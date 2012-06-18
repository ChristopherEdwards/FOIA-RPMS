IBOSTUS	;ALB/SGD - MCCR BILL STATUS REPORT ;25 MAY 88 14:19
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;
	;MAP TO DGCROST
	;
	;***
	;S XRTL=$ZU(0),XRTN="IBOSTUS-1" D T0^%ZOSV ;start rt clock
	N IBDTP ; date type chosen for sorting
	I '$D(DT) D DT^DICRW
YN	W !!,"DO YOU WANT TO PRINT THE STATUS OF ALL BILLS" S %=1 D YN^DICN G Q:%=-1 S:%=1 IBBST="ALL" G SORT:%=1 I %=0 W !,"CHOOSE Y (YES) OR N (NO)" G YN
CHOOSE	S Z="^ENTERED/NOT REVIEWED^REVIEWED^AUTHORIZED^PRINTED^CANCELLED" R !!,"CHOOSE A BILL STATUS: ",X:DTIME G HELP:X["?" G Q:(X["^")!(X="") D IN^DGHELP S IBBST=$E(X,1) I %=-1 W *7," ??" G HELP
	S IBHD2=$S(IBBST="A":"AUTHORIZED",IBBST="E":"ENTERED/NOT REVIEWED",IBBST="R":"REVIEWED",IBBST="P":"PRINTED",IBBST="C":"CANCELLED",1:"")
SORT	; chose the date type to sort on
	S DIR(0)="S^1:EVENT DATE;2:BILL DATE;3:ENTERED DATE"
	S DIR("A")="SORT BY",DIR("B")=1,DIR("?")="^D HELP2^IBOSTUS"
	D ^DIR K DIR Q:$D(DIRUT)
	S IBDTP=$S(Y=1:"Event",Y=2:"Bill",Y=3:"Entered",1:"") Q:IBDTP=""
DATE	W ! S %DT="AEPX",%DT("A")="Start with "_IBDTP_" DATE: ",%DT(0)=-DT D ^%DT G Q:Y<0 S IBBEG=Y
DATE1	S %DT="EPX" W !,"Go to "_IBDTP_" DATE: TODAY// " R X:DTIME S:X=" " X=IBBEG G Q:(X["^") S:X="" X="TODAY" D ^%DT G DATE1:Y<0 S IBEND=Y I IBEND<IBBEG W *7," ??",!,"ENDING DATE must follow BEGINNING DATE." G DATE1
	I IBEND>DT W *7," ??" G DATE1
	;
	W !!,*7,"*** Margin width of this output is 132 ***"
	;S DGPGM="QUEUED^IBOSTUS",DGVAR="IBDTP^IBBST^IBHD2^IBBEG^IBEND^DUZ" D ZIS^DGUTQ G Q:POP
	;
	S %ZIS="QM" D ^%ZIS G:POP Q
	I $D(IO("Q")) K IO("Q") D  G Q
	.S ZTRTN="QUEUED^IBOSTUS",ZTDESC="IB - Bill Status Report",ZTSAVE("IB*")=""
	.D ^%ZTLOAD K ZTSK D HOME^%ZIS
	;
	U IO
	;***
	;I $D(XRT0) S:'$D(XRTN) XRTN="IBOSTUS" D T1^%ZOSV ;stop rt clock
QUEUED	; entry point if queued
	;***
	;S XRTL=$ZU(0),XRTN="IBOSTUS-2" D T0^%ZOSV ;start rt clock
	;
	; K ^TMP($J)
	; D:IBDTP="Entered" INDX ; DATE ENTERED is not cross-referenced
	G BEGIN^IBOSTUS1
	;
Q	K %,I,J,X,X1,X2,Y,Z,IBIFN,%DT,IBAPP,POP,IBPAGE,DGPGM,DGVAR,IBNEX,IBF,IBBEG,IBEND,IBHD,IBHD2,IBL,IBL1,IBBST,IBBS,IBBSBY,IBBSDT,IB0,IBS
	I '$D(ZTQUEUED) D ^%ZISC
	;***
	;I $D(XRT0) S:'$D(XRTN) XRTN="IBOSTUS" D T1^%ZOSV ;stop rt clock
	Q
	;
HELP	W !!,"CHOOSE FROM: ","ENTERED/NOT REVIEWED",!?13,"REVIEWED",!?13,"AUTHORIZED",!?13,"PRINTED",!?13,"CANCELLED" G CHOOSE
	Q
HELP2	; help for SORT BY:
	W !!,"   EVENT DATE is the date beginning the bill's episode of care"
	W !!,"   BILL DATE is the date the bill was initially printed"
	W !!,"   ENTERED DATE is the date the bill was first entered"
	Q
INDX	; creates a temporary index of bills sorted by bill date=initial printed
	N D S IBNEX=0 F  S IBNEX=$O(^DGCR(399,IBNEX)) Q:'IBNEX  S D=$P($G(^DGCR(399,IBNEX,"S")),"^",1) D:D&(D'<(IBBEG\1))&(D'>(IBEND\1_.2359))
	.S ^TMP($J,"ENTERED",D,IBNEX)=""
	Q
STATS	; prints statistics
	S IBHDR3="REPORT STATISTICS" D HEAD^IBOSTUS1
	S IBST1="RATE TYPE  : "
	S IBST2="BILL STATUS: "
	F I="IBST1","IBST2" N IBTOT D  W:'IBCRT !!!!
	.S IBCAT="" F  W ! S IBCAT=$O(@I@(IBCAT)) Q:IBCAT=""  D
	..I IBCRT,($Y>(IOSL-2)) D HEAD^IBOSTUS1
	.. S X=@I@(IBCAT,"$"),X2="2$" D COMMA^%DTC
	..W !,IBCAT,?18,".................... ",?42,$J(X,15),?60,$J(@I@(IBCAT,"C"),6),?67," BILLS"
	..S IBTOT("C")=$G(IBTOT("C"))+@I@(IBCAT,"C")
	..S IBTOT("$")=$G(IBTOT("$"))+@I@(IBCAT,"$")
	.W !,?40,"-----------------",?60,"-------------"
	.S X=$G(IBTOT("$")),X2="2$" D COMMA^%DTC
	.W !?42,$J(X,15),?60,$J($G(IBTOT("C")),6),?67," BILLS"
	Q
