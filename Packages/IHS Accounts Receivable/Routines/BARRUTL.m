BARRUTL ; IHS/SD/LSL - Report Utility ; 07/26/2010
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**6,19**;OCT 26, 2005
 ;
 ; IHS/ASDS/LSL - 08/29/00 - Routine created
 ;
 ; IHS/SD/LSL - 04/12/02 - V1.6 Patch 2
 ;     Modified LOOP line tag to allow it to be used for new Age
 ;     Summary Report
 ;
 ; IHS/SD/LSL - 10/03/02 - V1.7 - NDA-0902-180080
 ;      Modified LOOP lne tag to allow reports to sort by date
 ;      correctly.   Reports show ** NO DATA TO PRINT **
 ;
 ; IHS/SD/LSL - 12/06/02 - V1.7 - NHA-0601-180049
 ;      Modified to find bill in 3P correctly.
 ;      
 ; IHS/SD/TMM 1.8*19 7/26/10 Select by Group Plans
 Q
 ; ***************************************************
 ;
LOOP ;EP for Looping thru Bill File
 ; Note:  BARY("OBAL") may not work if other Inclusion Selections made
 ; "OBAL" is OpenBalance bills variable BARY("STCR") is a little tricky IHS/SD/PKD 1/20/11
 I $G(BARY("DT"))]"" D                           ; Sort by Date
 . I BARY("DT")="V" S BARP("X")="E" Q         ; Sort by Visit Date
 . I BARY("DT")="A" S BARP("X")="AG" Q        ; Sort by 3P Approval Date
 . I BARY("DT")="X" S BARP("X")="H" Q         ; Sort by Transmittal Date
 E  I $D(BARY("ACCT")) S BARP("X")="D"        ; Sort by A/R Account
 E  I $D(BARY("PAT")) S BARP("X")="C"         ; Sort by Patient
 E  I $D(BARY("STCR")) S BARP("X")="OBAL"     ; Sort by Open Balance
 E  S BARP("X")=1                             ; Sort by A/R Bill
 I BARP("X") D  Q      ; If no parameters loop entire file
 . S BAR=0
 . F  S BAR=$O(^BARBL(DUZ(2),BAR)) Q:'+BAR  D @("DATA^"_BARP("RTN"))
 I $G(BARY("DT"))]"","AXV"[BARY("DT") D  Q
 . S BARP("DT")=BARY("DT",1)-.5
 . F  S BARP("DT")=$O(^BARBL(DUZ(2),BARP("X"),BARP("DT"))) Q:'BARP("DT")!(BARP("DT")>(BARY("DT",2)+.5))  D
 . . S BAR=""
 . . F  S BAR=$O(^BARBL(DUZ(2),BARP("X"),BARP("DT"),BAR)) Q:'BAR  D @("DATA^"_BARP("RTN"))
 S:$D(BARY("DT")) BARP("DT")=BARY("DT",1)-1
 I $G(BARY("STCR"))]"" D  Q
 . S BAR=0
 . F  S BAR=$O(^BARBL(DUZ(2),BARP("X"),BAR)) Q:'BAR  D @("DATA^"_BARP("RTN"))
 S BAR=""
 S BARP("RI")=$S(BARP("X")="D":BARY("ACCT"),1:BARY("PAT"))
 I $G(BAR("OPT"))="STA" D GRPINS  Q  ; IHS/SD/PKD 1.8*19 move specific code to the end
 F  S BAR=$O(^BARBL(DUZ(2),BARP("X"),BARP("RI"),BAR)) Q:'BAR  D @("DATA^"_BARP("RTN"))
 ;
 Q
 ; *********************************************************************
 ;
TRANS ;EP for Looping thru Transaction File
 S BARP("X")=$S($G(BARY("DT"))="T":"B",1:1)
 ;S:$D(BARY("BATCH")) BARP("X")="ACB"
 S:$D(BARY("BATCH"))&($G(BARY("DT"))'="T") BARP("X")="ACB"  ;BAR*1.8*6 IHS/SD/TPF 8/12/2008
 I BARP("X") D  Q      ; If no parameters loop entire file
 . S BARTR=0
 . F  S BARTR=$O(^BARTR(DUZ(2),BARTR)) Q:'+BARTR  D @("DATA^"_BARP("RTN"))
 I $G(BARY("DT"))="T" D  Q
 . S BARP("DT")=BARY("DT",1)-.5
 . F  S BARP("DT")=$O(^BARTR(DUZ(2),BARP("X"),BARP("DT"))) Q:'BARP("DT")!(BARP("DT")>(BARY("DT",2)+.5))  D
 . . S BARTR=0
 . . F  S BARTR=$O(^BARTR(DUZ(2),BARP("X"),BARP("DT"),BARTR)) Q:'BARTR  D @("DATA^"_BARP("RTN"))
 I $D(BARY("ITEM")) D  Q
 . S BART=""
 . F  S BART=$O(^BARTR(DUZ(2),BARP("X"),BARY("BATCH"),BARY("ITEM"),BART)) Q:'BART  D
 . . S BARTR=0
 . . F  S BARTR=$O(^BARTR(DUZ(2),BARP("X"),BARY("BATCH"),BARY("ITEM"),BART,BARTR)) Q:'+BARTR  D @("DATA^"_BARP("RTN"))
 E  D  Q
 . S BARI=""
 . F  S BARI=$O(^BARTR(DUZ(2),BARP("X"),BARY("BATCH"),BARI)) Q:'BARI  D
 . . S BART=""
 . . F  S BART=$O(^BARTR(DUZ(2),BARP("X"),BARY("BATCH"),BARI,BART)) Q:'BART  D
 . . . S BARTR=0
 . . . F  S BARTR=$O(^BARTR(DUZ(2),BARP("X"),BARY("BATCH"),BARI,BART,BARTR)) Q:'+BARTR  D @("DATA^"_BARP("RTN"))
 S BARP("RI")=$S(BARP("X")="C":BARY("ACCT"),1:BARY("PAT"))
 S:$D(BARY("DT")) BARP("DT")=BARY("DT",1)-1
 Q
 ; *********************************************************************
 ;
PSR ; EP - Loop A/R Period Summary Report Data File
 S BAR("L")=0
 F  S BAR("L")=$O(^BARPSR(BAR("L"))) Q:'+BAR("L")  D
 . I $D(BARY("LOC")),BARY("LOC")'=BAR("L") Q   ; Not chosen visit loc
 . S BARPSR=BARBDT-1
 . F  S BARPSR=$O(^BARPSR(BAR("L"),1,BARPSR)) Q:'+BARPSR  D
 . . Q:BARPSR>BAREDT
 . . D @("DATA^"_BARP("RTN")_1)
 Q
 ; *********************************************************************
 ;
PAZ ;EP to pause report
 I '$D(IO("Q")),$E(IOST)="C",'$D(IO("S")) D
 .F  W ! Q:$Y+3>IOSL
 .K DIR
 .S DIR(0)="E"
 .D ^DIR
 .K DIR
 Q
 ; *********************************************************************
 ;
POUT ;EP for exiting report
 K:$D(BAR("SUBR")) ^TMP(BAR("SUBR"),$J)
 D KILL^%ZTLOAD
 K BARY,BARP,BAR,IO("Q"),POP,DIR,DUOUT,DTOUT,ZTSK,DIROUT,DIRUT,%ZIS
 Q
 ; *********************************************************************
 ;
MM ;EP
 ; Correct A/R Account and Bill Amount for bills on Mismatch Report
 S DA=0
 F  S DA=$O(^BARBLER(DUZ(2),"AMM",1,DA)) Q:'+DA  D MM2
 K DIE,DA,DR,DIQ,DIC,ABMAMT,ABMINS,ABMINSN,BAR,BAR3PDUZ
 Q
 ; *********************************************************************
 ;
MM2 ;
 ; Check each entry in A/R bill error for Mismatch
 K DIE,DR,DIC,DIQ,ABMAMT,ABMINS,ABMINSN,BAR,BAR3PDUZ,BAR3PIEN
 S DIC="^BARBL(DUZ(2),"
 S DIQ="BAR("
 S DIQ(0)="IE"
 S DR="3;13;17;22;108"
 D EN^DIQ1
 S BAR("3P LOC")=$$FIND3PB^BARUTL(DUZ(2),DA)
 S BAR3PDUZ=$P(BAR("3P LOC"),",")
 S BAR3PIEN=$P(BAR("3P LOC"),",",2)
 Q:'$G(BAR3PDUZ)
 S BAR3PINS=$P($G(^ABMDBILL(BAR3PDUZ,BAR3PIEN,0)),U,8)
 Q:BAR3PINS=""
 S BAR3PINN=$P($G(^AUTNINS(BAR3PINS,0)),U)
 I BAR3PINN'=$G(BAR(90050.01,DA,3,"E")) D
 . S DR="3///^S X=BAR3PINN"
 . I $P($G(^ABMDBILL(BAR3PDUZ,BAR3PIEN,13,BAR3PINS,0)),U,2)=1 S DR=DR_";205///^S X=BAR3PINN"
 S BAR3PAMT=$P($G(^ABMDBILL(BAR3PDUZ,BAR3PIEN,2)),U)
 I ((BAR3PAMT+.005)\.01/100)'=((BAR(90050.01,DA,13,"I")+.005)\.01/100) S DR=DR_";13///^S X=BAR3PAMT"
 Q:'$D(DR)
 S:$E(DR)=";" DR=$E(DR,2,99)
 S DIE="^BARBL(DUZ(2),"
 D ^DIE
 K DR,DIE,BAR,BAR3PDUZ,BAR3PIEN
 Q
 ;
GRPINS  ;  IHS/SD/TMM 1.8*19 7/20/10
 ; If Group Plan entered, filter 
 F  S BAR=$O(^BARBL(DUZ(2),BARP("X"),BARP("RI"),BAR)) Q:'BAR  D
 . ;If user did not specify a group, report all groups
 . I $G(BAR("OPT"))="STA",'$D(BARY("GRP PLAN")) D @("DATA^"_BARP("RTN")) Q   ;1.8*19 8/16/10
 . ;Verify if group was specified
 . S BARGRPBL=$$GROUPLAN^BARUTL(BAR)   ;Valid grp plan returns: 1^BARGPIEN^BARGPNUM^BARGPNAM...   
 . I $P(BARGRPBL,U)=0!$P(BARGRPBL,U)="" Q     ;Group Plan not found in Employer Group Insurance     
 . S BARGPNUM=$P($P(BARGRPBL,U,2),"|",2)
 . S BARGPIEN=$P($P(BARGRPBL,U,2),"|",1)
 . S BARGPNAM=$P($P(BARGRPBL,U,2),"|",3)
 . I BARGPIEN="" Q
 . I '$D(BARY("GRP PLAN",BARGPIEN)) Q         ;Group Plan for this bill not requested
 . D @("DATA^"_BARP("RTN"))
 ; ;End 1.8*19
