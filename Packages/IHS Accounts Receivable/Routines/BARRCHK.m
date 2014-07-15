BARRCHK ; IHS/SD/LSL - Report Utility to Check Parms ;07/23/2010
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**4,6,7,10,19,23,23*;OCT 26, 2005
 ; MODIFIED XTMP($J,"ZTSRREJ-" ERROR WITH XTMP($J,"BAR-"_;MRS:BAR*1.8*6 IM29892
 ; MODIFIED XTMP FILE NAME TO TMP TO MEET SAC REQUIREMENTS;MRS:BAR*1.8*7 IM29892
 ; 
 ; TMM 07/23/2010 V1.8*19
 ;      Add (Employer) Group Plan filter for A/R Statistical
 ;       report. requirement 4PMS10022. ;                     
 ;MAR 2013 P.OTTIS ADDED NEW VA billing     
 ;JUL 2013 P.OTTIS ADDED SUPPORT FOR ICD-10
 ;SEP 2013 P.OTTIS BUG FIX NOT SETING DX("P") CORRECTLY
 ;SEP 2013 P.OTTIS FIXED <UNDEFINED>BILL+30^BARRCHK *BAR("DX",1) IF NO DX
 ; ***********************************************************************
 Q
 ;
BILL ;EP
 ; for checking Bill File data parameters
 S BARDEBUG=0
 S BARP("HIT")=0
 S:$G(BAR("SUBR"))="" BAR("SUBR")=$S($G(BAR("RTN"))'="":BAR("RTN"),1:"UNKNOWN CALL")
 I '$D(^BARBL(DUZ(2),BAR)) D  Q     ; No data
 . I $G(BARDEBUG) S ^TMP($J,"BAR-"_BAR("SUBR"),"REASON REJECTED","NO DATA AT THIS IEN",BAR)="" D DBGMSG ;MRS:BAR*1.8*6 IM29892
 S BAR(0)=$G(^BARBL(DUZ(2),BAR,0))  ; A/R Bill 0 node
 S BAR(1)=$G(^BARBL(DUZ(2),BAR,1))  ; A/R Bill 1 node
 S BAR("V")=$P(BAR(1),U,14)         ; Visit type (3P Visit Type)
 S BAR("L")=$P(BAR(1),U,8)          ; Visit location (A/R Parent/Sat)
 S BAR("I")=$P(BAR(0),U,3)          ; A/R Account
 S BAR("P")=$P(BAR(1),U,1)          ; Patient (Patient file)
 S BAR("D")=$P(BAR(1),U,2)          ; DOS Begin
 S BAR("A")=$P(BAR(0),U,18)         ; 3P Approval date
 S BAR("PD")=$P(BAR(0),U,19)        ; 3P Print Date
 S BAR("PV")=$P(BAR(1),U,13)        ; Provider (New Person)
 S BAR("C")=$P(BAR(1),U,12)         ; Clinic  (Clinic Stop File)
 S BAR("DS")=$$GET1^DIQ(90050.01,BAR,23)   ; Discharge Service (#)
 ;
 ;TAKE PRIMARY DX FROM BILL FILE. IF ALL DXs WANTED, HAVE TO LOOK INTO 3PB BILL FILE
 ;
 ;BUG FIX SETTING BAR("DX") CORRECTLY
 I $G(BARY("DXTYPE"))="P" D
 . K BAR("DX")
 . S BAR("DX",1)=$$GET1^DIQ(90050.01,BAR,24)   ; Primary Diagnosis (Code)
 . S BAR("DX")=$G(BAR("DX",1))
 I $G(BARY("DXTYPE"))="A"!($G(BARY("DXTYPE"))="O") D
 . K BAR("DX")
 . D GETDX^BARRSLDX(BAR)  ;OTHER OR ALL INTO BAR("DX",nnn) 
 . S BAR("DX")=$G(BAR("DX",1))
 ;
 S BAR("GRP")=$P($P($$GROUPLAN^BARUTL(BAR),U,2),"|",1)  ; Group Plan  ;IHS/SD/TMM ADD 7/23/10
 I $G(BAR("DX",1))="" S BAR("DX",1)="No DX"
 ;
 ;default: OPTION#1 S BAR("I") A/R Account taken from ^BARBL
 ;
 ;OPTION #2 S BAR("I")=$P(^BARTR(DUZ(2),TRIEN,0),U,6) ;A/R Account taken from ^BARTR 7/31
 ;
 S BARTMP=BAR("I")	
 S BAR("BI")=$$GETBI(BARTMP) ; Insurer Type / BILLING ENTITY CODE
 I $G(BAR("BI"))="" S BAR("BI")="No Billing Entity"
 I BAR("BI")'="No Billing Entity" D
 . S BAR("ALL")="O"                             ; Other Allow Cat
 . I ",N,I,W,C,T,G,SEP,TSI,"[(","_BAR("BI")_",") S BAR("ALL")="O" Q  ;
 . I ",R,MC,MD,MH,MMC,"[(","_BAR("BI")_",") S BAR("ALL")="R" Q  ; 
 . I ",D,FPL,K,"[(","_BAR("BI")_",") S BAR("ALL")="D" Q  ; 
 . I ",F,M,H,P,"[(","_BAR("BI")_",") S BAR("ALL")="P" Q  ;
 . I ",V,"[(","_BAR("BI")_",") S BAR("ALL")="V" Q        ;VETERANS P.OTT
 I $G(BAR("ALL"))=""  S BAR("ALL")="No Allowance Category"
 I BAR("L")=""!(BAR("I")="")!(BAR("P")="")!(BAR("D")="") D  Q
 . I $G(BARDEBUG) S ^TMP($J,"BAR-"_BAR("SUBR"),"REASON REJECTED","NULL LOCATION^INS TYPE^PATIENT^DOS BEGIN",BAR)=BAR("L")_U_BAR("I")_U_BAR("P")_U_BAR("D") D DBGMSG
 ;
 I $G(BARY("SORT"))="V",BAR("V")="" S BAR("V")=99999
 I $G(BARY("SORT"))="C",BAR("C")="" S BAR("C")=99999
 I '$D(^BARAC(DUZ(2),BAR("I"),0)) D  Q               ; No A/R account data
 . I $G(BARDEBUG) S ^TMP($J,"BAR-"_BAR("SUBR"),"REASON REJECTED","NO AR ACCT DATA",BAR)="" D DBGMSG
 ;BAR*1.8*6  DD 4.1.1 FOR THE FOLLOWING LINES ADDED A SET TO THE REJECTION GLOBAL
 I $D(BARY("LOC")),BARY("LOC")'=BAR("L") D  Q      ; Not chosen location
 . I $G(BARDEBUG) S ^TMP($J,"BAR-"_BAR("SUBR"),"REASON REJECTED","NOT CHOSEN LOCATION",BAR)="" D DBGMSG
ARACCT  ;
 I $D(BARY("ARACCT")),'$D(BARY("ARACCT",BAR("I"))) D  Q  ; Not chosn AR ac
 . I $G(BARDEBUG) S ^TMP($J,"BAR-"_BAR("SUBR"),"REASON REJECTED","NOT CHOSEN (ARACCT) AR ACCT",BAR)="" D DBGMSG
 I $D(BARY("PAT")),BARY("PAT")'=BAR("P") D  Q      ; Not chosen patient
 . I $G(BARDEBUG) S ^TMP($J,"BAR-"_BAR("SUBR"),"REASON REJECTED","NOT CHOSEN PATIENT",BAR)="" D DBGMSG
 I $D(BARY("PRV")),BARY("PRV")'=BAR("PV") D  Q     ; Not chosen provider
 . I $G(BARDEBUG) S ^TMP($J,"BAR-"_BAR("SUBR"),"REASON REJECTED","NOT CHOSEN PROVIDER",BAR)="" D DBGMSG
ARACCT1  ;
 I $D(BARY("ACCT")),BARY("ACCT")'=BAR("I") D  Q    ; Not chosen A/R acct
 . I $G(BARDEBUG) S ^TMP($J,"BAR-"_BAR("SUBR"),"REASON REJECTED","NOT CHOSEN (ACCT) AR ACCT",BAR)="" D DBGMSG
 ; ---BEGIN 1.8*19 IHS/SD/TMM 7/25/10
 I $D(BARY("GRP PLAN")),$P(BAR("GRP"),U)=0 D  Q   ;Group Plan not found
 . S BARTMP="NO GROUP PLAN FOR THIS BILL"
 . I $G(BARDEBUG) S ^TMP($J,"BAR-"_BAR("SUBR"),"REASON REJECTED",BARTMP,BAR)="" D DBGMSG
 I $D(BARY("GRP PLAN")),'$D(BARY("GRP PLAN",BAR("GRP"))) D  Q  ; Not chosn Group Plan
 . I $G(BARDEBUG) S ^TMP($J,"BAR-"_BAR("SUBR"),"REASON REJECTED","NOT CHOSEN (GRP PLAN-"_BAR("""GRP""")_") AR ACCT",BAR)="" D DBGMSG
 ; -----END 1.8*19
 I $D(BARY("DSCH")),BAR("DS")="" S BAR("DS")=99999
 I $D(BARY("DSCH")),'$D(BARY("DSCH",BAR("DS"))) D  Q  ;Not chosn disch svc
 . I $G(BARDEBUG) S ^TMP($J,"BAR-"_BAR("SUBR"),"REASON REJECTED","NOT CHOSEN (DSCH) DISCH SVC",BAR)="" D DBGMSG
 I $D(BARY("DSVC")),BARY("DSVC")'=BAR("DS") D  Q      ;Not chosn disch svc
 .I $G(BARDEBUG) S ^TMP($J,"BAR-"_BAR("SUBR"),"REASON REJECTED","NOT CHOSEN (DSVC) DISCH SVC",BAR)="" D DBGMSG
 ;
 I $D(BARY("DX9"))!$D(BARY("DX10")) D DX Q:'BAR("DX","HIT")       ; Check DX P.OTT
 I $D(BARY("TYP")),(U_BARY("TYP")_U)'[(U_BAR("BI")_U) D  Q     ; Not chosen Bill entity 
 . I $G(BARDEBUG) S ^TMP($J,"BAR-"_BAR("SUBR"),"REASON REJECTED","NOT CHOSEN ABILL ENTITY",BAR)="" D DBGMSG
 I $D(BARY("ITYP")),BARY("ITYP")'=BAR("BI") D  Q   ; Not chosen Ins Type
 . I $G(BARDEBUG) S ^TMP($J,"BAR-"_BAR("SUBR"),"REASON REJECTED","NOT CHOSEN INS TYPE",BAR)="" D DBGMSG
 I $D(BARY("ALL")),(+BARY("ALL")=BARY("ALL")) S BARY("ALL")=$$CONVERT^BARRSL2(BARY("ALL"))  ;
 I $D(BARY("ALL")),BARY("ALL")'=BAR("ALL") D  Q     ; Not chosen Allow Cat
 . I $G(BARDEBUG) S ^TMP($J,"BAR-"_BAR("SUBR"),"REASON REJECTED","NOT CHOSEN ALLOW CAT",BAR)=$G(BARY("ALL"))_"/ "_$G(BAR("ALL")) D DBGMSG
 I $D(BARY("CLIN")),'$D(BARY("CLIN",BAR("C"))) D  Q  ; Not chosen clinic
 . I $G(BARDEBUG) S ^TMP($J,"BAR-"_BAR("SUBR"),"REASON REJECTED","NOT CHOSEN CLINIC",BAR)="" D DBGMSG
 I $D(BARY("VTYP")),'$D(BARY("VTYP",BAR("V"))) D  Q  ; Not chosen visit typ
 . I $G(BARDEBUG) S ^TMP($J,"BAR-"_BAR("SUBR"),"REASON REJECTED","NOT CHOSEN VISIT TYPE",BAR)="" D DBGMSG
 K BAR("QUIT")
 I $G(BARY("DT"))="V" D  Q:$G(BAR("QUIT"))      ; Not chosen visit date
 . S:BAR("D")<BARY("DT",1) BAR("QUIT")=1
 . S:BAR("D")>BARY("DT",2) BAR("QUIT")=1
 . I $G(BAR("QUIT")) I $G(BARDEBUG) S ^TMP($J,"BAR-"_BAR("SUBR"),"REASON REJECTED","NOT CHOSEN VISIT DATE",BAR)="" D DBGMSG
 I $G(BARY("DT"))="A" D  Q:$G(BAR("QUIT"))      ; Not chosen approval dt
 . S:BAR("A")<BARY("DT",1) BAR("QUIT")=1
 . S:$P(BAR("A"),".")>BARY("DT",2) BAR("QUIT")=1
 . I $G(BAR("QUIT")) I $G(BARDEBUG) S ^TMP($J,"BAR-"_BAR("SUBR"),"REASON REJECTED","NOT CHOSEN APPROVAL DATE",BAR)="" D DBGMSG
 I $G(BARY("DT"))="X" D  Q:$G(BAR("QUIT"))      ; Not chosen export date
 . S:BAR("PD")<BARY("DT",1) BAR("QUIT")=1
 . S:$P(BAR("PD"),".")>BARY("DT",2) BAR("QUIT")=1
 . I $G(BAR("QUIT")) I $G(BARDEBUG) S ^TMP($J,"BAR-"_BAR("SUBR"),"REASON REJECTED","NOT CHOSEN EXPORT DATE",BAR)="" D DBGMSG
 S BARP("HIT")=1
 I $G(BARDEBUG) W "  HIT=1"
 Q
DBGMSG ;
 I '$G(BARDEBUG) Q
 W "  HIT=0"
 Q
 ;
TRANS ;EP
 D TRANS^BARRCHK1  ;BAR*1.8*6 SQA ROUTINE SIZE LIMIT
 Q
 ;
DX ;P.OTT
 S BAR("DX","HIT")=0
 N I,BARDX
 ;W !,"------NEXT PAT. MAX DX=",$O(BAR("DX","HIT"),-1)
 ;FOR EACH PAT DX RUN MATCHING PROCESS
 S I="" F  S I=$O(BAR("DX",I)) Q:'I  S BARDX=BAR("DX",I) D DX2(BARDX) Q:BAR("DX","HIT")
 Q
DX2(BARDX) ;
 S BARDBG=0 ;I DUZ=838 S BARDBG=1 ;P.OTT
 I $G(BARDBG) W !,"CHECKING IF DX ",BARDX," MATCHES CRITERIA FOR SELECTED DXs"
 ;RLT - Fixed quits and changed DX selection
 ;      from numeric operators (<>) to string
 ;      operators (=]).
 S BAR("DX","HIT")=0
 I $D(BARY("DX9")) D DX9(BARDX) I BAR("DX","HIT") D  Q
 . S BAR("DX")=BARDX ;FIX 9/12/13
 . I $G(BARDBG) W " YES ICD9 "_BAR("DX")
 . S BARYTOTY("DX9")=$G(BARYTOTY("DX9"))+1
 Q
 I $D(BARY("DX10")) D DX10(BARDX) I BAR("DX","HIT") D  Q
 . S BAR("DX")=BARDX ;FIX 9/12/13
 . I $G(BARDBG) W " YES ICD10 "_BAR("DX")
 . S BARYTOTY("DX10")=$G(BARYTOTY("DX10"))+1
 S BARYTOTN("DX")=$G(BARYTOTN("DX"))+1
 I $G(BARDBG) W " NO "_BAR("DX")
 Q
DX9(BARDX) ;BARDX=BAR("DX")
 NEW BARDXY,BAROK
 I $D(BARY("DX9",3)) D  I BAROK S BAR("DX","HIT")=1 QUIT  ;FOUND INDIVIDUAL DX MATCHING
 . S BAROK=0
 . S BARDXY="" F i=1:1 S BARDXY=$O(BARY("DX9",3,BARDXY)) Q:BARDXY=""  D  I BARDXY=BARDX S BAROK=1 Q
 . . I $G(BARDBG) W !,i,". ",BARDX
 I $D(BARY("DX9",4)) D  I BAROK S BAR("DX","HIT")=1 QUIT  ;FOUND 'DX BEGINS' DX MATCHING
 . S BAROK=0
 . ;S BARDXY="" F  S BARDXY=$O(BARY("DX9",4,BARDXY)) Q:BARDXY=""  I BARDX[BARDXY S BAROK=1 Q  ;DX CONTAINS PATTERN
 . S BARDXY="" F i=1:1 S BARDXY=$O(BARY("DX9",4,BARDXY)) Q:BARDXY=""  D  I $E(BARDX,1,$L(BARDXY))=BARDXY S BAROK=1 Q  ;DX BEGINS PATTERN
 . . I $G(BARDBG) W !,i,". ",BARDX
 Q:$G(BARY("DX9",1))=""
 Q:$G(BARY("DX9",2))=""
 I (BARDX=BARY("DX9",1)!(BARDX]BARY("DX9",1)))&(BARDX']BARY("DX9",2)) D  S BAR("DX","HIT")=1
 . I $G(BARDBG) W !,1,". ",BARDX
 Q
DX10(BARDX) ;
 NEW BARDXY,BAROK
 I $D(BARY("DX10",3)) D  I BAROK S BAR("DX10","HIT")=1 QUIT  ;FOUND INDIVIDUAL DX MATCHING
 . S BAROK=0
 . S BARDXY="" F  S BARDXY=$O(BARY("DX10",3,BARDXY)) Q:BARDXY=""  D  I BARDXY=BARDX S BAROK=1 Q
 . . I $G(BARDBG) W !,i,". ",BARDX
 I $D(BARY("DX10",4)) D  I BAROK S BAR("DX","HIT")=1 QUIT  ;FOUND 'DX BEGINS' DX MATCHING
 . S BAROK=0
 . ;S BARDXY="" F  S BARDXY=$O(BARY("DX10",4,BARDXY)) Q:BARDXY=""  I BARDX[BARDXY S BAROK=1 Q  ;DX CONTAINS PATTERN
 . S BARDXY="" F i=1:1 S BARDXY=$O(BARY("DX10",4,BARDXY)) Q:BARDXY=""  D  I $E(BARDX,1,$L(BARDXY))=BARDXY S BAROK=1 Q  ;DX BEGINS PATTERN
 . . I $G(BARDBG) W !,i,". ",BARDX
 Q:$G(BARY("DX10",1))=""
 Q:$G(BARY("DX10",2))=""
 I (BARDX=BARY("DX10",1)!(BARDX]BARY("DX10",1)))&(BARDX']BARY("DX10",2)) D  S BAR("DX","HIT")=1
 . I $G(BARDBG) W !,1,". ",BARDX
 Q
GETBI(D0) ;keep D0 intact
 I D0="" Q ""
 Q $$VALI^BARVPM(8)     ; Insurer Type CODE 
 ;
 ;EOR 
