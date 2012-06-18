BARRPAY ; IHS/SD/PKD - TOP PAYERS REPORT ; 07/2/2010
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**19**;OCT 26, 2005
 ; New Reports - Top Payers - PKD 
 Q
 ; *******************************
 ;
EN ; EP
 K BARY,BAR,PKD
 D:'$D(BARUSR) INIT^BARUTL  ;Setup basic A/R variables
 S BARP("RTN")="BARRPAY"  ; Routine used to get data
 S BAR("LOC")="BILLING"  ; Financial Reports - verify w/ Adrian/Gina -pkd
 D ^BARRSEL  ; Select exclusion parameters
 I $D(DTOUT)!$D(DUOUT)!$D(DIROUT) Q
 D MOREQ  ; Additional Questions: Sort by; include CXL's; how many to top payers
 ;
HD S BAR("HD",0)=BARMENU
 D ^BARRHD  ; Report header
 ; Add additional Selection Criteria to the Headers
 I $D(BARY("DX")) D DX^BARRHD
 I $D(BARY("CLIN")) D HDCLIN
 I $D(BARY("APPR")) D HDAPPR
 I $D(BARY("ADJTYP")) D HDRADJ
 D HDRSORT
  N SORT,SORTNM,SUBNM,T,TMP,TRIEN,VISITLOC,COUNT,ADJTYP
 S BARQ("RC")="COMPUTE^BARRPAY"  ; Compute routine
 S BARQ("RP")="PRINT^BARRPAY2"  ; Print routine
 S BARQ("NS")="BAR"  ; Namespace for variables
 S BARQ("RX")="POUT^BARRUTL"  ; Clean-up routine
 K ^TMP($J,"BAR-PAY"), ^TMP($J,"BAR-PAYS"), ^TMP($J,"BAR-PAYS1")
 D ^BARDBQUE  ; Double queuing
 ;D PAZ^BARRUTL
 Q
 ;*************
COMPUTE ;
 ;
 S BAR("SUBR")="BAR-PAY"
 K ^TMP($J,"BAR-PAY"),^TMP($J,"BAR-PAYS"),^TMP($J,"BAR-PAYS1")
 S COUNT=0  ; Total transactions counted
 I "VAX"[BARY("DT") D LOOP^BARRUTL Q  ;visit / approved / transmit date sort
 I BARY("DT")="T" D TRANS^BARRUTL  ; transaction date sort
 I BARY("DT")="B" D BATCHDT  ; batch date sort 
 ; 
 Q
BATCHDT  ; Sort by Collection Batch Date, get transactions
 S BARP("DT")=BARY("DT",1)-.5
 F  S BARP("DT")=$O(^BARCOL(DUZ(2),"C",BARP("DT"))) Q:'BARP("DT")!(BARP("DT")>(BARY("DT",2)+.5))  D
 . S BARP("BATCH")=0  F  S BARP("BATCH")=$O(^BARCOL(DUZ(2),"C",BARP("DT"),BARP("BATCH"))) Q:'BARP("BATCH")  D
 . . I '$D(^BARTR(DUZ(2),"AD",BARP("BATCH"))) S ^TMP($J,"BAR-PAY","ERR","COL-BATCH",BARP("BATCH"))="NO TRIENS" Q
 . . S TRIEN=""  F  S TRIEN=$O(^BARTR(DUZ(2),"AD",BARP("BATCH"),TRIEN)) Q:TRIEN=""  D
 . . .  S BARTR=TRIEN D DATA
 Q
 ; ***************
 ;
DATA ; EP
 ; "T" - transaction Date returns BARTR = BARTR IEN
 ; Called by BARRUTL if no parameters
 ;  BAR - ^BARBL IEN
 S BARP("HIT")=0
 I BARY("DT")="T"!(BARY("DT")="B") D  Q:'BARP("HIT")
 . N T S T=$P($G(^BARTR(DUZ(2),BARTR,1)),U) Q:'T
 . Q:T'=43&(T'=40)  ; Adjustments and Payments only
 . S TRIEN=BARTR
 . S BAR=$P(^BARTR(DUZ(2),TRIEN,0),U,4)  ; BAR = BILL IEN
 . Q:'BAR
 . S BARP("HIT")=1
1 S BARP("HIT")=0
 ; LOOP^BARRUTL returns the BILL NUMBER - need the TR-IEN to check parms 
 D BILL^BARRCHK  ; BARP("HIT")=1 if all selected parameters pass
4 Q:'BARP("HIT")
3 S BAR("3P LOC")=$$FIND3PB^BARUTL(DUZ(2),BAR)
 Q:BAR("3P LOC")=""  ; Bill not found 3PB
 S (BAR3PDUZ,VISITLOC)=$P(BAR("3P LOC"),",")  ; Save VisitLoc for Sort
 S BAR3PIEN=$P(BAR("3P LOC"),",",2)
 ; 
 S BARB3PB0=$G(^ABMDBILL(BAR3PDUZ,BAR3PIEN,0))
 S BARBSTAT=$P(BARB3PB0,U,4)  ; Bill Status - X=Cancelled
2 I BARY("CXL")=0&(BARBSTAT="X") Q  ; No cancellations
 S SORT(1)="NO ADDED SORT",SORT=BARY("BARSORTX")  ; primary sort after LOC
 ;1:PROVIDER;2:CLINIC;3:APPROVING OFFICIAL;4:PRIMARY DIAGNOSIS;5:ADJUSTMENT TYPE;6:ALLOWANCE CATEGORY"
 I SORT=1 S SORT(1)=$P(BAR(1),U,13)  ;PRV
 I SORT=2 S SORT(1)=$P(BAR(1),U,8)  ;Clinic
 I SORT=3 S SORT(1)=$P($G(^BARBL(DUZ(2),BAR,2)),U,15) D  ;APPRV OFCL
 . I SORT(1)="" S SORT(1)=0
 ;S BARP("HIT")=0
 ;I SORT=4 S SORT(1)=$P(BAR(1),U,17) D  Q:'BARP("HIT")  ;Prime DX
 ;. I SORT(1)
 ; 0)CR - DB = Pay pc 2-3  A/R Acct - pc 6
 ; 1) pc3 - AdjType
 S BARP("HIT")=0
TRIEN N TT,BARTEST,HIT,BARTRANC,PMTCRD,PAIDAMT
 I BARY("DT")'="T"&(BARY("DT")'="B") S TRIEN="" D  Q
 . F  S TRIEN=$O(^BARTR(DUZ(2),"AC",BAR,TRIEN)) Q:'TRIEN  D TRCHK
 ; 
TRCHK S (PAIDAMT,PMTCRD)=0
 Q:'$D(^BARTR(DUZ(2),TRIEN))  ; quit if no transaction
 ;
 S BARTRANC=$P($G(^BARTR(DUZ(2),TRIEN,1)),U)
 Q:BARTRANC=""  ;No amounts
 Q:BARTRANC'=40&(BARTRANC'=43)
 S BARTEST=$P($G(^BARTR(DUZ(2),TRIEN,1)),U,2) ; ADJ CAT
 Q:BARTEST=21!(BARTEST=22)  ; Pending & Gen'l Info don't affect totals
 I BARTRANC=43 Q:BARTEST'=13&(BARTEST'=14)  ; See Allowable Amt calc in ^BARBLCLC
 ; Only Co-Pays and Deductible Adjustments are included in Allowable Amount
 S ADJTYP=$P($G(^BARTR(DUZ(2),TRIEN,1)),U,3)  ; ADJ TYPE
 I $G(BARY("ADJTYP"))]"" Q:ADJTYP'=BARY("ADJTYP")  ; comment out unless they really want it. ****
 S HIT=0
 S BARPAYER=$P(^BARTR(DUZ(2),TRIEN,0),U,6)  I BARPAYER="" D  Q  ; A/R ACCT aka PAYER
 . S ^TMP($J,"BAR-PAY","ERR","-NO PAYER",TRIEN)=""
 ; GET A/R ACCT; ACCT# ; PayerName and Payer Allowance Category
 ; Allowance code from BARTR=>
 I $G(^BARAC(DUZ(2),BARPAYER,0))="" D  Q
 . S ^TMP($J,"BAR-PAY","ERR","-NO BARAC ENTRY",TRIEN,BARAC)=""
 S BARAC=+$P(^BARAC(DUZ(2),BARPAYER,0),U)  ;
 I $P(^BARAC(DUZ(2),BARPAYER,0),";",2)'["AUTNINS"  Q  ; Quit if Payer is not Insurance Co
 S BARPYALL=$P(^AUTNINS(BARAC,2),U)  ; ALLOWANCE CODE
  I $D(BARY("ALL")) Q:BARY("ALL","CODES")'[BARY("ALL")_" "  ; ALLOWANCE CAT
 S BARPYNM=$P(^AUTNINS(BARAC,0),U)
  S T=$G(^BARTR(DUZ(2),TRIEN,0))
 I BARTRANC=40 S PAIDAMT=$P(T,U,2)
 I BARTRANC=43 S PMTCRD=$P(T,"^",2)-$P(T,"^",3)  ; aka ALLOWANCE AMOUNT
 ; Add credits / deduct debits for adjustments
 S TMP=$G(^TMP($J,"BAR-PAY","ARACT",VISITLOC,BARPAYER))
 D SETSORT
 S ^TMP($J,"BAR-PAY","ARACT",VISITLOC,BARPAYER)=TMP
 I SORT(1)'="" D
 . S X=BARY("BARSORTX")
 . S BARTAG=$S(X=1:"PRV",X=2:"CLIN",X=3:"CSHR",X=4:"DX",X=5:"ADJTY",X=6:"ALLOWCAT",1:"NOSORT")
 . I BARTAG="NOSORT" S SORT(1)=BARTAG,SORTNM=" "
 . E  D @BARTAG
 . S TMP=$G(^TMP($J,"BAR-PAY",BARTAG,VISITLOC,SORT(1),BARPAYER))
 . D SETSORT
 . S ^TMP($J,"BAR-PAY",BARTAG,VISITLOC,SORT(1),BARPAYER)=TMP
 ; will re-sort before printing
 ;S ^TMP($J,"BAR-PAY",BAR)=""
 S COUNT=COUNT+1
 Q
SETSORT  ;
 S $P(TMP,U)=$P(TMP,U)+1  ; TRANSACTION COUNT
 S $P(TMP,U,2)=$P(TMP,U,2)+PAIDAMT  ; AMOUNT PAID
 S $P(TMP,U,3)=$P(TMP,U,3)+PMTCRD  ; ALLOWANCE AMT per TRANSACTION
 Q
 ; *******************************
PRV  ; Provider Name
 S SUBNM="PROVIDER:  "
 S SORT=$P($G(BAR(1)),U,13)
 I SORT="" S SORT(1)="No Provider Listed" Q
 S SORT(1)=$P(^VA(200,SORT,0),U,1)
 Q
 ; . S BARTAG=$S(X=1:"PRV",X=2:"CLIN",X=3:"CSHR",X=4:"DX",X=5:"ADJTY",X=6:"ALLOWCAT",1:"NOSORT")
CLIN  ;  Visit Location Name
 S SUBNM="CLINIC: "
 S SORT=$P(BAR(1),U,12)
 I SORT="" S SORT=DUZ(2)  ; If not a satellite, use the Parent Location as 
 S SORT(1)=$P(^DIC(40.7,SORT,0),U,1)
 Q
CSHR  ;
 S SUBNM="APPROVING OFFICIAL: "
 ; not finding it in ^BARBL(DUZ(2),BILLIEN,2) so
 ;  looking ^ABMDBILL(DUZ(2),3PBIEN,1)
 ; S SORT=$P($G(BAR(2)),U,15)
  S SORT=$P($G(^ABMDBILL(BAR3PDUZ,BAR3PIEN,1)),U,4)
  I SORT="" S SORT(1)="No Approving Official" Q
 S SORT(1)=$P(^VA(200,SORT,0),U,1)
 Q
DX  ; ^ICD9(547,0)=202.04^LC^NODULAR LYMPHOMA AXILLA^^17^^^^
 S SUBNM="Primary DX: "
 S SORT=BAR("DX")  ; set in ^BARRCHK
 I BAR("DX")="No DX" S SORT(1)="No DX entered" Q
 S SORT=$O(^ICD9("AB",SORT,""))  ; get IEN
 S SORT(1)=BAR("DX")_" "_$P(^ICD9(SORT,0),U,3)
 Q
ADJTY  ;
 S SUBNM=("ADJUSTMENT TYPE: ")
 I BARTRANC=40 S SORT(1)="Payment, not Adjustment" Q
 S SORT=$G(ADJTYP) I ADJTYP="" S SORT(1)="No Adj Type" Q
 S SORT(1)=$P(^BARTBL(SORT,0),U)
 Q
ALLOWCAT  ;
 S SUBNM="ALLOWANCE CATEGORY: "
 S SORT=BARALL(BARPYALL)  ; Allowance Category (set in tag: MOREQ)
 S SORT(1)=SORT  ; 
 Q
NOSORT  ;
 S SORT(1)="",SUBNM=" "
 Q
 ; *************************************
MOREQ  ; Additional Questions
 ; Set-up Allowance Code Grid
 K BARALL
 F X="R","MD","MH" S BARALL(X)="MEDICARE (INS TYPES R MD MH)"
 F X="D","K" S BARALL(X)="MEDICAID (INS TYPES D K)"
 F X="P","H","F","M" S BARALL(X)="PRIVATE INSURANCE (INS TYPES P H F M)"
 F X= "W","C","N","I","G","T" S BARALL(X)="OTHER (INS TYPES W C N I G T)"
 ; Select Sort from all available parameters
 I $D(BARY("ALL")) D  ; Get the ALLOWANCE CATEGORIES to include
 . N ALL
 . S ALL=$P(BARY("ALL","NM"),"(INS TYPES ",2)
 . S BARY("ALL","CODES")=$E(ALL,1,$L(ALL)-1)_" "
 K DIR
 S DIR(0)="SO^1:PROVIDER;2:CLINIC;3:APPROVING OFFICIAL;4:PRIMARY DIAGNOSIS;5:ADJUSTMENT TYPE;6:ALLOWANCE CATEGORY"
 S DIR("A")="Select a * SORT * Field"
 S DIR("?")="The report can be sorted by one of the listed parameters."
 D ^DIR Q:Y="^"
 K DIR
 I $E(X)="^" S BARDONE=1 Q
 S BARY("BARSORTX")=+Y
 I $D(DTOUT)!($D(DUOUT)) S BARDONE2=1 Q
 D DISP^BARRSEL
 W !!,"SORT PARAMETER in Effect for Top Payer Report: "
 S BARSORTR=$P($T(SORTEXT),":",BARY("BARSORTX")+2) W BARSORTR
SORTEXT ;;:No Sort Selected:PROVIDER:CLINIC:APPROVING OFFICIAL:PRIMARY DIAGNOSIS:ADJUSTMENT TYPE:ALLOWANCE CATEGORY 
NMBR  ; Number of entries to print
 W ! K DIR
 S DIR("A")="Select number of entries to display"
 S DIR("B")=5  ; Default to Top 5
 S DIR(0)="LO^1:100"
 D ^DIR
 Q:$D(DTOUT)!($D(DUOUT))!(Y<1)
 S BAR("NBR TO PRINT")=+Y
ASKCXL  ;
 W !
 K DIR
 S DIR("A")="Do you wish to include cancelled bills in your count? YES/NO"
 S DIR("B")="YES"
 S DIR(0)="Y"
 D ^DIR
 K DIR
 Q:($D(DUOUT)!$D(DTOUT))
 S BARY("CXL")=Y  ; Quit parameter
 Q
ADJTYP  ; from ^BARRSEL
 S DIR(0)="SO^13:Deductible Adjustments;14:Co-Pays"
 S DIR("A")="Select ONE  of the above INCLUSION PARAMETERS"
 D ^DIR
 I $D(DTOUT)!$D(DUOUT)!$D(DIRUT)!(Y="") Q
 S BARY("ADJTYP")=Y
 Q
 ;
HDCLIN  ; If clinic selected, add to HDR to print
 S BAR("CONJ")="at Clinic "
 S BAR("TXT")=BARY("CLIN","NM")
 D CHK^BARRHD
 Q
HDAPPR ;
 ; Approving Official (ie cashier)
 S BAR("CONJ")="Approving Official "
 S BAR("TXT")=BARY("APPR","NM")
 D CHK^BARRHD
 Q
HDRADJ  ; If Adj selected, add to HDR to print
 S BAR("CONJ")="Adjustment: "
 S BAR("TXT")=$P(^BAR(90052.01,BARY("ADJTYP"),0),U)
 D CHK^BARRHD
 Q
HDRSORT  ; Add Sort selected to HEADERS
 S BAR("CONJ")="Sort by: "
 S BAR("TXT")=BARSORTR
 D CHK^BARRHD
 Q
