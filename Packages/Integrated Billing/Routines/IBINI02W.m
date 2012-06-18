IBINI02W	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(350.9)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(350.9,6.19,0)
	;;=PSYCH WEEKLY ADMISSIONS^NJ2,0^^6;19^K:+X'=X!(X>99)!(X<5)!(X?.E1"."1N.N) X
	;;^DD(350.9,6.19,3)
	;;=Type a Number between 5 and 99, 0 Decimal Digits
	;;^DD(350.9,6.19,21,0)
	;;=^^3^3^2930805^
	;;^DD(350.9,6.19,21,1,0)
	;;=This is the minimum number of admissions for Psychiatry that your Medical
	;;^DD(350.9,6.19,21,2,0)
	;;=Center generally averages.  This is used along with the Psychiatry
	;;^DD(350.9,6.19,21,3,0)
	;;=sample size to compute a random number.
	;;^DD(350.9,6.19,"DT")
	;;=2930901
	;;^DD(350.9,6.2,0)
	;;=PSYCH RANDOM NUMBER^NJ2,0^^6;20^K:+X'=X!(X>99)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(350.9,6.2,3)
	;;=Type a Number between 1 and 99, 0 Decimal Digits
	;;^DD(350.9,6.2,21,0)
	;;=^^4^4^2940209^^
	;;^DD(350.9,6.2,21,1,0)
	;;=This is an internally computed random number.  It is re-computed each
	;;^DD(350.9,6.2,21,2,0)
	;;=week.  When the count of the Psychiatry admissions reaches a multiple of
	;;^DD(350.9,6.2,21,3,0)
	;;=this number it is considered the random selection.  The total number
	;;^DD(350.9,6.2,21,4,0)
	;;=of random selections for UR will not exceed the Psychiatry sample size.
	;;^DD(350.9,6.2,"DT")
	;;=2930804
	;;^DD(350.9,6.21,0)
	;;=PSYCH ENTRIES MET^NJ2,0^^6;21^K:+X'=X!(X>99)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(350.9,6.21,3)
	;;=Type a Number between 1 and 99, 0 Decimal Digits
	;;^DD(350.9,6.21,21,0)
	;;=^^1^1^2930805^
	;;^DD(350.9,6.21,21,1,0)
	;;=This is the number of random selections generated this week.
	;;^DD(350.9,6.21,"DT")
	;;=2930804
	;;^DD(350.9,6.22,0)
	;;=PSYCH ADMISSION COUNTER^NJ2,0^^6;22^K:+X'=X!(X>99)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(350.9,6.22,3)
	;;=Type a Number between 1 and 99, 0 Decimal Digits
	;;^DD(350.9,6.22,21,0)
	;;=^^2^2^2930805^
	;;^DD(350.9,6.22,21,1,0)
	;;=This is the number of admissions for this service counted by the
	;;^DD(350.9,6.22,21,2,0)
	;;=claims tracking module so far this week.
	;;^DD(350.9,6.22,"DT")
	;;=2930804
	;;^DD(350.9,6.23,0)
	;;=REPORTS ADD TO CLAIMS TRACKING^S^0:NO;1:YES;^6;23^Q
	;;^DD(350.9,6.23,3)
	;;=Should the Patients with Insurance Reports add entries to claims tracking.
	;;^DD(350.9,6.23,21,0)
	;;=^^10^10^2940209^^
	;;^DD(350.9,6.23,21,1,0)
	;;=This field determines whether or not you wish to allow the Veterans with
	;;^DD(350.9,6.23,21,2,0)
	;;=Insurance reports to add entries to Claims tracking.  If you answer 'YES'
	;;^DD(350.9,6.23,21,3,0)
	;;=then admisssions and outpatient visits found as billable but not found
	;;^DD(350.9,6.23,21,4,0)
	;;=in claims tracking will be added to claims tracking for billing information
	;;^DD(350.9,6.23,21,5,0)
	;;=purposes only.  No review will be set up.  This is to allow flagging of
	;;^DD(350.9,6.23,21,6,0)
	;;=these visits as unbillable so that they can be removed from these reports.
	;;^DD(350.9,6.23,21,7,0)
	;;=Answering 'YES' does not guarantee that the entry will be added.  The 
	;;^DD(350.9,6.23,21,8,0)
	;;=related parameters about whether Claims Tracking is turned on and the
	;;^DD(350.9,6.23,21,9,0)
	;;=Claims Tracking Start Date will override this parameter.
	;;^DD(350.9,6.23,21,10,0)
	;;= 
	;;^DD(350.9,6.23,23,0)
	;;=^^1^1^2940209^^
	;;^DD(350.9,6.23,23,1,0)
	;;= 
	;;^DD(350.9,6.23,"DT")
	;;=2931026
	;;^DD(350.9,7.01,0)
	;;=AUTO BILLER FREQUENCY^NJ4,0^^7;1^K:+X'=X!(X>9999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(350.9,7.01,3)
	;;=Type a Number between 0 and 9999, 0 Decimal Digits
	;;^DD(350.9,7.01,21,0)
	;;=^^8^8^2931122^^^^
	;;^DD(350.9,7.01,21,1,0)
	;;=Enter the number of days between each execution of the automated biller.
	;;^DD(350.9,7.01,21,2,0)
	;;=For example, if the auto biller should run only once a week, enter 7.
