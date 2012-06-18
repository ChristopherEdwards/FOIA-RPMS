BKMVD21 ;PRXM/HC/JGH - V-File Exam Review History; 24-JAN-2005
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
EN ;ENTRY POINT -- ListMan template BKMV PCC EXAM REVIEW
 ; Called by Review History option for Exam
 ; Assumes existence of DFN,DUZ
 N HIVIEN
 S HIVIEN=$$HIVIEN^BKMIXX3()
 I HIVIEN="" W !,"There is no HMS register defined." H 2 Q
 I '$$VALID^BKMIXX3(DUZ) Q
 K ^TMP("BKMVD21",$J)
 D ^XBFMK
 D EN^VALM("BKMV PCC EXAM REVIEW")
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
 Q
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
 N TEXT,XAM,IENS,RXAMDT,PXAMDT,XAMDT,XAMIEN
 D ^XBFMK
 S VALMCNT=0,VALMAR="^TMP(""BKMVD21"","""_$J_""")",VALM0=""
 S XAM=""
 F  S XAM=$O(^AUPNVXAM("AA",DFN,XAM)) Q:XAM=""  D
 . S RXAMDT=""
 . F  S RXAMDT=$O(^AUPNVXAM("AA",DFN,XAM,RXAMDT)) Q:RXAMDT=""  D
 . . S XAMIEN=""
 . . F  S XAMIEN=$O(^AUPNVXAM("AA",DFN,XAM,RXAMDT,XAMIEN)) Q:XAMIEN=""  D
 . . . S DA=XAM,IENS=$$IENS^DILF(.DA)
 . . . S ^TMP("BKMVD21",$J,"SORTED",RXAMDT,XAMIEN)=""
 S (RXAMDT,PXAMDT)=""
 F  S RXAMDT=$O(^TMP("BKMVD21",$J,"SORTED",RXAMDT)) Q:RXAMDT=""  D
 . S XAMIEN=""
 . F  S XAMIEN=$O(^TMP("BKMVD21",$J,"SORTED",RXAMDT,XAMIEN)) Q:XAMIEN=""  D
 . . S XAMDT=9999999-RXAMDT
 . . S DA=XAMIEN
 . . S IENS=$$IENS^DILF(.DA)
 . . S TEXT=""
 . . S TEXT=$$SETFLD^VALM1($S(XAMDT'=PXAMDT:$$FMTE^XLFDT(XAMDT\1,"5Z"),1:""),TEXT,"Visit")
 . . S TEXT=$$SETFLD^VALM1($$GET1^DIQ(9000010.13,IENS,".01","E"),TEXT,"Exam")
 . . S TEXT=$$SETFLD^VALM1($$GET1^DIQ(9000010.13,IENS,".04","E"),TEXT,"Result")
 . . S VALMCNT=$G(VALMCNT)+1 D SET^VALM10(VALMCNT,TEXT)
 . . S PXAMDT=XAMDT
 D ^XBFMK
 Q
 ;
HELP ; -- help code
 N X
 S X="?" D DISP^XQORM1 W !
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BKMVD21",$J)
 K VALM0,VALMAR,VALMCNT,VALMHDR
 Q
 ;
 ;
