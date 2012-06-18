IBCU4	;ALB/AAS - BILLING UTILITY ROUTINE (CONTINUED)  ;12-FEB-90
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
	;MAP TO DGCRU4
	;
DDAT	;Input transform for Statement Covers From field
	I '$D(DA) G TO
	S IB00=+$P(^DGCR(399,+DA,0),"^",3) I +X<$P(IB00,".",1) W !?4,"Cannot precede the 'EVENT DATE'!",*7 K X G DDAT4
	I +X>(DT_".2359") W !?4,"Cannot bill for future treatment!",*7 K X G DDAT4
	D PROCDT
	I DGPRDTB,X>DGPRDTB K X W !?4,"Can't be greater than date of specified Procedures!",*7 G DDAT4
	G DDAT4
DDAT1	;Input transform for Satement covers to
	I '$D(DA) G FROM
	S IB00=$S($D(^DGCR(399,+DA,"U")):$P(^("U"),"^",1),1:"") I 'IB00 W !?4,"'Start Date' must be specified first!",*7 K X G DDAT4
	I +X<IB00 W !?4,"Cannot preceed the 'Start Date'!",*7 K X G DDAT4
	I $S($E(IB00,4,5)<10:$E(IB00,2,3),1:$E(IB00,2,3)+1)'=$S($E(X,4,5)<10:$E(X,2,3),1:$E(X,2,3)+1) K X W !?4,"Must be in same fiscal year!",*7 G DDAT4
	I $E(IB00,1,3)'=$E(X,1,3) K X W !?4,"Must be in same calendar year!",*7 G DDAT4
	D PROCDT
	I DGPRDTE,X<DGPRDTE K X W !?4,"Can't be less than date of specified Procedures!",*7 G DDAT4
	G DDAT4
	;
	;DDAT2   ;Input transform for OP VISITS DATE(S) field  REPLACED WITH IBCU41 6/15/93
	;S IB00=$G(^DGCR(399,IBIFN,"U")) I $P(IB00,"^",1)']"" W !?4,*7,"No 'Start Date' on file...can't enter OP visit dates..." K X G DDAT4
	;I $P(IB00,"^",2)']"" W !?4,*7,"No 'End Date' on file...can't enter OP visit dates..." K X G DDAT4
	;I X<$P(IB00,"^",1) W !?4,*7,"Can't enter a visit date prior to 'Start Date'..." K X G DDAT4
	;I X>$P(IB00,"^",2) W !?4,*7,"Can't enter a visit date later than 'End Date'..." K X G DDAT4
	;I $P(^DGCR(399,IBIFN,0),"^",19)'=2,$D(^DGCR(399,"ASC2",IBIFN)),$O(^DGCR(399,IBIFN,"OP",0)) W !?4,*7,"Only 1 visit date allowed on bills with Amb. Surg. Codes!" K X G DDAT4
	;D APPT^IBCU3,DUPCHK^IBCU3
	G DDAT4
	;
DDAT3	; - x-ref call for to and from dates, REPLACED BY TRIGGERS ON .08, 151, 152 ON 10/18/93
	;if inpatient bill return DGNEWLOS to cause recalc of los in IBSC6
	G DDAT4:'$D(X)
	I $D(^DGCR(399,DA,0)),$P(^(0),"^",5)<3 S DGNEWLOS=1
	S IB00=$S($D(^DGCR(399,+DA,"U")):^("U"),1:"") I IB00']"" K X G DDAT4
	S IB02=$S(+$E(IB00,4,5)<10:$E(IB00,2,3),1:$E(IB00,2,3)+1),IB01=$E(IB00,1)_IB02_"0930",$P(^DGCR(399,DA,"U1"),"^",9)=IB02 ;,$P(^DGCR(399,DA,"U1"),"^",11)=$S($P(IB00,"^",2)>IB01:IB02+1,1:"")
	;I $P(^DGCR(399,DA,"U1"),"^",11)="" S $P(^("U1"),"^",12)=""
	;
DDAT4	K IB00,IB01,IB02,IB03,DGX,DGNOAP,DGJ,DGPROC,DGPRDT,DGPRDTE,DGPRDTB Q
	;
	;
TO	;151 pseudo input x-form
	I +X_.9<IBIDS(.03) W !?4,"Cannot precede the 'EVENT DATE'!",*7 K X Q
	I +X>(DT_".2359") W !?4,"Cannot bill for future treatment!",*7 K X
	Q
FROM	;152 pseudo input x-form
	I '$D(IBIDS(151)) W !?4,"'Start Date' must be specified first!",*7 K X Q
	I +X<IBIDS(151) W !?4,"Cannot preceed the 'Start Date'!",*7 K X Q
	I $S($E(IBIDS(151),4,5)<10:$E(IBIDS(151),2,3),1:$E(IBIDS(151),2,3)+1)'=$S($E(X,4,5)<10:$E(X,2,3),1:$E(X,2,3)+1) K X W !?4,"Must be in same fiscal year!",*7 Q
	I $E(IBIDS(151),1,3)'=$E(X,1,3) K X W !?4,"Must be in same calendar year!",*7 Q
	Q
	;
SPEC	;  - calculate discharge specialty
	;  - input  IBids(.08) = ptf record number
	;  - output IBids(161) = pointer to billing specialty in 399.1
	K IBIDS(161)
	Q:$S('$D(IBIDS(.08)):1,'$D(^DGPT(+IBIDS(.08),70)):1,'$P(^(70),"^",2):1,'$D(^DIC(42.4,+$P(^(70),"^",2),0)):1,1:0)  S IBIDS(161)=$P(^DGPT(IBIDS(.08),70),"^",2)
	S IBIDS(161)=$P($G(^DIC(42.4,+IBIDS(161),0)),"^",5) I IBIDS(161)="" K IBIDS(161) Q
	S IBIDS(161)=$O(^DGCR(399.1,"B",IBIDS(161),0))
	I '$D(^DGCR(399.1,+IBIDS(161),0)) K IBIDS(161)
	Q
	;
PROCDT	;  - find first and last dates of procedures
	;    can't set from and to date inside of this range
	S (DGPRDT,DGPROC,DGPRDTE,DGPRDTB)=0
	F  S DGPROC=$O(^DGCR(399,+DA,"CP",DGPROC)) Q:'DGPROC  S DGPRDT=$P($G(^DGCR(399,+DA,"CP",DGPROC,0)),"^",2) D
	. I DGPRDTB=0!(DGPRDTB>DGPRDT) S DGPRDTB=DGPRDT
	. I DGPRDTE=0!(DGPRDTE<DGPRDT) S DGPRDTE=DGPRDT
	. Q
	Q
