ICD002E ;IHS/OIT/FCJ - ICD*18.0*1002 Env Check FOR IHS patch 1002 ;07/01/2011
 ;;18.0;DRG Grouper;**1002**;Oct 20, 2000;Build 7
 ;               
 ;
ENV ;               
 I '$G(IOM) D HOME^%ZIS
 I '$G(DUZ) W !,"DUZ UNDEFINED OR 0." D SORRY(2) Q
 I '$L($G(DUZ(0))) W !,"DUZ(0) UNDEFINED OR NULL." D SORRY(2) Q
 I '(DUZ(0)["@") W:'$D(ZTQUEUED) !,"DUZ(0) DOES NOT CONTAIN AN '@'." D SORRY(2) Q
 ;
 S X=$$GET1^DIQ(200,DUZ,.01)
 W !!,$$CJ^XLFSTR("Hello, "_$P(X,",",2)_" "_$P(X,","),IOM)
 W !!,$$CJ^XLFSTR("Checking Environment for "_$P($T(+2),";",4)_" V "_$P($T(+2),";",3)_" Patch "_$P($T(+2),";",5)_".",IOM)
 ;
 NEW IORVON,IORVOFF
 S X="IORVON;IORVOFF"
 D ENDR^%ZISS
CHK ;
 I '$$INSTALLD("ICD*18.0*1001") S XPDQUIT=2
 I $$VCHK("DI","22.0",2,"<")
 I $$VCHK("XU","8.0",2,"<")
 I '$$INSTALLD("AUT*98.1*24") S XPDQUIT=2
 I '$$INSTALLD("AUM*11.0*6") S XPDQUIT=2
 ;
 NEW DA,DIC
 S X="ICD",DIC="^DIC(9.4,",DIC(0)="",D="C"
 D IX^DIC
 I Y<0,$D(^DIC(9.4,"C","ICD")) D
 .W !!,*7,*7,$$CJ^XLFSTR("You Have More Than One Entry In The",IOM),!,$$CJ^XLFSTR("PACKAGE File with an ""ICD"" prefix.",IOM)
 .W !,$$CJ^XLFSTR(IORVON_"One entry needs to be deleted."_IORVOFF,IOM)
 .D SORRY(2)
 ;
 I $G(XPDQUIT) W !,$$CJ^XLFSTR(IORVON_"You must FIX IT, Before Proceeding."_IORVOFF,IOM),!!,*7,*7,*7 Q
 W !!,$$CJ^XLFSTR("ENVIRONMENT OK.",IOM)
 D HELP^XBHELP("INTROE","ICD002E")
 I '$$DIR^XBDIR("E","","","","","",1) D SORRY(2) Q
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0 D HELP^XBHELP("INTROI","ICD002E") I '$$DIR^XBDIR("E","","","","","",1) D SORRY(2)
 Q
 ;
SORRY(X) ;
 KILL DIFQ
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("Sorry....FIX IT!",IOM)
 Q
 ;
VCHK(ICDPRE,ICDVER,ICDQUIT,ICDCOMP) ; Check versions needed.
 ;  
 NEW ICDV
 S ICDV=$$VERSION^XPDUTL(ICDPRE)
 W !,$$CJ^XLFSTR("Need "_$S(ICDCOMP="<":"at least ",1:"")_ICDPRE_" v "_ICDVER_"....."_ICDPRE_" v "_ICDV_" Present",IOM)
 I @(ICDV_ICDCOMP_ICDVER) D SORRY(ICDQUIT) Q 0
 Q 1
INSTALLD(ICD) ;EP; Determine if patch was installed, where ICD is
 ; the name of the INSTALL.  E.g "AVA*93.2*12".
 ;
 NEW DIC,X,Y
 ;  lookup package.
 S X=$P(ICD,"*",1)
 S DIC="^DIC(9.4,",DIC(0)="FM",D="C"
 D IX^DIC
 I Y<1 Q 0
 ;  lookup version.
 S DIC=DIC_+Y_",22,",X=$P(ICD,"*",2)
 D ^DIC
 I Y<1 Q 0
 ;  lookup patch.
 S DIC=DIC_+Y_",""PAH"",",X=$P(ICD,"*",3)
 D ^DIC
 I Y<1 S P=DIC_"""B"","_X_")" I $O(@P)'="" S Y=1
 I Y>0 W !,$$CJ^XLFSTR("Need at least "_ICD_"....."_ICD_" Present",IOM)
 I Y<0 W !,$$CJ^XLFSTR("Need at least "_ICD_".....",IOM)
 Q $S(Y<1:0,1:1)
 ; -------------------------------------------
INTROE ; Intro text during KIDS Environment check.
 ;; Distribution contains VA ICD patches 33 through 59.
 ;; Patch is required for Lexicon patches.
 ;;
 ;;
 ;;###
 ;
INTROI ; Intro text during KIDS Install.
 ;;A standard message will be produced by this update.
 ;;  
 ;;If you run interactively, results are displayed on your screen,
 ;;in the mail message and in the INSTALL file.
 ;;If you queue to TaskMan, please read the mail message for results of
 ;;this update, and remember not to Q to the HOME device.
 ;;###
