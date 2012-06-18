IBINI030	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(351)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(351,.04,1,1,"%D",6,0)
	;;=killed whenever the patient field is defined.  The "ACT" cross-reference
	;;^DD(351,.04,1,1,"%D",7,0)
	;;=on the patient field is the companion to this cross-reference.
	;;^DD(351,.04,1,1,"DT")
	;;=2911106
	;;^DD(351,.04,3)
	;;=Enter the present status for this billing clock.
	;;^DD(351,.04,21,0)
	;;=^^7^7^2920415^^^^
	;;^DD(351,.04,21,1,0)
	;;=The status of the billing clock will be CURRENT if charges are being
	;;^DD(351,.04,21,2,0)
	;;=created for that clock.  The clock will be CLOSED after 365 days or
	;;^DD(351,.04,21,3,0)
	;;=the date on which the patient is no longer Category C, whichever is
	;;^DD(351,.04,21,4,0)
	;;=earlier.  Billing clocks which may have been "left open" due to a lack
	;;^DD(351,.04,21,5,0)
	;;=of billable activity will be closed during the nightly compilation
	;;^DD(351,.04,21,6,0)
	;;=job.  Billing clocks which must be deleted for any reason will
	;;^DD(351,.04,21,7,0)
	;;=have a status of CANCELLED.
	;;^DD(351,.04,"DT")
	;;=2911106
	;;^DD(351,.05,0)
	;;=1ST 90 DAY INPATIENT AMOUNT^NJ7,2^^0;5^S:X["$" X=$P(X,"$",2) K:X'?.N.1".".2N!(X>9999.99)!(X<0) X
	;;^DD(351,.05,3)
	;;=Type a Dollar Amount between 0 and 9999.99, 2 Decimal Digits
	;;^DD(351,.05,21,0)
	;;=^^3^3^2920415^^^^
	;;^DD(351,.05,21,1,0)
	;;=This field represents the total co-payment (not including the per diem
	;;^DD(351,.05,21,2,0)
	;;=charge) amount which has been billed to the patient for his first 90 days
	;;^DD(351,.05,21,3,0)
	;;=of Hospital or Nursing Home care.
	;;^DD(351,.05,"DT")
	;;=2911009
	;;^DD(351,.06,0)
	;;=2ND 90 DAY INPATIENT AMOUNT^NJ7,2^^0;6^S:X["$" X=$P(X,"$",2) K:X'?.N.1".".2N!(X>9999.99)!(X<0) X
	;;^DD(351,.06,3)
	;;=Type a Dollar Amount between 0 and 9999.99, 2 Decimal Digits
	;;^DD(351,.06,21,0)
	;;=^^3^3^2920415^^^
	;;^DD(351,.06,21,1,0)
	;;=This field represents the total co-payment (not including the per diem
	;;^DD(351,.06,21,2,0)
	;;=charge) amount which has been billed to the patient for his second 90 days
	;;^DD(351,.06,21,3,0)
	;;=of Hospital or Nursing Home care.
	;;^DD(351,.06,"DT")
	;;=2911009
	;;^DD(351,.07,0)
	;;=3RD 90 DAY INPATIENT AMOUNT^NJ7,2^^0;7^S:X["$" X=$P(X,"$",2) K:X'?.N.1".".2N!(X>9999.99)!(X<0) X
	;;^DD(351,.07,3)
	;;=Type a Dollar Amount between 0 and 9999.99, 2 Decimal Digits
	;;^DD(351,.07,21,0)
	;;=^^3^3^2920415^^^
	;;^DD(351,.07,21,1,0)
	;;=This field represents the total co-payment (not including the per diem
	;;^DD(351,.07,21,2,0)
	;;=charge) amount which has been billed to the patient for his third 90 days
	;;^DD(351,.07,21,3,0)
	;;=of Hospital or Nursing Home care.
	;;^DD(351,.07,"DT")
	;;=2911009
	;;^DD(351,.08,0)
	;;=4TH 90 DAY INPATIENT AMOUNT^NJ7,2^^0;8^S:X["$" X=$P(X,"$",2) K:X'?.N.1".".2N!(X>9999.99)!(X<0) X
	;;^DD(351,.08,3)
	;;=Type a Dollar Amount between 0 and 9999.99, 2 Decimal Digits
	;;^DD(351,.08,21,0)
	;;=^^3^3^2920415^^^
	;;^DD(351,.08,21,1,0)
	;;=This field represents the total co-payment (not including the per diem
	;;^DD(351,.08,21,2,0)
	;;=charge) amount which has been billed to the patient for his fourth 90 days
	;;^DD(351,.08,21,3,0)
	;;=of Hospital or Nursing Home care.
	;;^DD(351,.08,"DT")
	;;=2911009
	;;^DD(351,.09,0)
	;;=NUMBER INPATIENT DAYS^NJ3,0^^0;9^K:+X'=X!(X>365)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(351,.09,3)
	;;=Type a Number between 0 and 365, 0 Decimal Digits
	;;^DD(351,.09,21,0)
	;;=^^4^4^2920225^^^
	;;^DD(351,.09,21,1,0)
	;;=This field represents the total number of days that the patient has
	;;^DD(351,.09,21,2,0)
	;;=spent in the Hospital or Nursing Home since the Clock Begin Date.
