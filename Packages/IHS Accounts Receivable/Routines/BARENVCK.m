BARENVCK ;IHS/SD/POT - ENVIRONMENT CHECKER ;   
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26**;OCT 26,2005;Build 17
 ;IHS/SD/POT - BAR*1.8*25 - checker to look for latest patches
 ;IHS/SD/SDR - 1.8*26 - Updated for patch 26; changed all namespacing of variable from ABM to BAR
 ;
 ;
 I '$G(DUZ) W !,"DUZ UNDEFINED OR 0." D SORRY(2) Q
 ;
 I '$L($G(DUZ(0))) W !,"DUZ(0) UNDEFINED OR NULL." D SORRY(2) Q
 ;
 S X=$P(^VA(200,DUZ,0),U)
 W !!,$$CJ^XLFSTR("Hello, "_$P(X,",",2)_" "_$P(X,","),IOM)
 W !!,$$CJ^XLFSTR("Checking Environment for "_$P($T(+2),";",4)_" V "_$P($T(+2),";",3)_" Patch "_$P($T(+2),";",5)_".",IOM),!
 ;
 S XPDQUIT=0
 ;
 I '$$VCHK("DI","22.0",2) S XPDQUIT=2
 ;
 S X=$$PATCH^XPDUTL("DI*22.0*1017")
 I X'=1 W !,$$CJ^XLFSTR("VA Fileman 22 Patch 1017 NOT INSTALLED",IOM) S XPDQUIT=2
 I X=1 W !,$$CJ^XLFSTR("VA Fileman 22 Patch 1017 installed.",IOM)
 K X
 ;
 I '$$VCHK("ABM","2.6",2) S XPDQUIT=2
 N X,BAR,I
 S BAR=1
 F I=1:1:13 D
 .S X=$$PATCH^XPDUTL("ABM*2.6*"_I)
 .I X'=1 S BAR=0 W !,$$CJ^XLFSTR("Need Third Party Billing v2.6 Patch "_I_"..... "_$S(BAR=0:"NOT ",1:"")_"Present",IOM)
 I BAR=0 S XPDQUIT=2
 ;
 ;START NEW CODE- BAR*1.8*25 IHS/SD/POT
 I '$$VCHK("BAR","1.8",2) S XPDQUIT=2
 S BAR=1
 ;F I=9:1:24 D  ;bar*1.8*26 IHS/SD/SDR
 F I=6:1:7,9,10,12,13,14,15,16,17,18,19,20,21,22,23,24,25 D  ;bar*1.8*26 IHS/SD/SDR
 .S X=$$PATCH^XPDUTL("BAR*1.8*"_I)
 .I X'=1 S BAR=0 W !,$$CJ^XLFSTR("Need A/R v1.8 Patch "_I_"..... "_$S(BAR=0:"NOT ",1:"")_"Present",IOM)
 I BAR=0 S XPDQUIT=2
 ;end NEW CODE- BAR*1.8*25 IHS/SD/POT
 ;
 I '$$VCHK("AUT","98.1",2) S XPDQUIT=2
 ;
 S X=$$LAST^BARENVCK("IHS DICTIONARIES (POINTERS)","98.1")
 ;old code I $P(X,U,1)'=14&($P(X,U,1)'>14) W !,$$CJ^XLFSTR("AUT v98.1 Patch 14 NOT INSTALLED",IOM) S XPDQUIT=2 - BAR*1.8*25 IHS/SD/POT
 I $P(X,U,1)'=26&($P(X,U,1)'>26) W !,$$CJ^XLFSTR("AUT v98.1 Patch 26 NOT INSTALLED",IOM) S XPDQUIT=2 ;- BAR*1.8*25 IHS/SD/POT
 ;
 I '$$VCHK("XU","8.0",2) S XPDQUIT=2
 K X
 ;NEW CODE- BAR*1.8*25 IHS/SD/POT
 S X=$$PATCH^XPDUTL("XU*8.0*1017")
 I X'=1 W !,$$CJ^XLFSTR("KERNEL v8.0 Patch 1017 NOT INSTALLED",IOM) S XPDQUIT=2
 I X=1 W !,$$CJ^XLFSTR("XU Patch 1017 installed.",IOM)
 K X
 ;end NEW CODE- BAR*1.8*25 ;IHS/SD/POT
 ;
 ;
 N DA,DIC
 S X="BAR",DIC="^DIC(9.4,",DIC(0)="",D="C"
 D IX^DIC
 I Y<0,$D(^DIC(9.4,"C","BAR")) D  S XPDQUIT=2
 .W !!,*7,*7,$$CJ^XLFSTR("You Have More Than One Entry In The",IOM),!,$$CJ^XLFSTR("PACKAGE File with an ""BAR"" prefix.",IOM)
 .W !,$$CJ^XLFSTR("One entry needs to be deleted.",IOM)
 .W !,$$CJ^XLFSTR("FIX IT! Before Proceeding.",IOM),!!,*7,*7,*7
 .Q
 ;
 I $G(XPDENV)=1 D
 .; The following line prevents the "Disable Options..." and "Move
 .; Routines..." questions from being asked during the install.
 .S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 .D OPTSAV("BARMENU")
 .Q
 ;
 I XPDQUIT D SORRY(XPDQUIT) Q
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
VCHK(BARPRE,BARVER,BARQUIT) ; Check versions needed.
 ;  
 N BARV
 S BARV=$$VERSION^XPDUTL(BARPRE)
 W !,$$CJ^XLFSTR("Need at least "_BARPRE_" v "_BARVER_"....."_BARPRE_" v "_BARV_" Present",IOM)
 I BARV<BARVER W *7,!,$$CJ^XLFSTR("^^^^**NEEDS FIXED**^^^^",IOM) Q 0
 Q 1
 ;
OPTSAV(BARM) ;
 D BMES^XPDUTL("Saving the configuration of option '"_BARM_"'...")
 I $D(^XTMP("BARENVCK",7.2,"OPTSAV",BARM)) D BMES^XPDUTL("NOT SAVED.  Option '"_BARM_"' has previously been saved.") Q
 I '$D(^XTMP("BARENVCK")) S ^XTMP("BARENVCK",0)=$$FMADD^XLFDT(DT,30)_U_DT_U_"BARENVCK - SAVE OPTION CONFIGURATIONS."
 N I,A
 S I=$O(^DIC(19,"B",BARM,0))
 I 'I D BMES^XPDUTL("NOT SAVED.  Option '"_BARM_"' not found in OPTION file.") Q
 S A=0
 F  S A=$O(^DIC(19,I,10,A)) Q:'A  S ^XTMP("BARENVCK",7.2,"OPTSAV",BARM,A)=$P(^DIC(19,+^DIC(19,I,10,A,0),0),U,1)_U_$P(^DIC(19,I,10,A,0),U,2,3)
 Q
 ;
INSTALLD(BARINSTL) ;EP - Determine if patch ABMINSTL was installed, where ABMINSTL is
 ; the name of the INSTALL.  E.g "ABM*2.5*6".
 ;;^DIC(9.4,D0,22,D1,PAH,D2,0)=
 ;;(#.01) PATCH APPLICATION HISTORY [1F] ^ (#.02)DATE APPLIED [2D] ^ (#.03) APPLIED BY [3P] ^ 
 N DIC,X,Y
 S X=$P(BARINSTL,"*",1)
 S DIC="^DIC(9.4,",DIC(0)="FM",D="C"
 D IX^DIC
 I Y<1 Q 0
 S DIC=DIC_+Y_",22,",X=$P(BARINSTL,"*",2)
 D ^DIC
 I Y<1 Q 0
 S DIC=DIC_+Y_",""PAH"",",X=$P(BARINSTL,"*",3)
 D ^DIC
 Q $S(Y<1:0,1:1)
 ;
LAST(PKG,VER) ;EP - returns last patch applied for a Package, PATCH^DATE
 ;        Patch includes Seq # if Released
 N PKGIEN,VERIEN,LATEST,PATCH,SUBIEN
 I $G(VER)="" S VER=$$VERSION^XPDUTL(PKG) Q:'VER -1
 S PKGIEN=$O(^DIC(9.4,"B",PKG,"")) Q:'PKGIEN -1
 S VERIEN=$O(^DIC(9.4,PKGIEN,22,"B",VER,"")) Q:'VERIEN -1
 S LATEST=-1,PATCH=-1,SUBIEN=0
 F  S SUBIEN=$O(^DIC(9.4,PKGIEN,22,VERIEN,"PAH",SUBIEN)) Q:SUBIEN'>0  D
 . I $P(^DIC(9.4,PKGIEN,22,VERIEN,"PAH",SUBIEN,0),U,2)>LATEST S LATEST=$P(^(0),U,2),PATCH=$P(^(0),U)
 . I $P(^DIC(9.4,PKGIEN,22,VERIEN,"PAH",SUBIEN,0),U,2)=LATEST,$P(^(0),U)>PATCH S PATCH=$P(^(0),U)
 Q PATCH_U_LATEST
