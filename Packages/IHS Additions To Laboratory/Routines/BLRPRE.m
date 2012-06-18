BLRPRE ; IHS/HQW/TPF - ENVIRONMENT CHECK FOR PATCH 16; [ 05/28/2003  11:54 AM ]
 ;;5.2;LR;**1016**;NOV 18, 2002
 ;
 S $P(LINE,"*",81)=""
 S XPDNOQUE="NO QUE"  ;NO QUEUING ALLOWED
 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0  ;PREVENT "DIABLE OPTIONS" AND "MOVE ROUTINES" QUESTIONS
 S XPDABORT=0
 I '$G(DUZ) W !,"DUZ UNDEFINED OR 0." D SORRY Q
 ;
 I '$L($G(DUZ(0))) W !,"DUZ(0) UNDEFINED OR NULL." D SORRY Q
 ;
 D HOME^%ZIS,DT^DICRW
 S X=$P($G(^VA(200,DUZ,0)),U)
 I $G(X) D BMES^XPDUTL("Installer cannot be identified!") D SORRY Q
 D BMES^XPDUTL("Hello, "_$P(X,",",2)_" "_$P(X,","))
 D BMES^XPDUTL("Checking Environment for Patch "_$P($T(+2),";",5)_" of Version "_$P($T(+2),";",3)_" of "_$P($T(+2),";",4)_".")
 ;
 S X=$G(^DD("VERSION"))
 D BMES^XPDUTL("Need at least FileMan 21.....FileMan "_X_" Present")
 I X<21 D SORRY Q
 ;
 S X=$G(^DIC(9.4,$O(^DIC(9.4,"C","XU",0)),"VERSION"))
 D BMES^XPDUTL("Need at least Kernel 8.0.....Kernel "_X_" Present")
 I X<8.0 D SORRY Q
 ;
 ;
VERSION ;
 ;CHECK FOR PREVIOUS PATCH NEEDED
 S %=$D(^XPD("9.7","B","LR*5.2*1015"))
 I '% D  Q
 . D BMES^XPDUTL("Patch 1016 of version 5.2 of the RPMS Laboratory Package")
 . D BMES^XPDUTL("Cannot Be Installed Unless")
 . D BMES^XPDUTL("Patch 1015 of version 5.2 Has Been Previously Installed.")
 . D SORRY
 ;
 ;GET INSTALL STATUS
 S %=$O(^XPD("9.7","B","LR*5.2*1015",""))
 S LRSTATUS=$P($G(^XPD(9.7,%,0)),U,9)
 I LRSTATUS'=3 D  Q   ;IF INSTALL STATUS NOT COMPLETE QUIT
 .D BMES^XPDUTL("Install of Patch 1015 not complete!")
 .D SORRY
 ;
 D BMES^XPDUTL("Patch 1015 of version LR 5.2 Has Been Previously Installed......OK to continue")
 ;
 ;
 ;
ENVOK ; If this is just an environment check, end here.
 D BMES^XPDUTL("ENVIRONMENT OK.")
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
 I $D(DIRUT)!($G(Y)=0) D BMES^XPDUTL("Please perform a successful backup before contnuing!!") S XPDABORT=1 Q
 S %DT="R",X="NOW" D ^%DT X ^DD("DD")
 D BMES^XPDUTL("BACKUPS CONFIRMED BY "_$P($G(^VA(200,DUZ,0)),U)_" ON "_$P(Y,"@")_" AT "_$P(Y,"@",2))
 ;
 ;
 Q
SORRY ;
 K DIFQ
 S XPDABORT=1
 D BMES^XPDUTL("Sorry....something is wrong with your enviroment")
 D BMES^XPDUTL("for a Lab 5.2 Patch 15 install!")
 D BMES^XPDUTL("Please print/capture this screen and notify")
 D BMES^XPDUTL("the Help Desk")
 Q
