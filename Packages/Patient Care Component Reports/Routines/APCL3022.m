APCL3022 ; IHS/CMI/LAB -  environment check ;    [ 08/22/2009  7:33 AM ]
 ;;3.0;IHS PCC REPORTS;**22,23**;FEB 05, 1997
 ;
 ;
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 F X="XPO1","XPZ1","XPZ2","XPI1" S XPDDIQ(X)=0
 I $$VERSION^XPDUTL("BJPC")'="2.0" W !,"version 2.0 of BJPC is required" D SORRY(2)
 ;
 Q
 ;
PRE ;
 Q
POST ;
OPTIONS ;
 S X=$$ADD^XPDMENU("APCL M OTHER REPORTS","APCL EDIT SURV ILI STOP DATE","USSD")
 I 'X W "Attempt to add APCL EDIT SURV ILI STOP DATE option failed.." H 3
 S DA=$O(^APCLCNTL("B","ILI STOP DATE",0))
 I 'DA W !!,"ILI CONTROL FILE ENTRY MISSING.  NOTIFY PROGRAMMER." K DA Q
 Q:$P(^APCLCNTL(DA,0),U,3)]""
 S DIE="^APCLCNTL(",DR=".03////3090901"
 D ^DIE
 K DIE,DA
 Q
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
