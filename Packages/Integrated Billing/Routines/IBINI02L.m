IBINI02L	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(350.9)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(350.9,1.26,21,0)
	;;=^^4^4^2940209^^^^
	;;^DD(350.9,1.26,21,1,0)
	;;=Enter the form type most commonly used at your facility.  Used for the
	;;^DD(350.9,1.26,21,2,0)
	;;=conversion between the UB-82 and the UB-92.  All new bills and
	;;^DD(350.9,1.26,21,3,0)
	;;=all follow-up bills will be printed on this form unless the primary
	;;^DD(350.9,1.26,21,4,0)
	;;=insurer has the other UB form defined as it's form type.
	;;^DD(350.9,1.26,23,0)
	;;=^^4^4^2940209^^^
	;;^DD(350.9,1.26,23,1,0)
	;;=Used specifically to help in the conversion from the UB-82 to the UB-92.
	;;^DD(350.9,1.26,23,2,0)
	;;=The UB-92 is replacing the UB-82, which will no longer be accepted after
	;;^DD(350.9,1.26,23,3,0)
	;;=a certain date, so that even follow-up bills that were originally printed
	;;^DD(350.9,1.26,23,4,0)
	;;=on the UB-82 must then be printed on the UB-92.
	;;^DD(350.9,1.26,"DT")
	;;=2931110
	;;^DD(350.9,1.27,0)
	;;=HCFA 1500 ADDRESS COLUMN^NJ2,0^^1;27^K:+X'=X!(X>80)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(350.9,1.27,3)
	;;=Type a Number between 1 and 80, 0 Decimal Digits.  Used only for the HCFA 1500 bill form.
	;;^DD(350.9,1.27,21,0)
	;;=^^2^2^2940209^^^^
	;;^DD(350.9,1.27,21,1,0)
	;;=This is the column that the mailing address will begin printing
	;;^DD(350.9,1.27,21,2,0)
	;;=on row 1 of the HCFA 1500 form.
	;;^DD(350.9,1.27,23,0)
	;;=^^5^5^2940209^^^^
	;;^DD(350.9,1.27,23,1,0)
	;;=Necessary because the latest version of the HCFA 1500 form has black
	;;^DD(350.9,1.27,23,2,0)
	;;=bars in the space where the mailing address is supposed to print.  With
	;;^DD(350.9,1.27,23,3,0)
	;;=this parameter the site can specify where the address prints, depending
	;;^DD(350.9,1.27,23,4,0)
	;;=on the type of envelope they use.  The first 5 rows are the only blank
	;;^DD(350.9,1.27,23,5,0)
	;;=space on the form available for the mailing address.
	;;^DD(350.9,1.27,"DT")
	;;=2940112
	;;^DD(350.9,1.28,0)
	;;=DEFAULT RX REFILL REV CODE^*P399.2'^DGCR(399.2,^1;28^S DIC("S")="I $P(^(0),U,3)" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(350.9,1.28,3)
	;;=Enter the revenue code that should be used for Rx Refills.
	;;^DD(350.9,1.28,12)
	;;=Only Activated Revenue Codes can be selected!
	;;^DD(350.9,1.28,12.1)
	;;=S DIC("S")="I $P(^(0),U,3)"
	;;^DD(350.9,1.28,21,0)
	;;=^^4^4^2940121^^
	;;^DD(350.9,1.28,21,1,0)
	;;=If entered, this Revenue Code will be used for all prescription refill's
	;;^DD(350.9,1.28,21,2,0)
	;;=on a bill when the revenue codes and charges are automatically calculated.
	;;^DD(350.9,1.28,21,3,0)
	;;=This default will be overridden by the PRESCRIPTION REFILL REV. CODE
	;;^DD(350.9,1.28,21,4,0)
	;;=for an insurance company, if one exists.
	;;^DD(350.9,1.28,"DT")
	;;=2940105
	;;^DD(350.9,1.29,0)
	;;=DEFAULT RX REFILL DX^P80'^ICD9(^1;29^Q
	;;^DD(350.9,1.29,3)
	;;=Enter a Diagnosis that should be added to every RX Refill bill.
	;;^DD(350.9,1.29,21,0)
	;;=^^2^2^2940121^^^
	;;^DD(350.9,1.29,21,1,0)
	;;=If entered, this diagnosis will be automatically added to every bill that
	;;^DD(350.9,1.29,21,2,0)
	;;=has prescription refills.
	;;^DD(350.9,1.29,23,0)
	;;=^^1^1^2940121^^
	;;^DD(350.9,1.29,23,1,0)
	;;=Should probably be a genaric code like V68.1 ISSUE REPEAT PRESCRIPT.
	;;^DD(350.9,1.29,"DT")
	;;=2940105
	;;^DD(350.9,1.3,0)
	;;=DEFAULT RX REFILL CPT^P81'^ICPT(^1;30^Q
	;;^DD(350.9,1.3,3)
	;;=Enter a CPT procedure code that should be printed on every bill that has RX Refills.
	;;^DD(350.9,1.3,21,0)
	;;=^^2^2^2940121^^^
	;;^DD(350.9,1.3,21,1,0)
	;;=If entered, this procedure will automatically be added to every bill
