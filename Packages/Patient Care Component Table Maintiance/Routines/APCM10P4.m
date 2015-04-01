APCM10P4 ;IHS/CMI/LAB - MU V1.0 PATCH 4 ENV;
 ;;1.0;IHS MU PERFORMANCE REPORTS;**4,5**;MAR 26, 2012;Build 5
 ;
 ;
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 F X="XPO1","XPZ1","XPZ2","XPI1" S XPDDIQ(X)=0
 I '$$INSTALLD("BJPC*2.0*8") D SORRY(2)
 I '$$INSTALLD("BJPC*2.0*9") D SORRY(2)
 I '$$INSTALLD("APCM*1.0*2") D SORRY(2)
 I '$$INSTALLD("APCM*1.0*3") D SORRY(2)
 ;
 Q
 ;
PRE ;
 Q
POST ;
 Q
INSTALLD(APCMSTAL) ;EP - Determine if patch APCMSTAL was installed, where
 ; APCLSTAL is the name of the INSTALL.  E.g "AG*6.0*11".
 ;
 NEW APCMY,DIC,X,Y
 S X=$P(APCMSTAL,"*",1)
 S DIC="^DIC(9.4,",DIC(0)="FM",D="C"
 D IX^DIC
 I Y<1 D IMES Q 0
 S DIC=DIC_+Y_",22,",X=$P(APCMSTAL,"*",2)
 D ^DIC
 I Y<1 D IMES Q 0
 S DIC=DIC_+Y_",""PAH"",",X=$P(APCMSTAL,"*",3)
 D ^DIC
 S APCMY=Y
 D IMES
 Q $S(APCMY<1:0,1:1)
IMES ;
 D MES^XPDUTL($$CJ^XLFSTR("Patch """_APCMSTAL_""" is"_$S(Y<1:" *NOT*",1:"")_" installed.",IOM))
 Q
SORRY(X) ;
 KILL DIFQ
 I X=3 S XPDQUIT=2 Q
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("Sorry....FIX IT!",IOM)
 Q
