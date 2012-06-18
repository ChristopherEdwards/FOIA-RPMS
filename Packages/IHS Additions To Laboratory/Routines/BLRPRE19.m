BLRPRE19 ; IHS/ITSC/MKK - ENVIRONMENT CHECK FOR PATCH 19; [ 08/20/2004  2:15 PM ]
 ;;5.2;LR;**1019**;MAR 25, 2005
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
 S X=$G(^DIC(9.4,$O(^DIC(9.4,"C","OR",0)),"VERSION"))
 D BMES^XPDUTL("Need at least ORDER ENTRY/RESULTS REPORTING (OERR) 2.5.....OERR "_X_" Present")
 I X<2.5 D SORRY Q
 ;
 S X=$G(^DIC(9.4,$O(^DIC(9.4,"C","PIMS",0)),"VERSION"))
 D BMES^XPDUTL("Need at least PIMS 5.3.....PIMS "_X_" Present")
 I X<5.3 D SORRY Q
 ;
 S X=$G(^DIC(9.4,$O(^DIC(9.4,"C","LEX",0)),"VERSION"))
 D BMES^XPDUTL("Need at least LEXICON 2.0.....LEXICON "_X_" Present")
 I X<2.0 D SORRY Q
 ;
VERSION ;
 ;CHECK FOR PREVIOUS PATCH NEEDED
 S %=$D(^XPD("9.7","B","LR*5.2*1018"))
 I '% D  Q
 . NEW STR
 . S STR="Patch 1019 of version 5.2 of the RPMS Laboratory Package"
 . S STR=STR_" CANNOT be"_$C(13)_$C(10)
 . S STR=STR_"installed unless Patch 1018 of version 5.2 has been previously"
 . S STR=STR_" installed."_$C(13)_$C(10)
 . D BMES^XPDUTL(STR)
 . D SORRY
 ;
 ;GET INSTALL STATUS
 S %=$O(^XPD("9.7","B","LR*5.2*1018",""))
 S LRSTATUS=$P($G(^XPD(9.7,%,0)),U,9)
 I LRSTATUS'=3 D  Q   ;IF INSTALL STATUS NOT COMPLETE QUIT
 .D BMES^XPDUTL("Install of Patch 1018 not complete!")
 .D SORRY
 ;
 D BMES^XPDUTL("Patch 1018 of version LR 5.2 Has Been Previously Installed......OK to continue")
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
 ;
SORRY ;
 K DIFQ
 S XPDABORT=1
 ; D BMES^XPDUTL("Sorry....something is wrong with your enviroment")
 ; D BMES^XPDUTL("for a Lab 5.2 Patch 1019 install!")
 NEW STR
 S STR="Sorry....something is wrong with your enviroment for"
 S STR=STR_" an install of"_$C(13)_$C(10)_$$CJ^XLFSTR("Lab 5.2 Patch 1019",65)
 D BMES^XPDUTL(STR)
 ; D BMES^XPDUTL("Please print/capture this screen and notify the Support Center at")
 ; D BMES^XPDUTL($$CJ^XLFSTR("1-999-999-9999",65))
 S STR="Please print/capture this screen and notify the Support Center"
 S STR=STR_" at"_$C(13)_$C(10)_$$CJ^XLFSTR("1-999-999-9999",65)_$C(13)_$C(10)
 D BMES^XPDUTL(STR)
 Q
 ;
 ;CHECK FOR LMI MAIL GROUP
CHECKLMI() ;
 S DIC="^XMB(3.8,"
 S X="LMI"
 D ^DIC
 Q +Y
 ;
POST ;
 NEW STR
 S STR=$$CJ^XLFSTR("Updating MODULE PCC LINK CONTROL failed",65)
 S STR=$C(13)_$C(10)_"Please print/capture this screen and notify the Support Center"
 S STR=STR_" at"_$C(13)_$C(10)_$$CJ^XLFSTR("1-999-999-9999",65)_$C(13)_$C(10)
 ;
 S STR=$$KILL^ZIBGCHAR("BLRENTRY")    ; Clear Tracking global
 ;
 ; The following code adds the correct PCC Merge code.  The original code
 ; for LAB in the MODULE PCC LINK CONTROL dictionary is trying to call the
 ; ALRLINK routine, which was deleted years ago.
 ; 
 S BLRX=$O(^APCDLINK("B","LABORATORY",0))  ;get ien of entry
 I 'BLRX D ADD  ;if it doesn't exist add it
 ;
 ; Check to determine if valid routine (BZHELR) already exists in dictionary.
 ; If it does exist, just quit
 I $G(^APCDLINK(BLRX,1))["BZHELR" Q
 ;
 ;if not, now edit it
 S DA=BLRX
 S DIE="^APCDLINK("
 S DR="1////S BLROSAV=$G(X),X=""BLRPCCVM"" X ^%ZOSF(""TEST"") S X=BLROSAV K BLROSAV I $T D ^BLRPCCVM"
 D ^DIE
 I $D(Y) D BMES^XPDUTL(STR)
 K DIE,DA,DR,DIC,DLAYGO,DD,DO
 Q
 ;
ADD ;
 S X="LABORATORY",DIC="^APCDLINK(",DLAYGO=9001002,DIC(0)="E" K DD,D0 D FILE^DICN
 S BLRX=+Y
 Q
