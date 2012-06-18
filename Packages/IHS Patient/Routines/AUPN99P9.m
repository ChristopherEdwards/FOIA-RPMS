AUPN99P9 ;IHS/CMI/LAB,GTH,EFG,SDR - AUPN 99.1 PATCH 9 ; [ 05/09/2003  7:59 AM ]
 ;;99.1;IHS DICTIONARIES (PATIENT);**9,10**;JUN 13, 2003
 ;
 ; IHS/SET/GTH AUPN*99.1*8 10/04/2002
 ;
 I '$G(IOM) D HOME^%ZIS
 ;
 I '$G(DUZ) W !,"DUZ UNDEFINED OR 0." D SORRY(2) Q
 ;
 I '$L($G(DUZ(0))) W !,"DUZ(0) UNDEFINED OR NULL." D SORRY(2) Q
 ;
 S X=$P(^VA(200,DUZ,0),U)
 W !!,$$CJ^XLFSTR("Hello, "_$P(X,",",2)_" "_$P(X,","),IOM)
 W !!,$$CJ^XLFSTR("Checking Environment for "_$P($T(+2),";",4)_" V "_$P($T(+2),";",3)_" Patch "_$P($T(+2),";",5)_".",IOM)
 ;
 NEW IORVON,IORVOFF
 S X="IORVON;IORVOFF"
 D ENDR^%ZISS
 ;
 I $$VCHK("AUPN","99.1",2)
 ;
 I '$$INSTALLD("AUT*98.1*7") D SORRY(2)
 ;
 NEW DA,DIC
 S X="AUPN",DIC="^DIC(9.4,",DIC(0)="",D="C"
 D IX^DIC
 I Y<0,$D(^DIC(9.4,"C","AUPN")) D  Q
 . W !!,*7,*7,$$CJ^XLFSTR("You Have More Than One Entry In The",IOM),!,$$CJ^XLFSTR("PACKAGE File with an ""AUPN"" prefix.",IOM)
 . W !,$$CJ^XLFSTR(IORVON_"One entry needs to be deleted."_IORVOFF,IOM)
 . D SORRY(2)
 .Q
 ;
 I $G(XPDQUIT) W !,$$CJ^XLFSTR(IORVON_"FIX IT! Before Proceeding."_IORVOFF,IOM),!!,*7,*7,*7 Q
 ;
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 ;
 W !!,$$CJ^XLFSTR("ENVIRONMENT OK.",IOM)
 ;
 I '$$DIR^XBDIR("E","","","","","",1) D SORRY(3)
 Q
 ;
SORRY(X) ;
 KILL DIFQ
 I X=3 S XPDQUIT=2 Q
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("Sorry....FIX IT!",IOM)
 Q
 ;
VCHK(AUPNPRE,AUPNVER,AUPNQUIT) ; Check versions needed.
 ;  
 NEW AUPNV
 S AUPNV=$$VERSION^XPDUTL(AUPNPRE)
 W !,$$CJ^XLFSTR("Need at least "_AUPNPRE_" v "_AUPNVER_"....."_AUPNPRE_" v "_AUPNV_" Present",IOM)
 I AUPNV<AUPNVER D SORRY(AUPNQUIT) Q 0
 Q 1
 ;
PRE ;EP - From KIDS.
 D BMES^XPDUTL("Beginning Pre-install routine (PRE^AUPN99P9).")
 D MES^XPDUTL("   Checking for installation of AUPN*99.1*6.")
 I '$$INSTALLD("AUPN*99.1*6") D  I 1
 . D MES^XPDUTL("AUPN*99.1*6 NOT installed.  Deleting dd fields .")
 . NEW DIK
 . S DIK="^DD(9000010.24,",DA=.01,DA(1)=9000010.24 D ^DIK
 . S DIK="^DD(9000010.24,",DA=.04,DA(1)=9000010.24 D ^DIK
 . S DIK="^DD(9000010.34,",DA=.01,DA(1)=9000010.34 D ^DIK
 .Q
 E  D MES^XPDUTL("AUPN*99.1*6 is installed.  No dd fields deleted.")
 ;
 D MES^XPDUTL("Pre-install routine is complete.")
 Q
 ;
POST ;EP - From KIDS.
 D BMES^XPDUTL("Beginning post-install routine (POST^AUPN99P9).")
 ;
 D MES^XPDUTL("   Checking for install of AUPN*99.1*5.")
 I '$$INSTALLD("AUPN*99.1*5") D  I 1
 . D MES^XPDUTL("AUPN*99.1*5 not installed."),MES^XPDUTL("  Indexing AE x-ref on Medicaid Eligible...")
 . D POST^AUPN99P5
 . D MES^XPDUTL("X-ref complete.")
 .Q
 E  D MES^XPDUTL("AUPN*99.1*5 is installed.  No action necessary.")
 ;
 D MAIL
 ;
 D ^AUPNSEC
 ;
 D BMES^XPDUTL("Post-install routine is complete.")
 Q
 ;
MAIL ; Send install mail message.
 D BMES^XPDUTL("Delivering AUPN*99.1*9 install message to select users...")
 NEW DIFROM,XMSUB,XMDUZ,XMTEXT,XMY
 KILL ^TMP("AUPN99P9",$J)
 S ^TMP("AUPN99P9",$J,1)=" --- AUPN v 99.1, Patch 9, has been installed into this uci ---"
 S %=0
 F  S %=$O(^XTMP("XPDI",XPDA,"BLD",XPDBLD,1,%)) Q:'%   S ^TMP("AUPN99P9",$J,(%+1))=" "_^(%,0)
 S XMSUB=$P($P($T(+1),";",2)," ",3,99),XMDUZ=$S($G(DUZ):DUZ,1:.5),XMTEXT="^TMP(""AUPN99P9"",$J,",XMY(1)="",XMY(DUZ)=""
 F %="AGZMENU","APCDZMENU","XUMGR","XUPROG","XUPROGMODE" D SINGLE(%)
 D ^XMD
 KILL ^TMP("AUPN99P9",$J)
 Q
 ;
SINGLE(K) ; Get holders of a single key K.
 NEW Y
 S Y=0
 Q:'$D(^XUSEC(K))
 F  S Y=$O(^XUSEC(K,Y)) Q:'Y  S XMY(Y)=""
 Q
 ;
INSTALLD(AUPNSTAL) ;EP - Determine if patch AUPNSTAL was installed, where
 ; AUPNSTAL is the name of the INSTALL.  E.g "AG*6.0*10".
 ;
 NEW AUPNY,DIC,X,Y
 S X=$P(AUPNSTAL,"*",1)
 S DIC="^DIC(9.4,",DIC(0)="FM",D="C"
 D IX^DIC
 I Y<1 D IMES Q 0
 S DIC=DIC_+Y_",22,",X=$P(AUPNSTAL,"*",2)
 D ^DIC
 I Y<1 D IMES Q 0
 S DIC=DIC_+Y_",""PAH"",",X=$P(AUPNSTAL,"*",3)
 D ^DIC
 S AUPNY=Y
 D IMES
 Q $S(AUPNY<1:0,1:1)
IMES ;
 D MES^XPDUTL($$CJ^XLFSTR("Patch """_AUPNSTAL_""" is"_$S(Y<1:" *NOT*",1:"")_" installed.",IOM))
 Q
 ;
