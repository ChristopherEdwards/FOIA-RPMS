IBINI03C	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(352.3)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(352.3,.02,21,2,0)
	;;=code should be activated or ignored.
	;;^DD(352.3,.02,"DT")
	;;=2930720
	;;^DD(352.3,.03,0)
	;;=IGNORE MEANS TEST BILLING?^RS^1:YES;0:NO;^0;3^Q
	;;^DD(352.3,.03,3)
	;;=Please enter 'YES' or 'NO.'
	;;^DD(352.3,.03,21,0)
	;;=^^5^5^2930805^^^^
	;;^DD(352.3,.03,21,1,0)
	;;=This field is used to determine whether Means Test billing should
	;;^DD(352.3,.03,21,2,0)
	;;=be activated or ignored, as of the EFFECTIVE DATE (field #.02).
	;;^DD(352.3,.03,21,3,0)
	;;= 
	;;^DD(352.3,.03,21,4,0)
	;;=Please note that you only need an entry in this file for a clinic
	;;^DD(352.3,.03,21,5,0)
	;;=stop code for which you would like Means Test billing to be IGNORED.
	;;^DD(352.3,.03,"DT")
	;;=2930805
