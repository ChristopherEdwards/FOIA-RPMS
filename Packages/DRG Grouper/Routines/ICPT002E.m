ICPT002E ;IHS/OIT/FCJ - ICPT*6.0*1002 Env Check FOR IHS patch 1002
 ;;6.0;CPT/HCPCS;**1002**;May 19, 1997               ;Build 9
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
 I '$$INSTALLD("ICPT*6.0*37") S XPDQUIT=2
 I $$VCHK("DI","22.0",2,"<")
 I $$VCHK("XU","8.0",2,"<")
 I '$$INSTALLD("AUT*98.1*24") S XPDQUIT=2
 I '$$INSTALLD("AUM*11.0*6") S XPDQUIT=2
 ;
 NEW DA,DIC
 S X="ICPT",DIC="^DIC(9.4,",DIC(0)="",D="C"
 D IX^DIC
 I Y<0,$D(^DIC(9.4,"C","ICPT")) D
 .W !!,*7,*7,$$CJ^XLFSTR("You Have More Than One Entry In The",IOM),!,$$CJ^XLFSTR("PACKAGE File with an ""ICPT"" prefix.",IOM)
 .W !,$$CJ^XLFSTR(IORVON_"One entry needs to be deleted."_IORVOFF,IOM)
 .D SORRY(2)
 ;
 I $G(XPDQUIT) W !,$$CJ^XLFSTR(IORVON_"You must FIX IT, Before Proceeding."_IORVOFF,IOM),!!,*7,*7,*7 Q
 W !!,$$CJ^XLFSTR("ENVIRONMENT OK.",IOM)
 D HELP^XBHELP("INTROE","ICPT002E")
 I '$$DIR^XBDIR("E","","","","","",1) D SORRY(2) Q
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0 D HELP^XBHELP("INTROI","ICPT002E") I '$$DIR^XBDIR("E","","","","","",1) D SORRY(2)
 Q
 ;
SORRY(X) ;
 KILL DIFQ
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("Sorry....FIX IT!",IOM)
 Q
 ;
VCHK(ICPTPRE,ICPTVER,ICPTQUIT,ICPTCOMP) ; Check versions needed.
 ;  
 NEW ICPTV
 S ICPTV=$$VERSION^XPDUTL(ICPTPRE)
 W !,$$CJ^XLFSTR("Need "_$S(ICPTCOMP="<":"at least ",1:"")_ICPTPRE_" v "_ICPTVER_"....."_ICPTPRE_" v "_ICPTV_" Present",IOM)
 I @(ICPTV_ICPTCOMP_ICPTVER) D SORRY(ICPTQUIT) Q 0
 Q 1
INSTALLD(ICPT) ;EP; Determine if patch was installed, where ICPT is
 ; the name of the INSTALL.  E.g "AVA*93.2*12".
 ;
 NEW DIC,X,Y
 ;  lookup package.
 S X=$P(ICPT,"*",1)
 S DIC="^DIC(9.4,",DIC(0)="FM",D="C"
 D IX^DIC
 I Y<1 Q 0
 ;  lookup version.
 S DIC=DIC_+Y_",22,",X=$P(ICPT,"*",2)
 D ^DIC
 I Y<1 Q 0
 ;  lookup patch.
 S DIC=DIC_+Y_",""PAH"",",X=$P(ICPT,"*",3)
 D ^DIC
 I Y<1 S P=DIC_"""B"","_X_")" I $O(@P)'="" S Y=1
 I Y>0 W !,$$CJ^XLFSTR("Need at least "_ICPT_"....."_ICPT_" Present",IOM)
 I Y<0 W !,$$CJ^XLFSTR("Need at least "_ICPT_".....",IOM)
 Q $S(Y<1:0,1:1)
 ; -------------------------------------------
INTROE ; Intro text during KIDS Environment check.
 ;; Distribution contains VA ICPT patches 38 through 57.
 ;; Patch is required for Lexicon IHS patch 1002.
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
