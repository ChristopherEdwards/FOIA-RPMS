IBINI02U	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(350.9)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(350.9,6.05,0)
	;;=PROSTHETICS CLAIMS TRACKING^S^0:OFF;1:INSURED ONLY;2:ALL PATIENTS;^6;5^Q
	;;^DD(350.9,6.05,3)
	;;=
	;;^DD(350.9,6.05,21,0)
	;;=^^6^6^2940130^^
	;;^DD(350.9,6.05,21,1,0)
	;;=This field will be used to determine if prosthetics should be tracked in
	;;^DD(350.9,6.05,21,2,0)
	;;=the claims tracking module.  If this parameter is set to OFF, then no
	;;^DD(350.9,6.05,21,3,0)
	;;=prosthetic entries will be added to claims tracking.  If this is set to
	;;^DD(350.9,6.05,21,4,0)
	;;=INSURED ONLY then only parameter entries for insured patients will be
	;;^DD(350.9,6.05,21,5,0)
	;;=added to claims tracking.  If this is set to ALL PATIENTS then an
	;;^DD(350.9,6.05,21,6,0)
	;;=entry will be created for all patients prosthetic items.
	;;^DD(350.9,6.05,"DT")
	;;=2930804
	;;^DD(350.9,6.06,0)
	;;=USE ADMISSION SHEETS^S^0:NO;1:YES;^6;6^Q
	;;^DD(350.9,6.06,21,0)
	;;=^^4^4^2940130^^^
	;;^DD(350.9,6.06,21,1,0)
	;;=Enter whether your facility is using Admission Sheets as part of the
	;;^DD(350.9,6.06,21,2,0)
	;;=MCCR/UR functionality.  If this parameter is answered "YES" then
	;;^DD(350.9,6.06,21,3,0)
	;;=users will be asked for the device to print admissions sheets to.
	;;^DD(350.9,6.06,21,4,0)
	;;=The default device will be from the BILL FORM TYPE file.
	;;^DD(350.9,6.06,"DT")
	;;=2930804
	;;^DD(350.9,6.07,0)
	;;=RANDOM SAMPLE DATE^D^^6;7^S %DT="EX" D ^%DT S X=Y K:Y<1 X
	;;^DD(350.9,6.07,21,0)
	;;=^^3^3^2930804^
	;;^DD(350.9,6.07,21,1,0)
	;;=This is the date that random sampling was last re-generated.  The
	;;^DD(350.9,6.07,21,2,0)
	;;=IB background job will re-generate a new date, new random numbers,
	;;^DD(350.9,6.07,21,3,0)
	;;=and zero the counters every Sunday night.
	;;^DD(350.9,6.07,"DT")
	;;=2930804
	;;^DD(350.9,6.08,0)
	;;=MEDICINE SAMPLE SIZE^RNJ2,0^^6;8^K:+X'=X!(X>99)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(350.9,6.08,3)
	;;=Type a Number between 0 and 99, 0 Decimal Digits
	;;^DD(350.9,6.08,21,0)
	;;=^^3^3^2930805^^
	;;^DD(350.9,6.08,21,1,0)
	;;=This is the number of required Utilization Reviews that you wish to have
	;;^DD(350.9,6.08,21,2,0)
	;;=done each week for Medicine admissions.  The minimum recommended by
	;;^DD(350.9,6.08,21,3,0)
	;;=the QA office is one per week.
	;;^DD(350.9,6.08,"DT")
	;;=2940113
	;;^DD(350.9,6.09,0)
	;;=MEDICINE WEEKLY ADMISSIONS^NJ2,0^^6;9^K:+X'=X!(X>99)!(X<5)!(X?.E1"."1N.N) X
	;;^DD(350.9,6.09,3)
	;;=Type a Number between 5 and 99, 0 Decimal Digits
	;;^DD(350.9,6.09,21,0)
	;;=^^3^3^2930805^^^
	;;^DD(350.9,6.09,21,1,0)
	;;=This is the minimum number of admissions for Medicine that your Medical
	;;^DD(350.9,6.09,21,2,0)
	;;=Center generally averages.  This is used along with the Medicine
	;;^DD(350.9,6.09,21,3,0)
	;;=sample size to compute a random number.
	;;^DD(350.9,6.09,"DT")
	;;=2930804
	;;^DD(350.9,6.1,0)
	;;=MEDICINE RANDOM NUMBER^NJ2,0^^6;10^K:+X'=X!(X>99)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(350.9,6.1,3)
	;;=Type a Number between 1 and 99, 0 Decimal Digits
	;;^DD(350.9,6.1,21,0)
	;;=^^4^4^2940209^^^
	;;^DD(350.9,6.1,21,1,0)
	;;=This is an internally computed random number.  It is re-computed each
	;;^DD(350.9,6.1,21,2,0)
	;;=week.  When the count of the Medicine admissions reaches a multiple of
	;;^DD(350.9,6.1,21,3,0)
	;;=this number it is considered the random selection.  The total number
	;;^DD(350.9,6.1,21,4,0)
	;;=of random selections for UR will not exceed the Medicine sample size.
	;;^DD(350.9,6.1,"DT")
	;;=2930804
	;;^DD(350.9,6.11,0)
	;;=MEDICINE ENTRIES MET^NJ2,0^^6;11^K:+X'=X!(X>99)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(350.9,6.11,3)
	;;=Type a Number between 1 and 99, 0 Decimal Digits
