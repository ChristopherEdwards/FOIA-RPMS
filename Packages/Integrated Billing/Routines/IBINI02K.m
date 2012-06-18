IBINI02K	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(350.9)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(350.9,1.2,"DT")
	;;=2920302
	;;^DD(350.9,1.21,0)
	;;=MEDICARE PROVIDER NUMBER^F^^1;21^K:$L(X)>8!($L(X)<1) X
	;;^DD(350.9,1.21,3)
	;;=Enter the number Medicare provided your facility.  Answer must be 1-8 characters in length.
	;;^DD(350.9,1.21,21,0)
	;;=^^2^2^2940209^^^^
	;;^DD(350.9,1.21,21,1,0)
	;;=This is the 1-8 character number provided by Medicare to the facility.
	;;^DD(350.9,1.21,21,2,0)
	;;= 
	;;^DD(350.9,1.21,22)
	;;=
	;;^DD(350.9,1.21,"DT")
	;;=2920306
	;;^DD(350.9,1.22,0)
	;;=MULTIPLE FORM TYPES^S^1:YES;0:NO;^1;22^Q
	;;^DD(350.9,1.22,3)
	;;=Enter 'Y'es if your facility uses the HCFA 1500 as well as one of the UB claim forms.
	;;^DD(350.9,1.22,21,0)
	;;=^^7^7^2940209^^^^
	;;^DD(350.9,1.22,21,1,0)
	;;=Set this field to 'YES' if the facility uses more than one health insurance
	;;^DD(350.9,1.22,21,2,0)
	;;=form type.  The UB-82 and the UB-92 are considered a single form because
	;;^DD(350.9,1.22,21,3,0)
	;;=one is replacing the other.  Therefore, if your site uses one of the UB
	;;^DD(350.9,1.22,21,4,0)
	;;=forms and the HCFA 1500 then this should be answered 'YES'.  If your site
	;;^DD(350.9,1.22,21,5,0)
	;;=is only using the UB forms (UB-82 and/or UB-92) then answer 'NO'.  If this
	;;^DD(350.9,1.22,21,6,0)
	;;=is set to 'NO' or left blank then only the UB type claim forms will be 
	;;^DD(350.9,1.22,21,7,0)
	;;=allowed.
	;;^DD(350.9,1.22,"DT")
	;;=2920414
	;;^DD(350.9,1.23,0)
	;;=CAN INITIATOR AUTHORIZE?^S^1:YES;0:NO;^1;23^Q
	;;^DD(350.9,1.23,21,0)
	;;=^^6^6^2920428^
	;;^DD(350.9,1.23,21,1,0)
	;;=Beginning with IB Version 1.5, the Review step in creating a bill has
	;;^DD(350.9,1.23,21,2,0)
	;;=been eliminated.  If this parameter is answered YES and the initiator
	;;^DD(350.9,1.23,21,3,0)
	;;=holds the IB AUTHORIZE key then the initiator
	;;^DD(350.9,1.23,21,4,0)
	;;=of the bill will be allowed to Authorize the Bill.  If this is answered
	;;^DD(350.9,1.23,21,5,0)
	;;=no then another user who holds the IB AUTHORIZE key will have to authorize
	;;^DD(350.9,1.23,21,6,0)
	;;=the bill.
	;;^DD(350.9,1.23,"DT")
	;;=2920428
	;;^DD(350.9,1.24,0)
	;;=BASC START DATE^D^^1;24^S %DT="EX" D ^%DT S X=Y K:Y<1 X
	;;^DD(350.9,1.24,21,0)
	;;=^^6^6^2920616^^^^
	;;^DD(350.9,1.24,21,1,0)
	;;=This is the date that facilities can begin billing Ambulatory Surgical
	;;^DD(350.9,1.24,21,2,0)
	;;=Code Rates.  The earliest date is the date that IB Version 1.5 was installed
	;;^DD(350.9,1.24,21,3,0)
	;;=at the site or the date the regulation allowing BASC billing was approved.
	;;^DD(350.9,1.24,21,4,0)
	;;=This date will be stored automatically in the file.
	;;^DD(350.9,1.24,21,5,0)
	;;= 
	;;^DD(350.9,1.24,21,6,0)
	;;=If this field is null then BASC rates will not automatically calculate.
	;;^DD(350.9,1.24,"DT")
	;;=2920506
	;;^DD(350.9,1.25,0)
	;;=DEFAULT DIVISION^P40.8^DG(40.8,^1;25^Q
	;;^DD(350.9,1.25,3)
	;;=Enter the division you wish to show as a default division when entering procedures into a bill.
	;;^DD(350.9,1.25,21,0)
	;;=^^2^2^2920526^
	;;^DD(350.9,1.25,21,1,0)
	;;=This field will be used as the default answer to the division question when
	;;^DD(350.9,1.25,21,2,0)
	;;=entering Billable Ambulatory Surgeries into a bill.
	;;^DD(350.9,1.25,"DT")
	;;=2920526
	;;^DD(350.9,1.26,0)
	;;=DEFAULT FORM TYPE^*P353'^IBE(353,^1;26^S DIC("S")="I $P(^IBE(353,Y,0),U,1)[""UB""" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(350.9,1.26,3)
	;;=Enter the form type that is most commonly used at your facility.
	;;^DD(350.9,1.26,12)
	;;=Only UB form types can be chosen.
	;;^DD(350.9,1.26,12.1)
	;;=S DIC("S")="I $P(^IBE(353,Y,0),U,1)[""UB"""
