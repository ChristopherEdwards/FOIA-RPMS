BKMVD71 ;PRXM/HC/JGH - V-File Skin Review History; 24-JAN-2005 ; 13 Jun 2005  12:11 PM
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 QUIT
 ;
EN ;ENTRY POINT -- ListMan template BKMV PCC SKIN REVIEW
 ; Called by Review History option for Skin Test
 ; Assumes existence of DFN,DUZ
 N HIVIEN
 S HIVIEN=$$HIVIEN^BKMIXX3()
 I HIVIEN="" W !,"There is no HMS register defined." H 2 Q
 ;
 ; The following line no longer applies
 ;I '$D(^BKM(90450,HIVIEN,11,"B",DUZ)) Q
 K ^TMP("BKMVD71",$J)
 D ^XBFMK
 D EN^VALM("BKMV PCC SKIN REVIEW")
 D ^XBFMK
 D EXIT
 QUIT
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
 N TEXT,SKN,IENS,RSKNDT,PSKNDT,SKNDT,SKNIEN
 D ^XBFMK
 S VALMCNT=0,VALMAR="^TMP(""BKMVD71"","_$J_")",VALM0=""
 ;
 S SKN=""
 F  S SKN=$O(^AUPNVSK("AA",DFN,SKN)) Q:SKN=""  D
 . S RSKNDT=""
 . F  S RSKNDT=$O(^AUPNVSK("AA",DFN,SKN,RSKNDT)) Q:RSKNDT=""  D
 . . S SKNIEN=""
 . . F  S SKNIEN=$O(^AUPNVSK("AA",DFN,SKN,RSKNDT,SKNIEN)) Q:SKNIEN=""  D
 . . . S ^TMP("BKMVD71",$J,"SORTED",RSKNDT,SKNIEN)=""
 S (RSKNDT,PSKNDT)=""
 F  S RSKNDT=$O(^TMP("BKMVD71",$J,"SORTED",RSKNDT)) Q:RSKNDT=""  D
 . S SKNIEN=""
 . F  S SKNIEN=$O(^TMP("BKMVD71",$J,"SORTED",RSKNDT,SKNIEN)) Q:SKNIEN=""  D
 . . S SKNDT=9999999-RSKNDT
 . . S DA=SKNIEN,IENS=$$IENS^DILF(.DA)
 . . S TEXT=""
 . . S TEXT=$$SETFLD^VALM1($S(RSKNDT'=PSKNDT:$$FMTE^XLFDT(SKNDT\1,"5Z"),1:""),TEXT,"Visit")
 . . S TEXT=$$SETFLD^VALM1($$GET1^DIQ(9000010.12,IENS,".01","E"),TEXT,"Test")
 . . S TEXT=$$SETFLD^VALM1($$GET1^DIQ(9000010.12,IENS,".04","E"),TEXT,"Results")
 . . S TEXT=$$SETFLD^VALM1($$GET1^DIQ(9000010.12,IENS,".05","E"),TEXT,"Reading")
 . . S VALMCNT=$G(VALMCNT)+1 D SET^VALM10(VALMCNT,TEXT)
 . . S PSKNDT=RSKNDT
 D ^XBFMK
 QUIT
 ;
HELP ; -- help code
 N X
 S X="?" D DISP^XQORM1 W !
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BKMVD71",$J)
 K VALM0,VALMAR,VALMCNT,VALMHDR
 Q
