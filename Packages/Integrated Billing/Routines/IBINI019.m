IBINI019	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(350)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(350,.13,"DT")
	;;=2910304
	;;^DD(350,.14,0)
	;;=DATE BILLED FROM^D^^0;14^S %DT="EX" D ^%DT S X=Y K:Y<1 X
	;;^DD(350,.14,1,0)
	;;=^.1^^0
	;;^DD(350,.14,21,0)
	;;=^^1^1^2920414^^^^
	;;^DD(350,.14,21,1,0)
	;;=This is the first date in the date range covered by this billing action.
	;;^DD(350,.14,"DT")
	;;=2920302
	;;^DD(350,.15,0)
	;;=DATE BILLED TO^D^^0;15^S %DT="EX" D ^%DT S X=Y K:Y<1 X
	;;^DD(350,.15,21,0)
	;;=^^1^1^2920414^^
	;;^DD(350,.15,21,1,0)
	;;=This is the last date in the date range covered by this billing action.
	;;^DD(350,.15,"DT")
	;;=2911008
	;;^DD(350,.16,0)
	;;=PARENT EVENT^P350'^IB(^0;16^Q
	;;^DD(350,.16,1,0)
	;;=^.1
	;;^DD(350,.16,1,1,0)
	;;=350^AF
	;;^DD(350,.16,1,1,1)
	;;=S ^IB("AF",$E(X,1,30),DA)=""
	;;^DD(350,.16,1,1,2)
	;;=K ^IB("AF",$E(X,1,30),DA)
	;;^DD(350,.16,1,1,"%D",0)
	;;=^^2^2^2911009^
	;;^DD(350,.16,1,1,"%D",1,0)
	;;=This cross-reference will be used to link all Means Test/Category C
	;;^DD(350,.16,1,1,"%D",2,0)
	;;=co-payment and per diem charges to a particular billable event.
	;;^DD(350,.16,1,1,"DT")
	;;=2911009
	;;^DD(350,.16,1,2,0)
	;;=350^ACT1^MUMPS
	;;^DD(350,.16,1,2,1)
	;;=I $D(^IB(DA,0)),$P(^(0),"^",5)=1,$P($G(^IBE(350.1,+$P(^(0),"^",3),0)),"^")'["ADMISSION" S ^IB("ACT",X,DA)=""
	;;^DD(350,.16,1,2,2)
	;;=K ^IB("ACT",X,DA)
	;;^DD(350,.16,1,2,"%D",0)
	;;=^^9^9^2920115^^^^
	;;^DD(350,.16,1,2,"%D",1,0)
	;;=Cross-reference of all IB ACTIONS for Means Test/Category C charges
	;;^DD(350,.16,1,2,"%D",2,0)
	;;=which have a status (field #.05) of INCOMPLETE.
	;;^DD(350,.16,1,2,"%D",3,0)
	;;= 
	;;^DD(350,.16,1,2,"%D",4,0)
	;;=This is a temporary cross-reference which is used to locate per diem
	;;^DD(350,.16,1,2,"%D",5,0)
	;;=and co-payment charges, for an inpatient/NHCU admission, which are
	;;^DD(350,.16,1,2,"%D",6,0)
	;;=established, but not yet passed to AR.  The cross-reference is set
	;;^DD(350,.16,1,2,"%D",7,0)
	;;=whenever the status (#.05) of a billable charge is changed to 1
	;;^DD(350,.16,1,2,"%D",8,0)
	;;=(INCOMPLETE), and killed without condition.  The "ACT" cross-reference
	;;^DD(350,.16,1,2,"%D",9,0)
	;;=on the status field is the companion to this cross-reference.
	;;^DD(350,.16,1,2,"DT")
	;;=2911106
	;;^DD(350,.16,21,0)
	;;=^^12^12^2940209^^^^
	;;^DD(350,.16,21,1,0)
	;;=This field is used only for IB ACTION entries (both events and charges)
	;;^DD(350,.16,21,2,0)
	;;=which are associated with Category C billing.
	;;^DD(350,.16,21,3,0)
	;;= 
	;;^DD(350,.16,21,4,0)
	;;=This field is a pointer to the IB ACTION event (inpatient/NHCU admission
	;;^DD(350,.16,21,5,0)
	;;=or outpatient visit) for which the charges are being billed.  For an
	;;^DD(350,.16,21,6,0)
	;;=event entry, this field will point to itself.  For all IB ACTION charges 
	;;^DD(350,.16,21,7,0)
	;;=(new, cancelled, and updated) associated with a billable event,
	;;^DD(350,.16,21,8,0)
	;;=this field will point to that event.
	;;^DD(350,.16,21,9,0)
	;;= 
	;;^DD(350,.16,21,10,0)
	;;=Note that cancelled and updated actions will still point to the parent
	;;^DD(350,.16,21,11,0)
	;;=(new) action through the Parent Charge (.09) field, in the same manner
	;;^DD(350,.16,21,12,0)
	;;=as Pharmacy co-pay charges.
	;;^DD(350,.16,"DT")
	;;=2911106
	;;^DD(350,.17,0)
	;;=EVENT DATE^D^^0;17^S %DT="EX" D ^%DT S X=Y K:Y<1 X
	;;^DD(350,.17,1,0)
	;;=^.1
	;;^DD(350,.17,1,1,0)
	;;=350^AFDT1^MUMPS
	;;^DD(350,.17,1,1,1)
	;;=I $D(^IB(DA,0)),$P(^(0),"^",2) S ^IB("AFDT",$P(^(0),"^",2),-X,DA)=""
	;;^DD(350,.17,1,1,2)
	;;=I $D(^IB(DA,0)),$P(^(0),"^",2) K ^IB("AFDT",$P(^(0),"^",2),-X,DA)
	;;^DD(350,.17,1,1,"%D",0)
	;;=^^5^5^2911227^^^
