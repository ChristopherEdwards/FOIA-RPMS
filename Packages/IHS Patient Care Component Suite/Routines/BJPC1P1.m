BJPC1P1 ; IHS/CMI/LAB - PCC Suite v1.0 patch 1 environment check ;    
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 F X="XPO1","XPZ1","XPZ2","XPI1" S XPDDIQ(X)=0
 I '$$INSTALLD("BJPC*1.0*1") D SORRY(2)
 ;
 Q
 ;
PRE ;
 Q
POST ;
 ;install icd9 taxonomy
 D ^BJPC1T
 ;create surveillance ili clinics
 D CLTAX
 D ZISH
 S X=$$ADD^XPDMENU("APCL M MAN QUALITY ASSURANCE","APCL SURVEILLANCE ILI TEMPLATE","ILI")
 I 'X W "Attempt to add SURVEILLANCE ILI report option failed.." H 3
 Q
 ;
ZISH ;create entry in ZISH SEND PARAMETERS file
 D ^XBFMK K DIADD,DLAYGO,DIC,DD,D0,DO
 S BDWY=0 F  S BDWY=$O(^%ZIB(9888888.93,"B","SURVEILLANCE ILI SEND",0)) Q:BDWY'=+BDWY  D
 .I BDWY S DA=BDWY,DIK="^%ZIB(9888888.93," D ^DIK K DA,DIK
 S X="SURVEILLANCE ILI SEND",DIC(0)="L",DIC="^%ZIB(9888888.93," D FILE^DICN
 I Y=-1 W !!,"error creating ZISH SEND PARAMETERS entry" Q
 S DA=+Y,DIE="^%ZIB(9888888.93,",DR=".02///QUOVADX-IE.DOMAIN.NAME;.03///fludata;.04///etgx7h;.06///-u;.07///B;.08///sendto"
 D ^DIE
 I $D(Y) W !!,"error updating ZISH SEND PARAMETERS entry" Q
 Q
 ;
CLTAX ;
 S ATXFLG=1
 W !,"Creating Surveillance ILI Clinics taxonomy..."
 S BJPCDA=0 S BJPCDA=$O(^ATXAX("B","SURVEILLANCE ILI CLINICS",BJPCDA)) I BJPCDA S DA=BJPCDA S DIK="^ATXAX(" D ^DIK K DA,DIK
 S X="SURVEILLANCE ILI CLINICS",DIC="^ATXAX(",DIC(0)="L",DIADD=1,DLAYGO=9002226 D ^DIC K DIC,DA,DIADD,DLAYGO,I
 I Y=-1 W !!,"ERROR IN CREATING SURVEILLANCE ILI CLINICS TAX" Q
 S BJPCTX=+Y,$P(^ATXAX(BJPCTX,0),U,2)="SURVEILLANCE ILI CLINICS",$P(^(0),U,5)=DUZ,$P(^(0),U,8)=0,$P(^(0),U,9)=DT,$P(^(0),U,12)=172,$P(^(0),U,13)=0,$P(^(0),U,15)=40.7,^ATXAX(BJPCTX,21,0)="^9002226.02101A^0^0"
 D ^XBFMK K DIADD,DLAYGO S BJPCTEXT="CLINICS" F BJPCX=1:1 S X=$P($T(@BJPCTEXT+BJPCX),";;",2) Q:X=""  S Y=$O(^DIC(40.7,"C",X,0)) I Y D
 .S ^ATXAX(BJPCTX,21,BJPCX,0)=+Y,$P(^ATXAX(BJPCTX,21,0),U,3)=BJPCX,$P(^(0),U,4)=BJPCX,^ATXAX(BJPCTX,21,"AA",+Y,+Y)=""
 .Q
 S DA=BJPCTX,DIK="^ATXAX(" D IX1^DIK
 Q
 ;
INSTALLD(BJPCSTAL) ;EP - Determine if patch BJPCSTAL was installed, where
 ; BJPCSTAL is the name of the INSTALL.  E.g "AG*6.0*11".
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
 ;
CLINICS ;
 ;;30
 ;;10
 ;;12
 ;;13
 ;;20
 ;;24
 ;;28
 ;;57
 ;;70
 ;;80
 ;;89
 ;;01
 ;;06
 ;;
