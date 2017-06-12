AMH40P5 ; IHS/CMI/LAB - POST INIT BH 16 Apr 2009 7:37 AM 01 Aug 2009 5:37 AM ; 18 Sep 2014  11:23 AM
 ;;4.0;IHS BEHAVIORAL HEALTH;**5**;JUN 02, 2010;Build 18
 ;
ENV ;EP 
 F X="XPO1","XPZ1","XPZ2","XPI1" S XPDDIQ(X)=0
 I +$$VERSION^XPDUTL("XU")<8 D MES^XPDUTL($$CJ^XLFSTR("Version 8.0 of KERNEL is required.  Not installed",80)) D SORRY(2) I 1
 E  D MES^XPDUTL($$CJ^XLFSTR("Requires Kernel Version 8.0....Present.",80))
 I +$$VERSION^XPDUTL("DI")<22 D MES^XPDUTL($$CJ^XLFSTR("Version 22.0 of FILEMAN is required.  Not installed.",80)) D SORRY(2) I 1
 E  D MES^XPDUTL($$CJ^XLFSTR("Requires Fileman v22....Present.",80))
 I $E($$VERSION^XPDUTL("AMH"),1,3)'="4.0" D MES^XPDUTL($$CJ^XLFSTR("Version 4.0 of AMH is required.  Not installed.",80)) D SORRY(2) I 1
 E  D MES^XPDUTL($$CJ^XLFSTR("Requires AMH v4.0....Present.",80))
 I '$$INSTALLD("AMH*4.0*4") D SORRY(2)
 Q
 ;
PRE ;
 Q
 ;
POST ;EP
 S X=$$DELETE^XPDMENU("AMH M PRINT TABLES","AMH P TABLES MHSS PROB CODES")
 D ICD10
 ;INACTIVATE 8.4
 S DA=$O(^AMHPROB("B","8.4",0)) I DA S DIE="^AMHPROB(",DR=".13///1;.14////"_DT D ^DIE K DIE,DA,DR
 ;D BMXPO
 Q
BMXPO ;-- update the RPC file
 N AMHRPC
 S AMHRPC=$O(^DIC(19,"B","AMHGRPC",0))
 Q:'AMHRPC
 D CLEAN(AMHRPC)
 D GUIEP^BMXPO(.RETVAL,AMHRPC_"|AMH")
 Q
 ;
CLEAN(APP) ;-- clean out the RPC multiple first
 S DA(1)=APP
 S DIK="^DIC(19,"_DA(1)_","_"""RPC"""_","
 N AMHDA
 S AMHDA=0 F  S AMHDA=$O(^DIC(19,APP,"RPC",AMHDA)) Q:'AMHDA  D
 . S DA=AMHDA
 . D ^DIK
 K ^DIC(19,APP,"RPC","B")
 Q
INSTALLD(AMHSTAL) ;EP - Determine if patch AMHSTAL was installed, where
 ; APCLSTAL is the name of the INSTALL.  E.g "AG*6.0*11".
 ;
 NEW AMHY,DIC,X,Y
 S X=$P(AMHSTAL,"*",1)
 S DIC="^DIC(9.4,",DIC(0)="FM",D="C"
 D IX^DIC
 I Y<1 D IMES Q 0
 S DIC=DIC_+Y_",22,",X=$P(AMHSTAL,"*",2)
 D ^DIC
 I Y<1 D IMES Q 0
 S DIC=DIC_+Y_",""PAH"",",X=$P(AMHSTAL,"*",3)
 D ^DIC
 S AMHY=Y
 D IMES
 Q $S(AMHY<1:0,1:1)
IMES ;
 D MES^XPDUTL($$CJ^XLFSTR("Patch """_AMHSTAL_""" is"_$S(Y<1:" *NOT*",1:"")_" Present.",IOM))
 Q
SORRY(X) ;
 KILL DIFQ
 I X=3 S XPDQUIT=2 Q
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("Sorry....FIX IT!",IOM)
 Q
ICD10 ;
 NEW AMHTEXT,AMHY,AMHTX,X,AMHCODE,AMHPC,AMH10
 S AMHTEXT="ICDNEW" F AMHY=1:1 S AMHTX=$P($T(@AMHTEXT+AMHY),";;",2,3) Q:AMHTX=""  D
 .S (X,AMHCODE)=$P(AMHTX,";;",1)
 .S AMHPC=$O(^AMHPROB("B",AMHCODE,0))
 .I AMHPC="" D MES^XPDUTL("Problem code: "_$P(AMHTX,";;",1)_" does not exist") Q
 .S AMH10=$P(AMHTX,";;",2)
 .S DA=AMHPC,DIE="^AMHPROB(",DR=".13///@;.14///@;.17///"_AMH10 D ^DIE K DA,DIE,DR
 .I $D(Y) W !,AMHPC," DID NOT UPDATE"
 .Q
 Q
ICDNEW ;
 ;;1;;Z74.2
 ;;1.1;;Z71.89
 ;;2;;Z60.3
 ;;3;;F69.
 ;;4;;Z51.89
 ;;5;;Z92.89
 ;;6.1;;Z92.89
 ;;6.2;;Z92.89
 ;;7;;Z91.19
 ;;8;;Z91.19
 ;;8.1;;
 ;;8.11;;Z91.19
 ;;8.2;;
 ;;8.21;;
 ;;8.3;;
 ;;8.4;;Z76.5
 ;;38.2;;Z76.0
 ;;39;;R45.851
 ;;40;;F48.9
 ;;41;;R99.
 ;;54.1;;
 ;;70;;Z59.8
 ;;71;;Z59.8
 ;;72;;Z62.21
 ;;72.1;;Z71.89
 ;;73;;Z51.89
 ;;74;;Z51.89
 ;;75;;Z51.89
 ;;76;;Z51.89
 ;;77;;Z59.3
 ;;78;;Z02.89
 ;;79;;Z59.5
 ;;79.1;;Z59.5
 ;;79.2;;Z75.4
 ;;81;;Z71.3
 ;;83;;Z59.9
 ;;85;;Z59.9
 ;;86;;Z65.3
 ;;87;;Z65.3
 ;;88;;Z65.3
 ;;89;;Z55.9
 ;;89.1;;
 ;;90;;Z55.9
 ;;91;;Z55.9
 ;;92;;Z51.89
 ;;93;;Z60.9
 ;;94;;Z60.0
 ;;94.1;;Z65.8
 ;;94.2;;R41.83
 ;;95;;
 ;;96;;
 ;;97;;
 ;;98;;
 ;;99;;
