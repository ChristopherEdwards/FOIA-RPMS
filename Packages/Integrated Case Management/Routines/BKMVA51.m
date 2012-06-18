BKMVA51 ;PRXM/HC/JGH - HMS PATIENT REGISTER; [ 1/19/2005 7:16 PM ] ; 09 Jun 2005  12:55 PM
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
EN ;ENTRY POINT -- ListMan template BKMV PCC MED REVIEW
 ; Assumes existence of DFN,DUZ
 N HIVIEN
 S HIVIEN=$$HIVIEN^BKMIXX3()
 I HIVIEN="" W !,"There is no HMS register defined." H 2 Q
 I '$$VALID^BKMIXX3(DUZ) Q
 K ^TMP("BKMVA51",$J)
 D ^XBFMK
 D EN^VALM("BKMV PCC MED REVIEW")
 D ^XBFMK
 D EXIT
 Q
 ;
HDR ; EP - Header code
 ; Assumes existence of DUZ
 N DA,IENS,SITE,RCRDHDR,BKMDOD
 S DA=$G(DUZ(2)),IENS=$$IENS^DILF(.DA),SITE=$$GET1^DIQ(4,IENS,.01,"E")
 S VALMHDR(1)=$$PAD^BKMIXX4("",">"," ",(80-($L(SITE)+2))\2)_"["_$G(SITE)_"]"
 S RCRDHDR=$$PAD^BKMIXX4(" Patient: ",">"," ",10)_$$PAD^BKMIXX4($$GET1^DIQ(2,DFN,".01","E"),">"," ",30)_$$PAD^BKMIXX4(" HRN: ",">"," ",6)_$$PAD^BKMIXX4($$HRN^BKMVA1(DFN),">"," ",9)
 S BKMDOD=$$GET1^DIQ(2,DFN,".351","I")
 I BKMDOD'="" S RCRDHDR=RCRDHDR_$$PAD^BKMIXX4(" DOD: ",">"," ",6)_$$PAD^BKMIXX4($$FMTE^XLFDT(BKMDOD,1),">"," ",15)
 S VALMHDR(2)=RCRDHDR
 Q
 ;
INIT ; -- init variables and list array
 ; Assumes existence of DFN
 D GETALL(DFN)
 Q
 ;
GETALL(DFN) ; Build ListMan display array of patient medication information
 ; Input variables:
 ;  DFN - IEN for File 2
 ; Output variables:
 ;  VALMAR - Builds ListMan array
 ;  VALMCNT - List array count
 ;  VALM0
 N TEXT,MEDDT,PMEDDT,MEDIEN,IENS,TEXT,RMEDDT
 D ^XBFMK
 S VALMCNT=0,VALMAR="^TMP(""BKMVA51"","""_$J_""")",VALM0=""
 ;
 S (RMEDDT,PMEDDT)=""
 F  S RMEDDT=$O(^AUPNVMED("AA",DFN,RMEDDT)) Q:RMEDDT=""  D
 . S MEDIEN=""
 . F  S MEDIEN=$O(^AUPNVMED("AA",DFN,RMEDDT,MEDIEN)) Q:MEDIEN=""  D
 . . S DA=MEDIEN
 . . S MEDDT=9999999-RMEDDT
 . . S IENS=$$IENS^DILF(.DA)
 . . S TEXT=""
 . . S TEXT=$$SETFLD^VALM1($S(MEDDT'=PMEDDT:$$FMTE^XLFDT(MEDDT,"5Z"),1:""),TEXT,"Visit")
 . . S TEXT=$$SETFLD^VALM1($$GET1^DIQ(9000010.14,IENS,".01","E"),TEXT,"Medication")
 . . S TEXT=$$SETFLD^VALM1($$GET1^DIQ(9000010.14,IENS,".05","E"),TEXT,"Instructions")
 . . S TEXT=$$SETFLD^VALM1($$GET1^DIQ(9000010.14,IENS,".06","E"),TEXT,"Qty")
 . . S TEXT=$$SETFLD^VALM1($$GET1^DIQ(9000010.14,IENS,".07","E"),TEXT,"Days")
 . . S VALMCNT=$G(VALMCNT)+1 D SET^VALM10(VALMCNT,TEXT)
 . . S PMEDDT=MEDDT
 D ^XBFMK
 Q
 ;
HELP ; -- help code
 N X
 S X="?" D DISP^XQORM1 W !
 Q
 ;
EXIT ;clean up used variables.
 K ^TMP("BKMVA51",$J)
 K VALM0,VALMAR,VALMHDR,VALMCNT
 Q
 ;
 ;
