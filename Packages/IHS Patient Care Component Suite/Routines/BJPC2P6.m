BJPC2P6 ; IHS/CMI/LAB - PCC Suite v1.0 patch 3 environment check ;   
 ;;2.0;IHS PCC SUITE;**6**;MAY 14, 2009;Build 11
 ;
 ;
 ; The following line prevents the "Disable Options..." and "Move Routines..." questions from being asked during the install.
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 F X="XPO1","XPZ1","XPZ2","XPI1" S XPDDIQ(X)=0
 ;KERNEL
 I +$$VERSION^XPDUTL("XU")<8 D MES^XPDUTL($$CJ^XLFSTR("Version 8.0 of KERNEL is required.  Not installed",80)) D SORRY(2) I 1
 E  D MES^XPDUTL($$CJ^XLFSTR("Requires Kernel Version 8.0....Present.",80))
 ;FILEMAN
 I +$$VERSION^XPDUTL("DI")<22 D MES^XPDUTL($$CJ^XLFSTR("Version 22.0 of FILEMAN is required.  Not installed.",80)) D SORRY(2) I 1
 E  D MES^XPDUTL($$CJ^XLFSTR("Requires Fileman v22....Present.",80))
 ;BJPC
 I $$VERSION^XPDUTL("BJPC")'="2.0" D MES^XPDUTL($$CJ^XLFSTR("Version 2.0 of the IHS PCC SUITE (BJPC) is required.  Not installed",80)) D SORRY(2) I 1
 E  D MES^XPDUTL($$CJ^XLFSTR("Requires IHS PCC Suite (BJPC) Version 2.0....Present.",80))
 ;BJPC 2.0 PATCH 4
 I '$$INSTALLD("BJPC*2.0*5") D SORRY(2)
 I '$$INSTALLD("APCL*3.0*27") D SORRY(2)
 ;
 Q
 ;
PRE ;
 S BJPCX=0 F  S BJPCX=$O(^APCMMUM(BJPCX)) Q:BJPCX'=+BJPCX  S DA=BJPCX,DIK="^APCMMUM(" D ^DIK
 S BJPCX=0 F  S BJPCX=$O(^APCMMUPL(BJPCX)) Q:BJPCX'=+BJPCX  S DA=BJPCX,DIK="^APCMMUPL(" D ^DIK
 S BJPCX=0 F  S BJPCX=$O(^APCMMUCN(BJPCX)) Q:BJPCX'=+BJPCX  S DA=BJPCX,DIK="^APCMMUCN(" D ^DIK
 Q
POST ;
 ;S X=$$ADD^XPDMENU("BDP MENU REPORTS","BDP NO DESG PROVIDER","NODP")
 ;I 'X W !,"Attempt to add BDP NO DESG PROVIDER option failed.." H 3
 S X=$$ADD^XPDMENU("APCLMENU","APCM MU MAIN MENU","MUR",3)
 I 'X W !,"Attempt to add APCM MU MAIN MENU option failed.." H 3
 D POST^APCLEM1
PALR ;fix allergy list reviewed?
 S DA=$O(^APCLVSTS("B","Allergy List Reviewed?",0))
 I DA S X=$G(^APCLVSTS(DA,2)) S $P(X,"""",2)="Allergy List " S ^APCLVSTS(DA,2)=X
 Q
INSTALLD(BJPCSTAL) ;EP - Determine if patch BJPCSTAL was installed, where
 ; APCLSTAL is the name of the INSTALL.  E.g "AG*6.0*11".
 ;
 NEW BJPCY,DIC,X,Y
 S X=$P(BJPCSTAL,"*",1)
 S DIC="^DIC(9.4,",DIC(0)="FM",D="C"
 D IX^DIC
 I Y<1 D IMES Q 0
 S DIC=DIC_+Y_",22,",X=$P(BJPCSTAL,"*",2)
 D ^DIC
 I Y<1 D IMES Q 0
 S DIC=DIC_+Y_",""PAH"",",X=$P(BJPCSTAL,"*",3)
 D ^DIC
 S BJPCY=Y
 D IMES
 Q $S(BJPCY<1:0,1:1)
IMES ;
 D MES^XPDUTL($$CJ^XLFSTR("Patch """_BJPCSTAL_""" is"_$S(Y<1:" *NOT*",1:"")_" installed.",IOM))
 Q
SORRY(X) ;
 KILL DIFQ
 I X=3 S XPDQUIT=2 Q
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("Sorry....FIX IT!",IOM)
 Q
