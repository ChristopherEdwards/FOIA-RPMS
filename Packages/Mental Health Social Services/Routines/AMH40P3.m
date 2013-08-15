AMH40P3 ; IHS/CMI/LAB - POST INIT BH 16 Apr 2009 7:37 AM 01 Aug 2009 5:37 AM ; 13 Apr 2010  3:54 PM
 ;;4.0;IHS BEHAVIORAL HEALTH;**3**;JUN 18, 2010;Build 10
 ;
ENV ;EP 
 F X="XPO1","XPZ1","XPZ2","XPI1" S XPDDIQ(X)=0
 I +$$VERSION^XPDUTL("XU")<8 D MES^XPDUTL($$CJ^XLFSTR("Version 8.0 of KERNEL is required.  Not installed",80)) D SORRY(2) I 1
 E  D MES^XPDUTL($$CJ^XLFSTR("Requires Kernel Version 8.0....Present.",80))
 I +$$VERSION^XPDUTL("DI")<22 D MES^XPDUTL($$CJ^XLFSTR("Version 22.0 of FILEMAN is required.  Not installed.",80)) D SORRY(2) I 1
 E  D MES^XPDUTL($$CJ^XLFSTR("Requires Fileman v22....Present.",80))
 I $E($$VERSION^XPDUTL("AMH"),1,3)'="4.0" D MES^XPDUTL($$CJ^XLFSTR("Version 4.0 of AMH is required.  Not installed.",80)) D SORRY(2) I 1
 E  D MES^XPDUTL($$CJ^XLFSTR("Requires AMH v4.0....Present.",80))
 I '$$INSTALLD("AMH*4.0*2") D SORRY(2)
 Q
 ;
PRE ;
 S DA=0 F  S DA=$O(^AMHRECD(DA)) Q:DA'=+DA  S DIK="^AMHRECD(" D ^DIK
 K DA,DIK
 Q
 ;
POST ;EP
 ;D RESET  ;reset AEX for all visits with a visit date 100106 or greater.
 ;set new site parameter to 1 if it is not filled in
 S AMHX=0 F  S AMHX=$O(^AMHSITE(AMHX)) Q:AMHX'=+AMHX  D
 .I $P($G(^AMHSITE(AMHX,18)),U,10)'="" Q  ;already set
 .S DA=AMHX,DIE="^AMHSITE(",DR="1810///1" D ^DIE K DA,DR,DIE
 D MENU
 D ZISH
 D BMXPO
 Q
 ;
MENU ;add export option to menu
 N X
 S X=$$ADD^XPDMENU("AMH M EXPORT UTILITY","AMH EY AUTO EXPORT","SAE")
 Q
 ;
ZISH ;create entry in ZISH SEND PARAMETERS file
 D ^XBFMK K DIADD,DLAYGO,DIC,DD,D0,DO
 ;Q:$D(^%ZIB(9888888.93,"B","AMH AUTO SEND"))
 S APCLY=0 F  S APCLY=$O(^%ZIB(9888888.93,"B","AMH AUTO SEND",0)) Q:APCLY'=+APCLY  D
 .I APCLY S DA=APCLY,DIK="^%ZIB(9888888.93," D ^DIK K DA,DIK
 S X="AMH AUTO SEND",DIC(0)="L",DIC="^%ZIB(9888888.93," D FILE^DICN
 I Y=-1 W !!,"error creating ZISH SEND PARAMETERS entry" Q
 S DA=+Y,DIE="^%ZIB(9888888.93,",DR=".02///QUOVADX-IE.IHS.GOV;.03///ihpesusr;.04///g2dwy66b;.06///-u;.07///B;.08///sendto"
 D ^DIE
 I $D(Y) W !!,"error updating ZISH SEND PARAMETERS entry" Q
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
