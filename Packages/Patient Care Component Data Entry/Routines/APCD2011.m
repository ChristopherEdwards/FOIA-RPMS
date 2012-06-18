APCD2011 ; IHS/CMI/TUCSON - DATA ENTRY PATCH 10 [ 03/11/05  9:09 AM ]
 ;;2.0;IHS RPMS/PCC Data Entry;**11**;MAR 09, 1999
 ;
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 F X="XPO1","XPZ1","XPZ2","XPI1" S XPDDIQ(X)=0
 I $$VERSION^XPDUTL("BJPC")'="2.0" W !,"version 2.0 of BJPC is required" D SORRY(2)
 ;
 Q
INSTALLD(APCDSTAL) ;EP - Determine if patch APCDSTAL was installed, where
 ; APCDSTAL is the name of the INSTALL.  E.g "AG*6.0*11".
 ;
 NEW APCDY,DIC,X,Y
 S X=$P(APCDSTAL,"*",1)
 S DIC="^DIC(9.4,",DIC(0)="FM",D="C"
 D IX^DIC
 I Y<1 D IMES Q 0
 S DIC=DIC_+Y_",22,",X=$P(APCDSTAL,"*",2)
 D ^DIC
 I Y<1 D IMES Q 0
 S DIC=DIC_+Y_",""PAH"",",X=$P(APCDSTAL,"*",3)
 D ^DIC
 S APCDY=Y
 D IMES
 Q $S(APCDY<1:0,1:1)
IMES ;
 D MES^XPDUTL($$CJ^XLFSTR("Patch """_APCDSTAL_""" is"_$S(Y<1:" *NOT*",1:"")_" installed.",IOM))
 Q
SORRY(X) ;
 KILL DIFQ
 I X=3 S XPDQUIT=2 Q
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("Sorry....FIX IT!",IOM)
 Q
