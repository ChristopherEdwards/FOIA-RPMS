IBINI070	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(356.6)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(356.6,.04,"DT")
	;;=2930802
	;;^DD(356.6,.05,0)
	;;=BILLING CYCLE^NJ4,0^^0;5^K:+X'=X!(X>9999)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(356.6,.05,3)
	;;=Type a Number between 1 and 9999, 0 Decimal Digits.  Enter the number of days in the billing cycle for this type of claim.
	;;^DD(356.6,.05,21,0)
	;;=^^9^9^2931021^^^^
	;;^DD(356.6,.05,21,1,0)
	;;=This is the maximum number of days allowed on a single bill for this type
	;;^DD(356.6,.05,21,2,0)
	;;=of care.
	;;^DD(356.6,.05,21,3,0)
	;;= 
	;;^DD(356.6,.05,21,4,0)
	;;=For example, if outpatient bills have a billing cycle of 7 days then
	;;^DD(356.6,.05,21,5,0)
	;;=one bill will be created for a seven day period, which may contain 1
	;;^DD(356.6,.05,21,6,0)
	;;=visit or seven.
	;;^DD(356.6,.05,21,7,0)
	;;= 
	;;^DD(356.6,.05,21,8,0)
	;;=If this is left blank and the event type can be automatically billed then
	;;^DD(356.6,.05,21,9,0)
	;;=the bills will be created in one month intervals.
	;;^DD(356.6,.05,"DT")
	;;=2930802
	;;^DD(356.6,.06,0)
	;;=DAYS DELAY^NJ2,0^^0;6^K:+X'=X!(X>99)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(356.6,.06,3)
	;;=Type a Number between 1 and 99, 0 Decimal Digits.  Enter the number of days after a billing cycle completes that the Automated Biller should run.
	;;^DD(356.6,.06,21,0)
	;;=^^6^6^2931021^^
	;;^DD(356.6,.06,21,1,0)
	;;=This is the minimum number of days delay that apparently billable 
	;;^DD(356.6,.06,21,2,0)
	;;=visits (for this type of event type) should wait for auto billing.
	;;^DD(356.6,.06,21,3,0)
	;;= 
	;;^DD(356.6,.06,21,4,0)
	;;=This field works in conjunction with the field BILLING CYCLE to 
	;;^DD(356.6,.06,21,5,0)
	;;=determine what visits are included on a bill and when those bills can
	;;^DD(356.6,.06,21,6,0)
	;;=be created.
	;;^DD(356.6,.06,"DT")
	;;=2930802
	;;^DD(356.6,.08,0)
	;;=ENTRY CODE^NJ2,0I^^0;8^K:+X'=X!(X>99)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(356.6,.08,1,0)
	;;=^.1
	;;^DD(356.6,.08,1,1,0)
	;;=356.6^AC
	;;^DD(356.6,.08,1,1,1)
	;;=S ^IBE(356.6,"AC",$E(X,1,30),DA)=""
	;;^DD(356.6,.08,1,1,2)
	;;=K ^IBE(356.6,"AC",$E(X,1,30),DA)
	;;^DD(356.6,.08,1,1,"DT")
	;;=2940223
	;;^DD(356.6,.08,3)
	;;=Type a Number between 1 and 99, 0 Decimal Digits
	;;^DD(356.6,.08,21,0)
	;;=^^3^3^2940202^
	;;^DD(356.6,.08,21,1,0)
	;;=This field is designed to be used internally by the claims tracking module
	;;^DD(356.6,.08,21,2,0)
	;;=to uniquely identify an entry.  This number will intially be the same as
	;;^DD(356.6,.08,21,3,0)
	;;=the internal entry number.  It should not be edited.
	;;^DD(356.6,.08,"DT")
	;;=2940309
