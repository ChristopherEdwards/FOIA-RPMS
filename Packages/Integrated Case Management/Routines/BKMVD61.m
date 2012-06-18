BKMVD61 ;PRXM/HC/JGH - V-File Radiology Review History; 24-JAN-2005 ; 12 Apr 2005  6:56 PM
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
EN ;ENTRY POINT -- ListMan template BKMV PCC RADIOLOGY REVIEW
 ; Called by Review History option for Radiology
 ; Assumes existence of DFN,DUZ
 N HIVIEN
 S HIVIEN=$$HIVIEN^BKMIXX3()
 I HIVIEN="" W !,"There is no HMS register defined." H 2 Q
 I '$$VALID^BKMIXX3(DUZ) Q
 K ^TMP("BKMVD61",$J)
 D ^XBFMK
 D EN^VALM("BKMV PCC RADIOLOGY REVIEW")
 D ^XBFMK
 D EXIT
 Q
 ;
HDR ; -- header code
 ; Assumes existence of DUZ
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
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BKMVD61",$J)
 K VALM0,VALMAR,VALMCNT,VALMHDR
 Q
 ;
GETALL(DFN) ; Build ListMan display array
 ; Input variables:
 ;  DFN - IEN for File 2
 ; Output variables:
 ;  VALMAR - Builds ListMan array
 ;  VALMCNT - List array count
 ;  VALM0
 N DA0,DA1,TEXT,RADIO,IENS,RADCODE,BKMVDT,RADDT,BKMPVDT,RADDT2
 D ^XBFMK
 S VALMCNT=0,VALMAR="^TMP(""BKMVD61"","""_$J_""")",VALM0=""
 ;
 S RAD=0
 F  S RAD=$O(^AUPNVRAD("AA",DFN,RAD)) Q:RAD=""  D
 .S RADDT=0
 .F  S RADDT=$O(^AUPNVRAD("AA",DFN,RAD,RADDT)) Q:RADDT=""  D
 ..S RADDT2=9999999-RADDT
 ..S RADIEN=0
 ..F  S RADIEN=$O(^AUPNVRAD("AA",DFN,RAD,RADDT,RADIEN)) Q:RADIEN=""  D
 ...S ^TMP("BKMVD61",$J,"SORTED",RADDT2,RADIEN)=""
 S (BKMVDT,BKMPVDT)="" F  S BKMVDT=$O(^TMP("BKMVD61",$J,"SORTED",BKMVDT),-1) Q:BKMVDT=""  D
 .S RAD="" F  S RAD=$O(^TMP("BKMVD61",$J,"SORTED",BKMVDT,RAD)) Q:RAD=""  D
 . . S DA=RAD
 . . S IENS=$$IENS^DILF(.DA)
 . . S TEXT=""
 . . S TEXT=$$SETFLD^VALM1($S((BKMVDT\1)'=(BKMPVDT\1):$$FMTE^XLFDT(BKMVDT\1,"5Z"),1:""),TEXT,"Visit")
 . . S TEXT=$$SETFLD^VALM1($$GET1^DIQ(9000010.22,IENS,".01","E"),TEXT,"Procedure")
 . . S TEXT=$$SETFLD^VALM1($$GET1^DIQ(9000010.22,IENS,".05","E"),TEXT,"Abnormal")
 . . ; CPT Code is a computed field based on RADIOLOGY PROCEDURE
 . . S RADCODE=$$GET1^DIQ(9000010.22,IENS,.01,"I")
 . . S TEXT=$$SETFLD^VALM1($$GET1^DIQ(71,RADCODE,"9","E"),TEXT,"CPT Code")
 . . S VALMCNT=$G(VALMCNT)+1 D SET^VALM10(VALMCNT,TEXT)
 . . S BKMPVDT=BKMVDT
 D ^XBFMK
 Q
