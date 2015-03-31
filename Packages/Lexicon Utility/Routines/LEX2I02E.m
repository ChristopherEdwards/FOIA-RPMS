LEX2I02E ;IHS/OIT/FCJ - LEX*2.0*1002 Env Check FOR IHS patch 1002 ;07/01/2011
 ;;2.0;LEXICON UTILITY;**1002**;Sep 23, 1996;Build 15
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
 ;I $$INSTALLD("LEX*2.0*1002") W !,"LEX*2.0 has already been installed." S XPDQUIT=2 Q
 I '$$INSTALLD("ICPT*6.0*1002") S XPDQUIT=2
 I '$$INSTALLD("ICD*18.0*1002") S XPDQUIT=2
 I '$$INSTALLD("LEX*2.0*1001") S XPDQUIT=2
 I $$VCHK("DI","22.0",2,"<")
 I $$VCHK("XU","8.0",2,"<")
 I '$$INSTALLD("AUT*98.1*24") S XPDQUIT=2
 I '$$INSTALLD("AUM*11.0*6") S XPDQUIT=2
 ;
 NEW DA,DIC
 S X="LEX",DIC="^DIC(9.4,",DIC(0)="",D="C"
 D IX^DIC
 I Y<0,$D(^DIC(9.4,"C","LEX")) D
 .W !!,*7,*7,$$CJ^XLFSTR("You Have More Than One Entry In The",IOM),!,$$CJ^XLFSTR("PACKAGE File with an ""LEX"" prefix.",IOM)
 .W !,$$CJ^XLFSTR(IORVON_"One entry needs to be deleted."_IORVOFF,IOM)
 .D SORRY(2)
 ;
 I $G(XPDQUIT) W !,$$CJ^XLFSTR(IORVON_"You must FIX IT, Before Proceeding."_IORVOFF,IOM),!!,*7,*7,*7 Q
 W !!,$$CJ^XLFSTR("ENVIRONMENT OK.",IOM)
 D HELP^XBHELP("INTROE","LEX2I02E")
 I '$$DIR^XBDIR("E","","","","","",1) D SORRY(2) Q
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0 D HELP^XBHELP("INTROI","LEX2I02E") I '$$DIR^XBDIR("E","","","","","",1) D SORRY(2)
 Q
 ;
SORRY(X) ;
 KILL DIFQ
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("Sorry....FIX IT!",IOM)
 Q
 ;
VCHK(LEXPRE,LEXVER,LEXQUIT,LEXCOMP) ; Check versions needed.
 ;  
 NEW LEXV
 S LEXV=$$VERSION^XPDUTL(LEXPRE)
 W !,$$CJ^XLFSTR("Need "_$S(LEXCOMP="<":"at least ",1:"")_LEXPRE_" v "_LEXVER_"....."_LEXPRE_" v "_LEXV_" Present",IOM)
 I @(LEXV_LEXCOMP_LEXVER) D SORRY(LEXQUIT) Q 0
 Q 1
INSTALLD(LEX) ;EP; Determine if patch was installed, where LEX is
 ; the name of the INSTALL.  E.g "AVA*93.2*12".
 ;
 NEW DIC,X,Y
 ;  lookup package.
 S X=$P(LEX,"*",1)
 S DIC="^DIC(9.4,",DIC(0)="FM",D="C"
 D IX^DIC
 I Y<1 Q 0
 ;  lookup version.
 S DIC=DIC_+Y_",22,",X=$P(LEX,"*",2)
 D ^DIC
 I Y<1 Q 0
 ;  lookup patch.
 S DIC=DIC_+Y_",""PAH"",",X=$P(LEX,"*",3)
 D ^DIC
 I Y<1 S P=DIC_"""B"","_X_")" I $O(@P)'="" S Y=1
 I Y>0 W !,$$CJ^XLFSTR("Need at least "_LEX_"....."_LEX_" Present",IOM)
 I Y<0 W !,$$CJ^XLFSTR("Need at least "_LEX_".....",IOM)
 Q $S(Y<1:0,1:1)
 ; -------------------------------------------
INTROE ; Intro text during KIDS Environment check.
 ;; Distribution contains VA Lexicon patches 54 through 78
 ;; and patch 81.  Patch 81 is an index patch fix which 
 ;; is required.  Patch 79 and 80 are data patches,
 ;; IHS currently releases ICD codes annually, as VA
 ;; releases quarterly. Patches 79 and 80 will be released
 ;; with the annual ICD patch in October.
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
