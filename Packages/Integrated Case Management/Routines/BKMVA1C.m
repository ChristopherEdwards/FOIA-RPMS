BKMVA1C ;PRX/HC/DLS - HMS PATIENT REGISTER CONT; 
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 ; Prompts and functions related to BKMVA1
 Q
 ;
REGDC(DFN) ;EP - Called by LDREC^BKMVA1B
 ; Determine HMS Diagnosis Category for Register/Add or PAT/REC/ED, based on HIV, AIDS, and CD4 Absolute criteria.
 ; Note: This logic is based on the following statement...
 ; 1. Patient must have at least 2 diags not on the same day of HIV Positive (DX.6);
 ;       AND
 ; 2. If current CD4 Absolute (T.30) count is below 200'
 ;       OR
 ; 3. Patient has at least one diagnosis of Other AIDS Defining Illness (DX.1)
 ;    since the first HIV/AIDS diagnosis;
 ;       Then
 ;    Proposed Diagnosis is AIDS;
 ;       Else
 ;    Proposed Diagnosis is HIV.
 ;    Currently, this statement is being interpreted to mean:
 ;       IF (1 and (2 or 3)) --> AIDS
 ;       
 ; If this logic is changed, only REGDC should be affected. 
 ; HIV,AIDS,andCD4AB should be able to remain the same.
 ; 
 N FLG,RSLT,FLAG
 ; Default is HIV
 S RSLT="",DIAGCAT="",HAIDSDT="",IAIDSDT=""
 ; Do HIV and set FLG("H") to result.
 S FLAG("H")=$$HIV(DFN)
 ; If not HIV, you don't need to go any further. Quit
 I 'FLAG("H") Q
 ; Do AIDS and set FLG("A") to result.
 S FLAG("A")=$$AIDS(DFN)
 ; If not AIDS, check for CD4 Absolute
 I 'FLAG("A") S FLAG("C")=$$CD4AB(DFN)
 ; If HIV and (AIDS or CD4 Absolute) set the final result to "A" (for AIDS).
 I FLAG("H") S RSLT="H"
 I FLAG("A")!$G(FLAG("C")) S RSLT="A"
 K ^TMP("BKMAIDS",$J),^TMP("BKMHIV",$J),^TMP("BKMCD4",$J),^TMP("BKMTST",$J),^TMP("BKMCD4AB",$J),^TMP("BKMHIVP",$J),^TMP("BKMCD4P",$J)
 S DIAGCAT=RSLT
 Q
 ;
HIV(DFN) ; (DX.6) See if patient has 2 HIV diagnoses on differing days.  
 ;
 N HIDX,HIEN,HIVDT,VISIT,CHK,FLG
 S HIDX="",FLG=0
 F  S HIDX=$O(^TMP("BKMHIV",$J,HIDX)) Q:HIDX=""  D
 . ; First check the POV's
 . S HIEN=""
 . F  S HIEN=$O(^AUPNVPOV("B",HIDX,HIEN)) Q:(HIEN="")!(FLG)  D
 .. I $P(^AUPNVPOV(HIEN,0),U,2)=DFN D
 ... S VISIT=$$GET1^DIQ(9000010.07,HIEN,.03,"I")
 ... I VISIT D
 .... S HIVDT=$P($$GET1^DIQ(9000010,VISIT,.01,"I"),".",1)
 .... I $D(^TMP("BKMHIVP",$J,DFN,HIVDT)) Q
 .... S ^TMP("BKMHIVP",$J,DFN,HIVDT)=""
 .... S ^TMP("BKMHIVP",$J,DFN)=$G(^TMP("BKMHIVP",$J,DFN))+1
 .... ;I $O(^TMP("BKMHIVP",$J,DFN,""))=$O(^TMP("BKMHIVP",$J,DFN,""),-1) S FLG=1
 . ; Now check the Problem List.
 . S HIEN=""
 . F  S HIEN=$O(^AUPNPROB("B",HIDX,HIEN)) Q:(HIEN="")!(FLG)  D
 .. I $P(^AUPNPROB(HIEN,0),U,2)=DFN D
 ... S HIVDT=$P($$PROB^BKMVUTL(HIEN),".")
 ... I $D(^TMP("BKMHIVP",$J,DFN,HIVDT)) Q
 ... S ^TMP("BKMHIVP",$J,DFN)=$G(^TMP("BKMHIVP",$J,DFN))+1
 ... ;I $O(^TMP("BKMHIVP",$J,DFN,""))=$O(^TMP("BKMHIVP",$J,DFN,""),-1) S FLG=1
 I $G(^TMP("BKMHIVP",$J,DFN))>1 S FLG=1
 Q FLG
 ;
AIDS(DFN) ;  (DX.1) See if patient has at least one AIDS Defining Illness since first HIV/AIDS diagnosis. If so, set FLG=1
 ;
 N AIDX,AIEN,VISIT,FLG
 ; Get Initial HIV/AIDS date from ^TMP("BKMHIVP"). If null, quit.
 S HAIDSDT=$O(^TMP("BKMHIVP",$J,DFN,""))
 S FLG=0,AIDX=""
 F   S AIDX=$O(^TMP("BKMAIDS",$J,AIDX)) Q:(AIDX="")!(FLG)  D
 . S AIEN=""
 . F  S AIEN=$O(^AUPNVPOV("B",AIDX,AIEN)) Q:(AIEN="")!(FLG)  D
 .. I $P(^AUPNVPOV(AIEN,0),U,2)=DFN D
 ... S VISIT=$$GET1^DIQ(9000010.07,AIEN,.03,"I") Q:VISIT=""
 ... S IAIDSDT=$P($$GET1^DIQ(9000010,VISIT,.01,"I"),".")
 ... ; If AIDS Defining Illness date is after Initial HIV/AIDS Diagnosis Date, set FLG=1.
 ... I IAIDSDT>HAIDSDT S FLG=1
 Q FLG
 ;
CD4AB(DFN) ;  (T.30) Accumulate all CD4 Absolute result and see if the most recent CD4 Absolute result is less than 200 (and not null). If so, set FLG=1.
 ;
 NEW LAB,LIEN,RESULT,RDATE,VISDTM,LSTTST,FLG
 S LAB="",FLG=0
 F  S LAB=$O(^TMP("BKMCD4AB",$J,LAB)) Q:LAB=""  D
 . S LIEN=""
 . F  S LIEN=$O(^AUPNVLAB("B",LAB,LIEN),-1) Q:(LIEN="")  D
 .. I $P(^AUPNVLAB(LIEN,0),U,2)=DFN D
 ... S RESULT=$$GET1^DIQ(9000010.09,LIEN,.04,"E")
 ... S RDATE=$$GET1^DIQ(9000010.09,LIEN,1212,"I")
 ... I 'RDATE S VISIT=$$GET1^DIQ(9000010.09,LIEN,.03,"I") Q:VISIT=""  D
 .... S VISDTM=$$GET1^DIQ(9000010,VISIT,.01,"I")
 ... I RESULT'="" D
 .... I RDATE S ^TMP("BKMCD4P",$J,RDATE)=RESULT
 .... I 'RDATE,VISDTM S ^TMP("BKMCD4P",$J,VISDTM)=RESULT
 S LSTTST=$O(^TMP("BKMCD4P",$J,""),-1)
 I LSTTST'="",^TMP("BKMCD4P",$J,LSTTST)<200 S FLG=1
 Q FLG
 ;
XIT K DIAGCAT,HAIDSDT,IAIDSDT
 Q
 ;
OPT() ;EP - Called by REPORTS^BKMVA1
 ;Select reports to print
 N DIR,X,Y,DTOUT,DUOUT,BKMCHK
 ;
OPT1 ;
 S BKMCHK=0
 K DIR
 S DIR(0)="FO"
 S DIR("A")="Select Patient Report"
 S DIR("A",1)=" "
 S DIR("A",2)="     Select one of the following:"
 S DIR("A",3)=" "
 S DIR("A",4)="          DO         Due/OverDue"
 S DIR("A",5)="          QC         Quality of Care Audit Report"
 S DIR("A",6)="          SUPP       HMS Supplement"
 S DIR("A",7)="          HS         Health Summary"
 S DIR("A",8)="          BOTH       Both Health Summary and Supplement"
 S DIR("A",9)="          SSR        State Surveillance Report"
 S DIR("A",10)=" "
 S DIR("?")=" "
 S DIR("?",1)="  Enter DO to select the Due/OverDue Report"
 S DIR("?",2)="  Enter QC to select the Quality of Care Audit Report"
 S DIR("?",3)="  Enter SUPP to select the HMS Supplement"
 S DIR("?",4)="  Enter HS to select the Health Summary"
 S DIR("?",5)="  Enter BOTH to select both the Health Summary and the HMS Supplement"
 S DIR("?",6)="  Enter SSR to select the State Surveillance Report"
 S DIR("?",7)=" "
 S DIR("?",8)="  When BOTH is selected the HMS Supplement will display after the"
 S DIR("?",9)="  Health Summary has completed."
 D ^DIR K DIR
 I $D(DTOUT)!$D(DUOUT)!(Y="") Q ""
 S Y=$$UP^XLFSTR(Y)
 ; Special case where user enters 'H' or 'h' redisplay as ambiguous
 I Y="H" D  I Y="" G OPT1
 .S DIR(0)="SO^1:HMS Supplement;2:Health Summary"
 .K DIR("A")
 .S DIR("A")="Select the report option"
 .K DIR("B"),DIR("?")
 .S DIR("?")=" "
 .S DIR("?",1)="  Enter 1 to select the HMS Supplement"
 .S DIR("?",2)="  Enter 2 to select the Health Summary"
 .D ^DIR K DIR
 .I $D(DUOUT)!$D(DTOUT)!(Y="") S Y="" Q
 .S Y=$S(Y=1:"SUPP",1:"HS"),BKMCHK=1
 .;
 ; Special case where user enters 'S' or 's' redisplay as ambiguous
 I Y="S" D  I Y="" G OPT1
 .S DIR(0)="SO^1:HMS Supplement;2:State Surveillance Report"
 .K DIR("A")
 .S DIR("A")="Select the report option"
 .K DIR("B"),DIR("?")
 .S DIR("?")=" "
 .S DIR("?",1)="  Enter 1 to select the HMS Supplement"
 .S DIR("?",2)="  Enter 2 to select the State Surveillance Report"
 .D ^DIR K DIR
 .I $D(DUOUT)!$D(DTOUT)!(Y="") S Y="" Q
 .S Y=$S(Y=1:"SUPP",1:"SSR"),BKMCHK=1
 .;
 I '$F("^DO^QC^SUPP^HS^BOTH^SSR^",U_Y_U) D
 .I $L(Y)<4,$E("DO",1,$L(Y))=Y S Y="DO" Q
 .I $L(Y)<4,$E("QC",1,$L(Y))=Y S Y="QC" Q
 .I $L(Y)<4,$E("SUPP",1,$L(Y))=Y S Y="SUPP" Q
 .I $L(Y)<4,$E("HS",1,$L(Y))=Y S Y="HS" Q
 .I $L(Y)<4,$E("BOTH",1,$L(Y))=Y S Y="BOTH" Q
 .I $L(Y)<4,$E("SSR",1,$L(Y))=Y S Y="SSR" Q
 .I $L(Y)>0,$E("DUE/OVERDUE",1,$L(Y))=Y S Y="DO" Q
 .I $L(Y)>0,$E("QUALITY OF CARE AUDIT REPORT",1,$L(Y))=Y S Y="QC" Q
 .I $L(Y)>0,$E("HMS SUPPLEMENT",1,$L(Y))=Y S Y="SUPP" Q
 .I $L(Y)>0,$E("HEALTH SUMMARY",1,$L(Y))=Y S Y="HS" Q
 .I $L(Y)>0,$E("BOTH HEALTH SUMMARY AND SUPPLEMENT",1,$L(Y))=Y S Y="BOTH" Q
 .I $L(Y)>0,$E("STATE SURVEILLANCE REPORT",1,$L(Y))=Y S Y="SSR" Q
 I '$F("^DO^QC^SUPP^HS^BOTH^SSR^",U_Y_U) W !!?2,"Please enter a code or description from the list.",!! G OPT1
 I 'BKMCHK W " ",$S(Y="DO":"Due/Overdue",Y="QC":"Quality of Care Audit Report",Y="SUPP":"HMS Supplement",Y="HS":"Health Summary",Y="BOTH":"Both Health Summary and Supplement",1:"State Surveillance Report")
 Q Y
