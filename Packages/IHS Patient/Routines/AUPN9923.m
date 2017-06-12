AUPN9923 ;IHS/OIT/FBD - AUPN 99.1 PATCH 23 ENVIRONMENT CHECKS AND POST-INIT ;
 ;;99.1;IHS DICTIONARIES (PATIENT);**23**;APR 8, 2013;Build 9
 ;
 ;
ENV ;ENVIROMENT CHECK
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
 I $$VCHK("DI","22.0",2)
 I $$VCHK("XU","8.0",2)
 I $$VCHK("AUPN","99.1",2)
 ;
 I '$$INSTALLD("AUPN*99.1*22") D SORRY(2)
 I '$$INSTALLD("AUT*98.1*25") D SORRY(2)
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
POST ;EP - AUPN V99.1 PATCH 23 POST-INIT
 ;
 N AUPNCNT,AUPNCNT2
 D MES^XPDUTL("CONVERTING PREFERRED REMINDER VALUES FROM 'MAIL' TO 'LETTER'.")
 S (AUPNCNT,AUPNCNT2)=0 F  S AUPNCNT=$O(^AUPNPAT(AUPNCNT)) Q:'+AUPNCNT  D
 . Q:'$D(^AUPNPAT(AUPNCNT,40))
 . S:$P(^AUPNPAT(AUPNCNT,40),U,2)="M" $P(^AUPNPAT(AUPNCNT,40),U,2)="L",AUPNCNT2=AUPNCNT2+1
 D MES^XPDUTL(AUPNCNT2_" ENTRIES FOUND.")
 Q  ;DEBUG
 ;
 ;D BMES^XPDUTL("Delivering AUPN*99.1*23 install message to select users...")
 NEW DIFROM,XMSUB,XMDUZ,XMTEXT,XMY
 KILL ^TMP("AUPN9923",$J)
 S ^TMP("AUPN9923",$J,1)=" --- AUPN v 99.1, Patch 23, has been installed into this uci ---"
 S %=0
 F  S %=$O(^XTMP("XPDI",XPDA,"BLD",XPDBLD,1,%)) Q:'%   S ^TMP("AUPN9923",$J,(%+1))=" "_^(%,0)
 S XMSUB=$P($P($T(+1),";",2)," ",3,99),XMDUZ=$S($G(DUZ):DUZ,1:.5),XMTEXT="^TMP(""AUPN9923"",$J,",XMY(1)="",XMY(DUZ)=""
 F %="AGZMENU","APCDZMENU","XUMGR","XUPROG","XUPROGMODE" D SINGLE(%)
 D ^XMD
 KILL ^TMP("AUPN9923",$J)
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
