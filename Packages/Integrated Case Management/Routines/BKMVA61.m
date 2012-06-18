BKMVA61 ;PRXM/HC/JGH - HMS PATIENT REGISTER; [ 1/19/2005 7:16 PM ] ; 09 Jun 2005  12:57 PM
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
EN ;ENTRY POINT -- ListMan template BKMV PCC EDUC REVIEW
 ; Assumes existence of DFN,DUZ
 N HIVIEN
 S HIVIEN=$$HIVIEN^BKMIXX3()
 I HIVIEN="" W !,"There is no HMS register defined." H 2 Q
 I '$$VALID^BKMIXX3(DUZ) Q
 K ^TMP("BKMVA61",$J)
 D ^XBFMK
 D EN^VALM("BKMV PCC EDUC REVIEW")
 D ^XBFMK
 Q
 ;
HDR ; -- header code
 ; Assumes existence of DUZ
 D HDR^BKMVA51
 Q
 ;
INIT ; -- init variables and list array
 ; Assumes existence of DFN
 D GETALL(DFN)
 Q
 ;
GETALL(DFN) ; Build ListMan display array of patient education information
 ; Input variables:
 ;  DFN - IEN for File 2
 ; Output variables:
 ;  VALMAR - Builds ListMan array
 ;  VALMCNT - List array count
 ;  VALM0
 N TEXT,PEDIEN,IENS,PEDDT,RPEDDT,PPEDDT
 D ^XBFMK
 S VALMCNT=0,VALMAR="^TMP(""BKMVA61"","""_$J_""")",VALM0=""
 ;
 S (RPEDDT,PPEDDT)=""
 F  S RPEDDT=$O(^AUPNVPED("AA",DFN,RPEDDT)) Q:RPEDDT=""  D
 . S PEDIEN=""
 . F  S PEDIEN=$O(^AUPNVPED("AA",DFN,RPEDDT,PEDIEN)) Q:PEDIEN=""  D
 . . S DA=PEDIEN
 . . S PEDDT=9999999-RPEDDT
 . . S IENS=$$IENS^DILF(.DA)
 . . S TEXT=""
 . . S TEXT=$$SETFLD^VALM1($S(PEDDT'=PPEDDT:$$FMTE^XLFDT(PEDDT,"5Z"),1:""),TEXT,"Visit")
 . . S TEXT=$$SETFLD^VALM1($$GET1^DIQ(9000010.16,IENS,".01","E"),TEXT,"Class")
 . . S TEXT=$$SETFLD^VALM1($$GET1^DIQ(9000010.16,IENS,".06","E"),TEXT,"Level")
 . . S TEXT=$$SETFLD^VALM1($$GET1^DIQ(9000010.16,IENS,".05","E"),TEXT,"Provider")
 . . S TEXT=$$SETFLD^VALM1($$GET1^DIQ(9000010.16,IENS,".14","E"),TEXT,"Objs Met")
 . . S TEXT=$$SETFLD^VALM1($$GET1^DIQ(9000010.16,IENS,".07","E"),TEXT,"I/G")
 . . S TEXT=$$SETFLD^VALM1($$GET1^DIQ(9000010.16,IENS,".08","E"),TEXT,"Len")
 . . S TEXT=$$SETFLD^VALM1($$GET1^DIQ(9000010.16,IENS,".13","I"),TEXT,"Beh")
 . . S VALMCNT=$G(VALMCNT)+1 D SET^VALM10(VALMCNT,TEXT)
 . . S PPEDDT=PEDDT
 D ^XBFMK
 Q
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !
 Q
 ;
EXIT ;
 K ^TMP("BKMVA61",$J)
 K VALM0,VALMAR,VALMHDR,VALMCNT
 Q
 ;
 ;
