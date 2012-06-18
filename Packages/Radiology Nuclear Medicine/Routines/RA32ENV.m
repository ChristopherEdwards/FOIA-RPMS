RA32ENV ;HIRMFO/SWM-Environment Check routine ;11/27/01  10:03
VERSION ;;5.0;Radiology/Nuclear Medicine;**32**;Mar 16, 1998
 ; check if patch 28 was installed
 N RAOUT,RAVAL,RAERR
 S RAVAL="RA*5.0*28"
 D FIND^DIC(9.7,"",".01;.02;17","",.RAVAL,"","","","","RAOUT","RAERR")
 I '$O(RAOUT("DILIST",2,0)) G ABEND1
 ;I RAOUT("DILIST","ID",$O(RAOUT("DILIST",2,""),-1),.02)'="Install Completed" G ABEND2;IHS/ITS/CLS 08/02/2003
 Q
ABEND1 ;
 D EN^DDIOL("**Patch "_RAVAL_" is not in the INSTALL file**",,"!!?5")
 G SETABND
ABEND2 ;
 D EN^DDIOL("**Patch "_RAVAL_"'s STATUS isn't 'Install Completed'**",,"!!?5")
SETABND S XPDABORT=2
 Q
