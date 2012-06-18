IBCONS1	;ALB/AAS - NSC PATIENTS W/ INS BACKGROUND PRINTS ; 7 JUN 90
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;
	;MAP TO DGCRONS1
	;
EN	; Inpatient Discharge entry to que background once weekly
	S IBINPT=2,IBSUB="AMV3" G QUEUE
	;
EN1	; Inpatient Admission entry to que background once weekly
	S IBINPT=1,IBSUB="AMV1" G QUEUE
	;
EN2	; Outpatient entry to que background once weekly
	S IBINPT=0,IBSUB=""
	;
QUEUE	; Set up the background job to run for the previous week
	;   o  For All Divisions
	;   o  For Insured veterans with unbilled episodes of care
	;   o  With the output sorted by Terminal Digit
	;
	K ^TMP($J)
	S X="T",%DT="" D ^%DT S IBEND=+Y
	S X="T-7",%DT="" D ^%DT S IBBEG=+Y K %DT
	S (VAUTD,IBSORT,IBTERM,IBRNB)=1
	U IO G BEGIN^IBCONSC
	;
	;
LOOP25	; Print all NSC w/Insurance reports.
	S IBQUIT=0,IBFL=1,IBDV=""
	F  S IBDV=$O(^TMP($J,IBDV)) Q:IBDV=""  D LOOP3 Q:IBQUIT
	D:'IBQUIT PAUSE
	;
Q	K %,%DT,B,I,J,K,L,M,X,X1,X2,Y,DFN,IBCNT,IBIFN,IBBILL,IBDATE,IBFLAG,IBI,IBDT,IBPAGE,IBL,IBHD,IBBEG1
	K IBBEG,IBEND,IBINPT,IBFLAG,IBNAME,IBAPPT,IBDC,IBDAT,IBDFN,POP,^TMP($J)
	;I '$D(ZTQUEUED) D ^%ZISC
	Q
	;
	;
LOOP3	; Loop through billed, unbilled, or both types of episodes of care.
	F IBBILL=$S(IBSORT<3:IBSORT,1:1):1:$S(IBSORT<3:IBSORT,1:2) S IBNAME="",IBPAGE=0 K IBFLAG D HEAD Q:IBQUIT  D LOOP31 Q:IBQUIT
	Q
	;
LOOP31	; Loop through each name or terminal digit (and associated DFN).
	F  S IBNAME=$O(^TMP($J,IBDV,IBBILL,IBNAME)) D  Q:IBNAME=""!(IBQUIT)
	. I IBNAME="",'$D(IBFLAG) W !!,"No matches found.",!
	. Q:IBNAME=""
	. S DFN=0 F  S DFN=$O(^TMP($J,IBDV,IBBILL,IBNAME,DFN)) Q:'DFN  D LOOP4 Q:IBQUIT  W !
	Q
	;
LOOP4	; Loop through each episode of care for a patient.
	S IBDAT="" F I=0:0 S IBDAT=$O(^TMP($J,IBDV,IBBILL,IBNAME,DFN,IBDAT)) Q:IBDAT=""!(IBQUIT)  D PRINT I $Y>$S($D(IOSL):(IOSL-6),1:6) W ! D HEAD Q:IBQUIT
	Q
	;
PRINT	; Print each detail line.
	I '$G(IBRNB),$D(^TMP($J,IBDV,IBBILL,IBNAME,DFN,IBDAT,2)) Q  ; if reason not billable, and don't print if not billable quit
	S IBFLAG=1 D PID^VADPT6
	W !,VA("BID"),?6,$E($P(^DPT(DFN,0),"^"),1,20),?28,VA("PID"),?42,$E($P($G(^DIC(8,+$G(^(.36)),0)),"^",6),1,16) K VA,VAERR
	S Y=IBDAT X ^DD("DD") W ?60,Y
	;
	; -- print insurance, use ibcns1 calls
	S X=$$INSP(DFN,IBDAT) W ?82,X
	;
	;S IBCNT=0 F II=0:0 S II=$O(^DPT(DFN,.312,II)) Q:'II  S IBCNT=IBCNT+1,X=+^(II,0) D
	;. I $D(^DIC(36,X,0)) W:IBCNT=2!(IBCNT=3) ", " W:IBCNT<4 $E($P(^(0),"^"),1,14) W:IBCNT=4 " " W:IBCNT>3 "*"
	;
	; -- print reason not billable
	I $G(^TMP($J,IBDV,IBBILL,IBNAME,DFN,IBDAT,2))]"" W ?115,$E(^(2),1,16)
	;
	S X=$G(^TMP($J,IBDV,IBBILL,IBNAME,DFN,IBDAT,1))
	I X]"" W !?10,$P(X,"^") I $P(X,"^",2)]"" W " with " F IBDC=2:1 Q:$P(X,"^",IBDC)=""  W $P(X,"^",IBDC),", "
	S X=^TMP($J,IBDV,IBBILL,IBNAME,DFN,IBDAT) Q:'$L(X)  F K=1:1 S IBIFN=$P(X,"^",K) Q:IBIFN=""  D PRINT1
	Q
	;
PRINT1	; If an episode of care has been billed, display billing information.
	D GVAR^IBCBB
	W !?10,$P(^DGCR(399,IBIFN,0),"^"),?20,$P($G(^DGCR(399.3,+IBAT,0)),"^",4),"-",$S(IBCL<3:"INPT",IBCL>2:"OUTP",1:"")
	W ?37,"From: ",$E(IBFDT,4,5)_"/"_$E(IBFDT,6,7)_"/"_$E(IBFDT,2,3)
	W ?55,"To: ",$E(IBTDT,4,5)_"/"_$E(IBTDT,6,7)_"/"_$E(IBTDT,2,3)
	W ?78,"Debtor: "
	I IBWHO="i",$D(^DIC(36,+IBNDM,0)) W $P(^(0),"^")
	I IBWHO="o",$D(^DIC(4,+$P(IBNDM,"^",11),0)) W $P(^(0),"^")
	I IBWHO="p" W $P(^DPT(DFN,0),"^")
	D END^IBCBB1 Q
	;
HEAD	; Print header; don't pause on first pass through.
	I $D(ZTQUEUED),$$S^%ZTLOAD S (ZTSTOP,IBQUIT)=1 Q
	D:'IBFL PAUSE Q:IBQUIT  S IBFL=0
	S IBPAGE=IBPAGE+1
	; -- ibformfd = skip only intial form feed, need ffs for each div.
	I $E(IOST,1,2)["C-"!(IBPAGE>1)!($G(IBFORMFD)) W @IOF
	S IBFORMFD=1
	W IBHD,!,$S(IBBILL=2:"PREVIOUSLY ",1:"UN"),"BILLED PATIENTS for Division ",$P($G(^DG(40.8,IBDV,0)),"^"),?80,"Printed: ",IBDATE,?118,"Page: ",IBPAGE
	W !,"PT ID PATIENT",?28,"SSN",?42,"ELIGIBILITY",?60,"DATE OF ",$S(IBINPT=2:"DISCHARGE",1:"CARE"),?82,"INSURANCE COMPANIES"
	W:IBRNB ?115,"NOT BILLABLE"
	W !,IBL
	Q
	;
INSP(DFN,IBDAT)	; -- print ins. company on report logic
	N X,IBDD,IBDDINS,IBCNT
	S IBCNT=0,IBDDINS=""
	I '$G(DFN)!('$G(IBDAT)) G INSPQ
	S IBDD="" D ALL^IBCNS1(DFN,"IBDD",1,IBDAT)
	S X=0 F  S X=$O(IBDD(X)) Q:'X!(IBCNT>2)  D
	.S IBCNT=IBCNT+1
	.I IBCNT>1 S IBDDINS=IBDDINS_","
	.S IBDDINS=IBDDINS_$E($P($G(^DIC(36,+$G(IBDD(X,0)),0)),"^"),1,10)
	S IBDDINS=$E(IBDDINS,1,30)
	I $G(IBDD(0))>3 S IBDDINS=IBDDINS_"*"
INSPQ	Q IBDDINS
	;
PAUSE	Q:$E(IOST,1,2)'="C-"
	F J=$Y:1:(IOSL-5) W !
	S DIR(0)="E" D ^DIR K DIR I $D(DIRUT)!($D(DUOUT)) S IBQUIT=1 K DIRUT,DTOUT,DUOUT
	Q
