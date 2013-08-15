BAREV822 ; IHS/SD/LSL - ENVIRONMENT CHECK V1.8 PATCH 22; 06/01/2010
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**22**;OCT 26,2005;Build 38
 ;
 K XPDQUIT                       ;CLEAR FLAG
 I '$G(DUZ) D  Q
 . W !,"DUZ UNDEFINED OR 0"
 . D SORRY(2)
 ;
 I '$L($G(DUZ(0))) D  Q
 . W !,"DUZ(0) UNDEFINED OR NULL"
 . D SORRY(2)
 ;
 S X=$P(^VA(200,DUZ,0),U)                ;User's name
 W !!,$$CJ^XLFSTR("Hello, "_$P(X,",",2)_" "_$P(X,","),IOM)
 W !!,$$CJ^XLFSTR("Checking Environment for "_$P($T(+2),";",4)_" V "_$P($T(+2),";",3),IOM)
 ;
 N BARXU
 S BARXU=$$INSTALLD("XU","8.0",1011)     ;Find current Kernel version and patch
 I $P(BARXU,"*",2)<8 S BARXU=0
 I $P(BARXU,"*",3)'=1011 S BARXU=0
 W !,$$CJ^XLFSTR("Need at least XU v8.0 Patch 1011..... "_$S(BARXU=0:"NOT ",1:"")_"Present",IOM)
 I BARXU=0 D SORRY(2)
 ;
 I $$VCHK("DI","22.0",2)                 ;FileMan V22.0
 ;
 N BARXB
 S BARXB=$$INSTALLD("XB","2.6",11)       ;Find current IHS utilities version and patch
 I $P(BARXB,"*",2)<3 S BARXB=0
 I $P(BARXU,"*",3)'=11 S BARXU=0
 ;
 I $$VCHK("BAR","1.8",2)                 ;Accounts Receivable V1.8
 ;3PB 2.6 Patch 4
 N BARABM
 S BARABM=$$INSTALLD("ABM","2.6",4)
 I $P(BARABM,"*",2)<2.6 S BARABM=0
 I $P(BARABM,"*",3)<4 S BARABM=0
 W !,$$CJ^XLFSTR("Need at least Third Party Billing v2.6 Patch 4..... "_$S(BARABM=0:"NOT ",1:"")_"Present",IOM)
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
 ;A/R IS NO LONGER CUMULATIVE AFTER PATCH 6
 ;LAST CUMULATIVE PATCH WAS PATCH 6
 N BAR,I
 F I=6:1:7,9,10,12,13,14,15,16,17,18,19,20,21 D           ;NOTE: BAR*1.8*8 WAS REPLACED WITH BAR*1.8*9
 .S BAR=$$INSTALLD("BAR","1.8",I)
 .I $P(BAR,"*",3)'=I S BAR=0 D
 ..W !,$$CJ^XLFSTR("Need Accounts Receivable v1.8 Patch "_I_"..... "_$S(BAR=0:"NOT ",1:"")_"Present",IOM)
 I BAR=0 D SORRY(2)
 ;
 I $G(XPDQUIT) W !,$$CJ^XLFSTR("FIX IT! Before Proceeding.",IOM),!!,*7,*7,*7 Q
 ;
 W !!,$$CJ^XLFSTR("ENVIRONMENT OK.",IOM)
 D HELP^XBHELP("INTROE","BAREV810")
 ;
 I $G(XPDENV)=1 D
 . ; The following line prevents the "Disable Options..." and "Move
 . ; Routines..." questions from being asked during the install.
 . S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 . D HELP^XBHELP("INTROI","BAREV822")
 . Q
 ;
 I '$$DIR^XBDIR("E","","","","","",1) D SORRY(2)
 Q
 ;
POST ;EP - POST INSTALL
 Q:$$INSTALLD^BAREV822("BAR","1.8",22)="BAR*1.8*22"
 ;======================================================================
 ; SET UP DEBT MANAGEMENT PARAMETERS
 ; ---------------------------------------------------------------------
 F I=1:1:4 S LET(I)=0,LET(I)=$O(^BAR(90052.03,"B","DEBT MANAGEMENT LETTER "_I,LET(I)))
 S BARP=0
 F  S BARP=$O(^BAR(90052.06,BARP)) Q:BARP'?1N.N  D
 .S BARS=0 F  S BARS=$O(^BAR(90052.06,BARP,BARS)) Q:BARS'?1N.N  D
 ..S DIE="^BAR(90052.06,"_BARP_",",DA=BARS
 ..S DR="1705///"_LET(1)_";1706///"_60_";1707///"_LET(2)_";1708///"_90
 ..S DR=DR_";1709///"_LET(3)_";1710///"_120_";1711///"_LET(4)_";1712///"_150
 ..S DR=DR_";1808///250"
 ..D ^DIE
 ;
 ;======================================================================
 ; ADD DEPT MANAGEMENT Menu
 ;----------------------------------------------------------------------
 I $$ADD^XPDMENU("BAR ACM MAIN","BAR DM MENU","DBT") D MES^XPDUTL($J("",5)_"Debt Management Menu added to the Account Management Menu")
 ;
 D EN^BARADJR7  ;new SARs
 D ZNODE  ;add zero node for A/R DEBT MANAGEMENT BILLS file bar*1.8*22 SDR
 D BMES^XPDUTL("Post-install routine is complete.")
 Q
 ;start new code bar*1.8*22 SDR
ZNODE ;EP
 S DUZHOLD=DUZ(2)
 S DUZ(2)=0
 F  S DUZ(2)=$O(^BARBL(DUZ(2))) Q:'+DUZ(2)  D
 .; A/R Debt Mgmt Bill file
 .S BAR("GL")="^BARDM(DUZ(2),0)"
 .S @BAR("GL")=^DIC(90053.05,0)
 .;A/R Debt Mgmt Print Log file
 .S BAR("GL")="^BARDMLG(DUZ(2),0)"
 .S @BAR("GL")=^DIC(90053.08,0)
 S DUZ(2)=DUZHOLD
 K DUZHOLD,BAR
 Q
 ;end new code
 ;
SORRY(X) ;
 KILL DIFQ
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("Sorry....FIX IT!",IOM)
 Q
 ; ***
VCHK(BARPRE,BARVER,BARQUIT)     ; Check versions needed.
 ;
 N BARV
 S BARV=$$VERSION^XPDUTL(BARPRE)
 W !,$$CJ^XLFSTR("Need at least "_BARPRE_" v "_BARVER_"....."_BARPRE_" v "_BARV_" Present",IOM)
 I BARV<BARVER KILL DIFQ S XPDQUIT=BARQUIT D SORRY(BARQUIT) Q 0
 Q 1
 ; ***
INSTALLD(BARNM,BARVR,BARPT) ;EP    ;RLT
 N BARVNUM,BARPATCH
 ;1 get current version
 S BARVNUM=$$VERSION^XPDUTL(BARNM)
 I '+BARVNUM Q 0
 ;2 is needed patch loaded
 S BARPATCH=$$PATCH^XPDUTL(BARNM_"*"_BARVR_"*"_BARPT)
 I '+BARPATCH Q 0
 Q BARNM_"*"_BARVNUM_"*"_BARPT
 ;
 ; ********************************************************************
INTROE ; Intro text during KIDS Environment check.
 ;;This distribution Modifies Accounts Receivable and does not contain
 ;;previous patch modifications for version 1.8.
 ;;
 ;;        This patch is **not** cumulative.
 ;;
 ;;  Patch contains all menu options, site parameters and letters for
 ;;  the Debt Mangement system.
 ;;  Some parameters have been pre-defined but may be changed under the
 ;;  Debt Management Parameters and Debt Letter Signature/Address parameters
 ;;  options.
 ;;
 ;;  You also need to set up the insurers/accounts letters will be sent 
 ;;  to.
 ;;
 ;;###
 ;;
 ;
INTROI ; Intro text during KIDS Install.
 ;;If you run interactively, results will be displayed on your screen,
 ;;and recorded in the entry in the INSTALL file.
 ;;If you queue to TaskMan, remember not to Q to the HOME device.
 ;;###
