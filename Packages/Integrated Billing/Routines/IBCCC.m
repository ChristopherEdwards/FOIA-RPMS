IBCCC	;ALB/AAS - CANCEL AND CLONE A BILL ;25-JAN-90
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
	;MAP TO DGCRCC
	;
	;STEP 1 - cancel bill
	;STEP 1.5 - entry to clone previously cancelled bill.  (must be cancel)
	;STEP 2 - build array of IBIDS call screen that asks ok
	;STEP 3 - pass stub entry to ar
	;STEP 4 - store stub data in MCCR then x-ref
	;STEP 5 - get remainder of data to move and store in MCCR then x-ref
	;STEP 6 - go to screens, come out to IBB1 
EN	;
	;***
	;I $D(XRT0) S:'$D(XRTN) XRTN="IBCCC" D T1^%ZOSV ;stop rt clock
	;S XRTL=$ZU(0),XRTN="IBCCC-1" D T0^%ZOSV ;start rt clock
	;
STEP1	S IBCAN=2,IBQUIT=0,IBAC=6,IBU="UNSPECIFIED" D ASK^IBCC
	G:IBQUIT END1
	I 'IBCCCC!('$D(IBIFN)) G STEP1
EN1	;
STEP1P5	I '$D(IBIFN) S IBCAN=2,IBQUIT=0,IBAC=6 W !,"Copy Previously Cancelled Bill.",!! S DIC="^DGCR(399,",DIC("S")="I $P(^(0),U,13)=7",DIC(0)="AEMQZ",DIC("A")="Enter BILL NUMBER or Patient NAME: " D ^DIC G:Y<1 END S IBIFN=+Y
	;
	S IBIDS(.15)=IBIFN K IBIFN
STEP2	S IBND0=^DGCR(399,IBIDS(.15),0) I $D(^("U")) S IBNDU=^("U")
	F I=2:1:12 S:$P(IBND0,"^",I)]"" IBIDS(I/100)=$P(IBND0,"^",I)
	F I=16:1:19 S:$P(IBND0,"^",I)]"" IBIDS(I/100)=$P(IBND0,"^",I)
	F I=151,152,155 S IBIDS(I)=$P(IBNDU,"^",(I-150))
	D HOME^%ZIS
	S DFN=IBIDS(.02) D DEM^VADPT,^IBCA1
ASK	S IBYN=0 W !!,"IS THE ABOVE INFORMATION CORRECT AS SHOWN" S %=1 D YN^DICN G END:%=2,STEP3:%=1 I % G END
	W !!?4,"YES - If this information is correct as shown and you wish to file the bill.",!?4,"NO  - If you wish to change this information prior to filing."
	W !?4,"'^' - Enter the up-arrow character to DELETE this Bill at this time." G ASK
	;
STEP3	;
	S PRCASV("SER")=$P($G(^IBE(350.9,1,1)),"^",14)
	S PRCASV("SITE")=$P($$SITE^VASITE,"^",3),IBNWBL=""
	W !,"Passing bill to Accounts Receivable Module..." D SETUP^PRCASVC3 I $S($P(PRCASV("ARREC"),"^")=-1:1,$P(PRCASV("ARBIL"),"^")=-1:1,1:0) W *7,"  ",$P(PRCASV("ARREC"),"^",2),$P(PRCASV("ARBIL"),"^",2) G END
	S IBIDS(.01)=$P(PRCASV("ARBIL"),"-",2),IBIDS(.17)=$S($D(IBIDS(.17)):IBIDS(.17),1:PRCASV("ARREC"))
	W !,"Billing Record #",IBIDS(.01)," being established for '",VADM(1),"'..." S IBIDS(.02)=DFN
	G ^IBCCC1 ;go to step4
	Q
END	W !!,"No Billing Record Set up.  You must manually enter the bill."
END1	K %,%DT,IBCAN,IBAC,IBND0,IBNDU,IBYN,IBCCCC,IBIFN,IB,IBA,IBNWBL,IBBT,IBIDS,IBU,I,J,VA,VADM,X,X1,X2,X3,X4,Y,D G STEP1:'IBQUIT
	K IBQUIT
	;***
	;I $D(XRT0) S:'$D(XRTN) XRTN="IBCCC" D T1^%ZOSV ;stop rt clock
	Q
