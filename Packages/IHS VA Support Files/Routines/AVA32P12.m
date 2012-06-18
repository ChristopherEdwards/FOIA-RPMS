AVA32P12 ;IHS/ASDST/GTH - AVA 93.2 PATCH 12 ; [ 02/13/2002   5:15 PM ]
 ;;93.2;VA SUPPORT FILES;**12**;JUL 01, 1993
 ;
 ; IHS/ASDST/GTH AVA*93.2*12 02/13/2002
 ;
 I '$G(DUZ) W !,"DUZ UNDEFINED OR 0." D SORRY(2) Q
 ;
 I '$L($G(DUZ(0))) W !,"DUZ(0) UNDEFINED OR NULL." D SORRY(2) Q
 ;
 S X=$P(^VA(200,DUZ,0),U)
 W !!,$$CJ^XLFSTR("Hello, "_$P(X,",",2)_" "_$P(X,","),IOM)
 W !!,$$CJ^XLFSTR("Checking Environment for "_$P($T(+2),";",4)_" V "_$P($T(+2),";",3)_" Patch "_$P($T(+2),";",5)_".",IOM)
 ;
 Q:'$$VCHK("AVA","93.2",2)
 Q:'$$VCHK("DI","21.0",2)
 Q:'$$VCHK("XU","8.0",2)
 ;
 NEW DA,DIC
 S X="AVA",DIC="^DIC(9.4,",DIC(0)="",D="C"
 D IX^DIC
 I Y<0,$D(^DIC(9.4,"C","AVA")) D  Q
 . W !!,*7,*7,$$CJ^XLFSTR("You Have More Than One Entry In The",IOM),!,$$CJ^XLFSTR("PACKAGE File with an ""AVA"" prefix.",IOM)
 . W !,$$CJ^XLFSTR("One entry needs to be deleted.",IOM)
 . W !,$$CJ^XLFSTR("FIX IT! Before Proceeding.",IOM),!!,*7,*7,*7
 . D SORRY(2)
 . I $$DIR^XBDIR("E")
 .Q
 W !,$$CJ^XLFSTR("No 'AVA' dups in PACKAGE file",IOM)
 ;
 I $G(XPDENV)=1 D
 . ; The following line prevents the "Disable Options..." and "Move
 . ; Routines..." questions from being asked during the install.
 . S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 .Q
 ;
 I '(DUZ(0)["@") W !,"The dd updates require an '@' in your DUZ(0).",!,"Everything else looks OK!" D SORRY(2) Q
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
VCHK(AVAPRE,AVAVER,AVAQUIT) ; Check versions needed.
 ;  
 NEW AVAV
 S AVAV=$$VERSION^XPDUTL(AVAPRE)
 W !,$$CJ^XLFSTR("Need at least "_AVAPRE_" v "_AVAVER_"....."_AVAPRE_" v "_AVAV_" Present",IOM)
 I AVAV<AVAVER KILL DIFQ S XPDQUIT=AVAQUIT W *7,!,$$CJ^XLFSTR("Sorry....",IOM) S AVAV=$$DIR^XBDIR("E","Press RETURN") Q 0
 Q 1
 ;
PRE ;EP - From KIDS.
 Q
 D BMES^XPDUTL("Beginning pre-install routine (PRE^AVA32P12).")
 D BMES^XPDUTL("Pre-install routine is complete.")
 Q
 ;
POST ;EP - From KIDS.
 NEW AVA
 D BMES^XPDUTL("Beginning post-install routine (POST^AVA32P12).")
 ;
 D BMES^XPDUTL("Changing sub-file dictionary number in the 9999999.18 multiple...")
 D SFDD
 ;
 D BMES^XPDUTL("Delivering AVA*93.2*12 install message to select users...")
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
 KILL ^TMP("AVAP12MS",$J)
 S ^TMP("AVAP12MS",$J,1)=" --- AVA v 93.2, Patch 12, has been installed into this uci ---"
 S %=0
 F  S %=$O(^XTMP("XPDI",XPDA,"BLD",XPDBLD,1,%)) Q:'%   S ^TMP("AVAP12MS",$J,(%+1))=" "_^(%,0)
 S XMSUB=$P($P($T(+1),";",2)," ",4,99),XMDUZ=$S($G(DUZ):DUZ,1:.5),XMTEXT="^TMP(""AVAP12MS"",$J,",XMY(1)="",XMY(DUZ)=""
 F %="XUMGR","XUPROG","XUPROGMODE" D SINGLE(%)
 D ^XMD
 KILL ^TMP("AVAP12MS",$J)
 Q
 ;
SINGLE(K) ; Get holders of a single key K.
 NEW Y
 S Y=0
 Q:'$D(^XUSEC(K))
 F  S Y=$O(^XUSEC(K,Y)) Q:'Y  S XMY(Y)=""
 Q
 ;
