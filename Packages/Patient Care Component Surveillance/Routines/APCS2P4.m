APCS2P4 ; IHS/CMI/LAB - environment check ;
 ;;2.0;IHS PCC SUITE;**5**;MAY 14, 2009
 ;
 ;
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 F X="XPO1","XPZ1","XPZ2","XPI1" S XPDDIQ(X)=0
 I $$VERSION^XPDUTL("BJPC")'="2.0" W !,"version 2.0 of BJPC is required" D SORRY(2)
 I '$$INSTALLD("BJPC*2.0*3") D SORRY(2)
 ;
 Q
 ;
PRE ;
 Q
POST ;
LAB ;EP
 S APCSX="SURVEILLANCE RAPID FLU TESTS" D LAB1
 D HLO
 Q
LAB1 ;
 S APCSDA=$O(^ATXLAB("B",APCSX,0))
 Q:APCSDA  ;taxonomy already exisits
 W !,"Creating ",APCSX," Taxonomy..."
 S X=APCSX,DIC="^ATXLAB(",DIC(0)="L",DIADD=1,DLAYGO=9002228 D ^DIC K DIC,DA,DIADD,DLAYGO,I
 I Y=-1 W !!,"ERROR IN CREATING ",APCSX," TAX" Q
 S APCSTX=+Y,$P(^ATXLAB(APCSTX,0),U,2)=APCSX,$P(^(0),U,5)=DUZ,$P(^(0),U,6)=DT,$P(^(0),U,8)="B",$P(^(0),U,9)=60
 S ^ATXLAB(APCSTX,21,0)="^9002228.02101PA^0^0"
 S DA=APCSTX,DIK="^ATXAX(" D IX1^DIK
 Q
 ;
HLO ;--register the app in HLO
 N FDA,FIENS,FERR,PCCI
 Q:$O(^HLD(779.2,"B","RPMS-ILI",0))
 S PCCI=$O(^DIC(9.4,"B","IHS PCC SUITE",0))
 Q:'PCCI
 S FIENS=""
 S FDA(779.2,"+1,",.01)="RPMS-ILI"
 S FDA(779.2,"+1,",2)=PCCI
 D UPDATE^DIE("","FDA","FIENS","FERR(1)")
 Q
 ;
OPTIONS ;
 ;
INSTALLD(APCLSTAL) ;EP - Determine if patch APCLSTAL was installed, where
 ; APCLSTAL is the name of the INSTALL.  E.g "AG*6.0*11".
 ;
 NEW APCLY,DIC,X,Y
 S X=$P(APCLSTAL,"*",1)
 S DIC="^DIC(9.4,",DIC(0)="FM",D="C"
 D IX^DIC
 I Y<1 D IMES Q 0
 S DIC=DIC_+Y_",22,",X=$P(APCLSTAL,"*",2)
 D ^DIC
 I Y<1 D IMES Q 0
 S DIC=DIC_+Y_",""PAH"",",X=$P(APCLSTAL,"*",3)
 D ^DIC
 S APCLY=Y
 D IMES
 Q $S(APCLY<1:0,1:1)
IMES ;
 D MES^XPDUTL($$CJ^XLFSTR("Patch """_APCLSTAL_""" is"_$S(Y<1:" *NOT*",1:"")_" installed.",IOM))
 Q
SORRY(X) ;
 KILL DIFQ
 I X=3 S XPDQUIT=2 Q
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("Sorry....FIX IT!",IOM)
 Q
