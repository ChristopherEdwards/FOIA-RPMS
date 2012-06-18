BKMVD41 ;PRXM/HC/JGH - V-File Measurement Review History; 24-JAN-2005 ; 12 Apr 2005  6:17 PM
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
EN ;ENTRY POINT -- ListMan template BKMV PCC MSR REVIEW
 ; Called by Review History option for Measurement
 ; Assumes existence of DFN,DUZ
 N HIVIEN
 S HIVIEN=$$HIVIEN^BKMIXX3()
 I HIVIEN="" W !,"There is no HMS register defined." H 2 Q
 I '$$VALID^BKMIXX3(DUZ) Q
 K ^TMP("BKMVD41",$J)
 D ^XBFMK
 D EN^VALM("BKMV PCC MSR REVIEW")
 D ^XBFMK
 D EXIT
 Q
 ;
HDR ; -- header code
 ; Assumes existence of DUZ,RCRDHDR
 N DA,IENS,SITE,RCRDHDR,BKMDOD
 S DA=$G(DUZ(2)),IENS=$$IENS^DILF(.DA),SITE=$$GET1^DIQ(4,IENS,.01,"E")
 S VALMHDR(1)=$$PAD^BKMIXX4("",">"," ",(80-($L(SITE)+2))\2)_"["_$G(SITE)_"]"
 S RCRDHDR=$$PAD^BKMIXX4(" Patient: ",">"," ",10)_$$PAD^BKMIXX4($$GET1^DIQ(2,DFN,".01","E"),">"," ",30)_$$PAD^BKMIXX4(" HRN: ",">"," ",6)_$$PAD^BKMIXX4($$HRN^BKMVA1(DFN),">"," ",9)
 S BKMDOD=$$GET1^DIQ(2,DFN,".351","I")
 I BKMDOD'="" S RCRDHDR=RCRDHDR_$$PAD^BKMIXX4(" DOD: ",">"," ",6)_$$PAD^BKMIXX4($$FMTE^XLFDT(BKMDOD,"5Z"),">"," ",15)
 S VALMHDR(2)=RCRDHDR
 ;
INIT ; -- init variables and list array
 ; Assumes existence of DFN
 D GETALL(DFN)
 Q
 ;
GETALL(DFN) ; Build ListMan display array
 ; Input variables:
 ;  DFN - IEN for File 2
 ; Output variables:
 ;  VALMAR - Builds ListMan array
 ;  VALMCNT - List array count
 ;  VALM0
 N TEXT,MSR,IENS,MSRDT,BKMVDT,RMSRDT,PMSRDT,MSRIEN
 D ^XBFMK
 S VALMCNT=0,VALMAR="^TMP(""BKMVD41"","""_$J_""")",VALM0=""
 S MSR=0
 F  S MSR=$O(^AUPNVMSR("AA",DFN,MSR)) Q:MSR=""  D
 . S RMSRDT=""
 . F  S RMSRDT=$O(^AUPNVMSR("AA",DFN,MSR,RMSRDT)) Q:RMSRDT=""  D
 . . S MSRIEN=""
 . . F  S MSRIEN=$O(^AUPNVMSR("AA",DFN,MSR,RMSRDT,MSRIEN)) Q:MSRIEN=""  D
 . . . S ^TMP("BKMVD41",$J,"SORTED",RMSRDT,MSRIEN)=""
 S (RMSRDT,PMSRDT)=""
 F  S RMSRDT=$O(^TMP("BKMVD41",$J,"SORTED",RMSRDT)) Q:RMSRDT=""  D
 . S MSRIEN=""
 . F  S MSRIEN=$O(^TMP("BKMVD41",$J,"SORTED",RMSRDT,MSRIEN)) Q:MSRIEN=""  D
 . . S MSRDT=9999999-RMSRDT
 . . S DA=MSRIEN
 . . S IENS=$$IENS^DILF(.DA)
 . . S TEXT=""
 . . S TEXT=$$SETFLD^VALM1($S(MSRDT'=PMSRDT:$$FMTE^XLFDT(MSRDT\1,"5Z"),1:""),TEXT,"Visit")
 . . S TEXT=$$SETFLD^VALM1($$GET1^DIQ(9000010.01,IENS,".01","E"),TEXT,"Measurement")
 . . S TEXT=$$SETFLD^VALM1($$GET1^DIQ(9000010.01,IENS,".04","E"),TEXT,"Value")
 . . S VALMCNT=$G(VALMCNT)+1 D SET^VALM10(VALMCNT,TEXT)
 . . S PMSRDT=MSRDT
 D ^XBFMK
 Q
HELP ; -- help code
 N X
 S X="?" D DISP^XQORM1 W !
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BKMVD41",$J)
 K VALM0,VALMAR,VALMCNT,VALMHDR
 Q
