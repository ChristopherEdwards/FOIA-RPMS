BKMVC7 ;PRXM/HC/JGH - Patient Record Etiology ; 21 Jul 2005  7:17 PM
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
 Q
 ;
 ;
EN ; -- Entry point for BKMV RECORD ETIOLOGY ListMan template
 N HIVIEN
 S HIVIEN=$$HIVIEN^BKMIXX3()
 I HIVIEN="" W !,"There is no HMS register defined." H 2 Q
 ; PRXM/BHS - 03/30/2006 - Removed security check here - enforced within each option
 ;I '$D(^BKM(90450,HIVIEN,11,"B",DUZ)) Q
 ;
 K ^TMP("BKMVC7",$J)
 ;D GETALL(DFN)
 D EN^VALM("BKMV RECORD ETIOLOGY")
 D INIT^BKMVA2
 ;D CLEAN
 Q
 ;
INIT ;
 D GETALL(DFN)
 Q
 ;
GETALL(DFN) ;
 N ETI,ETICM,ETIDT,DA0,DA1,BKMIENS,TEXT
 D ^XBFMK
 S VALMCNT=0,VALMAR="^TMP(""BKMVC7"","""_$J_""")",VALM0=""
 S VALMCNT=$G(VALMCNT)+1 D SET^VALM10(VALMCNT," ")
 S (ETI,ETICM,LINE,ETIDT)=""
 S DA1=$$BKMIEN^BKMIXX3(DFN)
 Q:DA1=""
 S DA0=$$BKMREG^BKMIXX3(DA1)
 Q:DA0=""
 ;S (BKMIEN,DA1)=$O(^BKM(90451,"B",DFN,""))
 ;Q:DA1=""
 ;S (BKMREG,DA0)=$O(^BKM(90451,DA1,1,"B",1,""))
 ;I DA0="" Q
 ;;This patient is not on the HIV register.
 S DA=DA0,DA(1)=DA1
 S BKMIENS=$$IENS^DILF(.DA)
 S ETI=$$GET1^DIQ(90451.01,BKMIENS,7,"E")
 ;S ETI=$P($G(^BKM(90451,DA1,1,1,3)),U,3)
 I ETI'="" D
 .;S ETI=$P($G(^BKM(90451.5,ETI,0)),U,1)  ;$$GET1^DIQ("90451.01",ETIENS,"7","E")
 .;S EC=$P($G(^BKM(90451,DA1,1,1,5)),U,2)  ;$$GET1^DIQ("90451.01",ETIENS,"7.5","E")
 .;S LINE=0 F  S LINE=$O(^BKM(90451,DA1,1,DA0,4,LINE)) Q:LINE=""  S EC(LINE)=$G(^BKM(90451,DA1,1,DA0,4,LINE,0))
 .S ETICM=$$GET1^DIQ(90451.01,BKMIENS,7.5,"E")
 .S ETIDT=$$FMTE^XLFDT($S($$GET1^DIQ(90451.01,BKMIENS,7.51,"I")'="":$$GET1^DIQ(90451.01,BKMIENS,7.51,"I")\1,1:""),"1")
 .;S VALMCNT=0,VALMAR="^TMP(""BKMVC7"","""_$J_""")",VALM0=""
 .;S VALMCNT=$G(VALMCNT)+1 D SET^VALM10(VALMCNT," ")
 .;S VALMCNT=$G(VALMCNT)+1 D SET^VALM10(VALMCNT," ")
 .;I $P($G(^BKM(90451,DA1,1,1,3)),U,3)'="" D
 .S TEXT=$$PAD^BKMIXX4("Etiology: ",">"," ",24)_$$PAD^BKMIXX4(ETI,">"," ",54)
 .S VALMCNT=$G(VALMCNT)+1 D SET^VALM10(VALMCNT,TEXT)
 .S TEXT=$$PAD^BKMIXX4("Etiology Comment: ",">"," ",24)_$$PAD^BKMIXX4(ETICM,">"," ",54)
 .S VALMCNT=$G(VALMCNT)+1 D SET^VALM10(VALMCNT,TEXT)
 .S TEXT=$$PAD^BKMIXX4("Etiology Last Updated: ",">"," ",24)_$$PAD^BKMIXX4(ETIDT,">"," ",54)
 .S VALMCNT=$G(VALMCNT)+1 D SET^VALM10(VALMCNT,TEXT)
 ;No longer a W/P field. Now just set in EC, above.
 ;S LINE="" F  S LINE=$O(EC(LINE)) Q:LINE=""  S VALMCNT=$G(VALMCNT)+1 D SET^VALM10(VALMCNT,EC(LINE))
 D ^XBFMK
 Q
 ;
EDITTMP ;
 N BKMPRIV,BKMIEN,BKMREG,DA1,BKMIENS,BKMV
 D ^XBFMK
 S BKMPRIV=$$BKMPRIV^BKMIXX3($G(DUZ))
 ;I BKMPRIV=0 D NOGO^BKMIXX3  Q
 I 'BKMPRIV D NOGO^BKMIXX3  Q
 S BKMIEN=$O(^BKM(90451,"B",DFN,""))
 Q:BKMIEN=""
 S BKMREG=$O(^BKM(90451,BKMIEN,1,"B",HIVIEN,""))
 Q:BKMREG=""
 D ^XBFMK
 D FULL^VALM1
 ;Removed. Causing duplicate entries.
 ;D EN^BKMVAUD
 ; Capture Etiology (7)
 S DA(1)=BKMIEN,DA=BKMREG
 S BKMIENS=$$IENS^DILF(.DA)
 S BKMV("PRE",7)=$$GET1^DIQ(90451.01,BKMIENS,7,"I")
 S BKMV("PRE-EXT",7)=$$GET1^DIQ(90451.01,BKMIENS,7,"E")
 S DA1=BKMIEN
 L +^BKM(90451,BKMIEN):0 I '$T D EN^DDIOL("Another user is editing this entry.") H 2 G EDITTMPX
 ; PRX/DLS 4/3/2006 Adding code for Etiology prompts.
 N CDC,CDCIEN,CDCSTR,CDCVAL,X,Y,DR,CDCVAL2
 S (CDC,CDCVAL)=""
 F  S CDC=$O(^BKM(90451.5,"D",CDC)) Q:CDC=""  D
 . S CDCIEN=$O(^BKM(90451.5,"D",CDC,"")) Q:CDCIEN=""
 . S CDCSTR=$G(^BKM(90451.5,CDCIEN,0))
 . I CDCSTR'="" S CDCVAL=CDCVAL_$P(CDCSTR,U,2)_":"_$P(CDCSTR,U)_";"
 S CDCVAL=$E(CDCVAL,1,$L(CDCVAL)-1)
 S DIR(0)="SO^"_CDCVAL
 S DIR("A")="CDC Etiology Category"
 S DIR("B")=BKMV("PRE-EXT",7)
 D ^DIR
 ; PRX/DLS 4/12/06 Adding functionality to allow deletion of Etiology.
 ; If the etiology is removed and left blank, the comments will also be removed.
 ; If user enters '@' (to delete entry), prompt for confirmation before doing it.
 I X'="" D
 . S DIE="^BKM(90451,"_DA1_",1,",DA=BKMREG
 . I X'="@" D
 . . S CDCVAL2=$$FIND1^DIC(90451.5,"","",Y,"C","")
 . . S DR="7////"_CDCVAL2
 . I X="@" D
 . . S DIR(0)="Y"
 . . S DIR("A")="Confirm Deletion of Etiology Category"
 . . S DIR("B")="NO"
 . . D ^DIR
 . . I Y S DR="7////@;7.5////@"
 . I $G(DR) D ^DIE
 ; If there is an Etiology for this patient, prompt user for comments; otherwise, don't.
 I $$GET1^DIQ(90451.01,BKMIENS,7,"I")'="" D
 . S DIR(0)="FO"
 . S DIR("A")="Etiology Comments"
 . S DIR("B")=$$GET1^DIQ(90451.01,BKMIENS,7.5,"I")
 . D ^DIR
 I X'="" D
 . S DIE="^BKM(90451,"_DA1_",1,",DA=BKMREG
 . S DR=$S(X="@":"7.5////@",1:"7.5////"_$G(Y))
 . I DR["@" D
 . . S DIR(0)="Y"
 . . S DIR("A")="Confirm Deletion of Etiology Comments"
 . . S DIR("B")="NO"
 . . D ^DIR
 . I (DR'["@")!($G(Y)) D ^DIE
 ; PRX/DLS 4/3/2006 END NEW CODE
 K DA
 S DA(1)=BKMIEN,DA=BKMREG
 S BKMIENS=$$IENS^DILF(.DA)
 ; Capture Etiology (7)
 S BKMV("POST",7)=$$GET1^DIQ(90451.01,BKMIENS,7,"I")
 ; Compare pre vs. post
 I BKMV("PRE",7)'=BKMV("POST",7) D
 . ; Update Etiology Last Updated (7.51)
 . S DIE="^BKM(90451,"_DA(1)_",1,"
 . S DR="7.51////"_$$NOW^XLFDT()_";"
 . D ^DIE
 L -^BKM(90451,BKMIEN)
 ;D POST^BKMVAUD
EDITTMPX ; Exit point for EDITTMP
 D ^XBFMK ; Kills off a lot of Fileman variables
 K ^TMP("BKMVC7",$J)
 ;D GETALL(DFN)
 D INIT
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BKMVC7",$J)
 K VALM0,VALMAR,VALMHDR,VALMCNT
 Q
 ;
EXPND ; -- expand code
 Q
 ;
HDR ; -- header code
 D HDR^BKMVA51
 Q
 ;
CLEAN ;
 K BKMIEN,BKMREG,DA,DA0,DA1,DIE,DR,EC,ETI,HIVIEN,IENS,LINE,SITE,TEXT
 K ^TMP("BKMVC7",$J)
 Q
 ;
 ;
