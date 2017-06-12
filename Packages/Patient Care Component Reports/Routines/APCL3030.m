APCL3030 ; IHS/CMI/LAB - environment check ; 13 Aug 2014  11:54 AM
 ;;3.0;IHS PCC REPORTS;**30**;FEB 05, 1997;Build 27
 ;
 ;
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 F X="XPO1","XPZ1","XPZ2","XPI1" S XPDDIQ(X)=0
 I $$VERSION^XPDUTL("BJPC")'="2.0" W !,"version 2.0 of BJPC is required" D SORRY(2)
 I $$VERSION^XPDUTL("BGP")'>"14" W !,"version 14.1 or higher of BGP is required" D SORRY(2)
 I '$$INSTALLD("APCL*3.0*29") D SORRY(2)
 ;
 Q
 ;
PRE ;
 S DA=$O(^DIC(19,"B","APCLSILI MU2 EXPORT",0))
 I DA S DIE="^DIC(19,",DR="1///Syndromic Surveillance Visit Export" D ^DIE K DA,DIE,DR
 Q
POST ;
 ;wipe out stop date
 S DA=$O(^APCLCNTL("B","ILI STOP DATE",0))
 I DA S DIE="^APCLCNTL(",DR=".03///@;.06///1" D ^DIE K DIE,DA,DR
 ;S X=$$ADD^XPDMENU("APCL M MAN QUALITY ASSURANCE","APCL MENU SURVEILLANCE ILI","SURV")
 ;I 'X W !,"Attempt to add ILI ON DEMAND option failed.." H 3
 D ^APCLS9
 S $P(^APCLILIC(1,0),U,4)=""  ;set full export
 ;clear out log because FLF will run after patch install
 S APCLX=0 F  S APCLX=$O(^APCLILIL(APCLX)) Q:APCLX'=+APCLX  S DA=APCLX,DIK="^APCLILIL(" D ^DIK
 ;set date 2 days from now for full user pop export to run.  if 2 days from now is the 1st, don't bother.
 ;S APCLX=$$FMADD^XLFDT(DT,2)
 ;I $E(APCLX,6,7)="01" Q  ;DON'T BOTHER, IT WILL RUN ANYWAY IN 2 DAYS
 ;I $D(^APCLILIC("B",1,1)) Q  ;already did this export
 ;S ^APCLILIC(1,0)=1_U_1_U_DT
 ;S ^APCLILIC("B",1,1)=""
 ;
 ;
 S X=$G(XPDQUES("POS Q1"))
 S DA=1,DIE="^APCLILIC(",DR=".05///"_X D ^DIE
 ;D RMMENU
 Q
 ;
MUSS ;
 ;SET UP LOG FOR AUTTSITE(1,0) ENTRY
 
 Q
RMMENU ;-- remove options from APCLMENU
 N I,X
 F I="APCL SURVEILLANCE AGG REPORT","APCL SURVEILLANCE ILI TEMPLATE","APCLSILI ILI EXPORT LIST" D
 . S X=$$DELETE^XPDMENU("APCL M MAN QUALITY ASSURANCE",I)
 . I 'X W !,"Attempt to remove "_I_" from the APCL M MAN QUALITY ASSURANCE menu failed..." H 3
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
