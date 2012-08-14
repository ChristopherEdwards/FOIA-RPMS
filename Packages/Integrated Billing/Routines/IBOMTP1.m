IBOMTP1	;ALB/CPM - CATEGORY C BILLING PROFILE (CON'T) ; 10-DEC-91
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;
	;***
	;S XRTL=$ZU(0),XRTN="IBOMTP1-2" D T0^%ZOSV ;start rt clock
	; Begin compilation.  Start with billing clocks.
	S Y=-(IBEDT+.1),X=0 F  Q:-Y<IBBDT  S Y=$O(^IBE(351,"AIVDT",IBDFN,Y)) Q:'Y  F  S X=$O(^IBE(351,"AIVDT",IBDFN,Y,X)) Q:'X  S:$P($G(^IBE(351,X,0)),"^",4)'=3 ^TMP($J,"IBOMTP",-Y,"C")=""
	;
	; Get O/P visits from file #399.
	S X1=IBBDT,X2=-1 D C^%DTC S Y=X
	F  S Y=$O(^DGCR(399,"AOPV",IBDFN,Y)) Q:'Y!(Y>IBEDT)  D
	. S IBDA=0 F  S IBDA=$O(^DGCR(399,"AOPV",IBDFN,Y,IBDA)) Q:'IBDA  D
	..  I $D(^DGCR(399,+IBDA,0)),'$P($G(^("S")),"^",16),$P($G(^DGCR(399.3,+$P(^(0),"^",7),0)),"^")["MEANS" S ^TMP($J,"IBOMTP",Y,"M"_IBDA)=""
	;
	; Get the rest of the charges from file #350.
	S Y="" F  S Y=$O(^IB("AFDT",IBDFN,Y)) Q:'Y  I -Y'>IBEDT S Y1=0 F  S Y1=$O(^IB("AFDT",IBDFN,Y,Y1)) Q:'Y1  D
	. S IBDA=0 F  S IBDA=$O(^IB("AF",Y1,IBDA)) Q:'IBDA  D
	..  Q:'$D(^IB(IBDA,0))  S IBX=^(0)
	..  Q:$P(IBX,"^",8)["ADMISSION"
	..  I $P(IBX,"^",15)<IBBDT!($P(IBX,"^",14)>IBEDT) Q
	..  S ^TMP($J,"IBOMTP",+$P(IBX,"^",14),"I"_IBDA)=""
	;
	; Print report.
	D NOW^%DTC S IBHDT=$$DAT2^IBOUTL($E(%,1,12))
	S IBLINE="",$P(IBLINE,"-",IOM+1)="",(IBPAG,IBCHGT,IBQUIT)=0
	S IBPT=$$PT^IBEFUNC(IBDFN)
	S IBH="Category C Billing Profile for "_$P(IBPT,"^")_"  "_$P(IBPT,"^",2) D HDR
	I '$D(^TMP($J,"IBOMTP")) W !,"This patient has no Category C bills." D PAUSE^IBOUTL G END
	; - first, print detail lines
	S IBD="" F  S IBD=$O(^TMP($J,"IBOMTP",IBD)) Q:'IBD  D  G:IBQUIT END
	. S IBTY="" F  S IBTY=$O(^TMP($J,"IBOMTP",IBD,IBTY)) Q:IBTY=""  D  Q:IBQUIT
	..  I $Y>(IOSL-5) D PAUSE^IBOUTL Q:IBQUIT  D HDR
	..  W !,$$DAT1^IBOUTL(IBD)
	..  I IBTY="C" W ?12,"Begin Category C Billing Clock" Q
	..  S IBDA=+$E(IBTY,2,99),IBD0=$S($E(IBTY)="M":$G(^DGCR(399,IBDA,0)),1:$G(^IB(IBDA,0))),IBSEQ=0
	..  I $E(IBTY)="I" S IBSEQ=$P($G(^IBE(350.1,+$P(IBD0,"^",3),0)),"^",5)
	..  W ?14,$S($E(IBTY)="M":"OPT COPAYMENT (UB-82)",1:$$ACTNM^IBOUTL(+$P(IBD0,"^",3)))
	..  W ?44,$S($E(IBTY)="M":$P(IBD0,"^"),1:$$STAT())
	..  I $E(IBTY)="I",$P(IBD0,"^",14)'=$P(IBD0,"^",15) W ?54,$$DAT1^IBOUTL($P(IBD0,"^",15))
	..  I $E(IBTY)="M" S X=+$O(^DGCR(399,IBDA,"RC","B",500,0)),IBCHG=+$P($G(^DGCR(399,IBDA,"RC",X,0)),"^",2)
	..  E  S IBCHG=+$P(IBD0,"^",7)
	..  I IBSEQ=2 S IBCHG=-IBCHG
	..  I $E(IBTY)="I",$P(IBD0,"^",11)="",$P($G(^IBE(350.21,+$P(IBD0,"^",5),0)),"^",5) S IBCHG=0
	..  S X=IBCHG,X2="2$",X3=10 D COMMA^%DTC W ?65,X
	..  S IBCHGT=IBCHGT+IBCHG
	..  I IBSEQ=2!($P(IBD0,"^",11)=""&($P($G(^IBE(350.21,+$P(IBD0,"^",5),0)),"^",5))) W !?5,"Charge Removal Reason: ",$S($D(^IBE(350.3,+$P(IBD0,"^",10),0)):$P(^(0),"^"),1:"UNKNOWN")
	; - print totals line
	I $Y>(IOSL-5) D PAUSE^IBOUTL G:IBQUIT END D HDR
	W !?63,"-----------" S X=IBCHGT,X2="2$",X3=12 D COMMA^%DTC W !?63,X
	D PAUSE^IBOUTL
	; - close device and quit
END	K ^TMP($J)
	;***
	;I $D(XRT0) S:'$D(XRTN) XRTN="IBOMTP1" D T1^%ZOSV ;stop rt clock
	I $D(ZTQUEUED) S ZTREQ="@" Q
	K IBJ,IBD,IBH,IBHDT,IBTY,IBDA,IBD0,IBSEQ,IBQUIT,IBCHG,IBCHGT,IBPAG,IBLINE,IBX,IBPT,X,X2,X3,Y,Y1
	D ^%ZISC Q
	;
	;
HDR	; Print header.
	I $E(IOST,1,2)["C-"!(IBPAG) W @IOF,*13
	S IBPAG=IBPAG+1 W ?(80-$L(IBH)\2),IBH
	W !,"From ",$$DAT1^IBOUTL(IBBDT)," through ",$$DAT1^IBOUTL(IBEDT)
	W ?IOM-36,IBHDT,?IOM-9,"Page: ",IBPAG
	W !,"BILL DATE   BILL TYPE",?44,"BILL #    BILL TO   TOT CHARGE"
	W !,IBLINE,! Q
	;
STAT()	; Display bill number or status
	N IBSTAT S IBSTAT=$G(^IBE(350.21,+$P(IBD0,"^",5),0))
	Q $S($P(IBSTAT,"^",6):$$HLD(+$P(IBD0,"^",5)),$P(IBD0,"^",5)=99:"Converted",$P(IBD0,"^",11)]"":$P($P(IBD0,"^",11),"-",2),$P(IBSTAT,"^",5):"Cancelled",1:"Pending")
	;
HLD(STAT)	; Return an 'on hold' status string
	Q "Hold "_$S(STAT=20:"Rate",STAT=21:"Clm",STAT=22:"Adj",1:"Ins")