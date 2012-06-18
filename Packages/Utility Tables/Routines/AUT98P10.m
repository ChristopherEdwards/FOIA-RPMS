AUT98P10 ;IHS/SET/GTH - AUT 98.1 PATCH 10 ; [ 06/06/2002   4:31 PM ]
 ;;98.1;IHS DICTIONARIES (POINTERS);**10**;MAR 04, 1998
 ;
 ; IHS/SET/GTH AUT*98.1*10 06/06/2002
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
 S X=$$VERSION^XPDUTL("AUT")
 W !!,$$CJ^XLFSTR("Need AUT v 98.1.....AUT v "_X_" Present",IOM)
 I X<98.1,+X'=1.1 D SORRY(2)
 ;
 I $$VCHK("DI","21.0",2)
 I $$VCHK("XU","8.0",2)
 ;
 NEW DA,DIC
 S X="AUT",DIC="^DIC(9.4,",DIC(0)="",D="C"
 D IX^DIC
 I Y<0,$D(^DIC(9.4,"C","AUT")) D
 . W !!,*7,*7,$$CJ^XLFSTR("You Have More Than One Entry In The",IOM),!,$$CJ^XLFSTR("PACKAGE File with an ""AUT"" prefix.",IOM)
 . W !,$$CJ^XLFSTR("One entry needs to be deleted.",IOM)
 . D SORRY(2)
 .Q
 ;
 I $G(XPDQUIT) W !,$$CJ^XLFSTR("FIX IT! Before Proceeding.",IOM),!!,*7,*7,*7 Q
 ;
 W !,$$CJ^XLFSTR("No 'AUT' dups in PACKAGE file",IOM)
 W !!,$$CJ^XLFSTR("ENVIRONMENT OK.",IOM)
 ;
 D HELP^XBHELP("INTROE","AUT98P10")
 I '$$DIR^XBDIR("E","","","","","",1) D SORRY(2) Q
 ;
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0 D HELP^XBHELP("INTROI","AUT98P10")
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
 D BMES^XPDUTL("Beginning pre-install routine (PRE^AUT98P10).")
 D AUDS
 D BMES^XPDUTL("Pre-install routine is complete.")
 Q
 ;
POST ;EP - From KIDS.
 D BMES^XPDUTL("Beginning post-install routine (POST^AUT98P10).")
 D AUDR,MAIL
 D BMES^XPDUTL("Post-install routine is complete.")
 Q
 ;
MAIL ;
 D BMES^XPDUTL("Delivering MailMan message to select users...")
 NEW DIFROM,XMSUB,XMDUZ,XMTEXT,XMY
 KILL ^TMP("AUT98P10",$J)
 D RSLT(" --- AUT v 98.1, Patch 10, has been installed into this uci ---")
 F %=1:1 D RSLT($P($T(GREET+%),";",3)) Q:$P($T(GREET+%+1),";",3)="###"
 S %=0
 F  S %=$O(^XTMP("XPDI",XPDA,"BLD",XPDBLD,1,%)) Q:'%   D RSLT(^(%,0))
 S XMSUB=$P($P($T(+1),";",2)," ",3,99),XMDUZ=$S($G(DUZ):DUZ,1:.5),XMTEXT="^TMP(""AUT98P10"",$J,",XMY(1)="",XMY(DUZ)=""
 F %="XUMGR","XUPROG","XUPROGMODE" D SINGLE(%)
 D ^XMD
 KILL ^TMP("AUT98P10",$J)
 Q
 ;
RSLT(%) S ^(0)=$G(^TMP("AUT98P10",$J,0))+1,^(^(0))=%
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
 ;;(1) In EDUCATION TOPICS, field INACTIVE DATE is added,
 ;;(2) In EMPLOYER GROUP INSURANCE, the VISIT TYPE multiple is redefined,
 ;;(3) Four files w/data are added for accreditation and certification,
 ;;(4) Two forms are added for adds/edits to the certification files.
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
 ;;Standard data dictionaries on your RPMS system have been updated.
 ;;  
 ;;You are receiving this message because of the particular RPMS
 ;;security keys that you hold.  This is for your information, only.
 ;;You need do nothing in response to this message.
 ;;  
 ;;Questions about this patch, which is a product of the RPMS DBA
 ;;can be directed to the
 ;;Help Desk
 ;;Please refer to patch "AUT*98.1*10".
 ;;  
 ;;Requests for modifications or additions to RPMS standard data
 ;;dictionaries must be directed to the RPMS DBA.
 ;;  
 ;;###;NOTE: This line indicates the end of text in this message.
 ;
 ; -----------------------------------------------------
 ; The global location for dictionary audit is:
 ;           ^DD(FILE,0,"DDA")
 ; If the valuey is "Y", dd audit is on.  Any other value, or the
 ; absence of the node, means dd audit is off.
 ; -----------------------------------------------------
AUDS ; Save current settings, and SET dd auditing 'on'.
 D MES^XPDUTL("Saving current DD AUDIT settings for files in this patch")
 D MES^XPDUTL("and turning DD AUDIT to 'Y'.")
 S ^XTMP("AUT98P10",0)=$$FMADD^XLFDT(DT,10)_"^"_DT_"^"_$P($P($T(+1),";",2)," ",3,99)
 NEW AUM
 S AUM=0
 F  S AUM=$O(^XTMP("XPDI",XPDA,"FIA",AUM)) Q:'AUM  D
 . I '$D(^XTMP("AUT98P10",AUM,"DDA")) S ^XTMP("AUT98P10",AUM,"DDA")=$G(^DD(AUM,0,"DDA"))
 . D MES^XPDUTL(" File "_$$RJ^XLFSTR(AUM,12)_" - "_$$LJ^XLFSTR(^XTMP("XPDI",XPDA,"FIA",AUM),30)_"- DD audit was '"_$G(^XTMP("AUT98P10",AUM,"DDA"))_"'"),MES^XPDUTL($$RJ^XLFSTR("Set to 'Y'",69))
 . S ^DD(AUM,0,"DDA")="Y"
 .Q
 Q
 ; -----------------------------------------------------
AUDR ; Restore the file data audit values to their original values.
 D MES^XPDUTL("Restoring DD AUDIT settings for files in this patch")
 NEW AUM
 S AUM=0
 F  S AUM=$O(^XTMP("AUT98P10",AUM)) Q:'AUM  D
 . S ^DD(AUM,0,"DDA")=^XTMP("AUT98P10",AUM,"DDA")
 . D MES^XPDUTL(" File "_$$RJ^XLFSTR(AUM,12)_" - "_$$LJ^XLFSTR($$GET1^DID(AUM,"","","NAME"),30)_"- DD AUDIT Set to '"_^DD(AUM,0,"DDA")_"'")
 .Q
 KILL ^XTMP("AUT98P10")
 Q
 ; -----------------------------------------------------
 ;
