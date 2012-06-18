IBOTR1	;ALB/CPM - INSURANCE PAYMENT TREND REPORT - USER INTERFACE (CON'T.); 5-JUN-91
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;
	;MAP TO DGCROTR1
	;
OUTPT	R !,"Select (I)NPATIENT, (O)UTPATIENT, or (B)OTH BILL RECORDS: BOTH// ",X:DTIME G:'$T!(X["^") END S:X="" X="B" S X=$E(X)
	I "IOBiob"'[X S IBOFF=1 D HELP G OUTPT
	W $S("iI"[X:"  INPATIENT","oO"[X:"  OUTPATIENT","bB"[X:"  BOTH")
	S (IBBRT,IBBRTY)=$S("iI"[X:"I","oO"[X:"O",1:"A") I "Bb"'[X G ARST
	;
REPTY	R !,"Print a (C)ombined or (S)eparate Reports: C// ",X:DTIME G:'$T!(X["^") END S:X="" X="C" S X=$E(X)
	I "CScs"'[X S IBOFF=7 D HELP G REPTY
	W $S("cC"[X:"  COMBINED","sS"[X:"  SEPARATE") S IBBRN=$S("cC"[X:"C",1:"S")
	;
ARST	R !,"Select (O)PEN, (C)LOSED, or (B)OTH TYPES OF BILLS: BOTH// ",X:DTIME G:'$T!(X["^") END S:X="" X="B" S X=$E(X)
	I "OCBocb"'[X S IBOFF=29 D HELP G ARST
	W $S("oO"[X:"  OPEN","cC"[X:"  CLOSED","bB"[X:"  BOTH"),!
	S IBARST=$S("oO"[X:"O","cC"[X:"C",1:"A")
	;
QDATE	S DIR(0)="SA^1:DATE BILL PRINTED;2:TREATMENT DATE",DIR("A")="Print Report by (1) DATE BILL PRINTED or (2) TREATMENT DATE: ",DIR("B")="1",DIR("T")=20,DIR("?")="^S IBOFF=24 D HELP^IBOTR1"
	D ^DIR K DIR G:Y=""!(X="^") END S IBDF=X,IBDFN=Y(0)
BEGDT	S %DT="AEPX",%DT("A")="   START WITH "_IBDFN_": " D ^%DT K %DT G:Y<0 END S IBBDT=Y
	S %DT="AEPX",%DT("A")="   GO TO "_IBDFN_": " D ^%DT K %DT G:Y<0 END
	S IBEDT=Y I Y<IBBDT W *7,!!,"      The END DATE must follow the BEGIN DATE.",! G BEGDT
	;
INSO1	W !,"      START WITH INSURANCE COMPANY: FIRST// " R X:DTIME G:'$T!(X["^") END
	I $E(X)="?" S IBOFF=12 D HELP G INSO1
	S IBICF=X
INSO2	W !,"      GO TO INSURANCE COMPANY: LAST// " R X:DTIME G:'$T!(X["^") END
	I $E(X)="?" S IBOFF=18 D HELP G INSO2
	I X="" S IBICL="" S:IBICF="" IBIC="ALL" G SELPRNT
	I X="@",IBICF="@" S IBICL="@",IBIC="NULL" G SELPRNT
	I IBICF'="@",IBICF]X W *7,!!,"       The LAST value must follow the FIRST.",! G INSO2
	S IBICL=X
	;
SELPRNT	W !!,"You will need a 132 column printer for this report!"
	S %ZIS="QM" D ^%ZIS G:POP END
	I $D(IO("Q")) D  G END
	.S ZTRTN="^IBOTR2",ZTDESC="INSURANCE PAYMENT TREND REPORT",ZTSAVE("IB*")=""
	.D ^%ZTLOAD W !!,$S($D(ZTSK):"This job has been queued.  The task number is "_ZTSK_".",1:"Unable to queue this job.")
	.K ZTSK,IO("Q") D HOME^%ZIS
	U IO
	;***
	;I $D(XRT0) S:'$D(XRTN) XRTN="IBOTR1" D T1^%ZOSV ;stop rt clock
	D ^IBOTR2 ;Compile and print report
END	Q
	;
	;
HELP	W ! F  S IBTEXT=$P($T(TEXT+IBOFF),";",3) Q:IBTEXT=""  W !,IBTEXT S IBOFF=IBOFF+1
	W:IBOFF<24!(IBOFF>29) ! Q
	;
TEXT	;  'Select INPATIENT... ' prompt
	;;      Enter:  '<CR>' -  To select both Inpatient and Outpatient bills
	;;              'I'    -  To select only Inpatient bills
	;;              'O'    -  To select only Outpatient bills
	;;              '^'    -  To quit this option
	;
	;  '(C)ombined or (S)eparate report' prompt
	;;      Enter:  '<CR>' -  To print a report of both Inpatient and Outpatient bills
	;;              'S'    -  To print separate Inpatient and Outpatient reports
	;;              '^'    -  To quit this option
	;
	;  'Start with INSURANCE COMPANY' prompt
	;;      Enter a valid field value up to 40 characters, or
	;;              '@'    -  To include null values
	;;              '<CR>' -  To start from the 'first' value for this field
	;;              '^'    -  To quit this option
	;
	;  'Go to INSURANCE COMPANY' prompt
	;;      Enter a valid field value up to 40 characters, or
	;;              '@'    -  To include only null values, if 'Start with' value is @
	;;              '<CR>' -  To go to the 'last' value for this field
	;;              '^'    -  To quit this option
	;
	;  'Print report by ...' prompt
	;;      Enter:  '<CR>' -  To select bills by the Bill Printed Date
	;;              '2'    -  To select bills by the Treatment Date
	;;              '^'    -  To quit this option
	;
	;  'Select (C)LOSED, (O)PEN... ' prompt
	;;      Enter:  '<CR>' -  To select both Open and Closed bills
	;;              'O'    -  To select only Open bills
	;;              'C'    -  To select only Closed bills
	;;              '^'    -  To quit this option
	;
