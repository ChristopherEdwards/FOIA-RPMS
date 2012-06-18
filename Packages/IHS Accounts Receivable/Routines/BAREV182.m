BAREV182 ; IHS/SD/LSL - ENVIRONMENT CHECK V1.8 PATCH 2 NPI;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**1,2**;MAY 22,2007
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
 I $$VCHK("BAR","1.8",2)             ; Accounts Receivable V1.8
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
 D HELP^XBHELP("INTROE","BAREV181")
 ;
 I $G(XPDENV)=1 D
 . ; The following line prevents the "Disable Options..." and "Move
 . ; Routines..." questions from being asked during the install.
 . S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 . D HELP^XBHELP("INTROI","BAREV181")
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
 N BARVNUM,BARPATCH
 ;1 get current version
 S BARVNUM=$$VERSION^XPDUTL(BARNM)
 I '+BARVNUM Q 0
 ;2 is needed patch loaded
 S BARPATCH=$$PATCH^XPDUTL(BARNM_"*"_BARVR_"*"_BARPT)
 I '+BARPATCH Q 0
 Q BARNM_"*"_BARVNUM_"*"_BARPATCH
POST ;EP - POST INSTALL OF ZISH ENTRIES AND QUEING OF BIZTALK TASK
 D STUFFDCM       ;Stuff too long target id into
 D FIXADJ3        ;FIX A/R EDI STND CLAIM ADJ REASONS STANDARD ADJUSTMENT CODE 3
 ;                BAD ENTRY IN FIELD .03 (14;17) IM21683,IM23712
 D AWODT          ;CHANGE THE AWO EXPIRATION DATE
 D ADWO            ;ADD NEW WRITE OFF ENTRY IN BARTBL AT 916 SO IT DOESNOT GET OVERWRITTEN BY
 ;                  NEW ENTRIES IN PATCH 2
 D EDIHIPAA       ;EDIT "HIPAA 835 v4010" ENTRY IN A/R EDI TRANSPORT FILE
 Q
ADWO ; EP
 N ADWO
 S ADWO="^BARTBL(916,0)"
 S @ADWO="AUTO WRITE-OFF 2007^3^WO"
 S DIK="^BARTBL(" D IXALL^DIK
 Q
AWODT ;EP -
 K DIR,DIE,DIC,DA,DR
 S DR="15////^S X=3070529"
 S DUZ2=1
 F  S DUZ2=$O(^BAR(90052.06,DUZ2)) Q:'DUZ2  D
 .S DIE="^BAR(90052.06,"_DUZ2_","
 .S DA=DUZ2
 .D ^DIE
 Q
EDIHIPAA ;EP - EDIT HIPAA TRANSPORT ENTRY
 N TRANIEN
 S TRANIEN=$O(^BAREDI("1T","B","HIPAA 835 v4010",""))
 I 'TRANIEN D  Q
 .W !,$$CJ^XLFSTR("CANNOT FIND HIPAA 835 v4010 ENTRY!!",IOM)
 .W !,$$CJ^XLFSTR("INFORM THE HELP DESK IMMEDIATELY!!",IOM)
 ;BEGIN UPDATING FIELDS
 ;
 ;EDIT SEGMENT 2-080.B-N1
 ;IDENTIFICATION CODE QUALIFIER
 K DIE,DIC,DA,DR,DIR
 S DA(2)=TRANIEN
 S DA(1)=15
 S DA=3
 S DIE="^BAREDI(""1T"","_DA(2)_",10,"_DA(1)_",10,"
 S BARVAL="VICQ"
 S DR=".08///^S X=BARVAL"
 D ^DIE
 ;
 ;IDENTIFICATION CODE
 K DIE,DIC,DA,DR,DIR
 S DA(2)=TRANIEN
 S DA(1)=15
 S DA=4
 S DIE="^BAREDI(""1T"","_DA(2)_",10,"_DA(1)_",10,"
 S BARVAL="VIC"
 S DR=".08///^S X=BARVAL"
 D ^DIE
 ;
 ;REFERENCE ID QUALIFIER
 K DIE,DIC,DA,DR,DIR
 S DA(2)=TRANIEN
 S DA(1)=18
 S DA=1
 S DIE="^BAREDI(""1T"","_DA(2)_",10,"_DA(1)_",10,"
 S BARVAL="VREFBIQ"
 S DR=".08///^S X=BARVAL"
 D ^DIE
 ;
 ;REFERENCE IDENTIFICATION
 K DIE,DIC,DA,DR,DIR
 S DA(2)=TRANIEN
 S DA(1)=18
 S DA=2
 S DIE="^BAREDI(""1T"","_DA(2)_",10,"_DA(1)_",10,"
 S BARVAL="VREFBID"
 S DR=".08///^S X=BARVAL"
 D ^DIE
 ;
 ;VARIABLE PROCESSING
 K DIE,DIC,DA,DR,DIR
 S X="VREFBIQ"
 S DA(1)=TRANIEN
 S DIC(0)="L"
 S DIC="^BAREDI(""1T"","_DA(1)_",70,"
 D ^DIC
 I +Y>0 D
 .K DIE,DIC,DA,DR,DIR
 .S DA=+Y
 .S DA(1)=TRANIEN
 .S DIE="^BAREDI(""1T"","_DA(1)_",70,"
 .S BARVAL="VREFB|BAREDPA1"
 .S DR=".02///^S X=BARVAL"
 .D ^DIE
 ;
 K DIE,DIC,DA,DR,DIR
 S X="VREFBID"
 S DA(1)=TRANIEN
 S DIC(0)="L"
 S DIC="^BAREDI(""1T"","_DA(1)_",70,"
 D ^DIC
 I +Y>0 D
 .K DIE,DIC,DA,DR,DIR
 .S DA=+Y
 .S DA(1)=TRANIEN
 .S DIE="^BAREDI(""1T"","_DA(1)_",70,"
 .S BARVAL="VREFB|BAREDPA1"
 .S DR=".02///^S X=BARVAL"
 .D ^DIE
 ;
 K DIE,DIC,DA,DR,DIR
 S X="VIC"
 S DA(1)=TRANIEN
 S DIC(0)="L"
 S DIC="^BAREDI(""1T"","_DA(1)_",70,"
 D ^DIC
 I +Y>0 D
 .K DIE,DIC,DA,DR,DIR
 .S DA=+Y
 .S DA(1)=TRANIEN
 .S DIE="^BAREDI(""1T"","_DA(1)_",70,"
 .S BARVAL="VIC|BAREDPA1"
 .S DR=".02///^S X=BARVAL"
 .D ^DIE
 Q
PRE ;EP -
 Q
FIXADJ3 ;EP
 Q:$$GET1^DIQ(90056.06,"3,",.03,"I")'="14;17"
 K DIE,DIR,DR,DA,DIC
 S DIE="^BARADJ("
 S DA=3
 S DR=".03///14;.04///27"
 D ^DIE
 Q
STUFFDCM ;
 D BMES^XPDUTL("Updating Debt Collection Target ID in ZISH SEND PARAMETERS file....")
 K DIC,DIE,DA,DR,DIR
 S TARGETID="asdstgw.d1.na.DOMAIN.NAME"
 F X="BAR DCM B","BAR DCM F" D
 .S DIC="^%ZIB(9888888.93,"
 .S DIC(0)=""
 .D ^DIC
 .Q:Y<0
 .S DIE=DIC
 .K DIC,DA,DR,DIR
 .S DA=+Y
 .S DR=".02////"_TARGETID
 .D ^DIE
 Q
 ; ********************************************************************
INTROE ; Intro text during KIDS Environment check.
 ;;This distribution Modifies Accounts Receivable containing previous patch
 ;;modifications and:
 ;;
 ;;###
 ;;
 ;
INTROI ; Intro text during KIDS Install.
 ;;If you run interactively, results will be displayed on your screen,
 ;;and recorded in the entry in the INSTALL file.
 ;;If you queue to TaskMan, remember not to Q to the HOME device.
 ;;###
