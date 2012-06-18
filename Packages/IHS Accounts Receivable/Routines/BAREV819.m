BAREV819 ; IHS/SD/LSL - ENVIRONMENT CHECK V1.8 PATCH 819; 06/01/2010
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**19**;OCT 26,2005
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
 ;I $$VCHK("DI","21.0",2)                 ;FileMan V21.0
 I $$VCHK("DI","22.0",2)                 ;FileMan V22.0  1.8*19
 ;
 N BARXB
 S BARXB=$$INSTALLD("XB","2.6",11)       ;Find current IHS utilities version and patch
 I $P(BARXB,"*",2)<3 S BARXB=0
 I $P(BARXU,"*",3)'=11 S BARXU=0
 ; commented out - removed from notes file 1.8*19
 ;W !,$$CJ^XLFSTR("Need at least XB v3.0 Patch 11..... "_$S(BARXB=0:"NOT ",1:"")_"Present",IOM)
 ;I BARXB=0 D SORRY(2)
 ;
 I $$VCHK("BAR","1.8",2)                 ;Accounts Receivable V1.8
 ;
3PB N BARABM
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
 F I=6:1:7,9,10,12,13,14,15,16,17,18 D           ;NOTE: BAR*1.8*8 WAS REPLACED WITH BAR*1.8*9
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
 . D HELP^XBHELP("INTROI","BAREV810")
 . Q
 ;
 I '$$DIR^XBDIR("E","","","","","",1) D SORRY(2)
 Q
 ;
POST ;EP - POST INSTALL
 ;======================================================================
 ; Rebuild all cross-references for A/R EDI STND CLAIMS ADJ REASONS file
 ; ---------------------------------------------------------------------
 S DIK="^BARADJ("
 D IXALL^DIK
 ;
 ;======================================================================
 ; A/R Menu updates:
 ;----------------------------------------------------------------------
 I '$G(DUZ) W !,"DUZ UNDEFINED OR 0." Q
 ;
 I '$L($G(DUZ(0))) W !,"DUZ(0) UNDEFINED OR NULL." Q
 ;
 I '(DUZ(0)["@") W:'$D(ZTQUEUED) !,"DUZ(0) DOES NOT CONTAIN AN '@'." Q
 ;
 ; REMOVED $$ADD^XPDMENU code and included Menues in the KIDS build 1/10/11 1.8*19 
 D BMES^XPDUTL("Post-install routine is complete.")
 ;
POSTPPAY ;  initial set of A/R Prepayment files
 ;======================================================================
 ; Setup ^BARPPAY for all DUZ(2) defined in A/R Collection Batch file:
 ;----------------------------------------------------------------------
 W !!,"Initialize A/R PREPAYMENT files",!!
 S BARDUZ2=0 F  S BARDUZ2=$O(^BAR(90052.06,BARDUZ2)) Q:'BARDUZ2  D
 . I '$D(^BARPPAY(BARDUZ2)) S ^BARPPAY(BARDUZ2,0)="A/R PREPAYMENT^90050.06^^"
 . W !,"  ",$$GET1^DIQ(4,BARDUZ2_",",.01,"E")
 W !!,"A/R PREPAYMENT file setup complete",!!
 ;
 ;======================================================================
 ; Set file security for new A/R Prepayment file (^BARPPAY)
 ;----------------------------------------------------------------------
 F BARNODE="DEL","LAYGO","AUDIT","DD" S ^DIC(90050.06,0,BARNODE)="@"
 F BARNODE="RD","WR" S ^DIC(90050.06,0,BARNODE)="V"
 ;
 ;======================================================================
 ; 
 ;----------------------------------------------------------------------
 ;
 ;
ENTRY ;
 ; Create entry
 S BARD=";;"
 F BARIEN=25 D EN
 D ^BARVKL0
 D ENTRY2
 Q
 ; *********************************************************************
 ;
EN ;
 S BARVALUE=$P($T(@BARIEN),BARD,2,3)
 K DIC,DA,X,Y
 S DIC="^BAR(90052.01,"
 S DIC(0)="LZE"
 S DINUM=BARIEN
 S DLAYGO=90052.01
 S X=$P(BARVALUE,BARD)
 S DIC("DR")="2///^S X=$P(BARVALUE,BARD,2)"
 K DD,DO
 D FILE^DICN
 Q
 ; *********************************************************************
 ; NAME;;ACRONYM
 ; *********************************************************************
25 ;;SENT TO COLLECTIONS;;STC
 ;
ENTRY2 ;
 ; Create entry
 S BARD=";;"
 S BARCNT=0
 F  D EN2 Q:BARVALUE="END"
 D ^BARVKL0
 Q
 ; ********************************************************************
EN2 ;
 S BARCNT=BARCNT+1
 S BARVALUE=$P($T(@1+BARCNT),BARD,2,5)
 Q:BARVALUE="END"
 K DIC,DA,X,Y
 S DIC="^BARTBL("
 S DIC(0)="LZE"
 S DINUM=$P(BARVALUE,BARD)
 S DLAYGO=90052.02
 S X=$P(BARVALUE,BARD,2)
 S DIC("DR")="2///^S X=$P(BARVALUE,BARD,3)"
 S DIC("DR")=DIC("DR")_";6////"_$P(BARVALUE,BARD,4)
 K DD,DO
 D FILE^DICN
 Q
 ; *********************************************************************
 ; IEN;;NAME;;TABLE TYPE;;ACRONYM
 ; *********************************************************************
1 ;;
 ;;990;;PSC (PROGRAM SUPPORT CENTER);;25;;PSC
 ;;991;;LOCAL COLLECTION COMPANY;;25;;COL
 ;;992;;INTERNAL COLLECTIONS;;25;;ICOL
 ;;993;;STATUS CHANGE;;7;;STC
 ;;END
 ;
 ;
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
 ; RLT - 04/05/05 - Per Don Jackson, modified this tag to use
 ;                  PATCH^XPDUTL.  Removed the reverse $O, problem
 ;                  with XU patch numbers. VA (lower than 1000) and
 ;                  IHS patch numers (1000 and higher) not loaded
 ;                  in numerical order.  No longer
 ;                  verifies that a lower version did not get
 ;                  reinstalled over a higher version.
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
 ;;###
 ;;
 ;
INTROI ; Intro text during KIDS Install.
 ;;If you run interactively, results will be displayed on your screen,
 ;;and recorded in the entry in the INSTALL file.
 ;;If you queue to TaskMan, remember not to Q to the HOME device.
 ;;###
