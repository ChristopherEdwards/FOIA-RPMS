AUT98P27 ; IHS/OIT/FBD - AUT V98.1 PATCH 27 ENVIRONMENT CHECKS AND POST-INIT PROCESS;   
 ;;98.1;IHS DICTIONARIES (POINTERS);**27**;DEC 5,2014;Build 2
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
 ;AUT
 I $$VERSION^XPDUTL("AUT")'="98.1" D MES^XPDUTL($$CJ^XLFSTR("Version 98.1 of the IHS DICTIONARIES (POINTERS) is required.  Not installed",80)) D SORRY(2) I 1
 E  D MES^XPDUTL($$CJ^XLFSTR("Requires IHS DICTIONARIES (POINTERS) Version 98.1....Present.",80))
 ;AUT 98.1 PATCH 26
 I '$$INSTALLD("AUT*98.1*26") D SORRY(2)
 ;
 Q  ;END OF ENVIRONMENT CHECK
 ;
 ;
PRE ;PATCH 27 PRE-INIT CHECKS AND PROCESSES
 D MES^XPDUTL($$CJ^XLFSTR("Beginning AUT v98.1 patch 27 pre-init process.",80))
 ;
 ;
 D MES^XPDUTL($$CJ^XLFSTR("AUT v98.1 patch 27 pre-init process complete.",80))
 Q
 ;
 ;
POST ;PATCH 27 POST-INIT PROCESSES
 D MES^XPDUTL($$CJ^XLFSTR("Beginning AUT v98.1 patch 27 post-init process.",80))
 ;
 D BMES^XPDUTL("Delivering AUT*98.1*27 install message to select users...")
 D MAIL
 ;
 D MES^XPDUTL($$CJ^XLFSTR("AUT v98.1 patch 27 post-init process complete.",80))
 Q
 ;
 ;
MAIL ;----- SEND INSTALL MAIL MESSAGE 
 ;
 N DIFROM,XMSUB,XMDUZ,XMTEXT,XMY
 ;
 K ^TMP("AUTP27MS",$J)
 S ^TMP("AUTP27MS",$J,1)=" --- AUT v 98.1 Patch 27 has been installed into this namespace ---"
 S ^TMP("AUTP27MS",$J,2)="  "
 I $G(XPDA) D
 . S %=0
 . F  S %=$O(^XTMP("XPDI",XPDA,"BLD",XPDBLD,1,%)) Q:'%   D
 . . S ^TMP("AUTP27MS",$J,(%+2))=" "_^(%,0)
 ;
 S XMSUB=$P($P($T(+1),";",2)," ",3,99)
 S XMDUZ=$S($G(DUZ):DUZ,1:.5)
 S XMTEXT="^TMP(""AUTP27MS"",$J,"
 S XMY(1)=""
 S XMY(DUZ)=""
 ;
 F %="XUMGR","XUPROG","XUPROGMODE" D SINGLE(%)
 D ^XMD
 ;
 K ^TMP("AUTP27MS",$J)
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
