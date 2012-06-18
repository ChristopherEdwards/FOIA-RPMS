IBINI07C	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(356.93)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(356.93,.03,"DT")
	;;=2931130
	;;^DD(356.93,.04,0)
	;;=ESTIMATED LENGTH OF STAY^NJ7,1^^0;4^K:+X'=X!(X>99999)!(X<0)!(X?.E1"."2N.N) X
	;;^DD(356.93,.04,1,0)
	;;=^.1
	;;^DD(356.93,.04,1,1,0)
	;;=356.93^AC^MUMPS
	;;^DD(356.93,.04,1,1,1)
	;;=Q
	;;^DD(356.93,.04,1,1,2)
	;;=Q
	;;^DD(356.93,.04,1,1,"%D",0)
	;;=^^3^3^2931215^
	;;^DD(356.93,.04,1,1,"%D",1,0)
	;;=Cross-reference to cause filing of data.  Field Days Remaining 
	;;^DD(356.93,.04,1,1,"%D",2,0)
	;;=utilizes value in input transform and may not be filed without this
	;;^DD(356.93,.04,1,1,"%D",3,0)
	;;=x-ref.
	;;^DD(356.93,.04,1,1,"DT")
	;;=2931215
	;;^DD(356.93,.04,3)
	;;=Type a Number between 0 and 99999, 1 Decimal Digit
	;;^DD(356.93,.04,21,0)
	;;=^^5^5^2940213^^^
	;;^DD(356.93,.04,21,1,0)
	;;=This is the estimated length of stay in the medical center for UR or
	;;^DD(356.93,.04,21,2,0)
	;;=Insurance purposes.  This is not related to the average length of 
	;;^DD(356.93,.04,21,3,0)
	;;=stays for PTF.  It is the estimated LOS for this admission for this
	;;^DD(356.93,.04,21,4,0)
	;;=patient for this DRG.  It is used to help determine if for billing
	;;^DD(356.93,.04,21,5,0)
	;;=purposes that this patient has exceeded his length of stay.
	;;^DD(356.93,.04,"DT")
	;;=2931215
	;;^DD(356.93,.05,0)
	;;=DAYS REMAINING^NJ5,0X^^0;5^K:+X'=X!(X>99999)!(X<0)!(X?.E1"."1N.N)!(X>$P($G(^IBT(356.93,DA,0)),"^",4)) X
	;;^DD(356.93,.05,3)
	;;=The Days Remaining can not exceed the Estimated Length of Stay.  Type a Number between 0 and 99999, 0 Decimal Digits
	;;^DD(356.93,.05,21,0)
	;;=^^3^3^2940213^^
	;;^DD(356.93,.05,21,1,0)
	;;=This is the days remaining that this patient has for this DRG.
	;;^DD(356.93,.05,21,2,0)
	;;=It is the ELOS minus the number of days the patient has already been
	;;^DD(356.93,.05,21,3,0)
	;;=treated for this episode.
	;;^DD(356.93,.05,"DT")
	;;=2931201
