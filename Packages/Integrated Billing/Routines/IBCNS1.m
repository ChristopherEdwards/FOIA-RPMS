IBCNS1	;ALB/AAS - INSURANCE MANAGEMENT SUPPORTED FUNCTIONS ; 22-JULY-91
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
INSURED(DFN,IBINDT)	; -- Is patient insured
	; --Input  DFN     = patient
	;          IBINDT  = (optional) date insured (default = today)
	; -- Output        = 0 - not insured
	;                  = 1 - insured
	;
	N J,X,IBINS S IBINS=0,J=0
	I '$G(IBINDT) S IBINDT=DT
	F  S J=$O(^DPT(DFN,.312,J)) Q:'J  S X=$G(^(J,0)) S IBINS=$$CHK(X,IBINDT) Q:IBINS
INSQ	Q IBINS
	;
PRE(DFN,IBINDT)	; -- is pre-certification required for patient
	N X,Y,J,IBPRE
	S IBPRE=0,J=0
	S:'$G(IBINDT) IBINDT=DT
	F  S J=$O(^DPT(DFN,.312,J)) Q:'J  S X=$G(^(J,0)) I $$CHK(X,IBINDT),$P($G(^IBA(355.3,+$P(X,"^",18),0)),"^",6) S IBPRE=1 Q
PREQ	Q IBPRE
	;
UR(DFN,IBINDT)	; -- is ur required for patient
	N X,Y,J,IBPRE
	S IBUR=0,J=0
	S:'$G(IBINDT) IBINDT=DT
	F  S J=$O(^DPT(DFN,.312,J)) Q:'J  S X=$G(^(J,0)) I $$CHK(X,IBINDT),$P($G(^IBA(355.3,+$P(X,"^",18),0)),"^",5) S IBUR=1 Q
URQ	Q IBUR
	;
CHK(X,Z,Y)	; -- check one entry for active
	; --  Input   X    = Zeroth node of entry in insurance multiple (2.312)
	;             Z    = date to check
	;             Y    = 2 if want will not reimburse
	; --  Output  1    = Insurance Active
	;             0    = Inactive
	;
	N Z1,X1 S Z1=0
	I $$INDEM(X) G CHKQ ; is and indemnity policy or company
	S X1=$G(^DIC(36,+X,0)) G:X1="" CHKQ ;insurance company entry doesn't exist
	I $P(X,"^",8) G:Z<$P(X,"^",8) CHKQ ;effective date later than care
	I $P(X,"^",4) G:Z>$P(X,"^",4) CHKQ ;care after expiration date
	G:$P(X1,"^",5) CHKQ ;insurance company inactive
	I $G(Y)'=2 G:$P(X1,"^",2)="N" CHKQ ;insurance company will not reimburse
	S Z1=1
CHKQ	Q Z1
	;
ACTIVE(IBCIFN)	; -- is this company active for this patient for this date
	; -- called from input transform and x-refs for fields 101,102,103
	; -- input
	N ACTIVE,DFN,IBINDT
	S DFN=$P(^DGCR(399,DA,0),"^",2),IBINDT=$S(+$G(^DGCR(399,DA,"U")):+$G(^("U")),1:DT)
	;
ACTIVEQ	Q ACTIVE
	;
DD	;  - called from input transform and x-refs for field 101,102,103
	;  - input requires da=internal entry number in 399
	;  - outputs IBdd(ins co.) array
	N DFN S DFN=$P(^DGCR(399,DA,0),"^",2),IBINDT=$S(+$G(^DGCR(399,DA,"U")):+$G(^("U")),1:DT)
	D ALLACT
DDQ	K IBINDT Q
	;
	;
ALLACT	; -- return active insurance zeroth nodes in ibdd(ins co,entry in mult)
	N X,X1
	S (X1,IBDD)=0
	F  S X1=$O(^DPT(DFN,.312,X1)) Q:'X1  S X=$G(^(X,0)) I $$CHK(X,IBINDT) S IBDD(+X,X1)=X
	;
ALLACTQ	Q
	;
HDR	W !?4,"Insurance Co.",?22,"Policy #",?40,"Group",?52,"Holder",?60,"Effective",?70,"Expires" S X="",$P(X,"=",IOM-4)="" W !?4,X
	Q
	;
	;
D1	N X Q:'$D(IBINS)
	W !?4,$S($D(^DIC(36,+IBINS,0)):$E($P(^(0),"^",1),1,16),1:"UNKNOWN")
	W ?22,$E($P(IBINS,"^",2),1,16)
	W ?40,$E($$GRP^IBCNS($P(IBINS,"^",18)),1,10)
	S X=$P(IBINS,"^",6) W ?52,$S(X="v":"SELF",X="s":"SPOUSE",1:"OTHER")
	W ?60,$$DAT1^IBOUTL($P(IBINS,"^",8)),?70,$$DAT1^IBOUTL($P(IBINS,"^",4))
	Q
	;
ALL(DFN,VAR,ACT,ADT)	; -- find all insurance data on a patient
	;
	; -- input DFN  = patient
	;          VAR  = variable to output in format of abc
	;                 or abc(dfn)
	;                 or ^tmp($j,"Insurance")
	;          ACT  = 1 if only active ins. desired
	;               = 2 if active and will not reimburse desired (medicare)
	;          ADT  = if ACT=1, then ADT is the internal date to check
	;                 active for, default = dt
	;
	; -- output var(0)   =: number of entries insurance multiple
	;           var(x,0) =: ^dpt(dfn,.312,x,0)
	;           var(x,1) =: ^dpt(dfn,.312,x,1)
	;           var(x,2) =: ^dpt(dfn,.312,x,2)
	;
	N X
	S X=0 I $G(ACT),$E($G(ADT),1,7)'?7N S ADT=DT
	F  S X=$O(^DPT(DFN,.312,X)) Q:'X  D
	.I $G(ACT),'$$CHK(^DPT(DFN,.312,X,0),ADT,$G(ACT)) Q
	.S @VAR@(0)=$G(@VAR@(0))+1
	.S @VAR@(X,0)=$$ZND(DFN,X)
	.S @VAR@(X,1)=$G(^DPT(DFN,.312,X,1))
	.S @VAR@(X,2)=$G(^DPT(DFN,.312,X,2))
	.S @VAR@(X,355.3)=$G(^IBA(355.3,+$P($G(^DPT(DFN,.312,X,0)),"^",18),0))
ALLQ	Q
	;
ZND(DFN,NODE)	; -- set group number and group name back into zeroth node of ins. type
	N X,Y S (X,Y)=""
	I '$G(DFN)!('$G(NODE)) G ZNDQ
	S X=$G(^DPT(+DFN,.312,+NODE,0))
	S Y=$G(^IBA(355.3,+$P(X,"^",18),0)) I Y="" G ZNDQ
	S $P(X,"^",3)=$P(Y,"^",4) ; move group number
	S $P(X,"^",15)=$P(Y,"^",3) ; move group name
	;
ZNDQ	Q X
	;
INDEM(X)	; -- is this and indemnity plan
	; -- input zeroth node if insurance type field
	N IBINDEM,IBCTP
	S IBINDEM=1
	I $P($G(^DIC(36,+X,0)),"^",13)=15 G INDEMQ ; company is indemnity co.
	S IBCTP=$P($G(^IBA(355.3,+$P(X,"^",18),0)),"^",9)
	I IBCTP,$P($G(^IBE(355.1,+IBCTP,0)),"^",3)=9 G INDEMQ ; plan is and indemnity plan
	S IBINDEM=0
INDEMQ	Q IBINDEM
