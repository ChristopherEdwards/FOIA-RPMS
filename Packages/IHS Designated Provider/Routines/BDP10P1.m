BDP10P1 ; IHS/CMI/LAB - PRE/POST INIT ;
 ;;1.0;DESIGNATED PROVIDER MGT SYSTEM;**1**;SEP 10, 2004
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 F X="XPO1","XPZ1","XPZ2","XPI1" S XPDDIQ(X)=0
 ;
 Q
PRE ;pre init for patch 1
 ;change WOMENS HEALTH to WOMEN'S HEALTH CASE MANAGER
 ;wipe out fields that populate WH dd
 S DA=$O(^BDPTCAT("B","WOMENS HEALTH",0))
 I DA S DIE="^BDPTCAT(",DR=".01///WOMEN'S HEALTH CASE MANAGER",DITC=1 D ^DIE K DIE,DA,DR,DITC
 S DA=$O(^BDPTCAT("B","CANCER",0))
 I DA S DIE="^BDPTCAT(",DR=".02///CA" D ^DIE K DIE,DA,DR
 Q
INSTALLD(BDPSTAL) ;EP - Determine if patch BDPSTAL was installed, where
 ; BDPSTAL is the name of the INSTALL.  E.g "AG*6.0*11".
 ;
 NEW BDPY,DIC,X,Y
 S X=$P(BDPSTAL,"*",1)
 S DIC="^DIC(9.4,",DIC(0)="FM",D="C"
 D IX^DIC
 I Y<1 D IMES Q 0
 S DIC=DIC_+Y_",22,",X=$P(BDPSTAL,"*",2)
 D ^DIC
 I Y<1 D IMES Q 0
 S DIC=DIC_+Y_",""PAH"",",X=$P(BDPSTAL,"*",3)
 D ^DIC
 S BDPY=Y
 D IMES
 Q $S(BDPY<1:0,1:1)
IMES ;
 D MES^XPDUTL($$CJ^XLFSTR("Patch """_BDPSTAL_""" is"_$S(Y<1:" *NOT*",1:"")_" installed.",IOM))
 Q
SORRY(X) ;
 KILL DIFQ
 I X=3 S XPDQUIT=2 Q
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("Sorry....FIX IT!",IOM)
 Q
