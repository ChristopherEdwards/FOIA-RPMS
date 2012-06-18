BKMVA1B ;PRXM/HC/BHS - HMS PATIENT REGISTER CONT; [ 8/16/2005 11:33 AM ] ; 16 Aug 2005  11:33 AM
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 ; Prompts and functions related to BKMVA1
 Q
 ;
YNP(PROMPT,DFLT) ;EP - Yes/No question
 S DFLT=$G(DFLT)
 D ^XBFMK
 S DIR(0)="Y"
 S DIR("A")=PROMPT
 I DFLT="YES"!(DFLT="NO") S DIR("B")=DFLT
 D ^DIR I $D(DTOUT)!$D(DUOUT) Q 0
 Q $S(+$G(Y)=0:0,1:1)
 ;
FOLL() ;EP -Where Followed prompt
 N BKMIEN,BKMREG,DA,BKMIENS,FOLL
 S BKMIEN=$$BKMIEN^BKMIXX3(DFN)
 S BKMREG=$$BKMREG^BKMIXX3(BKMIEN)
 S DA(1)=BKMIEN,DA=BKMREG
 S BKMIENS=$$IENS^DILF(.DA)
 S FOLL=$$GET1^DIQ(90451.01,BKMIENS,.015,"E")
 I FOLL="" S FOLL=$$GET1^DIQ(4,+$G(DUZ(2)),.01,"E")
 N DIR,Y
 S DIR("B")=FOLL
 S DIR(0)="POr^9999999.06:EZ"
 S DIR("A")="  Where Followed"
 D ^DIR
 I Y=-1,X="@" Q "@"
 I $D(DTOUT)!$D(DUOUT) Q -1
 Q $P(Y,"^")
 ;
DXHIST(BKMIENS,BKMDUZ,BKMDX) ;EP - Update Date/Time of HMS Diagnosis Category History for File 90451
 ; Input variables:
 ;  BKMIENS - IEN list formatted for File 90451.01
 ;  BKMDUZ - User IEN from File 200
 ;  BKMDX  - Internal code from HMS DIAGNOSIS CATEGORY (??)
 ; Output variables:
 ;  Record updated in File 90451
 ; Initialize variables
 N IENS
 I $G(BKMIENS)'="",$G(BKMDUZ)'="" D
 .; Set the data via FileMan API
 .K FDA
 .S IENS="+1,"_BKMIENS
 .;S %DT="ST",X="N" D ^%DT
 .;S FDA(90451.151,IENS,.01)=Y       ; DATE/TIME
 .S FDA(90451.151,IENS,.01)=$$NOW^XLFDT()       ; DATE/TIME
 .S FDA(90451.151,IENS,.02)=BKMDX   ; HMS DIAGNOSIS CATEGORY
 .S FDA(90451.151,IENS,.03)=BKMDUZ  ; EVENT USER (File 200)
 .D UPDATE^DIE("","FDA","")
 .K FDA,%DT,X,Y
 Q
 ;
DIAG(DFN) ;EP - Return HMS Diagnosis Category
 N BKMIEN,BKMREG,DA,BKMIENS
 S BKMIEN=$$BKMIEN^BKMIXX3(DFN)
 S BKMREG=$$BKMREG^BKMIXX3(BKMIEN)
 S DA(1)=BKMIEN,DA=BKMREG
 S BKMIENS=$$IENS^DILF(.DA)
 Q $$GET1^DIQ(90451.01,BKMIENS,2.3,"I")
 ;
LDVAL(IENS) ; Load initial data values for input template BKMV PATIENT RECORD
 N TEMP
 K BKMVAL
 D GETS^DIQ(90451.01,IENS,".5;1;2.3;2.7;3;5;5.5;.015;6;6.5;7","I","TEMP")
 M BKMVAL=TEMP(90451.01,IENS)
 Q
 ;
LDREC(DFN,GUI) ;EP - Load recommended values for HMS Diagnosis Category, Initial HIV Date and
 ; Initial AIDS Date based on taxonomies
 ; this will first load the appropriate taxonomies and then calculate
 ; recommended values and store them in the following variables:
 ; DIAGCAT (Diagnosis); IAIDSDT (Initial AIDS date) ; HAIDSDT (Initial HIV date)
 ;
 ;  Added GUI Flag so as work with iCare
 S GUI=$G(GUI,0)
 I 'GUI D EN^DDIOL("Please wait, calculating default diagnosis category and initial dates.")
 ; Load taxonomies
 D ITAX^BKMVA1U
 ; Created REGDC^BKVMA1C to Process new logic for Recommended Diagnosis Category
 ;D AIDS^BKMVFAP1(DFN) ; Determine recommended values
 D REGDC^BKMVA1C(DFN)
 ; Kill temporary globals used to store taxonomies
 K ^TMP("BKMAIDS",$J),^TMP("BKMHIV",$J),^TMP("BKMCD4",$J)
 K ^TMP("BKMHIVP",$J),^TMP("BKMTST",$J),^TMP("BKMCD4AB",$J)
 Q
 ;
GETDXCAT(DFN) ;
 N BKMIEN,BKMREG,HIVIEN,BKMCHK,BKMVUP,DIAGCAT
 D ^XBFMK
 I '$$BKMPRIV^BKMIXX3(DUZ) D NOGO^BKMIXX3 Q
 S HIVIEN=$$HIVIEN^BKMIXX3()
 I HIVIEN="" Q
 S BKMIEN=$$BKMIEN^BKMIXX3(DFN)
 I BKMIEN="" Q
 S BKMREG=$$BKMREG^BKMIXX3(BKMIEN)
 I BKMREG="" Q
 S DA(1)=BKMIEN,DA=BKMREG
 S BKMIENS=$$IENS^DILF(.DA)
 ; Capture Clinical Classification (3) and HMS Dx Cat (2.3)
 S BKMV("PRE",3)=$$GET1^DIQ(90451.01,BKMIENS,3,"I")
 S BKMV("PRE",2.3)=$$GET1^DIQ(90451.01,BKMIENS,2.3,"I")
 ; Edit fields
 S DIAGCAT=$$DIAG^BKMIXX3() ;Prompt for HMS Diagnosis Category
 I DIAGCAT'=-1,DIAGCAT]"" D
 . S BKMVUP(90451.01,BKMIENS,2.3)=$G(DIAGCAT) K DA
 . D FILE^DIE("I","BKMVUP")
 K DA
 S DA(1)=BKMIEN,DA=BKMREG
 S BKMIENS=$$IENS^DILF(.DA)
 ; Capture Clinical Classification (3) and HMS Dx Cat (2.3)
 S BKMV("POST",3)=$$GET1^DIQ(90451.01,BKMIENS,3,"I")
 S BKMV("POST",2.3)=$$GET1^DIQ(90451.01,BKMIENS,2.3,"I")
 ; Compare pre vs. post
 I BKMV("PRE",3)'=BKMV("POST",3) D
 . ; Update Prior Clincal Classification (3.55) and Clinical Class. Change DT (3.5)
 . ;S %DT="ST",X="N" D ^%DT
 . S DIE="^BKM(90451,"_DA(1)_",1,"
 . S DR="3.55////"_BKMV("PRE",3)_";"
 . ;S DR=DR_"3.5////"_Y_";"
 . S DR=DR_"3.5////"_$$NOW^XLFDT()_";"
 . D ^DIE
 I BKMV("PRE",2.3)'=BKMV("POST",2.3) D
 . ; Update Prior Diagnosis (35)
 . S DIE="^BKM(90451,"_DA(1)_",1,"
 . S DR="35////"_BKMV("PRE",2.3)_";"
 . D ^DIE
 . D DXHIST^BKMVA1B(BKMIEN,BKMREG,DUZ,BKMV("POST",2.3))
 D ^XBFMK
 Q
 ;
DSPCC ;EP - Display Clinical Categories
 ;
 N CC,CCIEN,CCSTR
 S CC=""
 W !!?3,"Select one of the following clinical classifications:"
 F  S CC=$O(^BKMV(90451.7,"B",CC)) Q:CC=""  D
 . S CCIEN=$O(^BKMV(90451.7,"B",CC,"")) Q:CCIEN=""
 . S CCSTR=$G(^BKMV(90451.7,CCIEN,0)) Q:CCSTR=""  W !?3,$P(CCSTR,U),?13,$P(CCSTR,U,2)
 W !
 Q
 ;
DSPCDC ;EP - Display CDC Etiology Categories
 N CDC,CDCIEN,CDCSTR
 S CDC=""
 W !!?3,"Select one of the following CDC Etiology categories:"
 F  S CDC=$O(^BKM(90451.5,"D",CDC)) Q:CDC=""  D
 . S CDCIEN=$O(^BKM(90451.5,"D",CDC,"")) Q:CDCIEN=""
 . S CDCSTR=$G(^BKM(90451.5,CDCIEN,0)) Q:CDCSTR=""  W !?3,$P(CDCSTR,U,2),?13,$P(CDCSTR,U)
 W !
 Q
 ;
PROMPTS(DFN,BKMSKIP) ;EP - Patient Record prompts.
 ; BKMSKIP indicates whether or not prompts that are populated
 ; should be skipped when using input template BKMV PATIENT RECORD
 ; Populates DIRUT if timeout or up-arrow to exit
 N HIVIEN,BKMIEN,BKMREG,BKMIENS
 N BKMV,BKMDIAG,OBKMDIAG,BKMCC
 N BKMETI,FOLL
 S BKMETI=1 ;Flag to Input Template BKMV PATIENT RECORD to prompt for etiology
 ;
 S HIVIEN=$$HIVIEN^BKMIXX3
 S BKMIEN=$$BKMIEN^BKMIXX3(DFN)
 S BKMREG=$$BKMREG^BKMIXX3(BKMIEN)
 S DA(1)=BKMIEN,DA=BKMREG
 S BKMIENS=$$IENS^DILF(.DA)
 S DIE("NO^")="OUTOK"
 ; Initialize output variable identifying timeout or up-arrow
 K DIRUT
 ; Builds BKMV("PRE") array
 D GETVALS(BKMIENS,"PRE")
 D FULL^VALM1
 K DA
 S DA=BKMIEN,DIE="^BKM(90451,",DR="[BKMV PATIENT RECORD]"
 I '$$BKMPRIV^BKMIXX3(DUZ) D NOGO^BKMIXX3 Q
 ; Attempt to lock register record
 L +^BKM(90451,BKMIEN):0 I '$T D EN^DDIOL("Another user is editing this entry.") H 2 G PROMPTX
 D ^DIE
 ;Leave in commented lines until input template BKMV PATIENT RECORD has been confirmed
 ; Status
 ;I '$$EXISTRST^BKMVA1A(DFN,HIVIEN) D GETRSTAT^BKMVA1A(DFN)
 ;Q:$D(DIRUT)
 ; Status comments, if no Status
 ;I '$$EXISTRST^BKMVA1A(DFN,HIVIEN),'$$EXISTRSC^BKMVA1A(DFN,HIVIEN) D GETRSCOM^BKMVA1A(DFN)
 ;Q:$D(DIRUT)
 ; HMS dx category
 ;I '$$EXISTHDC^BKMVA1A(DFN,HIVIEN) D GETDXCAT(DFN)
 ;Q:$D(DIRUT)
 ; Initial HIV dx date
 ;I '$$EXISTIHD^BKMVA1A(DFN,HIVIEN) D GETIHDDT^BKMVA1A(DFN)
 ;Q:$D(DIRUT)
 ; Initial AIDS dx date
 ;I '$$EXISTIAD^BKMVA1A(DFN,HIVIEN) D GETIADDT^BKMVA1A(DFN)
 ;Q:$D(DIRUT)
 ; Location
 ;I '$$EXISTFOL^BKMVA1A(DFN,HIVIEN) D GETFOL^BKMVA1A(DFN)
 ;Q:$D(DIRUT)
 ; Provider
 ;I '$$EXISTRP^BKMVA1A(DFN) D GETRP^BKMVA1A(DFN)
 ;Q:$D(DIRUT)
 ; Case manager
 ;I '$$EXISTCM^BKMVA1A(DFN) D GETCM^BKMVA1A(DFN)
 ;Q:$D(DIRUT)
 ; Etiology
 ;I '$$EXISTETI^BKMVA1A(DFN) D GETETI^BKMVA1A(DFN)
 ;Q:$D(DIRUT)
 S BKMIEN=$$BKMIEN^BKMIXX3(DFN)
 S BKMREG=$$BKMREG^BKMIXX3(BKMIEN)
 K DA
 S DA(1)=BKMIEN,DA=BKMREG
 S BKMIENS=$$IENS^DILF(.DA)
 ; Builds BKMV("POST") array
 D GETVALS(BKMIENS,"POST")
 ; Populate triggered fields based on changes
 D COMPVALS(BKMIENS,"PRE","POST")
 ; Unlock register record
 L -^BKM(90451,BKMIEN)
PROMPTX ; Secondary point following unsuccessful lock attempt
 ; Notifications including state reporting status, state confirmation status and partner notification status
 ; PRXM/HC/BHS - 05/22/2006 - Update prompt text per IHS
 ;I '$$EXISTNOT^BKMVA1A(DFN) I $$YNP^BKMVA1B("  Do you want to add notification data to this patient","NO") D GETNOT^BKMVA1A(DFN)
 I '$$EXISTNOT^BKMVA1A(DFN) I $$YNP^BKMVA1B("  Do you want to add State or partner notification data now","NO") D GETNOT^BKMVA1A(DFN)
 Q:$D(DIRUT)
 ; HAART Appropriate and Compliance
 ; PRXM/HC/BHS - 05/22/2006 - Update prompt text per IHS
 ;I '$$EXISTHAP^BKMVA1A(DFN,HIVIEN) I $$YNP^BKMVA1B("  Do you want to add HAART Appropriate or Compliance data to this patient","NO") D GETHAP^BKMVA1A(DFN)
 I '$$EXISTHAP^BKMVA1A(DFN,HIVIEN) I $$YNP^BKMVA1B("  Do you want to add data related to HAART medications now","NO") D GETHAP^BKMVA1A(DFN)
 Q
 ;
GETVALS(IENS,TYP) ;EP - Called from TESTEDIT^BKMVA1A
 ; Build pre/post edit fields to track changes
 N TEMP
 K BKMV(TYP)
 ; Capture Status (.5), Clinical Classification (3), HMS Dx Cat (2.3)
 ;         (5), (5.5) and Etiology (7)
 ; PRX/DLS 4/5/06 Added prompt for Etiology Comments (7.5)
 D GETS^DIQ(90451.01,IENS,".5;2.3;3;5;5.5;7;7.5","I","TEMP")
 M BKMV(TYP)=TEMP(90451.01,IENS)
 Q
 ;
COMPVALS(IENS,TYP1,TYP2) ;EP - Called from TESTEDIT^BKMVA1A
 ; Compare pre/post edit fields to populate other fields
 ; Assumes existence of BKMV array
 ; Inputs:
 ;   TYP1 = Subscript value like "PRE"
 ;   TYP2 = Subscript value like "POST"
 N BKMCC
 I $G(TYP1)=""!($G(TYP2)="") Q
 I '$D(BKMV(TYP1))!'$D(BKMV(TYP2)) Q
 K BKMCC
 ; Delete clinical classification and initial dxs if at risk dx category
 I '$F("^H^A^",U_BKMV(TYP2,2.3,"I")_U) D
 . S BKMCC(90451.01,BKMIENS,3)=""
 . S BKMCC(90451.01,BKMIENS,3.5)=""
 . S BKMCC(90451.01,BKMIENS,5)=""
 . S BKMCC(90451.01,BKMIENS,5.5)=""
 ; Delete initial AIDS dx if HIV dx category
 I BKMV(TYP2,2.3,"I")="H" D
 . S BKMCC(90451.01,BKMIENS,5.5)=""
 ; Compare pre vs. post
 I BKMV(TYP1,.5,"I")'=BKMV(TYP2,.5,"I") D
 . ; Update Prior Status (.55)
 . S BKMCC(90451.01,BKMIENS,.55)=BKMV(TYP1,.5,"I")
 I BKMV(TYP1,3,"I")'=BKMV(TYP2,3,"I") D
 . ; Update Prior Clinical Classification (3.55) and Clinical Class. Change DT (3.5)
 . S BKMCC(90451.01,BKMIENS,3.55)=BKMV(TYP1,3,"I")
 . S BKMCC(90451.01,BKMIENS,3.5)=$$NOW^XLFDT()
 ; Evaluate if HMS Diagnosis Category has changed; if so update it
 I BKMV(TYP1,2.3,"I")'=BKMV(TYP2,2.3,"I") D
 . ; Update Prior Diagnosis (35)
 . S BKMCC(90451.01,BKMIENS,35)=BKMV(TYP1,2.3,"I")
 . D DXHIST^BKMVA1B(BKMIENS,DUZ,BKMV(TYP2,2.3,"I"))
 ; Evaluate if Etiology has changed; if so update Etiology Last Update (7.51)
 I BKMV(TYP1,7,"I")'=BKMV(TYP2,7,"I") D
 . S BKMCC(90451.01,BKMIENS,7.51)=$$NOW^XLFDT()
 D FILE^DIE("","BKMCC")
 Q
 ;
 ;
