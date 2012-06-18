BLRPRE1 ; IHS/HQW/TPF - ENVIRONMENT CHECK FOR PATCH 13; [ 10/09/2002  6:55 AM ]
 ;;5.2;LR;**1014**;OCT 9, 2002
 S $P(LINE,"*",81)=""
 S XPDNOQUE="NO QUE"  ;NO QUEUING ALLOWED
 S XPDABORT=0
 I '$G(DUZ) W !,"DUZ UNDEFINED OR 0." D SORRY Q
 ;
 I '$L($G(DUZ(0))) W !,"DUZ(0) UNDEFINED OR NULL." D SORRY Q
 ;
 D HOME^%ZIS,DT^DICRW
 S X=$P($G(^VA(200,DUZ,0)),U)
 I $G(X)="" W !,$$C^XBFUNC("Who are you????") D SORRY Q
 W !,$$C^XBFUNC("Hello, "_$P(X,",",2)_" "_$P(X,","))
 W !!,$$C^XBFUNC("Checking Environment for Patch "_$P($T(+2),";",5)_" of Version "_$P($T(+2),";",3)_" of "_$P($T(+2),";",4)_".")
 ;
 S X=$G(^DD("VERSION"))
 W !!,$$C^XBFUNC("Need at least FileMan 21.....FileMan "_X_" Present")
 I X<21 D SORRY Q
 ;
 S X=$G(^DIC(9.4,$O(^DIC(9.4,"C","XU",0)),"VERSION"))
 W !!,$$C^XBFUNC("Need at least Kernel 8.0.....Kernel "_X_" Present")
 I X<8.0 D SORRY Q
 ;
VERSION ;
 ;CHECK FOR PREVIOUS PATCH NEEDED
 S %=$D(^XPD("9.7","B","LR*5.2*1013"))
 I '% D  Q
 . W !,$$C^XBFUNC("Patch 1014 of version 5.2 of the RPMS Laboratory Package Cannot Be Installed Unless")
 . W !,$$C^XBFUNC("Patch 1013 of version 5.2 Has not Been Previously Installed.")
 . D SORRY
 . I $$DIR^XBDIR("E","Press RETURN...")
 ;
 ;GET INSTALL STATUS
 S %=$O(^XPD("9.7","B","LR*5.2*1013",""))
 S LRSTATUS=$P($G(^XPD(9.7,%,0)),U,9)
 I LRSTATUS'=3 D  Q   ;IF INSTALL STATUS NOT COMPLETE QUIT
 .W !,$$C^XBFUNC("Install of Patch 1013 not complete!")
 .D SORRY
 .I $$DIR^XBDIR("E","Press RETURN...")
 ;
 W !!!,$$C^XBFUNC("Patch 1013 of version LR 5.2 Has Been Previously Installed......OK to continue")
 ;
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
 I $D(DIRUT)!($G(Y)=0) S XPDABORT=1 Q
 S ^TMP("BLRAPRE","BACKUPS CONFIRMED BY "_DUZ)=$H
 ;
 Q
SORRY ;
 K DIFQ
 S XPDABORT=1
 W *7,!!!,$$C^XBFUNC("Sorry....something is wrong with your enviroment")
 W !,$$C^XBFUNC("Aborting Electronic Signature Plug-in install!")
 W !,$$C^XBFUNC("Please print/capture this screen and notify")
 W !,$$C^XBFUNC("the Help Desk")
 W !!,LINE
 Q
