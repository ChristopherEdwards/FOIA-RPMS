AUPN9924 ;IHS/OIT/NKD - AUPN 99.1 PATCH 24 ENVIRONMENT CHECKS AND POST-INIT ; 02/19/2015
 ;;99.1;IHS DICTIONARIES (PATIENT);**24**;MAR 9, 1999;Build 1
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
 I '$$INSTALLD("AUPN*99.1*23") W *7,!,$$CJ^XLFSTR("Sorry....FIX IT! ***DISABLED***",IOM) D SORRY(2)
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
POST ;EP - AUPN V99.1 PATCH 24 POST-INIT
 ;
 ; RUN MCD ELIGIBILITY CLEANUP
 D MES^XPDUTL("RUNNING POST-INSTALL MEDICAID ELIGIBILITY CLEANUP")
 D ^AUPNMCDF
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
