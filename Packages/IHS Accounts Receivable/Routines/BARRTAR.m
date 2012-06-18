BARRTAR ; IHS/SD/LSL - Transaction report ; 08/20/2008
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**6,7,21**;OCT 26, 2005
 ; MODIFIED XTMP FILE NAME TO TMP TO MEET SAC REQUIREMENTS;MRS:BAR*1.8*7 IM29892
 ; IHS/ASDS/LSL - 10/02/00 - Routine created
 ;
 ; IHS/SD/LSL - 04/19/02 - V1.6 Patch 2
 ;     Modified to accomodate new "Location to sort report by" parameter
 ;
 ; IHS/SD/LSL - 10/24/02 - V1.7 - PAB-1002-90130
 ;      Modified to insert DUZ(2) as subscript in data global.  Needed to
 ;      pull correct Collection Batch and Item from A/R Global during print
 ;      due to "location to sort report by" parameter edits.
 ;
 ; IHS/SD/LSL - 06/20/03 - V1.7 Patch 2 - IM10890
 ;      Remove tran type 115 (coll batch to acct post) from report
 ;
 Q
 ; *********************************************************************
 ;
EN ; EP
 K BARY,BAR
 D:'$D(BARUSR) INIT^BARUTL         ; Setup basic A/R variables
 S BARP("RTN")="BARRTAR"           ; Routine used to get data
 S BAR("PRIVACY")=1                ; Privacy act applies
 S BAR("LOC")=$$GET1^DIQ(90052.06,DUZ(2),16)   ; BILLING or VISIT
 I BAR("LOC")="" S BAR("LOC")="VISIT"
 D ^BARRSEL                        ; Select exclusion parameters
 I $D(DTOUT)!$D(DUOUT)!$D(DIROUT) Q
 I $D(BARY("RTYP")) S BAR("HD",0)=BARY("RTYP","NM")_" "_BARMENU
 E  S BAR("HD",0)=BARMENU
 D ^BARRHD                         ; Report header
 S BARQ("RC")="COMPUTE^BARRTAR"    ; Compute routine
 S BARQ("RP")="PRINT^BARRTAR"      ; Print routine
 S BARQ("NS")="BAR"                ; Namespace for variables
 S BARQ("RX")="POUT^BARRUTL"       ; Clean-up routine
 D ^BARDBQUE                       ; Double queuing
 D PAZ^BARRUTL
 Q
 ; *********************************************************************
 ;
COMPUTE ;
 ;
 S BAR("SUBR")="BAR-TAR"
 K ^TMP($J,"BAR-TAR")
 K ^TMP($J,"BAR-TARS")
 I BAR("LOC")="BILLING" D TRANS^BARRUTL Q
 S BARDUZ2=DUZ(2)
 S DUZ(2)=0
 F  S DUZ(2)=$O(^BARTR(DUZ(2))) Q:'DUZ(2)  D TRANS^BARRUTL
 S DUZ(2)=BARDUZ2
 Q
 ; *********************************************************************
 ;
DATA ; EP
 ; Called by BARRUTL if no parameters
 F I=2:1:7 S BAR(I)=0
 S BARP("HIT")=0
 D TRANS^BARRCHK
 Q:'BARP("HIT")
 S BAR("SORT")=$S(BARY("SORT")="C":BAR("C"),1:BAR("V"))
 I BARTR("I")]"" S BAR("ACCT")=$$VAL^XBDIQ1(90050.02,BARTR("I"),.01)
 I BAR("ACCT")="" S BAR("ACCT")="No A/R Account"   ; External A/R Acct
 S BARTR("L")=$$VAL^XBDIQ1(9999999.06,BARTR("L"),.01)  ; External location
 S BAR("TRANS")=$P(BARTR(1),U)                     ; Transaction type
 S BAR("ADJCAT")=$P(BARTR(1),U,2)                  ; Adjustment Category
 ;IHS/SD/PKD bar*1.8*21 Add Sent to Collections 25&993 to Adj/Trans
 ;I ",3,4,13,14,15,16,19,20,"'[(","_BAR("ADJCAT")_",")&(",40,100,"'[(","_BAR("TRANS")_",")) Q
 I ",3,4,13,14,15,16,19,20,25,"'[(","_BAR("ADJCAT")_",")&(",40,100,993,"'[(","_BAR("TRANS")_",")) Q
 S BAR("CR-DB")=$$VAL^XBDIQ1(90050.03,BARTR,3.5)   ; Credits - Debits
 S BAR(1)=$E($P(BAR(0),U),1,14)                    ; Bill number
 S:BAR("TRANS")=40 BAR(2)=BAR("CR-DB")             ; Payment Amount
 S:BAR("ADJCAT")=20 BAR(3)=BAR("CR-DB")            ; Previous credits
 S:BAR("ADJCAT")=19 BAR(4)=BAR("CR-DB")            ; Refund
 I +BAR(2)!(+BAR(3))!(+BAR(4)) S BAR(5)=BAR("CR-DB")  ; Payment
 S BAR(6)=$P(BAR(0),U,13)                          ; Billed Amount
 ; Adjustments
 ; IHS/SD/PKD bar*1.8*21 Include Sent to collections to Adj Cat
 ;I ",3,4,13,14,15,16,"[(","_BAR("ADJCAT")_",") S BAR(7)=BAR("CR-DB")
 I ",3,4,13,14,15,16,25,"[(","_BAR("ADJCAT")_",") S BAR(7)=BAR("CR-DB")
 ; For detail
 S BARHLD=$G(^TMP($J,"BAR-TAR",BARTR("AR"),DUZ(2)_U_BARTR("L")_U_BARTR("B")_U_BARTR("IT")_U_BAR("SORT")_U_BAR("ACCT")_U_BAR))
 S $P(^TMP($J,"BAR-TAR",BARTR("AR"),DUZ(2)_U_BARTR("L")_U_BARTR("B")_U_BARTR("IT")_U_BAR("SORT")_U_BAR("ACCT")_U_BAR),U)=BAR(1)
 S $P(^TMP($J,"BAR-TAR",BARTR("AR"),DUZ(2)_U_BARTR("L")_U_BARTR("B")_U_BARTR("IT")_U_BAR("SORT")_U_BAR("ACCT")_U_BAR),U,2)=$P(BARHLD,U,2)+BAR(2)
 S $P(^TMP($J,"BAR-TAR",BARTR("AR"),DUZ(2)_U_BARTR("L")_U_BARTR("B")_U_BARTR("IT")_U_BAR("SORT")_U_BAR("ACCT")_U_BAR),U,3)=$P(BARHLD,U,3)+BAR(3)
 S $P(^TMP($J,"BAR-TAR",BARTR("AR"),DUZ(2)_U_BARTR("L")_U_BARTR("B")_U_BARTR("IT")_U_BAR("SORT")_U_BAR("ACCT")_U_BAR),U,4)=$P(BARHLD,U,4)+BAR(4)
 S $P(^TMP($J,"BAR-TAR",BARTR("AR"),DUZ(2)_U_BARTR("L")_U_BARTR("B")_U_BARTR("IT")_U_BAR("SORT")_U_BAR("ACCT")_U_BAR),U,5)=$P(BARHLD,U,5)+BAR(5)
 S $P(^TMP($J,"BAR-TAR",BARTR("AR"),DUZ(2)_U_BARTR("L")_U_BARTR("B")_U_BARTR("IT")_U_BAR("SORT")_U_BAR("ACCT")_U_BAR),U,6)=BAR(6)
 S $P(^TMP($J,"BAR-TAR",BARTR("AR"),DUZ(2)_U_BARTR("L")_U_BARTR("B")_U_BARTR("IT")_U_BAR("SORT")_U_BAR("ACCT")_U_BAR),U,7)=$P(BARHLD,U,7)+BAR(7)
 ;BEGIN BAR*1.8*6 IHS/SD/TPF 8/6/2008 IM30075
 ;S BARHLD=$G(^TMP($J,"BAR-TAR",BARTR("AR"),DUZ(2)_U_BARTR("L")_U_BARTR("B")_U_BARTR("IT")_U_BAR("SORT")_U_BAR("ACCT")_U_BAR_U_BARTR))
 ;S $P(^TMP($J,"BAR-TAR",BARTR("AR"),DUZ(2)_U_BARTR("L")_U_BARTR("B")_U_BARTR("IT")_U_BAR("SORT")_U_BAR("ACCT")_U_BAR_U_BARTR),U)=BAR(1)
 ;S $P(^TMP($J,"BAR-TAR",BARTR("AR"),DUZ(2)_U_BARTR("L")_U_BARTR("B")_U_BARTR("IT")_U_BAR("SORT")_U_BAR("ACCT")_U_BAR_U_BARTR),U,2)=$P(BARHLD,U,2)+BAR(2)
 ;S $P(^TMP($J,"BAR-TAR",BARTR("AR"),DUZ(2)_U_BARTR("L")_U_BARTR("B")_U_BARTR("IT")_U_BAR("SORT")_U_BAR("ACCT")_U_BAR_U_BARTR),U,3)=$P(BARHLD,U,3)+BAR(3)
 ;S $P(^TMP($J,"BAR-TAR",BARTR("AR"),DUZ(2)_U_BARTR("L")_U_BARTR("B")_U_BARTR("IT")_U_BAR("SORT")_U_BAR("ACCT")_U_BAR_U_BARTR),U,4)=$P(BARHLD,U,4)+BAR(4)
 ;S $P(^TMP($J,"BAR-TAR",BARTR("AR"),DUZ(2)_U_BARTR("L")_U_BARTR("B")_U_BARTR("IT")_U_BAR("SORT")_U_BAR("ACCT")_U_BAR_U_BARTR),U,5)=$P(BARHLD,U,5)+BAR(5)
 ;S $P(^TMP($J,"BAR-TAR",BARTR("AR"),DUZ(2)_U_BARTR("L")_U_BARTR("B")_U_BARTR("IT")_U_BAR("SORT")_U_BAR("ACCT")_U_BAR_U_BARTR),U,6)=BAR(6)
 ;S $P(^TMP($J,"BAR-TAR",BARTR("AR"),DUZ(2)_U_BARTR("L")_U_BARTR("B")_U_BARTR("IT")_U_BAR("SORT")_U_BAR("ACCT")_U_BAR_U_BARTR),U,7)=$P(BARHLD,U,7)+BAR(7)
 ;END BAR*1.8*6 IHS/SD/TPF 8/6/2008 IM30075
 ; For summary
 S BARHLD2=$G(^TMP($J,"BAR-TARS",BARTR("AR"),DUZ(2),BARTR("L"),BARTR("B"),BARTR("IT"),BAR("SORT"),BAR("ACCT")))
 S $P(^TMP($J,"BAR-TARS",BARTR("AR"),DUZ(2),BARTR("L"),BARTR("B"),BARTR("IT"),BAR("SORT"),BAR("ACCT")),U,2)=$P(BARHLD2,U,2)+BAR(2)
 S $P(^TMP($J,"BAR-TARS",BARTR("AR"),DUZ(2),BARTR("L"),BARTR("B"),BARTR("IT"),BAR("SORT"),BAR("ACCT")),U,3)=$P(BARHLD2,U,3)+BAR(3)
 S $P(^TMP($J,"BAR-TARS",BARTR("AR"),DUZ(2),BARTR("L"),BARTR("B"),BARTR("IT"),BAR("SORT"),BAR("ACCT")),U,4)=$P(BARHLD2,U,4)+BAR(4)
 S $P(^TMP($J,"BAR-TARS",BARTR("AR"),DUZ(2),BARTR("L"),BARTR("B"),BARTR("IT"),BAR("SORT"),BAR("ACCT")),U,5)=$P(BARHLD2,U,5)+BAR(5)
 S $P(^TMP($J,"BAR-TARS",BARTR("AR"),DUZ(2),BARTR("L"),BARTR("B"),BARTR("IT"),BAR("SORT"),BAR("ACCT")),U,6)=$P(BARHLD2,U,6)+BAR(6)
 S $P(^TMP($J,"BAR-TARS",BARTR("AR"),DUZ(2),BARTR("L"),BARTR("B"),BARTR("IT"),BAR("SORT"),BAR("ACCT")),U,7)=$P(BARHLD2,U,7)+BAR(7)
 Q
 ; *********************************************************************
 ;
PRINT ; EP
 ; Print
 S BAR("PG")=0
 I BARY("RTYP")=1 D DETAIL^BARRTAR2,FOOTER
 I BARY("RTYP")=2 D SUMM^BARRTAR3,FOOTER
 I BARY("RTYP")=3 D
 . D DETAIL^BARRTAR2
 . Q:'$D(@BAR)            ; No data
 . D PAZ^BARRUTL
 . Q:$G(BAR("F1"))
 . D SUMM^BARRTAR3
 . D FOOTER
 Q
 ; *********************************************************************
 ;
FOOTER ;
 Q:$G(BAR("F1"))
 I $D(BAR("UN-ALLOCATED")) D
 . S X=""
 . K BAR("DUZ")
 . S X=$O(BAR("UN-ALLOCATED",X))
 . S BAR("DUZ")=$P(BAR("UN-ALLOCATED",X),U,2)
 . S BAR("COL")="W !!?10,""** Unallocated for Collection Batch "",$P(^BARCOL(BAR(""DUZ""),BARTR(""B""),0),U),"" **"",!!"
 . D PAZ^BARRUTL
 . D HDB^BARRTAR2
 . S BAR("UN")=""
 . F  S BAR("UN")=$O(BAR("UN-ALLOCATED",BAR("UN"))) Q:'BAR("UN")  D
 . . W !?15,"ITEM",?30,$J(BAR("UN"),3),?40,$J($FN($P(BAR("UN-ALLOCATED",BAR("UN")),U),",",2),10)
 . . S BAR("UNT")=$G(BAR("UNT"))+$P(BAR("UN-ALLOCATED",BAR("UN")),U)
 . W !?40,"----------"
 . W !?40,$J($FN(BAR("UNT"),",",2),10)
 I $D(BAR("ST")) D
 . W !!!!?16,"*****  R E P O R T  C O M P L E T E  *****"
 . D PAZ^BARRUTL
 Q
