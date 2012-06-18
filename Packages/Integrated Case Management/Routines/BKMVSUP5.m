BKMVSUP5 ;PRXM/HC/WOM - Continuation of BKMVSUP, HIV SUPPLEMENT; [ 1/19/2005 7:16 PM ] ; 10 Jun 2005  12:31 PM
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
 Q
FLOW(DFN) ; EP - Generate Flow Sheet
 I LNCNT>(MAXCT-4) D NEWPG^BKMVSUP
 D UPD^BKMVSUP S LINE=" HIV FLOW SHEET" D UPD^BKMVSUP
 N FLTST,FLDT,FLIEN,FLTYP,CNT,LAST,STOP,MAX,MEDNM,MEDDT,DISDT
 K BKMT("FLOW"),BKMT("PRT")
 F FLTST="VL","CD4ABS" S CNT=0 D
 . S FLDT=""
 . F  S FLDT=$O(BKMT(FLTST,FLDT),-1) Q:FLDT=""  D  Q:CNT=6
 .. S FLIEN=""
 .. F  S FLIEN=$O(BKMT(FLTST,FLDT,FLIEN)) Q:FLIEN=""  D  Q:CNT=6
 ... S FLTYP=""
 ... F  S FLTYP=$O(BKMT(FLTST,FLDT,FLIEN,FLTYP)) Q:FLTYP=""  D  Q:CNT=6
 .... I $P(BKMT(FLTST,FLDT,FLIEN,FLTYP),U)]"" D  ;Only include if results are present
 ..... S BKMT("FLOW",FLDT,FLTST,FLIEN,FLTYP)=BKMT(FLTST,FLDT,FLIEN,FLTYP),CNT=CNT+1
 K BKMT("VL"),BKMT("CD4ABS")
 Q:'$D(BKMT("FLOW"))
 ;
 S STOP="" K BKMT("FLOWD")
 ; Only print 6 dates; combine if dates are w/in 7 days
 S LAST=$O(BKMT("FLOW",""),-1),FLDT=LAST,CNT=1,FLDT(LAST)="",BKMT("FLOWD",LAST,LAST)=""
 F  S FLDT=$O(BKMT("FLOW",FLDT),-1) Q:FLDT=""  D  Q:STOP
 . I $$FMDIFF^XLFDT(LAST,FLDT,1)<8 D  Q
 .. M BKMT("FLOW",LAST)=BKMT("FLOW",FLDT) K BKMT("FLOW",FLDT) S BKMT("FLOWD",LAST,FLDT)=""
 . I CNT=6 S STOP=1 Q
 . S LAST=FLDT,FLDT(LAST)="",CNT=CNT+1,BKMT("FLOWD",LAST,LAST)=""
 ;
 ; Reorder array for printing
 S FLDT="",MAX("VL")="",MAX("CD4ABS")=""
 F  S FLDT=$O(BKMT("FLOW",FLDT)) Q:FLDT=""  D
 . S FLTST="" F  S FLTST=$O(BKMT("FLOW",FLDT,FLTST)) Q:FLTST=""  D
 .. S FLIEN=""  F  S FLIEN=$O(BKMT("FLOW",FLDT,FLTST,FLIEN)) Q:FLIEN=""  D
 ... S FLTYP="" F  S FLTYP=$O(BKMT("FLOW",FLDT,FLTST,FLIEN,FLTYP)) Q:FLTYP=""  D
 .... S CNT=$G(BKMT("PRT",FLTST,FLDT))+1,BKMT("PRT",FLTST,FLDT)=CNT
 .... I CNT>MAX(FLTST) S MAX(FLTST)=CNT
 .... S BKMT("PRT",FLTST,FLDT,CNT)=BKMT("FLOW",FLDT,FLTST,FLIEN,FLTYP)
 ;
 ; Print results
 N MEDDYS,FIRST,MEDDSPDT,MEDISSDT
 K BKMT("FLOW")
 S FLDT=""
 F CNT=0:1:5 S FLDT=$O(FLDT(FLDT)) Q:FLDT=""  S FLDT(FLDT)=18+(CNT*10)
 D PRTDT ; Print dates
 S LINE=" Viral Load"
 D PRTFL("VL",MAX("VL"))
 D UPD^BKMVSUP S LINE=" CD4 Count"
 D PRTFL("CD4ABS",MAX("CD4ABS"))
 ; Get HAART Medication
 ; Loop through currently active medications
 K BKMT("MED")
 S MEDDT=""
 F  S MEDDT=$O(^TMP("BKMSUPP",$J,"HAART",MEDDT)) Q:MEDDT=""  D
 . S MEDIEN=""
 . F  S MEDIEN=$O(^TMP("BKMSUPP",$J,"HAART",MEDDT,MEDIEN)) Q:MEDIEN=""  D
 .. S MEDDYS=$$GET1^DIQ(9000010.14,MEDIEN,.07,"I") ; Get days prescribed
 .. I MEDDYS="" S MEDDYS=30 ; Using Health Summary logic
 .. Q:'MEDDYS
 .. S MEDDSPDT=$$RX(MEDIEN,MEDDT,101) ; Get last dispensed date
 .. S MEDISSDT=$$RX(MEDIEN,MEDDT,1) ; Get issue date
 .. S MEDNM=$$GET1^DIQ(9000010.14,MEDIEN,.01,"E") ; Get med name
 .. I MEDNM="" S MEDNM="Unknown"
 .. S FLDT=""
 .. F  S FLDT=$O(FLDT(FLDT)) Q:FLDT=""  D
 ... ; If Last Dispensed Date (or Visit Date if no PCC LINK) + DAYS is earlier than the lab date, skip this med
 ... I $$FMADD^XLFDT(MEDDSPDT,MEDDYS)<(FLDT\1) Q
 ... ; Medication must be active prior to the first date of the test
 ... S FIRST=$O(BKMT("FLOWD",FLDT,"")) Q:'FIRST
 ... I MEDISSDT'<(FIRST\1) Q
 ... S BKMT("MED",MEDNM,FLDT)=""
 ;
 ; Loop through inactive medications
 S DISDT=""
 F  S DISDT=$O(BKMT("HAARTD",DISDT)) Q:DISDT=""  D
 . S MEDDT=""
 . F  S MEDDT=$O(BKMT("HAARTD",DISDT,MEDDT)) Q:MEDDT=""  D
 .. S MEDIEN=""
 .. F  S MEDIEN=$O(BKMT("HAARTD",DISDT,MEDDT,MEDIEN)) Q:MEDIEN=""  D
 ... S MEDDYS=$$GET1^DIQ(9000010.14,MEDIEN,.07,"I") ; Get days prescribed
 ... I MEDDYS="" S MEDDYS=30 ; Using Health Summary logic
 ... Q:'MEDDYS
 ... S MEDDSPDT=$$RX(MEDIEN,MEDDT,101) ; Get last dispensed date
 ... S MEDISSDT=$$RX(MEDIEN,MEDDT,1) ; Get issue date
 ... S MEDNM=$$GET1^DIQ(9000010.14,MEDIEN,.01,"E") ; Get med name
 ... I MEDNM="" S MEDNM="Unknown"
 ... S FLDT=""
 ... F  S FLDT=$O(FLDT(FLDT)) Q:FLDT=""  D  ;I DISDT\1>(FLDT\1) D; IHS removed discontinued date check 04/27/06
 .... ; If Last Dispensed Date (or Visit Date if no PCC LINK) + DAYS is earlier than the lab date, skip this med
 .... S FIRST=$O(BKMT("FLOWD",FLDT,"")) Q:'FIRST
 .... I $$FMADD^XLFDT(MEDDSPDT,MEDDYS)<(FIRST\1) Q
 .... ; Medication must be active prior to the first date of the test
 .... I MEDISSDT\1'<(FIRST\1) Q
 .... S BKMT("MED",MEDNM,FLDT)=""
 D UPD^BKMVSUP
 ;
 ; Print medications for listed dates
 S MEDNM=""
 F  S MEDNM=$O(BKMT("MED",MEDNM)) Q:MEDNM=""  D
 . D UPD^BKMVSUP S LINE=" "_$E(MEDNM,1,16)
 . S MEDDT="" F  S MEDDT=$O(BKMT("MED",MEDNM,MEDDT)) Q:MEDDT=""  D
 .. S LINE=$$LINE^BKMVSUP(LINE,"   x",FLDT(MEDDT))
 . I LNCNT>MAXCT D NEWPG^BKMVSUP
 I LINE'="" D UPD^BKMVSUP
 Q
RX(MEDIEN,DFLTDT,FLD) ; Get date from prescription file if PCC LINK exists
 ; FLD = field for desired date
 I '$D(^PSRX("APCC",MEDIEN)) Q DFLTDT\1
 N PSRXIEN,PSRXDT
 S PSRXIEN=$O(^PSRX("APCC",MEDIEN,""))
 I PSRXIEN S PSRXDT=$$GET1^DIQ(52,PSRXIEN,FLD,"I") I PSRXDT S DFLTDT=PSRXDT
 Q DFLTDT\1
PRTDT ; Print dates for subheader
 N FIRST
 S FLDT="" F  S FLDT=$O(FLDT(FLDT)) Q:FLDT=""  D
 . S FIRST=$O(BKMT("FLOWD",FLDT,"")) I 'FIRST S FIRST=FLDT
 . S LINE=$$LINE^BKMVSUP(LINE,$P($$FMTE^XLFDT(FIRST,"2Z"),"@"),FLDT(FLDT))
 D UPD^BKMVSUP,BLANK^BKMVSUP(1)
 Q
PRTFL(TYPE,MAX) ;
 N LCNT,RESULT
 F LCNT=1:1:MAX D  D UPD^BKMVSUP
 .S FLDT=""
 .F  S FLDT=$O(FLDT(FLDT)) Q:FLDT=""  D
 .. S RESULT=$E($G(BKMT("PRT",TYPE,FLDT,LCNT)),1,8)
 .. S LINE=$$LINE^BKMVSUP(LINE,$E("       ",1,8-$L(RESULT)\2),FLDT(FLDT))_RESULT
 .. I LNCNT>MAXCT D NEWPG^BKMVSUP
 Q
REM(DFN) ; EP - List Reminders
 ; Remove message since this will be handled during processing not printing
 ; I IOST["C-" W !!?1,"Calculating HIV-RELATED REMINDERS - Please wait."
 D UPD^BKMVSUP,BLANK^BKMVSUP(1) S LINE=" HIV-RELATED REMINDERS: " D UPD^BKMVSUP
 N PRT,A1,B1,DUE,OVERDUE,REMTXT,DXDT
 K LIST D REMIND^BKMVF3(DFN,NOW,.LIST)
 I LNCNT>(MAXCT-1) D NEWPG^BKMVSUP
 I $O(LIST("")) D
 . D UPD^BKMVSUP S LINE=" Reminder",LINE=$$LINE^BKMVSUP(LINE,"Last",26)
 . S LINE=$$LINE^BKMVSUP(LINE,"Due",41) D UPD^BKMVSUP
 . S A1="" F  S A1=$O(LIST(A1)) Q:A1=""  D
 .. S B1="" F  S B1=$O(LIST(A1,B1)) Q:B1=""  D
 ... S DUE=$G(LIST(A1,B1,"DUE")) ;S:DUE="" DUE="Unknown" this is not on the Clinical Rem, they must be the same
 ... I LNCNT>MAXCT D NEWPG^BKMVSUP
 ... I 'DUE,'$G(LIST(A1,B1,"LAST")) Q
 ... S REMTXT=$G(LIST(A1,B1,0))
 ... S OVERDUE=0
 ... I DUE'="" S:DUE<DT OVERDUE=1 S DUE=$P($$FMTE^XLFDT(+DUE,"5Z"),"@",1)
 ... I OVERDUE=0,$G(LIST(A1,B1,"LAST"))="" S DUE="("_DUE_")"
 ... I OVERDUE=1 S DUE=$S($G(LIST(A1,B1,"LAST"))="":"("_DUE_")",1:DUE)
 ... ;I OVERDUE=1 S DUE="May Be Due Now (Was due "_DUE_")"
 ... S LINE=" "_$E(REMTXT,1,25)
 ... S LINE=$$LINE^BKMVSUP(LINE,$P($$FMTE^XLFDT($G(LIST(A1,B1,"LAST")),"5Z"),"@"),26)
 ... I $G(LIST(A1,B1,"LASTTXT"))]"" S LINE=LINE_LIST(A1,B1,"LASTTXT")
 ... S LINE=$$LINE^BKMVSUP(LINE,DUE,42) D UPD^BKMVSUP
 ... I REMTXT["Viral Load"!(REMTXT["Trichomoniasis Test")!(REMTXT["Tetanus IZ")!(REMTXT["Dental Exam") D UPD^BKMVSUP
 ... I LNCNT>MAXCT D NEWPG^BKMVSUP
 ;
 ; Check for a history of Tuberculosis diagnosis (DX.14) or history of positive PPD test (T.21)
 ; Preferentially list TB dx over positive PPD
 I '$D(LIST("REM.T.05")) D
 . ; *** Need to new variables ***
 . ; *** Do we need to examine BKM PPD TAX, BKM PPD CPTS or BKM PPD CVX CODES since they are not used for a positive PPD determination?
 . ; Check for history of Tuberculosis diagnosis
 . ; DX.14
 . S GLOBAL="BKMT(""PPDDX"",VSTDT,TEST,""LAB"")"
 . S GLOBAL1="BKMT(""PPDTEST"",VSTDT,TEST,""LAB"")" ; *** Is this needed? ***
 . S GLOBAL2="BKMT(""PPDPOS"",VSTDT,TEST,""LAB"")"
 . D ICDTAX^BKMIXX1(DFN,"DM AUDIT PROBLEM TB DXS","","",GLOBAL)
 . S DXDT=$O(BKMT("PPDDX",""),-1)
 . I DXDT S LINE=" PPD Diagnosis ",LINE=$$LINE^BKMVSUP(LINE,$P($$FMTE^XLFDT(DXDT,"5Z"),"@"),26) D UPD^BKMVSUP Q
 . ;
 . ; Check for history of positive PPD
 . ; T.21
 . S GLOBAL="BKMT(""PPDDX"",VSTDT,TEST,""LAB"")"
 . D LABTAX^BKMIXX(DFN,"BKM PPD TAX","","",GLOBAL1) ;***
 . D LOINC^BKMIXX(DFN,"BKM PPD LOINC CODES","","",GLOBAL2)
 . S GLOBAL="BKMT(""PPD"",VSTDT,TEST,""CPT"")"
 . D CPTTAX^BKMIXX(DFN,"BKM PPD CPTS","","",GLOBAL1)
 . S GLOBAL="BKMT(""PPD"",VSTDT,TEST,""CVX"")"
 . D CVXTAX^BKMIXX1(DFN,"BKM PPD CVX CODES","","",GLOBAL1)
 . S GLOBAL="BKMT(""PPD"",VSTDT,TEST,""ICD"")"
 . D ICDTAX^BKMIXX1(DFN,"BKM PPD ICDS","","",GLOBAL1)
 . S GLOBAL="BKMT(""PPD"",VSTDT,TEST,""SKIN"")"
 . D SKNTAX^BKMIXX1(DFN,"21","","",GLOBAL2)
 . M BKMT("PPDTEST")=BKMT("PPDPOS")
 . S VSTDT=$O(BKMT("PPDPOS",""),-1)
 . S POS=""
 . I VSTDT D
 .. S TEST=$O(BKMT("PPDPOS",VSTDT,""),-1) Q:'TEST
 .. S RESULT=BKMT("PPDPOS",VSTDT,TEST,"LAB"),POS=$$POS^BKMQQCR7(RESULT)
 . I POS D
 .. S LINE=" PPD ",LINE=$$LINE^BKMVSUP(LINE,$P($$FMTE^XLFDT(VSTDT,"5Z"),"@"),26)
 .. S LINE=$$LINE^BKMVSUP(LINE,"Positive Test Result",42)
 .. D UPD^BKMVSUP
 ;S LINE=$$LINE^BKMVSUP(LINE,$P($$FMTE^XLFDT($G(LIST(A1,B1,"LAST")),"5Z"),"@"),26) . ; 
 K LIST
 I LNCNT>MAXCT D NEWPG^BKMVSUP
 D UPD^BKMVSUP,BLANK^BKMVSUP(1)
 Q
ED(DFN) ; EP - Retrieve Education data.
 N BKMCKDT
 S BKMCKDT=$$FMADD^XLFDT(DT,-360)
 D UPD^BKMVSUP,BLANK^BKMVSUP(1)
 S LINE=" Last HIV-related education given (past 12 months): " D UPD^BKMVSUP
 I LNCNT>MAXCT D NEWPG^BKMVSUP
 K BKMT("ED")
 S GLOBAL="BKMT(""ED"",VSTDT,TEST,""ICD"")"
 D ICDTAX^BKMIXX1(DFN,"BKM FAMILY PLANNING POV","",BKMCKDT,GLOBAL)
 D ICDTAX^BKMIXX1(DFN,"BKMV HIV ED DXS","",BKMCKDT,GLOBAL)
 D ICDTAX^BKMIXX1(DFN,"BKMV STD ED DXS","",BKMCKDT,GLOBAL)
 S GLOBAL="BKMT(""ED"",VSTDT,TEST,""ED"")"
 ; Patient Education Codes can use two different formats
 D PTEDTAX^BKMIXX(DFN,"FP-","",BKMCKDT,GLOBAL) ; Family Planning
 D PTEDTAX^BKMIXX(DFN,"HIV-,-HIV,*BGP HIV/AIDS DXS","",BKMCKDT,GLOBAL) ; HIV Counseling/Education
 D PTEDTAX^BKMIXX1(DFN,"BKM STD ED CODES","",BKMCKDT,GLOBAL)
 D PTEDTAX^BKMIXX1(DFN,"BKM SAFE SEX ED CODES","",BKMCKDT,GLOBAL)
 I '$D(BKMT("ED")) D EDREF Q  ; Get refusals if no data found
 I LNCNT>(MAXCT-2) D NEWPG^BKMVSUP
 S LINE=$$LINE^BKMVSUP("   [Topic]","[Date]",35)
 S LINE=$$LINE^BKMVSUP(LINE,"[Provider initials]",47)
 N EDDT,EDTST,DISPDT,PROV
 S EDDT="" F  S EDDT=$O(BKMT("ED",EDDT),-1) Q:EDDT=""  D
 . S EDTST="" F  S EDTST=$O(BKMT("ED",EDDT,EDTST)) Q:EDTST=""  D
 .. S DISPDT=$P($$FMTE^XLFDT(EDDT,"5Z"),"@")
 .. I $D(BKMT("ED",EDDT,EDTST,"ICD")) D
 ... D UPD^BKMVSUP S LINE="   "_$E($$GET1^DIQ(9000010.07,EDTST,.01,"E"),1,30)
 ... S LINE=$$LINE^BKMVSUP(LINE,DISPDT,35)
 ... S LINE=$$LINE^BKMVSUP(LINE,$E($$GET1^DIQ(9000010.07,EDTST,.04,"E"),1,30),47)
 ... I LNCNT>MAXCT D NEWPG^BKMVSUP
 .. I $D(BKMT("ED",EDDT,EDTST,"ED")) D
 ... D UPD^BKMVSUP S LINE=" "_$E($$GET1^DIQ(9000010.16,EDTST,.01,"E"),1,30)
 ... S LINE=$$LINE^BKMVSUP(LINE,DISPDT,35)
 ... S PROV=$$GET1^DIQ(9000010.16,EDTST,.05,"I") Q:PROV=""
 ... S LINE=$$LINE^BKMVSUP(LINE,$$GET1^DIQ(200,PROV,1,"E"),47)
 ... I LNCNT>MAXCT D NEWPG^BKMVSUP
 K BKMT("ED")
 I LINE'="" D UPD^BKMVSUP
 Q
EDREF ; Check refusals for education
 S GLOBAL="BKMT(""ED"",VSTDT,TEST,""ED"")"
 ; Patient Education Codes can use two different formats
 D REFUSAL^BKMIXX2(DFN,9999999.09,"FP-","","",GLOBAL) ; Family Planning
 D REFUSAL^BKMIXX2(DFN,9999999.09,"HIV-,-HIV,*BGP HIV/AIDS DXS","","",GLOBAL) ; HIV Counseling/Education
 D REFUSAL^BKMIXX2(DFN,9999999.09,"BKM STD ED CODES","","",GLOBAL)
 D REFUSAL^BKMIXX2(DFN,9999999.09,"BKM SAFE SEX ED CODES","","",GLOBAL)
 D LTAXPRT^BKMVSUP1("ED",1,1,1)
 K BKMT("ED")
 I LINE'="" D UPD^BKMVSUP
 Q
XIT ; QUIT POINT
 Q
