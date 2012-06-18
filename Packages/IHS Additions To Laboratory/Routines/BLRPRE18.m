BLRPRE18 ; IHS/HQW/TPF - ENVIRONMENT CHECK FOR PATCH 18; [ 06/03/2003  8:35 AM ]
 ;;5.2T8;LR;**1018**;Oct 27, 2004
 ;
 S $P(LINE,"*",81)=""
 S XPDNOQUE="NO QUE"  ;NO QUEUING ALLOWED
 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0  ;DISABLE THE "Disable options..." and "Move routines..." questions from being asked during install
 S XPDDIQ("XPO1")=0  ;DISABLE "Rebuild Menu Tree" question
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
 D BMES^XPDUTL("Need at least FileMan 22.....FileMan "_X_" Present")
 I X<22 D SORRY Q
 ;
 S X=$G(^DIC(9.4,$O(^DIC(9.4,"C","XU",0)),"VERSION"))
 D BMES^XPDUTL("Need at least Kernel 8.0.....Kernel "_X_" Present")
 I X<8.0 D SORRY Q
 ;
 D BMES^XPDUTL("Must have 'LMI' mail group present....")
 I $$CHECKLMI<0 D SORRY Q
 D BMES^XPDUTL("'LMI' mail group found. OK")
 ;
 D BMES^XPDUTL("Must have Order Entry/Results Reporting....")
 I '$O(^DIC(9.4,"B","ORDER ENTRY/RESULTS REPORTING","")) D SORRY Q
 D BMES^XPDUTL("Order Entry/Results Reporting found. OK")
 ;
 S X=$G(^DIC(9.4,$O(^DIC(9.4,"C","PIMS",0)),"VERSION"))
 D BMES^XPDUTL("Need at least PIMS 5.3.....PIMS "_X_" Present")
 I X<5.3 D SORRY Q
 ;
 ;CHECK FOR NLT VERSION LEVEL
 ;S X=$O(^DIC(9.4,"B","NATIONAL LABORATORY TEST",0))
 ;I X="" D SORRY Q
 ;S X=$P($G(^DIC(9.4,X,"VERSION")),U)
 ;D BMES^XPDUTL("Need at least 'NATIONAL LABORATORY TEST' Version 5.254 ...... "_X_" Present")
 ;I X<"5.254" D SORRY Q
 ;
 ;CHECK FOR ICPT VERSION LEVEL
 ;S X=$O(^DIC(9.4,"B","CPT/HCPCS CODES",0))
 ;I X="" D SORRY Q
 ;S X=$P($G(^DIC(9.4,X,"VERSION")),U)
 ;D BMES^XPDUTL("Need at least 'ICPT' Version 6.0 ......"_X_" Present")
 ;I X<"6.0" D SORRY Q
 ;
VERSION ;
 ;CHECK FOR PREVIOUS PATCH NEEDED
 S %=$D(^XPD("9.7","B","LR*5.2*1016"))
 I '% D  Q
 . D BMES^XPDUTL("Patch 1018 of version 5.2 of the RPMS Laboratory Package")
 . D BMES^XPDUTL("Cannot Be Installed Unless")
 . D BMES^XPDUTL("Patch 1016 of version 5.2 Has Been Previously Installed.")
 . D SORRY
 ;
 ;GET INSTALL STATUS
 S %=$O(^XPD("9.7","B","LR*5.2*1016",""))
 S LRSTATUS=$P($G(^XPD(9.7,%,0)),U,9)
 I LRSTATUS'=3 D  Q   ;IF INSTALL STATUS NOT COMPLETE QUIT
 .D BMES^XPDUTL("Install of Patch 1016 not complete!")
 .D SORRY
 ;
 D BMES^XPDUTL("Patch 1016 of version LR 5.2 Has Been Previously Installed......OK to continue")
 ;
 ;
 ;
ENVOK ; If this is just an environ check, end here.
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
 S ^BLRINSTL("INSTALLED BY")=$P($G(^VA(200,DUZ,0)),U)
 ;
 Q
SORRY ;
 K DIFQ
 S XPDABORT=1
 D BMES^XPDUTL("Sorry....something is wrong with your enviroment")
 D BMES^XPDUTL("for a Lab 5.2 Patch 1018 install!")
 D BMES^XPDUTL("Please print/capture this screen and notify")
 D BMES^XPDUTL("the Help Desk")
 Q
 ;CHECK FOR LMI MAIL GROUP
CHECKLMI() ;
 S DIC="^XMB(3.8,"
 S X="LMI"
 D ^DIC
 Q +Y
 ;
 ;RESET ^LR("BLRA" FOR NEW STRUCTURE -- IF AND ONLY IF Patch 18 has not been installed before.
 ; E-SIG sites are the only ones effected by this.
POST ;
 NEW LAB18,LAB18C
 ;
 S LAB18=$O(^XPD("9.7","B","LR*5.2*1018",""))              ; Get Patch Pointer
 ; Post Install Completion Date
 I $G(LAB18) S LAB18C=$P($G(^XPD(9.7,LAB18,"INIT",1,0)),"^",2)
 I $G(LAB18C) D  Q
 . D BMES^XPDUTL("Post Install (LAB18C) -- Lab Patch 18 has been installed before.")
 . D BMES^XPDUTL("BLRTEMP global not updated.")
 ;
 I $D(^BLRTEMP("BLRA"))>0 D  Q              ; If temp global exists, quit
 . D BMES^XPDUTL("Post Install (BLRTEMP) -- Lab Patch 18 has been installed before.")
 . D BMES^XPDUTL("BLRTEMP global not updated.")
 ;
 I $D(^LR("BLRA"))=0  D  Q
 . D BMES^XPDUTL("Post Install (BLRA) -- There is no E-SIG data on this site.")
 . D BMES^XPDUTL("BLRTEMP global not created.")
 ;
 D BMES^XPDUTL("Post Install -- Lab Patch 18 has not been installed before.")
 D BMES^XPDUTL("BLRTEMP Global Being Created.")
 ;
 M ^BLRTEMP("BLRA")=^LR("BLRA")
 K ^LR("BLRA")
 S BLRAPRAC=""
 F  S BLRAPRAC=$O(^BLRTEMP("BLRA",BLRAPRAC)) Q:BLRAPRAC=""  D
 .S BLRASTAT=""
 .F  S BLRASTAT=$O(^BLRTEMP("BLRA",BLRAPRAC,BLRASTAT)) Q:BLRASTAT=""  D
 ..S BLRAIVDT=""
 ..F  S BLRAIVDT=$O(^BLRTEMP("BLRA",BLRAPRAC,BLRASTAT,BLRAIVDT)) Q:BLRAIVDT=""  D
 ...S BLRADFN=""
 ...F  S BLRADFN=$O(^BLRTEMP("BLRA",BLRAPRAC,BLRASTAT,BLRAIVDT,BLRADFN)) Q:BLRADFN=""  D
 ....S BLRASS=$G(^BLRTEMP("BLRA",BLRAPRAC,BLRASTAT,BLRAIVDT,BLRADFN))
 ....Q:BLRASS=""
 ....S ^LR("BLRA",BLRAPRAC,BLRASTAT,BLRAIVDT,BLRADFN,BLRASS)=BLRASS
 ;DO NOT KILL ^BLRTEMP IN CASE SOMETHING HAPPENED AND WE NEED IT LATER TO RESTORE DATA
 ;
 Q
