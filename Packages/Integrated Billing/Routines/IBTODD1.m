IBTODD1	;ALB/AAS - CLAIMS TRACKING DENIED DAYS REPORT ; 27-OCT-93
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;
%	I '$D(DT) D DT^DICRW
PRINT	; -- print data
	; -- ^tmp($j,"ibtodd",primary sort,secondary sort,ibtrc)=DFN ^ attending ^ treating specialty ^ service ^ billing bed section ^ billing rate
	;
	K IBCNT
	I 'IBSUM D HDR
	I 'IBSUM,$O(^TMP($J,"IBTODD",""))="" W !!,"No Denials Found in Date Range." G PRINTQ
	;
	S IBI="",IBISV=""
	F  S IBI=$O(^TMP($J,"IBTODD",IBI)) Q:IBI=""!(IBQUIT)  D
	.I IBSORT'="P",IBISV'=IBI D SUBT^IBTODD
	.S IBISV=IBI
	.D SUBH^IBTODD(IBI) S IBJ="" F  S IBJ=$O(^TMP($J,"IBTODD",IBI,IBJ)) Q:IBJ=""!(IBQUIT)  D
	..S IBTRC=""
	..F  S IBTRC=$O(^TMP($J,"IBTODD",IBI,IBJ,IBTRC)) Q:IBTRC=""!(IBQUIT)  S IBDATA=^(IBTRC) D ONE
	I 'IBSUM D SUBT^IBTODD
	D SUM
	;
PRINTQ	Q
	;
ONE	; -- print one entry
	; -- ^tmp($j,"ibtodd",primary sort,secondary sort,ibtrc)=DFN ^ attending ^ treating specialty ^ service ^ billing bed section ^ billing rate
	;
	S IBAPL=$$APPEAL(IBTRC)
	D CNTS
	S IBTALL=+$P($G(^IBT(356.2,+IBTRC,1)),"^",7) ;entire admission denied
	Q:IBSUM
	;
	I IOSL<($Y+4) D HDR
	S DFN=+IBDATA D PID^VADPT
	S IBTRCD=$G(^IBT(356.2,+IBTRC,0))
L1	W !,$E($P(^DPT(DFN,0),"^"),1,22),?25,VA("PID")
	S IBCDT=$$CDT($P(IBTRCD,"^",2))
	W ?38,$$DAT1^IBOUTL(+IBCDT\1) W:$P(IBCDT,"^",2) " to"
	W ?50,$J($P(IBDATA,"^",2),8)
	I IBTALL W ?64,"ALL"
	I 'IBTALL W ?64,$$DAT1^IBOUTL($P(IBTRCD,"^",15),"2P") W:$P(IBTRCD,"^",16) " to"
	I IBTALL!('$P(IBTRCD,"^",16)) W " (",$P(IBDATA,"^",7),")"
	K IBDEN,IBC S IBDEN=0,IBC=0
	F  S IBDEN=$O(^IBT(356.2,+IBTRC,12,IBDEN)) Q:'IBDEN  S IBC=IBC+1,IBC(IBC)=^(IBDEN,0)
	W:$G(IBC(1)) ?78,$E($$EXPAND^IBTRE(356.212,.01,+IBC(1)),1,25)
	W ?110,$S(+$P(IBAPL,"^",2):"YES",1:"NO")
	W ?117,$J(+IBAPL,8)
	;
	;
L2	W !?38,$$DAT1^IBOUTL($P(IBCDT,"^",2)\1,"2P")
	W ?64,$$DAT1^IBOUTL($P(IBTRCD,"^",16),"2P")
	I 'IBTALL,$P(IBTRCD,"^",16) W " (",$P(IBDATA,"^",7),")"
	W ?78,$E($$EXPAND^IBTRE(356.212,.01,$G(IBC(2))),1,25)
	;
	I $O(IBC(2)) S IBDEN=2 F  S IBDEN=$O(IBC(IBDEN)) Q:'IBDEN  W !?78,$E($$EXPAND^IBTRE(356.212,.01,$G(IBC(IBDEN))),1,25)
ONEQ	W !
	Q
	;
SUM	; -- Print summary report
	Q:IBQUIT
	I $E(IOST,1,2)="C-",IBPAG D PAUSE^VALM1 I $D(DIRUT) S IBQUIT=1 Q
	I $E(IOST,1,2)="C-"!(IBPAG) W @IOF
	S IBPAG=IBPAG+1
	W !,"MCCR/UR DENIED DAYS Summary Report for Reviews Dated ",$$FMTE^XLFDT(IBBDT),$S(IBBDT'=IBEDT:" to "_$$FMTE^XLFDT(IBEDT),1:""),"  "
	W ?(IOM-33),"Page ",IBPAG,"  ",IBHDT
	W !!,?35,"Number",?50,"Days",?65,"Amount",?80,"Days won",?100,"Maximum"
	W !,"Service",?35,"Denials",?50,"Denied",?65,"Denied",?80,"on Appeal",?100,"Billing Rate"
	W !,$TR($J(" ",IOM)," ","-")
	;
	I $O(^TMP($J,"IBTODD",""))="" W !!,"No Denials Found in Date Range." G SUMQ
	;
	S IBSERV="" F  S IBSERV=$O(IBCNT(IBSERV)) Q:IBSERV=""  D
	.W !,$$EXPAND^IBTRE(42.4,3,IBSERV)
	.W ?32,$J($P(IBCNT(IBSERV),"^",3),8)
	.W ?46,$J(+IBCNT(IBSERV),8)
	.S X=$P(IBCNT(IBSERV),"^",2),X2="0$" D COMMA^%DTC W ?60,X
	.W ?81,$J($P(IBCNT(IBSERV),"^",4),6)
	.S X=$P(IBCNT(IBSERV),"^",6),X2="0$" D COMMA^%DTC W ?95,X
	;
	W !?48,"--------",!,?48,$J(IBTOTL,6)
SUMQ	;
	Q
	;
CNTS	; -- develop summary data
	S IBSERV=$P(IBDATA,"^",4)
	I IBSERV="" S IBSERV="UNKNOWN"
	S:'$D(IBCNT(IBSERV)) IBCNT(IBSERV)=""
	S $P(IBCNT(IBSERV),"^")=$P(IBCNT(IBSERV),"^")+$P(IBDATA,"^",7)
	S $P(IBCNT(IBSERV),"^",2)=$P(IBCNT(IBSERV),"^",2)+($P(IBDATA,"^",7)*$P(IBDATA,"^",6))
	S $P(IBCNT(IBSERV),"^",3)=$P(IBCNT(IBSERV),"^",3)+1
	S $P(IBCNT(IBSERV),"^",4)=$P(IBCNT(IBSERV),"^",4)+$G(IBAPL)
	S:$P(IBCNT(IBSERV),"^",6)<$P(IBDATA,"^",6) $P(IBCNT(IBSERV),"^",6)=$P(IBDATA,"^",6)
	S IBSUBT=$G(IBSUBT)+$P(IBDATA,"^",7)
	S IBTOTL=$G(IBTOTL)+$P(IBDATA,"^",7)
	Q
	;
HDR	; -- Print header for billing report
	Q:IBQUIT
	I $E(IOST,1,2)="C-",IBPAG D PAUSE^VALM1 I $D(DIRUT) S IBQUIT=1 Q
	I $E(IOST,1,2)="C-"!(IBPAG) W @IOF
	S IBPAG=IBPAG+1
	W !,"MCCR/UR DENIED DAYS Report for Reviews Dated ",$$FMTE^XLFDT(IBBDT),$S(IBBDT'=IBEDT:" to "_$$FMTE^XLFDT(IBEDT),1:""),"  "
	W ?(IOM-33),"Page ",IBPAG,"  ",IBHDT
	W !!,?38,"Dates of",?64,"Dates",?117,"Days Approved"
	W !,"Patient",?25,"Pt. ID",?38,"Care",?50,"Attending",?64,"Denied",?78,"Denial Reason",?105,"Appealed",?117,"on Appeal"
	W !,$TR($J(" ",IOM)," ","-")
	Q
	;
CDT(IBTRN)	; -- compute dates of care
	N X,Y S X=$G(^IBT(356,+IBTRN,0)),Y=""
	I $P(X,"^",5) S DGPM=$G(^DGPM($P(X,"^",5),0)) D
	.S Y=+DGPM
	.I $P(DGPM,"^",17) S Y=Y_"^"_+$G(^DGPM($P(DGPM,"^",17),0))
	I 'Y S Y=$P(X,"^",6)
	Q Y
	;
APPEAL(IBTRC)	; -- Find appeals
	N X,Y,IBAPEAL,IBTRN,IBTRSV S (Y,X)=0
	S IBTRSV=IBTRC
	S IBTRC=0 F  S IBTRC=$O(^IBT(356.2,"AP",+IBTRSV,IBTRC)) Q:'IBTRC  S Y=1,X=X+$$AP(IBTRC)
	;
	Q X_"^"_Y
	;
AP(IBTRC)	; -- count days approved
	N X,Y,Z
	S (X,Z)=0
	F  S X=$O(^IBT(356.2,+IBTRC,14,X)) Q:'X  S Y=$G(^(X,0)),Z=Z+$$FMDIFF^XLFDT($P(Y,"^",2),+Y)+1
	Q Z
