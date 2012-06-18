BWP10ENV ; IHS/CMI/LAB - BW PATCH 10 environment check ;   
 ;;2.0;WOMEN'S HEALTH;**10**;MAY 16, 1996
 ;
 ;
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 F X="XPO1","XPZ1","XPZ2","XPI1" S XPDDIQ(X)=0
 I '$$INSTALLD("BW*2.0*9") D SORRY(2)
 ;
 Q
POST ;
 S DA=$O(^BWPN("B","HYSTERECTOMY",0))
 I $$VAL^XBDIQ1(9002086.2,DA,.14)=68.5 D
 .S DIE="^BWPN(",DR=".14///"_68.9 D ^DIE K DA,DR,DIE
 .I $D(Y) D MES^XPDUTL("Unable to update Hysterectomy ICD Procedure code.",IOM)
 K DA,DIE,DR
 Q
INSTALLD(BWSTAL) ;EP - Determine if patch BWSTAL was installed, where
 ; APCLSTAL is the name of the INSTALL.  E.g "AG*6.0*11".
 ;
 NEW BWY,DIC,X,Y
 S X=$P(BWSTAL,"*",1)
 S DIC="^DIC(9.4,",DIC(0)="FM",D="C"
 D IX^DIC
 I Y<1 D IMES Q 0
 S DIC=DIC_+Y_",22,",X=$P(BWSTAL,"*",2)
 D ^DIC
 I Y<1 D IMES Q 0
 S DIC=DIC_+Y_",""PAH"",",X=$P(BWSTAL,"*",3)
 D ^DIC
 S BWY=Y
 D IMES
 Q $S(BWY<1:0,1:1)
IMES ;
 D MES^XPDUTL($$CJ^XLFSTR("Patch """_BWSTAL_""" is"_$S(Y<1:" *NOT*",1:"")_" installed.",IOM))
 Q
SORRY(X) ;
 KILL DIFQ
 I X=3 S XPDQUIT=2 Q
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("Sorry....FIX IT!",IOM)
 Q
