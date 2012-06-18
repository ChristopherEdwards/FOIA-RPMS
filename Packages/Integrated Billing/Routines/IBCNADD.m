IBCNADD	;ALB/AAS - ADDRESS RETRIEVAL ENGINE FOR FILE 399 ; 29-AUG-93
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
ADD(DA)	; -- Retrive correct billing address for a bill
	;    assumes that new policy field points to valid ins. policy
	N X,Y,I,J,IB01,IB02,IBTYP,DFN,IBCNS,IBCDFN,IBCNT,IBAGAIN
	S IB02=""
	S DFN=$P($G(^DGCR(399,DA,0)),"^",2)
	S IBCNS=+$G(^DGCR(399,DA,"M")) G:'IBCNS MAINQ
	S IBCDFN=$P($G(^DGCR(399,DA,"M")),"^",12) I IBCDFN S IBCNS=+$G(^DPT(+DFN,.312,+IBCDFN,0))
	I '$D(^DIC(36,+IBCNS,0)) G MAINQ
	;
	; -- if send bill to employer and state is filled in use this
	I +$G(^DPT(DFN,.312,+IBCDFN,2)),+$P(^(2),"^",6) S IB02=$P(^(2),"^",2,99) G MAINQ
	;
MAIN	; -- determine address for company for type bill
	;
	; -- get main address
	S IB02=$S($D(^DIC(36,+IBCNS,.11)):^(.11),1:"")
	S IBCNT=$G(IBCNT)+1
	;
	; -- if process the same co. more than once you are in an infinate loop
	I $D(IBCNT(IBCNS)) G MAINQ ;already processed this company  use main add
	S IBCNT(IBCNS)=""
	;
	; -- type of bill
	;     inpatient<3, outpatient>2
	S IBTYP=$P(^DGCR(399,DA,0),"^",5)
	S IBTYP=$S(IBTYP<3:"I",1:"O")
	D @IBTYP I $D(IBAGAIN) K IBAGAIN G MAIN
	;
	; -- return address
MAINQ	Q IB02
	;
I	; -- see if there is an inpatient address
	; -- use if state is there
	I $P($G(^DIC(36,+IBCNS,.12)),"^",5) S IB02=$P($G(^(.12)),"^",1,6)
	;
	; -- if other company processes claims start again
	I $P($G(^DIC(36,+IBCNS,.12)),"^",7) S IBCNS=$P($G(^DIC(36,+IBCNS,.12)),"^",7) S IBAGAIN=1
	Q
	;
O	; -- see if there is an outpatient address
	; -- use if state is there
	I $P($G(^DIC(36,+IBCNS,.16)),"^",5) S IB02=$P($G(^(.16)),"^",1,6)
	;
	; -- if other company processes claims start again
	I $P($G(^DIC(36,+IBCNS,.16)),"^",7) S IBCNS=$P($G(^DIC(36,+IBCNS,.16)),"^",7) S IBAGAIN=1
	Q
