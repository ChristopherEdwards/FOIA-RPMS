IBINI0AN	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(399)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(399,212,5,1,0)
	;;=399^210^1
	;;^DD(399,212,9)
	;;=^
	;;^DD(399,212,21,0)
	;;=^^2^2^2880901^
	;;^DD(399,212,21,1,0)
	;;=These are the charges incurred during the second fiscal year associated
	;;^DD(399,212,21,2,0)
	;;=with this bill.
	;;^DD(399,212,"DT")
	;;=2880708
	;;^DD(399,213,0)
	;;=FORM LOCATOR 92^F^^U1;13^K:$L(X)>32!($L(X)<3) X
	;;^DD(399,213,3)
	;;=Answer must be 3-32 characters in length.
	;;^DD(399,213,21,0)
	;;=^^4^4^2940214^^^^
	;;^DD(399,213,21,1,0)
	;;=This is the Attending Physician ID (UPIN) and is printed on the UB-82 in
	;;^DD(399,213,21,2,0)
	;;=form locator 92 and form locator 82 on the UB-92.  This field will be
	;;^DD(399,213,21,3,0)
	;;=loaded with the ATTENDING PHYSICIAN ID code required by the primary
	;;^DD(399,213,21,4,0)
	;;=insurer, if that insurer has a code defined.
	;;^DD(399,213,23,0)
	;;=^^5^5^2940214^^^^
	;;^DD(399,213,23,1,0)
	;;=This field may be null or a value the billing clerk inserted while editing
	;;^DD(399,213,23,2,0)
	;;=on screen 8 or a value that the primary insurer requires to print in form
	;;^DD(399,213,23,3,0)
	;;=locator 92 of the UB-82 or FL 82 of the UB-92.  If the field is null
	;;^DD(399,213,23,4,0)
	;;=then the print routines print the string 'Dept. of Veterans Affairs' in
	;;^DD(399,213,23,5,0)
	;;=form locator 82/92.
	;;^DD(399,213,"DT")
	;;=2931216
	;;^DD(399,214,0)
	;;=FORM LOCATOR 93^F^^U1;14^K:$L(X)>32!($L(X)<3) X
	;;^DD(399,214,3)
	;;=Answer must be 3-32 characters in length.
	;;^DD(399,214,21,0)
	;;=^^4^4^2940120^^^^
	;;^DD(399,214,21,1,0)
	;;=Enter the 'Other Physician ID'.  The name and/or number of the licensed
	;;^DD(399,214,21,2,0)
	;;=physician other than the attending physician or what the primary insurer
	;;^DD(399,214,21,3,0)
	;;=requires in this field on the form.  Will print in form locator 93 on the
	;;^DD(399,214,21,4,0)
	;;=UB-82 and form locator 83 on the UB-92.
	;;^DD(399,214,"DT")
	;;=2931216
	;;^DD(399,215,0)
	;;=ADMITTING DIAGNOSIS^P80'^ICD9(^U2;1^Q
	;;^DD(399,215,3)
	;;=Enter the code for the admitting diagnosis.
	;;^DD(399,215,21,0)
	;;=^^4^4^2931220^^^^
	;;^DD(399,215,21,1,0)
	;;=The ICD-9 diagnosis code provided at the time of admission as stated
	;;^DD(399,215,21,2,0)
	;;=by the physician.
	;;^DD(399,215,21,3,0)
	;;= 
	;;^DD(399,215,21,4,0)
	;;=The admitting diagnosis code will be printed in Form Locator 76 on the UB-92.
	;;^DD(399,215,"DT")
	;;=2931220
	;;^DD(399,216,0)
	;;=COVERED DAYS^NJ3,0^^U2;2^K:+X'=X!(X>999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(399,216,3)
	;;=Type a Number between 0 and 999, 0 Decimal Digits
	;;^DD(399,216,21,0)
	;;=^^4^4^2940201^
	;;^DD(399,216,21,1,0)
	;;=The number of days covered by the primary payer, as qualified by the payer
	;;^DD(399,216,21,2,0)
	;;=organization.
	;;^DD(399,216,21,3,0)
	;;= 
	;;^DD(399,216,21,4,0)
	;;=Form Locator 7 on the UB-92.
	;;^DD(399,216,"DT")
	;;=2940201
	;;^DD(399,217,0)
	;;=NON-COVERED DAYS^NJ4,0^^U2;3^K:+X'=X!(X>9999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(399,217,3)
	;;=Type a Number between 0 and 9999, 0 Decimal Digits
	;;^DD(399,217,21,0)
	;;=^^1^1^2940201^
	;;^DD(399,217,21,1,0)
	;;=Days of care not covered by the primary payer.  Form Locator 8 on the UB-92.
	;;^DD(399,217,"DT")
	;;=2940201
	;;^DD(399,301,0)
	;;=PRIMARY NODE^RF^^I1;E1,240^K:$L(X)>240!($L(X)<1) X
	;;^DD(399,301,3)
	;;=This is the information pertaining to the primary insurance carrier associated with this bill.
	;;^DD(399,301,21,0)
	;;=^^2^2^2930622^^
	;;^DD(399,301,21,1,0)
	;;=This is the information pertaining to the primary insurance carrier which
	;;^DD(399,301,21,2,0)
	;;=is associated with this bill.
