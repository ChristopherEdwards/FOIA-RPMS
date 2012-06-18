BARRATS ; IHS/SD/LSL - File Synchronization ;09/15/2008
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**7,19,20**;OCT 26, 2005
 ;
 ; IHS/SD/LSL - 06/04/02 - V1.6 Patch 2
 ;     Routine created
 ; MODIFIED XTMP FILE NAME TO TMP TO MEET SAC REQUIREMENTS;MRS:BAR*1.8*7 IM29892
 ; *********************************************************************
 ;
 ;     This routine will compare the Current Bill Amount of the A/R Bill
 ;     File to the A/R Transaction history balance.  If they are not
 ;     equal, relevant data will be stored in a temp global.  A report
 ;     (A/R BILL AND TRANSACTION SYNCHRONIZATION REPORT) will be
 ;     generated containing A/R Bill, Date of Service, A/R Account,
 ;     Current Bill Amount, Transaction History Balance, and the
 ;     difference between the two.
 ;
 ;     The user may select a visit location for the report.
 ;     The user may choose to print a detail report.  If detail, then
 ;     the transaction history will show as well (Transaction Date,
 ;     Transaction Type, A/R Account, Transaction Amount, and
 ;     Transaction Balance)
 ;
 ; *********************************************************************
 Q
 ; *********************************************************************
 ;
EN ; EP
 ;
 K BARY,BAR
 D:'$D(BARUSR) INIT^BARUTL           ; Set up basic A/R variables
 S BARP("RTN")="BARRATS"             ; Routine used to gather data
 S BAR("PRIVACY")=1                  ; Privacy act applies (used BARRHD)
 S BAR("LOC")=$$GET1^DIQ(90052.06,DUZ(2),16)   ; BILLING or VISIT
 I BAR("LOC")="" S BAR("LOC")="VISIT"
 D MSG^BARRSEL                       ; Message about BILLING/VISIT loc
 D LOC^BARRSL1                       ; Ask location - BARY("LOC")
 Q:$D(DTOUT)!($D(DUOUT))
 W:'$D(BARY("LOC")) "ALL"
 D RTYP                              ; Ask Report type
 Q:$D(DTOUT)!($D(DUOUT))
 D SETHDR                            ; Build header array
 S BARQ("RC")="COMPUTE^BARRATS"      ; Gather data
 S BARQ("RP")="PRINT^BARRATS"        ; Print report
 S BARQ("NS")="BAR"                  ; Namespace for variables
 S BARQ("RX")="POUT^BARRUTL"         ; Clean-up routine
 D ^BARDBQUE                         ; Double queuing
 D PAZ^BARRUTL                       ; Press return to continue
 Q
 ; *********************************************************************
 ;
RTYP ;
 ; Ask report type (detail or summary)         
 K DIR,BARY("RTYP")
 S DIR(0)="SO^1:Detail;2:Summary"
 S DIR("A")="Select TYPE of REPORT desired"
 S DIR("B")=2
 S DIR("?")="Select detail or summary.  Detail contains transaction history"
 D ^DIR
 K DIR
 I $D(DUOUT)!$D(DTOUT) Q
 S BARY("RTYP")=Y
 S BARY("RTYP","NM")=Y(0)
 Q
 ; *********************************************************************
 ;
SETHDR ;
 ; Build header array
 S BAR("LVL")=0
 I $G(BARY("RTYP"))=2 S BAR("HD",0)="SUMMARY "
 E  S BAR("HD",0)="DETAIL "
 S BAR("HD",0)=BAR("HD",0)_"A/R Bill and Transaction Synchronization Report"
 S BAR("TXT")="ALL"
 I $D(BARY("LOC")) S BAR("TXT")=$P(^DIC(4,BARY("LOC"),0),U)
 I BAR("LOC")="BILLING" D
 . S BAR("TXT")=BAR("TXT")_" Visit location(s) under "
 . S BAR("TXT")=BAR("TXT")_$P(^DIC(4,DUZ(2),0),U)
 . S BAR("TXT")=BAR("TXT")_" Billing Location"
 E  S BAR("TXT")=BAR("TXT")_" Visit location(s) regardless of Billing Location"
 S BAR("CONJ")="at "
 D CHK^BARRHD
 Q
 ; *********************************************************************
 ; *********************************************************************
 ;
COMPUTE ;
 ; Build temporary data global
 K ^TMP($J,"BAR-ATS")
 I BAR("LOC")="BILLING" D DATA
 E  D LOOP
 Q
 ; *********************************************************************
LOOP ;
 S BARDUZ=DUZ(2)
 S DUZ(2)=0
 F  S DUZ(2)=$O(^BARBL(DUZ(2))) Q:'+DUZ(2)  D DATA
 S DUZ(2)=BARDUZ
 Q
 ; *********************************************************************
 ;
DATA ;
 S BARBILL=0
 F  S BARBILL=$O(^BARBL(DUZ(2),BARBILL)) Q:'+BARBILL  D
 . Q:'$D(^BARBL(DUZ(2),BARBILL,0))        ; No data on bill
 . D BILLDATA                             ; Gather A/R Bill data
 . I $D(BARY("LOC")),BARY("LOC")'=BARVIS Q  ; Not chosen visit location
 . D TRDATA                               ; Gather A/R Transaction data
 . Q:+BARBAMT=BARTAMT                     ; Files are in sync
 . S BARDIF=BARBAMT-BARTAMT
 . ;S ^TMP($J,"BAR-ATS",BARVISOU,BARAC,BARDOS,BARBILL)=BARBAMT_U_BARTAMT_U_DUZ(2)  ;IHS/SD/AML 5/27/09 - Old code
 . S ^TMP($J,"BAR-ATS",BARVISOU,BARAC,BARDOS,BARBILL,BARBAPP,BARHRN)=BARBAMT_U_BARTAMT_U_DUZ(2)  ;IHS/SD/AML 5/27/09 - Add Appr date and HRN
 Q
 ; *********************************************************************
 ;
BILLDATA ;
 ; Gather data from A/R Bill file.
 F I=0:1:1 S BARBL(I)=$G(^BARBL(DUZ(2),BARBILL,I))
 S BARBAMT=$P(BARBL(0),U,15)              ; Current bill amount
 S BARAC=$$GET1^DIQ(90050.01,BARBILL,3)   ; A/R Account (external)
 S:BARAC="" BARAC="NO A/R ACCOUNT"
 S BARDOS=$P(BARBL(1),U,2)                ; DOS Begin
 I BARDOS="" S BARDOS=99
 S BARVIS=$P(BARBL(1),U,8)                ; Visit location
 I +BARVIS S BARVISOU=$$GET1^DIQ(4,BARVIS,.01)
 E  S BARVISOU="NO VISIT LOCATION"
 S BARBAPP=$P(BARBL(0),U,18)              ;3P Approve date - IHS/SD/AML 4/13/09 - Added to make working ATS report easier
 S BARHRN=$P(BARBL(1),U,7)                ;HRN - IHS/SD/AML 4/13/09 - Added to make working ATS report easier
 S:BARHRN="" BARHRN="NO HRN"  ;Null if missing HRN
 Q
 ; *********************************************************************
 ;
TRDATA ;
 ; Gather data for A/R Bill from A/R Transaction File via "AC" x-ref
 ; Find PSR transactions and do math to find balance
 S (BARTR,BARTAMT)=0
 F  S BARTR=$O(^BARTR(DUZ(2),"AC",BARBILL,BARTR)) Q:'+BARTR  D
 . Q:'$D(^BARTR(DUZ(2),BARTR,0))          ; No transaction data
 . F I=0:1:1 S BARTR(I)=$G(^BARTR(DUZ(2),BARTR,I))
 . S BARTRTYP=$P(BARTR(1),U)              ; Trans type (pointer)
 . S BARADCAT=$P(BARTR(1),U,2)            ; Adjust cat (pointer)
 . S BARCDT=$P(BARTR(0),U,2)
 . S BARDBT=$P(BARTR(0),U,3)
 . ; IHS/SD/PKD 1.8*20 3/11/11 Include Sent to Collections as part of Adjustments
 . ; 25 - Sent to Collections w/ TRANTYP = 993 - STATUS CHANGE
 . ; I ",3,4,13,14,15,16,19,20,"'[(","_BARADCAT_",")&(",40,49,39,108,503,504,"'[(","_BARTRTYP_",")) Q
 . I ",3,4,13,14,15,16,19,20,25"'[(","_BARADCAT_",")&(",40,49,39,108,503,504,993,"'[(","_BARTRTYP_",")) Q
 . S BARTAMT=BARTAMT+BARDBT-BARCDT
 Q
 ; *********************************************************************
 ; *********************************************************************
 ;
PRINT ;
 ; Print report
 K BARRCNT,BARR1,BARR2,BARR3
 S (BARRCNT,BARR1,BARR2,BARR3)=0   ;MRS:BAR*1.8*7 IM30525
 S BAR("PG")=0
 S BARDASH="W !?43,""----------   ----------   ----------"""
 S BAREQUAL="W !?43,""==========   ==========   =========="""
 D HDB                             ; Print page and column headers
 I '$D(^TMP($J,"BAR-ATS")) D  Q
 . W !!!,"*** NO DATA TO PRINT ***"
 . D EOP^BARUTL(0)
 S BARVIS=""
 F  S BARVIS=$O(^TMP($J,"BAR-ATS",BARVIS)) Q:BARVIS=""!$G(BAR("F1"))  D
 . K BARVCNT,BARV1,BARV2,BARV3
 . S (BARVCNT,BARV1,BARV2,BARV3)=0   ;MRS:BAR*1.8*7 IM30525
 . W !!?5,"Visit Location: ",BARVIS,!
 . S BARAC=""
 . F  S BARAC=$O(^TMP($J,"BAR-ATS",BARVIS,BARAC)) Q:BARAC=""!$G(BAR("F1"))  D
 . . S BARDOS=0
 . . F  S BARDOS=$O(^TMP($J,"BAR-ATS",BARVIS,BARAC,BARDOS)) Q:'+BARDOS!$G(BAR("F1"))  D
 . . . S BARBILL=0
 . . . F  S BARBILL=$O(^TMP($J,"BAR-ATS",BARVIS,BARAC,BARDOS,BARBILL)) Q:'+BARBILL!$G(BAR("F1"))  D
 . . . . ;IHS/SD/AML 5/27/09 - Added to ^TMP to allow Approval date and HRN to print on report
 . . . . S BARBAPP=0
 . . . . F  S BARBAPP=$O(^TMP($J,"BAR-ATS",BARVIS,BARAC,BARDOS,BARBILL,BARBAPP)) Q:'+BARBAPP!$G(BAR("F1"))  D
 . . . . . S BARHRN=0
 . . . . . F  S BARHRN=$O(^TMP($J,"BAR-ATS",BARVIS,BARAC,BARDOS,BARBILL,BARBAPP,BARHRN)) Q:BARHRN=""!$G(BAR("F1"))  D
 . . . . . . S BARTMP=^TMP($J,"BAR-ATS",BARVIS,BARAC,BARDOS,BARBILL,BARBAPP,BARHRN)
 . . . . . . S BARHLD=DUZ(2)
 . . . . . . S DUZ(2)=$P(BARTMP,U,3)
 . . . . . . D PRNTLINE
 . . . . . . I $G(BARY("RTYP"))=1 D HIST
 . . . . . . S DUZ(2)=BARHLD
 . . . . ;IHS/SD/AML 5/27/09 - End new code, begin old code
 . . . . ;S BARTMP=^TMP($J,"BAR-ATS",BARVIS,BARAC,BARDOS,BARBILL)
 . . . . ;S BARHLD=DUZ(2)
 . . . . ;S DUZ(2)=$P(BARTMP,U,3)
 . . . . ;D PRNTLINE
 . . . . ;I $G(BARY("RTYP"))=1 D HIST
 . . . . ;S DUZ(2)=BARHLD
 . . . . ;IHS/SD/AML 5/27/09 - End code changes to allow ^TMP global population of new fields
 . X BARDASH
 . W !," ** Visit Location Total  (Bill cnt:"
 . W ?37,$J(BARVCNT,4),")"
 . W ?43,$J($FN(BARV1,",",2),10)
 . W ?56,$J($FN(BARV2,",",2),10)
 . W ?69,$J($FN(BARV3,",",2),10)
 X BAREQUAL
 W !,"*** REPORT TOTAL          (Bill cnt:"
 W ?37,$J(BARRCNT,4),")"
 W ?43,$J($FN(BARR1,",",2),10)
 W ?56,$J($FN(BARR2,",",2),10)
 W ?69,$J($FN(BARR3,",",2),10)
 Q
 ; *********************************************************************
 ;
HD ; EP
 D PAZ^BARRUTL
 I $D(DTOUT)!$D(DUOUT)!$D(DIROUT) S BAR("F1")=1 Q
 ;
HDB ; EP
 ; Page and column header
 S BAR("PG")=BAR("PG")+1
 S BAR("I")=""
 D WHD^BARRHD                       ; Page header
 W !?48,"BILL",?56,"TRANSACTION"
 W !,"A/R BILL",?15,"DOS",?27,"A/R ACCOUNT",?46,"BALANCE"
 W ?56,"HISTORY BAL",?69,"DIFFERENCE"
 S $P(BAR("DASH"),"=",$S($D(BAR(132)):132,1:80))=""
 W !,BAR("DASH"),!
 Q
 ; *********************************************************************
 ;
PRNTLINE ;
 ; PRINT DATA LINES
 S BARBAMT=$P(BARTMP,U)
 S BARTAMT=$P(BARTMP,U,2)
 S BARDIFF=BARBAMT-BARTAMT
 ;S BARBAPP=$G(BARBAPP)               ;MRS:BAR*1.8*7 IM30525
 ;S BARHRN=$G(BARHRN)                 ;MRS:BAR*1.8*7 IM30525
 I $Y>(IOSL-5) D HD Q:$G(BAR("F1"))
 W !,$E($$GET1^DIQ(90050.01,BARBILL,.01),1,12)
 I BARDOS=99 W ?14,"NO DOS"
 E  W ?14,$$SDT^BARDUTL(BARDOS)
 W ?26,$E(BARAC,1,15)
 W ?43,$J($FN(BARBAMT,",",2),10)
 W ?56,$J($FN(BARTAMT,",",2),10)
 W ?69,$J($FN(BARDIFF,",",2),10)
 ;IHS/SD/AML 5/15/2008 - Begin new code - print additional items on ATS
 W !,?3,"Appr Dt: "_$$CDT^BARDUTL(BARBAPP)_" ("_(BARBAPP)_")"  ;IHS/SD/SDR 9/28/10
 W ?47,"HRN: "_BARHRN  ;IHS/SD/SDR 9/28/10
 W ?64,$J($FN(($$GET1^DIQ(90050.01,BARBILL,13)),",",2),10)  ;IHS/SD/SDR 9/28/10
 W ?75,"[ ]"  ;IHS/SD/SDR 9/28/10
 ;IHS/SD/AML 5/15/2008 - End new code - print additional lines on ATS
 ;
 S BARVCNT=$G(BARVCNT)+1
 S BARRCNT=$G(BARRCNT)+1
 S BARV1=$G(BARV1)+BARBAMT
 S BARV2=$G(BARV2)+BARTAMT
 S BARV3=$G(BARV3)+BARDIFF
 S BARR1=$G(BARR1)+BARBAMT
 S BARR2=$G(BARR2)+BARTAMT
 S BARR3=$G(BARR3)+BARDIFF
 Q
 ; *********************************************************************
 ;
HIST ;
 ; Detail report...print transaction history
 S (BARTR,BARTAMT,BARTBAL)=0
 W !!?6,"TR DATE",?17,"TR TYPE",?33,"A/R ACCOUNT",?50,"TR AMOUNT",?65,"TR BALANCE"
 W !?6,"----------",?17,"--------------",?33,"--------------",?50,"----------",?65,"----------"  ;IHS/SD/SDR 9/28/10
 F  S BARTR=$O(^BARTR(DUZ(2),"AC",BARBILL,BARTR)) Q:'+BARTR!($G(BAR("F1")))  D
 . Q:'$D(^BARTR(DUZ(2),BARTR,0))          ; No transaction data
 . F I=0:1:1 S BARTR(I)=$G(^BARTR(DUZ(2),BARTR,I))
 . S BARTRTYP=$P(BARTR(1),U)              ; Trans type (pointer)
 . S BARADCAT=$P(BARTR(1),U,2)            ; Adjust cat (pointer)
 . S BARCDT=$P(BARTR(0),U,2)
 . S BARDBT=$P(BARTR(0),U,3)
 . ;I ",3,4,13,14,15,16,19,20,"'[(","_BARADCAT_",")&(",40,49,39,108,503,504,"'[(","_BARTRTYP_",")) Q  ;bar*1.8*20
 . ;include sent to collections
 . I ",3,4,13,14,15,16,19,20,25"'[(","_BARADCAT_",")&(",40,49,39,108,503,504,993,"'[(","_BARTRTYP_",")) Q  ;bar*1.8*20
 . ;
 . S BARTAMT=BARDBT-BARCDT
 . S BARTBAL=$G(BARTBAL)+BARTAMT
 . I $Y>(IOSL-4) D HD Q:$G(BAR("F1"))
 . ;I DUZ(0)="@" W !?2,BARTR  ;IHS/SD/AML 5/27/09
 . ;E  W !?6,$$SDT^BARDUTL(BARTR)  ;IHS/SD/AML 5/27/09
 . W !?2,BARTR  ;IHS/SD/AML 5/27/09
 . W ?17,$E($$GET1^DIQ(90050.03,BARTR,101),1,14)
 . W ?33,$E($$GET1^DIQ(90050.03,BARTR,6),1,14)
 . W ?50,$J($FN(BARTAMT,",",2),10)
 . W ?65,$J($FN(BARTBAL,",",2),10)
 W ! F A=1:1:80 W "-"  ;IHS/SD/SDR 9/28/10
 W !
 Q
