IBINI03V	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(354.1)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(354.1,.14,21,0)
	;;=^^4^4^2930430^^
	;;^DD(354.1,.14,21,1,0)
	;;=If this exemption requires retroactively canceling prior charges, this
	;;^DD(354.1,.14,21,2,0)
	;;=is the ending date for the retroactive cancellation.  This must be   
	;;^DD(354.1,.14,21,3,0)
	;;=tracked to prevent duplicate retroactive cancellations of the same      
	;;^DD(354.1,.14,21,4,0)
	;;=charges.
	;;^DD(354.1,.14,"DT")
	;;=2930113
	;;^DD(354.1,.15,0)
	;;=PRIOR YEAR THRESHOLDS^D^^0;15^S %DT="E" D ^%DT S X=Y K:Y<1 X
	;;^DD(354.1,.15,1,0)
	;;=^.1
	;;^DD(354.1,.15,1,1,0)
	;;=354.1^APRIOR
	;;^DD(354.1,.15,1,1,1)
	;;=S ^IBA(354.1,"APRIOR",$E(X,1,30),DA)=""
	;;^DD(354.1,.15,1,1,2)
	;;=K ^IBA(354.1,"APRIOR",$E(X,1,30),DA)
	;;^DD(354.1,.15,1,1,"%D",0)
	;;=^^5^5^2930430^^
	;;^DD(354.1,.15,1,1,"%D",1,0)
	;;=This is a cross reference of all active exemptions created with prior
	;;^DD(354.1,.15,1,1,"%D",2,0)
	;;=year thresholds.  It will be used when entering new thresholds to
	;;^DD(354.1,.15,1,1,"%D",3,0)
	;;=identfy patient exemptions in need of updating.  It will be deleted
	;;^DD(354.1,.15,1,1,"%D",4,0)
	;;=by the IB INACTIVATE EXEMPTION TEMPLATE when creating a new exemption
	;;^DD(354.1,.15,1,1,"%D",5,0)
	;;=for this date.
	;;^DD(354.1,.15,1,1,"DT")
	;;=2930126
	;;^DD(354.1,.15,21,0)
	;;=^^5^5^2930430^
	;;^DD(354.1,.15,21,1,0)
	;;=This field will contain the date of the threshold used to calculate
	;;^DD(354.1,.15,21,2,0)
	;;=exemptions based on income only if the date of the threshold was
	;;^DD(354.1,.15,21,3,0)
	;;=over 1 year in the past.  This will be used by the add threshold 
	;;^DD(354.1,.15,21,4,0)
	;;=option to list and recompute these exemptions when new thresholds
	;;^DD(354.1,.15,21,5,0)
	;;=are entered.
	;;^DD(354.1,.15,"DT")
	;;=2930126
