BJPC2P15 ; IHS/CMI/LAB - PCC Suite v2.0 P15 ;   
 ;;2.0;IHS PCC SUITE;**15**;MAY 14, 2009;Build 11
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
 ;BJPC 2.0 PATCH 13
 I '$$INSTALLD("BJPC*2.0*14") D MES^XPDUTL($$CJ^XLFSTR("Requires bjpc V2.0 patch 14.  Not installed.",80)) D SORRY(2)
 ;I '$$INSTALLD("ATX*5.1*13") D MES^XPDUTL($$CJ^XLFSTR("Requires atx (taxonomy) v5.1 patch 13.  Not installed.",80)) D SORRY(2)
 ;
 Q
 ;
PRE ;
 Q
POST ;
 ;K ^AUPNPROB("ALST")
 ;S DIK="^AUPNPROB(",DIK(1)=".22" D ENALL^DIK
 ;INACTIVATE READINESS TO LEARN NOT READY
 S DA=$O(^AUTTRTL("B","NOT READY",0)) I DA S DIE="^AUTTRTL(",DR=".03///1" D ^DIE K DA,DIE  ;PER SUSAN CR2744
 S DA=$O(^AUTTMSR("B","RS",0)) I DA S ^AUTTMSR(DA,11,1,0)="Enter whole number between 0 and 140."
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
