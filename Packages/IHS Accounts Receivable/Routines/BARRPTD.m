BARRPTD ; IHS/SD/PKD - Payment Summary Report by TDN or Date Range ;05/25/2010
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**19**;OCT 26, 2005
 ; 
 ; IHS/SD/PKD - 05/25/10 - V1.8*19  Based on BARRPRP
 Q
 ; *********************************************************************
 ;
EN ; EP
 N TOTFIL,TCT,STR,LOC,LINE,QUIT,DUZ2
 N BARTOT,BARTOT2,BARTOLD,BARSRT,BARSAT,BARIEN,BARLTOT
 N BARGRDT,BARDASH,BARASK,SORT1,SORT2,SORTKEY,FILEHDR
 D:'$D(BARUSR) INIT^BARUTL         ; Setup basic A/R variables
 S DUZ2=DUZ(2)
 K ^TMP($J,"BAR-PTD")
 S BARQ("RC")="COMPUTE^BARRPTD"    ; Compute routine
 S BARQ("RP")="PRINT^BARRPTD2"      ; Print routine
 S BARQ("NS")="BAR"                ; Namespace for variables
 S BARQ("RX")="POUT^BARRUTL"       ; Clean-up routine
 S BARP("RTN")="BARRPTD"           ; Routine used to get data
 ;S BAR("PRIVACY")=1                ; Privacy act applies
 S BAR("LOC")="BILLING"            ; Location is ALWAYS billing
SLCT D ^BARRSEL                      ; Select exclusion parameters
 Q:X="^"!$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 I '$D(BARY("DT"))&('$D(BARY("TDN"))) W *7,!!,?10,"*** Dates or TDN's Required ***" G SLCT
 I $D(BARY("DT"))
 S LOC=DUZ(2)
 S DUZ(2)=DUZ2
 I $D(DTOUT)!$D(DUOUT)!$D(DIROUT) Q
 ;
 ; Select entry of DATE RANGE or List of TDN's
SEL  ;
 K DIR ;
 N BARTEXT
 S DIR("A")="Output to Text Delimited File? "
 S DIR(0)="Y;;"
 S DIR("B")="N"
 D ^DIR
 I $D(DTOUT)!$D(DUOUT)!$D(DIROUT) Q
 S BARTEXT=Y
 K DIR
 ;
 I BARTEXT D ^%ZIS  D COMPUTE Q
 U IO
 D ^BARDBQUE                       ; Double queuing
PAZ D POUT^BARRUTL  ;D PAZ^BARRUTL
 Q
 ; *********************************************************************
QUE  ; EP
 K IO("Q")
 S ZTRTN="COMPUTE^BARRPTD",ZTDESC="TDN SUMMARY REPORT"
 S ZTSAVE("BAR*")=""
 D ^%ZTLOAD
 I $D(ZTSK)[0 W !!?5,"REPORT CANCELLED!"
 E  W !!?5,"REQUEST QUEUED AS TASK # "_ZTSK,!
 Q
 ;
DATES  ;
 ; Ask Collection Batch Open Date Range
 W !!," ============ Entry of COLLECTION BATCH DATE Range =============",!
 K BARY("TDN")  ; Dates **OR** TDN's
 S BARSTART=$$DATE^BARDUTL(1)
 I BARSTART<1 Q
 I BARSTART>DT W *7,!,"Future dates invalid.  Please re-enter." G DATES
 S BAREND=$$DATE^BARDUTL(2)
 I BAREND<1 W ! G DATES
 I BAREND<BARSTART!(BAREND>DT) D  G DATES
 .W *7
 .W !!,"The END date must not be before the START date, or Future Date.",!
 S BARY("DT",1)=BARSTART
 S BARY("DT",2)=BAREND
 S BAREND=BAREND+.9
 S BARY("DT")="CB"
 Q
 ; ********************************************************************
 ;
COMPUTE ; EP BY Date Range
 ; Find bills matching criteria and store in ^TMP($J,"BAR-PTD")
 K ^TMP($J,"BAR-PTD")
 ; Collection batch by Date Range
 ; Sort by Loc/Date/TDN/Collection Batch
 I BARSRT=1 D DTS
 I BARSRT=2 D TDN
 I BARTEXT D
 . D PRINT^BARRPTD2,POUT^BARRUTL
 . N TP S TP="C IO U 0" X TP
 Q
 ;
DTS S BARDT=BARSTART-1  ; DATE.TIME
 F  S BARDT=$O(^BARCOL(DUZ(2),"C",BARDT)) Q:((BARDT>BAREND)!(BARDT=""))  D
 . S SORT1=$P(BARDT,"."),BARGRDT=0
 . S BARIEN="" F  S BARIEN=$O(^BARCOL(DUZ(2),"C",BARDT,BARIEN)) Q:'BARIEN  D
 . . S GLODATA=$G(^BARCOL(DUZ(2),BARIEN,0)) Q:GLODATA=""
 . . N QUIT,VISLOC S QUIT=0
 . . S VISLOC=$P(GLODATA,U,8) I $D(BARY("LOC")) D  Q:QUIT
 . . . I BARY("LOC")'=VISLOC S QUIT=1
 . . S SORT2=$$GET1^DIQ(90051.01,BARIEN,28) I SORT2="" Q:SORT2=""  ; TDN/IPAC - Sort
 . . D DATA
 Q
 ; ********************************************************************
 ;
TDN  ; Pick-up all Collection batches w/ 1 TDN
 S (BARIEN,BARTDN)=""
 F  S BARTDN=$O(BARY("TDN",BARTDN)) Q:BARTDN=""  D
 . F  S BARIEN=$O(^BARCOL(DUZ(2),"E",BARTDN,BARIEN)) Q:BARIEN=""  D
 . . S GLODATA=$G(^BARCOL(DUZ(2),BARIEN,0)) Q:GLODATA=""
 . . N QUIT,VISLOC S QUIT=0
 . . S VISLOC=$P(GLODATA,U,8) I $D(BARY("LOC")) D  Q:QUIT
 . . . I BARY("LOC")'=VISLOC S QUIT=1
 . . S SORT2=+$P(GLODATA,"^",4) ; Date Used for sort in ^TMP
 . . S SORT1=$$GET1^DIQ(90051.01,BARIEN,28)  ; Get the TDN/IPAC - use for Sort
 . . D DATA
 Q
 ; ********************************************************************
 ;
DATA ;
 ; Collect data for report
 K BARB
 S BARB("NAME")=$P(^BARCOL(DUZ(2),BARIEN,0),U)  ;Collection batch name
 S BARB("AMT")=$$GET1^DIQ(90051.01,BARIEN,15)  ; Batched amount
 S BARB("PST")=$$GET1^DIQ(90051.01,BARIEN,16)  ; Batch posted amount
 S BARB("UPST")=$$GET1^DIQ(90051.01,BARIEN,17)  ; Batch unposted amount
 S BARB("UNALL")=$$GET1^DIQ(90051.01,BARIEN,23)  ; True Unallocated 
 S BARB("RFND")=$$GET1^DIQ(90051.01,BARIEN,22)  ; Batch Refunded
 S BARB("XFR")=$$GET1^DIQ(90051.01,BARIEN,560)  ; Transfer Amount
 ; will save in string STR as: 15/16/23/22/560/17
 ; GrandTotalBatchedAmount:16
 S STR=BARB("AMT")_","_BARB("PST")_","_BARB("UNALL")_","_BARB("RFND")_","_BARB("XFR")_","_BARB("UPST")
 S ^TMP($J,"BAR-PTD",VISLOC,SORT1,SORT2,BARB("NAME"))=STR
 S TOTFIL="^TMP($J,""BAR-PTD"",VISLOC)"  D TOTALS(TOTFIL)  ; Location totals
 S TOTFIL="^TMP($J,""BAR-PTD"")" D TOTALS(TOTFIL)  ; Grand Totals
 Q
 ; ********************************************************************
 ;
TOTALS(TOTFIL) ; Accumulate Totals 
 S BARTOLD=$G(@TOTFIL)
 S $P(BARTOLD,U)=$P(BARTOLD,U)+1  ;counter
 ; STR doesn't include a counter, SO piece in STR is 1 less
 S $P(BARTOLD,U,2)=$P(BARTOLD,U,2)+$P(STR,",",1)
 S $P(BARTOLD,U,3)=$P(BARTOLD,U,3)+$P(STR,",",2)
 S $P(BARTOLD,U,4)=$P(BARTOLD,U,4)+$P(STR,",",3)
 S $P(BARTOLD,U,5)=$P(BARTOLD,U,5)+$P(STR,",",4)
 S $P(BARTOLD,U,6)=$P(BARTOLD,U,6)+$P(STR,",",5)
 S $P(BARTOLD,U,7)=$P(BARTOLD,U,7)+$P(STR,",",6)
 S @TOTFIL=BARTOLD
 Q
 ;
