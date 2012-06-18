IBCNS	;ALB/AAS - IS INSURANCE ACTIVE ; 22-JULY-91
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
	;MAP TO DGCRNS
	;
	;Input   -  DFN       = patient
	;        -  IBINDT  = (optional) date to check ins active for or today if not defined
	;        -  IBOUTP  = (optional) 1 if want active insurance returned in IBDD(insurance company)=node in patient file
	;        -            = 2 if want all ins returned
	;
	;Output  -  IBINS   = 1 if has active ins., 0 if no active ins.
	;        -  IBDD()  = internal node in patient file of valid ins.
	;        -  IBDDI() = internal node in patient file of invalid ins.
	;
%	N J,X S IBINS=0 K IBDD,IBDDI
	S J=0 F  S J=$O(^DPT(DFN,.312,J)) Q:'J  I $D(^DPT(DFN,.312,J,0)) S X=^(0) D CHK
	Q
	;
CHK	;
	;Input   -  IBI  = entry in insurance multiple
	;
	S Z=$S($D(IBINDT):IBINDT,1:DT),Z1=$S($D(IBOUTP):IBOUTP,1:0)
	G:'$D(^DIC(36,+X,0)) CHKQ S X1=^(0) ;insurance company entry doesn't exist
	I $P(X,"^",8) G:Z<$P(X,"^",8) CHKQ ;effective date later than care
	I $P(X,"^",4) G:Z>$P(X,"^",4) CHKQ ;care after expiration date
	G:$P(X1,"^",5) CHKQ ;insurance company inactive
	G:$P(X1,"^",2)="N" CHKQ ;insurance company will not reimburse
	S IBINS=1 I Z1 D
	.S IBDD(+X)=X
	.Q:'$P(IBDD(+X),"^",18)
	.S Y=$G(^IBA(355.3,+$P(IBDD(+X),"^",18),0))
	.I $P(Y,"^",4)'="" S $P(IBDD(+X),"^",3)=$P(Y,"^",4) ; move group number
	.I $P(Y,"^",3)'="" S $P(IBDD(+X),"^",15)=$P(Y,"^",3) ; move group name
CHKQ	I Z1=2&('$D(IBDD(+X))) D
	.S IBDDI(+X)=X
	.Q:'$P(IBDDI(+X),"^",18)
	.S Y=$G(^IBA(355.3,+$P(IBDDI(+X),"^",18),0))
	.I $P(Y,"^",4)'="" S $P(IBDDI(+X),"^",3)=$P(Y,"^",4) ; move group number
	.I $P(Y,"^",3)'="" S $P(IBDDI(+X),"^",15)=$P(Y,"^",3) ; move group name
	K X,X1,Z,Z1,Y Q
	;
DD	;  - called from input transform and x-refs for field 101,102,103
	;  - input requires da=internal entry number in 399
	;  - outputs IBdd(ins co.) array
	N DFN S DFN=$P(^DGCR(399,DA,0),"^",2),IBOUTP=1,IBINDT=$S(+$G(^DGCR(399,DA,"U")):+$G(^("U")),1:DT)
	D %
DDQ	K IBOUTP,IBINDT Q
	;
	;
DISP	;  -Display all insurance company information
	;  -input DFN
	;
	Q:'$D(DFN)  D:'$D(IOF) HOME^%ZIS
	N X,IBINS,IBX
	D ALL^IBCNS1(DFN,"IBINS")
	;
	D HDR
	I '$D(IBINS) W !,"    No Insurance Information" G DISPQ
	;
	S X=0 F  S X=$O(IBINS(X)) Q:'X  S IBINS=IBINS(X,0) D D1 ; display
	;
DISPQ	Q
	;
OLDISP	;  -Display all insurance company information
	;  -input DFN
	;
	Q:'$D(DFN)  D:'$D(IOF) HOME^%ZIS
	;
	S IBOUTP=2 D IBCNS
	;
	D HDR
	I '$D(IBDD),'$D(IBDDI) W !,"    No Insurance Information" G DISPQ
	;
	S X="" F  S X=$O(IBDD(X)) Q:X=""  S IBINS=IBDD(X) D D1 ;active insurance
	S X="" F  S X=$O(IBDDI(X)) Q:X=""  S IBINS=IBDDI(X) D D1 ;inactive ins
	;
OLDISPQ	K IBDD,IBDDI,IBX
	Q
	;
HDR	; -- print standard header
	D HDR1("=",IOM-4)
	Q
	;
HDR1(CHAR,LENG)	; -- print header, specify character
	W !?4,"Insurance Co.",?22,"Subscriber ID",?40,"Group",?52,"Holder",?60,"Effective",?70,"Expires" I $G(CHAR)'="",LENG S X="",$P(X,CHAR,LENG)="" W !?4,X
	Q
	;
	;
D1	N X Q:'$D(IBINS)
	W !?4,$S($D(^DIC(36,+IBINS,0)):$E($P(^(0),"^",1),1,16),1:"UNKNOWN")
	W ?22,$E($P(IBINS,"^",2),1,16)
	;W ?40,$E($S($P(IBINS,"^",15)'="":$P(IBINS,"^",15),1:$P(IBINS,"^",3)),1,10)
	W ?40,$E($$GRP($P(IBINS,"^",18)),1,10)
	S X=$P(IBINS,"^",6) W ?52,$S(X="v":"SELF",X="s":"SPOUSE",1:"OTHER")
	W ?60,$$DAT1^IBOUTL($P(IBINS,"^",8)),?70,$$DAT1^IBOUTL($P(IBINS,"^",4))
	Q
	;
GRP(IBCPOL)	; -- return group name/group policy
	;     input:   IBCPOL = pointer to entry in 355.3
	;    output:   group name or group number, if both group NUMBER
	;              if neither 'Individual PLAN'
	;
	N X,Y S X=""
	S X=$G(^IBA(355.3,+$G(IBCPOL),0))
	S Y=$S($P(X,"^",4)'="":$P(X,"^",4),1:$P(X,"^",3))
	I $P(X,"^",10) S Y="Ind. Plan "_Y
GRPQ	Q Y
