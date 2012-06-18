ACHS31E1 ;IHS/OIT/FCJ - ACHS 3.1 PATCH ENV CHECK ;
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**20**;JUN 11,2001
 ;3.1*14 1/11/2008;IHS/OIT/FCJ
 ; CHANGE INTROE SECTION WITH EACH PATCH
 ;
 ;
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
AR ;
 ;TEST FOR AREA OFFICE INSTALL, LEX AND ICD INSTALLS ARE NOT REQUIRED FOR AREA INSTALLS
 S ACHSAR=0
 S DIR(0)="Y",DIR("A")="Is this an AREA OFFICE install",DIR("B")="N"
 S DIR("?")="Only answer Yes if this is being installed in the Area office namespace without a facility operating in this namespace."
 D ^DIR
 I $D(DTOUT)!$D(DUOUT)!$D(DIRUT) W !,"User stopped environment check." Q
 S ACHSAR=+Y
CHK ;
 I '$$INSTALLD("ACHS*3.1*19") S XPDQUIT=2
 I $$VCHK("DI","22.0",2,"<")
 I $$VCHK("XU","8.0",2,"<")
 I '$$INSTALLD("AUPN*99.1*16") S XPDQUIT=2
 I '$$INSTALLD("AUT*98.1*20") S XPDQUIT=2
 I $$VCHK("ATX","5.1",2,"<")
 I ACHSAR=0 D
 .I $$VCHK("LEX","2.0",2,"<")
 .I '$$INSTALLD("AICD*3.51*7") S XPDQUIT=2
 ;
 NEW DA,DIC
 S X="ACHS",DIC="^DIC(9.4,",DIC(0)="",D="C"
 D IX^DIC
 I Y<0,$D(^DIC(9.4,"C","ACHS")) D
 .W !!,*7,*7,$$CJ^XLFSTR("You Have More Than One Entry In The",IOM),!,$$CJ^XLFSTR("PACKAGE File with an ""ACHS"" prefix.",IOM)
 .W !,$$CJ^XLFSTR(IORVON_"One entry needs to be deleted."_IORVOFF,IOM)
 .D SORRY(2)
 ;
 I $G(XPDQUIT) W !,$$CJ^XLFSTR(IORVON_"You must FIX IT, Before Proceeding."_IORVOFF,IOM),!!,*7,*7,*7 Q
 W !!,$$CJ^XLFSTR("ENVIRONMENT OK.",IOM)
 D HELP^XBHELP("INTROE","ACHS31E1")
 I '$$DIR^XBDIR("E","","","","","",1) D SORRY(2) Q
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0 D HELP^XBHELP("INTROI","ACHS31E1") I '$$DIR^XBDIR("E","","","","","",1) D SORRY(2)
 Q
 ;
SORRY(X) ;
 KILL DIFQ
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("Sorry....FIX IT!",IOM)
 Q
 ;
VCHK(ACHSPRE,ACHSVER,ACHSQUIT,ACHSCOMP) ; Check versions needed.
 ;  
 NEW ACHSV
 S ACHSV=$$VERSION^XPDUTL(ACHSPRE)
 W !,$$CJ^XLFSTR("Need "_$S(ACHSCOMP="<":"at least ",1:"")_ACHSPRE_" v "_ACHSVER_"....."_ACHSPRE_" v "_ACHSV_" Present",IOM)
 I @(ACHSV_ACHSCOMP_ACHSVER) D SORRY(ACHSQUIT) Q 0
 Q 1
INSTALLD(ACHS) ;EP; Determine if patch ACHS was installed, where ACHS is
 ; the name of the INSTALL.  E.g "AVA*93.2*12".
 ;
 NEW DIC,X,Y
 ;  lookup package.
 S X=$P(ACHS,"*",1)
 S DIC="^DIC(9.4,",DIC(0)="FM",D="C"
 D IX^DIC
 I Y<1 Q 0
 ;  lookup version.
 S DIC=DIC_+Y_",22,",X=$P(ACHS,"*",2)
 D ^DIC
 I Y<1 Q 0
 ;  lookup patch.
 S DIC=DIC_+Y_",""PAH"",",X=$P(ACHS,"*",3)
 D ^DIC
 I Y<1 S P=DIC_"""B"","_X_")" I $O(@P)'="" S Y=1
 I Y>0 W !,$$CJ^XLFSTR("Need at least "_ACHS_"....."_ACHS_" Present",IOM)
 I Y<0 W !,$$CJ^XLFSTR("Need at least "_ACHS_".....",IOM)
 Q $S(Y<1:0,1:1)
 ; -------------------------------------------
INTROE ; Intro text during KIDS Environment check.
 ;;In this distribution:
 ;;(1)Modifications: 
 ;;    1. ACHSRPFU,ACHSRPF,ACHSRPF1 - Routines for using the GUI
 ;;       formless printing.
 ;;    2. ACHSRPU - Fixed the document number printing.
 ;;    3. ACHSMERG - Added entry point for patient merge.
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
 ;
