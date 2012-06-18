BKMVA41 ;PRXM/HC/JGH - HMS PATIENT REGISTER; [ 1/19/2005 7:16 PM ] ; 13 Apr 2005  5:42 PM
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
EN ;ENTRY POINT -- ListMan template BKMV PCC LAB REVIEW
 ; Assumes existence of DFN,DUZ
 N HIVIEN
 S HIVIEN=$$HIVIEN^BKMIXX3()
 I HIVIEN="" W !,"There is no HMS register defined." H 2 Q
 I '$$VALID^BKMIXX3(DUZ) Q
 K ^TMP("BKMVA41",$J)
 D ^XBFMK
 D EN^VALM("BKMV PCC LAB REVIEW")
 D ^XBFMK
 D EXIT
 Q
 ;
HDR ; -- header code
 ; Assumes existence of DUZ
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
GETALL(DFN) ; Build ListMan display array of patient lab information
 ; Input variables:
 ;  DFN - IEN for File 2
 ; Output variables:
 ;  VALMAR - Builds ListMan array
 ;  VALMCNT - List array count
 ;  VALM0
 N DA0,TEXT,LABDT,IENS,REFLOW,REFHIGH,BKMRNG,LAB,BKMVDT,VSTIEN,BKMPVDT
 N BKMACC,BKMPAR,BKMCHI,BKMRVDT
 D ^XBFMK
 S VALMCNT=0,VALMAR="^TMP(""BKMVA41"","""_$J_""")",VALM0=""
 ;
 ;PRXM/HC/BHS - 06/14/2006 - Resort lab test by reverse date, acc #, parent lab, child lab
 ;                           to match PAT/REC/LAB display order per IHS
 ;                           Commented out code removed for readability and size constraints
 S LAB=0,LABDT=0
 F  S LAB=$O(^AUPNVLAB("AC",DFN,LAB)) Q:LAB=""  D
 . S DA=LAB,IENS=$$IENS^DILF(.DA)
 . S LABDT=$$GET1^DIQ(9000010.09,IENS,"1201","I")
 . ; If event d/t is null, try visit d/t
 . I LABDT="" D  Q:LABDT=""
 . . S VSTIEN=$$GET1^DIQ(9000010.09,IENS,".03","I") Q:VSTIEN=""
 . . S LABDT=$$GET1^DIQ(9000010,VSTIEN_",",".01","I")
 . S BKMRVDT=9999999-(LABDT\1)
 . S BKMACC=$E($$GET1^DIQ(9000010.09,IENS,".06","E"),1,2)
 . I BKMACC="" S BKMACC="ZZ"
 . S BKMPAR=$S($$GET1^DIQ(9000010.09,IENS,"1208","I")]"":$$GET1^DIQ(9000010.09,IENS,"1208","I"),1:LAB)
 . S BKMCHI=$S($$GET1^DIQ(9000010.09,IENS,"1208","I")="":0,1:LAB)
 . S ^TMP("BKMVA41",$J,"NEW_SORT",BKMRVDT,BKMACC,BKMPAR,BKMCHI)=""
 ; Build display records
 S (BKMRVDT,BKMPVDT)="" F  S BKMRVDT=$O(^TMP("BKMVA41",$J,"NEW_SORT",BKMRVDT)) Q:BKMRVDT=""  D
 . S BKMACC="" F  S BKMACC=$O(^TMP("BKMVA41",$J,"NEW_SORT",BKMRVDT,BKMACC)) Q:BKMACC=""  D
 . . S BKMPAR="" F  S BKMPAR=$O(^TMP("BKMVA41",$J,"NEW_SORT",BKMRVDT,BKMACC,BKMPAR)) Q:BKMPAR=""  D
 . . . S BKMCHI="" F  S BKMCHI=$O(^TMP("BKMVA41",$J,"NEW_SORT",BKMRVDT,BKMACC,BKMPAR,BKMCHI)) Q:BKMCHI=""  D
 . . . . S DA=$S(BKMCHI>0:BKMCHI,1:BKMPAR)
 . . . . S IENS=$$IENS^DILF(.DA)
 . . . . S BKMVDT=9999999-BKMRVDT
 . . . . S VALMCNT=$G(VALMCNT)+1
 . . . . S TEXT=""
 . . . . ; Display only date and only when not a duplicate of previous entry
 . . . . S TEXT=$$SETFLD^VALM1($S((BKMVDT\1)'=(BKMPVDT\1):$$FMTE^XLFDT(BKMVDT\1,"5Z"),1:""),TEXT,"Visit")
 . . . . S TEXT=$$SETFLD^VALM1($S(BKMCHI>0:"  ",1:"")_$$GET1^DIQ(9000010.09,IENS,".01","E"),TEXT,"Lab Test")
 . . . . S TEXT=$$SETFLD^VALM1($$GET1^DIQ(9000010.09,IENS,".04","E"),TEXT,"Results")
 . . . . S TEXT=$$SETFLD^VALM1($$GET1^DIQ(9000010.09,IENS,"1101","E"),TEXT,"Units")
 . . . . S REFLOW=$$GET1^DIQ(9000010.09,IENS,"1104","E")
 . . . . S REFHIGH=$$GET1^DIQ(9000010.09,IENS,"1105","E")
 . . . . S BKMRNG=REFLOW_"-"_REFHIGH
 . . . . I BKMRNG="-" S BKMRNG=""
 . . . . S TEXT=$$SETFLD^VALM1(BKMRNG,TEXT,"RefRange")
 . . . . D SET^VALM10(VALMCNT,TEXT)
 . . . . S BKMPVDT=BKMVDT
 D ^XBFMK
 Q
 ;
GETDA(DFN,VALUE) ; Return IEN for the Patient DFN with the Register value
 ; Search for the appropriate register VALUE for the patient DFN and return the
 ; patient IEN in the variable DA.
 ; If  the variable VALUE contains a 1 then the IEN for the patient in the 
 ; HIV Management System is returned.
 N DA
 S DA="" F  S DA=$O(^AUPNVLAB("AC",DFN,DA)) Q:DA=""
 Q DA
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !
 Q
 ;
EXIT ;clean up used variables
 K ^TMP("BKMVA41",$J)
 K VALM0,VALMAR,VALMCNT,VALMHDR
 Q
 ;
 ;
