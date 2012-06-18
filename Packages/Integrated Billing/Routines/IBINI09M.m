IBINI09M	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(362.1)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(362.1,.02,"DT")
	;;=2930905
	;;^DD(362.1,.03,0)
	;;=BILL NUMBER^P399'^DGCR(399,^0;3^Q
	;;^DD(362.1,.03,1,0)
	;;=^.1
	;;^DD(362.1,.03,1,1,0)
	;;=362.1^D
	;;^DD(362.1,.03,1,1,1)
	;;=S ^IBA(362.1,"D",$E(X,1,30),DA)=""
	;;^DD(362.1,.03,1,1,2)
	;;=K ^IBA(362.1,"D",$E(X,1,30),DA)
	;;^DD(362.1,.03,1,1,"DT")
	;;=2930906
	;;^DD(362.1,.03,3)
	;;=Enter a bill number.
	;;^DD(362.1,.03,21,0)
	;;=^^1^1^2931229^
	;;^DD(362.1,.03,21,1,0)
	;;=This is the bill associated with the Claims Tracking event, if any.
	;;^DD(362.1,.03,"DT")
	;;=2930906
	;;^DD(362.1,.05,0)
	;;=DATE ENTERED^RD^^0;5^S %DT="EX" D ^%DT S X=Y K:Y<1 X
	;;^DD(362.1,.05,1,0)
	;;=^.1^^0
	;;^DD(362.1,.05,3)
	;;=Enter a date.
	;;^DD(362.1,.05,21,0)
	;;=^^3^3^2931229^
	;;^DD(362.1,.05,21,1,0)
	;;=This is the date the event was added to the comments file.  This is
	;;^DD(362.1,.05,21,2,0)
	;;=usually the date the auto biller first tried to create a bill for the
	;;^DD(362.1,.05,21,3,0)
	;;=event.
	;;^DD(362.1,.05,"DT")
	;;=2940211
	;;^DD(362.1,11,0)
	;;=COMMENTS^362.111^^11;0
	;;^DD(362.1,11,21,0)
	;;=^^2^2^2931229^
	;;^DD(362.1,11,21,1,0)
	;;=Comments associated with the Claims Tracking event the the Bill/Claims 
	;;^DD(362.1,11,21,2,0)
	;;=bill.
	;;^DD(362.111,0)
	;;=COMMENTS SUB-FIELD^^.01^1
	;;^DD(362.111,0,"DT")
	;;=2930903
	;;^DD(362.111,0,"NM","COMMENTS")
	;;=
	;;^DD(362.111,0,"UP")
	;;=362.1
	;;^DD(362.111,.01,0)
	;;=COMMENTS^W^^0;1^Q
	;;^DD(362.111,.01,"DT")
	;;=2930903
