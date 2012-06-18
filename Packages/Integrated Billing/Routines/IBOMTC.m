IBOMTC	;ALB/CPM - CATEGORY C BILLING ACTIVITY LIST ; 09-JAN-92
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;
	;***
	;S XRTL=$ZU(0),XRTN="IBOMTC-1" D T0^%ZOSV ;start rt clock
	;
	S:'$D(DTIME) DTIME=300 D HOME^%ZIS
	; Select Start and End dates.
BDT	S %DT="AEPX",%DT("A")="Start with DATE: " D ^%DT K %DT G END:Y<0 S IBBDT=Y
	I IBBDT<2901001 W !,"The Start Date cannot be earlier than 10/1/90.",! G BDT
EDT	S %DT="EX" R !,"Go to DATE: ",X:DTIME S:X=" " X=IBBDT
	G END:(X="")!(X["^") D ^%DT G EDT:Y<0 S IBEDT=Y
	I Y<IBBDT W *7," ??",!,"ENDING DATE must follow BEGINNING DATE." G BDT
	;
	; Select output device.
	S %ZIS="QM" D ^%ZIS G:POP END
	I $D(IO("Q")) D  G END
	.S ZTRTN="^IBOMTC1",ZTDESC="CATEGORY C BILLING ACTIVITY LIST"
	.S (ZTSAVE("IBBDT"),ZTSAVE("IBEDT"))=""
	.D ^%ZTLOAD W !!,$S($D(ZTSK):"This job has been queued.  The task number is "_ZTSK_".",1:"Unable to queue this job.")
	.K ZTSK,IO("Q") D HOME^%ZIS
	;
	U IO
	;***
	;I $D(XRT0) S:'$D(XRTN) XRTN="IBOMTC" D T1^%ZOSV ;stop rt clock
	;
	D ^IBOMTC1 ; generate report
	;
END	K %DT,IBBDT,IBEDT,X,Y
	;***
	;I $D(XRT0) S:'$D(XRTN) XRTN="IBOMTC" D T1^%ZOSV ;stop rt clock
	Q
