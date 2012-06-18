AUT981P9 ;IHS/ASDST/GTH - AUT 98.1 PATCH 9 ; [ 01/07/2002   3:22 PM ]
 ;;98.1;IHS DICTIONARIES (POINTERS);**9**;MAR 04, 1998
 ;
 ; IHS/ASDST/GTH AUT*98.1*9 01/07/2002
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
 I X<98.1,+X'=1.1 D SORRY(2) Q
 ;
 Q:'$$VCHK("DI","21.0",2)
 Q:'$$VCHK("XU","8.0",2)
 ;
 NEW DA,DIC
 S X="AUT",DIC="^DIC(9.4,",DIC(0)="",D="C"
 D IX^DIC
 I Y<0,$D(^DIC(9.4,"C","AUT")) D  Q
 . W !!,*7,*7,$$CJ^XLFSTR("You Have More Than One Entry In The",IOM),!,$$CJ^XLFSTR("PACKAGE File with an ""AUT"" prefix.",IOM)
 . W !,$$CJ^XLFSTR("One entry needs to be deleted.",IOM)
 . W !,$$CJ^XLFSTR("FIX IT! Before Proceeding.",IOM),!!,*7,*7,*7
 . D SORRY(2)
 . I $$DIR^XBDIR("E")
 .Q
 W !,$$CJ^XLFSTR("No 'AUT' dups in PACKAGE file",IOM)
 ;
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 ;
 W !!,$$CJ^XLFSTR("ENVIRONMENT OK.",IOM)
 ;
 I '$$DIR^XBDIR("E","","","","","",1) D SORRY(2) Q
 Q
 ;
SORRY(X) ;
 KILL DIFQ
 S XPDQUIT=X
 W:'$D(ZTQUEUED) *7,!,$$CJ^XLFSTR("Sorry....",IOM),$$DIR^XBDIR("E","Press RETURN")
 Q
 ;
VCHK(AUTPRE,AUTVER,AUTQUIT) ; Check versions needed.
 ;  
 NEW AUTV
 S AUTV=$$VERSION^XPDUTL(AUTPRE)
 W !,$$CJ^XLFSTR("Need at least "_AUTPRE_" v "_AUTVER_"....."_AUTPRE_" v "_AUTV_" Present",IOM)
 I AUTV<AUTVER KILL DIFQ S XPDQUIT=AUTQUIT W *7,!,$$CJ^XLFSTR("Sorry....",IOM) S AUTV=$$DIR^XBDIR("E","Press RETURN") Q 0
 Q 1
 ;
PRE ;EP - From KIDS.
 D BMES^XPDUTL("Beginning pre-install routine (PRE^AUT981P9).")
 D BMES^XPDUTL("Removing fields from RPMS SITE file.")
 NEW DA,DIK
 S DIK="^DD(9999999.3911,",DA(1)=9999999.3911,DA=.01
 D ^DIK
 KILL ^DD(9999999.3911) ; 4 of the 0th nodes aren't KILL'd by ^DIK.
 S DIK="^DD(9999999.39,",DA(1)=9999999.39
 F DA=1,2,1101 D ^DIK
 D BMES^XPDUTL("Pre-install routine is complete.")
 Q
 ;
POST ;EP - From KIDS.
 D BMES^XPDUTL("Beginning post-install routine (POST^AUT981P9).")
 D BMES^XPDUTL("Delivering MailMan message to select users...")
 D MAIL
 D BMES^XPDUTL("Post-install routine is complete.")
 Q
 ;
MAIL ; Send install mail message.
 NEW DIFROM,XMSUB,XMDUZ,XMTEXT,XMY
 KILL ^TMP("AUTP9MSG",$J)
 S ^TMP("AUTP9MSG",$J,1)=" --- AUT v 6, Patch 9, has been installed into this uci ---"
 S %=0
 F  S %=$O(^XTMP("XPDI",XPDA,"BLD",XPDBLD,1,%)) Q:'%   S ^TMP("AUTP9MSG",$J,(%+1))=" "_^(%,0)
 S XMSUB=$P($P($T(+1),";",2)," ",3,99),XMDUZ=$S($G(DUZ):DUZ,1:.5),XMTEXT="^TMP(""AUTP9MSG"",$J,",XMY(1)="",XMY(DUZ)=""
 F %="XUMGR","XUPROG","XUPROGMODE" D SINGLE(%)
 D ^XMD
 KILL ^TMP("AUTP9MSG",$J)
 Q
 ;
SINGLE(K) ; Get holders of a single key K.
 NEW Y
 S Y=0
 Q:'$D(^XUSEC(K))
 F  S Y=$O(^XUSEC(K,Y)) Q:'Y  S XMY(Y)=""
 Q
 ;
INSTALLD(AUT) ;EP - Determine if patch AUT was installed, where AUT is
 ; the name of the INSTALL.  E.g "AUT*98.1*7".
 ;
 NEW DIC,X,Y
 ;  lookup package.
 S X=$P(AUT,"*",1)
 S DIC="^DIC(9.4,",DIC(0)="FM",D="C"
 D IX^DIC
 I Y<1 Q 0
 ;  lookup version.
 S DIC=DIC_+Y_",22,",X=$P(AUT,"*",2)
 D ^DIC
 I Y<1 Q 0
 ;  lookup patch.
 S DIC=DIC_+Y_",""PAH"",",X=$P(AUT,"*",3)
 D ^DIC
 Q $S(Y<1:0,1:1)
 ;
