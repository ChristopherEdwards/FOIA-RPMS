BKMVD81 ;PRXM/HC/JGH - V-File Immunology Review History ; 03 Jun 2005  3:13 PM
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
EN ;ENTRY POINT -- ListMan template BKMV PCC IMM REVIEW
 ; Called by Review History option for Immunology
 ; Assumes existence of DFN,DUZ
 N HIVIEN
 S HIVIEN=$$HIVIEN^BKMIXX3()
 I HIVIEN="" W !,"There is no HMS register defined." H 2 Q
 I '$$VALID^BKMIXX3(DUZ) Q
 K ^TMP("BKMVD81",$J)
 D ^XBFMK
 D EN^VALM("BKMV PCC IMM REVIEW")
 D ^XBFMK
 D EXIT
 Q
 ;
HDR ; -- header code
 ; Assumes existence of DUZ,RCRDHDR
 N DA,IENS,SITE
 S DA=$G(DUZ(2)),IENS=$$IENS^DILF(.DA),SITE=$$GET1^DIQ(4,IENS,.01,"E")
 S VALMHDR(1)=$$PAD^BKMIXX4("",">"," ",(80-$L(SITE)+2)\2)_"["_$G(SITE)_"]"
 S RCRDHDR=$$PAD^BKMIXX4(" Patient: ",">"," ",10)_$$PAD^BKMIXX4($$GET1^DIQ(2,DFN,".01","E"),">"," ",30)_$$PAD^BKMIXX4(" HRN: ",">"," ",6)_$$PAD^BKMIXX4($$HRN^BKMVA1(DFN),">"," ",9)
 S BKMDOD=$$GET1^DIQ(2,DFN,".351","I")
 I BKMDOD'="" S RCRDHDR=RCRDHDR_$$PAD^BKMIXX4(" DOD: ",">"," ",6)_$$PAD^BKMIXX4($$FMTE^XLFDT(BKMDOD,"5Z"),">"," ",15)
 S VALMHDR(2)=$G(RCRDHDR)
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
 N TEXT,IMM,IENS,IMMDT,IMMIEN,RIMMDT,PIMMDT
 D ^XBFMK
 S VALMCNT=0,VALMAR="^TMP(""BKMVD81"","""_$J_""")",VALM0=""
 ;
 S IMM=""
 F  S IMM=$O(^AUPNVIMM("AA",DFN,IMM)) Q:IMM=""  D
 . S RIMMDT=""
 . F  S RIMMDT=$O(^AUPNVIMM("AA",DFN,IMM,RIMMDT)) Q:RIMMDT=""  D
 . . S IMMIEN=""
 . . F  S IMMIEN=$O(^AUPNVIMM("AA",DFN,IMM,RIMMDT,IMMIEN)) Q:IMMIEN=""  D
 . . . S ^TMP("BKMVD81",$J,"SORTED",RIMMDT,IMMIEN)=""
 S (RIMMDT,PIMMDT)=""
 F  S RIMMDT=$O(^TMP("BKMVD81",$J,"SORTED",RIMMDT)) Q:RIMMDT=""  D
 . S IMMIEN=""
 . F  S IMMIEN=$O(^TMP("BKMVD81",$J,"SORTED",RIMMDT,IMMIEN)) Q:IMMIEN=""  D
 . . S IMMDT=9999999-RIMMDT
 . . S DA=IMMIEN,IENS=$$IENS^DILF(.DA)
 . . S TEXT=""
 . . S TEXT=$$SETFLD^VALM1($S(IMMDT'=PIMMDT:$$FMTE^XLFDT(IMMDT\1,"5Z"),1:""),TEXT,"Visit")
 . . S TEXT=$$SETFLD^VALM1($$GET1^DIQ(9000010.11,IENS,".01","E"),TEXT,"Immunization")
 . . S TEXT=$$SETFLD^VALM1($$GET1^DIQ(9000010.11,IENS,".04","E"),TEXT,"Series")
 . . S TEXT=$$SETFLD^VALM1($$GET1^DIQ(9000010.11,IENS,".05","E"),TEXT,"Lot")
 . . S TEXT=$$SETFLD^VALM1($$GET1^DIQ(9000010.11,IENS,".06","E"),TEXT,"Reaction")
 . . S VALMCNT=$G(VALMCNT)+1 D SET^VALM10(VALMCNT,TEXT)
 . . S PIMMDT=IMMDT
 D ^XBFMK
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BKMVD81",$J)
 K VALM0,VALMAR,VALMCNT,VALMHDR
 Q
