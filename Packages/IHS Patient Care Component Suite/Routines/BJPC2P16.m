BJPC2P16 ; IHS/CMI/LAB - PCC Suite v2.0 P15 ;   
 ;;2.0;IHS PCC SUITE;**16**;MAY 14, 2009;Build 9
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
 I '$$INSTALLD("BJPC*2.0*15") D MES^XPDUTL($$CJ^XLFSTR("Requires bjpc V2.0 patch 15.  Not installed.",80)) D SORRY(2)
 ;I '$$INSTALLD("ATX*5.1*13") D MES^XPDUTL($$CJ^XLFSTR("Requires atx (taxonomy) v5.1 patch 13.  Not installed.",80)) D SORRY(2)
 ;
 Q
 ;
PRE ;
 K ^APCHTMP("HMR STATUS")
 S X=0 F  S X=$O(^APCHSURV(X)) Q:X'=+X  S ^APCHTMP("HMR STATUS",X)=$P(^APCHSURV(X,0),U)_U_$P(^APCHSURV(X,0),U,3)
 Q
POST ;
 ;CR# 05990
 S DA=$O(^AUTTMSR("B","AG",0)) I DA S ^AUTTMSR(DA,11,1,0)="Enter Abdominal Girth.  Must be in the range 0-250. Up to 2 decimal ",^AUTTMSR(DA,11,2,0)="digits. e.g. 38.5 or 40 or 39.25"
 K ^AUPNPROB("ASLT")
 K ^AUPNPROB("ALST")
 ;K ^DD(9000011,0,"IX","ALST",9000011,80001)
 ;K ^DD(9000011,0,"IX","ALSTA",9000011,.22)
 S DIK="^AUPNPROB(",DIK(1)=".22" D ENALL^DIK
 ;HMR STATUS
 S APCHX=0 F  S APCHX=$O(^APCHTMP("HMR STATUS",APCHX)) Q:APCHX'=+APCHX  D
 .S X=$P(^APCHTMP("HMR STATUS",APCHX),U),APCHS=$P(^APCHTMP("HMR STATUS",APCHX),U,2)  ;,DIC="^APCHSURV(",DIC(0)="M" D ^DIC
 .;I Y=-1 W !!,"could not update status on ",X," hmr" Q
 .Q:'$D(^APCHSURV(APCHX,0))
 .I $P(^APCHSURV(APCHX,0),U,3)'="D" S $P(^APCHSURV(APCHX,0),U,3)=APCHS
 K ^APCHTMP("HMR STATUS")
 K APCHX,APCHS
 S X=$$ADD^XPDMENU("APCDSUPER","APCD UPDATE DEFAULT STATUS","PLST")
 I 'X W !,"Attempt to add APCD UPDATE DEFAULT STATUS option failed.." H 3
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
