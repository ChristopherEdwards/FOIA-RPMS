DI1018P ; IHS/OIT/FBD - FILEMAN V22.0 PATCH 1018 ENVIRONMENT CHECKS AND POST-INIT PROCESS;   
 ;;22.0;VA FILEMAN;**1018**;JUN 03,2015;Build 3
 ;
 ;
 ; The following line prevents the "Disable Options..." and "Move Routines..." questions from being asked during the install.
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 F X="XPO1","XPZ1","XPZ2","XPI1" S XPDDIQ(X)=0
 ;KERNEL
 I +$$VERSION^XPDUTL("XU")<8 D MES^XPDUTL($$CJ^XLFSTR("Version 8.0 of KERNEL is required.  Not installed",80)) D SORRY(2) I 1
 E  D MES^XPDUTL($$CJ^XLFSTR("Requires Kernel Version 8.0....Present.",80))
 ;FILEMAN
 I +$$VERSION^XPDUTL("DI")<22 D MES^XPDUTL($$CJ^XLFSTR("Version 22.0 of FILEMAN is required.  Not installed.",80)) D SORRY(2) I 1
 E  D MES^XPDUTL($$CJ^XLFSTR("Requires Fileman v22....Present.",80))
 ;DI 22.0 PATCH 1017
 I '$$INSTALLD("DI*22.0*1017") D SORRY(2)
 ;
 Q  ;END OF ENVIRONMENT CHECK
 ;
 ;
PRE ;PATCH 1018 PRE-INIT CHECKS AND PROCESSES
 D MES^XPDUTL($$CJ^XLFSTR("Beginning DI v22.0 patch 1018 pre-init process.",80))
 ;
 D MES^XPDUTL($$CJ^XLFSTR("Setting flag to prevent KIDS env check/pre-init/post-init routine deletion...",80))
 S DIZFLG=+$O(^XTV(8989.2,"B","XPD NO_EPP_DELETE",0))  ;CHECK IF NO-DELETE PARAMETER ALREADY EXISTS IN KERNEL PARAMETERS FILE
 I 'DIZFLG D  ;IF NOT, ADD IT
 . K DO
 . S DIC="^XTV(8989.2,",DIC(0)="L",X="XPD NO_EPP_DELETE",DIADD=1
 . D FILE^DICN S DIZFLG=+Y  K DO,DIC,DIADD,X
 S DIE="^XTV(8989.2,",DA=DIZFLG,DR="4///1"  ;SET XPD NO_EPP_DELETE PARAMETER VALUE TO 1 (NO-DELETE = TRUE)
 D ^DIE 
 K DIE,DA,DR
 D MES^XPDUTL($$CJ^XLFSTR("Flag set complete.",80))
 ;
 D MES^XPDUTL($$CJ^XLFSTR("DI v22.0 patch 1018 pre-init process complete.",80))
 Q
 ;
 ;
POST ;PATCH 1018 POST-INIT PROCESSES
 D MES^XPDUTL($$CJ^XLFSTR("Beginning DI v22.0 patch 1018 post-init process.",80))
 ;
 D MES^XPDUTL($$CJ^XLFSTR("Re-initializing FileMan...",80))
 D  ;INCREMENT STACK TO COMPARTMENTALIZE FOLLOWING 'NEW' COMMANDS NECESSARY FOR NA^DINIT CALL
 .N %,%H,%X,%Y,DD,DH,DIC,DIK,DIT,DITZS,D,DA,VERSION,DU,F,I,J,P,X,Y,DIRUT,DTOUT,DUOUT  ;'NEW'-ED EQUIVALENT OF KL^DINIT6 VARIABLE KILL
 .D VERSION^DINIT N DIFROM S DIFROM=VERSION D DT^DICRW  ;FILEMAN VERSION NUMBER RETRIEVAL
 .D NA^DINIT  ;GOES DIRECTLY INTO REQUIRED ^DINIT EXECUTION WITHOUT GIVING USER ^DINIT'S NORMAL CHANCE TO OPT OUT
 D MES^XPDUTL($$CJ^XLFSTR("FileMan re-initialization complete...",80))
 ;
 D BMES^XPDUTL("Delivering DI v22.0 patch 1018 install message to select users...")
 D MAIL
 ;
 D MES^XPDUTL($$CJ^XLFSTR("DI v22.0 patch 1018 post-init process complete.",80))
 Q
 ;
 ;
MAIL ;----- SEND INSTALL MAIL MESSAGE 
 ;
 N DIFROM,XMSUB,XMDUZ,XMTEXT,XMY
 ;
 K ^TMP("DI1018MS",$J)
 S ^TMP("DI1018MS",$J,1)=" --- DI v22.0 patch 1018 has been installed into this namespace ---"
 S ^TMP("DI1018MS",$J,2)="  "
 I $G(XPDA) D
 . S %=0
 . F  S %=$O(^XTMP("XPDI",XPDA,"BLD",XPDBLD,1,%)) Q:'%   D
 . . S ^TMP("DI1018MS",$J,(%+2))=" "_^(%,0)
 ;
 S XMSUB=$P($P($T(+1),";",2)," ",3,99)
 S XMDUZ=$S($G(DUZ):DUZ,1:.5)
 S XMTEXT="^TMP(""DI1018MS"",$J,"
 S XMY(1)=""
 S XMY(DUZ)=""
 ;
 F %="XUMGR","XUPROG","XUPROGMODE" D SINGLE(%)
 D ^XMD
 ;
 K ^TMP("DI1018MS",$J)
 Q
 ;
 ;
SINGLE(K) ;----- GET HOLDERS OF A SINGLE KEY K.
 N Y
 Q:'$D(^XUSEC(K))
 S Y=0
 F  S Y=$O(^XUSEC(K,Y)) Q:'Y  S XMY(Y)=""
 Q
 ;
 ;
INSTALLD(AUTSTAL) ;EP - Determine if patch AUTSTAL was installed, where
 ; AUTSTAL is the name of the INSTALL.  E.g "AG*6.0*11".
 ;
 NEW AUTY,DIC,X,Y
 S X=$P(AUTSTAL,"*",1)
 S DIC="^DIC(9.4,",DIC(0)="FM",D="C"
 D IX^DIC
 I Y<1 D IMES Q 0
 S DIC=DIC_+Y_",22,",X=$P(AUTSTAL,"*",2)
 D ^DIC
 I Y<1 D IMES Q 0
 S DIC=DIC_+Y_",""PAH"",",X=$P(AUTSTAL,"*",3)
 D ^DIC
 S AUTY=Y
 D IMES
 Q $S(AUTY<1:0,1:1)
 ;
 ;
IMES ;
 D MES^XPDUTL($$CJ^XLFSTR("Patch """_AUTSTAL_""" is"_$S(Y<1:" *NOT*",1:"")_" installed.",IOM))
 Q
 ;
 ;
SORRY(X) ;
 KILL DIFQ
 I X=3 S XPDQUIT=2 Q
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("Sorry....FIX IT!",IOM)
 Q
