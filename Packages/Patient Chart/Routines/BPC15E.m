BPC15E ; IHS/OIT/MJL - ENVIRONMENT CHECK FOR PATIENT CHART ; [ 04/15/2008  10:18 AM ]
 ;;1.5;BPC;**5**;OCT 04, 2005
 ;
 S $P(LINE,"*",81)=""
 S XPDNOQUE="NO QUE"  ;NO QUEUING ALLOWED
 S XPDABORT=0
 I '$G(DUZ) D SORRY("DUZ UNDEFINED OR 0") Q
 ;
 I '$L($G(DUZ(0))) D SORRY("DUZ(0) UNDEFINED OR NULL") Q
 ;
 D HOME^%ZIS,DT^DICRW
 S X=$P($G(^VA(200,DUZ,0)),U)
 I $G(X)="" W !,$$C^XBFUNC("Who are you????") D SORRY("Unknown User") Q
 ;
VERSION ;
 W !,$$C^XBFUNC("Hello, "_$P(X,",",2)_" "_$P(X,","))
 W !!,$$C^XBFUNC("Checking Environment for Install of Version "_$P($T(+2),";",3)_" of "_$P($T(+2),";",4)_".")
 ;
 Q:'$$VERCHK("VA FILEMAN",22)
 Q:'$$VERCHK("KERNEL",8)
 Q:'$$VERCHK("IHS RPC BROKER",1.5)
 Q:'$$VERCHK("BPC PATIENT CHART",1.5)
 Q:'$$VERCHK("IHS MENTAL HLTH/SOC SERV",3)
 Q:'$$VERCHK("REFERRED CARE INFO SYSTEM",3)
 ;
OTHER ;
 ;Other checks
 I '$P($G(^AUTTSITE(1,0)),U,22) D SORRY("File 200 PCC Conversion Has Not Been Previously Completed") Q
 W !!,"Checking for IHS RPC BROKER Patch..."
 I ","_$P($T(+2^BGUXUSRB),"**",2)_","'[",2," D SORRY("IHS RPC BROKER Version 1.5, Patch 2 Is Not Installed") Q
 I ","_$P($T(+2^BGULIST2),"**",2)_","'[",3," D SORRY("IHS RPC BROKER Version 1.5, Patch 3 Is Not Installed") Q
 I ","_$P($T(+2^BGUTCPL),"**",2)_","'[",4," D SORRY("IHS RPC BROKER Version 1.5, Patch 4 Is Not Installed") Q
 W !!,"Checking for BPC PATIENT CHART Patches..."
 ; The following line is necessary because patch 2 didn't do this check.
 I ","_$P($T(+2^BPCBHSC),"**",2)_","'[",1," D SORRY("BPC PATIENT CHART Version 1.5, Patch 1 Is Not Installed") Q
 I ","_$P($T(+2^BPCRC3),"**",2)_","'[",2," D SORRY("BPC PATIENT CHART Version 1.5, Patch 2 Is Not Installed") Q
 I ","_$P($T(+2^BPCBHDSP),"**",2)_","'[",3," D SORRY("BPC PATIENT CHART Version 1.5, Patch 3 Is Not Installed") Q
 I ","_$P($T(+2^BPCBHDSP),"**",2)_","'[",4," D SORRY("BPC PATIENT CHART Version 1.5, Patch 4 Is Not Installed") Q
 W !!,"Checking for AMH Patch..."
 I ","_$P($T(+2^AMHPCCL1),"**",2)_","'[",9," D SORRY("Mental Health Version 3.0, Patch 9 Is Not Installed") Q
 ;
ENVOK ; If this is just an environ check, end here.
 W !!,$$C^XBFUNC("ENVIRONMENT OK.")
 ;
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 ;
 ;
 ;VERIFY BACKUPS HAVE BEEN DONE
 ;W !!
 ;S DIR(0)="Y"
 ;S DIR("B")="NO"
 ;S DIR("A")="Has a SUCCESSFUL system backup been performed??"
 ;D ^DIR
 ;I $D(DIRUT)!($G(Y)=0) S XPDABORT=1 S XPX="BACKUP" D SORRY Q
 ;S ^TMP("BPCPRE",$J,"BACKUPS CONFIRMED BY "_DUZ)=$H
 ;
 Q
 ;
VERCHK(XPXPKG,XVRMIN) ;
 S X=$$VERSION^XPDUTL(XPXPKG)
 W !!,$$C^XBFUNC("Need at least "_XPXPKG_" "_XVRMIN_"....."_XPXPKG_" "_$S(X'="":X,1:"Is Not")_" Present")
 I X<XVRMIN  D SORRY(XPXPKG_" "_XVRMIN_" Is Not Installed") Q 0
 Q 1
 ;
SORRY(XPX) ;
 K DIFQ
 S XPDABORT=1,XPDBLD=$O(^XTMP("XPDI",XPDA,"BLD",0))
 W !,$$C^XBFUNC($P(^XTMP("XPDI",XPDST,"BLD",XPDBLD,0),U,1)_" "_$P(^XTMP("XPDI",XPDST,"BLD",XPDBLD,0),U,2)_" Cannot Be Installed!")
 W !,$$C^XBFUNC("Reason: "_XPX_".")
 W *7,!!!,$$C^XBFUNC("Sorry....something is wrong with your environment")
 W !,$$C^XBFUNC("Aborting "_XPDNM_" install!")
 W !,$$C^XBFUNC("Correct error and reinstall otherwise")
 W !,$$C^XBFUNC("please print/capture this screen and notify")
 W !,$$C^XBFUNC("the Help Desk")
 W !!,LINE
 D BMES^XPDUTL("Sorry....something is wrong with your environment")
 D BMES^XPDUTL("Enviroment ERROR "_$G(XPX))
 D BMES^XPDUTL("Aborting "_XPDNM_" install!")
 D BMES^XPDUTL("Correct error and reinstall otherwise")
 D BMES^XPDUTL("please print/capture this screen and notify")
 D BMES^XPDUTL("the Help Desk")
 Q
 ;
