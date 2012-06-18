BARRCXL1 ; IHS/SD/LSL - Cancelled Bills Report - Gather Data ;08/20/2008
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**7,19**;OCT 26, 2005
 ;
 ; IHS/SD/PKD - 05/07/10 - BAR*1.8.19
 ; IHS/SD/LSL - 03/10/03 - Routine created
 ;      Called by BARRCXL
 ; MODIFIED XTMP FILE NAME TO TMP TO MEET SAC REQUIREMENTS;MRS:BAR*1.8*7 IM29892
 Q
 ; *********************************************************************
 ;
 ;
COMPUTE ; EP
 ;
 S BAR("SUBR")="BAR-CXL"
 K ^TMP($J,"BAR-CXL"),^TMP($J,"BAR-CXL MULT"),^TMP($J,"BAR-CXL SUMY")
 S BARP("RTN")="BARRCXL1"    ; Routine used to get data if no parameters
 ;S BARDUZ2=DUZ(2)
 ;S DUZ(2)=0
 ;F  S DUZ(2)=$O(^BARBL(DUZ(2))) Q:'DUZ(2)!($G(BAR("F1")))
 ; Index "OBAL" should supercede any other Index
 S BAR=0
 I BARY("OBAL")=1 D  Q
 . F  S BAR=$O(^BARBL(DUZ(2),"OBAL",BAR)) Q:'BAR  D DATA
 D LOOP^BARRUTL
 ;S DUZ(2)=BARDUZ2
 Q
 ; *********************************************************************
 ;
DATA ; EP
 ; Called by BARRUTL if no parameters
 S BARP("HIT")=0
 D BILL^BARRCHK
 Q:'BARP("HIT")
 S BAR("3P LOC")=$$FIND3PB^BARUTL(DUZ(2),BAR)
 Q:BAR("3P LOC")=""                           ; Bill not found 3PB
 S BAR3PDUZ=$P(BAR("3P LOC"),",")
 S BAR3PIEN=$P(BAR("3P LOC"),",",2)
 ; BAR*1.8*19 IHS/SD/PKD 5/10/10 START
 ;S BARBSTAT=$P($G(^ABMDBILL(BAR3PDUZ,BAR3PIEN,0),U,4)
 S BARB3PB0=$G(^ABMDBILL(BAR3PDUZ,BAR3PIEN,0))  ; Need 3 pieces
 S BARBSTAT=$P(BARB3PB0,U,4)  ; Bill Status
 I '($I(PKDTOT)#1000) W "."
 Q:BARBSTAT'="X"
 ;I '($I(PKDTOTC)#1000) W "X"                              ; Bill not cancelled in 3P
 I $G(BARY("PTYP"))=2,$P($G(^AUPNPAT(BAR("P"),11)),U,12)'="I" Q  ;Not eligible
 I $G(BARY("PTYP"))=1,$P($G(^AUPNPAT(BAR("P"),11)),U,12)="I" Q   ; Eligible
 S BARBVSTY=$P(BARB3PB0,U,7)  ;Visit Type
 S BARBCLNC=$P(BARB3PB0,U,10)  ; Visit Clinic
 S BARBCANC=$P($G(^ABMDBILL(BAR3PDUZ,BAR3PIEN,1)),U,11)  ; Cancelling Official
 I $D(BARY("CANC")) Q:BARY("CANC")'=BARBCANC  ; Quit if Cancelling Official doesn't match selection
 S:BARBCANC="" BARBCANC=0  ; Piece not set In come older records
 S BARBREAS=$P($G(^ABMDBILL(BAR3PDUZ,BAR3PIEN,1)),U,13)  ; Reason Cancelled
 S:BARBREAS="" BARBREAS="Not Listed"
 ; END
 ;
 S BARLOC=""
 S:BAR("L")]"" BARLOC=$$GET1^DIQ(4,BAR("L"),.01)
 S:BARLOC="" BARLOC="No Visit Location"       ; Visit Location Name
 S BARACCT=""
 S:BAR("I")]"" BARACCT=$$GET1^DIQ(90050.02,BAR("I"),.01)
 S:BARACCT="" BARACCT="No A/R Account"        ; A/R Account Name
 S BARPAT=""
 S:BAR("P")]"" BARPAT=$$GET1^DIQ(9000001,BAR("P"),.01)
 S:BARPAT="" BARPAT="No Patient Name"         ; Patient Name
 S BARBILL=$P(BAR(0),U)                       ; Bill Number
 S BARBAMT=$P(BAR(0),U,13)                    ; Amount Billed
 S BARBAL=$P(BAR(0),U,15)                     ; Bill Balance
 ;
 I BARY("RTYP")=1 D DETDATA
 D SUMDATA
 Q
 ; *********************************************************************
DETDATA ;
 ; Build global for Detail Report
 ;  BAR*1.8*19 IHS/SD/PKD 5/10/10 - Cancelling Official is primary sort - BEGIN
 ;S ^TMP($J,"BAR-CXL",BARLOC,BARACCT,BAR("D"),BARPAT,BARBILL)=BARBAMT_U_BARBAL
 ; SORT:  Cashier, Location, Visit Type (or Clinic) plus PT NM,HRN,BILL# 
 N BARSORT S BARSORT=$S(BARY("SORT")="V":BARBVSTY,1:BARBCLNC)  ; visit type or Clinic
 N HRN S HRN=$P(BARBILL,"-",3) I 'HRN S HRN=$P(BAR(1),"^",7)
 I HRN="" S HRN="***** "
 S ^TMP($J,"BAR-CXL MULT",BARBCANC,BARLOC,BARSORT,BARPAT,BARBILL)=""
 S ^TMP($J,"BAR-CXL",BARBCANC,BARLOC,BARSORT,BARPAT,BARBILL)=BARBAMT_U_BARBAL
 S ^TMP($J,"BAR-CXL",BARBCANC,BARLOC,BARSORT,BARPAT,BARBILL,"MORE")=BARACCT_U_BAR("D")_U_HRN_U_BARBREAS
 ; END 1.8*19
 Q
 ; ********************************************************************
 ;
SUMDATA ;
 ; BAR*1.8*19 IHS/SD/PKD 5/10/10 - Add Cancelling Official as primary sort
 ; Build global for Summary Report (and Detail totals)
 ; Sum by AR Account
 ;S BARHOLD=$G(^TMP($J,"BAR-CXL",BARLOC,BARACCT))
 ;S $P(^TMP($J,"BAR-CXL",BARLOC,BARACCT),U)=$P(BARHOLD,U)+1
 ;S $P(^TMP($J,"BAR-CXL",BARLOC,BARACCT),U,2)=$P(BARHOLD,U,2)+BARBAMT
 ;S $P(^TMP($J,"BAR-CXL",BARLOC,BARACCT),U,3)=$P(BARHOLD,U,3)+BARBAL
 ;
 ; Sum by Visit Location
 ;S BARHOLD=$G(^TMP($J,"BAR-CXL",BARLOC))
 ;S $P(^TMP($J,"BAR-CXL",BARLOC),U)=$P(BARHOLD,U)+1
 ;S $P(^TMP($J,"BAR-CXL",BARLOC),U,2)=$P(BARHOLD,U,2)+BARBAMT
 ;S $P(^TMP($J,"BAR-CXL",BARLOC),U,3)=$P(BARHOLD,U,3)+BARBAL
 ;
 ; Sum for Report
 ;S BARHOLD=$G(^TMP($J,"BAR-CXL"))
 ;S $P(^TMP($J,"BAR-CXL"),U)=$P(BARHOLD,U)+1
 ;S $P(^TMP($J,"BAR-CXL"),U,2)=$P(BARHOLD,U,2)+BARBAMT
 ;S $P(^TMP($J,"BAR-CXL"),U,3)=$P(BARHOLD,U,3)+BARBAL
 ; Build global for Summary Report (and Detail totals)
 ; 
 ; BAR*1.8*19 BEGIN NEW CODE
 ; 
 ; Sum by AR Visit TYPE or CLINIC
 N BARSORT S BARSORT=$S(BARY("SORT")="V":BARBVSTY,1:BARBCLNC)
 S BARHOLD=$G(^TMP($J,"BAR-CXL",BARBCANC,BARLOC,BARSORT))
 S $P(BARHOLD,U)=$P(BARHOLD,U)+1
 S $P(BARHOLD,U,2)=$P(BARHOLD,U,2)+BARBAMT
 S $P(BARHOLD,U,3)=$P(BARHOLD,U,3)+BARBAL
 S ^TMP($J,"BAR-CXL",BARBCANC,BARLOC,BARSORT)=BARHOLD
 ;
 ; Sum by Visit Location
 S BARHOLD=$G(^TMP($J,"BAR-CXL",BARBCANC,BARLOC))
 S $P(BARHOLD,U)=$P(BARHOLD,U)+1
 S $P(BARHOLD,U,2)=$P(BARHOLD,U,2)+BARBAMT
 S $P(BARHOLD,U,3)=$P(BARHOLD,U,3)+BARBAL
 S ^TMP($J,"BAR-CXL",BARBCANC,BARLOC)=BARHOLD
 ;
 ; Sum by Cancelling Official (cashier in 3PB)
 S BARHOLD=$G(^TMP($J,"BAR-CXL",BARBCANC))
 S $P(BARHOLD,U)=$P(BARHOLD,U)+1
 S $P(BARHOLD,U,2)=$P(BARHOLD,U,2)+BARBAMT
 S $P(BARHOLD,U,3)=$P(BARHOLD,U,3)+BARBAL
 S ^TMP($J,"BAR-CXL",BARBCANC)=BARHOLD
 ;
 ; Sum for Report
 S BARHOLD=$G(^TMP($J,"BAR-CXL"))
 S $P(BARHOLD,U)=$P(BARHOLD,U)+1
 S $P(BARHOLD,U,2)=$P(BARHOLD,U,2)+BARBAMT
 S $P(BARHOLD,U,3)=$P(BARHOLD,U,3)+BARBAL
 S ^TMP($J,"BAR-CXL")=BARHOLD
 Q
 ; END BAR*1.8*19
