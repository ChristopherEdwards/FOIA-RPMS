APCH2P17 ; IHS/TUCSON/LAB - PCC HEALTH SUMMARY POST INIT PATCH 12 ;  [ 09/07/04  10:26 AM ]
 ;;2.0;IHS RPMS/PCC Health Summary;**17**;JUN 24, 1997
 ;
 ;
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 F X="XPO1","XPZ1","XPZ2","XPI1" S XPDDIQ(X)=0
 I '$$INSTALLD("APCH*2.0*16") D SORRY(2)
 I '$$INSTALLD("AICD*3.51*7") D SORRY(2)
 I '$D(^DIC(9.4,"C","LEX")) D MES^XPDUTL($$CJ^XLFSTR("Lexicon is *NOT* installed.",IOM)) D SORRY(2)
 ;
 Q
INSTALLD(APCHSTAL) ;EP - Determine if patch APCHSTAL was installed, where
 ; APCHSTAL is the name of the INSTALL.  E.g "AG*6.0*11".
 ;
 NEW APCHY,DIC,X,Y
 S X=$P(APCHSTAL,"*",1)
 S DIC="^DIC(9.4,",DIC(0)="FM",D="C"
 D IX^DIC
 I Y<1 D IMES Q 0
 S DIC=DIC_+Y_",22,",X=$P(APCHSTAL,"*",2)
 D ^DIC
 I Y<1 D IMES Q 0
 S DIC=DIC_+Y_",""PAH"",",X=$P(APCHSTAL,"*",3)
 D ^DIC
 S APCHY=Y
 D IMES
 Q $S(APCHY<1:0,1:1)
IMES ;
 D MES^XPDUTL($$CJ^XLFSTR("Patch """_APCHSTAL_""" is"_$S(Y<1:" *NOT*",1:"")_" installed.",IOM))
 Q
SORRY(X) ;
 KILL DIFQ
 I X=3 S XPDQUIT=2 Q
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("Sorry....FIX IT!",IOM)
 Q
PRE ;EP
 ;SAVE OFF STATUS FOR EACH REMINDER
 Q
POST ;EP
 NEW DA,DIE,DR
 S DA=$O(^APCHSURV("B","ANMC COLORECTAL",0))
 S DIE="^APCHSURV(",DR=".03////D" D ^DIE K DIE,DA,DR
 S DA=$O(^APCHSURV("B","ANMC COLORECTAL CANCER",0))
 S DIE="^APCHSURV(",DR=".03////D" D ^DIE K DIE,DA,DR
 D ^APCHTXS
 Q
