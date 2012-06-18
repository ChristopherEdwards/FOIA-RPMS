ACRFODD ;IHS/OIRM/DSD/AEF - Open Document Download Processing [ 10/27/2004   4:18 PM ]
 ;;2.1;ADMIN RESOURCE MGT SYSTEM;**13**;NOV 05, 2001
 ;
REC ;EP -- ENTRY POINT TO RECEIVE ODD OBLIGATION FILE FROM CORE
 ;
 N AP,DIC,DIR,OUT,PATH,X,Y
 D ^XBKVAR
 S DIC="^AUTTACPT("
 S DIC(0)="AEMQ"
 D ^DIC
 S AP=$P(Y,U,2)
 Q:'AP
 ;S PATH=$P($G(^ACRSYS(1,301)),U)          ; ACR*2.1*13.06 IM14144
 S PATH=$$ODDPATH^ACRFSYS(1)               ; ACR*2.1*13.06 IM14144
 Q:PATH']""
 D ASKPATHO^ACRFZISH(PATH,.ACROK)          ; ACR*2.1*13.06 IM14144 
 Q:'ACROK                                  ; ACR*2.1*13.06 IM14144
 ;S DIR(0)="Y"                             ; ACR*2.1*13.06 IM14144
 ;S DIR("A")="Is this OK"                  ; ACR*2.1*13.06 IM14144
 ;S DIR("B")="YES"                         ; ACR*2.1*13.06 IM14144
 ;D ^DIR                                   ; ACR*2.1*13.06 IM14144
 ;Q:$D(DTOUT)!($D(DUOUT))!($D(DIRUT))      ; ACR*2.1*13.06 IM14144
 ;I 'Y D SEL(.PATH,.OUT)                   ; ACR*2.1*13.06 IM14144
 ;I $G(OUT) W !,"DOWNLOAD ABORTED!" Q      ; ACR*2.1*13.06 IM14144
 ;Q:PATH']""                               ; ACR*2.1*13.06 IM14144
 ;I $E(PATH)'="/" S PATH="/"_PATH              ; ACR*2.1*13.06 IM14144
 ;I $E(PATH,$L(PATH))'="/" S PATH=PATH_"/"     ; ACR*2.1*13.06 IM14144
 W !
 ;D TCMD^ACRFUTL("/usr/spool/afsdata/odocget "_AP_" "_PATH) ; ACR*2.1*13.06 IM14144
 D TCMD^ACRFUTL(PATH_"odocget "_AP_" "_PATH) ; ACR*2.1*13.06 IM14144
 ;H 2                                        ; ACR*2.1*13.06 IM14144
 ;K DIR                                      ; ACR*2.1*13.06 IM14144
 ;S DIR(0)="E"                               ; ACR*2.1*13.06 IM14144
 ;S DIR("A")="Enter RETURN to continue"      ; ACR*2.1*13.06 IM14144
 ;D ^DIR                                     ; ACR*2.1*13.06 IM14144
 D PAUSE^ACRFWARN                            ; ACR*2.1*13.06 IM14144
 Q
SEL(PATH,OUT)      ;                               ; ACR*2.1*13.06 IM14144
 ;----- SELECT UNIX DIRECTORY
 ;
ASK ; REMOVED
 Q                                          ; ACR*2.1*13.06 IM14144
 N DIR,Y
 S DIR(0)="F"
 S DIR("A")="Directory"
 D ^DIR
 I $D(DTOUT)!($D(DUOUT))!($D(DIRUT)) S OUT=1 Q
 S PATH=Y
 D JCMD^ACRFUTL("cd "_PATH,.Y)
 I Y D  G ASK
 . W !,"No such directory "_PATH
 Q
IMP ;EP -- IMPORT ODD OBLIGATIONS INTO OPEN DOCUMENT DATABASE 
 ;
 N DIR,FILE,OUT,PATH,Y
 D INFO
 W !
 S DIR(0)="Y"
 S DIR("A")="Do you want to continue"
 S DIR("B")="NO"
 D ^DIR
 K DIR
 Q:'Y
 ;S PATH=$P($G(^ACRSYS(1,301)),U)              ; ACR*2.1*13.06 IM14144
 S PATH=$$ODDPATH^ACRFSYS(1)                   ; ACR*2.1*13.06 IM14144
 Q:PATH']""
 ;I $E(PATH)'="/" S PATH="/"_PATH              ; ACR*2.1*13.06 IM14144
 ;I $E(PATH,$L(PATH))'="/" S PATH=PATH_"/"     ; ACR*2.1*13.06 IM14144
 D LIST(PATH)
 D PICK(.OUT,.Y)
 Q:$G(OUT)
 S FILE=Y
 ;
 ;----- INTERFACE TO AFSLLDO2 ROUTINE
 ;
 D CRTSETUP^AFSLCRTS
 D SETTBL^AFSLLDO1
 S AFSEXFN=PATH_FILE
 S AFSLAPN=+$P(FILE,".",2)
 D ^AFSLLDO2
 ;D JCMD^ACRFUTL("rm /usr/spool/afsdata/pccodd.files") ; ACR*2.1*13.06 IM14144
 ;D JCMD^ACRFUTL("rm "_PATH_"pccodd.files") ; ACR*2.1*13.06 IM14144
 D DEL^ACRFZISH(PATH,"pccodd.files")        ; ACR*2.1*13.06 IM14144
 K ^TMP("ACR",$J)
 Q
PICK(OUT,Y)        ;
 ;----- PICK WHICH FILE TO IMPORT
 ;
 ;N DIR,DTOUT,DUOUT,X
 W !
 S DIR(0)="F"
 S DIR("A")="Select FILE for import"
 S DIR("?")="Enter file name to import, or '??' for a list of files"
 S DIR("??")="^D LIST^ACRFODD"
 F  D  Q:$G(OUT)  Q:$G(Y)]""
 . D ^DIR
 . I $D(DTOUT)!($D(DUOUT)) S OUT=1 Q
 . I '$D(^TMP("ACR",$J,"FILES",Y)) D  K Y
 . . W !,?5,"No such file "_Y
 Q
LIST(PATH)         ;
 ;----- LIST OF ODD FILES
 ;
 N DATA,I,FILE,QUIT,X
 D ^XBKVAR
 K ^TMP("ACR",$J)
 ;D JCMD^ACRFUTL("rm /usr/spool/afsdata/pccodd.files") ; ACR*2.1*13.06 IM14144
 ;D JCMD^ACRFUTL("ls -l "_PATH_"pccspc* > /usr/spool/afsdata/pccodd.files") ; ACR*2.1*13.06 IM14144
 ;D OPEN^%ZISH("FILE","/usr/spool/afsdata/","pccodd.files","R") ; ACR*2.1*13.06 IM14144
 ;D JCMD^ACRFUTL("rm "_PATH_"pccodd.files")      ;ACR*2.1*13.06 IM14144
 ;Q:POP                                          ;ACR*2.1*13.06 IM14144
 ;U IO                                           ;ACR*2.1*13.06 IM14144
 D DEL^ACRFZISH(PATH,"pccodd.files")             ;ACR*2.1*13.06 IM14144
 D JCMD^ACRFUTL("ls -l "_PATH_"pccspc* > "_PATH_"pccodd.files") ; ACR*2.1*13.06 IM14144
 D HFS^ACRFZISH(PATH,"pccodd.files","R",.%DEV)  ;ACR*2.1*13.06 IM14144
 Q:$G(%DEV)']""                                 ;ACR*2.1*13.06 IM14144
 U %DEV                                         ;ACR*2.1*13.06 IM14144
 F I=1:1 D  Q:$G(QUIT)
 . R X:DTIME
 . I $$STATUS^%ZISH S QUIT=1 Q
 . S ^TMP("ACR",$J,"DATA",I,0)=X
 D CLOSE^%ZISH("FILE")
 S I=0
 F  S I=$O(^TMP("ACR",$J,"DATA",I)) Q:'I  D
 . S X=^TMP("ACR",$J,"DATA",I,0)
 . S X=$E(X,55,999)
 . S ^TMP("ACR",$J,"FILES",$P(X,"/",$L(X,"/")),0)=$TR($E(X,30,40)," ","")_U_$E(X,42,53)_U_$P(X,"/",$L(X,"/"))
 D HOME^%ZIS
 W @IOF
 I '$D(^TMP("ACR",$J,"FILES")) W !,"No files to import" Q
 W !,"ODD files available for import into Open Document database"
 W !
 S FILE=""
 F  S FILE=$O(^TMP("ACR",$J,"FILES",FILE)) Q:FILE']""  D
 . S DATA=^TMP("ACR",$J,"FILES",FILE,0)
 . W !,$J($P(DATA,U),15)
 . W ?18,$P(DATA,U,2)
 . W ?32,$P(DATA,U,3)
 Q
INFO ;----- WRITE WARNING INFORMATION
 ;
 W !?18,"IMPORT CORE OBLIGATIONS DOWNLOAD FILE"
 W !
 W !?10,"This import process will completely replace all data"
 W !?10,"currently stored in your local obligations document"
 W !?10,"file with the current obligations data on file in the"
 W !?10,"CORE Accounting System.  There should have been NO"
 W !?10,"payment data entered into the ARMS PAYMENT system since"
 W !?10,"the last DHR Data Entry splitout & transmission to CORE."
 W !?10,"Otherwise, that data must be re-entered after this"
 W !?10,"import process is completed.  IT IS RECOMMENDED THAT"
 W !?10,"YOU REQUEST YOUR ADP SITE MANAGER SAVE THE GLOBAL"
 W !?10,"^AFSLODOC BEFORE YOU CONTINUE WITH THIS PROCESS."
 Q
