BKMVD51 ;PRXM/HC/JGH - V-File Procedure Review History; 24-JAN-2005 ; 12 Apr 2005  6:38 PM
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
EN ;ENTRY POINT -- ListMan template BKMV PCC PRC REVIEW
 ; Called by Review History option for Procedure
 ; Assumes existence of DFN,DUZ
 N HIVIEN
 S HIVIEN=$$HIVIEN^BKMIXX3()
 I HIVIEN="" W !,"There is no HMS register defined." H 2 Q
 I '$$VALID^BKMIXX3(DUZ) Q
 K ^TMP("BKMVD51",$J)
 D ^XBFMK
 D EN^VALM("BKMV PCC PRC REVIEW")
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
 ;
 N TEXT,PRC,IENS,RPRCDT,PPRCDT,PRCDT,PRCIEN
 D ^XBFMK
 S VALMCNT=0,VALMAR="^TMP(""BKMVD51"","""_$J_""")",VALM0=""
 S PRC=""
 F  S PRC=$O(^AUPNVPRC("AA",DFN,PRC)) Q:PRC=""  D
 . S RPRCDT=""
 . F  S RPRCDT=$O(^AUPNVPRC("AA",DFN,RPRCDT)) Q:RPRCDT=""  D
 . . S PRCIEN=""
 . . F  S PRCIEN=$O(^AUPNVPRC("AA",DFN,RPRCDT,PRCIEN)) Q:PRCIEN=""  D
 . . . S ^TMP("BKMVD51",$J,"SORTED",RPRCDT,PRCIEN)=""
 S (RPRCDT,PPRCDT)=""
 F  S RPRCDT=$O(^TMP("BKMVD51",$J,"SORTED",RPRCDT)) Q:RPRCDT=""  D
 . S PRCIEN=""
 . F  S PRCIEN=$O(^TMP("BKMVD51",$J,"SORTED",RPRCDT,PRCIEN)) Q:PRCIEN=""  D
 . . S PRCDT=9999999-RPRCDT
 . . S DA=PRCIEN,IENS=$$IENS^DILF(.DA)
 . . S TEXT=""
 . . S TEXT=$$SETFLD^VALM1($S(PRCDT'=PPRCDT:$$FMTE^XLFDT(PRCDT\1,"5Z"),1:""),TEXT,"Visit")
 . . S TEXT=$$SETFLD^VALM1($$GET1^DIQ(9000010.08,IENS,".01","E"),TEXT,"Procedure")
 . . S TEXT=$$SETFLD^VALM1($$GET1^DIQ(9000010.08,IENS,".04","E"),TEXT,"Provider Narrative")
 . . S VALMCNT=$G(VALMCNT)+1 D SET^VALM10(VALMCNT,TEXT)
 . . S PPRCDT=PRCDT
 D ^XBFMK
 Q
 ;
HELP ; -- help code
 N X
 S X="?" D DISP^XQORM1 W !
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BKMVD51",$J)
 K VALM0,VALMAR,VALMCNT,VALMHDR
 Q
