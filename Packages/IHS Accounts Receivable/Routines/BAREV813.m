BAREV813 ; IHS/SD/LSL - ENVIRONMENT CHECK V1.8 PATCH 13; 03/18/2009
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**13**;APR 21,2009
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
 I $$VCHK("DI","21.0",2)                 ;FileMan V21.0
 ;
 N BARXB
 S BARXB=$$INSTALLD("XB","3.0",11)       ;Find current IHS utilities version and patch
 I $P(BARXB,"*",2)<3 S BARXB=0
 I $P(BARXU,"*",3)'=11 S BARXU=0
 W !,$$CJ^XLFSTR("Need at least XB v3.0 Patch 11..... "_$S(BARXB=0:"NOT ",1:"")_"Present",IOM)
 I BARXB=0 D SORRY(2)
 ;
 I $$VCHK("BAR","1.8",2)                 ;Accounts Receivable V1.8
 ;
 N BARABM
 S BARABM=$$INSTALLD("ABM","2.5",13)
 I $P(BARABM,"*",2)<2.5 S BARABM=0
 I $P(BARABM,"*",3)'=13 S BARABM=0
 W !,$$CJ^XLFSTR("Need at least Third Party Billing v2.5 Patch 13..... "_$S(BARABM=0:"NOT ",1:"")_"Present",IOM)
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
 F I=6:1:7,9,10,11,12 D                           ;BAR*1.8*8 WAS REPLACED WITH BAR*1.8*9
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
 D ADDZISH         ;ADD ZISH SEND PARAMETER ENTRIES FOR OMB
 Q
 ;
ADDZISH ;EP - ADD ZISH ENTIRES TO 'ZISH SEND PARAMETERS' FILE
 ;ADD 'BAR OMB B' BACKGROUND ENTRY
 ;ADD 'BAR OMB F' FOREGROUND ENTRY
ADDF ;ADD FOREGROUND
 ;I $D(^%ZIB(9888888.93,"B","BAR OMB F")) D
 ;IF ENTRY IS SET TO omb THIS IS TEST SYSTEM - DO NOT UPDATE
 ;I $D(^%ZIB(9888888.93,"B","BAR OMB F")) D  Q:$$GET1^DIQ(9888888.93,REC_",",.03)="omb"     ;TMM V1.8*13
 I $D(^%ZIB(9888888.93,"B","BAR OMB F")) D  Q:$$GET1^DIQ(9888888.93,REC_",",.03)="ombdata"  ;TMM V1.8*13
 .S REC=$O(^%ZIB(9888888.93,"B","BAR OMB F",""))
 .D BMES^XPDUTL("Found [BAR OMB F] as a ZISH SEND PARAMETER entry")
 D BMES^XPDUTL("Adding [BAR OMB F] as a ZISH SEND PARAMETER entry")
 K DIC,DIE,DA,DR,DIR
 S DIC="^%ZIB(9888888.93,"
 S DIC(0)="L"
 S X="BAR OMB F"
 D ^DIC
 I +Y<0 W !,"UNABLE TO ADD ZISH PARAMETER ENTRY. TRY MANUALLY!!" Q
 K DIC,DIE,DA,DR,DIR,DD,DO,DINUM
 S DIE="^%ZIB(9888888.93,"
 S DA=+Y
 ;In-house testing - (pre-beta)       ;TMM V1.8*13
 ;S USERNAME="omb"                    ;TMM V1.8*13
 ;S PASSWORD="ombftp,1"               ;TMM V1.8*13
 ;S SENDCMD="sendto"                  ;TMM V1.8*13
 ;S TYPE="F"                          ;TMM V1.8*13
 ;S TARGETIP="161.223.91.114"         ;TMM V1.8*13
 ;
 ;Current 
 S USERNAME="ombdata"                 ;TMM V1.8*13
 S PASSWORD="f7cjfbyk"                ;TMM V1.8*13
 S SENDCMD="sendto"                   ;TMM V1.8*13
 S TYPE="F"                           ;TMM V1.8*13
 S TARGETIP="161.223.90.8"            ;TMM V1.8*13
 ;
 ;S ARGS="-i -g"                      ;TMM V1.8*13
 S ARGS="-i -g -u"                    ;TMM V1.8*13
 S DR=".02///^S X=TARGETIP"
 S DR=DR_";.03///^S X=USERNAME"
 S DR=DR_";.04////^S X=PASSWORD"
 S DR=DR_";.06///^S X=ARGS"
 S DR=DR_";.07///^S X=TYPE"
 S DR=DR_";.08///^S X=SENDCMD"
 D ^DIE
 K DIC,DIE,DA,DR,DIR
ADDB ;ADD BACKGROUND
 ;I $D(^%ZIB(9888888.93,"B","BAR OMB B")) D
 ;I $D(^%ZIB(9888888.93,"B","BAR OMB B")) D  Q:$$GET1^DIQ(9888888.93,REC_",",.03)="omb"     ;TMM V1.8*13
 I $D(^%ZIB(9888888.93,"B","BAR OMB B")) D  Q:$$GET1^DIQ(9888888.93,REC_",",.03)="ombdata"  ;TMM V1.8*13
 .S REC=$O(^%ZIB(9888888.93,"B","BAR OMB B",""))
 .D BMES^XPDUTL("Found [BAR OMB B] as a ZISH SEND PARAMETER entry")
 D BMES^XPDUTL("Adding [BAR OMB B] as a ZISH SEND PARAMETER entry")
 K DIC,DIE,DA,DR,DIR
 S DIC="^%ZIB(9888888.93,"
 S DIC(0)="L"
 S X="BAR OMB B"
 D ^DIC
 I +Y<0 D BMES^XPDUTL("UNABLE TO ADD ZISH PARAMETER ENTRY. TRY MANUALLY!!")
 K DIC,DIE,DA,DR,DIR,DD,DO,DINUM
 S DIE="^%ZIB(9888888.93,"
 S DA=+Y
 ;
 ;In-house testing - (pre-beta)       ;TMM V1.8*13
 ;S USERNAME="omb"                    ;TMM V1.8*13
 ;S PASSWORD="ombftp,1"               ;TMM V1.8*13
 ;S SENDCMD="sendto"                  ;TMM V1.8*13
 ;S TYPE="B"                          ;TMM V1.8*13
 ;S TARGETIP="161.223.91.114"         ;TMM V1.8*13
 ;
 ;Current 
 S USERNAME="ombdata"                 ;TMM V1.8*13
 S PASSWORD="f7cjfbyk"                ;TMM V1.8*13
 S SENDCMD="sendto"                   ;TMM V1.8*13
 S TYPE="B"                           ;TMM V1.8*13
 S TARGETIP="161.223.90.8"            ;TMM V1.8*13
 ;
 ;S ARGS="-i -g"                      ;TMM V1.8*13
 S ARGS="-i -g -u"                    ;TMM V1.8*13
 S DR=".02///^S X=TARGETIP"
 S DR=DR_";.03///^S X=USERNAME"
 S DR=DR_";.04////^S X=PASSWORD"
 S DR=DR_";.06///^S X=ARGS"
 S DR=DR_";.07///^S X=TYPE"
 S DR=DR_";.08///^S X=SENDCMD"
 D ^DIE
 K DIC,DIE,DA,DR,DIR
 Q
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
