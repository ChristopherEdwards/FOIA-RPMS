BGU15E ; IHS/OIT/MJL - ENVIRONMENT CHECK FOR PATIENT CHART ; [ 04/14/2008  4:46 PM ]
 ;;1.5;BGU;**4**;MAY 26, 2005
 ;
 S $P(LINE,"*",81)=""
 S XPDNOQUE="NO QUE"  ;NO QUEUING ALLOWED
 S XPDABORT=0
 I '$G(DUZ) W !,"DUZ UNDEFINED OR 0." S XPX="DUZ" D SORRY Q
 ;
 I '$L($G(DUZ(0))) W !,"DUZ(0) UNDEFINED OR NULL." S XPX="DUZ" D SORRY Q
 ;
 D HOME^%ZIS,DT^DICRW
 S X=$P($G(^VA(200,DUZ,0)),U)
 I $G(X)="" W !,$$C^XBFUNC("Who are you????") S XPX="DUZ" D SORRY Q
 W !,$$C^XBFUNC("Hello, "_$P(X,",",2)_" "_$P(X,","))
 W !!,$$C^XBFUNC("Checking Environment for Beta Install of Version "_$P($T(+2),";",3)_" of "_$P($T(+2),";",4)_".")
 ;
 S X=$G(^DD("VERSION"))
 W !!,$$C^XBFUNC("Need at least FileMan 22.....FileMan "_X_" Present")
 I X<22 S XPX="FM" D SORRY Q
 ;
 S X=$G(^DIC(9.4,$O(^DIC(9.4,"C","XU",0)),"VERSION"))
 W !!,$$C^XBFUNC("Need at least Kernel 8.0.....Kernel "_X_" Present")
 I X<8.0 S XPX="KERNEL" D SORRY Q
 ;
 S XPX="IHS RPC BROKER",X=$$VERSION^XPDUTL(XPX)
 S:X="" X="Is Not"
 W !!,$$C^XBFUNC(XPX_" 1.5....."_XPX_" "_X_" Present")
 I X<1.5 D SORRY Q
 ;
VERSION ;
 ;CHECK FOR PREVIOUS PATCH NEEDED
 S XPDBLD=$O(^XTMP("XPDI",XPDA,"BLD",0)),%=$P($G(^AUTTSITE(1,0)),U,22)
 I '% D  Q
 . W !,$$C^XBFUNC($P(^XTMP("XPDI",XPDST,"BLD",XPDBLD,0),U,1)_" "_$P(^XTMP("XPDI",XPDST,"BLD",XPDBLD,0),U,2)_" Cannot Be Installed Unless")
 . W !,$$C^XBFUNC("File 200 PCC Conversion Has Been Previously Completed.")
 . S XPX="PCC200" D SORRY
 . I $$DIR^XBDIR("E","Press RETURN...")
 ;
OTHER ;
 ;Other checks
 W !!,"Checking for IHS RPC BROKER Patch..."
 I ","_$P($T(+2^BGUXUSRB),"**",2)_","'[",1," W !!,$$C^XBFUNC("IHS RPC BROKER Version 1.5, Patch 1 Is Not Installed") S XPX="IHS RPC BROKER" D SORRY Q
 I ","_$P($T(+2^BGUXUSRB),"**",2)_","'[",2," W !!,$$C^XBFUNC("IHS RPC BROKER Version 1.5, Patch 2 Is Not Installed") S XPX="IHS RPC BROKER" D SORRY Q
 I ","_$P($T(+2^BGULIST2),"**",2)_","'[",3," W !!,$$C^XBFUNC("IHS RPC BROKER Version 1.5, Patch 3 Is Not Installed") S XPX="IHS RPC BROKER" D SORRY Q
 ;
ENVOK ; If this is just an environ check, end here.
 W !!,$$C^XBFUNC("ENVIRONMENT OK.")
 ;
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 ;
 ;VERIFY BACKUPS HAVE BEEN DONE
 W !!
 S DIR(0)="Y"
 S DIR("B")="NO"
 S DIR("A")="Has a SUCCESSFUL system backup been performed??"
 D ^DIR
 I $D(DIRUT)!($G(Y)=0) S XPDABORT=1 S XPX="BACKUP" D SORRY Q
 S ^TMP("BPCPRE",$J,"BACKUPS CONFIRMED BY "_DUZ)=$H
 ;
 Q
SORRY ;
 K DIFQ
 S XPDABORT=1
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
