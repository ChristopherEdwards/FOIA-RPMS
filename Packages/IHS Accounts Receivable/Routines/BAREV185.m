BAREV185 ; IHS/SD/LSL - ENVIRONMENT CHECK V1.8 PATCH 5; 05/08/2008
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**1,2,3,4,5**;APR 27,2007
 ;
 I '$G(DUZ) D  Q
 . W !,"DUZ UNDEFINED OR 0."
 . D SORRY(2)
 ;
 I '$L($G(DUZ(0))) D  Q
 . W !,"DUZ(0) UNDEFINED OR NULL."
 . D SORRY(2)
 ;
 ;BAR*1.8*4 -- ONLY
 ;ALL SESSIONS MUST BE TRANSPORTED BEFORE INSTALL OF PATCH 4
 I $P($$INSTALLD("BAR","1.8",4),"*",3)'=1 D
 .S BAROK=1
 .D ADDDIS          ;ADD DEFAULT (#1504) UFMS DISPLAY DATE LIMIT
 .D TASK(DUZ(2),.BAROK)
 .I 'BAROK D  Q
 .. W !!,*7,*7
 .. W $$CJ^XLFSTR("There are sessions that have not been transmitted",IOM)
 .. W !,$$CJ^XLFSTR("Please give the A/R cashiers the above list",IOM)
 .. W !,$$CJ^XLFSTR("Cannot proceed until all sessions are transmitted",IOM)
 .. D SORRY(2)
 ;
 S X=$P(^VA(200,DUZ,0),U)            ; User's name
 W !!,$$CJ^XLFSTR("Hello, "_$P(X,",",2)_" "_$P(X,","),IOM)
 W !!,$$CJ^XLFSTR("Checking Environment for "_$P($T(+2),";",4)_" V "_$P($T(+2),";",3),IOM)
 ;
 N BARXU
 S BARXU=$$INSTALLD("XU","8.0",1011)     ;RLT     ; Find current Kernel version and patch
 I $P(BARXU,"*",2)<8 S BARXU=0
 I $P(BARXU,"*",3)'=1 S BARXU=0        ;RLT
 W !,$$CJ^XLFSTR("Need at least XU v8.0 Patch 1011..... "_$S(BARXU=0:"NOT ",1:"")_"Present",IOM)
 I BARXU=0 D SORRY(2)
 ;
 I $$VCHK("DI","21.0",2)             ; FileMan V21.0
 ;
 N BARXB
 S BARXB=$$INSTALLD("XB","3.0",11)       ;RLT    ; Find current IHS utilities version and patch
 I $P(BARXB,"*",2)<3 S BARXB=0
 I $P(BARXU,"*",3)'=1 S BARXU=0        ;RLT
 W !,$$CJ^XLFSTR("Need at least XB v3.0 Patch 11..... "_$S(BARXB=0:"NOT ",1:"")_"Present",IOM)
 I BARXB=0 D SORRY(2)
 ;
 I $$VCHK("BAR","1.8",2)             ; Accounts Receivable V1.8
 ;
 N BARABM
 S BARABM=$$INSTALLD("ABM","2.5",13)
 I $P(BARABM,"*",2)<2.5 S BARABM=0
 I $P(BARABM,"*",3)'=1 S BARABM=0
 W !,$$CJ^XLFSTR("Need at least Third Party Billing v2.5 Patch 13..... "_$S(BARABM=0:"NOT ",1:"")_"Present",IOM)
 I BARABM=0 D SORRY(2)
 ;
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
 ;LETS DOUBLE CHECK - MAKE SURE THEY SAVE THE GLOBALS OFF
 ;DONE IF UPDATING A/R TABLES
 ;I '$G(XPDQUIT) D
 ;.W !!!,$$CJ^XLFSTR("IMPORTANT: PLEASE MAKE SURE YOU SAVE THE FOLLOWING GLOBALS TO DISK?",IOM)
 ;.W !,$$CJ^XLFSTR("USE ^%GOGEN TO SAVE ^BAR(90052.01",IOM)
 ;.W !,$$CJ^XLFSTR("USE ^%GO TO SAVE ^BARTBL",IOM)
 ;
 I $G(XPDQUIT) W !,$$CJ^XLFSTR("FIX IT! Before Proceeding.",IOM),!!,*7,*7,*7 Q
 ;
 W !!,$$CJ^XLFSTR("ENVIRONMENT OK.",IOM)
 D HELP^XBHELP("INTROE","BAREV184")
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
 ;
POST ;EP - POST INSTALL OF ZISH ENTRIES AND QUEING OF BIZTALK TASK
 D STUFFDCM       ;Stuff too long target id into
 D FIXADJ3        ;FIX A/R EDI STND CLAIM ADJ REASONS STANDARD ADJUSTMENT CODE 3
 ;                BAD ENTRY IN FIELD .03 (14;17) IM21683,IM23712
 D AWODT          ;CHANGE THE AWO EXPIRATION DATE
 D ADWO            ;ADD NEW WRITE OFF ENTRY IN BARTBL AT 916 SO IT DOESNOT GET OVERWRITTEN BY
 ;                  NEW ENTRIES IN PATCH 2
 D EDIHIPAA       ;EDIT "HIPAA 835 v4010" ENTRY IN A/R EDI TRANSPORT FILE
 ;
 ;set default value for field #22 in A/R COLLECTION POINT file
 D COLPOINT
 ;
 D ADDZISH         ;ADD ZISH SEND PARAMETER ENTRIES FOR UFMS
 Q
TASK(SAFEDUZ2,BAROK) ;EP - FOR PATCH 4 ONLY
 ;
 K ^BARBOB("BARZ")
CKSESS ;
 ; Session status can be:   O    OPEN
 ;                          RC   RECONCILED
 ;                          RV   REVIEWED/APPROVED
 ;                          T    TRANSMITTED
 ;                          RT   RETRANSMITTED
 K BAR
 N BARLOC,BARST,BARUDUZ,BAR
 S DUZ(2)=0
 F  S DUZ(2)=$O(^BARSESS(DUZ(2))) Q:'DUZ(2)  D
 .K ^BARSESS(DUZ(2),"NS")              ;CLEAN OUT NOT SENT BUCKET
 .Q:'$$IHS^BARUFUT(DUZ(2))
 .S BARLOC=$P(^AUTTLOC(DUZ(2),0),U,2)
 .S BARST=0
 .F  S BARST=$O(^BARSESS(DUZ(2),"C",BARST)) Q:BARST=""  D
 ..Q:BARST["TRANSMIT"            ;DON'T WANT (RE)TRANSMITTED
 ..S BARUDUZ=0
 ..F  S BARUDUZ=$O(^BARSESS(DUZ(2),"C",BARST,BARUDUZ)) Q:'BARUDUZ  D
 ...D LOOP(BARUDUZ,BARST)
 I '$D(BAR) Q
 D WRT
 S BAROK=0
 S DUZ(2)=SAFEDUZ2
 Q
LOOP(UDUZ,STAT) ; - GET DATA FROM SESSION LEVEL
 N SESSID,ERASTAT,CURSTAT,STATDATE,POSTING
 S CASHIER=$E($P($G(^VA(200,UDUZ,0)),U),1,17)
 S SESSID=0
 F  S SESSID=$O(^BARSESS(DUZ(2),"C",STAT,UDUZ,SESSID)) Q:SESSID=""  D
 .S IENS=SESSID_","_UDUZ_","
 .S SESSDT=$$GET1^DIQ(90057.11,IENS,.01,"I")
 .I SESSDT<3071001 Q              ;IGNORE PRE-UFMS SESSIONS
 .S CURSTAT=$$GET1^DIQ(90057.11,IENS,.02,"E")
 .S STATDATE=$$GET1^DIQ(90057.11,IENS,.03,"E")
 .S ERASTAT=$E($$GET1^DIQ(90057.11,IENS,.04,"E"))
 .S POSTING=$$STILPOST^BARUFUT1(UDUZ)
 .S Y=STATDATE X ^DD("DD") S STATDATE=Y
 .S BAR(CASHIER,BARLOC,STAT,SESSID)=""
 Q
WRT ;
 W !!?25,"OPEN SESSIONS LIST FOR: "
 W !,"CASHIER",?22,"LOCATION",?45,"STATUS",?65,"SESSION ID",!
 N A,B,C,D
 S A=""
 F  S A=$O(BAR(A)) Q:A=""  D              ;CASHIER
 .S B=0
 .F  S B=$O(BAR(A,B)) Q:B=""  D           ;DUZ(2)
 ..S C=0
 ..F  S C=$O(BAR(A,B,C)) Q:C=""  D        ;STATUS
 ...S D=0
 ...W A,?19,$E(B,1,20),?40,$E(C,1,20)
 ...F  S D=$O(BAR(A,B,C,D)) Q:'D  D       ;SESSION ID
 ....W ?62,D,!
 Q
ADDDIS ;EP - 
 K DIE,DR,DIC,DIE,DIR,DA
 ;S DR="1504////^S X=""T-1W"";1505////30"""
 S X1=3071001
 S X2=DT
 D ^%DTC
 S BARDT=X
 S DUZ2=1
 F  S DUZ2=$O(^BAR(90052.06,DUZ2)) Q:'DUZ2  D
 .S DA(1)=DUZ2
 .S DA=0
 .F  S DA=$O(^BAR(90052.06,DUZ2,DA)) Q:'DA  D
 ..S DR="1504////T"_BARDT
 ..S DR=DR_";1505////30"""  ;IHS/SD/TPF BAR*1.8*4 IM26189
 ..I '$$IHS^BARUFUT(DA) S DR=DR_";1502////1;1503////1"  ;FOR NON-IHS SITES
 ..S DIE="^BAR(90052.06,"_DA(1)_","
 ..D ^DIE
 Q
COLPOINT ;EP -
 K DIE,DR,DIC,DIE,DIR,DA
 S DR="22////^S X=1"
 S DUZ2=1
 N BART                                          ;BAR*1.8*4
 F  S DUZ2=$O(^BAR(90051.02,DUZ2)) Q:'DUZ2  D
 .S DA(1)=DUZ2
 .S DA=0
 .F  S DA=$O(^BAR(90051.02,DUZ2,DA)) Q:'DA  D
 ..S BART=$P($G(^BAR(90051.02,DUZ2,DA,0)),U,22)  ;BAR*1.8*4
 ..Q:BART'=""                  ;DON'T OVERWRITE  ;BAR*1.8*4
 ..S DIE="^BAR(90051.02,"_DA(1)_","
 ..D ^DIE
 Q
ADWO ; EP
 N ADWO
 S ADWO="^BARTBL(916,0)"
 S @ADWO="AUTO WRITE-OFF 2007^3^WO"
 S DIK="^BARTBL(" D IXALL^DIK
 Q
AWODT ;EP -
 K DIR,DIE,DIC,DA,DR
 S DR="15////^S X=3070525"
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
 ;
PRE ;EP - PRE INSTALL - DELETE OLD DATA IN TABLES
 Q  ;PER ADRIAN DO NOT UPDATE TABLES UNTIL HE STRAIGHTENS IT OUT. APPEARS OUR TABLES ARE NOT UPDATED??
 ;I AM NOT SURE WE KNOW WHAT ENTRIES THEY SHOULD HAVE.
 ;W !,"DELETING OLD TABLE DATA.."
 ;S IEN=0 F  S IEN=$O(^BARTBL(IEN)) Q:IEN=""!(IEN>999)  W "." K ^BARTBL(IEN)
 Q
FIXADJ3 ;EP
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
ADDZISH ;EP - ADD ZISH ENTIRES TO 'ZISH SEND PARAMETERS' FILE
 ;ADD 'BAR UFMS B' BACKGROUND ENTRY
 ;ADD 'BAR UFMS F' FOREGROUND ENTRY
ADDF ;ADD FOREGROUND
 ;I $D(^%ZIB(9888888.93,"B","BAR UFMS F")) D
 ;IF ENTRY IS SET TO umftest THIS IS TEST SYSTEM - DO NOT UPDATE
 I $D(^%ZIB(9888888.93,"B","BAR UFMS F")) D  Q:$$GET1^DIQ(9888888.93,REC_",",.03)="ufmstest"  ;BAR*1.8*4
 .S REC=$O(^%ZIB(9888888.93,"B","BAR UFMS F",""))
 .D BMES^XPDUTL("Found [BAR UFMS F] as a ZISH SEND PARAMETER entry")
 D BMES^XPDUTL("Adding [BAR UFMS F] as a ZISH SEND PARAMETER entry")
 K DIC,DIE,DA,DR,DIR
 S DIC="^%ZIB(9888888.93,"
 S DIC(0)="L"
 S X="BAR UFMS F"
 D ^DIC
 I +Y<0 W !,"UNABLE TO ADD ZISH PARAMETER ENTRY. TRY MANUALLY!!" Q
 K DIC,DIE,DA,DR,DIR,DD,DO,DINUM
 S DIE="^%ZIB(9888888.93,"
 S DA=+Y
 S USERNAME="ufmsuser"
 S PASSWORD="vjrsshn9"
 S SENDCMD="sendto"
 S TYPE="F"
 ;S TARGETIP="quovadx-ie.DOMAIN.NAME"
 S TARGETIP="quovadx-ie"  ;BAR*1.8*4
 S ARGS="-i -u -a"
 S DR=".02///^S X=TARGETIP"
 S DR=DR_";.03///^S X=USERNAME"
 S DR=DR_";.04////^S X=PASSWORD"
 S DR=DR_";.06///^S X=ARGS"
 S DR=DR_";.07///^S X=TYPE"
 S DR=DR_";.08///^S X=SENDCMD"
 D ^DIE
 K DIC,DIE,DA,DR,DIR
ADDB ;ADD BACKGROUND
 ;I $D(^%ZIB(9888888.93,"B","BAR UFMS B")) D
 I $D(^%ZIB(9888888.93,"B","BAR UFMS B")) D  Q:$$GET1^DIQ(9888888.93,REC_",",.03)="ufmstest"  ;BAR*1.8*4
 .S REC=$O(^%ZIB(9888888.93,"B","BAR UFMS B",""))  ;BAR*1.8*4
 .D BMES^XPDUTL("Found [BAR UFMS B] as a ZISH SEND PARAMETER entry")
 D BMES^XPDUTL("Adding [BAR UFMS B] as a ZISH SEND PARAMETER entry")
 K DIC,DIE,DA,DR,DIR
 S DIC="^%ZIB(9888888.93,"
 S DIC(0)="L"
 S X="BAR UFMS B"
 D ^DIC
 I +Y<0 D BMES^XPDUTL("UNABLE TO ADD ZISH PARAMETER ENTRY. TRY MANUALLY!!")
 K DIC,DIE,DA,DR,DIR,DD,DO,DINUM
 S DIE="^%ZIB(9888888.93,"
 S DA=+Y
 S USERNAME="ufmsuser"
 S PASSWORD="vjrsshn9"
 S SENDCMD="sendto"
 S TYPE="B"
 ;S TARGETIP="quovadx-ie.DOMAIN.NAME"
 S TARGETIP="quovadx-ie"  ;BAR*1.8*4
 S ARGS="-i -u -a"
 S DR=".02///^S X=TARGETIP"
 S DR=DR_";.03///^S X=USERNAME"
 S DR=DR_";.04////^S X=PASSWORD"
 S DR=DR_";.06///^S X=ARGS"
 S DR=DR_";.07///^S X=TYPE"
 S DR=DR_";.08///^S X=SENDCMD"
 D ^DIE
 K DIC,DIE,DA,DR,DIR
 Q
 ; ********************************************************************
INTROE ; Intro text during KIDS Environment check.
 ;;This distribution Modifies Accounts Receivable containing previous patch
 ;;modifications for version 1.8. This patch is cumulative.
 ;;
 ;;###
 ;;
 ;
INTROI ; Intro text during KIDS Install.
 ;;If you run interactively, results will be displayed on your screen,
 ;;and recorded in the entry in the INSTALL file.
 ;;If you queue to TaskMan, remember not to Q to the HOME device.
 ;;###
