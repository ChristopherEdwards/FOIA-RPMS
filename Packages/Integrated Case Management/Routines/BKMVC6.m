BKMVC6 ;PRXM/HC/JGH - Opp. Inf. and AIDS Defining Illnesses; 24-JAN-2005
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
 QUIT
EN ;
 NEW MEDS,HIVIEN
 S HIVIEN=$$HIVIEN^BKMIXX3()
 I HIVIEN="" W !,"There is no HMS register defined." H 2 Q
 I '$D(^BKM(90450,HIVIEN,11,"B",DUZ)) Q
 K ^TMP("BKMVC6",$J)
 D GETALL(DFN)
 D EN^VALM("BKMV RECORD OI")
 D CLEAN
 QUIT
INIT ; get information and set up screen
 NEW HTARGET,IIND,MED,TARGET,TEXT,MIND
 S VALMCNT=0,VALMAR="^TMP(""BKMVC6"","_$J_")",VALM0=""
 K ^TMP("BKMVC6",$J)
 S TEXT=$$PAD^BKMIXX4("Date",">"," ",12)_" "_$$PAD^BKMIXX4("Diagnosis",">"," ",15)_" "_$$PAD^BKMIXX4("ICD Description",">"," ",53)
 S VALMCNT=$G(VALMCNT)+1 D SET^VALM10(VALMCNT,TEXT)
 S HTARGET=""
 ; Changed loop to use new structure of ICD9S.
 F  S HTARGET=$O(ICD9S(HTARGET)) Q:HTARGET=""  D
 . S ETARGET=9999999-HTARGET,ETARGET=$$FMTE^XLFDT(ETARGET,1)
 . S IIND=""
 . F  S IIND=$O(ICD9S(HTARGET,IIND)) Q:IIND=""  D
 . . S NAR=$G(ICD9S(HTARGET,IIND))
 . . S IENS=$$IENS^DILF(IIND)
 . . I $T(ICDDX^ICDCODE)'="" S ICD9=$$ICD9^BKMUL3($P(IENS,","),9999999-HTARGET,2)
 . . I $T(ICDDX^ICDCODE)="" S ICD9=$$GET1^DIQ(80,IENS,.01,"E")
 . . I $T(ICDD^ICDCODE)'="" S DESC=$$ICDD^BKMUL3("ICD9",$P(IENS,","),9999999-HTARGET)
 . . I $T(ICDD^ICDCODE)="" S DESC=$$GET1^DIQ(80,IENS,10,"E")
 . . S TEXT=$$PAD^BKMIXX4(ETARGET,">"," ",12)_" "_$$PAD^BKMIXX4(ICD9,">"," ",15)_" "_$$PAD^BKMIXX4(DESC,">"," ",53)
 . . S VALMCNT=$G(VALMCNT)+1 D SET^VALM10(VALMCNT,TEXT)
 . . S TEXT=$$PAD^BKMIXX4("",">"," ",8)_$$PAD^BKMIXX4("Prov Comment: ",">"," ",14)_$$PAD^BKMIXX4(NAR,">"," ",58)
 . . S VALMCNT=$G(VALMCNT)+1 D SET^VALM10(VALMCNT,TEXT)
 QUIT
 ;
 ; This routine gathers all medications for a patient given their
 ; DFN in files 9000001 and 2. 
 ; HIVTAX must be defined and is equal to 1 for HIV medications or 0 for all medications.
 ; BEGDATE must be defined and is equal to the $H beginning date
 ; ENDDATE must be defined and is equal to the $H ending date
GETALL(DFN) ; EP - Gather patient information
 NEW IENDA0,IENDA,IENS,TARGET,HTARGET
 NEW ATAX,ATAX1
 K ICD9S
 S ATAX=$O(^ATXAX("B","BKMV AIDS DEF ILL DXS",""))   ; DX.1
 S ATAX1=$O(^ATXAX("B","BKMV HIV OPP INF DXS",""))   ; DX.8
 ; Modified code to return unique ICDs for a given date.
 S REVDATE=""
 F  S REVDATE=$O(^AUPNVPOV("AA",DFN,REVDATE)) Q:REVDATE=""  D
 . S VPOV=""
 . F  S VPOV=$O(^AUPNVPOV("AA",DFN,REVDATE,VPOV)) Q:VPOV=""  D
 . . S IENS=$$IENS^DILF(VPOV)
 . . S ICD9=$$GET1^DIQ(9000010.07,IENS,.01,"I")
 . . I ICD9="" Q
 . . I $$ICD^BKMIXX5(ICD9,ATAX,9)=0,$$ICD^BKMIXX5(ICD9,ATAX1,9)=0 Q
 . . S NAR=$$GET1^DIQ(9000010.07,IENS,.04,"E")
 . . S ICD9S(REVDATE,ICD9)=NAR
 S VPOV=""
 F  S VPOV=$O(^AUPNPROB("AC",DFN,VPOV)) Q:VPOV=""  D
 . S IENS=$$IENS^DILF(VPOV)
 . S POVDATE=$$PROB^BKMVUTL(IENS)
 . Q:POVDATE'?1.N
 . S REVDATE=9999999-POVDATE
 . S ICD9=$$GET1^DIQ(9000011,IENS,.01,"I")
 . I ICD9="" Q
 . I $$ICD^BKMIXX5(ICD9,ATAX,9)=0,$$ICD^BKMIXX5(ICD9,ATAX1,9)=0 Q
 . S NAR=$$GET1^DIQ(9000011,IENS,.05,"E")
 . S ICD9S(REVDATE,ICD9)=NAR
 . ;List date entered/last modified if different from date of onset
 . I POVDATE=$$GET1^DIQ(9000011,IENS,.13,"I") D
 ..  N OTHERDT
 ..  S OTHERDT=$$GET1^DIQ(9000011,IENS,.08,"I")
 ..  I OTHERDT="" S OTHERDT=$$GET1^DIQ(9000011,IENS,.03,"I")
 ..  Q:POVDATE=OTHERDT!(OTHERDT="")
 ..  S ICD9S(9999999-OTHERDT,ICD9)=NAR
 QUIT
PROMPT ;
 K BEGDATE,ENDDATE,HIVTAX
 S HIVTAX=1,ENDDATE=DT,BEGDATE=$$FMADD^XLFDT(ENDDATE,-365)
 S DIR(0)="S^1:HMS Related Meds;2:All Meds"
 S DIR("A")="Med Option"
 D ^DIR
 Q:Y?1."^"
 S HIVTAX=$S(Y=1:1,1:0)
 ;
 S DIR(0)="Y"
 S DIR("A")="Change Date Range"
 D ^DIR
 Q:Y?1."^"
 I Y="1",'$$DATEPRMP Q
 ; S BEGDATE=+$$FMTH^XLFDT(BEGDATE),ENDDATE=+$$FMTH^XLFDT(ENDDATE)
 D EN^BKMVC3
 QUIT
DATEPRMP() ;
 S DIR(0)="D"
 S DIR("A")="Beginning Date"
 D ^DIR
 Q:Y?1."^" 0
 S BEGDATE=Y
 S DIR(0)="D"
 S DIR("A")="Ending Date"
 D ^DIR
 S ENDDATE=Y
 Q:Y?1."^" 0
 QUIT 1
HDR ;
 N DA,IENS,SITE,RCRDHDR,BKMDOD
 S DA=$G(DUZ(2)),IENS=$$IENS^DILF(.DA),SITE=$$GET1^DIQ(4,IENS,.01,"E")
 S VALMHDR(1)=$$PAD^BKMIXX4("",">"," ",(80-($L(SITE)+2))\2)_"["_$G(SITE)_"]"
 S RCRDHDR=$$PAD^BKMIXX4(" Patient: ",">"," ",10)_$$PAD^BKMIXX4($$GET1^DIQ(2,DFN,".01","E"),">"," ",30)_$$PAD^BKMIXX4(" HRN: ",">"," ",6)_$$PAD^BKMIXX4($$HRN^BKMVA1(DFN),">"," ",9)
 S BKMDOD=$$GET1^DIQ(2,DFN,".351","I")
 I BKMDOD'="" S RCRDHDR=RCRDHDR_$$PAD^BKMIXX4(" DOD: ",">"," ",6)_$$PAD^BKMIXX4($$FMTE^XLFDT(BKMDOD,1),">"," ",15)
 S VALMHDR(2)=RCRDHDR
 S VALMHDR(3)=""
 S VALMHDR(4)="The following diagnoses related to Opportunistic Infections and AIDS Defining"
 S VALMHDR(5)="Illnesses have been identified in this patient's POVs or Problem List."
 QUIT
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !
 QUIT
EXIT ;
 K VALM0,VALMAR,VALMHDR,VALMCNT
 QUIT
EXPND ;
 QUIT
CLEAN ;
 K DA,DESC,DIR,ETARGET,ICD9S,ICD9,NAR,POVDATE,RCRDHDR,SITE,VPOV,Y,REVDATE
 K ^TMP("BKMVC6",$J)
 Q
