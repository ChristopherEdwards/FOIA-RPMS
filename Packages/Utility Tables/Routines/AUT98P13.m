AUT98P13 ;IHS/SET/AEF - AUT 98.1 PATCH 13 ; [ 10/16/2003  1:57 PM ]
 ;;98.1;IHS DICTIONARIES (POINTERS);**13**;OCT 16, 2003
 ;
 ; IHS/SET/AEF AUT*98.1*13 10/16/2003
 ;
 I '$G(IOM) D HOME^%ZIS
 ;
 I '$G(DUZ) W !,"DUZ UNDEFINED OR 0." D SORRY(2) Q
 ;
 I '$L($G(DUZ(0))) W !,"DUZ(0) UNDEFINED OR NULL." D SORRY(2) Q
 ;
 I '(DUZ(0)["@") W:'$D(ZTQUEUED) !,"DUZ(0) DOES NOT CONTAIN AN '@'." D SORRY(2) Q
 ;
 S X=$P(^VA(200,DUZ,0),U)
 W !!,$$CJ^XLFSTR("Hello, "_$P(X,",",2)_" "_$P(X,","),IOM)
 W !!,$$CJ^XLFSTR("Checking Environment for "_$P($T(+2),";",4)_" V "_$P($T(+2),";",3)_" Patch "_$P($T(+2),";",5)_".",IOM)
 ;
 NEW IORVON,IORVOFF
 S X="IORVON;IORVOFF"
 D ENDR^%ZISS
 ;
 S X=$$VERSION^XPDUTL("AUT")
 W !!,$$CJ^XLFSTR("Need AUT v 98.1.....AUT v "_X_" Present",IOM)
 I X<98.1,+X'=1.1 D SORRY(2)
 ;
 NEW DA,DIC
 S X="AUT",DIC="^DIC(9.4,",DIC(0)="",D="C"
 D IX^DIC
 I Y<0,$D(^DIC(9.4,"C","AUT")) D
 . W !!,*7,*7,$$CJ^XLFSTR("You Have More Than One Entry In The",IOM),!,$$CJ^XLFSTR("PACKAGE File with an ""AUT"" prefix.",IOM)
 . W !,$$CJ^XLFSTR(IORVON_"One entry needs to be deleted."_IORVOFF,IOM)
 . D SORRY(2)
 .Q
 ;
 I $G(XPDQUIT) W !,$$CJ^XLFSTR(IORVON_"FIX IT! Before Proceeding."_IORVOFF,IOM),!!,*7,*7,*7 Q
 ;
 W !!,$$CJ^XLFSTR("ENVIRONMENT OK.",IOM)
 ;
 D HELP^XBHELP("INTROE","AUT98P13")
 I '$$DIR^XBDIR("E","","","","","",1) D SORRY(2) Q
 ;
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0 D HELP^XBHELP("INTROI","AUT98P13")
 ;
 Q
 ;
SORRY(X) ;
 KILL DIFQ
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("Sorry....FIX IT!",IOM)
 Q
 ;
VCHK(AUTPRE,AUTVER,AUTQUIT) ; Check versions needed.
 ;  
 NEW AUTV
 S AUTV=$$VERSION^XPDUTL(AUTPRE)
 W !,$$CJ^XLFSTR("Need at least "_AUTPRE_" v "_AUTVER_"....."_AUTPRE_" v "_AUTV_" Present",IOM)
 I AUTV<AUTVER D SORRY(AUTQUIT) Q 0
 Q 1
 ;
PRE ;EP - From KIDS.
 ;
 ; --- Save, and set dd audit to "y" for effected files.
 I $$NEWCP^XPDUTL("PRE1-AUDS^AUT98P13","AUDS^AUT98P13")
 ;
 Q
 ;
POST ;EP - From KIDS.
 ;
 D UNIQUEL
 ;
 ; --- Restore dd audit to pre-install values.
 I $$NEWCP^XPDUTL("POS1-AUDR^AUT98P13","AUDR^AUT98P13")
 ;
 ; --- Send install mail message.
 I $$NEWCP^XPDUTL("POS2-MAIL^AUT98P13","MAIL^AUT98P13")
 ;
 Q
 ;
MAIL ;
 D BMES^XPDUTL("BEGIN Delivering MailMan message to select users...")
 NEW DIFROM,XMSUB,XMDUZ,XMTEXT,XMY
 KILL ^TMP("AUT98P13",$J)
 D RSLT(" --- AUT v 98.1, Patch 13, has been installed into this uci ---")
 F %=1:1 D RSLT($P($T(GREET+%),";",3)) Q:$P($T(GREET+%+1),";",3)="###"
 S %=0
 F  S %=$O(^XTMP("XPDI",XPDA,"BLD",XPDBLD,1,%)) Q:'%   D RSLT(^(%,0))
 S XMSUB=$P($P($T(+1),";",2)," ",3,99),XMDUZ=$S($G(DUZ):DUZ,1:.5),XMTEXT="^TMP(""AUT98P13"",$J,",XMY(1)="",XMY(DUZ)=""
 F %="XUMGR","XUPROG","XUPROGMODE" D SINGLE(%)
 D ^XMD
 KILL ^TMP("AUT98P13",$J)
 D MES^XPDUTL("END Delivering MailMan message to select users...")
 Q
 ;
RSLT(%) S ^(0)=$G(^TMP("AUT98P13",$J,0))+1,^(^(0))=%
 Q
 ;
SINGLE(K) ; Get holders of a single key K.
 NEW Y
 S Y=0
 Q:'$D(^XUSEC(K))
 F  S Y=$O(^XUSEC(K,Y)) Q:'Y  S XMY(Y)=""
 Q
 ;
INTROE ; Intro text during KIDS Environment check.
 ;;In this distribution:
 ;;There are several adds/edits to AUT standard data dictionaries, as
 ;;well as to the entries within the files.  The notes file for this
 ;;patch can be printed using KIDS option "3  Print Transport Global",
 ;;and the adds/edits for both the DDs and the entries can be listed
 ;;using KIDS option "4  Compare Transport Global to Current System".
 ;;Neither option will effect your system prior to install.
 ;;###
 ;
INTROI ; Intro text during KIDS Install.
 ;;A standard message will be produced by this update.
 ;;  
 ;;If you run interactively, results will be displayed on your screen,
 ;;as well as in the mail message and the entry in the INSTALL file.
 ;;If you queue to TaskMan, please read the mail message for results of
 ;;this update, and remember not to Q to the HOME device.
 ;;###
 ;
GREET ;;To add to mail message.
 ;;  
 ;;Greetings.
 ;;  
 ;;You are receiving this message because of the particular RPMS
 ;;security keys that you hold.  This is for your information, only.
 ;;You need do nothing in response to this message.
 ;;  
 ;;Questions about this patch, which is a product of the RPMS DBA
 ;;can be directed to the DIR/RPMS            
 ;;Help Desk.
 ;;Please refer to patch "AUT*98.1*13".
 ;;  
 ;;Requests for modifications or additions to RPMS standard data
 ;;dictionaries must be directed to the RPMS DBA.
 ;;  
 ;;###;NOTE: This line indicates the end of text in this message.
 ;
 ; -----------------------------------------------------
 ; The global location for dictionary audit is:
 ;           ^DD(FILE,0,"DDA")
 ; If the value is "Y", dd audit is on.  Any other value, or the
 ; absence of the node, means dd audit is off.
 ; -----------------------------------------------------
AUDS ; Save current settings, and SET dd auditing 'on'.
 D MES^XPDUTL("Saving current DD AUDIT settings for files in this patch")
 D MES^XPDUTL("and turning DD AUDIT to 'Y'.")
 S ^XTMP("AUT98P13",0)=$$FMADD^XLFDT(DT,10)_"^"_DT_"^"_$P($P($T(+1),";",2)," ",3,99)
 NEW AUT
 S AUT=0
 F  S AUT=$O(^XTMP("XPDI",XPDA,"FIA",AUT)) Q:'AUT  D
 . I '$D(^XTMP("AUT98P13",AUT,"DDA")) S ^XTMP("AUT98P13",AUT,"DDA")=$G(^DD(AUT,0,"DDA"))
 . D MES^XPDUTL(" File "_$$RJ^XLFSTR(AUT,13)_" - "_$$LJ^XLFSTR(^XTMP("XPDI",XPDA,"FIA",AUT),30)_"- DD audit was '"_$G(^XTMP("AUT98P13",AUT,"DDA"))_"'"),MES^XPDUTL($$RJ^XLFSTR("Set to 'Y'",69))
 . S ^DD(AUT,0,"DDA")="Y"
 .Q
 D MES^XPDUTL("DD AUDIT settings saved in ^XTMP(.")
 Q
 ; -----------------------------------------------------
AUDR ; Restore the file data audit values to their original values.
 D MES^XPDUTL("Restoring DD AUDIT settings for files in this patch")
 NEW AUT
 S AUT=0
 F  S AUT=$O(^XTMP("AUT98P13",AUT)) Q:'AUT  D
 . S ^DD(AUT,0,"DDA")=^XTMP("AUT98P13",AUT,"DDA")
 . D MES^XPDUTL(" File "_$$RJ^XLFSTR(AUT,13)_" - "_$$LJ^XLFSTR($$GET1^DID(AUT,"","","NAME"),30)_"- DD AUDIT Set to '"_^DD(AUT,0,"DDA")_"'")
 .Q
 KILL ^XTMP("AUT98P13")
 D MES^XPDUTL("DD AUDIT settings restored.")
 Q
 ; -----------------------------------------------------
 ;
UNIQUEL ;----- LOOP THRU LOCATION FILE AND POPULATE UNIQUE RPMS DB ID FIELD
 ;
 I '$$PATCH^XPDUTL("AUT*98.1*12") D UNIQUEP ;IF PATCH 12 HAS NOT BEEN INSTALLED
 D UNIQUED
 Q
 ;
UNIQUEP ;----- POPULATE THE UNIQUE RPMS DB ID FIELD
 ;
 N IEN
 ;
 D BMES^XPDUTL("Populating UNIQUE RPMS DB ID field in LOCATION file")
 ;
 S IEN=0
 F  S IEN=$O(^AUTTLOC(IEN)) Q:'IEN  D UNIQUE1(IEN)
 Q
 ;
UNIQUED ;----- DELETE SCRATCH LOCATION FILE
 ;
 N DIU,X,Y
 ;
 S DIU="^AUTT999(8008699.06,"
 S DIU(0)="D"
 D EN^DIU2
 Q
UNIQUE1(IEN)       ;
 ;----- PROCESS ONE ENTRY
 ;
 N ASUFAC,D0,DATA,IEN2,NAME,UNIQUE,X,Y
 ;
 S NAME=$P($G(^DIC(4,IEN,0)),U)
 S D0=IEN
 X $P($G(^DD(9999999.06,.0799,0)),U,5,999)
 Q:X']""
 Q:$L(X)'=6
 S ASUFAC=X
 S IEN2=0
 S IEN2=$O(^AUTT999(8008699.06,"D",ASUFAC,IEN2))
 Q:'IEN2
 S DATA=$G(^AUTT999(8008699.06,IEN2,0))
 Q:DATA']""
 ;Q:NAME'=$P(DATA,U,2)
 Q:ASUFAC'=$P(DATA,U,3)
 S UNIQUE=$P(DATA,U,4)
 Q:'UNIQUE
 Q:$D(^AUTTLOC("F",UNIQUE))
 D UNIQUEA(IEN,UNIQUE)
 Q
UNIQUEA(IEN,UNIQUE)          ;
 ;----- EDIT ONE ENTRY
 ;
 N DA,DIE,DR,X,Y
 ;
 S DIE="^AUTTLOC("
 S DA=IEN
 S DR=".32///^S X=UNIQUE"
 D ^DIE
 Q
