BAREV18 ; IHS/SD/LSL - ENVIRONMENT CHECK V1.8 ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;
 ;IHS/SD/RLT - 04/05/05
 ;             Modified routine to use PATCH^XPDUTL in the INSTALLD tag
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
 ;I $$VCHK("XU","8.0",2)              ; Kernel V8.0
 N BARXU
 ;S BARXU=$$INSTALLD("XU")               ;RLT     ; Find current Kernel version and patch
 S BARXU=$$INSTALLD("XU","8.0",1011)     ;RLT     ; Find current Kernel version and patch
 I $P(BARXU,"*",2)<8 S BARXU=0
 I $P(BARXU,"*",3)'=1 S BARXU=0        ;RLT
 ;I $P(BARXU,"*",2)>7,$P(BARXU,"*",2)<9,$P(BARXU,"*",3)<1010 S BARXU=0       ;RLT
 W !,$$CJ^XLFSTR("Need at least XU v8.0 Patch 1011..... "_$S(BARXU=0:"NOT ",1:"")_"Present",IOM)
 I BARXU=0 D SORRY(2)
 ;
 I $$VCHK("DI","21.0",2)             ; FileMan V21.0
 ;
 N BARXB
 ;S BARXB=$$INSTALLD("XB")               ;RLT    ; Find current IHS utilities version and patch
 S BARXB=$$INSTALLD("XB","3.0",11)       ;RLT    ; Find current IHS utilities version and patch
 I $P(BARXB,"*",2)<3 S BARXB=0
 I $P(BARXU,"*",3)'=1 S BARXU=0        ;RLT
 ;I $P(BARXB,"*",2)>2,$P(BARXB,"*",2)<4,$P(BARXB,"*",3)<10 S BARXB=0    ;RLT
 W !,$$CJ^XLFSTR("Need at least XB v3.0 Patch 11..... "_$S(BARXB=0:"NOT ",1:"")_"Present",IOM)
 I BARXB=0 D SORRY(2)
 ;
 I $$VCHK("BAR","1.7",2)             ; Accounts Receivable V1.7
 ;
 ; At least Third Party Billing V2.5 Patch 1 by looking for routine ABMUTLP in routine file
 N BARABM
 S BARABM=$$VERSION^XPDUTL("ABM")
 I BARABM'>2.5 S BARABM=$D(^DIC(9.8,"B","ABMUTLP"))
 W !,$$CJ^XLFSTR("Need at least ABM v2.5 Patch 1..... "_$S(BARABM=0:"NOT ",1:"")_" Present",IOM)
 I BARABM=0 D SORRY(2)
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
 D HELP^XBHELP("INTROE","BAREV18")
 ;
 I $G(XPDENV)=1 D
 . ; The following line prevents the "Disable Options..." and "Move
 . ; Routines..." questions from being asked during the install.
 . S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 . D HELP^XBHELP("INTROI","BAREV18")
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
INSTALLD(BARNM,BARVR,BARPT) ;EP    ;RLT
 ; RLT - 04/05/05 - Per Don Jackson, modified this tag to use
 ;                  PATCH^XPDUTL.  Removed the reverse $O, problem
 ;                  with XU patch numbers. VA (lower than 1000) and
 ;                  IHS patch numers (1000 and higher) not loaded
 ;                  in numerical order.  No longer
 ;                  verifies that a lower version did not get
 ;                  reinstalled over a higher version.
 ;INSTALLD(BAR)  ;EP            ;RLT   Old entry point
 ; Find current version and patch of said application (BAR)
 ; 1st look up package
 ;N DIC,X,Y,BARVER,BARVNUM,BARPATCH,BARPNUM
 ;S X=BAR
 ;S DIC="^DIC(9.4,"
 ;S DIC(0)="FM"
 ;S D="C"
 ;D IX^DIC
 ;I Y<1 Q 0
 ;; 2nd - find current version
 ;S BARVER=$O(^DIC(9.4,+Y,22,999999),-1)  ;last version installed
 ;I '+BARVER Q 0
 ;S BARVNUM=$P($G(^DIC(9.4,+Y,22,BARVER,0)),U)
 ;I '+BARVNUM Q 0
 ;; 3rd - find last patch installed for current version
 ;;^DIC(9.4,D0,22,D1,PAH,D2,0)
 ;S BARPATCH=$O(^DIC(9.4,+Y,22,BARVER,"PAH",999999),-1)   ;last patch
 ;I '+BARPATCH Q 0
 ;S BARPNUM=$P($G(^DIC(9.4,+Y,22,BARVER,"PAH",BARPATCH,0)),U)
 ;I '+BARPNUM Q 0
 ;Q BAR_"*"_BARVNUM_"*"_BARPNUM
 ;
 N BARVNUM,BARPATCH
 ;1 get current version
 S BARVNUM=$$VERSION^XPDUTL(BARNM)
 I '+BARVNUM Q 0
 ;2 is needed patch loaded
 S BARPATCH=$$PATCH^XPDUTL(BARNM_"*"_BARVR_"*"_BARPT)
 I '+BARPATCH Q 0
 Q BARNM_"*"_BARVNUM_"*"_BARPATCH
 ; ********************************************************************
INTROE ; Intro text during KIDS Environment check.
 ;;This distribution Modifies Accounts Receivable containing previous patch
 ;;modifications and:
 ;;(1) 2 enhanced reports
 ;;(2) 4 new reports
 ;;(3) New posting option - Auto Post Beneficiaries
 ;;(4) 2 EISS enhancements
 ;;(5) Debt Collections Module
 ;;###
 ;;
 ;
INTROI ; Intro text during KIDS Install.
 ;;If you run interactively, results will be displayed on your screen,
 ;;and recorded in the entry in the INSTALL file.
 ;;If you queue to TaskMan, remember not to Q to the HOME device.
 ;;###
