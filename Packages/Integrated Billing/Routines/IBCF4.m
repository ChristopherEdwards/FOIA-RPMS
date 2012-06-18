IBCF4	;ALB/ARH - PRINT BILL ADDENDUM ; 12-JAN-94
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
PRXA	;get bill number then print rx refill addendums for bills
	;S DIR("??")="^D RXDISP^IBCF4",DIR("?")="Enter the bill number of a bill with prescription refills or prosthetic items",DIR("A")="Select BILL NUMBER",DIR(0)="FO^0:15" D ^DIR K DIR I Y=""!$D(DIRUT) G EXIT
	;S IBIFN=$O(^DGCR(399,"B",Y,0)) I 'IBIFN  W "  ??" G PRXA
	;I '$D(^IBA(362.4,"AIFN"_+IBIFN)) W "  bill has no Rx Refills..." G PRXA
	S DIC("S")="I $D(^IBA(362.4,""AIFN""_+Y))!($D(^IBA(362.5,""AIFN""_+Y)))"
	S DIC="^DGCR(399,",DIC(0)="AEMQ" D ^DIC K DIC G:+Y'>0 EXIT S IBBILL=$P(Y,U,2),IBIFN=+Y
DEV	;get the device
	W !!,"Report requires 132 columns."
	S %ZIS="QM",%ZIS("A")="OUTPUT DEVICE: " D ^%ZIS G:POP EXIT
	I $D(IO("Q")) S ZTRTN="EN^IBCF4",ZTDESC="BILL ADDENDUM FOR "_IBBILL,ZTSAVE("IB*")="" D ^%ZTLOAD K IO("Q"),ZTSK G EXIT
	U IO D EN
	;
EXIT	;clean up and quit
	I $D(ZTQUEUED) S ZTREQ="@" Q
	K IBQUIT,IBIFN,IBBILL,X,Y,DTOUT,DUOUT,DIRUT,DIROUT D ^%ZISC
	Q
	;
EN	;ENTRY POINT IF QUEUED, print all rx refills for a bill
	S IBY=$G(^DGCR(399,+IBIFN,0)) Q:IBY=""  S IBXREF="AIFN"_IBIFN
	S (IBQUIT,IBPGN,IBRX)=0,IBHDR="BILL ADDENDUM FOR "_$P($G(^DPT(+$P(IBY,U,2),0)),U,1)_" - "_$P(IBY,U,1) D HDR
RX	I '$D(^IBA(362.4,IBXREF)) G PROS
	W !!,"PRESCRIPTION REFILLS:",!
	S IBRX=0 F  S IBRX=$O(^IBA(362.4,IBXREF,IBRX)) Q:IBRX=""!IBQUIT  S IBRIFN=0 F  S IBRIFN=$O(^IBA(362.4,IBXREF,IBRX,IBRIFN)) Q:'IBRIFN!IBQUIT  D
	. S IBY=$G(^IBA(362.4,IBRIFN,0)) Q:IBY=""
	. W !,$P(IBY,U,1),?13,$$FMTE^XLFDT(+$P(IBY,U,3)),?28,$P($G(^PSDRUG(+$P(IBY,U,4),0)),U,1)
	. I $P(IBY,U,6)'="" W ?70,"QTY: ",$P(IBY,U,7)
	. I $P(IBY,U,7)'="" W ?80,"DAYS SUPPLY: ",$P(IBY,U,6)
	. I $P(IBY,U,8)'="" W ?100,"NDC #: ",$P(IBY,U,8)
	. S IBLN=IBLN+1 I IBLN>(IOSL-7) D PAUSE,HDR
	;
PROS	I '$D(^IBA(362.5,IBXREF)) G END
	W !!!,"PROSTHETIC ITEMS:",!
	S IBPI=0 F  S IBPI=$O(^IBA(362.5,IBXREF,IBPI)) Q:IBPI=""!IBQUIT  S IBPIFN=0 F  S IBPIFN=$O(^IBA(362.5,IBXREF,IBPI,IBPIFN)) Q:'IBPIFN!IBQUIT  D
	. S IBY=$G(^IBA(362.5,IBPIFN,0)) Q:IBY=""
	. W !,$$FMTE^XLFDT(+$P(IBY,U,1)),?15,$P($$PIN^IBCSC5B(+$P(IBY,U,3)),U,2)
	. S IBLN=IBLN+1 I IBLN>(IOSL-7) D PAUSE,HDR
	D:'IBQUIT PAUSE
END	K IBX,IBY,IBPGN,IBRX,IBHDR,IBRIFN,IBLN,IBCDT,IBI,IBXREF,IBPI,IBPIFN
	Q
	;
	;
HDR	;print the report header
	S IBQUIT=$$STOP Q:IBQUIT  S IBPGN=IBPGN+1,IBLN=5
	D NOW^%DTC S Y=$E(%,1,12) D DD^%DT S IBCDT=$P(Y,"@",1)_"  "_$P(Y,"@",2)
	I IBPGN>1!($E(IOST,1,2)["C-") W @IOF
	W IBHDR W:IOM<85 ! W ?(IOM-30),IBCDT,?(IOM-8),"PAGE ",IBPGN,!
	;W !,"RX #",?13,"REFILL DATE",?28,"DRUG",?70,"DAYS SUPPLY",?83,"QTY",?90,"NDC #",!
	F IBI=1:1:IOM W "-"
	W !
	Q
	;
PAUSE	;pause at end of screen if beeing displayed on a terminal
	Q:$E(IOST,1,2)'["C-"
	S DIR(0)="E" D ^DIR K DIR
	I $D(DUOUT)!($D(DIRUT)) S IBQUIT=1
	Q
	;
STOP()	;determine if user has requested the queued report to stop
	I $D(ZTQUEUED),$$S^%ZTLOAD S ZTSTOP=1 K ZTREQ I +$G(IBPGN) W !,"***TASK STOPPED BY USER***"
	Q +$G(ZTSTOP)
	;
RXDISP	;displays all rx refills bills
	;N IBX,IBY,IBZ,IBC,X,Y S Y=1,IBC=0,IBX="AIFN"
	;F  S IBX=$O(^IBA(362.4,IBX)) Q:IBX=""  S IBY=$E(IBX,5,999),IBZ=$G(^DGCR(399,+IBY,0)) I IBZ'="" D  Q:'Y
	;. W !,$P(IBZ,U,1),?10,$E($P($G(^DPT(+$P(IBZ,U,2),0)),U,1),1,20),?32,$$DATE(+$P(IBZ,U,3)),?42,$S(+$P(IBZ,U,5)<3:"INPT",1:"OUTPT")
	;. W ?49,$P($G(^DGCR(399.3,+$P(IBZ,U,7),0)),U,4),?59,$E($$EXSET^IBEFUNC(+$P(IBZ,U,13),399,.13),1,7),?68,$E($P($G(^IBE(353,+$P(IBZ,U,19),0)),U,1),1,11)
	;. S IBC=IBC+1 I '(IBC#10) S DIR(0)="E" D ^DIR K DIR
	;Q
	;
DATE(X)	Q $E(X,4,5)_"/"_$E(X,6,7)_"/"_$E(X,2,3)
	;
BILLAD(IFN)	;returns true if bill has either rx refills or prosthetics so addendum should print
	N IBX S IBX=0,IFN=+$G(IFN) S:+$O(^IBA(362.4,"AIFN"_IFN,0)) IBX=1 S:+$O(^IBA(362.5,"AIFN"_IFN,0)) IBX=IBX+2
	Q IBX
