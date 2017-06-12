XWBP1018 ; IHS/OIT/FBD - XWB V1.1 PATCH 1018 ENVIRONMENT CHECKS;   
 ;;1.1;RPC BROKER;**1018**;JUN 7,2013;Build 8
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
 I $$VERSION^XPDUTL("XWB")'="1.1" D MES^XPDUTL($$CJ^XLFSTR("Version 1.1 of the RPC BROKER is required.  Not installed",80)) D SORRY(2) I 1
 E  D MES^XPDUTL($$CJ^XLFSTR("Requires RPC BROKER Version 1.1....Present.",80))
 ;AUT 98.1 PATCH 25
 I '$$INSTALLD("XWB*1.1*1017") D SORRY(2)
 ;
 Q  ;END OF ENVIRONMENT CHECK
 ;
 ;
 ;
POST ;XWB*1.1*1018 PATCH POST-INSTALL
 ;
 D MES^XPDUTL($$CJ^XLFSTR("Beginning XWB v1.1 patch 1018 post-init process.",80))
 N DIR ; error message from setting XWBM2M
 ;
 ;CHECK CORRECT SETTING FOR XWBM2M PARAMETER
 ; - IHS DEFAULT WILL BE OFF = M-TO-M BROKER DEACTIVATED
 ; - SHOULD ONLY BE TURNED ON FOR SITES USING THE DICOM GATEWAY (VISTA IMAGING SITES)
 ;
 S DIR(0)="Y"
 S DIR("A")="Does this system have services using the DICOM gateway (Y/N)"
 S DIR("?",1)="If this system runs services which use the DICOM gateway (such as "
 S DIR("?")="VistA Imaging) enter a 'Y' for Yes; otherwise, enter a 'N' for No."
 D ^DIR
 I +Y D  ;IF ANSWERED 'YES', SET APPROPRIATE PARAMETERS TO SUPPORT DICOM ACCESS
 .D P62ON ;PARAMETER XWB62 = 1 (YES/ON)
 .D M2MON ;PARAMETER XWBM2M = 1 (YES/ON)
 .D MES^XPDUTL($$CJ^XLFSTR("Per user specification, parameters set to allow M2M/DICOM access.",80))
 E  D  ; OTHERWISE SET PARAMETERS FOR NO DICOM ACCESS (DEFAULT)
 .D P62OFF ;PARAMETER XWB62 = 0 (NO/OFF)
 .D M2MOFF ;PARAMETER XWBM2M = 0 (NO/OFF)
 .D MES^XPDUTL($$CJ^XLFSTR("Per user specification, parameters set to disallow M2M/DICOM access.",80))
 ;
 D MES^XPDUTL($$CJ^XLFSTR("XWB v1.1 patch 1018 post-init process complete.",80))
 Q
 ;
 ;
P62ON ;SET VALUE OF XWB62 = 1 (YES)
 Q:'$D(^XTV(8989.51,"B","XWB62"))  ;SKIP IF PARAMETER DOESN'T EXIST ON THIS SYSTEM
 N XWBERR
 D PUT^XPAR("PKG","XWB62",1,1,.XWBERR)
 Q
 ;
P62OFF ;SET VALUE OF XWB62 = 0 (NO)
 Q:'$D(^XTV(8989.51,"B","XWB62"))  ;SKIP IF PARAMETER DOESN'T EXIST ON THIS SYSTEM
 N XWBERR
 D PUT^XPAR("PKG","XWB62",1,0,.XWBERR)
 Q
 ;
M2MON ;SET VALUE OF XWBM2M = 1 (YES)
 Q:'$D(^XTV(8989.51,"B","XWBM2M"))  ;SKIP IF PARAMETER DOESN'T EXIST ON THIS SYSTEM
 N XWBERR
 D PUT^XPAR("PKG","XWBM2M",1,1,.XWBERR)
 Q
 ;
M2MOFF ;SET VALUE OF XWBM2M = 0 (NO)
 Q:'$D(^XTV(8989.51,"B","XWBM2M"))  ;SKIP IF PARAMETER DOESN'T EXIST ON THIS SYSTEM
 N XWBERR
 D PUT^XPAR("PKG","XWBM2M",1,0,.XWBERR)
 Q
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
IMES ;
 D MES^XPDUTL($$CJ^XLFSTR("Patch """_AUTSTAL_""" is"_$S(Y<1:" *NOT*",1:"")_" installed.",IOM))
 Q
SORRY(X) ;
 KILL DIFQ
 I X=3 S XPDQUIT=2 Q
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("Sorry....FIX IT!",IOM)
 Q
