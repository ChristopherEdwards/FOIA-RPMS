BARRCHK ; IHS/SD/LSL - Report Utility to Check Parms ;07/23/2010
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**4,6,7,10,19**;OCT 26, 2005
 ; MODIFIED XTMP($J,"ZTSRREJ-" ERROR WITH XTMP($J,"BAR-"_;MRS:BAR*1.8*6 IM29892
 ; MODIFIED XTMP FILE NAME TO TMP TO MEET SAC REQUIREMENTS;MRS:BAR*1.8*7 IM29892
 ; 
 ; TMM 07/23/2010 V1.8*19
 ;      Add (Employer) Group Plan filter for A/R Statistical
 ;       report. requirement 4PMS10022. ;                     
 ;      
 ; ***********************************************************************
 Q
 ;
BILL ;EP
 ; for checking Bill File data parameters
 S BARP("HIT")=0
 ;BAR*1.8*6 ADDED FOR DEBUGGING
 S:$G(BAR("SUBR"))="" BAR("SUBR")=$S($G(BAR("RTN"))'="":BAR("RTN"),1:"UNKNOWN CALL")
 ;I '$D(^BARBL(DUZ(2),BAR)) S:$G(DEBUG) ^TMP($J,"ZTSRREJ-"_BAR("SUBR"),"REASON REJECTED","NO DATA AT THIS IEN",BAR)=""  ;MRS:BAR*1.8*6 IM29892
 I '$D(^BARBL(DUZ(2),BAR)) S:$G(DEBUG) ^TMP($J,"BAR-"_BAR("SUBR"),"REASON REJECTED","NO DATA AT THIS IEN",BAR)=""  ;MRS:BAR*1.8*6 IM29892
 ;END NEW
 Q:'$D(^BARBL(DUZ(2),BAR))        ; No data
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
 S BAR("DX")=$$GET1^DIQ(90050.01,BAR,24)   ; Primary Diagnosis (Code)
 S BAR("GRP")=$P($P($$GROUPLAN^BARUTL(BAR),U,2),"|",1)  ; Group Plan  ;IHS/SD/TMM ADD 7/23/10
 I BAR("DX")="" S BAR("DX")="No DX"
 I BAR("I")]"" D
 . S D0=BAR("I")
 . S BAR("BI")=$$VALI^BARVPM(8)     ; Type of Insurer
 I $G(BAR("BI"))="" S BAR("BI")="No Billing Entity"
 I BAR("BI")'="No Billing Entity" D
 . S BAR("ALL")="O"                             ; Other Allow Cat
 . I BAR("BI")="G" S BAR("ALL")="O" Q           ; Other BAR*1.8*6  DD 4.1.1 IM21585 
 . ;I BAR("BI")="R" S BAR("ALL")="R" Q           ; Medicare Allow Cat  bar*1.8*4 SCR91
 . I BAR("BI")="R"!(BAR("BI")="MD")!(BAR("BI")="MH") S BAR("ALL")="R" Q  ;bar*1.8*4 SCR91
 . I BAR("BI")="D" S BAR("ALL")="D" Q           ; Medicaid Allow Cat
 . ;I BAR("BI")="K" S BAR("ALL")="K" Q           ; CHIPS Allow Cat ;BAR*1.8*6  DD 4.1.1
 . I BAR("BI")="K" S BAR("ALL")="D" Q           ; CHIPS is lumped with Medicaid ;BAR*1.8*6  DD 4.1.1
 . I ",F,M,H,P,"[(","_BAR("BI")_",") S BAR("ALL")="P" Q  ; Private AC ;MRS:BAR*1.8*10 D148-4
 . ;I ",F,M,H,P,T,"[(","_BAR("BI")_",") S BAR("ALL")="P" Q  ; Remove T from Private;MRS:BAR*1.8*10 D148-4
 I $G(BAR("ALL"))=""  S BAR("ALL")="No Allowance Category"
 I BAR("L")=""!(BAR("I")="")!(BAR("P")="")!(BAR("D")="") S:$G(DEBUG) ^TMP($J,"BAR-"_BAR("SUBR"),"REASON REJECTED","NULL LOCATION^INS TYPE^PATIENT^DOS BEGIN",BAR)=BAR("L")_U_BAR("I")_U_BAR("P")_U_BAR("D")
 Q:BAR("L")=""!(BAR("I")="")!(BAR("P")="")!(BAR("D")="")
 ;
 I $G(BARY("SORT"))="V",BAR("V")="" S BAR("V")=99999
 I $G(BARY("SORT"))="C",BAR("C")="" S BAR("C")=99999
 I '$D(^BARAC(DUZ(2),BAR("I"),0)) S:$G(DEBUG) ^TMP($J,"BAR-"_BAR("SUBR"),"REASON REJECTED","NO AR ACCT DATA",BAR)=""
 Q:'$D(^BARAC(DUZ(2),BAR("I"),0))               ; No A/R account data
 ;BAR*1.8*6  DD 4.1.1 FOR THE FOLLOWING LINES ADDED A SET TO THE REJECTION GLOBAL
 I $D(BARY("LOC")),BARY("LOC")'=BAR("L") D  Q      ; Not chosen location
 .S:$G(DEBUG) ^TMP($J,"BAR-"_BAR("SUBR"),"REASON REJECTED","NOT CHOSEN LOCATION",BAR)=""
ARACCT  ;
 I $D(BARY("ARACCT")),'$D(BARY("ARACCT",BAR("I"))) D  Q  ; Not chosn AR ac
 .S:$G(DEBUG) ^TMP($J,"BAR-"_BAR("SUBR"),"REASON REJECTED","NOT CHOSEN (ARACCT) AR ACCT",BAR)=""
 I $D(BARY("PAT")),BARY("PAT")'=BAR("P") D  Q      ; Not chosen patient
 .S:$G(DEBUG) ^TMP($J,"BAR-"_BAR("SUBR"),"REASON REJECTED","NOT CHOSEN PATIENT",BAR)=""
 I $D(BARY("PRV")),BARY("PRV")'=BAR("PV") D  Q     ; Not chosen provider
 .S:$G(DEBUG) ^TMP($J,"BAR-"_BAR("SUBR"),"REASON REJECTED","NOT CHOSEN PROVIDER",BAR)=""
ARACCT1  ;
 I $D(BARY("ACCT")),BARY("ACCT")'=BAR("I") D  Q    ; Not chosen A/R acct
 . S:$G(DEBUG) ^TMP($J,"BAR-"_BAR("SUBR"),"REASON REJECTED","NOT CHOSEN (ACCT) AR ACCT",BAR)=""
 ; ---BEGIN 1.8*19 IHS/SD/TMM 7/25/10
 I $D(BARY("GRP PLAN")),$P(BAR("GRP"),U)=0 D  Q   ;Group Plan not found
 . S BARTMP="NO GROUP PLAN FOR THIS BILL"
 . I $G(DEBUG) S ^TMP($J,"BAR-"_BAR("SUBR"),"REASON REJECTED",BARTMP,BAR)=""
 I $D(BARY("GRP PLAN")),'$D(BARY("GRP PLAN",BAR("GRP"))) D  Q  ; Not chosn Group Plan
 . S:$G(DEBUG) ^TMP($J,"BAR-"_BAR("SUBR"),"REASON REJECTED","NOT CHOSEN (GRP PLAN-"_BAR("""GRP""")_") AR ACCT",BAR)=""
 ; -----END 1.8*19
 I $D(BARY("DSCH")),BAR("DS")="" S BAR("DS")=99999
 I $D(BARY("DSCH")),'$D(BARY("DSCH",BAR("DS"))) D  Q  ;Not chosn disch svc
 .S:$G(DEBUG) ^TMP($J,"BAR-"_BAR("SUBR"),"REASON REJECTED","NOT CHOSEN (DSCH) DISCH SVC",BAR)=""
 I $D(BARY("DSVC")),BARY("DSVC")'=BAR("DS") D  Q      ;Not chosn disch svc
 .S:$G(DEBUG) ^TMP($J,"BAR-"_BAR("SUBR"),"REASON REJECTED","NOT CHOSEN (DSVC) DISCH SVC",BAR)=""
 I $D(BARY("DX")) D DX Q:'BAR("DX","HIT")       ; Check DX range
 ;I $D(BARY("TYP")),BARY("TYP")'[BAR("BI") Q     ; Not chosen Bill entity
 I $D(BARY("TYP")),(U_BARY("TYP")_U)'[(U_BAR("BI")_U) D  Q     ; Not chosen Bill entity BAR*1.8*6 DD 4.1.1 IM21585
 .S:$G(DEBUG) ^TMP($J,"BAR-"_BAR("SUBR"),"REASON REJECTED","NOT CHOSEN ABILL ENTITY",BAR)=""
 I $D(BARY("ITYP")),BARY("ITYP")'=BAR("BI") D  Q   ; Not chosen Ins Type
 .S:$G(DEBUG) ^TMP($J,"BAR-"_BAR("SUBR"),"REASON REJECTED","NOT CHOSEN INS TYPE",BAR)=""
 I $D(BARY("ALL")),(+BARY("ALL")=BARY("ALL")) S BARY("ALL")=$$CONVERT^BARRSL2(BARY("ALL"))  ;BAR*1.8*6 DD 4.1.1 IM21585
 I $D(BARY("ALL")),BARY("ALL")'=BAR("ALL") D  Q     ; Not chosen Allow Cat
 .S:$G(DEBUG) ^TMP($J,"BAR-"_BAR("SUBR"),"REASON REJECTED","NOT CHOSEN ALLOW CAT",BAR)=""
 I $D(BARY("CLIN")),'$D(BARY("CLIN",BAR("C"))) D  Q  ; Not chosen clinic
 .S:$G(DEBUG) ^TMP($J,"BAR-"_BAR("SUBR"),"REASON REJECTED","NOT CHOSEN CLINIC",BAR)=""
 I $D(BARY("VTYP")),'$D(BARY("VTYP",BAR("V"))) D  Q  ; Not chosen visit typ
 .S:$G(DEBUG) ^TMP($J,"BAR-"_BAR("SUBR"),"REASON REJECTED","NOT CHOSEN VISIT TYPE",BAR)=""
 K BAR("QUIT")
 I $G(BARY("DT"))="V" D  Q:$G(BAR("QUIT"))      ; Not chosen visit date
 . S:BAR("D")<BARY("DT",1) BAR("QUIT")=1
 . S:BAR("D")>BARY("DT",2) BAR("QUIT")=1
 . I $G(BAR("QUIT")) S:$G(DEBUG) ^TMP($J,"BAR-"_BAR("SUBR"),"REASON REJECTED","NOT CHOSEN VISIT DATE",BAR)=""
 I $G(BARY("DT"))="A" D  Q:$G(BAR("QUIT"))      ; Not chosen approval dt
 . S:BAR("A")<BARY("DT",1) BAR("QUIT")=1
 . S:$P(BAR("A"),".")>BARY("DT",2) BAR("QUIT")=1
 . I $G(BAR("QUIT"))  S:$G(DEBUG) ^TMP($J,"BAR-"_BAR("SUBR"),"REASON REJECTED","NOT CHOSEN APPROVAL DATE",BAR)=""
 I $G(BARY("DT"))="X" D  Q:$G(BAR("QUIT"))      ; Not chosen export date
 . S:BAR("PD")<BARY("DT",1) BAR("QUIT")=1
 . S:$P(BAR("PD"),".")>BARY("DT",2) BAR("QUIT")=1
 . I $G(BAR("QUIT"))  S:$G(DEBUG) ^TMP($J,"BAR-"_BAR("SUBR"),"REASON REJECTED","NOT CHOSEN EXPORT DATE",BAR)=""
 S BARP("HIT")=1
 Q
 ;
TRANS ;EP
 D TRANS^BARRCHK1  ;BAR*1.8*6 SQA ROUTINE SIZE LIMIT
 Q
 ;
DX ;
 ;RLT - Fixed quits and changed DX selection
 ;      from numeric operators (<>) to string
 ;      operators (=]).
 S BAR("DX","HIT")=0
 Q:$G(BARY("DX",1))=""
 Q:$G(BARY("DX",2))=""
 I ((BAR("DX")=BARY("DX",1))!(BAR("DX")]BARY("DX",1)))&(BAR("DX")']BARY("DX",2)) S BAR("DX","HIT")=1
 Q
