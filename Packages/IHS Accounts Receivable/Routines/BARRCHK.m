BARRCHK ; IHS/SD/LSL - Report Utility to Check Parms ;07/23/2010
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**4,6,7,10,19,23,24,25*;OCT 26, 2005;Build 6
 ; MODIFIED XTMP($J,"ZTSRREJ-" ERROR WITH XTMP($J,"BAR-"_;MRS:BAR*1.8*6 IM29892
 ; MODIFIED XTMP FILE NAME TO TMP TO MEET SAC REQUIREMENTS;MRS:BAR*1.8*7 IM29892
 ; 
 ; TMM 07/23/2010 V1.8*19
 ;      Add (Employer) Group Plan filter for A/R Statistical
 ;       report. requirement 4PMS10022
 ;
 ; IHS/SD/POT HEAT 03/13 ADDED NEW VA billing  - BAR*1.8*23
 ; IHS/SD/POT HEAT 07/13 ADDED SUPPORT FOR ICD-10 - BAR*1.8*23
 ; IHS/SD/POT 09/13 FIXED <UNDEFINED>BILL+30^BARRCHK *BAR("DX",1) IF NO DX - BAR*1.8*24
 ; IHS/SD/POT 02/09/14 HEAT150941 Allow ALL DX9/10; if no DX selected:
 ;                      show ALL DX of ALL available coding systems - BAR*1.8*24
 ; IHS/SD/POT 09/12/14 CR4073 HEAT182059 FIXED MATCHING OF SELECTED INDIVIDUAL ICD-10 DIAGNOSES  - BAR*1.8*25
 ; ********************************************
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
 ;TAKE PRIMARY DX FROM BILL FILE
 ;
 ;BUG FIX SETTING BAR("DX") CORRECTLY
 K BAR("DX")
 S BAR("DX",1)=$$GET1^DIQ(90050.01,BAR,24)   ; Primary Diagnosis (Code)
 S BAR("DX")=$G(BAR("DX",1))
 S BAR("GRP")=$P($P($$GROUPLAN^BARUTL(BAR),U,2),"|",1)  ; Group Plan  ;IHS/SD/TMM ADD 7/23/10
 I $G(BAR("DX",1))="" S BAR("DX",1)=" " ;"No DX"
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
 . I ",V,"[(","_BAR("BI")_",") S BAR("ALL")="V" Q        ; - BAR*1.8*23
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
 ;I DUZ=838 I $D(BARY("PAT")) W !,"PATIENT # MATCHES: PAT=",$G(BARY("PAT"))," P=",BAR("P")
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
 I $D(BARY("DX9"))!$D(BARY("DX10")) D DX Q:'BAR("DX","HIT")       ; Check DX - BAR*1.8*23
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
DX ; - BAR*1.8*23
 S BAR("DX","HIT")=0
 N I,BARDX
 ;FOR EACH PAT DX RUN MATCHING PROCESS
 S BARDBG=0
 S I="" F  S I=$O(BAR("DX",I)) Q:'I  D  Q:BAR("DX","HIT")
 . S BARDX=BAR("DX",I)
 . I BARY("DX-ICDVER")="9" D DX29(BARDX) Q
 . I BARY("DX-ICDVER")="10" D DX210(BARDX) Q
 . I BARY("DX-ICDVER")="B" D DX29(BARDX),DX210(BARDX) Q
 Q
DX29(BARDX) ;
 I $G(BARDBG) W !,"CHECKING IF DX ",BARDX," MATCHES CRITERIA FOR SELECTED DXs 9"
 ;RLT - Fixed quits and changed DX selection
 ;      from numeric operators (<>) to string
 ;      operators (=]).
 S BAR("DX","HIT")=0
 I $$GETICD(BARDX)'=9 D  Q   ;IF NOT CODED IN 9 QUIT 3/10/2014
 . I $G(BARDBG) W !,BARDX," NOT ICD9"
 . Q
 I $G(BARY("DX9"))="ALL" S BAR("DX","HIT")=1 Q  ;HEAT150941 ALL DX9 2/9/2014
 I $D(BARY("DX9")) D DX9(BARDX) I BAR("DX","HIT") D  Q
 . S BAR("DX")=BARDX ;FIX 9/12/13
 . I $G(BARDBG) W " YES ICD9 "_BAR("DX")
 . S BARYTOTY("DX9")=$G(BARYTOTY("DX9"))+1
 . Q
 Q
DX210(BARDX) ;
 I $G(BARDBG) W !,"CHECKING IF DX ",BARDX," MATCHES CRITERIA FOR SELECTED DXs 10"
 I $$GETICD(BARDX)'=10 D  Q   ;IF NOT CODED IN 9 QUIT
 . I $G(BARDBG) W !,BARDX," NOT ICD10"
 . Q
 I $G(BARY("DX10"))="ALL" S BAR("DX","HIT")=1 Q  ;HEAT150941 ALL DX10 2/9/2014
 I $D(BARY("DX10")) D DX10(BARDX) I BAR("DX","HIT") D  Q
 . S BAR("DX")=BARDX ;FIX 9/12/13
 . I $G(BARDBG) W " YES ICD10 "_BAR("DX")
 . S BARYTOTY("DX10")=$G(BARYTOTY("DX10"))+1
 Q
DX9(BARDX) ;BARDX=BAR("DX")
 NEW BARDXY,BAROK
 I $D(BARY("DX9",3)) D  I BAROK S BAR("DX","HIT")=1 QUIT  ;FOUND INDIVIDUAL DX MATCHING
 . S BAROK=0
 . S BARDXY="" F i=1:1 S BARDXY=$O(BARY("DX9",3,BARDXY)) Q:BARDXY=""  D  I BARDXY=BARDX S BAROK=1 Q
 . . I $G(BARDBG) W !,i,". ",BARDX
 Q:$G(BARY("DX9",1))=""
 Q:$G(BARY("DX9",2))=""
 I (BARDX=BARY("DX9",1)!(BARDX]BARY("DX9",1)))&(BARDX']BARY("DX9",2)) D  S BAR("DX","HIT")=1
 . I $G(BARDBG) W !,1,". ",BARDX
 Q
DX10(BARDX) ;
 NEW BARDXY,BAROK,BARI
 ;old code I $D(BARY("DX10",3)) D  I BAROK S BAR("DX10","HIT")=1 QUIT  ;INDIVIDUAL DX MATCHING
 I $D(BARY("DX10",3)) D  I BAROK S BAR("DX","HIT")=1 QUIT  ;INDIVIDUAL DX MATCHING HEAT182059 - BAR*1.8*25
 . S BAROK=0
 . S BARDXY="" F BARI=1:1 S BARDXY=$O(BARY("DX10",3,BARDXY)) Q:BARDXY=""  D  I BARDXY=BARDX S BAROK=1 Q
 . . I $G(BARDBG) W !,BARI,". ",BARDX
 Q:$G(BARY("DX10",1))=""
 Q:$G(BARY("DX10",2))=""
 I $$NUM^ICDEX(BARDX)<$$NUM^ICDEX(BARY("DX10",1)) Q  ;< LOW NO MATCH
 I $$NUM^ICDEX(BARDX)>$$NUM^ICDEX(BARY("DX10",2)) Q  ;> HIGH - NO  MATCH
 D  S BAR("DX","HIT")=1
 . I $G(BARDBG) W !,1,". ",BARDX
 Q
 ;END NEW CODE
GETBI(D0) ;keep D0 intact
 I D0="" Q ""
 Q $$VALI^BARVPM(8)     ; Insurer Type CODE 
 ;
GETICD(BARDX)  ;
 N BARFILE,BARX
 I BARDX="" Q 0  ;NIL  - NO DG
 I BARDX=" " Q 0  ;NO DG
 I $T(+1^ICDEX)="" Q 9  ;IS ICD9 (NO OTHER EXISTS)
 S BARFILE=$$CODEFI^ICDEX(BARDX) ; File for code
 S BARX=$$CODECS^ICDEX(BARDX,BARFILE,"") ; Coding system for code/file
 I BARX["ICD-9" Q 9
 Q 10
 ;
 ;EOR 
