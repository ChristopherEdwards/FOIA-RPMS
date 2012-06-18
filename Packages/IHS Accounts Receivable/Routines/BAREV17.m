BAREV17 ; IHS/SD/LSL - ENVIRONMENT CHECK V1.7 ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;
 I '$G(DUZ) D  Q
 . W !,"DUZ UNDEFINED OR 0."
 . D SORRY(2)
 ;
 I '$L($G(DUZ(0))) D  Q
 . W !,"DUZ(0) UNDEFINED OR NULL."
 . D SORRY(2)
 ;
 S X=$P(^VA(200,DUZ,0),U)            ; User's name
 W !!,$$CJ^XLFSTR("Hello, "_$P(X,",",2)_" "_$P(X,","),IOM)
 W !!,$$CJ^XLFSTR("Checking Environment for "_$P($T(+2),";",4)_" V "_$P($T(+2),";",3),IOM)
 ;
 I $$VCHK("XU","8.0",2)              ; Kernel V8.0
 I $$VCHK("DI","21.0",2)             ; FileMan V21.0
 I $$VCHK("BAR","1.6",2)             ; Accounts Receivable V1.6
 ;
 ; At least Third Party Billing V2.5 Patch 1 by looking for routine ABMUTLP in routine file
 N BARABM
 S BARABM=$$VERSION^XPDUTL("ABM")
 I BARABM'>2.5 S BARABM=$D(^DIC(9.8,"B","ABMUTLP"))
 W !,$$CJ^XLFSTR("Need at least ABM v2.5 Patch 1..... "_$S(BARABM=0:"NOT ",1:"")_" Present",IOM)
 I BARABM=0 D SORRY(2)
 ;
 ;N BARGIS                            ; GIS V3.01 Patch 2
 ;S BARGIS=$$INSTALLD("GIS*3.01*2")
 ;W !,$$CJ^XLFSTR("Need Patch GIS*3.01*2..... "_$S(BARGIS:"",1:"NOT ")_"Installed",IOM)
 ;I 'BARGIS D SORRY(2)
 ;
 ;N BARGIS2                            ; GIS V3.01 Patch 6
 ;S BARGIS2=$$INSTALLD("GIS*3.01*6")
 ;W !,$$CJ^XLFSTR("Need Patch GIS*3.01*6..... "_$S(BARGIS2:"",1:"NOT ")_"Installed",IOM)
 ;I 'BARGIS2 D SORRY(2)
 ;
 N DA,DIC
 S X="BAR"
 S DIC="^DIC(9.4,"
 S DIC(0)=""
 S D="C"
 D IX^DIC
 I Y<0,$D(^DIC(9.4,"C","BAR")) D
 . W !!,*7,*7,$$CJ^XLFSTR("You Have More Than One Entry In The",IOM)
 . W !,$$CJ^XLFSTR("PACKAGE File with an ""BAR"" prefix.",IOM)
 . W !,$$CJ^XLFSTR("One entry needs to be deleted.",IOM)
 . D SORRY(2)
 . Q
 ;
 I $G(XPDQUIT) W !,$$CJ^XLFSTR("FIX IT! Before Proceeding.",IOM),!!,*7,*7,*7 Q
 ;
 W !!,$$CJ^XLFSTR("ENVIRONMENT OK.",IOM)
 D HELP^XBHELP("INTROE","BAREV17")
 ;
 I $G(XPDENV)=1 D
 . ; The following line prevents the "Disable Options..." and "Move
 . ; Routines..." questions from being asked during the install.
 . S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 . D HELP^XBHELP("INTROI","BAREV17")
 . Q
 ;
 I '$$DIR^XBDIR("E","","","","","",1) D SORRY(2)
 Q
 ; ********************************************************************
SORRY(X) ;
 KILL DIFQ
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("Sorry....FIX IT!",IOM)
 Q
 ; ********************************************************************
VCHK(BARPRE,BARVER,BARQUIT)     ; Check versions needed.
 ;
 N BARV
 S BARV=$$VERSION^XPDUTL(BARPRE)
 W !,$$CJ^XLFSTR("Need at least "_BARPRE_" v "_BARVER_"....."_BARPRE_" v "_BARV_" Present",IOM)
 I BARV<BARVER KILL DIFQ S XPDQUIT=BARQUIT D SORRY(BARQUIT) Q 0
 Q 1
 ; ********************************************************************
INSTALLD(BAR) ;EP
 ; Determine if Third Party Billing V2.5 Patch 1 has been installed
 ; where BARABM is the name of the INSTALL  (ABM*2.5*1)
 ; 1st look up package
 N DIC,X,Y
 S X=$P(BAR,"*")
 S DIC="^DIC(9.4,"
 S DIC(0)="FM"
 S D="C"
 D IX^DIC
 I Y<1 Q 0
 ; 2nd look up version
 S DIC=DIC_+Y_",22,"
 S X=$P(BAR,"*",2)
 D ^DIC
 I Y<1 Q 0
 ; 3rd look up patch
 S DIC=DIC_+Y_",""PAH"","
 S X=$P(BAR,"*",3)
 D ^DIC
 Q $S(Y<1:0,1:1)
 ; ********************************************************************
INTROE ; Intro text during KIDS Environment check.
 ;;This distribution Modifies Accounts Receivable contains previous patch
 ;;modifications and:
 ;;(1) 15 minor issues reported from the field
 ;;(2) 2 major functionality flaws
 ;;    (a) Finding the correct bill in 3PB at multifacility sites
 ;;    (b) Resolves the error in getting a transaction problem when
 ;;        posting.
 ;;###
 ;;
 ;
INTROI ; Intro text during KIDS Install.
 ;;If you run interactively, results will be displayed on your screen,
 ;;and recorded in the entry in the INSTALL file.
 ;;If you queue to TaskMan, remember not to Q to the HOME device.
 ;;###
