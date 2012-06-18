BKMVA9 ;PRXM/HC/JGH-HMS PATIENT REGISTER; [ 1/19/2005 7:16 PM ] ; 09 Jun 2005  12:58 PM
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
EN ; -EP for BKMV UPD1 State
 N HIVIEN,ENTER
 S HIVIEN=$$HIVIEN^BKMIXX3()
 I HIVIEN="" W !,"There is no HMS register defined." H 2 Q
 I '$$VALID^BKMIXX3(DUZ) Q
 ; DAOU/BHS-12/29/05-Removed Sec check-enforced w/i each opt
 ;I '$$BKMPRIV^BKMIXX3(DUZ) D NOGO^BKMIXX3 Q
 ;
 K ^TMP("BKMVA9",$J)
 D EN^VALM("BKMV UPD1 STATE")
 K ^TMP("BKMVA9",$J)
 I '$$GETALL^BKMVA1(DFN) W !,"No Patient entered or Patient Not In Register <Enter>" H 2 Q
 D INIT^BKMVA1
 Q
 ;
EXEN ; EP -Called by GETNOT^BKMVA1A
 ; Assume DFN exists
 N HIVIEN
 S HIVIEN=$$HIVIEN^BKMIXX3()
 I HIVIEN="" W !,"There is no HMS register defined." H 2 Q
 I '$$VALID^BKMIXX3(DUZ) W !,"You are not a valid HMS user." H 2 Q
 ;
 K ^TMP("BKMVA9",$J)
 D EN^VALM("BKMV UPD1 STATE")
 K ^TMP("BKMVA9",$J)
 Q
 ;
HDR ; -header
 D HDR^BKMVA51
 Q
 ;
INIT ; -init vars & list array
 D GETALL
 Q
 ;
GETALL ;
 N VALMPGE,PNOT,BKMVA9,PDAT,TEXT,BKMVA9E,DA0,DA1,DA2,IENS,CAT,BKMDT,RSTAT
 N BKMSTAT,BKMSTATI,PNOTI,BKMDTE
 D ^XBFMK
 S VALMCNT=0,VALMPGE=1,VALMAR="^TMP(""BKMVA9"","_$J_")",VALM0=""
 S DA2=$$BKMIEN^BKMIXX3(DFN)
 S DA1=$$BKMREG^BKMIXX3(DA2)
 K DA
 S DA=DA1,DA(1)=DA2
 S IENS=$$IENS^DILF(.DA)
 ;DAOU/ALA 9/21/05 Modified State Reprtng data to reflect new fields
 ;D GETS^DIQ(90451.01,IENS,"4;4.1;4.2;4.3;4.5;4.51;4.52;4.53","E","BKMVA9","BKMVA9E")
 ; DAOU/BHS-10/31/05-Modified to translate dates to consistent format
 ; DAOU/BHS-11/30/05-Modified display order per IHS & add date entered display, etc
 D GETS^DIQ(90451.01,IENS,"4.1;4.3;4.51;4.53","EI","BKMVA9","BKMVA9E")
 S TEXT=""
 S TEXT=$$SETFLD^VALM1("State Reporting Category:",TEXT,"Type")
 S TEXT=$$SETFLD^VALM1("HIV",TEXT,"Status")
 S TEXT=$$SETFLD^VALM1("",TEXT,"Date Entered")
 S VALMCNT=$G(VALMCNT)+1 D SET^VALM10(VALMCNT,TEXT)
 S BKMSTAT=$G(BKMVA9("90451.01",IENS,"4.3","E")),(BKMSTATI,RSTAT)=$G(BKMVA9("90451.01",IENS,"4.3","I"))
 S BKMDT=$$FMTE^XLFDT($S($$GET1^DIQ(90451.01,IENS,"4","I")'="":$$GET1^DIQ(90451.01,IENS,"4","I")\1,1:""),"1")
 S BKMDTE=$$FMTE^XLFDT($S($$GET1^DIQ(90451.01,IENS,"4.4","I")'="":$$GET1^DIQ(90451.01,IENS,"4.4","I")\1,1:""),"1")
 S TEXT=""
 S TEXT=$$SETFLD^VALM1("Reported to State?",TEXT,"Type")
 S TEXT=$$SETFLD^VALM1(BKMSTAT_$S(BKMSTATI="Y"&(BKMDT'=""):" - "_BKMDT,1:""),TEXT,"Status")
 S TEXT=$$SETFLD^VALM1(BKMDTE,TEXT,"Date Entered")
 S VALMCNT=$G(VALMCNT)+1 D SET^VALM10(VALMCNT,TEXT)
 S BKMSTAT=$S(RSTAT="Y":$G(BKMVA9("90451.01",IENS,"4.1","E")),1:"")
 S BKMSTATI=$S(RSTAT="Y":$G(BKMVA9("90451.01",IENS,"4.1","I")),1:"")
 S BKMDT=$S(RSTAT="Y":$$FMTE^XLFDT($S($$GET1^DIQ(90451.01,IENS,"4.2","I")'="":$$GET1^DIQ(90451.01,IENS,"4.2","I")\1,1:""),"1"),1:"")
 S BKMDTE=$$FMTE^XLFDT($S($$GET1^DIQ(90451.01,IENS,"4.41","I")'="":$$GET1^DIQ(90451.01,IENS,"4.41","I")\1,1:""),"1")
 S TEXT=""
 S TEXT=$$SETFLD^VALM1("Confirmed by State?",TEXT,"Type")
 S TEXT=$$SETFLD^VALM1(BKMSTAT_$S(BKMSTATI="Y"&(BKMDT'=""):" - "_BKMDT,1:""),TEXT,"Status")
 S TEXT=$$SETFLD^VALM1(BKMDTE,TEXT,"Date Entered")
 S VALMCNT=$G(VALMCNT)+1 D SET^VALM10(VALMCNT,TEXT)
 S VALMCNT=$$I^BKMIXX3($G(VALMCNT),) D SET^VALM10(VALMCNT,"")  ; A blank line
 S TEXT=""
 S TEXT=$$SETFLD^VALM1("State Reporting Category:",TEXT,"Type")
 S TEXT=$$SETFLD^VALM1("AIDS",TEXT,"Status")
 S TEXT=$$SETFLD^VALM1("",TEXT,"Date Entered")
 S VALMCNT=$G(VALMCNT)+1 D SET^VALM10(VALMCNT,TEXT)
 S BKMSTAT=$G(BKMVA9("90451.01",IENS,"4.53","E")),(BKMSTATI,RSTAT)=$G(BKMVA9("90451.01",IENS,"4.53","I"))
 S BKMDT=$$FMTE^XLFDT($S($$GET1^DIQ(90451.01,IENS,"4.5","I")'="":$$GET1^DIQ(90451.01,IENS,"4.5","I")\1,1:""),"1")
 S BKMDTE=$$FMTE^XLFDT($S($$GET1^DIQ(90451.01,IENS,"4.54","I")'="":$$GET1^DIQ(90451.01,IENS,"4.54","I")\1,1:""),"1")
 S TEXT=""
 S TEXT=$$SETFLD^VALM1("Reported to State?",TEXT,"Type")
 S TEXT=$$SETFLD^VALM1(BKMSTAT_$S(BKMSTATI="Y"&(BKMDT'=""):" - "_BKMDT,1:""),TEXT,"Status")
 S TEXT=$$SETFLD^VALM1(BKMDTE,TEXT,"Date Entered")
 S VALMCNT=$G(VALMCNT)+1 D SET^VALM10(VALMCNT,TEXT)
 S BKMSTAT=$S(RSTAT="Y":$G(BKMVA9("90451.01",IENS,"4.51","E")),1:"")
 S BKMSTATI=$S(RSTAT="Y":$G(BKMVA9("90451.01",IENS,"4.51","I")),1:"")
 S BKMDT=$S(RSTAT="Y":$$FMTE^XLFDT($S($$GET1^DIQ(90451.01,IENS,"4.52","I")'="":$$GET1^DIQ(90451.01,IENS,"4.52","I")\1,1:""),"1"),1:"")
 S BKMDTE=$$FMTE^XLFDT($S($$GET1^DIQ(90451.01,IENS,"4.541","I")'="":$$GET1^DIQ(90451.01,IENS,"4.541","I")\1,1:""),"1")
 S TEXT=""
 S TEXT=$$SETFLD^VALM1("Confirmed by State?",TEXT,"Type")
 S TEXT=$$SETFLD^VALM1(BKMSTAT_$S(BKMSTATI="Y"&(BKMDT'=""):" - "_BKMDT,1:""),TEXT,"Status")
 S TEXT=$$SETFLD^VALM1(BKMDTE,TEXT,"Date Entered")
 S VALMCNT=$G(VALMCNT)+1 D SET^VALM10(VALMCNT,TEXT)
 ;
 S VALMCNT=$$I^BKMIXX3($G(VALMCNT),) D SET^VALM10(VALMCNT,"")  ; A blank line
 ; Partnr Notify Status-only display if exists
 S PNOT=$$GET1^DIQ(90451.01,IENS,"15","E"),PNOTI=$$GET1^DIQ(90451.01,IENS,"15","I")
 S PDAT=$$FMTE^XLFDT($S($$GET1^DIQ(90451.01,IENS,"16","I")'="":$$GET1^DIQ(90451.01,IENS,"16","I")\1,1:""),"1")
 S BKMDTE=$$FMTE^XLFDT($S($$GET1^DIQ(90451.01,IENS,"17","I")'="":$$GET1^DIQ(90451.01,IENS,"17","I")\1,1:""),"1")
 S TEXT=""
 S TEXT=$$SETFLD^VALM1("Partner Notification Status:",TEXT,"Type")
 S TEXT=$$SETFLD^VALM1(PNOT_$S(PNOTI="Y"&(PDAT'=""):" - "_PDAT,1:""),TEXT,"Status")
 S TEXT=$$SETFLD^VALM1(BKMDTE,TEXT,"Date Entered")
 S VALMCNT=$G(VALMCNT)+1 D SET^VALM10(VALMCNT,TEXT)
 ;
 D ^XBFMK
 Q
 ;
MAINFORM ; State Reporting/Confirmation
 ; Assume DFN & DUZ exist
 ; OSTAT utilized in input template
 N BKMPRIV,HIVIEN,BKMIEN,BKMREG,BKMV,BKMIENS,OSTAT
 D ^XBFMK
 S BKMPRIV=$$BKMPRIV^BKMIXX3(DUZ)
 I 'BKMPRIV D NOGO^BKMIXX3 Q
 S HIVIEN=$$HIVIEN^BKMIXX3()
 Q:HIVIEN=""
 S BKMIEN=$$BKMIEN^BKMIXX3(DFN)
 Q:BKMIEN=""
 S BKMREG=$$BKMREG^BKMIXX3(BKMIEN)
 Q:BKMREG=""
 D ^XBFMK
 D FULL^VALM1
 ; PRXM/BHS-04/04/06-Removed
 ;D EN^BKMVAUD
 ; DAOU/BHS-12/01/05-Orig vals for 'Date Entered' if changed
 ; Capture fields: 4,4.1,4.2,4.3,4.5,4.51,4.52,4.53
 K DA
 S DA(1)=BKMIEN,DA=BKMREG
 S BKMIENS=$$IENS^DILF(.DA)
 S BKMV("PRE",4)=$$GET1^DIQ(90451.01,BKMIENS,4,"I")
 S BKMV("PRE",4.1)=$$GET1^DIQ(90451.01,BKMIENS,4.1,"I")
 S BKMV("PRE",4.2)=$$GET1^DIQ(90451.01,BKMIENS,4.2,"I")
 S BKMV("PRE",4.3)=$$GET1^DIQ(90451.01,BKMIENS,4.3,"I")
 S BKMV("PRE",4.5)=$$GET1^DIQ(90451.01,BKMIENS,4.5,"I")
 S BKMV("PRE",4.51)=$$GET1^DIQ(90451.01,BKMIENS,4.51,"I")
 S BKMV("PRE",4.52)=$$GET1^DIQ(90451.01,BKMIENS,4.52,"I")
 S BKMV("PRE",4.53)=$$GET1^DIQ(90451.01,BKMIENS,4.53,"I")
 K DA
 S DA=BKMIEN,DIE="^BKM(90451,",DR="[BKMV PATIENT RECORD STATE]"
 L +^BKM(90451,BKMIEN):0 I '$T D EN^DDIOL("Another user is editing this entry.") H 2 G MAINX
 D ^DIE K SRCAT
 H 1
 ; DAOU/BHS-12/01/05-Update 'Date Entered' if changed
 ; Capture fields: 4,4.1,4.2,4.3,4.5,4.51,4.52,4.53
 K DA
 S DA(1)=BKMIEN,DA=BKMREG
 S BKMIENS=$$IENS^DILF(.DA)
 S BKMV("POST",4)=$$GET1^DIQ(90451.01,BKMIENS,4,"I")
 S BKMV("POST",4.1)=$$GET1^DIQ(90451.01,BKMIENS,4.1,"I")
 S BKMV("POST",4.2)=$$GET1^DIQ(90451.01,BKMIENS,4.2,"I")
 S BKMV("POST",4.3)=$$GET1^DIQ(90451.01,BKMIENS,4.3,"I")
 S BKMV("POST",4.5)=$$GET1^DIQ(90451.01,BKMIENS,4.5,"I")
 S BKMV("POST",4.51)=$$GET1^DIQ(90451.01,BKMIENS,4.51,"I")
 S BKMV("POST",4.52)=$$GET1^DIQ(90451.01,BKMIENS,4.52,"I")
 S BKMV("POST",4.53)=$$GET1^DIQ(90451.01,BKMIENS,4.53,"I")
 ; Compare pre vs post
 I (BKMV("PRE",4)'=BKMV("POST",4))!(BKMV("PRE",4.3)'=BKMV("POST",4.3)) D
 . ; STATE HIV RPT LAST UPDATED (4.4)
 . S DIE="^BKM(90451,"_DA(1)_",1,"
 . S DR="4.4////"_$$NOW^XLFDT()_";"
 . D ^DIE
 I (BKMV("PRE",4.1)'=BKMV("POST",4.1))!(BKMV("PRE",4.2)'=BKMV("POST",4.2)) D
 . ; STATE HIV ACK LAST UPDATED (4.41)
 . S DIE="^BKM(90451,"_DA(1)_",1,"
 . S DR="4.41////"_$$NOW^XLFDT()_";"
 . D ^DIE
 I (BKMV("PRE",4.5)'=BKMV("POST",4.5))!(BKMV("PRE",4.53)'=BKMV("POST",4.53)) D
 . ; STATE AIDS RPT LAST UPDATED (4.54)
 . S DIE="^BKM(90451,"_DA(1)_",1,"
 . S DR="4.54////"_$$NOW^XLFDT()_";"
 . D ^DIE
 I (BKMV("PRE",4.51)'=BKMV("POST",4.51))!(BKMV("PRE",4.52)'=BKMV("POST",4.52)) D
 . ; STATE AIDS ACK LAST UPDATED (4.541)
 . S DIE="^BKM(90451,"_DA(1)_",1,"
 . S DR="4.541////"_$$NOW^XLFDT()_";"
 . D ^DIE
 L -^BKM(90451,BKMIEN)
 ; PRXM/BHS-04/04/06-Removed
 ;D POST^BKMVAUD
MAINX ; Exit point for MAINFORM
 K ^TMP("BKMVA9",$J)
 D GETALL
 Q
 ;
PNOTFORM ;  Partner notification
 ; Assume DFN & DUZ exist
 ; OSTAT utilized in input template
 N BKMPRIV,HIVIEN,BKMIEN,BKMREG,IENS,BKMV,BKMIENS,OSTAT
 D ^XBFMK
 S BKMPRIV=$$BKMPRIV^BKMIXX3(DUZ)
 I 'BKMPRIV D NOGO^BKMIXX3 Q
 S HIVIEN=$$HIVIEN^BKMIXX3()
 Q:HIVIEN=""
 S BKMIEN=$$BKMIEN^BKMIXX3(DFN)
 Q:BKMIEN=""
 S BKMREG=$$BKMREG^BKMIXX3(BKMIEN)
 Q:BKMREG=""
 D ^XBFMK
 D FULL^VALM1
 ; PRXM/BHS-04/04/06-Removed
 ;D EN^BKMVAUD
 ; DAOU/BHS-12/01/05-Track original values to track 'Date Entered' for changes
 ; Capture fields: 15,16
 K DA
 S DA(1)=BKMIEN,DA=BKMREG
 S BKMIENS=$$IENS^DILF(.DA)
 S BKMV("PRE",15)=$$GET1^DIQ(90451.01,BKMIENS,15,"I")
 S BKMV("PRE",16)=$$GET1^DIQ(90451.01,BKMIENS,16,"I")
 K DA
 S DA(1)=BKMIEN,DA=BKMREG,IENS=$$IENS^DILF(.DA)
 L +^BKM(90451,BKMIEN):0 I '$T D EN^DDIOL("Another user is editing this entry.") H 2 G PNOTX
 ; If PARTNER NOTIFICATION STATUS (#15) is null, default it
 I $$GET1^DIQ(90451.01,IENS,"15","I")="" D
 . ; Default to 'Unknown'
 . S DIE="^BKM(90451,"_DA(1)_",1,"
 . S DR="15////U;"
 . D ^DIE
 K DA
 S DA=BKMIEN,DIE="^BKM(90451,",DR="[BKMV UPD1 PNOT]"
 D ^DIE
 H 1
 ; DAOU/BHS-12/01/05-Update 'Date Entered' fields where appropriate
 ; Capture fields: 15,16
 K DA
 S DA(1)=BKMIEN,DA=BKMREG
 S BKMIENS=$$IENS^DILF(.DA)
 S BKMV("POST",15)=$$GET1^DIQ(90451.01,BKMIENS,15,"I")
 S BKMV("POST",16)=$$GET1^DIQ(90451.01,BKMIENS,16,"I")
 ; Compare pre vs post
 I BKMV("PRE",15)'=BKMV("POST",15)!(BKMV("PRE",16)'=BKMV("POST",16)) D
 . ; PARTNER NOTIFIED LAST UPDATED (17)
 . S DIE="^BKM(90451,"_DA(1)_",1,"
 . S DR="17////"_$$NOW^XLFDT()_";"
 . D ^DIE
 L -^BKM(90451,BKMIEN)
 ; PRXM/BHS-04/04/06-Removed
 ;D POST^BKMVAUD
PNOTX ; PNOTFORM Exit point
 K ^TMP("BKMVA9",$J)
 D GETALL
 Q
 ;
HELP ; -help
 S X="?" D DISP^XQORM1 W !
 Q
 ;
EXIT ; -exit
 K VALM0,VALMAR,VALMHDR,VALMCNT
 Q
 ;
YNP(PROMPT,DFLT) ;Yes/No question
 N DIR,X,Y,DTOUT,DUOUT,DIRUT,DIROUT,TEXT,DIWL,DIWR,BKMTOT,II
 S DFLT=$G(DFLT)
 S DIR(0)="Y"
 ; If PROMPT is > 1 line, split with ^DIWP
 I $L(PROMPT)>77 D
 . K ^UTILITY($J,"W")
 . S X=PROMPT,DIWL=1,DIWR=77 D ^DIWP
 . S BKMTOT=+$G(^UTILITY($J,"W",DIWL))
 . F II=1:1:BKMTOT D
 . . S TEXT=$G(^UTILITY($J,"W",DIWL,II,0))
 . . I $E(TEXT,$L(TEXT))=" " S TEXT=$E(TEXT,1,$L(TEXT)-1)
 . . I II<BKMTOT S DIR("A",II)=TEXT
 . . I II=BKMTOT S DIR("A")=TEXT
 I $L(PROMPT)<78 S DIR("A")=PROMPT
 I DFLT="YES"!(DFLT="NO") S DIR("B")=DFLT
 D ^DIR I $D(DTOUT)!$D(DUOUT) Q 0
 Q $S(+$G(Y)=0:0,1:1)
 ; 
STAT(DFN,FLD) ; get current AIDS/HIV State Reportng/Confirmation or Partnr Notification Status
 N STAT,BKMIEN,BKMREG
 S STAT=""
 S BKMIEN=$$BKMIEN^BKMIXX3(DFN)
 I BKMIEN="" Q STAT
 S BKMREG=$$BKMREG^BKMIXX3(BKMIEN)
 I BKMREG="" Q STAT
 S STAT=$$GET1^DIQ(90451.01,BKMREG_","_BKMIEN_",",FLD,"I")
 Q STAT
 ;
HIVRDT ; EP -Input Transform for State HIV Reporting DT
 N Y,HIVCDT,DOB,DFN
 S HIVCDT=$$GET1^DIQ(90451.01,DA_","_DA(1)_",",4.2,"I")
 S DFN=$$GET1^DIQ(90451,DA(1)_",",.01,"I")
 S DOB=$$GET1^DIQ(2,DFN,.03,"I")
 S %DT="EX" D ^%DT S X=Y
 I Y=-1 K X S BFL=1 Q
 I DOB>X K X Q
 I X>DT K X Q
 I HIVCDT'="",X>HIVCDT K X Q
 Q
 ;
HIVCDT ; EP -Input Transform for State HIV Confirmation DT
 N Y,HIVRDT,DOB,DFN
 S HIVRDT=$$GET1^DIQ(90451.01,DA_","_DA(1)_",",4,"I")
 S DFN=$$GET1^DIQ(90451,DA(1)_",",.01,"I")
 S DOB=$$GET1^DIQ(2,DFN,.03,"I")
 S %DT="EX" D ^%DT S X=Y
 I Y=-1 K X S BFL=1 Q
 I DOB>X K X Q
 I X>DT K X Q
 I HIVRDT'="",X<HIVRDT K X Q
 Q
 ;
AIDRDT ; EP -Input Transform for State AIDS Reporting DT
 N Y,AIDCDT,DOB,DFN
 S AIDCDT=$$GET1^DIQ(90451.01,DA_","_DA(1)_",",4.52,"I")
 S DFN=$$GET1^DIQ(90451,DA(1)_",",.01,"I")
 S DOB=$$GET1^DIQ(2,DFN,.03,"I")
 S %DT="EX" D ^%DT S X=Y
 I Y=-1 K X S BFL=1 Q
 I DOB>X K X Q
 I X>DT K X Q
 I AIDCDT'="",X>AIDCDT K X Q
 Q
 ;
AIDCDT ; EP -Input Transform for State AIDS Confirmation DT
 N Y,AIDRDT,DOB,DFN
 S AIDRDT=$$GET1^DIQ(90451.01,DA_","_DA(1)_",",4.5,"I")
 S DFN=$$GET1^DIQ(90451,DA(1)_",",.01,"I")
 S DOB=$$GET1^DIQ(2,DFN,.03,"I")
 S %DT="EX" D ^%DT S X=Y
 I Y=-1 K X S BFL=1 Q
 I DOB>X K X Q
 I X>DT K X Q
 I AIDRDT'="",X<AIDRDT K X Q
 Q
 ;
PNOTDT ; EP -Input Transform for Partner Notification DT
 NEW Y,DOB,DFN
 S DFN=$$GET1^DIQ(90451,DA(1)_",",.01,"I")
 S DOB=$$GET1^DIQ(2,DFN,.03,"I")
 S %DT="EX" D ^%DT S X=Y
 I Y=-1 K X S BFL=1 Q
 I DOB>X K X Q
 I X>DT K X Q
 Q
 ;
HIVRHLP ; EP -HIV State Reporting DT Special Help
 S DV=""
 K HELP
 I $G(BFL) D HELP^%DTC K BFL Q
 I X["BAD" D
 . S HELP(1)="The State HIV reporting date must be previous to the State HIV confirmation"
 . S HELP(1,"F")="?5"
 . S HELP(2)="date, if it exists, and not previous to the Date of Birth and not in the future."
 . S HELP(2,"F")="!?5"
 . S HELP(3)="Please reenter the date."
 . S HELP(3,"F")="!?5"
 . D EN^DDIOL(.HELP)
 K HELP
 Q
 ;
HIVCHLP ; EP -HIV State Confirmation DT Special Help
 S DV=""
 K HELP
 I $G(BFL) D HELP^%DTC K BFL Q
 I X["BAD" D
 . S HELP(1)="The State HIV confirmation date must be on or after the State HIV reporting"
 . S HELP(1,"F")="?5"
 . S HELP(2)="date, if it exists, and not previous to the Date of Birth and not in the future."
 . S HELP(2,"F")="!?5"
 . S HELP(3)="Please reenter the date."
 . S HELP(3,"F")="!?5"
 . D EN^DDIOL(.HELP)
 K HELP
 Q
 ;
AIDRHLP ; EP -AIDS State Reporting DT Special Help
 S DV=""
 K HELP
 I $G(BFL) D HELP^%DTC K BFL Q
 I X["BAD" D
 . S HELP(1)="The State AIDS reporting date must be previous to the State AIDS confirmation"
 . S HELP(1,"F")="?5"
 . S HELP(2)="date, if it exists, and not previous to the Date of Birth and not in the future."
 . S HELP(2,"F")="!?5"
 . S HELP(3)="Please reenter the date."
 . S HELP(3,"F")="!?5"
 . D EN^DDIOL(.HELP)
 K HELP
 Q
 ;
AIDCHLP ; EP -AIDS State Confirmation DT Special Help
 S DV=""
 K HELP
 I $G(BFL) D HELP^%DTC K BFL Q
 I X["BAD" D
 . S HELP(1)="The State AIDS confirmation date must on or after the State AIDS reporting"
 . S HELP(1,"F")="?5"
 . S HELP(2)="date, if it exists, and not previous to the Date of Birth and not in the future."
 . S HELP(2,"F")="!?5"
 . S HELP(3)="Please reenter the date."
 . S HELP(3,"F")="!?5"
 . D EN^DDIOL(.HELP)
 K HELP
 Q
 ;
PNOTHLP ; EP -Partner Notification Special Help
 S DV=""
 K HELP
 I $G(BFL) D HELP^%DTC K BFL Q
 I X["BAD" D
 . S HELP(1)="The partner notification date must not precede the Date of Birth and"
 . S HELP(1,"F")="?5"
 . S HELP(2)="cannot be in the future.  Please reenter the date."
 . S HELP(2,"F")="!?5"
 . D EN^DDIOL(.HELP)
 K HELP
 Q
