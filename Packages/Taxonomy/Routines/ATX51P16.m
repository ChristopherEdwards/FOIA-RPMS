ATX51P16 ; IHS/CMI/LAB - PCC Suite v5.1 patch 16 environment check ; 02 Nov 2015  2:41 PM
 ;;5.1;TAXONOMY;**16**;FEB 04, 1997;Build 26
 ;
 ;
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 F X="XPO1","XPZ1","XPZ2","XPI1" S XPDDIQ(X)=0
 I '$$INSTALLD("ATX*5.1*15") D SORRY(2)
 I +$$VERSION^XPDUTL("AICD")<4 D MES^XPDUTL($$CJ^XLFSTR("Version 4.0 of AICD is required.  Not installed",80)) D SORRY(2) I 1
 E  D MES^XPDUTL($$CJ^XLFSTR("Requires AICD V4.0....Present.",80))
 ;
 Q
 ;
PRE ;
 Q
POST ;
 S ATXDA=0
 F  S ATXDA=$O(^ATXAX(ATXDA)) Q:ATXDA'=+ATXDA  D
 .Q:'$D(^ATXAX(ATXDA,0))
 .Q:$P(^ATXAX(ATXDA,0),U,13)]""  ;already has value
 .S F=$P(^ATXAX(ATXDA,0),U,15)
 .I F'=80,F'=81,F'=80.1,F'=95.3,F'=50.67 Q
 .;W !,ATXDA," ",F," ",$P(^ATXAX(ATXDA,0),U,1)
 .S DA=ATXDA,DIE="^ATXAX(",DR=".13///1" D ^DIE K DIE,DA,DR
 D ^ATXF5
 D SETTAXRN^ATX6ENV
 Q
INSTALLD(ATXSTAL) ;EP - Determine if patch ATXSTAL was installed, where
 ; ATXSTAL is the name of the INSTALL.  E.g "AG*6.0*11".
 ;
 NEW ATXY,DIC,X,Y
 S X=$P(ATXSTAL,"*",1)
 S DIC="^DIC(9.4,",DIC(0)="FM",D="C"
 D IX^DIC
 I Y<1 D IMES Q 0
 S DIC=DIC_+Y_",22,",X=$P(ATXSTAL,"*",2)
 D ^DIC
 I Y<1 D IMES Q 0
 S DIC=DIC_+Y_",""PAH"",",X=$P(ATXSTAL,"*",3)
 D ^DIC
 S ATXY=Y
 D IMES
 Q $S(ATXY<1:0,1:1)
IMES ;
 D MES^XPDUTL($$CJ^XLFSTR("Patch """_ATXSTAL_""" is"_$S(Y<1:" *NOT*",1:"")_" installed.",IOM))
 Q
SORRY(X) ;
 KILL DIFQ
 I X=3 S XPDQUIT=2 Q
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("Sorry....FIX IT!",IOM)
 Q
