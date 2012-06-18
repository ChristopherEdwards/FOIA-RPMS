APCL3027 ; IHS/CMI/LAB - environment check ;
 ;;3.0;IHS PCC REPORTS;**27**;FEB 05, 1997
 ;
 ;
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 F X="XPO1","XPZ1","XPZ2","XPI1" S XPDDIQ(X)=0
 I $$VERSION^XPDUTL("BJPC")'="2.0" W !,"version 2.0 of BJPC is required" D SORRY(2)
 ;I $$VERSION^XPDUTL("BGP")'="10.0" W !,"version 10.0 of BGP is required" D SORRY(2)
 ;I '$$INSTALLD("BJPC*2.0*2") D SORRY(2)
 ;
 Q
 ;
PRE ;
 Q
POST ;
 ;wipe out stop date
 S DA=$O(^APCLCNTL("B","ILI STOP DATE",0))
 I DA S DIE="^APCLCNTL(",DR=".03///@" D ^DIE K DIE,DA,DR
 D ^APCL27
 ;set date 2 days from now for full user pop export to run.  if 2 days from now is the 1st, don't bother.
 ;S APCLX=$$FMADD^XLFDT(DT,2)
 ;I $E(APCLX,6,7)="01" Q  ;DON'T BOTHER, IT WILL RUN ANYWAY IN 2 DAYS
 ;I $D(^APCLILIC("B",1,1)) Q  ;already did this export
 ;S ^APCLILIC(1,0)=1_U_1_U_DT
 ;S ^APCLILIC("B",1,1)=""
 ;
 ;
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
