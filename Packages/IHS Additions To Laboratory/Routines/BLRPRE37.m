BLRPRE37 ; IHS/MSC/MKK - IHS Lab Patch LR*5.2*1037 Pre/Environment Routine ; 02-Nov-2015 13:44 ; MKK
 ;;5.2;IHS LABORATORY;**1037**;NOV 01, 1997;Build 4
 ;
ENVICHEK ; EP - Environment Checker
 NEW BLRVERN,CP,ERRARRAY,ROWSTARS,RPMS,RPMSVER,TODAY,WOTCNT
 ;
 Q:$$ENVIVARS()="Q"
 ;
 D ENVHEADR^BLRPRE31(CP,RPMSVER,RPMS),BLANK
 ;
 D NEEDIT^BLRPRE31(CP,"LR","5.2",1036,.ERRARRAY),BLANK  ; Lab Pre-Requisite
 ;
 I XPDABORT>0 D SORRYEND^BLRPRE33(.ERRARRAY,CP)   Q     ; ENVIRONMENT HAS ERROR(S)
 ;
 D BOKAY^BLRPRE31("ENVIRONMENT")
 ;
 Q
 ;
ENVIVARS() ; EP - Setup the Environment variables
 D SETEVARS
 ;
 S TODAY=$$DT^XLFDT
 S WOTCNT=$$WOTCNT(BLRVERN)
 S ROWSTARS=$TR($J("",65)," ","*")     ; Row of asterisks
 ;
 S ^XTMP(BLRVERN,0)=$$HTFM^XLFDT(+$H+90)_"^"_$$DT^XLFDT_"^IHS Lab Patch "_CPSTR
 M ^XTMP(BLRVERN,TODAY,WOTCNT,"DUZ")=DUZ
 S ^XTMP(BLRVERN,TODAY,WOTCNT,"BEGIN")=$$NOW^XLFDT
 ;
 S XUMF=1
 ;
 I $G(XPDNM)="" D SORRY^BLRPRE31(CP,"XPDNM not defined or 0.")  Q "Q"
 ;
 S RPMS=$P(XPDNM,"*",1)      ; RPMS Module
 S RPMSVER=$P(XPDNM,"*",2)   ; RPMS Version
 ;
 I +$G(DUZ)<1 D SORRY^BLRPRE31(CP,"DUZ UNDEFINED OR 0.")  Q "Q"
 I $$GET1^DIQ(200,DUZ,"NAME")="" D SORRY^BLRPRE31(CP,"Installer cannot be identified!")  Q "Q"
 ;
 S XPDNOQUE=1        ; No Queuing Allowed
 ;
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 F X="XPO1","XPZ1","XPZ2","XPI1" S XPDDIQ(X)=0,XPDDIQ(X,"B")="NO"
 ;
 S XPDABORT=0        ; KIDS install Flag
 ;
 D HOME^%ZIS         ; Reset/Initialize IO variables
 D DTNOLF^DICRW      ; Set DT variable without a Line Feed
 ;
 Q "OK"
 ;
PRE ; EP - Ask for confirmation of Backup
 NEW BLRVERN,CNT,CP,CPSTR,CRTLINE,DIRASTR,FDAROOT,IEN,IENS,MSGROOT
 NEW BCKUPCNT                   ; Current Patch,Backup count
 ;
 D SETEVARS
 ;
 S XUMF=1
 ;
 D INITSCR
 D TITLE^XPDID(CPSTR)
 D BLANK,BMES^XPDUTL("Pre-Install of "_BLRVERN_" Begins.")
 ;
 Q:$$BACKUP()="Q"
 ;
 D INITSCR
 D TITLE^XPDID(CPSTR)
 D BLANK,BMES^XPDUTL("Pre-Install of "_BLRVERN_" Continues.")
 ;
 ; Do Pre-install stuff here.
 ;
 D TABMESG^BLRKIDSU("Pre-Install Processing Ends at "_$$UP^XLFSTR($$HTE^XLFDT($H,"5MPZ"))_".",5)
 H 2  ; Pause so user can see the message.
 ;
 D EXIT^XPDID
 Q
 ;
BACKUP() ; EP - Confirm Backup
 NEW BCKUPCNT,SUCCSTR
 ;
 D SHOWBOX^BLRGMENU("ATTENTION",10,70)
 ;
 D ^XBFMK
 S DIR(0)="Y"
 S DIR("B")="NO"
 I $G(IOST)["C-VT" S SUCCSTR=$C(27)_"[1;7;5m"_">> SUCCESSFUL <<"_$C(27)_"[0m"
 E  S SUCCSTR=">> SUCCESSFUL <<"
 S DIR("A")=$J("",10)_"Has a "_SUCCSTR_" backup been performed?"
 S DIR("?")="A *NO* answer will abort the install process."
 D ^DIR
 W !
 ;
 Q:+$G(Y)'=1 $$NOBACKUP()       ; If BACKUP not performed, then ABORT installation.
 ;
 Q:+$G(DEBUG) $$OKBACKUP()      ; DEBUG will *NOT* store Backup Confirmation data.
 ;
 ; Store backup confirmation person & date/time
 S BCKUPCNT=1+$O(^BLRINSTL("LAB PATCH",CP,"BACKUP CONFIRMED BY",0),-1)
 S ^BLRINSTL("LAB PATCH",CP,"BACKUP CONFIRMED BY",BCKUPCNT)=$P($G(^VA(200,DUZ,0)),U)
 S ^BLRINSTL("LAB PATCH",CP,"BACKUP CONFIRMED BY",BCKUPCNT,"DUZ")=DUZ
 S ^BLRINSTL("LAB PATCH",CP,"BACKUP CONFIRMED BY",BCKUPCNT,"DATE/TIME")=$$HTE^XLFDT($H,"5MZ")
 ;
 Q $$OKBACKUP()
 ;
OKBACKUP() ; EP - Backup Confirmed.
 D MES^XPDUTL("")
 D OKAY^BLRKIDSU("SUCCESSFUL system backup CONFIRMED by: "_$$GET1^DIQ(200,DUZ,"NAME")_".",5)
 I +$G(DEBUG) D
 . D MES^XPDUTL("")
 . D TABMENU^BLRKIDSU("DEBUG will **NOT** Store Backup Confirmation.",10)
 ;
 H 2     ; Pause to let the user see the message.
 Q "OK"
 ;
NOBACKUP() ; EP - No backup message
 S XPDABORT=1
 D PASSMESG^BLRPRE31("ATTENTION")
 D TABMESG^BLRKIDSU("SUCCESSFUL system backup has >>> NOT <<< been confirmed.",15)
 D TABMESG^BLRKIDSU("Installer: "_$$GET1^DIQ(200,DUZ,"NAME")_" ["_DUZ_"].",25)
 D TABMESG^BLRKIDSU("Install Aborting.",15)
 H 2     ; Pause to let the user see the message.
 Q "Q"
 ;
DEBUG ; EP - Debugging Line Label for environment checker
 NEW BEGTIME,BLRVERN,CP,CPSTR,DEBUG,ENDTIME,ERRARRAY,LASTLOGI
 NEW LRBLNOW,PATCHNUM,PREREQ,QFLG,ROWSTARS,RPMS,RPMSVER,STR
 NEW SUCCSTR,TODAY,WHATCNT,WOTCNT,XPDABORT,XPDENV,XPDNM
 ;
 ; NOTE: DEBUG will not store "Backup" data.
 ;
 D SETEVARS
 ;
 W !!
 W "Debug Routine ",BLRVERN," Begins:",!!
 ;
 S DEBUG=1    ; Don't Send Alerts
 ;
 W !
 S XPDNM=CPSTR
 S XPDENV=0
 ;
 D PRE
 Q:XPDABORT
 ;
 W !!!
 ;
 D ^XBFMK
 S DIR(0)="YO"
 S DIR("B")="NO"
 S DIR("A")="Test Post Install Code"
 D ^DIR
 ;
 D:+$G(Y)=1 POST
 ;
 W !!,"Debug Routine ",BLRVERN," Ends.",!!
 Q
 ;
POST ; EP - Post-Install
 NEW (DEBUG,DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 D SETEVARS
 ;
 S TODAY=$$DT^XLFDT
 S WOTCNT=$$WOTCNT(BLRVERN)
 ;
 D REFLABCH   ; Reference Lab Changes
 ;
 D BLANK,BMES^XPDUTL("Laboratory Patch "_CPSTR_" INSTALL complete."),BLANK
 ;
 Q:+$G(DEBUG)
 ;
 D POSTMAIL(BLRVERN,CPSTR)
 ;
 S ^XTMP(BLRVERN,TODAY,WOTCNT,"END")=$$NOW^XLFDT
 Q
 ;
SAVEOFF ; EP - Save off all routines being updated by this patch into the ^rBACKUP global.
 NEW (DEBUG,DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 I +$G(DEBUG) D BLANK,OKAY^BLRKIDSU("DEBUG: SAVEOFF^BLRPRE37",4)  Q     ; If DEBUG, just print message & quit
 ;
 S PATCH=$P($T(+2),"*",3)
 ;
 F RTN="BLRLINK4","BLRRLEDI","BLRRLU","BLRSGNS3","LR7OF1"  D
 . S RTNPATCH=$RE($P($RE($TR($P($G(^ROUTINE(RTN,0,2)),";",5),"*")),","))
 . Q:RTNPATCH'<PATCH  ; Only versions < this patch
 . ;
 . K ERRS,RTNA
 . F LN=0:1:$G(^ROUTINE(RTN,0,0))  S RTNA(LN)=$G(^ROUTINE(RTN,0,LN))
 . S X=$$ROUTINE^%R(RTN_".INT",.RTNA,.ERRS,"CSB")
 . S NOW=$H
 . S ^BLRINSTL("LAB PATCH",PATCH,"SAVEOFF",NOW)=$$HTE^XLFDT(NOW,"5MZ")
 . S ^BLRINSTL("LAB PATCH",PATCH,"SAVEOFF",NOW,RTN)=$S($D(ERRS)>1:"ERRORS",1:"OK")
 Q
 ;
 ;
 ; ========================= UTILITIES FOLLOW ==========================
 ;
SETEVARS ; EP - SET standard "Enviroment" VARiables.
 S (CP,PATCHNUM)=$P($T(+2),"*",3)
 S CPSTR="LR*5.2*"_CP
 S BLRVERN=$TR($P($T(+1),";")," ")
 Q
 ;
BLANK ; EP - Blank Line
 D MES^XPDUTL("")
 Q
 ;
MESCNTR(STR) ; EP - Center a line and use XPDUTL to display it
 D MES^XPDUTL($$CJ^XLFSTR(STR,IOM))
 Q
 ;
WOTCNT(BLRVERN) ; EP - Counter for ^XTMP
 NEW CNT,TODAY
 ;
 S TODAY=$$DT^XLFDT
 ;
 S CNT=1+$G(^XTMP(BLRVERN,0,TODAY))
 S ^XTMP(BLRVERN,0,TODAY)=CNT
 Q $TR($J(CNT,3)," ","0")
 ;
INITSCR ; EP - Initialize screen. Cloned from INIT^XPDID
 N X,XPDSTR
 I IO'=IO(0)!(IOST'["C-VT") S XPDIDVT=0 Q
 I $T(PREP^XGF)="" S XPDIDVT=0 Q
 D PREP^XGF
 S XPDIDVT=1,X="IOSTBM",XPDSTR=""
 D ENDR^%ZISS
 S IOTM=3,IOBM=IOSL-4
 W @IOSTBM
 D FRAME^XGF(IOTM-2,0,IOTM-2,IOM-1) ; Top line
 ; D FRAME^XGF(IOBM+1,0,IOBM+1,IOM-1) ; Bottom line
 D IOXY^XGF(IOTM-2,0)
 Q
 ;
 ;
POSTMAIL(BLRVERN,CPSTR) ; EP - Post Install MailMan Message
 NEW STR
 ;
 S STR(1)=" "
 S STR(2)=$J("",10)_"POST INSTALL of "_BLRVERN_" Routine."
 S STR(3)=" "
 S STR(4)=$J("",15)_"Laboratory Patch "_CPSTR_" INSTALL completed."
 S STR(5)=" "
 ;
 Q:+$G(DEBUG)   ; No MailMan messages during debugging
 ;
 ; Send E-Mail to LMI Mail Group & Installer
 D MAILALMI^BLRUTIL3("Laboratory Patch "_CPSTR_" INSTALL complete.",.STR,BLRVERN)
 ;
 Q
 ;
REFLABCH ; EP - Post Install Reference Lab changes
 NEW FDA,ERRORS
 ;
 D BMES^XPDUTL("IHS Reference Lab Changes.")
 ;
 ; Schedule BLR REFLAB PURGE QUE ORDER option to run every 30 days
 D TABMESG^BLRKIDSU("Adding BLR REFLAB PURGE QUE ORDER option to OPTION SCHEDULING (#19.2) file.",5)
 ; First, put into file 19.2
 D ^XBFMK
 K FDA,ERRORS
 S FDA(19.2,"?+1,",.01)="BLR REFLAB PURGE QUE ORDER"
 S FDA(19.2,"?+1,",5)=$NAMESPACE
 S FDA(19.2,"?+1,",9)="P"
 D UPDATE^DIE("ES","FDA",,"ERRORS")
 ;
 ; Now, put in the schedule - every 30 days at 2300, starting today
 I $D(ERRORS)<1 D
 . W !,?9
 . D RESCH^XUTMOPT("BLR REFLAB PURGE QUE ORDER",DT_.2300,,"30D")
 . D BLANK,OKAY^BLRKIDSU("Added to 19.2 and has been scheduled.",10)
 ;
 D TABMESG^BLRKIDSU("Adding options to the Reference Lab Main Menu",5)
 D ADDOPTS^BLRKIDS2("BLRREFLABMENU","BLR REFLAB PURGE QUE ORDER","QPO")
 D ADDOPTS^BLRKIDS2("BLRREFLABMENU","BLR REFLAB PURGE ORD ACC FILE","PO")
 ;
 D BMES^XPDUTL("IHS Reference Lab Changes. OK.")
 Q
