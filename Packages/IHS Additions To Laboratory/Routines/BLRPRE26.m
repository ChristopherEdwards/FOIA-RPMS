BLRPRE26 ; IHS/OIT/MKK - IHS Lab PATCH 1026 Environment/Post Install Routine ;MAY 06, 2009 9:58 AM
 ;;5.2T1;IHS LABORATORY;**1026**;NOV 01, 1997
 ;
PRE ; EP
 D BMES^XPDUTL("Beginning of Pre Check.")
 NEW CP,RPMS,RPMSVER
 NEW STR
 NEW LASTPTCH                 ; Last Patch of Lab
 NEW LSTPISTS                 ; Last Patch Install Status
 NEW ERRARRAY                 ; Array of errors
 ;
 I $G(XPDNM)="" D SORRY("XPDNM not defined or 0.")  Q
 ;
 S CP=$P(XPDNM,"*",3)         ; Current Patch Number
 S RPMS=$P(XPDNM,"*",1)       ; RPMS Module
 S RPMSVER=$P(XPDNM,"*",2)    ; Version of RPMS module being patched
 ;
PTCHLAST ; EP - Check for previous patch
 D MES^XPDUTL("     Need LR*5.2*1025 Patch Installed.")
 I $$PATCH^XPDUTL("LR*5.2*1025")'=1 D SORRY("LR*5.2*1025 Patch Not Installed.")  Q
 ;
 D OKAY^BLRKIDSU("LR*5.2*1025 Patch Installed.",10)
 ;
 S XPDNOQUE="NO QUE"          ; No Queuing Allowed
 ;
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 F X="XPO1","XPZ1","XPZ2","XPI1" S XPDDIQ(X)=0
 ;
 S XPDABORT=0                    ; KIDS install Flag
 ;
USERID ; EP - CHECK FOR USER ID
 I '$G(DUZ) D SORRY("DUZ UNDEFINED OR 0.")  Q
 ;
 I '$L($G(DUZ(0))) D SORRY("DUZ(0) UNDEFINED OR NULL.")  Q
 ;
 D HOME^%ZIS
 D DTNOLF^DICRW          ; Set DT variable without Doing a Line Feed
 ;
 S X=$P($G(^VA(200,DUZ,0)),U)
 I $G(X) D SORRY^BLRKIDSU("Installer cannot be identified!",,,CP) Q
 ;
 D MES^XPDUTL("Pre Check complete.")
 ;
LETSGO ; EP - USER IDENTIFIED -- LET'S GO
 D BMES^XPDUTL("Hello, "_$P(X,",",2)_" "_$P(X,","))
 ;
 D BMES^XPDUTL("Checking Environment for Patch "_CP_" of Version "_RPMSVER_" of "_RPMS_".")
 ;
 D NEEDIT("DI","22.0",,.ERRARRAY)         ; FILEMAN 22.0
 D NEEDIT("XM","8.0",,.ERRARRAY)          ; MAILMAN 8.0
 D NEEDIT("XU","8.0",1013,.ERRARRAY)      ; KERNEL 8.0 & PATCH 1013
 ;
 D CHECKLMI(.ERRARRAY)                    ; LMI MAIL GROUP
 ;
 I XPDABORT<1 D BMES^XPDUTL("ENVIRONMENT OK.")
 ;
 I XPDABORT>0 D
 . D SORRYEND(.ERRARRAY)     ; Environment has error(s)
 ;
 Q
 ;
BACKUP ; EP
 NEW CP
 S CP=$P($T(+2),"*",3)
 ;
 D BACKUPS^BLRKIDSU(CP)
 Q
 ;
POST ; EP -- POST INSTALL
 NEW CP
 ;
 S CP=$P($T(+2),"*",3)
 ;
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 F X="XPO1","XPZ1","XPZ2","XPI1" S XPDDIQ(X)=0
 ;
 D LABTMOD                    ; Modify File # 60
 D MOD90479                   ; Modify File # 90479
 ;
 D BMES^XPDUTL("Laboratory Patch "_CP_" INSTALL complete.")
 ;
 NEW STR
 S STR(1)="Laboratory Patch "_CP_" INSTALL completed at."
 S STR(2)=$$CJ^XLFSTR($$UP^XLFSTR($TR($$HTE^XLFDT($H,"MP"),"@"," ")),43)
 D SENDMAIL("IHS Lab Patch "_CP)
 D SNDALERT("Laboratory Patch "_CP_" INSTALL complete.")
 ;
 ; Store # of times installation occurred as well as person & date/time
 D ENDINSTL^BLRKIDSU(CP)
 ;
 Q
 ;
DEBUG ; EP - Debugging Line Label for environment checker
 NEW CP,DEBUG,XPDNM
 S DEBUG="YES"
 S XPDNM="LR*5.2*1026"
 S CP=$P($T(+2),"*",3)        ; Current Patch
 D PRE
 Q
 ;
 ; Error Message routine.  It will send an ALERT and a MailMan message
 ; and it will also appear on the INSTALL LOG.
SORRY(MSG,MODE,MSG2)       ; EP
 S CP=$P($T(+2),"*",3)
 ;
 NEW MESSAGE
 I $G(MODE)=""!($G(MODE)'["NONFATAL") D
 . S MESSAGE="Install Aborting due to the following Systems Environment issue:"
 . S XPDABORT=1     ; Fatal Error Flag Set
 ;
 I $G(MODE)["NONFATAL" S MESSAGE="*** WARNING *** WARNING *** WARNING ***"
 ;
 K DIFQ
 ;
 NEW STR,LINECNT
 S LINECNT=1
 D ADDLINE(" ",.LINECNT)
 D ADDLINE($TR($J("",65)," ","*"),.LINECNT)    ; Row of asterisks
 D ADDLINE(" ",.LINECNT)
 D ADDLINE($$CJ^XLFSTR("Site: "_$$LOC^XBFUNC,65),.LINECNT)
 D ADDLINE(" ",.LINECNT)
 D ADDLINE($$CJ^XLFSTR(MESSAGE,65),.LINECNT)
 D ADDLINE(" ",.LINECNT)
 D ADDLINE($$CJ^XLFSTR(">>> "_MSG_" <<<",65),.LINECNT)
 I $D(MSG2) D ADDLINE($$CJ^XLFSTR(">>> "_MSG2_" <<<",65),.LINECNT)
 D ADDLINE(" ",.LINECNT)
 ;
 I $G(MODE)["NONFATAL" D ADDLINE($$CJ^XLFSTR(MESSAGE,65),.LINECNT)
 ;
  I $G(MODE)'["NONFATAL" D
 . D ADDLINE($$CJ^XLFSTR("Please print/capture this screen and",65),.LINECNT)
 . D ADDLINE($$CJ^XLFSTR("notify the Support Center at",65),.LINECNT)
 . D ADDLINE(" ",.LINECNT)
 . D ADDLINE($$CJ^XLFSTR("1-888-830-7280.",65),.LINECNT)
 . D ADDLINE(" ",.LINECNT)
  ;
 D ADDLINE($TR($J("",65)," ","*"),.LINECNT)    ; Row of asterisks
 D ADDLINE(" ",.LINECNT)
 ;
 D BMES^XPDUTL(.STR)
 ;
 Q
 ;
ADDLINE(ASTR,LC) ; EP -- Add a line to the STR array
 I $G(ASTR)="" S ASTR=" "
 S STR(LC)=ASTR
 S LC=LC+1
 Q
 ;
SNDALERT(ALERTMSG) ; EP -- Send alert to LMI group & Installer
 D SENDIT("G.LMI",ALERTMSG)
 D SENDIT(DUZ,ALERTMSG)
 Q
 ;
SENDIT(WHO,WOTMSG) ; EP - Send the Alert
 S XQAMSG=WOTMSG
 S XQA(WHO)=""
 D SETUP^XQALERT
 K XQA,XQAMSG
 Q
 ;
SENDMAIL(MAILMSG) ; EP -- Send MailMan E-mail to LMI group & Installer
 D MAILIT("G.LMI",MAILMSG)
 D MAILIT(DUZ,MAILMSG)
 Q
 ;
MAILIT(WHO,MSG) ; EP -- Send the MailMan Message
 NEW CP,DIFROM,XMDUZ,XMMG,XMSUB,XMTEXT,XMY
 ;
 S CP=$P($T(+2),"*",3)
 ;
 S XMY(WHO)=""
 S XMSUB=MSG
 S XMTEXT="STR("
 S XMDUZ="IHS "_XPDNM
 D ^XMD
 ;
 I $G(XMMG)="" Q   ; Message sent
 ;
 D BMES^XPDUTL("Error Sending MailMan Message.")
 D TABMESG^BLRKIDSU("Error Message:"_XMMG,10)
 ;
 Q
 ;
CHECKLMI(ERRARRAY)   ; EP  -- CHECK FOR LMI MAIL GROUP
 NEW HEREYAGO
 ;
 D BMES^XPDUTL("Must have 'LMI' mail group present.")
 D FIND^DIC(3.8,"","","","LMI","","","","","HEREYAGO")
 ;
 I $G(HEREYAGO("DILIST",1,1))="LMI" D  Q
 . D OKAY^BLRKIDSU("'LMI' mail group found.")
 ;
 D SORRY("'LMI' mail group NOT found!","FATAL")
 S ERRARRAY("XMB(3.8","Mail Group","3.8")="LMI Mail Group"
 Q
 ;
 ; Generic "Find RPMS Module's Version and (perhaps) Patch number"
 ; The MODULE variable MUST be the PREFIX name from the PACKAGE file (9.4).
NEEDIT(MODULE,VERSION,PATCH,ERRARRAY)      ; EP
 NEW NAME                ; Name of PACKAGE
 NEW HEREYAGO,STR1,STR2  ; Scratch variables/arrays
 NEW SYSVER,SYSPATCH     ; System Version & System Patch variables
 ;
 D FIND^DIC(9.4,"","","",MODULE,"","C","","","HEREYAGO")
 S NAME=$G(HEREYAGO("DILIST",1,1))
 ;
 D BMES^XPDUTL("Need at least "_NAME_" "_VERSION)
 ;
 S SYSVER=$$VERSION^XPDUTL(MODULE)     ; Get the System's Version
 ; If System Version < Needed Version, write message and quit
 I SYSVER<VERSION D  Q
 . S ERRARRAY(MODULE,NAME,VERSION)=SYSVER
 . D NEEDMSG("Need "_NAME_" "_VERSION_" & "_NAME_" "_SYSVER_" found!")
 ;
 D OKAY^BLRKIDSU(NAME_" "_SYSVER_" found.")
 I VERSION<SYSVER Q     ; If Version needed is lower, skip Patch check
 ;
 I $G(PATCH)="" Q   ; If no Patch check, just exit
 ;
 D BMES^XPDUTL("     Need "_NAME_" "_VERSION_" Patch "_PATCH_".")
 S SYSPATCH=$$PATCH^XPDUTL(MODULE_"*"_VERSION_"*"_PATCH)
 I SYSPATCH'=1 D  Q
 . S ERRARRAY(MODULE,NAME,VERSION)=$G(PATCH)
 . D NEEDMSG(NAME_" "_VERSION_" & Patch "_PATCH_" WAS NOT installed!")
 ;
 D OKAY^BLRKIDSU(NAME_" "_VERSION_" Patch "_PATCH_" found.",10)
 ;
 Q
 ;
NEEDMSG(MESSAGE) ; EP
 NEW STR1,STR2
 ;
 S STR1=MESSAGE
 I $L(STR1)<58 D SORRY^BLRKIDSU(STR1,,,CP)  Q
 ;
 S STR1=$P(MESSAGE,"&")_" &"
 S STR2=$$TRIM^XLFSTR($P(MESSAGE,"&",2),"L"," ")
 D SORRY^BLRKIDSU(STR1,,STR2,CP)
 Q
 ;
LABTMOD ; EP - Lab Test File Modification -- Try to Stop Infinite Recursion
 NEW CHNGSTR,MODSTR,SUBSTR
 ;
 S CHNGSTR="IF $P(^LAB(60,DA(1),0),U,5)'=""""!(DA(1)=X) W !,""NO CAN DO"" K X"
 ;
 S SUBSTR=$G(^DD(60.02,.01,0))
 I $P(SUBSTR,"^",5,99)=CHNGSTR  Q
 ;
 D BMES^XPDUTL(" ")
 D BMES^XPDUTL("POST INSTALL LABTMOD BEGINS")
 D TABMESG^BLRKIDSU("Changing Input Transform of .01 sub-field of 60.02 field of File # 60.",5)
 ;
 S MODSTR="^DD(60.02,.01,0)"
 S $P(SUBSTR,"^",5,99)=CHNGSTR
 S @MODSTR=SUBSTR
  ;
 S SUBSTR=$G(^DD(60.02,.01,0))
 ;
 I $P(SUBSTR,"^",5,99)=CHNGSTR D
 . D OKAY^BLRKIDSU(".01 sub-field of 60.02 field of File # 60 changed.",10)
 ;
 I $P(SUBSTR,"^",5,99)'=CHNGSTR D
 . D TABMESG^BLRKIDSU(".01 sub-field of 60.02 field of File # 60 NOT changed.",10)
 ;
 D BMES^XPDUTL("POST INSTALL LABTMOD ENDS")
 Q
 ;
 ; Modify File 90479 so that the permissions are like all Lab Files
MOD90479 ; EP
 NEW STR,WOT
 ;
 I $D(^DIC(90479,0))<1 Q
 ;
 D BMES^XPDUTL(" ")
 D BMES^XPDUTL("POST INSTALL MODIFICATION OF FILE 90479 BEGINS")
 S WOT="AUDIT"
 S STR="^DIC(90479,0,"""_WOT_""")=""#"""
 S @STR
 ;
 S WOT="DD"
 S STR="^DIC(90479,0,"""_WOT_""")=""@"""
 S @STR
 ;
 F WOT="DEL","LAYGO","RD","WR"  D
 . S STR="^DIC(90479,0,"""_WOT_""")=""L"""
 . S @STR
 D BMES^XPDUTL("POST INSTALL MODIFICATION OF FILE 90479 ENDS.")
 Q
 ;
RESET ; EP - For debugging purposes
 NEW CHNGSTR,SUBSTR
 ;
 S CHNGSTR="IF $P(^LAB(60,DA(1),0),U,5)'="""" W !,""NO CAN DO"" K X"
 ;
 S SUBSTR=$G(^DD(60.02,.01,0))
 I $P(SUBSTR,"^",5,99)=CHNGSTR  Q
 ;
 D TABMESG^BLRKIDSU("Resetting Input Transform of .01 sub-field of 60.02 field of File # 60.",5)
 ;
 S MODSTR="^DD(60.02,.01,0)"
 S $P(SUBSTR,"^",5,99)=CHNGSTR
 S @MODSTR=SUBSTR
 ;
 S SUBSTR=$G(^DD(60.02,.01,0))
 ;
 I $P(SUBSTR,"^",5,99)=CHNGSTR D  Q
 . D OKAY^BLRKIDSU(".01 sub-field of 60.02 field of File # 60 Reset.",10)
 ;
 D TABMESG^BLRKIDSU(".01 sub-field of 60.02 field of File # 60 NOT Reset.",10)
 Q
 ;
 ; Output a listing of ALL the errors detected during the environment check.
 ; Also, send ALERT & E-Mail
SORRYEND(WOTERR) ; EP
 NEW STR,MODULE,NAME,VERSION,PATCH,LINECNT,TMP,WHATMSG
 ;
 D SORRYHED^BLRKIDSU
 ;
 ; Add ALL the errors detected to the STR array
 S (MODULE,NAME,VERSION)=""
 F  S MODULE=$O(WOTERR(MODULE))  Q:MODULE=""  D
 . F  S NAME=$O(WOTERR(MODULE,NAME))  Q:NAME=""  D
 .. F  S VERSION=$O(WOTERR(MODULE,NAME,VERSION))  Q:VERSION=""  D
 ... D ADDMESG^BLRKIDSU
 ;
 D SORRYFIN^BLRKIDSU
 ;
 D BMES^XPDUTL(.STR)    ; Display for INSTALL LOG
 ;
 S WHATMSG=$G(XPDNM)_" Install FATAL Error(s)"
 ;
 D SNDALERT(WHATMSG)
 D SENDMAIL(WHATMSG)
 ;
 D FATLSTOR(.WOTERR)
 Q
 ;
FATLSTOR(WOTERR) ; Store Information concerning FATAL ERROR during Install
 NEW MODULE,NAME,NOW,VERSION
 ;
 ; The following line should NEVER happen, but if it does, fix XPDNM variable
 I $G(XPDNM)="" S XPDNM="LR*5.2*"_$P($T(+2),"*",3)
 ;
 S NOW=$H
 S ^BLRFATLI(XPDNM,NOW)=$$HTE^XLFDT(NOW,"2MZ")
 ;
 S (MODULE,NAME,VERSION)=""
 F  S MODULE=$O(WOTERR(MODULE))  Q:MODULE=""  D
 . F  S NAME=$O(WOTERR(MODULE,NAME))  Q:NAME=""  D
 .. F  S VERSION=$O(WOTERR(MODULE,NAME,VERSION))  Q:VERSION=""  D
 ... S ^BLRFATLI(XPDNM,NOW,MODULE,NAME,VERSION)=$G(WOTERR(MODULE,NAME,VERSION))
 ;
 Q
