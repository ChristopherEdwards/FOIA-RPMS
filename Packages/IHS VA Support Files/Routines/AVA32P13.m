AVA32P13 ;IHS/ASDST/GTH - AVA 93.2 PATCH 13 ; [ 09/12/2002   3:15 PM ]
 ;;93.2;VA SUPPORT FILES;**13**;JUL 01, 1993
 ;
 ; IHS/ASDST/GTH AVA*93.2*13 09/12/2002
 ;
 I '$G(IOM) D HOME^%ZIS
 ;
 I '$G(DUZ) W !,"DUZ UNDEFINED OR 0." D FAIL(2),SORRY Q
 ;
 I '$L($G(DUZ(0))) W !,"DUZ(0) UNDEFINED OR NULL." D FAIL(2),SORRY Q
 ;
 S X=$P(^VA(200,DUZ,0),U)
 W !!,$$CJ^XLFSTR("Hello, "_$P(X,",",2)_" "_$P(X,","),IOM)
 W !!,$$CJ^XLFSTR("Checking Environment for "_$P($T(+2),";",4)_" V "_$P($T(+2),";",3)_" Patch "_$P($T(+2),";",5)_".",IOM)
 ;
 NEW IORVON,IORVOFF
 S X="IORVON;IORVOFF"
 D ENDR^%ZISS
 ;
 I $$VCHK("AVA","93.2",2)
 I $$VCHK("DI","21.0",2)
 I $$VCHK("XU","8.0",2)
 ;
 NEW DA,DIC
 S X="AVA",DIC="^DIC(9.4,",DIC(0)="",D="C"
 D IX^DIC
 I Y<0,$D(^DIC(9.4,"C","AVA")) D
 . W !!,*7,*7,$$CJ^XLFSTR("You Have More Than One Entry In The",IOM),!,$$CJ^XLFSTR("PACKAGE File with an ""AVA"" prefix.",IOM)
 . W !,$$CJ^XLFSTR(IORVON_"One entry needs to be deleted."_IORVOFF,IOM)
 . W !,$$CJ^XLFSTR("FIX IT! Before Proceeding.",IOM),!!,*7,*7,*7
 . D FAIL(2)
 .Q
 ;
 I $G(XPDENV)=1 D
 . ; The following line prevents the "Disable Options..." and "Move
 . ; Routines..." questions from being asked during the install.
 . S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 .Q
 ;
 I '(DUZ(0)["@") W !,$$CJ^XLFSTR("The dd updates require an '@' in your DUZ(0). "_IORVON_"<<<-- FIX IT!"_IORVOFF,IOM) D FAIL(2)
 ;
 S DA=0
 F  S DA=$O(^VA(200,DA)) Q:'DA  I $P($G(^(DA,"USC1",0)),U,3) D
 . D FAIL(2)
 . W !,$$CJ^XLFSTR("NEW PERSON '"_IORVON_$P(^VA(200,DA,0),U,1)_IORVOFF_"' has a Person Class.",IOM)
 .Q
 ;
 I $D(XPDQUIT) W !!,$$CJ^XLFSTR(IORVON_"Please Fix It!!"_IORVOFF,IOM) D SORRY Q
 ;
 W !!,$$CJ^XLFSTR("ENVIRONMENT OK.",IOM)
 ;
 I '$$DIR^XBDIR("E","","","","","",1) D FAIL(2),SORRY
 Q
 ;
FAIL(X) ;
 KILL DIFQ
 S XPDQUIT=X
 Q
 ;
SORRY ;
 W:'$D(ZTQUEUED) *7,!,$$CJ^XLFSTR("Sorry....",IOM),$$DIR^XBDIR("E","Press RETURN")
 Q
 ;
VCHK(AVAPRE,AVAVER,AVAQUIT) ; Check versions needed.
 ;  
 NEW AVAV,AVAMSG
 S AVAV=$$VERSION^XPDUTL(AVAPRE),AVAMSG=$S(AVAV<AVAVER:" <<<-- FIX IT!",1:"")
 W !,$$CJ^XLFSTR("Need at least "_AVAPRE_" v "_AVAVER_"....."_AVAPRE_" v "_AVAV_" Present"_AVAMSG,IOM)
 I AVAV<AVAVER D FAIL(AVAQUIT) Q 0
 Q 1
 ;
PRE ;EP - From KIDS.
 D BMES^XPDUTL("Beginning pre-install routine (PRE^AVA32P13).")
 D MES^XPDUTL("Deleting entries in PERSON CLASS file (8932.1).")
 KILL ^UTILITY("XBDSET",$J)
 S ^UTILITY("XBDSET",$J,8932.1)=""
 D EN2^XBFRESET
 D MES^XPDUTL("Pre-install routine is complete.")
 Q
 ;
POST ;EP - From KIDS.
 NEW AVA
 D BMES^XPDUTL("Beginning post-install routine (POST^AVA32P13).")
 ;
 D BMES^XPDUTL("Changing sub-file dictionary number in the 9999999.18 multiple...")
 D SFDD
 ;
 D BMES^XPDUTL("Delivering AVA*93.2*13 install message to select users...")
 D MAIL
 ;
 D BMES^XPDUTL("Post-install routine is complete.")
 Q
 ;
SFDD ;
 NEW I,P
 S I=0,P=$P(^DD(200,9999999.18,0),U,2)
 F  S I=$O(^VA(200,I)) Q:'(I=+I)  I $D(^VA(200,I,9999999.18,0)) S $P(^(0),U,2)=P
 Q
 ;
MAIL ; Send install mail message.
 NEW DIFROM,XMSUB,XMDUZ,XMTEXT,XMY
 KILL ^TMP("AVAP13MS",$J)
 S ^TMP("AVAP13MS",$J,1)=" --- AVA v 93.2, Patch 13, has been installed into this uci ---"
 S %=0
 F  S %=$O(^XTMP("XPDI",XPDA,"BLD",XPDBLD,1,%)) Q:'%   S ^TMP("AVAP13MS",$J,(%+1))=" "_^(%,0)
 S XMSUB=$P($P($T(+1),";",2)," ",4,99),XMDUZ=$S($G(DUZ):DUZ,1:.5),XMTEXT="^TMP(""AVAP13MS"",$J,",XMY(1)="",XMY(DUZ)=""
 F %="XUMGR","XUPROG","XUPROGMODE" D SINGLE(%)
 D ^XMD
 KILL ^TMP("AVAP13MS",$J)
 Q
 ;
SINGLE(K) ; Get holders of a single key K.
 NEW Y
 S Y=0
 Q:'$D(^XUSEC(K))
 F  S Y=$O(^XUSEC(K,Y)) Q:'Y  S XMY(Y)=""
 Q
 ;
