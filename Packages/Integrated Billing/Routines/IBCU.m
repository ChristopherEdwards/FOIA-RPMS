IBCU	;ALB/MRL - BILLING UTILITY ROUTINE  ;01 JUN 88 12:00
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
	;MAP TO DGCRU
	;
ARSTAT	;find status of bill in file 430.3 (ar) return status number
	S IBARST=$$STA^PRCAFN(IBIFN)
	Q
	;
ARCAT	;Trigger logic to set who's responsible in 399.3 from AR Category
	S X=$P($$CATN^PRCAFN($P(^DGCR(399.3,DA,0),"^",6)),"^",3)
	S:X'="" X=$S("PC"[X:"p",X="N":"o",X="T":"i",1:"")
	Q
	;
PTF	;Screen for appropriate PTF records
	K IBDD1 S DFN=+$P(^DGCR(399,+DA,0),"^",2) Q:'$D(^DPT(+DFN,0))  S IB05=$P(^(0),"^",1),IB03=$P(^DGCR(399,+DA,0),"^",3)
	S IB01="",IB02=0 F IB02=0:0 S IB01=$O(^DD(45,0,"ID",IB01)) Q:'IB01  S IB02=IB02+1,IBDD(IB02)=^(IB01)
	F IB01=0:0 S IB01=$O(^DGPT("B",+DFN,IB01)) Q:'IB01  I $D(^DGPT(+IB01,0)) S IB04=$P(^(0),"^",2),Y=+IB01 I $P(IB03,".",1)=$P(IB04,".",1) S IBDD1(+Y)="" I $S('$D(X):0,X["?":1,1:0) D PTFW
	G PTFQ:X'["?" I '$O(IBDD1(0)) W !,"Patient has no ACTIVE PTF RECORDS for this event date.",!,"A 'PTF NUMBER' is required for inpatient billing records."
	E  W !!,"Select the appropriate billing record from the above listing by number."
PTFQ	W ! K IB01,IB02,IB03,IB04,IB05,IBDD Q
PTFW	W !,Y,?15,IB05 F IB02=0:0 S IB02=$O(IBDD(IB02)) Q:'IB02  X IBDD(IB02)
	Q
	;
AGE	;Input Transform for Condition Code 17
	I X=18 G SEX
	I X=17 S IBC=X,DFN=$P(^DGCR(399,D0,0),"^",2) D DEM^VADPT I VADM(4)<100 W !!,"This patient is only ",VADM(4)," years old!!",!! K IBC Q
	I $D(IBC) S X=IBC
	Q
	;
SEX	;Input Transform for Condition Code 18
	I X=18 S IBC=X,DFN=$P(^DGCR(399,D0,0),"^",2) D DEM^VADPT I $E(VADM(5))="M" W !!,"This patient is a MALE!! Condition code 18 applies only to FEMALES!!",!! K IBC,X
	I $D(IBC) S X=IBC
	Q
	;
REV	;Input Transform for Revenue Code
	I X=-1 W !!,"Choose only ACTIVE Revenue Codes!!",!! S D="AC" ;S X="" S X=$O(^DGCR(399.2,"AC",X)) Q:X=""  W !,$P(^DGCR(399.2,X,0),"^",1),?30,$P(^(0),"^",2) K X Q
	I '$D(IBC) I $D(^DGCR(399.2,X,0)) I '$P(^DGCR(399.2,X,0),"^",3) W !!,"Only ACTIVE Revenue Codes may be selected!!",!! K X Q
	Q
	;
YN	S X=$E(X),X=$S(X=1:X,X=0:X,X="Y":1,X="y":1,X="n":0,X="N":0,1:2) I X'=2 W "  (",$S(X:"YES",1:"NO"),")" Q
	W !?4,"NOT A VALID CHOICE!",*7 K X Q
	Q
	;
DIS	;Determine Billing Discharge status from PTF
	;Called from triggers on fields .08 and 161
	N A
	I '$D(^DGCR(399,DA,0)) S X="" G DISQ
	S X=$P(^DGCR(399,DA,0),"^",6) I X=2!(X=3) S X=$O(^DGCR(399.1,"B","STILL PATIENT",0)) G DISQ
	S X=$P(^DGCR(399,DA,0),"^",8) I $S(X="":1,'$D(^DGPT(X)):1,1:0) S X="" G DISQ
	I '+$G(^DGPT(X,70)) S X=$O(^DGCR(399.1,"B","STILL PATIENT",0)) G DISQ
	S A=$P($G(^DGCR(399,DA,"U")),"^",2) I A,(A+.24)<+$G(^DGPT(X,70)) S X=$O(^DGCR(399.1,"B","STILL PATIENT",0)) G DISQ
	S X=+$P($G(^DGPT(X,70)),"^",3)
	I X=1 S X=$O(^DGCR(399.1,"B",$E("DISCHARGED TO HOME OR SELF CARE",1,30),0)) G DISQ
	I X=4 S X=$O(^DGCR(399.1,"B",$E("LEFT AGAINST MEDICAL ADVICE",1,30),0)) G DISQ
	I X=6!(X=7) S X=$O(^DGCR(399.1,"B","EXPIRED",0)) G DISQ
	I X=5!(X=2) S X=$O(^DGCR(399.1,"B",$E("DISCHARGED TO ANOTHER SHORT-TERM GENERAL HOSPITAL",1,30),0)) G DISQ
	S X=""
DISQ	Q
	;
INST	;Ask Institutution address info
	S DIC("DR")="1.01;1.02;1.03;.02;1.04" I $D(^XUSEC("IB SUPERVISOR",DUZ)) S DLAYGO=4
	Q
	;
SM	;Flag for printing medicare statment on UB-82
	;DGSM=0 means figure out which statement, DGSM=1 means no statements
	S DGSM=0 Q
	;IBCU
