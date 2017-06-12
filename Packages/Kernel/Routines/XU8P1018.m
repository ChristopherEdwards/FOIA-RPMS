XU8P1018 ;IHS/OIT/FBD - XU V8.0 PATCH 1018 ;
 ;;8.0;KERNEL;**1018**;JUNE 4, 2015;Build 8
 ;
 ;
ENV ;ENVIROMENT CHECK
 I '$G(IOM) D HOME^%ZIS
 ;
 I '$G(DUZ) D MES^XPDUTL("No valid user identification found; aborting.") D SORRY(2) Q
 ;
 I '$L($G(DUZ(0))) D MES^XPDUTL("No valid user location found; aborting.") D SORRY(2) Q
 ;
 S X=$P(^VA(200,DUZ,0),U)
 W !!,$$CJ^XLFSTR("Hello, "_$P(X,",",2)_" "_$P(X,","),IOM)
 W !!,$$CJ^XLFSTR("Checking Environment for "_$P($T(+2),";",4)_" V "_$P($T(+2),";",3)_" Patch "_$P($T(+2),";",5)_".",IOM)
 ;
 NEW IORVON,IORVOFF
 S X="IORVON;IORVOFF"
 D ENDR^%ZISS
 ;
 I $$VCHK("DI","22.0",2)
 I $$VCHK("XT","7.3",2)
 I $$VCHK("XM","8.0",2)
 I $$VCHK("XU","8.0",2)
 ;
 I '$$INSTALLD("DI*22.0*170") D SORRY(2)
 I '$$INSTALLD("XT*7.3*137") D SORRY(2)
 I '$$INSTALLD("XM*8.0*45") D SORRY(2)
 I '$$INSTALLD("XU*8.0*638") D SORRY(2)
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
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"),XPDDIQ("XPO1"),XPDDIQ("XPI1"))=0
 ;
 W !!,$$CJ^XLFSTR("ENVIRONMENT OK.",IOM)
 ;
 I '$$DIR^XBDIR("E","","","","","",1) D SORRY(3)
 Q  ;ENVIRONMENT CHECK EXIT
 ;
SORRY(X) ;
 KILL DIFQ
 I X=3 S XPDQUIT=2 Q
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("Sorry....FIX IT!",IOM)
 Q
 ;
 ; 
VCHK(AUPNPRE,AUPNVER,AUPNQUIT) ; Check versions needed.
 ;  
 NEW AUPNV
 S AUPNV=$$VERSION^XPDUTL(AUPNPRE)
 W !,$$CJ^XLFSTR("Need at least "_AUPNPRE_" v "_AUPNVER_"....."_AUPNPRE_" v "_AUPNV_" Present",IOM)
 I AUPNV<AUPNVER D SORRY(AUPNQUIT) Q 0
 Q 1
 ;
 ;
POST ;EP - XU V8.0 PATCH 1018 POST-INIT
 ;
 D BMES^XPDUTL($$CJ^XLFSTR("Beginning XU v8.0 patch 1018 post-init process.",80))
 ;
 D BMES^XPDUTL($$CJ^XLFSTR("Running ^ZTMGRSET to verify deployment of IHS-modified %-routines...",80))
 D ^ZTMGRSET
 ;
 D MES^XPDUTL($$CJ^XLFSTR("Changing Kernel temp file settings to Cache-appropriate default...",80))
 K DA,DIE,DR
 S DIE="^XTV(8989.3,",DA=1,DR=".07///1"
 D ^DIE
 ;
 D MES^XPDUTL($$CJ^XLFSTR("Cleaning up mail group/member cross-references...",80))
 K ^XMB(3.8,"AB")  ;FLUSH MAIL GROUP FILE'S OLD 'AB' XREF (MEMBER/MAIL GROUP)
 S XUMG=0  ;INITIAL SEED VALUE TO LOOP THROUGH ALL MAIL GROUPS
 F  S XUMG=$O(^XMB(3.8,XUMG)) Q:XUMG'=+XUMG  D  ;RUN THROUGH ALL MAIL GROUPS
 . K DIK,DA
 . S DIK="^XMB(3.8,"_XUMG_",1,"  ;MEMBER SUBFILE GLOBAL ROOT FOR THIS MAIL GROUP
 . S DIK(1)=".01^AB"  ;EXECUTE 'SET' LOGIC ON MEMBER FIELD'S AB XREF ONLY
 . S DA(1)=XUMG
 . D ENALL^DIK
 K DIK,DA
 ;
 D MES^XPDUTL($$CJ^XLFSTR("Purging obsolete user edit templates...",80))
 F XUZTEMP="XUEDIT CHARACTERISTICS","XUEXISTING USER","XUNEW USER" D  ;SCAN FOR FILE 3/FILE 200-CONFLICTING USER EDIT TEMPLATES
 . S XUZDA=""
 . F  S XUZDA=$O(^DIE("B",XUZTEMP,XUZDA)) Q:'+XUZDA  D  ;SCAN FOR MULTIPLE ENTRIES OF SPECIFIED TEMPLATE
 . . I $P($G(^DIE(XUZDA,0)),U,4)=3 D  ;KILL IF SPECIFIED ENTRY IS ASSOCIATED WITH FILE 3 (USER) - ONLY FILE 200 (NEW USER) ASSOCIATED TEMPLATES SHOULD REMAIN
 . . . K DA,DIE,DR
 . . . S DIE="^DIE(",DA=XUZDA,DR=".01///@"
 . . . D ^DIE
 K XUZTEMP,XUZDA
 ;
 D MES^XPDUTL($$CJ^XLFSTR("After purge, verifying Kernel reference of valid user edit template...",80))
 S XUZTEMP=$P(^XTV(8989.3,1,3),U,2)  ;CURRENT 'USER CHARACTERISTICS TEMPLATE' FIELD REFERENCE
 I $D(^DIE(XUZTEMP,0)) D  ;LEAVE ALONE IF EXISTING TEMPLATE REFERENCE IS VALID
 . D MES^XPDUTL($$CJ^XLFSTR("- Valid template reference exists.",80))
 . I 1
 E  D  ;ELSE FIX IF REFERENCED TEMPLATE NO LONGER EXISTS AFTER PURGE
 . D MES^XPDUTL($$CJ^XLFSTR("- Valid template reference does NOT exist; correcting...",80))
 . S XUZTEMP="XUEDIT CHARACTERISTICS"  ;KERNEL'S DEFAULT USER EDIT TEMPLATE
 . S XUZDA=$O(^DIE("B",XUZTEMP,""))  ;LOCATE DEFAULT TEMPLATE
 . K DA,DIE,DR
 . S DIE="^XTV(8989.3,",DA=1
 . S DR="12///"_$S(+XUZDA:"`"_XUZDA,1:"@")  ;USE DEFAULT TEMPLATE IEN IF LOCATED, ELSE FLUSH 'USER CHARACTERISTICS TEMPLATE' FIELD OF BAD POINTER
 . D ^DIE
 K XUZTEMP,XUZDA
 ;
 D MES^XPDUTL($$CJ^XLFSTR("Re-verifying/cleaning up ""PT"" file pointer indication nodes...",80))
 D ^XBFIXPT
 ;
 ;
 D BMES^XPDUTL("Delivering XU*8.0*1018 install message to select users...")
 NEW DIFROM,XMSUB,XMDUZ,XMTEXT,XMY
 KILL ^TMP("XU8P1018",$J)
 S ^TMP("XU8P1018",$J,1)=" --- XU v 8.0, Patch 1018, has been installed into this uci ---"
 S %=0
 F  S %=$O(^XTMP("XPDI",XPDA,"BLD",XPDBLD,1,%)) Q:'%   S ^TMP("XU8P1018",$J,(%+1))=" "_^(%,0)
 S XMSUB=$P($P($T(+1),";",2)," ",3,99),XMDUZ=$S($G(DUZ):DUZ,1:.5),XMTEXT="^TMP(""XU8P1018"",$J,",XMY(1)="",XMY(DUZ)=""
 F %="XUMGR","XUPROG","XUPROGMODE" D SINGLE(%)
 D ^XMD
 KILL ^TMP("XU8P1018",$J)
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
 ; AUPNSTAL is the name of the INSTALL.  E.g "AG*6.0*11".
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
