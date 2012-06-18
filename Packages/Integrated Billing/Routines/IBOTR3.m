IBOTR3	;ALB/CPM - INSURANCE PAYMENT TREND REPORT - OUTPUT ; 5-JUN-91
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;
	;MAP TO DGCROTR3
	;
	S (IBQUIT,IBPAG)=0,IBLINE="",$P(IBLINE,"-",IOM)="",Y=DT D D^DIQ S IBTDT=Y
	I $D(IBAF) D ADDFLD^IBOTR4
	I '$D(^TMP($J,"IBOTR")) D  S IBCALC=3 D PAUSE G END
	. S IBX=$S("bB"'[IBBRT:IBBRT,IBBRN="C":"A",1:"I")
	. D HDR W !!,"  NO INFORMATION MATCHES SELECTION CRITERIA."
	; 
	S IBX="" F  S IBX=$O(^TMP($J,"IBOTR",IBX)) Q:IBX=""  S IBTT="0^0^0^0" D HDR Q:IBQUIT  D INS Q:IBQUIT
END	K ^TMP($J),IBQUIT,IBINS,IBPAG,IBLINE,IBTDT,IBX,IBTT,IBTI,IBCALC,IBBN,IBD,X,X1,X2,IBAFT,IBI
	Q
	;
INS	; Loop through each Insurance company.
	S IBINS="" F  S IBINS=$O(^TMP($J,"IBOTR",IBX,IBINS)) Q:IBINS=""  S IBTI="0^0^0^0" D BILLNO Q:IBQUIT
	D:'IBQUIT GTOT^IBOTR4 ; Write grand totals for Inpt/Outpt report.
	Q
	;
BILLNO	; Loop through all bills for an Insurance company.
	I $Y>(IOSL-11) S IBCALC=11 D PAUSE Q:IBQUIT  D HDR Q:IBQUIT
	D INSADD S IBBN=""
	F  S IBBN=$O(^TMP($J,"IBOTR",IBX,IBINS,IBBN)) Q:IBBN=""  S IBD=^(IBBN) D DETAIL Q:IBQUIT
	D:'IBQUIT SUBTOT^IBOTR4 ; Write sub-totals for each insurance company.
	Q
	;
DETAIL	; Write out detail lines.
	N IBPEN S IBPEN=$S($P(IBBN,"@@",2)["*":0,1:$P(IBD,"^",6)-$P(IBD,"^",7))
	I $Y>(IOSL-3) S IBCALC=3 D PAUSE Q:IBQUIT  D HDR Q:IBQUIT  D INSADD
	W !,$P(IBBN,"@@",2),?10,$P(IBBN,"@@"),?34,$$DATE($P(IBD,"^",2)),?44,$$DATE($P(IBD,"^",3))
	W ?54,$$DATE($P(IBD,"^",4)),?64,$$DATE($P(IBD,"^",5))
	S X1=$P(IBD,"^",5),X2=$P(IBD,"^",4) D ^%DTC W ?75,$J(X,4)
	W ?80,$J($P(IBD,"^",6),9,2),?90,$J($P(IBD,"^",7),9,2)
	W ?101,$J($P(IBD,"^",6)-$P(IBD,"^",7),9,2),?111,$J(IBPEN,9,2)
	W ?123,$J($S(+$P(IBD,"^",6)=0:0,1:$P(IBD,"^",7)/$P(IBD,"^",6)*100),6,2)
	S $P(IBTI,"^")=$P(IBTI,"^")+1,$P(IBTI,"^",2)=$P(IBTI,"^",2)+$P(IBD,"^",6),$P(IBTI,"^",3)=$P(IBTI,"^",3)+$P(IBD,"^",7),$P(IBTI,"^",4)=$P(IBTI,"^",4)+IBPEN
	S $P(IBTT,"^")=$P(IBTT,"^")+1,$P(IBTT,"^",2)=$P(IBTT,"^",2)+$P(IBD,"^",6),$P(IBTT,"^",3)=$P(IBTT,"^",3)+$P(IBD,"^",7),$P(IBTT,"^",4)=$P(IBTT,"^",4)+IBPEN
	Q
	;
HDR	; Print the report header.
	S IBPAG=IBPAG+1 W:$E(IOST,1,2)["C-"!(IBPAG>1) @IOF W IBRTN," PAYMENT TREND REPORT  --  "
	W $S(IBX="I":"INPATIENT",IBX="O":"OUTPATIENT",1:"COMBINED INPATIENT AND OUTPATIENT")," BILLING"
	W ?105,IBTDT,"   PAGE: ",IBPAG
	W !?6,IBDFN,":  ",$$DATE(IBBDT),"  -  ",$$DATE(IBEDT),?57,"Note: '*' after the Bill Number denotes a CLOSED bill"
	W:$D(IBAF) !?6,IBAFT
	W !,"BILL",?10,"PATIENT",?55,"DATE",?64,"DATE BILL",?76,"#"
	W ?82,"AMOUNT",?91,"AMOUNT",?103,"AMOUNT",?112,"AMOUNT",?122,"PERCENT"
	W !,"NUMBER",?10,"NAME/ (AGE)",?34,"BILL FROM  -  TO",?54,"PRINTED"
	W ?65,"CLOSED",?75,"DAYS",?82,"BILLED",?90,"COLLECTED",?103,"UNPAID"
	W ?112,"PENDING",?122,"COLLECTED",!,IBLINE
	S IBQUIT=$$STOP^IBOUTL("Trend Report")
	Q
	;
DATE(IBX)	S:IBX]"" IBX=$E(IBX,4,5)_"/"_$E(IBX,6,7)_"/"_$E(IBX,2,3) Q IBX
	;
PAUSE	Q:$E(IOST,1,2)'="C-"
	F IBI=$Y:1:(IOSL-IBCALC) W !
	S DIR(0)="E" D ^DIR K DIR I $D(DIRUT)!($D(DUOUT)) S IBQUIT=1 K DIRUT,DTOUT,DUOUT
	Q
	;
INSADD	; Display Insurance Company name and address.  Input:  IBINS
	N D,IEN
	W !!?8,"PRIMARY INSURANCE CARRIER:  ",$P(IBINS,"@@")
	S IEN=$P(IBINS,"@@",2) G:'IEN INSADDQ
	S D=$G(^DIC(36,IEN,.11)) G:D="" INSADDQ
	W:$P(D,"^")]"" !?36,$P(D,"^")
	W:$P(D,"^",2)]"" !?36,$P(D,"^",2)
	W:$P(D,"^",3)]"" !?36,$P(D,"^",3)
	W:$P(D,"^")]""!($P(D,"^",2)]"")!($P(D,"^",3)]"") !?36
	W $P(D,"^",4) W:$P(D,"^",4)]""&($P(D,"^",5)]"") ", "
	W $P($G(^DIC(5,+$P(D,"^",5),0)),"^")
	W:$P(D,"^",6)]""&($P(D,"^",4)]""!($P(D,"^",5)]"")) "   "
	W $P(D,"^",6)
INSADDQ	W ! Q
