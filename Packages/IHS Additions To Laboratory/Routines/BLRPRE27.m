BLRPRE27 ;IHS/OIT/MKK - IHS Lab PATCH 1027 Environment Routine ;JUL 06, 2010 3:14 PM
 ;;5.2;IHS LABORATORY;**1027**;NOV 01, 1997
 ;
 ; TESTING ONE TWO THREE
 ;
PRE ; EP
 D BMES^XPDUTL("Beginning of Pre Check.")
 NEW CP,RPMS,RPMSVER,QFLG,STR
 NEW ERRARRAY                 ; Array of errors detected
 NEW ROWSTARS
 ;
 I $G(XPDNM)="" D SORRY("XPDNM not defined or 0.")  Q
 ;
 S CP=$P(XPDNM,"*",3)         ; Current Patch Number
 S RPMS=$P(XPDNM,"*",1)       ; RPMS Module
 S RPMSVER=$P(XPDNM,"*",2)    ; Version of RPMS module being patched
 ;
 S ROWSTARS=$TR($J("",65)," ","*")  ; Row of asterisks
 ;
USERID ; EP - CHECK FOR USER ID
 I +$G(DUZ)<1 D SORRY("DUZ UNDEFINED OR 0.")  Q
 ;
 I $P($G(^VA(200,DUZ,0)),U)="" D SORRY("Installer cannot be identified!")  Q
 ;
GETREADY ; EP
 S XPDNOQUE="NO QUE"          ; No Queuing Allowed
 ;
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 F X="XPO1","XPZ1","XPZ2","XPI1" S XPDDIQ(X)=0
 ;
 S XPDABORT=0                    ; KIDS install Flag
 ;
 D HOME^%ZIS             ; Reset/Initialize IO variables
 D DTNOLF^DICRW          ; Set DT variable without Doing a Line Feed
 ;
ENVICHEK ; Environment Checker
 NEW CHKPATCH
 ;
 D CHKENHED                              ; Header
 ;
 F CHKPATCH=46,61,62,63,65  D NEEDIT("LA","5.2",CHKPATCH,.ERRARRAY)
 D MES^XPDUTL(" ")
 F CHKPATCH=1005,1006  D NEEDIT("HL","1.6",CHKPATCH,.ERRARRAY)
 D MES^XPDUTL(" ")
 F CHKPATCH=261,1013  D NEEDIT("XU","8.0",CHKPATCH,.ERRARRAY)
 D MES^XPDUTL(" ")
 F CHKPATCH=187,202,220,222,230,232,256,261,269,271,282,283,285,287,312,1026  D
 . D NEEDIT("LR","5.2",CHKPATCH,.ERRARRAY)
 D MES^XPDUTL(" ")
 D CHECKLMI(.ERRARRAY)                   ; CHECK FOR LMI MAIL GROUP
 D MES^XPDUTL(" ")
 D NEEDIT("XM","8.0",,.ERRARRAY)         ; MAILMAN 8.0
 D MES^XPDUTL(" ")
 D NEEDIT("PIMS","5.3",,.ERRARRAY)       ; PIMS 5.3
 D MES^XPDUTL(" ")
 D NEEDIT("AUT","98.1","22",.ERRARRAY)   ; AUT 98.1 & PATCH 22
 D MES^XPDUTL(" ")
 D NEEDIT("DI","22.0",,.ERRARRAY)        ; VA FILEMAN 22.0
 D MES^XPDUTL(" ")
 ;
 I XPDABORT>0 D SORRYEND(.ERRARRAY,CP)   Q    ; ENVIRONMENT HAS ERROR(S)
 ;
 D BMES^XPDUTL("ENVIRONMENT OK.")
 ;
 Q
 ;
POST ; EP -- POST INSTALL
 NEW CP,STR
 ;
 S CP=$P($T(+2),"*",3)              ; Current Patch
 ;
 D ADDEAGDC^BLRPR27P                ; EAG Delta Check Addition -- POST Install
 ;
 ; Store # of times installation occurred as well as person & date/time
 D ENDINSTL^BLRKIDSU(CP)
 ;
 D SNDALERT("Laboratory Patch "_CP_" INSTALL complete.")
 ;
 S STR(1)=" "
 S STR(2)=$J("",10)_"POST INSTALL of BLRPRE27 Routine."
 S STR(3)=" "
 S STR(4)=$J("",15)_"Laboratory Patch "_CP_" INSTALL completed."
 S STR(5)=" "
 D SENDMAIL("Laboratory Patch "_CP_" INSTALL complete.")
 ;
 Q
 ;
CHKENHED ; EP -- Header
 NEW STR
 S STR=$TR($J("",IOM)," ","*")
 ;
 D ^XBCLS
 W STR,!
 W $TR($$CJ^XLFSTR("@Checking@Environment@for@Patch@"_CP_"@of@Version@"_RPMSVER_"@of@"_RPMS_".@",IOM)," @","* "),!
 W STR,!
 Q
 ;
DEBUG ; EP - Debugging Line Label for environment checker
 NEW CP,DEBUG,XPDNM
 W !!
 D PASSMESG^BLRPRE27("DEBUGGING@BLRPRE27")
 ;
 S DEBUG="YES"
 ;
 D ^XBFMK
 S DIR(0)="YO"
 S DIR("B")="NO"
 S DIR("A")="Send Alerts/E-Mails"
 D ^DIR
 S:+$G(Y)=1 DEBUG="NO"
 ;
 W !
 S XPDNM="LR*5.2*1027"
 S XPDENV=0
 D PRE
 ;
 W !!
 D ^XBFMK
 S DIR(0)="YO"
 S DIR("B")="NO"
 S DIR("A")="Debug POST Install Code"
 D ^DIR
 ;
 D:+$G(Y)=1 POST
 ;
 W !!,$TR($J("",IOM)," ","*"),!
 W $TR($$CJ^XLFSTR("@DEBUGGING@BLRPRE27@Complete.@",IOM)," @","* "),!
 W $TR($J("",IOM)," ","*"),!!
 ;
 Q
 ;
 ; Error Message routine.
SORRY(MSG,MODE,MSG2)       ; EP
 NEW MESSAGE,ROWSTARS
 ;
 S CP=$P($T(+2),"*",3)              ; Current Patch
 S ROWSTARS=$TR($J("",65)," ","*")  ; Row of asterisks
 ;
 S MODE=$G(MODE,"FATAL")
 ;
 I $G(MODE)="FATAL" D
 . S MESSAGE="Install Aborting due to the following Systems Environment issue:"
 . S XPDABORT=1     ; Fatal Error Flag Set
 ;
 I $G(MODE)["NONFATAL" S MESSAGE="*** WARNING *** WARNING *** WARNING ***"
 ;
 K DIFQ
 ;
 ; STR Array will be used to write to the screen, send E-Mail & Alert
 NEW STR,LINECNT
 S LINECNT=1
 D ADDLINE(" ",.LINECNT)
 D ADDLINE(ROWSTARS,.LINECNT)
 D ADDLINE(" ",.LINECNT)
 D ADDLINE("Site: "_$$LOC^XBFUNC,.LINECNT,"YES")
 D ADDLINE(" ",.LINECNT)
 D ADDLINE(MESSAGE,.LINECNT,"YES")
 D ADDLINE(" ",.LINECNT)
 D ADDLINE(">>> "_MSG_" <<<",.LINECNT,"YES")
 I $D(MSG2) D ADDLINE(">>> "_MSG2_" <<<",.LINECNT,"YES")
 D ADDLINE(" ",.LINECNT)
 ;
 I $G(MODE)["NONFATAL" D ADDLINE(MESSAGE,.LINECNT,"YES")
 ;
 I $G(MODE)="FATAL" D
 . D ADDLINE("Please print/capture this screen and",.LINECNT,"YES")
 . D ADDLINE("notify the Support Center at",.LINECNT,"YES")
 . D ADDLINE(" ",.LINECNT)
 . D ADDLINE("1-888-830-7280.",.LINECNT,"YES")
 . D ADDLINE(" ",.LINECNT)
  ;
 D ADDLINE(ROWSTARS,.LINECNT)    ; Row of asterisks
 D ADDLINE(" ",.LINECNT)
 ;
 D BMES^XPDUTL(.STR)
 ;
 I $G(DEBUG)="YES" Q
 ;
 I $G(MODE)="FATAL" D  Q
 . D SNDALERT("Laboratory Patch "_CP_" >> FATAL << "_MSG)
 . D SENDMAIL("IHS Lab Patch "_CP_" Install FATAL Error")
 ;
 D SNDALERT("Laboratory Patch "_CP_" - "_MODE_" - "_MSG)
 D SENDMAIL("IHS Lab Patch "_CP_" Install NONFATAL Error")
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
 D CHKGROUP^XMBGRP("LMI",.MGRPIEN)  ; VA DBIA 1146
 Q:+(MGRPIEN)<1 1                   ; If no Mail Group, return TRUE
 ;
 ; XMDUZ = DUZ of the user
 ; Y     = IEN of the mail group
 S XMDUZ=DUZ
 S Y=MGRPIEN
 D CHK^XMA21                        ; VA DBIA 10067
 ;
 Q $S($T=1:0,1:1)
 ;
SENDMAIL(MAILMSG) ; EP -- Send MailMan E-mail to LMI group AND Installer
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
 S XMSUB=MAILMSG
 S XMTEXT="STR("
 S XMDUZ="Lab Patch 1027"
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
ADDLINE(ASTR,LC,CENTER) ; EP -- Add a line to the STR array; CENTER if requested
 I $G(ASTR)="" S ASTR=" "
 S:$G(CENTER)'="YES" STR(LC)=ASTR
 S:$G(CENTER)="YES" STR(LC)=$$CJ^XLFSTR(ASTR,65)
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
 D ADDLINE(" ",.LINECNT)
 D ADDLINE(ROWSTARS,.LINECNT)
 D ADDLINE(" ",.LINECNT)
 D ADDLINE("Systems Environment Error Detected",.LINECNT,"YES")
 D ADDLINE("KIDS build will be deleted",.LINECNT,"YES")
 D ADDLINE(" ",.LINECNT)
 D ADDLINE("Modules with Version or Patch errors",.LINECNT,"YES")
 D ADDLINE(" ",.LINECNT)
 Q
 ;
ADDMESG ; EP
 NEW WOT
 ;
 D ADDLINE(NAME_" ("_MODULE_")",.LINECNT,"YES")
 ;
 S WOT=$G(WOTERR(MODULE,NAME,VERSION))
 S TMP="Version:"_VERSION
 I $P(WOT,"^",2)="VERSION" D
 . S TMP="Needed Version:"_VERSION
 . S TMP=TMP_"  Found Version:"_$P(WOT,"^")
 I $P(WOT,"^",2)="PATCH" D
 . S TMP=TMP_"  Needed Patch:"_$P(WOT,"^")
 ;
 D ADDLINE(TMP,.LINECNT,"YES")
 D ADDLINE(" ",.LINECNT)
 Q
 ;
SORRYFIN ; EP -- "Fin" of Final Fatal Message
 D ADDLINE("Re-Installation will be necessary.",.LINECNT,"YES")
 D ADDLINE(" ",.LINECNT)
 D ADDLINE("If assistance is needed, please call 1-888-830-7280.",.LINECNT,"YES")
 D ADDLINE(" ",.LINECNT)
 D ADDLINE(ROWSTARS,.LINECNT)
 D ADDLINE(" ",.LINECNT)
 Q
 ;
CHECKLMI(ERRARRAY) ; EP  -- CHECK FOR LMI MAIL GROUP
 NEW MGRPIEN
 D CHKGROUP^XMBGRP("LMI",.MGRPIEN)       ; VA DBIA 1146
 I MGRPIEN D  Q
 . D OKAY^BLRKIDSU("LMI Mail Group Exists.")
 ;
 D BMES^XPDUTL("")
 D SORRY("LMI Mail Group Does NOT Exist!")
 S ERRARRAY("XMB","Mail Group","3.8")="LMI Mail Group"
 Q
 ;
 ; Generic "Find RPMS Module's Version and (perhaps) Patch number"
 ; The MODULE variable MUST be the PREFIX name from the PACKAGE file (9.4).
NEEDIT(MODULE,VERSION,PATCH,ERRARRAY)      ; EP
 NEW NAME                ; NAME of PACKAGE
 NEW PTR                 ; PoinTeR to PACKAGE file
 NEW HEREYAGO,STR1,STR2  ; Scratch variables/arrays
 NEW SYSVER,SYSPATCH     ; System Version & System Patch variables
 NEW NAMEVER,NAMESYS
 ;
 D FIND^DIC(9.4,"",,,MODULE,,"C",,,"HEREYAGO")
 S PTR=+$G(HEREYAGO("DILIST",2,1))
 ;
 I PTR<1 D  Q      ; Modlue not installed on system -- write message and quit
 . S ERRARRAY(MODULE,MODULE,VERSION)="0^VERSION"
 . D NEEDMSG("Needed Module "_MODULE_" not Found!")
 ;
 S NAME=$G(HEREYAGO("DILIST",1,1))
 ;
 S SYSVER=$$VERSION^XPDUTL(MODULE)     ; Get the System's Version
 ;
 S NAMEVER=NAME_" "_VERSION,NAMESYS=NAME_" "_SYSVER
 ;
 ; If System Version < Needed Version, write message and quit
 I SYSVER<VERSION D  Q
 . S ERRARRAY(MODULE,NAME,VERSION)=SYSVER_"^VERSION"
 . D NEEDMSG("Need "_NAMEVER_" & "_NAMESYS_" found!")
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
 I $L(STR1)<58 D SORRY(STR1)  Q
 ;
 S STR1=$P(MESSAGE,"&")_" &"
 S STR2=$$TRIM^XLFSTR($P(MESSAGE,"&",2),"L"," ")
 D SORRY(STR1,,STR2)
 Q
 ;
MEGAWARN ; EP
 NEW CP
 ;
 S CP=$P($T(+2),"*",3)              ; Current Patch
 ;
 Q:$$BACKUPS="Q"
 ;
 Q:$$MAKESURE="Q"
 ;
 W !!
 D TEXTONGO
 D PRESSKEY(5)
 I $G(QFLG)="Q" D  Q
 . S XPDABORT=1
 . D BMES^XPDUTL("")
 . D BMES^XPDUTL($J("",15)_"Continue stopped.  Install Aborting.")
 . D BMES^XPDUTL("")
 ;
 D REALLYIN          ; Store info regarding person insisting on install
 Q
 ;
JUSTTXT() ; EP
 D PASSMESG("ATTENTION")
 W !
 D COMPLEX
 W ?5,"It is also critical that all Laboratorians are prepared for this patch.",!!
 W ?5,"Verify with the Lab Supervisor.",!
 Q $$MAKESURE
 ;
COMPLEX ; EP
 W ?5,"Due to the complexities of this install, it is absolutely imperative",!!
 W $$CJ^XLFSTR(">>> A VALID BACKUP EXISTS <<<",IOM),!!
 W ?5,"because there is no recovery possible except restoring from backup.",!!!
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
BACKUPS() ; EP -- Ask for confirmation of Backup
 D PASSMESG("ATTENTION")
 W !
 D COMPLEX
 ;
 D ^XBFMK
 S DIR(0)="Y"
 S DIR("B")="NO"
 S DIR("A")=$J("",10)_"Has a SUCCESSFUL system backup been performed??"
 D ^DIR
 W !
 ;
 I +$G(Y)'=1 D  Q "Q"
 . S XPDABORT=1
 . D PASSMESG("ATTENTION")
 . W !!
 . W ?15,"SUCCESSFUL system backup has >>> NOT <<< been confirmed.",!!
 . W ?15,"Install Aborting.",!!
 ;
 ; Store backup confirmation person & date/time
 NEW BCKUPCNT                   ; Current Patch,Backup count
 S BCKUPCNT=1+$O(^BLRINSTL("LAB PATCH",CP,"BACKUP CONFIRMED BY",""),-1)
 S ^BLRINSTL("LAB PATCH",CP,"BACKUP CONFIRMED BY",BCKUPCNT)=DUZ_"^"_$P($G(^VA(200,DUZ,0)),U)
 S ^BLRINSTL("LAB PATCH",CP,"BACKUP CONFIRMED BY",BCKUPCNT,"DATE/TIME")=$$HTE^XLFDT($H,"5MZ")
 ;
 Q "OK"
 ;
MAKESURE() ; EP
 D PASSMESG("PLEASE NOTE")
 W !
 ;
 W ?5,"There are over 335 routines, multiple Data Dictionary changes as well as",!
 W ?5,"numerous new options and processes that are included in this patch.",!
 W !
 S ANSWER=$$AREUSURE("CERTAIN")
 Q:ANSWER="Q" ANSWER
 ;
 D PASSMESG("SECOND CHANCE")
 S ANSWER=$$AREUSURE("REALLY certain")
 Q:ANSWER="Q" ANSWER
 W !
 ;
 D PASSMESG("LAST CHANCE")
 Q $$AREUSURE("ABSOLUTELY certain")
 ;
AREUSURE(MSG) ; EP
 NEW PROMPT
 S PROMPT=$J("",5)_"Are you "_MSG_" you want to continue loading this patch"
 D ^XBFMK
 S DIR(0)="YO"
 S DIR("B")="NO"
 S DIR("A")=PROMPT
 D ^DIR
 I $E($$UP^XLFSTR(X),1)'="Y" D  Q "Q"
 . S XPDABORT=1
 . W !!,?10,"YES was NOT entered.  Install Aborted.",!
 . D PRESSKEY(10)
 ;
 Q "OK"
 ;
TEXTONGO ; EP
 D PASSMESG("LOADING OF PATCH WILL COMMENCE")
 W !
 D BMES^XPDUTL($$CJ^XLFSTR(">>>> IHS Lab Patch 1027 will now be loaded. <<<<",IOM))
 D BMES^XPDUTL($$CJ^XLFSTR("Once installed there is no recovery possible except",IOM))
 D MES^XPDUTL($$CJ^XLFSTR("restoring from BACKUP.",IOM))
 D BMES^XPDUTL("")
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
REALLYIN       ; EP
 NEW CP,INSTCNT
 ;
 S CP=$P($T(+2),"*",3)
 S INSTCNT=1+$O(^BLRINSTL("LAB PATCH",CP,"REALLY INSTALL",""),-1)
 ;
 S ^BLRINSTL("LAB PATCH",CP,"REALLY INSTALL",INSTCNT)=DUZ_"^"_$P($G(^VA(200,DUZ,0)),"^")
 S ^BLRINSTL("LAB PATCH",CP,"REALLY INSTALL",INSTCNT,"DATE/TIME")=$$HTE^XLFDT($H,"5Z")
 Q
 ;
 ; TESTING FOUR FIVE SIX
