IBINI02I	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(350.9)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(350.9,1.1,21,2,0)
	;;=the total charges if this parameter is set to 'YES'.
	;;^DD(350.9,1.1,"DT")
	;;=2920204
	;;^DD(350.9,1.11,0)
	;;=*CAN INITIATOR REVIEW^S^1:YES;0:NO;^1;11^Q
	;;^DD(350.9,1.11,3)
	;;=Enter 1 or 'YES' if the person who created/edited a billing record is also able to review that record.
	;;^DD(350.9,1.11,21,0)
	;;=^^9^9^2940209^^^^
	;;^DD(350.9,1.11,21,1,0)
	;;=Creating a third party bill is a 4 part process.  The bill is Entered,
	;;^DD(350.9,1.11,21,2,0)
	;;=Reviewed, Authorized, and Printed.  The bill is considered complete and
	;;^DD(350.9,1.11,21,3,0)
	;;=passed to Accounts Receivable immediately after it has been Authorized.
	;;^DD(350.9,1.11,21,4,0)
	;;=This parameter is used to determine if the same person who Reviewed the
	;;^DD(350.9,1.11,21,5,0)
	;;=bill can Authorize the bill.  If the paramater CAN REVIEWER AUTHORIZE?
	;;^DD(350.9,1.11,21,6,0)
	;;=and this parameter, CAN INITIATOR REVIEW?, are both answered "YES" then
	;;^DD(350.9,1.11,21,7,0)
	;;=the same individual can perform all 4 parts of the billing process.  If
	;;^DD(350.9,1.11,21,8,0)
	;;=either parameter is answered "NO" then more than one person must be
	;;^DD(350.9,1.11,21,9,0)
	;;=involved in each bill.
	;;^DD(350.9,1.11,23,0)
	;;=^^1^1^2940209^
	;;^DD(350.9,1.11,23,1,0)
	;;=This field should be deleted in the next release of IB after v2.0.
	;;^DD(350.9,1.11,"DT")
	;;=2920429
	;;^DD(350.9,1.14,0)
	;;=MAS SERVICE POINTER^RP49'^DIC(49,^1;14^Q
	;;^DD(350.9,1.14,3)
	;;=Enter the Service/Section which is your facilities MAS Service.
	;;^DD(350.9,1.14,21,0)
	;;=^^3^3^2940209^^
	;;^DD(350.9,1.14,21,1,0)
	;;=Accounts Receivable requires that every bill be associated with a
	;;^DD(350.9,1.14,21,2,0)
	;;=SERVICE/SECTION.  This is the Service that will be identified with bills
	;;^DD(350.9,1.14,21,3,0)
	;;=sent to Accounts Receivable from the Integrated Billing Module.
	;;^DD(350.9,1.15,0)
	;;=CAN CLERK ENTER NON-PTF CODES?^S^1:YES;0:NO;^1;15^Q
	;;^DD(350.9,1.15,3)
	;;=Enter '1' or 'YES' if diagnosis and procedure codes not found in the PTF record may be entered by the billing clerk into a billing record.  This affects inpatient bills only.
	;;^DD(350.9,1.15,21,0)
	;;=^^4^4^2920205^
	;;^DD(350.9,1.15,21,1,0)
	;;=Answering 'YES' to this parameter will also allow billing clerks to enter
	;;^DD(350.9,1.15,21,2,0)
	;;=CPT and HCPS codes into the billing record as well as ICD diagnosis and
	;;^DD(350.9,1.15,21,3,0)
	;;=Procedure codes that are not in the corresponding PTF record.  This
	;;^DD(350.9,1.15,21,4,0)
	;;=parameter only affects inpatient bills.
	;;^DD(350.9,1.16,0)
	;;=ASK HINQ IN MCCR^S^1:YES;0:NO;^1;16^Q
	;;^DD(350.9,1.16,3)
	;;=Enter '1' or 'YES' if you want the person entering a new bill to be able to request a HINQ inquiry for bills on patients with unverified eligibility.
	;;^DD(350.9,1.16,21,0)
	;;=^^3^3^2920205^
	;;^DD(350.9,1.16,21,1,0)
	;;=When creating a new bill on a Veteran with unverified eligibility the
	;;^DD(350.9,1.16,21,2,0)
	;;=user may be asked if they would like to put a HINQ request in the HINQ
	;;^DD(350.9,1.16,21,3,0)
	;;=SUSPENSE file if this parameter is answered 'YES'.
	;;^DD(350.9,1.17,0)
	;;=USE OP CPT SCREEN?^S^1:YES;0:NO;^1;17^Q
	;;^DD(350.9,1.17,3)
	;;=Enter '1' or 'YES' if you want the person entering an outpatient bill to easily transfer CPT procedures from scheduling into the bill.
	;;^DD(350.9,1.17,21,0)
	;;=^^8^8^2920602^^
	;;^DD(350.9,1.17,21,1,0)
	;;=CPT codes for outpatient visits are currently stored as Ambulatory
	;;^DD(350.9,1.17,21,2,0)
	;;=Procedures in the Scheduling Visits file.  The user editing a bill
