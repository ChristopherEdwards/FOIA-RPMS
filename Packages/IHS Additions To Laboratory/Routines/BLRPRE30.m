BLRPRE30 ; IHS/OIT/MKK - IHS Lab PATCH 1030 PRE/POST/Environment Routine ; [ JUNE 25, 2010 9:58 AM ]
 ;;5.2;IHS LABORATORY;**1030**;NOV 01, 1997
 ;
PRE ; EP
 NEW CP,PREREQ,RPMS,RPMSVER,QFLG,ROWSTARS,STR
 NEW ERRARRAY                 ; Errors array
 ;
 D BMES^XPDUTL("Beginning of Pre Check.")
 ;
 I $G(XPDNM)="" D  Q
 . S CP=$TR($P($T(+2),";",5),"*")
 . D SORRY(CP,"XPDNM not defined or 0.")
 ;
 S CP=$P(XPDNM,"*",3)        ; Current Patch Number
 S RPMS=$P(XPDNM,"*",1)      ; RPMS Module
 S RPMSVER=$P(XPDNM,"*",2)   ; Version of RPMS module being patched
 ;
 S ROWSTARS=$TR($J("",65)," ","*")     ; Row of asterisks
 ;
USERID ; EP - CHECK FOR USER ID
 I +$G(DUZ)<1 D SORRY(CP,"DUZ UNDEFINED OR 0.")  Q
 ;
 I $P($G(^VA(200,DUZ,0)),U)="" D SORRY(CP,"Installer cannot be identified!")  Q
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
 D CHKMAILG(CP,"LMI",.ERRARRAY)              ; Check for LMI Mail Group
 D CHKMAILG(CP,"LAB MESSAGING",.ERRARRAY)    ; Check for LAB MESSAGING Mail Group
 ;
 D NEEDIT(CP,"LR","5.2","1029",.ERRARRAY)    ; Lab Pre-Requisites
 ;
 D NEEDIT(CP,"XM","8.0",,.ERRARRAY)          ; MAILMAN 8.0
 D NEEDIT(CP,"XU","8.0",1015,.ERRARRAY)      ; XU*8.0*1015 (Kernel)
 D NEEDIT(CP,"PIMS","5.3",,.ERRARRAY)        ; PIMS 5.3
 D NEEDIT(CP,"PXRM","1.5",1,.ERRARRAY)       ; PXRM*1.5*1 (CLINICAL REMINDERS)
 D NEEDIT(CP,"TIU","1.0",137,.ERRARRAY)      ; TIU*1.0*137
 D NEEDIT(CP,"USR","1.0",23,.ERRARRAY)       ; USR*1.0*23 (AUTHORIZATION/SUBSCRIPTION)
 ;
 I XPDABORT>0 D SORRYEND(.ERRARRAY,CP)   Q   ; ENVIRONMENT HAS ERROR(S)
 ;
 D BOKAY("ENVIRONMENT")
 ;
 Q
 ;
POST ; EP -- POST INSTALL
 NEW CP,STR,TAB
 ;
 S CP=$P($T(+2),"*",3)  ; Current Patch
 ;
 D NEWEAG^BLRPR30P
 ;
 S TAB=$J("",5)
 ;
 ; Store # of times installation occurred as well as person & date/time
 D ENDINSTL(CP)
 ;
 D BMES^XPDUTL("Laboratory Patch "_CP_" INSTALL complete.")
 ;
 D SNDALERT("Laboratory Patch "_CP_" INSTALL complete.")
 ;
 S STR(1)=" "
 S STR(2)=$J("",10)_"POST INSTALL of BLRPRE30 Routine."
 S STR(3)=" "
 S STR(4)=$J("",15)_"Laboratory Patch "_CP_" INSTALL completed."
 S STR(5)=" "
 D SENDMAIL("Laboratory Patch "_CP_" INSTALL complete.")
 ;
 Q
 ;
DEBUG ; EP - Debugging Line Label for environment checker
 NEW CP,RPMS,RPMSVER,QFLG,STR
 W !!
 W "Debug BLRPRE30.",!!
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
 S XPDNM="LR*5.2*1030"
 S XPDENV=0
 ;
 D BACKUPS
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
PRESSKEY(TAB,MSGSTR)                          ; EP
 NEW TABSTR
 S TABSTR=$J("",+$G(TAB))_$S(+$L($G(MSGSTR)):$G(MSGSTR),1:"Press RETURN Key")
 ;
 W !
 D ^XBFMK
 S DIR(0)="E"
 S DIR("A")=TABSTR
 D ^DIR
 I $G(DUOUT) S QFLG="Q"      ; If Fileman quit, then set Quit Flag
 ;
 Q
 ;
ENVHEADR(CP,RPMSVER,RPMS) ; EP -- Environment Header
 NEW STARS,STR
 S STARS=$TR($J("",IOM)," ","*")
 ;
 S STR="@Checking@Environment@for@Patch@"
 S STR=STR_CP_"@of@Version@"
 S STR=STR_RPMSVER_"@of@"
 S STR=STR_$TR(RPMS," ","@")_".@"
 ;
 D ^XBCLS
 W STARS,!
 W $TR($$CJ^XLFSTR(STR,IOM)," @","* "),!
 W STARS,!
 Q
 ;
BOKAY(MSG,TAB)       ; EP -- Write out Blank line, then "OKAY" message
 D BMES^XPDUTL($J("",+$G(TAB))_MSG_" OK.")
 Q
 ;
ENDINSTL(CURPATCH)       ; EP
 NEW INSTCNT                        ; Installation count
 ;
 S INSTCNT=1+$O(^BLRINSTL("LAB PATCH",CURPATCH,"INSTALLED BY",""),-1)
 ;
 S ^BLRINSTL("LAB PATCH",CURPATCH,"INSTALLED BY",INSTCNT)=$P($G(^VA(200,DUZ,0)),U)
 S ^BLRINSTL("LAB PATCH",CURPATCH,"INSTALLED BY",INSTCNT,"DATE/TIME")=$$HTE^XLFDT($H,"5Z")
 Q
 ;
 ; Error Message routine.
SORRY(CP,MSG,MODE,MSG2)    ; EP
 NEW MESSAGE,ROWSTARS
 ;
 S ROWSTARS=$TR($J("",65)," ","*")     ; Row of asterisks
 ;
 S MODE=$G(MODE,"FATAL")
 ;
 I $G(MODE)="FATAL" D
 . S MESSAGE="Install Aborting due to the following Systems Environment issue:"
 . S XPDABORT=1    ; Fatal Error Flag Set
 ;
 I $G(MODE)["NONFATAL" S MESSAGE="*** WARNING *** WARNING *** WARNING ***"
 ;
 K DIFQ
 ;
 ; STR Array will be used to write to the screen, send E-Mail & Alert
 NEW STR,LINECNT,MODESTR
 S LINECNT=1
 D ADDLINE(.LINECNT)
 D ADDLINE(.LINECNT,ROWSTARS)
 D ADDLINE(.LINECNT)
 D ADDLINE(.LINECNT,"Site: "_$$LOC^XBFUNC,"YES")
 D ADDLINE(.LINECNT)
 D ADDLINE(.LINECNT,MESSAGE,"YES")
 D ADDLINE(.LINECNT)
 D BANNERL(.LINECNT,MSG)
 D:$D(MSG2) BANNERL(.LINECNT,MSG2)
 D ADDLINE(.LINECNT)
 ;
 I $G(MODE)["NONFATAL" D ADDLINE(.LINECNT,MESSAGE,"YES")
 ;
 I $G(MODE)="FATAL" D
 . D ADDLINE(.LINECNT,"Please print/capture this screen and","YES")
 . D ADDLINE(.LINECNT,"notify the Support Center at","YES")
 . D ADDLINE(.LINECNT)
 . D ADDLINE(.LINECNT,"1-888-830-7280.","YES")
 . D ADDLINE(.LINECNT)
  ;
 D ADDLINE(.LINECNT,ROWSTARS)
 D ADDLINE(.LINECNT)
 ;
 D BMES^XPDUTL(.STR)
 ;
 I $G(DEBUG)="YES" Q
 ;
 S MODESTR=$S(MODE="FATAL":" >> FATAL << ",1:" - NONFATAL - ")
 D SNDALERT("Laboratory Patch "_CP_MODESTR_MSG)
 D SENDMAIL("IHS Lab Patch "_CP_" Install "_MODE_" Error")
 Q
 ;
SNDALERT(ALERTMSG) ; EP - Send alert to LMI group AND Installer
 Q:$G(DEBUG)="YES"
 ;
 S XQAMSG=ALERTMSG
 S XQA("G.LMI")=""
 ;
 ; If installer not part of LMI Mail Group, send them alert also
 S:$$NINLMI(DUZ) XQA(DUZ)=""
 ;
 D SETUP^XQALERT
 K XQA,XQAMSG
 Q
 ;
NINLMI(CHKDUZ) ; EP -- Check to see if DUZ is NOT part of LMI Mail Group
 NEW MGRPIEN,XMDUZ
 ;
 ; Get IEN of LMI MaiL Group
 D CHKGROUP^XMBGRP("LMI",.MGRPIEN)     ; VA DBIA 1146
 Q:+(MGRPIEN)<1 1                      ; If no Mail Group, return TRUE
 ;
 ; XMDUZ = DUZ of the user
 ; Y     = IEN of the mail group
 S XMDUZ=DUZ
 S Y=MGRPIEN
 D CHK^XMA21                           ; VA DBIA 10067
 ;
 Q $S($T=1:0,1:1)
 ;
SENDMAIL(SUBJECT) ; EP -- Send MailMan E-mail to LMI group AND Installer
 Q:$G(DEBUG)="YES"
 ;
 NEW DIFROM
 ;
 K XMY
 S XMY("G.LMI")=""
 ;
 ; If installer not part of LMI Mail Group, send them e-mail also
 S:$$NINLMI(DUZ) XMY(DUZ)=""
 ;
 S LRBLNOW=$E($$NOW^XLFDT,1,12)
 ;
 S XMSUB=SUBJECT
 S XMTEXT="STR("
 S XMDUZ="Lab Patch "_$P($T(+2),"*",3)      ; Current Patch
 S XMZ="NOT OKAY"
 D ^XMD
 ;
 I $G(XMMG)'=""!(XMZ="NOT OKAY") D
 . D BMES^XPDUTL($J("",5)_"MAILMAN ERROR.")
 . D BMES^XPDUTL($J("",10)_"XMZ:"_XMZ)
 . D BMES^XPDUTL($J("",10)_"XMMG:"_XMMG)
 ;
 K X,XMDUZ,XMSUB,XMTEXT,XMY,XMZ,Y   ; Cleanup
 Q
 ;
ADDLINE(LC,ASTR,CENTER) ; EP -- Add a line to the STR array; CENTER if requested
 I $G(ASTR)="" S ASTR=" "
 S STR(LC)=$S($G(CENTER)="YES":$$CJ^XLFSTR(ASTR,65),1:$G(ASTR))
 S LC=LC+1
 Q
 ;
SORRYEND(WOTERR,CP) ; EP -- ALL the errors detected during the environment check.
 NEW STR,MODULE,NAME,VERSION,PATCH,LINECNT,TMP
 ;
 D SORRYHED
 ;
 S (MODULE,NAME,VERSION)=""
 F  S MODULE=$O(WOTERR(MODULE))  Q:MODULE=""  D
 . F  S NAME=$O(WOTERR(MODULE,NAME))  Q:NAME=""  D
 .. F  S VERSION=$O(WOTERR(MODULE,NAME,VERSION))  Q:VERSION=""  D
 ... D ADDMESG
 ;
 D SORRYFIN
 ;
 D BMES^XPDUTL(.STR)
 ;
 Q
 ;
SORRYHED ; EP -- "Header" of Final Fatal Message
 S LINECNT=1
 D ADDLINE(.LINECNT)
 D ADDLINE(.LINECNT,ROWSTARS)
 D ADDLINE(.LINECNT)
 D ADDLINE(.LINECNT,"Systems Environment Error Detected","YES")
 D ADDLINE(.LINECNT,"KIDS build will be deleted","YES")
 D ADDLINE(.LINECNT)
 D ADDLINE(.LINECNT,"Modules with Version or Patch errors","YES")
 D ADDLINE(.LINECNT)
 Q
 ;
ADDMESG ; EP
 NEW WOT
 ;
 D ADDLINE(.LINECNT,NAME_" ("_MODULE_")","YES")
 ;
 S WOT=$G(WOTERR(MODULE,NAME,VERSION))
 S TMP="Version:"_VERSION
 I $P(WOT,"^",2)="VERSION" D
 . S TMP="Needed Version:"_VERSION
 . S TMP=TMP_"  Found Version:"_$P(WOT,"^")
 I $P(WOT,"^",2)="PATCH" D
 . S TMP=TMP_"  Needed Patch:"_$P(WOT,"^")
 ;
 D ADDLINE(.LINECNT,TMP,"YES")
 D ADDLINE(.LINECNT)
 Q
 ;
SORRYFIN ; EP -- "Fin" of Final Fatal Message
 D ADDLINE(.LINECNT,"Re-Installation will be necessary.","YES")
 D ADDLINE(.LINECNT)
 D ADDLINE(.LINECNT,"If assistance is needed, please call 1-888-830-7280.","YES")
 D ADDLINE(.LINECNT)
 D ADDLINE(.LINECNT,ROWSTARS)
 D ADDLINE(.LINECNT)
 Q
 ;
CHKMAILG(CP,MAILGRP,ERRARRAY)   ; Determine if required Mail Group Exists
 NEW MGRPIEN
 D CHKGROUP^XMBGRP(MAILGRP,.MGRPIEN)   ; VA DBIA 1146
 I MGRPIEN D  Q
 . D OKAY^BLRKIDSU(MAILGRP_" Mail Group Exists.")
 ;
 D BMES^XPDUTL("")
 D SORRY(CP,MAILGRP_" Mail Group Does NOT Exist!")
 S ERRARRAY("XMB","Mail Group","3.8")=MAILGRP_" Mail Group"
 Q
 ;
BANNERL(LC,ASTR) ; EP -- Stores "Banner" Line in STR array
 ;
 S STR(LC)=$$MKBANNRL(ASTR)
 S LC=LC+1
 Q
 ;
MKBANNRL(ASTR) ; EP - MaKe the BANNeR Line
 NEW HALFLEN,J,RM,STRLEN,TMPSTR
 ;
 S RM=65      ; Right Margin
 ;
 S HALFLEN=(RM\2)-(($L(ASTR)+2)\2)
 S TMPSTR=$TR($J("",HALFLEN)," ",">")
 S TMPSTR=TMPSTR_" "_ASTR_" "
 S STRLEN=$L(TMPSTR)
 F J=STRLEN:1:(RM-1) S TMPSTR=TMPSTR_"<"
 Q TMPSTR
 ;
 ; Generic "Find RPMS Module's Version and (perhaps) Patch number"
 ; The MODULE variable MUST be the PREFIX name from the PACKAGE file (9.4).
NEEDIT(CP,MODULE,VERSION,PATCH,ERRARRAY)      ; EP
 NEW NAME                    ; NAME of PACKAGE
 NEW PTR                     ; PoinTeR to PACKAGE file
 NEW HEREYAGO,STR1,STR2      ; Scratch variables/arrays
 NEW SYSVER,SYSPATCH         ; System Version & System Patch variables
 NEW NAMEVER,NAMESYS
 ;
 D FIND^DIC(9.4,"",,,MODULE,,"C",,,"HEREYAGO")
 S PTR=$G(HEREYAGO("DILIST",2,1))
 S NAME=$G(HEREYAGO("DILIST",1,1))
 ;
 S SYSVER=+$$VERSION^XPDUTL(MODULE)    ; Get Current Version #
 ;
 S NAMEVER=NAME_" "_VERSION,NAMESYS=NAME_" "_SYSVER
 ;
 ; If Current Version < Needed Version, write message and quit
 I SYSVER<VERSION D  Q
 . S ERRARRAY(MODULE,NAME,VERSION)=SYSVER_"^VERSION"
 . D:SYSVER>0 NEEDMSG("Need "_NAMEVER_" & "_NAMESYS_" found!")
 . D:SYSVER<1 NEEDMSG("Need "_MODULE_" & "_MODULE_" Not Installed!")
 ;
 ; If System Version > Needed Version, write message and quit
 I VERSION<SYSVER D OKAY^BLRKIDSU("Need "_NAMEVER_" & "_NAMESYS_" found.",5)  Q
 ;
 I $G(PATCH)="" D  Q   ; If no Patch check, write message and quit
 . D OKAY^BLRKIDSU(NAMEVER_" found.",5)
 ;
 S SYSPATCH=$$PATCH^XPDUTL(MODULE_"*"_VERSION_"*"_PATCH)
 I SYSPATCH'=1 D  Q
 . S ERRARRAY(MODULE,NAME,VERSION)=$G(PATCH)_"^PATCH"
 . D NEEDMSG(NAMEVER_" & Patch "_PATCH_" WAS NOT installed!")
 ;
 D OKAY^BLRKIDSU(NAMEVER_" Patch "_PATCH_" found.",5)
 ;
 Q
 ;
NEEDMSG(MESSAGE) ; EP
 NEW STR1,STR2
 ;
 S STR1=MESSAGE
 I $L(STR1)<58 D SORRY(CP,STR1)  Q
 ;
 S STR1=$P(MESSAGE,"&")_" &"
 S STR2=$$TRIM^XLFSTR($P(MESSAGE,"&",2),"L"," ")
 D SORRY(CP,STR1,,STR2)
 Q
 ;
PASSMESG(WOT) ; EP -- Splash message
 NEW MAXIT,AROUND
 ;
 S MAXIT="@"
 F J=1:1:$L(WOT) S MAXIT=MAXIT_$E(WOT,J,J)_"@"
 S AROUND=$TR($J("",8+$L(MAXIT))," ","@")
 S MAXIT="@@!!"_$TR(MAXIT," ","@")_"!!@@"
 ;
 D ^XBCLS
 W $TR($J("",IOM)," ","*"),!
 W $TR($J("",IOM)," ","*"),!
 W $TR($$CJ^XLFSTR(AROUND,IOM)," @","* "),!
 W $TR($$CJ^XLFSTR(MAXIT,IOM)," @","* "),!
 W $TR($$CJ^XLFSTR(AROUND,IOM)," @","* "),!
 W $TR($J("",IOM)," ","*"),!
 W $TR($J("",IOM)," ","*"),!
 Q
 ;
BACKUPS ; EP -- Ask for confirmation of Backup
 S CP=$P($T(+2),"*",3)  ; Current Patch
 D PASSMESG("ATTENTION")
 W !
 ;
 D ^XBFMK
 S DIR(0)="Y"
 S DIR("B")="NO"
 S DIR("A")=$J("",10)_"Has a "_$C(27)_"[1;7;5m"_">> SUCCESSFUL <<"_$C(27)_"[0m"_" backup been performed?"
 D ^DIR
 W !
 ;
 I +$G(Y)'=1 D  Q
 . S XPDABORT=1
 . D PASSMESG("ATTENTION")
 . D BMES^XPDUTL("")
 . D BMES^XPDUTL("")
 . D BMES^XPDUTL($J("",15)_"SUCCESSFUL system backup has >>> NOT <<< been confirmed.")
 . D BMES^XPDUTL($J("",15)_"Install Aborting.")
 ;
 ; Store backup confirmation person & date/time
 NEW BCKUPCNT                   ; Current Patch,Backup count
 S BCKUPCNT=1+$O(^BLRINSTL("LAB PATCH",CP,"BACKUP CONFIRMED BY",""),-1)
 S ^BLRINSTL("LAB PATCH",CP,"BACKUP CONFIRMED BY",BCKUPCNT)=DUZ_"^"_$P($G(^VA(200,DUZ,0)),U)
 S ^BLRINSTL("LAB PATCH",CP,"BACKUP CONFIRMED BY",BCKUPCNT,"DATE/TIME")=$$HTE^XLFDT($H,"5MZ")
 ;
 D BMES^XPDUTL("")
 D BMES^XPDUTL($J("",5)_"SUCCESSFUL system backup CONFIRMED by: "_$P($G(^VA(200,DUZ,0)),U))
 Q
