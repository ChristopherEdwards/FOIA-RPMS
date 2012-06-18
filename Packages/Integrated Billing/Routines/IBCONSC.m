IBCONSC	;ALB/MJB,SGD,AAS,RLW - NSC W/INSURANCE OUTPUT  ;06 JUN 88 13:51
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;
	;
INP	; Entry point for Inpatient Admission report
	S IBINPT=1,IBSUB="AMV1" G EN1
	;
INPDIS	; Entry point for Inpatient Discharge report
	S IBINPT=2,IBSUB="AMV3" G EN1
	;
EN	; Entry point for Outpatient report
	S IBINPT=0,IBSUB=""
EN1	;
	;***
	;S XRTL=$ZU(0),XRTN="IBCONSC-1" D T0^%ZOSV ;start rt clock
	I '$D(DT) D DT^DICRW
	K ^TMP($J)
	;
DATE	; Issue prompts for Begin and End dates
	S %DT="AEPX",%DT("A")="Start with DATE: " D ^%DT G Q:Y<0 S IBBEG=Y
DATE1	S %DT="EPX" R !,"Go to DATE: ",X:DTIME S:X=" " X=IBBEG G Q:(X="")!(X["^")
	D ^%DT G DATE1:Y<0 S IBEND=Y I Y<IBBEG W *7," ??",!,"ENDING DATE must follow BEGINNING DATE." G DATE1
	;I IBBEG>DT W " ??" G DATE1
	;
ASKDIV	; Issue prompt for Division
	D PSDR^IBODIV G:Y<0 Q
	;
SORT	; Select Billed, Unbilled, or All episodes for insured patients
	S DIR(0)="S^1:UNBILLED;2:BILLED;3:ALL",DIR("A")="PRINT LISTING",DIR("B")="UNBILLED",DIR("?")="Select whether you would like to print just the Unbilled list or the Billed list or ALL"
	D ^DIR S IBSORT=Y K DIR
	G:$D(DIRUT) Q
	;
RNB	; -- ask if should print those flagged with Reason not billable
	W !
	S DIR(0)="Y",DIR("A")="Print entries already flagged as not billable",DIR("B")="NO"
	S DIR("?")="Answer 'YES' if you want episodes already flagged as not billable printed on the report along with the reason.  Answer 'NO' if you do not want to see those already flagged."
	D ^DIR S IBRNB=Y K DIR ; ibrnb=1 means print on list with reason, =0 means don't print
	G:$D(DIRUT) Q
	;
TERM	; Sort by Patient Name or Terminal Digit?
	R !!,"Sort by (P)atient Name or (T)erminal Digit: P// ",X:DTIME G:X="^"!('$T) Q S:X="" X="P" S X=$E(X)
	I "PTpt"'[X D  G TERM
	. W !!?5,"Enter: '<CR>'  -  To sort the output by patient name."
	. W !?14,"'T'   -  To sort the output by Terminal Digit."
	. W !?23,"The output will be sorted by the 8th and 9th digits,"
	. W !?23,"and then the 6th and 7th digits of the patient's SSN."
	. W !?14,"'^'   -  To quit this option.",!
	W $S("Pp"[X:"   PATIENT NAME",1:"   TERMINAL DIGIT") S IBTERM="Tt"[X
	;
DEV	; -- ask device
	W !!,*7,"*** Margin width of this output is 132 ***"
	W !,"*** This output should be queued ***"
	S %ZIS="QM" D ^%ZIS G:POP Q
	I $D(IO("Q")) K IO("Q") D  G Q
	.S ZTRTN="BEGIN^IBCONSC",ZTSAVE("IB*")="",ZTSAVE("VAUTD")="",ZTSAVE("VAUTD(")=""
	.S ZTDESC="IB - Patients with Insurance and "_$S('IBINPT:"Outpatient ",IBINPT=1:"Admissions",1:"Discharges")
	.D ^%ZTLOAD K ZTSK D HOME^%ZIS
	;
	U IO
	;***
	;I $D(XRT0) S:'$D(XRTN) XRTN="IBCONSC" D T1^%ZOSV ;stop rt clock
	;
	;
BEGIN	; Background job main entry point.  Set up the report header.
	;***
	;S XRTL=$ZU(0),XRTN="IBCONSC-2" D T0^%ZOSV ;start rt clock
	S B="",IBL="",$P(IBL,"=",IOM)="",Y=IBBEG X ^DD("DD")
	S IBHD="*Veterans with Reimbursable Insurance and "_$S('IBINPT:"OUTPATIENT Appointments",1:"INPATIENT "_$S(IBINPT=2:"Discharges",1:"Admissions"))_" for the "
	S IBHD=IBHD_$S(IBBEG'=IBEND:"period covering ",1:"")_Y
	I IBBEG<IBEND S Y=IBEND X ^DD("DD") S IBHD=IBHD_" through "_Y
	K %DT S X="N",%DT="T" D ^%DT X ^DD("DD") S IBDATE=Y K %DT
	S IBTRKR=$G(^IBE(350.9,1,6)),IBQUIT=0
	;
	; Compile data for the report
	D @($S(IBINPT:"LOOP1",1:"LOOP2")_"^IBCONS2")
	G:IBQUIT Q
	;
	; Print the report
	S X=132 X ^%ZOSF("RM") D LOOP25^IBCONS1
	;
Q	; Clean up variables and close the output device.
	W !
	I $D(ZTQUEUED) S ZTREQ="@" Q
	D ^%ZISC
	K %,%DT,B,I,I1,II,J,K,L,M,N,X,X1,X2,Y,C,DFN,IBCNT,IBIFN,IBBILL,IBSORT,IBFORMFD
	K IBFLAG,IBI,IBDT,IBPAGE,IBL,IBHD,IBBEG1,IBBEG,IBEND,IBSTOP
	K IBTRKR,IBOE,IBRNB,IBADMVT,IBETYP,IBRMARK,IBQUIT
	K IBINPT,IBPGM,IBVAR,IBFLAG,IBNAME,IBAPPT,IBDC,IBDAT,IBDFN,IBTERM,IBQUIT
	K POP,^TMP($J),IBDV,IBSUB,VAUTD,IBINDT,IBINS,IBDATE,IBFL,PTF,IBSC,IBMOV
	;***
	;I $D(XRT0) S:'$D(XRTN) XRTN="IBCONSC" D T1^%ZOSV ;stop rt clock
	Q
