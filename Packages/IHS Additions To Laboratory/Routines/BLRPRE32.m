BLRPRE32 ; IHS/OIT/MKK - IHS Lab Patch 1032 Pre/Post/Environment Routine ; [ February 29, 2012 8:00 AM ]
 ;;5.2;IHS LABORATORY;**1032**;NOV 01, 1997
 ;
PRE ; EP
 NEW CP,PREREQ,RPMS,RPMSVER,QFLG,ROWSTARS,STR
 NEW ERRARRAY                 ; Errors array
 ;
 D BMES^XPDUTL("Beginning of Pre Check.")
 ;
 I $G(XPDNM)="" D  Q
 . S CP=$TR($P($T(+2),";",5),"*")
 . D SORRY^BLRPRE31(CP,"XPDNM not defined or 0.")
 ;
 S CP=$P(XPDNM,"*",3)        ; Patch Number
 S RPMS=$P(XPDNM,"*",1)      ; RPMS Module
 S RPMSVER=$P(XPDNM,"*",2)   ; RPMS Version
 ;
 S ROWSTARS=$TR($J("",65)," ","*")     ; Row of asterisks
 ;
USERID ; EP - CHECK FOR USER ID
 I +$G(DUZ)<1 D SORRY^BLRPRE31(CP,"DUZ UNDEFINED OR 0.")  Q
 ;
 I $P($G(^VA(200,DUZ,0)),U)="" D SORRY^BLRPRE31(CP,"Installer cannot be identified!")  Q
 ;
GETREADY ; EP
 S XPDNOQUE=1           ; No Queuing Allowed
 ;
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 F X="XPO1","XPZ1","XPZ2","XPI1" S XPDDIQ(X)=0,XPDDIQ(X,"B")="NO"
 ;
 S XPDABORT=0           ; KIDS install Flag
 ;
 D HOME^%ZIS            ; Reset/Initialize IO variables
 D DTNOLF^DICRW         ; Set DT variable without a Line Feed
 ;
ENVICHEK ; Environment Checker
 D ENVHEADR(CP,RPMSVER,RPMS)
 ;
 D NEEDIT^BLRPRE31(CP,"LR","5.2",1031,.ERRARRAY)  ; Lab Pre-Requisites
 ;
 D MES^XPDUTL("")
 ;
 I XPDABORT>0 D SORRYEND^BLRPRE31(.ERRARRAY,CP)   Q   ; ENVIRONMENT HAS ERROR(S)
 ;
 D BOKAY^BLRPRE31("ENVIRONMENT")
 ;
 Q
 ;
ENVHEADR(CP,RPMSVER,RPMS) ; EP -- Environment Header
 NEW FULLNAME,LINE1,LINE2,STARS,TIMESTR
 S STARS=$TR($J("",IOM)," ","*")
 ;
 S LINE1="@Checking@Environment@for@Patch@"_CP_"@of@"
 S LINE2=$TR($$CJ^XLFSTR("@Version@"_RPMSVER_"@of@the@"_$TR("Laboratory Service Package"," ","@")_"@",$L(LINE1))," ","@")
 S LINE1=$TR($$CJ^XLFSTR(LINE1,$L(LINE2))," ","@")    ; Make LINE1 same width as LINE2.
 ;
 S TIMESTR=$TR($$CJ^XLFSTR("at "_$$UP^XLFSTR($$HTE^XLFDT($H,"5MPZ")),$L(LINE2))," ","@")
 ;
 D ^XBCLS
 W STARS,!
 W $TR($$CJ^XLFSTR(LINE1,IOM)," @","* "),!
 W $TR($$CJ^XLFSTR(LINE2,IOM)," @","* "),!
 W $TR($$CJ^XLFSTR(TIMESTR,IOM)," @","* "),!
 W STARS,!
 Q
 ;
POST ; EP -- POST INSTALL
 NEW CP,POSTMSG,STR
 ;
 S CP=$P($T(+2),"*",3)  ; Current Patch
 S POSTMSG="Laboratory Patch "_CP_" INSTALL completed."
 ;
 ; Store # of times installation occurred as well as person & date/time
 D ENDINSTL^BLRPRE31(CP)
 ;
 D BMES^XPDUTL("Laboratory Patch "_CP_" INSTALL complete.")
 ;
 S STR(1)=" "
 S STR(2)=$J("",10)_"POST INSTALL of BLRPRE32 Routine."
 S STR(3)=" "
 S STR(4)=$J("",15)_POSTMSG
 S STR(5)=" "
 ;
 D MAILALMI^BLRUTIL3(POSTMSG,.STR,"IHS Lab Patch 1032")
 ;
 Q
 ;
DEBUG ; EP - Debugging Line Label for environment checker
 NEW CP,DEBUG,RPMS,RPMSVER,QFLG,STR
 W !!
 W "Debug BLRPRE32.",!!
 ;
 ; Note -- DEBUG is a negative flag:
 ;         YES="Don't Send Alerts"; NO="Send Alerts"
 S DEBUG="YES"
 D ^XBFMK
 S DIR(0)="YO"
 S DIR("B")="NO"
 S DIR("A")="Send Alerts/E-Mails"
 D ^DIR
 S:+$G(Y)=1 DEBUG="NO"
 ;
 W !
 S XPDNM="LR*5.2*1032"
 S XPDENV=0
 ;
 D PRESSKEY^BLRGMENU(4)
 ;
 D PRE
 W !!!
 ;
 D ^XBFMK
 S DIR(0)="YO"
 S DIR("B")="NO"
 S DIR("A")="Test Post Install Code"
 D ^DIR
 ;
 D:+$G(Y)=1 POST
 W !!!
 ;
 Q
 ;
BCKUPRPT ; EP - Report on the BLRINSTL global
 NEW CNT,HD1,HEADER,LINES,MAXLINES,PG,QFLG
 NEW BACKUP,BCKUPDT,BCKUPWHO,HOWMANY,INSTLDT,INSTLWHO,PATCH
 ;
 S HEADER(1)="^BLRINSTL Global Report"
 S HEADER(2)="Lab Package Installation"
 S HEADER(3)=" "
 S $E(HEADER(4),4)="Patch"
 S $E(HEADER(4),11)="#"
 S $E(HEADER(4),15)="Who Installed"
 S $E(HEADER(4),45)="Install Date/Time"
 S MAXLINES=20,LINES=MAXLINES+10,PG=0,(HD1,QFLG)="NO"
 ;
 S PATCH=1018
 F  S PATCH=$O(^BLRINSTL("LAB PATCH",PATCH))  Q:PATCH<1!(QFLG="Q")  D
 . S HOWMANY=0
 . F  S HOWMANY=$O(^BLRINSTL("LAB PATCH",PATCH,"INSTALLED BY",HOWMANY))  Q:HOWMANY<1!(QFLG="Q")  D
 .. I LINES>MAXLINES D HEADERPG^BLRGMENU(.PG,QFLG,HD1)  Q:QFLG="Q"
 .. ;
 .. S INSTLWHO=$G(^BLRINSTL("LAB PATCH",PATCH,"INSTALLED BY",HOWMANY))
 .. S:INSTLWHO["^" INSTLWHO=$P(INSTLWHO,"^",2)
 .. S INSTLDT=$G(^BLRINSTL("LAB PATCH",PATCH,"INSTALLED BY",HOWMANY,"DATE/TIME"))
 .. ;
 .. W ?4,PATCH
 .. W ?9,$J(HOWMANY,2)
 .. W ?14,INSTLWHO
 .. W ?44,INSTLDT
 .. W !
 .. S LINES=LINES+1
 ;
 D ^XBFMK
 S DIR(0)="YO"
 S DIR("A")="BACKUP LISTING"
 S DIR("B")="YES"
 D ^DIR
 I +$G(Y)'=1 D  Q
 . W !,?4,"No BACKUP report requested from ^BLRINSTL global.  Routine Ends.",!
 . D PRESSKEY^BLRGMENU(9)
 ;
 S MAXLINES=20,LINES=MAXLINES+10,PG=0,(HD1,QFLG)="NO"
 ;
 K HEADER(2)
 S HEADER(2)="Backup Confirmation"
 ;
 K HEADER(4)
 S $E(HEADER(4),4)="Patch"
 S $E(HEADER(4),11)="#"
 S $E(HEADER(4),15)="Who Confirmed"
 S $E(HEADER(4),45)="When Confirmed"
 ;
 S PATCH=1018
 F  S PATCH=$O(^BLRINSTL("LAB PATCH",PATCH))  Q:PATCH<1!(QFLG="Q")  D
 . S HOWMANY=0
 . F  S HOWMANY=$O(^BLRINSTL("LAB PATCH",PATCH,"BACKUP CONFIRMED BY",HOWMANY))  Q:HOWMANY<1!(QFLG="Q")  D
 .. I LINES>MAXLINES D HEADERPG^BLRGMENU(.PG,QFLG,HD1)  Q:QFLG="Q"
 .. ;
 .. S INSTLWHO=$G(^BLRINSTL("LAB PATCH",PATCH,"BACKUP CONFIRMED BY",HOWMANY))
 .. S:INSTLWHO["^" INSTLWHO=$P(INSTLWHO,"^",2)
 .. S INSTLDT=$G(^BLRINSTL("LAB PATCH",PATCH,"BACKUP CONFIRMED BY",HOWMANY,"DATE/TIME"))
 .. ;
 .. W ?4,PATCH
 .. W ?9,$J(HOWMANY,2)
 .. W ?14,INSTLWHO
 .. W ?44,INSTLDT
 .. W !
 .. S LINES=LINES+1
 Q
