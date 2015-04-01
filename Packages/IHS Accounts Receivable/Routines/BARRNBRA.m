BARRNBRA ; IHS/SD/POT - Non Ben Payment Report ; 08/20/2008
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**24**;OCT 26, 2005;Build 69
 ; IHS/SD/POT 07/15/13 HEAT114352 NEW REPORT BAR*1.8*24
 ; IHS/SD/POT 01/14/14 FIXED: IDENTIFY PAYMENTS TO OTHER PAT BAR*1.8*24
 ; IHS/SD/POT 04/07/14 FIXED CHECK FOR ELIGIBILITY STATUS FROM PAT FILE BAR*1.8*24
 Q
 ; **
 ;
EN ; EP
 K BARY,BAR
 S BARP("RTN")="BARRNBRA"
 S BARY("RTYP")=1,BARY("RTYP","NM")="DETAIL"
 S BAR("PRIVACY")=1  ; Privacy act applies
 S BARY("SORT")=""   ; Init value to prevent <UNDEF>
 D:'$D(BARUSR) INIT^BARUTL         ; Set A/R basic variable
 S BAR("LOC")=$$GET1^DIQ(90052.06,DUZ(2),16)   ; BILLING or VISIT
 I BAR("LOC")="" S BAR("LOC")="VISIT"
 S DEBUG=0
ASK1 D ASKAGAI1^BARRNBRS
 I $D(DTOUT)!$D(DUOUT)!$D(DIROUT) Q
 I $D(DTOUT)!$D(DUOUT)!$D(DIROUT) Q
 I $D(BARY("RTYP")) S BAR("HD",0)=BARY("RTYP","NM")_" "_BARMENU
 E  S BAR("HD",0)=BARMENU
 ;-
 I $G(BARY("SORT"))="C" S BARY("SORT","NM")="Clinic"
 I $G(BARY("SORT"))="V" S BARY("SORT","NM")="Visit type"
 I $G(BARY("DT"))="V" S BARY("DT","NM")="Visit"
 I $G(BARY("DT"))="T" S BARY("DT","NM")="Transaction"
 I '$D(BARY("DT")) D  ;
 . S BARY("DT")="",BARY("DT",1)="",BARY("DT",2)=""
 S BARY("TYP")="^N^"
 S BARY("TYP","NM")="NON-BENEFICIARY"
 ;-
 D SETHDR                            ; Build header array
 S BARQ("RC")="COMPUTE^BARRNBRA"     ; Build tmp global with data
 S BARQ("RP")="PRINT^BARRNBRB"       ; Print reports from tmp global
 S BARQ("NS")="BAR"                  ; Namespace for variables
 S BARQ("RX")="POUT^BARRUTL"         ; Clean-up routine
 D ^BARDBQUE                         ; Double queuing
 D PAZ^BARRUTL                       ; Press return to continue
 Q
 ; **
SETHDR ;
 ; Build header array
 S BAR("OPT")="NBR"
 S BAR("LVL")=0
 S BARMODE="S"
 I $G(BARY("RTYP"))=1 S BARMODE="D"
 I BARMODE="D" S BAR("HD",0)="Non-beneficiary Detailed Report"
 I BARMODE="S" S BAR("HD",0)="Non-beneficiary Summary Report"
 D DT^BARRHD
 S BAR("LVL")=$G(BAR("LVL"))+1
 S BAR("HD",BAR("LVL"))=""
 S BAR("TXT")="ALL"
 I $D(BARY("LOC")) S BAR("TXT")=$P(^DIC(4,BARY("LOC"),0),U)
 I BAR("LOC")="BILLING" D
 . S BAR("TXT")=BAR("TXT")_" Visit location(s) under "
 . S BAR("TXT")=BAR("TXT")_$P(^DIC(4,DUZ(2),0),U)
 . S BAR("TXT")=BAR("TXT")_" Billing Location"
 E  S BAR("TXT")=BAR("TXT")_" Visit location(s) regardless of Billing Location"
 I $D(BARY("PAT")) S BAR("TXT")=BAR("TXT")_$C(10,13)_"for "_BARY("PAT","NM")
 S BAR("CONJ")="at "
 D CHK^BARRHD
 Q
 ; **
 ;
COMPUTE ; EP
 S BAR("SUBR")="BAR-NBR"
 K ^TMP($J,"BAR-NBR")
 K ^TMP($J,"BAR-NBR9")
 K ^TMP($J,"BAR-NBRT")
 K ^TMP($J,"BAR-BAR-NBR")
 I BAR("LOC")="BILLING" ;**************
 D TRANS,MAIN Q
 Q
 ; *********************************************************************
 ;
TRANS ;EP for Looping thru Transaction File
 I $G(BARY("PAT"))="" I BARY("DT")="T" S BARP("X")="B" D  Q  ;NO PAT - LOOP TXD FROM-TO
 . S BARP("DT")=BARY("DT",1)-.5 F  S BARP("DT")=$O(^BARTR(DUZ(2),BARP("X"),BARP("DT"))) Q:'BARP("DT")!(BARP("DT")>(BARY("DT",2)+.5))  D
 . . S BARTR=0 F  S BARTR=$O(^BARTR(DUZ(2),BARP("X"),BARP("DT"),BARTR)) Q:'BARTR  D DATA
 ;-------------------------
 I $G(BARY("PAT"))="" I BARY("DT")="V" D  Q   ;NO PAT - LOOP ALL TXD
 . S BARP("DT")=0 F  S BARP("DT")=$O(^BARTR(DUZ(2),BARP("DT"))) Q:'+BARP("DT")  S BARTR=BARP("DT") D DATA
 ;-------------------------
 I BARY("DT")="T" S BARP("X")="AF" D  Q  ;PAT
 . S BARP("DT")=BARY("DT",1)-.5 F  S BARP("DT")=$O(^BARTR(DUZ(2),BARP("X"),BARY("PAT"),BARP("DT"))) Q:'BARP("DT")!(BARP("DT")>(BARY("DT",2)+.5))  D
 . . S BARTR=BARP("DT") D DATA
 ;--------------------------
 I BARY("DT")="V" S BARP("X")="AF" D  Q
 . S BARP("DT")=0 F  S BARP("DT")=$O(^BARTR(DUZ(2),BARP("X"),BARY("PAT"),BARP("DT"))) Q:+BARP("DT")=0  D
 . . S BARTR=BARP("DT") D DATA
 ;--
 Q
 ; **
DATA ; Gather data for transactions found in TRANS
 ; S ^TMP($J,"BAR-NBR9",YBARBL,BARBL)
 ; S ^TMP($J,"BAR-NBR9",YBARBL,BARBL,BARTR)
 ;
 S BARP("HIT")=0
 S X=$$ISNONBEN(BARTR) I 'X Q
 D CHKTRANS^BARRNBRE(BARTR)
 I 'BARP("HIT") Q  ;
 S BARTEST=","_$P($G(^BARTR(DUZ(2),BARTR,1)),U)_","
 I BARTEST=",," Q
 ;I ",115,116,117,118,"[BARTEST D  Q
 I ",49,40,"'[BARTEST Q
 ;
 I $$ISERR(BARTR) Q  ;ERROR
 S BARBL=$P($G(^BARTR(DUZ(2),BARTR,0)),U,4) ;
 S BARTR(0)=$G(^BARTR(DUZ(2),BARTR,0))  ; A/R Transaction 0 node
 S BARTR(1)=$G(^BARTR(DUZ(2),BARTR,1))  ; A/R Transaction 1 node
 S BARTR("T")=$P(BARTR(1),U)            ; Transaction type
 S BARTR("DT")=$P(BARTR(0),U)           ; Transaction date/time
 S BARCR=$P(BARTR(0),"^",2)
 S BARDB=$P(BARTR(0),"^",3)
 S BARTRACC=$P(BARTR(0),U,6)            ;ACCNT
 S BARPAT=$P(BAR(10),U,1)               ;PAT FROM BAR 1;1
 S BARFLG=0
 I BARTRACC]"" I $G(^BARAC(DUZ(2),BARTRACC,0))[";AUPNPAT" I +$G(^BARAC(DUZ(2),BARTRACC,0))=BARPAT S BARFLG=1 ;BILLED TO PAT
 I BARTRACC]"" I $G(^BARAC(DUZ(2),BARTRACC,0))[";AUPNPAT" I +$G(^BARAC(DUZ(2),BARTRACC,0))'=BARPAT S BARFLG=-1 ;BILLED TO other PAT (in err) 1/14/2014
 ;40 - payment
 ;19 - refund
 ;20 - payment credit
 S BARPAY=0 I BARTR("T")=40 S BARPAY=$$VAL^XBDIQ1(90050.03,BARTR,3.5) ;PAYMENT #3.6
 S BARADJ=0
 I "^3^4^13^14^15^16^"[("^"_BARTR("T")_"^") S BARADJ=$$VAL^XBDIQ1(90050.03,BARTR,3.5) ;ADJ #3.7 ;
 S BARPAYAD=BARPAY+BARADJ
 ;BARFLG=-1 IF PAT WAS CHARGED IN ERR
 ;BARFLG=1 IF PAT WAS CHARGED
 ;BARFLG=0 IF INS WAS CHARGED
 I BARTR("T")=49 Q  ;1/13/2014 
 S TMP=BARTR("DT")_"^"_BARTR("T")_"^"_BARCR_"^"_BARDB_"^"_BARPAY_"^"_BARADJ_"^"_BARPAYAD_"^"_BARFLG
 S YBARBL=+$P($G(^BARBL(DUZ(2),BARBL,0)),U,1)  ;1ST PART OF BILL #
 S ^TMP($J,"BAR-NBR9",YBARBL,BARBL,BARTR)=TMP
 S ^TMP($J,"BAR-NBR9",YBARBL,BARBL)=$P(BAR(0),U,1)_"^"_$P(BAR(0),U,13)_"^"_$P(BAR(0),U,15)_"^^^"_BARPAT
 Q
 ;---------------------------
MAIN ;^TMP($J,"BAR-NBR9",-->^TMP($J,"BAR-NBRT",BAR("SUB1"),BAR("SUB3"),BAR("SUB4"),BAR("SUB5")),U,I)
 ;
 ; BAR("SUB1") = Visit Location
 ; BAR("SUB2") = Clinic / visit type
 ; BAR("SUB3") = N/A
 ; BAR("SUB4") = N/A
 ; BAR("SUB5") = A/R Bill
 ; OUTPUT DATA - NOT USED
 ; BAR(1) = Billed Amount
 ; BAR(2) = Insurance Payment
 ; BAR(3) = Patient  Payment
 ; BAR(4) = Balance
 ; BAR(5) = Transaction Date
 ; -------------------------------
 ;
 F I=1:1:5 S BAR(I)=0
 F I=1:1:5 K BAR("SUB"_I)
 N BARX,BAR,BARXTR,BARTR,BARDDD
 S BARY="" F  S BARY=$O(^TMP($J,"BAR-NBR9",BARY)) Q:BARY=""  D
 . S BARX="0" F  S BARX=$O(^TMP($J,"BAR-NBR9",BARY,BARX)) Q:BARX=""  D ADDUPTR^BARRNBRF(BARY,BARX)
 S BARY="" F  S BARY=$O(^TMP($J,"BAR-NBR9",BARY)) Q:BARY=""  D ADDUPBL^BARRNBRF(BARY)
 S BARX="" F  S BARX=$O(^TMP($J,"BAR-NBR9",BARX)) Q:BARX=""  D MAIN2(BARX)
 D 100^BARRNBRF
 D 110^BARRNBRF
 Q
 ;
MAIN2(YBARBL) ;YBARBL IS THE 1ST PART OF A BILL
 N PATPAY,INSPAY,BARDATE,BARBL
 F I=1:1:5 S BAR(I)=0
 S BARBL=$O(^TMP($J,"BAR-NBR9",YBARBL,"0")) I BARBL="" Q
 S BARDATE=+^TMP($J,"BAR-NBR9",YBARBL,BARBL)
 D EXTRACT(BARBL) ;GET 'C' AND 'L'
 S BAR("SUB1")=$$GET1^DIQ(9999999.06,BARTR("L"),.01) ;Visit Location
 S:BAR("SUB1")="" BAR("SUB1")="No Visit Location"
 I BARY("SORT")="C" D
 . S BAR("SUB2")=BAR("C") ;Clinic / visit type
 . I BAR("SUB2")]"",BAR("SUB2")'=99999 S BAR("SUB2")=$$GET1^DIQ(40.7,BAR("SUB2"),.01)
 . I BAR("SUB2")=""!(BAR("SUB2")=99999) S BAR("SUB2")="No Clinic Type"
 . D STANDARD
 I BARY("SORT")="V" D
 . S BAR("SUB2")=BAR("V") ;Clinic / visit type
 . I BAR("SUB2")]"",BAR("SUB2")'=99999 S BAR("SUB2")=$$GET1^DIQ(9002274.8,BAR("SUB2"),.01)
 . I BAR("SUB2")=""!(BAR("SUB2")=99999) S BAR("SUB2")="No Visit Type"
 . D STANDARD
 S BAR("SUB3")=" " ;N/A
 S BAR("SUB4")=" " ;N/A
 S BAR("SUB5")=YBARBL
 I BAR("SUB5")="" Q
 D DETAIL
 D BILL
 D SUMMARY
 Q
 ; *
STANDARD ;
 ; Temp global for SORT CRITERIA Clinic or Visit or A/R Account
 ; or Discharge Service
 ; Detail Lines
 NEW I
 S BARHLD=$G(^TMP($J,"BAR-NBR",BAR("SUB1"),BAR("SUB2")))
 F I=1:1:4 S $P(^TMP($J,"BAR-NBR",BAR("SUB1"),BAR("SUB2")),U,I)=$P(BARHLD,U,I)+BAR(I)
 ;
 ; Visit Location Totals
 S BARHLD=$G(^TMP($J,"BAR-NBR",BAR("SUB1")))
 F I=1:1:4 S $P(^TMP($J,"BAR-NBR",BAR("SUB1")),U,I)=$P(BARHLD,U,I)+BAR(I)
 ; Report Total
 S BARHLD=$G(^TMP($J,"BAR-NBR"))
 F I=1:1:4 S $P(^TMP($J,"BAR-NBR"),U,I)=$P(BARHLD,U,I)+BAR(I)
 S ^TMP($J,"BAR-NBR",BAR("SUB1"),BAR("SUB2"),YBARBL)=""
 Q
 ; *
 ;
SUMMARY ;
 ; Temp global for SORT CRITERIA Allowance Category or Billing Entity
 ; and Report Type Summarize.
 ;
 ; Detail Lines
 NEW I
 S BARHLD=$G(^TMP($J,"BAR-NBRT",BAR("SUB1"),BAR("SUB3")))
 F I=1:1:4 S $P(^TMP($J,"BAR-NBRT",BAR("SUB1"),BAR("SUB3")),U,4)=$P(BARHLD,U,I)+BAR(I)
 ;
 ; Visit Location Totals
 S BARHLD=$G(^TMP($J,"BAR-NBRT",BAR("SUB1")))
 F I=1:1:4 S $P(^TMP($J,"BAR-NBRT",BAR("SUB1")),U,I)=$P(BARHLD,U,I)+BAR(I)
 S $P(^TMP($J,"BAR-NBRT",BAR("SUB1")),U,5)=BARTR("L")
 ;
 ; Report Total
 S BARHLD=$G(^TMP($J,"BAR-NBRT"))
 F I=1:1:4 S $P(^TMP($J,"BAR-NBRT"),U,I)=$P(BARHLD,U,I)+BAR(I)
 Q
 ; *
 ;
DETAIL ;
 ; Temp global for SORT CRITERIA Allowance Category or Billing Entity
 ; and Report Type Summarize by payor w/in.
 ;
 ; Detail Lines
 NEW I
 S BARHLD=$G(^TMP($J,"BAR-NBRT",BAR("SUB1"),BAR("SUB3"),BAR("SUB4")))
 F I=1:1:4 S $P(^TMP($J,"BAR-NBRT",BAR("SUB1"),BAR("SUB3"),BAR("SUB4")),U,I)=$P(BARHLD,U,I)+BAR(I)
 Q
 ; *
 ;
BILL ;
 ; Temp global for SORT CRITERIA Allowance Category or Billing Entity
 ; and Report Type Summarize by BILL w/in payor w/in.
 ;
 ; Detail Lines
 S BARHLD=$G(^TMP($J,"BAR-NBRT",BAR("SUB1"),BAR("SUB3"),BAR("SUB4"),BAR("SUB5")))
 F I=1:1:4 S $P(^TMP($J,"BAR-NBRT",BAR("SUB1"),BAR("SUB3"),BAR("SUB4"),BAR("SUB5")),U,I)=$P(BARHLD,U,I)+BAR(I)
 S $P(^TMP($J,"BAR-NBRT",BAR("SUB1"),BAR("SUB3"),BAR("SUB4"),BAR("SUB5")),U,5)=BARDATE
 Q
 ; *
 ;
XIT ;
 D ^BARVKL0
 Q
ISERR(BARTRDT) ;
 N BARTR,BARTTYP
 D ENP^XBDIQ1(90050.03,BARTRDT,"101;102;103","BARTR(","I")
 S BARTTYP=BARTR(101,"I")
 I BARTTYP'=39,BARTTYP'=43,BARTTYP'=40,BARTTYP'=49,BARTTYP'=107 Q 0
 I BARTR(103)["ERROR" Q 1
 Q 0
EXTRACT(BARBL) ;
 N BAR0,BAR1
 S BAR0=$G(^BARBL(DUZ(2),BARBL,0))  ; A/R Bill 0 node
 S BAR1=$G(^BARBL(DUZ(2),BARBL,1))  ; A/R Bill 1 node
 S BAR("V")=$P(BAR1,U,14)           ; Visit type (3P Visit Type)
 S BARTR("L")=$P(BAR1,U,8)          ; Visit location (A/R Parent/Sat)
 S BARTR("D")=$P(BAR1,U,2)          ; DOS Begin
 S BARTR("C")=$P(BAR1,U,12)         ; Clinic  (Clinic Stop File)
 Q
ISNONBEN(BARTR) ;BAR*1.8*24
 N BAR1,BARPAT,BARTR0,BARBL
 S BARTR0=$G(^BARTR(DUZ(2),BARTR,0))
 S BARBL=$P(BARTR0,U,4) I BARBL="" Q 0
 S BAR1=$G(^BARBL(DUZ(2),BARBL,1))  ; A/R Bill 1 node
 S BARPAT=$P(BAR1,U,1)          ; Patient (Patient file)
 I BARPAT="" Q 0                ; <SUBSCRIPT>ISNONBEN+6^BARRNBRA 4/8/14
 I $P($G(^AUPNPAT(BARPAT,11)),U,12)="I" Q 1 ;Not eligible = > is non-ben
 Q 0
 ;------EOR----------
