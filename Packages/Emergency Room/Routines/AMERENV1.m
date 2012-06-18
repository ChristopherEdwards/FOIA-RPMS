AMERENV1 ; IHS/OIT/SCR - ERS V3.0 ENVIRONMENT CHECK ROUTINE ;
 ;;3.0;ER VISIT SYSTEM;**1,2**;FEB 23, 2009
 ;
 ;
PRECHK ; EP
 D BMES^XPDUTL("Beginning of Pre Check.")
 NEW STR      ; String variable -- used for messages.
 ;
 S $P(LINE,"*",81)=""
 S XPDNOQUE="NO QUE"  ;NO QUEUING ALLOWED
 ;
 ; DISABLE THE "Disable options..." and "Move routines..."
 ; questions from being asked during install
 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 ;
 S XPDDIQ("XPO1")=0  ;DISABLE "Rebuild Menu Tree" question
 S XPDABORT=0
 ;
USERID ; CHECK FOR USER ID
 I '$G(DUZ) D SORRY("DUZ UNDEFINED OR 0!")  Q
 ;
 I '$L($G(DUZ(0))) D SORRY("DUZ(0) UNDEFINED OR NULL!")  Q
 ;
 D HOME^%ZIS,DT^DICRW
 S X=$P($G(^VA(200,DUZ,0)),U)
 I $G(X) D SORRY("Installer cannot be identified!")  Q
 ;
LETSGO ; USER IDENTIFIED -- LET'S GO
 D MES^XPDUTL("Hello, "_$P(X,",",2)_" "_$P(X,","))
FILEMAN ; CHECK FOR FILEMAN 22.0
 S X=$G(^DD("VERSION"))
 D BMES^XPDUTL("Need at least FileMan 22.0")
 I X<22 D SORRY("Need FileMan 22.0 & FileMan "_X_" found!")  Q
 D OKAY("FileMan "_X_" found.")
 ;
KERNEL ; CHECK FOR KERNEL 8.0
 S X=$G(^DIC(9.4,$O(^DIC(9.4,"C","XU",0)),"VERSION"))
 D BMES^XPDUTL("Need at least Kernel 8.0.")
 I X<8.0 D SORRY("Need Kernel 8.0 & Kernel "_X_" found!")  Q
 D OKAY("Kernel "_X_" found.")
 ;
PIMS ; CHECK FOR PIMS 5.3
 ;first check for PIMS
 S X=$$VERSION^XPDUTL("PIMS")
 D BMES^XPDUTL("Need at least PIMS 5.3.")
 I X="" D SORRY("Please install PIMS 5.3 before loading this version")  Q
 I X<5.3 D SORRY("Need PIMS 5.3 & PIMS "_X_" found!") Q
 D OKAY("PIMS "_X_" found.")
 ;
MM1006 ; CHECK FOR MAILMAN patch 1006
 ;IHS/OIT/SCR 050409 modied to allow v 8.0 OR required 7.1 patch
 S VERSION=$$XMV8()
 I VERSION="8.0" D OKAY("MailMan version 8.0 found")
 I VERSION="7.1" D
 .D OKAY("MailMan version 7.1 found")
 .D BMES^XPDUTL("Need XM patch 1006.")
 .I $$XMPATCH(50)'["Y" D SORRY("MailMan v7.1 Patch 1006 IS NOT installed!")  Q
 .D OKAY("MailMan v7.1 Patch 1006 found")
 .Q
 I (VERSION'="8.0")&&(VERSION'="7.1") D SORRY("Unsupported MailMan Version Found") Q
 ;
AICD7 ; CHECK FOR AICD 3.51 patch 7
 S X=$$VERSION^XPDUTL("AICD")
 N Y S Y=+$$LAST^XPDUTL("IHS ICD/CPT LOOKUP & GROUPER",X)
 D BMES^XPDUTL("Need AICD 3.51 patch 7.")
 I X<3.51!((X=3.51)&(Y<7)) D  Q
 . D:Y=-1 SORRY("Need AICD 3.51 patch 7 & AICD "_X_" found!")
 . D:Y'=-1 SORRY("Need AICD 3.51 patch 7 & AICD "_X_" patch "_Y_" found!")
 D OKAY("AICD 3.51 Patch 7 found")
 ;
AG ; CHECK FOR AG 7.1 PATCH 2
 S X=$$VERSION^XPDUTL("IHS PATIENT REGISTRATION")
 N Y S Y=+$$LAST^XPDUTL("IHS PATIENT REGISTRATION",X)
 D BMES^XPDUTL("Need IHS PATIENT REGISTRATION 7.1 patch 2.")
 I X<7.1!((X=7.1)&(Y<2)) D  Q
 . D:Y=-1 SORRY("Need IHS PATIENT REGISTRATION 7.1 patch 2 & IHS PATIENT REGISTRATION "_X_" found!")
 . D:Y'=-1 SORRY("Need IHS PATIENT REGISTRATION 7.1 patch 2 & IHS PATIENT REGISTRATION "_X_" patch "_Y_" found!")
 D OKAY("IHS PATIENT REGISTRATION 7.1 Patch 2 found")
 ;
PCC ; CHECK FOR PCC DATA ENTRY 2.0
 S X=$$VERSION^XPDUTL("APCD")
 D BMES^XPDUTL("Need PCC DATA ENTRY 2.0.")
 I X<2.0 D SORRY("Need PCC DATA ENTRY 2.0 to install this version")  Q
 D OKAY("PCC DATA ENTRY 2.0 found.")
 ;
AMER ; CHECK FOR AMER 3.0 PATCH 1
 D BMES^XPDUTL("Need ER VISIT SYSTEM v3.0 patch 1")
 S X=$$VERSION^XPDUTL("ER VISIT SYSTEM")
 S Y=+$$LAST^XPDUTL("ER VISIT SYSTEM",X)
 I X<1 D SORRY("NEED ERS PATCH 1 before installing this patch") Q
 D OKAY("ERS v3.0 patch 1 found")
 ;
ENVOK ; ENVIRONMENT OK
 D BMES^XPDUTL("ENVIRONMENT OK.")
 ;
BACKUPS ; CHECK TO CONFIRM BACKUPS HAVE BEEN DONE
 D BMES^XPDUTL("SYSTEM BACKUP Check.")
 W !!
 S DIR(0)="Y"
 S DIR("B")="NO"
 S DIR("A")="Has a SUCCESSFUL system backup been performed"
 D ^DIR
 I $D(DIRUT)!($G(Y)=0) D  Q
 . D SORRY("Please perform a successful backup before continuing!!")
 S %DT="R",X="NOW" D ^%DT X ^DD("DD")
 S STR="BACKUPS CONFIRMED BY "_$P($G(^VA(200,DUZ,0)),U)_" ON "
 S STR=STR_$P(Y,"@")_" AT "_$P(Y,"@",2)
 D BMES^XPDUTL(STR)
 D MES^XPDUTL(" ")
 Q  ;END OF MAIN ROUTINE
 ;
SORRY(MSG,MODE) ; MESSAGE TO DISPLAY WHEN SOMETHING GOES WRONG
 NEW MESSAGE
 I $G(MODE)'["NONFATAL" D
 . S MESSAGE="Install Aborting due to the following Systems Environment issue:"
 . S XPDABORT=1
 ;
 I $G(MODE)["NONFATAL" S MESSAGE="*** WARNING *** WARNING *** WARNING ***"
 ;
 K DIFQ
 ;
 NEW STR
 S STR(1)=""
 S STR(2)=$TR($J("",65)," ","*")    ; Row of asterisks
 S STR(3)=" "
 S STR(4)=$$CJ^XLFSTR("Site: "_$$LOC^XBFUNC,65)
 S STR(5)=" "
 S STR(6)=$$CJ^XLFSTR(MESSAGE,65)
 S STR(7)=" "
 S STR(8)=$$CJ^XLFSTR(">>> "_MSG_" <<<",65)
 S STR(9)=" "
 S STR(10)=$$CJ^XLFSTR("Please print/capture this screen and",65)
 S STR(11)=$$CJ^XLFSTR("notify the Support Center at",65)
 S STR(12)=""
 S STR(13)=$$CJ^XLFSTR("1-888-830-7280.",65)
 S STR(14)=" "
 S STR(15)=$G(STR(2))               ; Row of asterisks
 S STR(16)=""
 D BMES^XPDUTL(.STR)
 Q
 ;
OKAY(MSG,TAB) ; MESSAGE WITH "OK" AT THE END
 NEW MESSAGE
 I $G(TAB)="" S TAB=5
 S MESSAGE=$J("",TAB)_MSG_" OK."
 D MES^XPDUTL(MESSAGE)
 Q
 ;
XMV8() ; CHECK FOR MAILMAN v8.0
 ;IHS/OIT/SCR 050409
 S X=$$VERSION^XPDUTL("XM")
 D BMES^XPDUTL("Checking MailMan Version")
 S MESSAGE="MAIL MAN v"_X_" found"
 D OKAY(MESSAGE)
 Q X
 ;
XMPATCH(CHK)  ; Check for mail-man patch
 NEW PAT,PATCH,XMPTR,OKGIS,OKPATCH
 S XMPTR=$O(^DIC(9.4,"C","XM",0))
 S PAT="",OKPATCH="NO"
 F  S PAT=$O(^DIC(9.4,XMPTR,22,PAT))  Q:PAT=""!(OKPATCH["Y")  D
 . S PATCH=""
 . F  S PATCH=$O(^DIC(9.4,XMPTR,22,PAT,"PAH",PATCH))  Q:PATCH=""!(OKPATCH["Y")  D
 .. I +$G(^DIC(9.4,XMPTR,22,PAT,"PAH",PATCH,0))[CHK S OKPATCH="YES"
 Q OKPATCH
 ;
TABMENU(MSG,TAB,TAIL) ; GENERIC MESSAGE OUTPUT
 NEW MESSAGE
 I $G(TAB)="" S TAB=5
 S MESSAGE=$J("",TAB)_MSG
 I $G(TAIL)'="" S MESSAGE=MESSAGE_" "_TAIL
 D MES^XPDUTL(MESSAGE)
 Q
