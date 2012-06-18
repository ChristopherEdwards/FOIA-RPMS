BMXE01 ; IHS/OIT/FJE - ENVIRONMENT CHECK FOR BMX 4.0 ; 03 Jun 2010  9:39 AM
 ;;4.0;BMX;;JUN 28, 2010
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
 W !!,$$C^XBFUNC("Checking Environment for Install of Version "_$P($T(+2),";",3)_" of "_$P($T(+2),";",4)_".")
 ;
 S X=$G(^DD("VERSION"))
 W !!,$$C^XBFUNC("Need at least FileMan 22.....FileMan "_X_" Present")
 I X<22 S XPX="FM" D SORRY Q
 ;
 S X=$G(^DIC(9.4,$O(^DIC(9.4,"C","XU",0)),"VERSION"))
 W !!,$$C^XBFUNC("Need at least Kernel 8.0.....Kernel "_X_" Present")
 I X<8.0 S XPX="KERNEL" D SORRY Q
 ;
DNS ; MAKE SURE THERE IS A VALID DNS IP ADDRESS (OR  A NULL VALUE) IN THE KERNEL SYSTEM PARAMETERS FILE
 N DNS,POP,%
 W !!,$$C^XBFUNC("Checking Kernel system parameters.  This may take 1 minute...")
 S DNS=$G(^XTV(8989.3,1,"DNS"))
 I DNS="" G DNS1
 I DNS="161.223.91.184" D DNSERR Q
 D CALL^%ZISTCP(DNS,53) I POP D CLOSE^%ZISTCP,DNSERR Q
DNS1 D CLOSE^%ZISTCP
 W !,$$C^XBFUNC("Kernel system parameters validated")
 ;
ENVOK ; If this is just an environ check, end here.
 W !!,$$C^XBFUNC("ENVIRONMENT OK.")
 ;
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 I $G(XPDENV)=1 D  ;Updates BMX Version file 
 .S X="2",DIC="^BMXAPPL(",DLAYGO=90093.2,DIC(0)="E" K DD,D0 D FILE^DICN
 .S DA=+Y
 .S:+DA DIE="^BMXAPPL(",DR=".02///0;.03////"_DT D ^DIE
 .K DIE,DA
 Q
 ; 
DNSERR W !,$$C^XBFUNC("The DNS IP address in the KERNEL SYSTEM PARAMETERS file is invalid!!!")
 W !,$$C^XBFUNC("You must enter a valid IP in the DNS IP field (or null) before ")
 W !,$$C^XBFUNC("installing this package")
 ; 
SORRY ;
 K DIFQ
 S XPDABORT=1
 W *7,!!!,$$C^XBFUNC("Sorry....something is wrong with your environment")
 W !,$$C^XBFUNC("Aborting BMX Version 4.0 Install!")
 W !,$$C^XBFUNC("Correct error and reinstall otherwise")
 W !,$$C^XBFUNC("please print/capture this screen and notify")
 W !,$$C^XBFUNC("the Help Desk at 888-830-7280")
 W !!,LINE
 D BMES^XPDUTL("Sorry....something is wrong with your environment")
 D BMES^XPDUTL("Enviroment ERROR "_$G(XPX))
 D BMES^XPDUTL("Aborting BMX Patch 1 install!")
 D BMES^XPDUTL("Correct error and reinstall otherwise")
 D BMES^XPDUTL("please print/capture this screen and notify")
 D BMES^XPDUTL("the Help Desk at 888-830-7280")
 Q
 ;
