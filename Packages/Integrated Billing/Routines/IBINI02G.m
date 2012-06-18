IBINI02G	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(350.9)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(350.9,.14,21,4,0)
	;;=available for the Medication Copayment Exemption functionality.  If
	;;^DD(350.9,.14,21,5,0)
	;;=this is a desirable feature it may be expanded in the future.
	;;^DD(350.9,.14,21,6,0)
	;;= 
	;;^DD(350.9,.14,21,7,0)
	;;=If this field is unanswered, the default is No and IB will use bulletins.
	;;^DD(350.9,.14,23,0)
	;;=^^3^3^2930204^^
	;;^DD(350.9,.14,23,1,0)
	;;=The node ^DD(200,0,"VR") is checked for version number.  If the 
	;;^DD(350.9,.14,23,2,0)
	;;=value of this node is less than 7 then the user will not be able
	;;^DD(350.9,.14,23,3,0)
	;;=to turn this feature on.
	;;^DD(350.9,.14,"DT")
	;;=2930204
	;;^DD(350.9,.15,0)
	;;=SUPPRESS MT INS BULLETIN^S^1:YES;0:NO;^0;15^Q
	;;^DD(350.9,.15,21,0)
	;;=^^4^4^2930805^
	;;^DD(350.9,.15,21,1,0)
	;;=This parameter is used to control the bulletin that is posted when
	;;^DD(350.9,.15,21,2,0)
	;;=any Means Test charge which might be covered by the patient's health
	;;^DD(350.9,.15,21,3,0)
	;;=insurance is billed.  If the site wishes to suppress this bulletin,
	;;^DD(350.9,.15,21,4,0)
	;;=then this parameter should be answered 'Yes'.
	;;^DD(350.9,.15,"DT")
	;;=2930805
	;;^DD(350.9,1.01,0)
	;;=NAME OF CLAIM FORM SIGNER^F^^1;1^K:$L(X)>20!($L(X)<2) X
	;;^DD(350.9,1.01,3)
	;;=Enter the name of the person responsible for signing third party bills as it should appear on the bills.  Answer must be 2-20 characters in length
	;;^DD(350.9,1.01,21,0)
	;;=^^2^2^2940209^^^^
	;;^DD(350.9,1.01,21,1,0)
	;;=This is the name of the signer of third party bills and will be printed
	;;^DD(350.9,1.01,21,2,0)
	;;=on the claim form in the signature block.
	;;^DD(350.9,1.01,"DT")
	;;=2940119
	;;^DD(350.9,1.02,0)
	;;=TITLE OF CLAIM FORM SIGNER^F^^1;2^K:$L(X)>20!($L(X)<2) X
	;;^DD(350.9,1.02,3)
	;;=Enter the title of the person responsible for signing this bill as it should appear on the bill.  Answer must be 2-20 characters in length.
	;;^DD(350.9,1.02,21,0)
	;;=^^2^2^2940209^^^
	;;^DD(350.9,1.02,21,1,0)
	;;=This is the title of the person signing the claim form as it will appear on
	;;^DD(350.9,1.02,21,2,0)
	;;=the bill.
	;;^DD(350.9,1.02,"DT")
	;;=2940119
	;;^DD(350.9,1.03,0)
	;;=*CAN REVIEWER AUTHORIZE?^S^1:YES;0:NO;^1;3^Q
	;;^DD(350.9,1.03,3)
	;;=Enter 1 or 'YES' if the person who reviews a billing record is also able to authorize that record.
	;;^DD(350.9,1.03,21,0)
	;;=^^9^9^2940209^^^^
	;;^DD(350.9,1.03,21,1,0)
	;;=Creating a third party bill is a 4 part process.  The bill is Entered,
	;;^DD(350.9,1.03,21,2,0)
	;;=Reviewed, Authorized, and Printed.  The bill is considered complete and
	;;^DD(350.9,1.03,21,3,0)
	;;=passed to Accounts Receivable immediately after it has been Authorized.
	;;^DD(350.9,1.03,21,4,0)
	;;=This parameter is used to determine if the same person who Reviewed the
	;;^DD(350.9,1.03,21,5,0)
	;;=bill can Authorize the bill.  If the paramater CAN INITIATOR REVIEW? 
	;;^DD(350.9,1.03,21,6,0)
	;;=and this parameter, CAN REVIEWER AUTHORIZE?, are both answered "YES"
	;;^DD(350.9,1.03,21,7,0)
	;;=then the same individual can perform all 4 parts of the billing process.
	;;^DD(350.9,1.03,21,8,0)
	;;=If either parameter is answered 'NO' then more than one person must
	;;^DD(350.9,1.03,21,9,0)
	;;=be involved in each bill.
	;;^DD(350.9,1.03,23,0)
	;;=^^1^1^2940209^^
	;;^DD(350.9,1.03,23,1,0)
	;;=This field should be deleted in the next release of IB after v2.0.
	;;^DD(350.9,1.03,"DT")
	;;=2920429
	;;^DD(350.9,1.04,0)
	;;=REMARKS TO APPEAR ON EACH FORM^F^^1;4^K:$L(X)>39!($L(X)<2) X
	;;^DD(350.9,1.04,3)
	;;=Enter any facility specific remarks which you would like to print on every UB bill.  Answer must be 2-39 characters in length.
