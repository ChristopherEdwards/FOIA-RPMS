BKMVD31 ;PRXM/HC/JGH - V-File Health Factors Review History; 24-JAN-2005 ; 12 Apr 2005  6:00 PM
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
EN ;ENTRY POINT -- ListMan template BKMV PCC HF REVIEW
 ; Called by Review History option for Health Factors
 ; Assumes existence of DFN,DUZ
 N HIVIEN
 S HIVIEN=$$HIVIEN^BKMIXX3()
 I HIVIEN="" W !,"There is no HMS register defined." H 2 Q
 I '$$VALID^BKMIXX3(DUZ) Q
 K ^TMP("BKMVD31",$J)
 D ^XBFMK
 D EN^VALM("BKMV PCC HF REVIEW")
 D ^XBFMK
 D EXIT
 Q
 ;
HDR ; -- header code
 ; Assumes existence of DUZ,RCRDHDR
 N DA,IENS,SITE
 S DA=$G(DUZ(2)),IENS=$$IENS^DILF(.DA),SITE=$$GET1^DIQ(4,IENS,.01,"E")
 S VALMHDR(1)=$$PAD^BKMIXX4("",">"," ",(80-$L(SITE)+2)\2)_"["_$G(SITE)_"]"
 S VALMHDR(2)=$G(RCRDHDR)
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
 K ^TMP("BKMVD31",$J)
 K VALM0,VALMAR,VALMCNT,VALMHDR
 Q
 ;
EXPND ; -- expand code
 Q
 ;
GETALL(DFN) ; Build ListMan display array
 ; Input variables:
 ;  DFN - IEN for File 2
 ; Output variables:
 ;  VALMAR - Builds ListMan array
 ;  VALMCNT - List array count
 ;  VALM0
 N TEXT,HFDT,IENS,HFACTOR,RHFDT,HFIEN,PHFDT
 D ^XBFMK
 S VALMCNT=0,VALMAR="^TMP(""BKMVD31"","""_$J_""")",VALM0=""
 S HFACTOR=""
 F  S HFACTOR=$O(^AUPNVHF("AA",DFN,HFACTOR)) Q:HFACTOR=""  D
 .S RHFDT=""
 .F  S RHFDT=$O(^AUPNVHF("AA",DFN,HFACTOR,RHFDT)) Q:RHFDT=""  D
 ..S HFIEN=""
 ..F  S HFIEN=$O(^AUPNVHF("AA",DFN,HFACTOR,RHFDT,HFIEN)) Q:HFIEN=""  D
 ...S ^TMP("BKMVD31",$J,"SORTED",RHFDT,HFIEN)=""
 S (RHFDT,PHFDT)=""
 F  S RHFDT=$O(^TMP("BKMVD31",$J,"SORTED",RHFDT)) Q:RHFDT=""  D
 .S HFIEN="" F  S HFIEN=$O(^TMP("BKMVD31",$J,"SORTED",RHFDT,HFIEN),-1) Q:HFIEN=""  D
 . . S DA=HFIEN
 . . S HFDT=9999999-RHFDT
 . . S IENS=$$IENS^DILF(.DA)
 . . S TEXT=""
 . . S TEXT=$$SETFLD^VALM1($S(HFDT'=PHFDT:$$FMTE^XLFDT(HFDT,"5Z"),1:""),TEXT,"Visit")
 . . S TEXT=$$SETFLD^VALM1($$GET1^DIQ(9000010.23,IENS,".01","E"),TEXT,"Health Factor")
 . . S VALMCNT=$G(VALMCNT)+1 D SET^VALM10(VALMCNT,TEXT)
 . . S PHFDT=HFDT
 D ^XBFMK
 Q
