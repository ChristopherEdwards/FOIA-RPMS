IBINI02J	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(350.9)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(350.9,1.17,21,3,0)
	;;=will be displayed all CPT codes stored in the Scheduling Visits file
	;;^DD(350.9,1.17,21,4,0)
	;;=for the date range of the bill if the parameter is set to 'YES'.
	;;^DD(350.9,1.17,21,5,0)
	;;=This display screen will prompt the user if they would like to
	;;^DD(350.9,1.17,21,6,0)
	;;=easily import any or all of the CPT codes into the bill.  This will
	;;^DD(350.9,1.17,21,7,0)
	;;=include both Ambulatory Procedures and the Billable Ambulatory
	;;^DD(350.9,1.17,21,8,0)
	;;=Surgical Codes.
	;;^DD(350.9,1.18,0)
	;;=DEFAULT AMB SURG REV CODE^*P399.2'^DGCR(399.2,^1;18^S DIC("S")="I $P(^(0),U,3)" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(350.9,1.18,3)
	;;=Enter the Revenue Code that you will usually want for Ambulatory Surgery.
	;;^DD(350.9,1.18,21,0)
	;;=^^5^5^2920224^^^
	;;^DD(350.9,1.18,21,1,0)
	;;=When billing Billable Ambulatory Surgical Codes (BASC), this will be
	;;^DD(350.9,1.18,21,2,0)
	;;=the default revenue code stored in the bill.  If this is not appropriate
	;;^DD(350.9,1.18,21,3,0)
	;;=for any particular insurance company then the field AMBULATORY SURG. REV.
	;;^DD(350.9,1.18,21,4,0)
	;;=CODE in the Insurance Company file may be entered and it will be used
	;;^DD(350.9,1.18,21,5,0)
	;;=for that particular insurance company entry.
	;;^DD(350.9,1.19,0)
	;;=TRANSFER PROCEDURES TO SCHED?^S^1:YES;0:NO;^1;19^Q
	;;^DD(350.9,1.19,3)
	;;=Enter '1' or 'YES' if you would like the person entering a bill to be able to automatically store the CPT procedures in a bill in the Scheduling Visits file.
	;;^DD(350.9,1.19,21,0)
	;;=^^13^13^2920224^^^^
	;;^DD(350.9,1.19,21,1,0)
	;;=CPT procedures may be stored as Ambulatory Procedures in the Scheduling
	;;^DD(350.9,1.19,21,2,0)
	;;=Visits file (using the Add/Edit Stop Code option) and they may be stored
	;;^DD(350.9,1.19,21,3,0)
	;;=in the billing record as procedures to print on a bill.  There is now a two
	;;^DD(350.9,1.19,21,4,0)
	;;=way sharing of information between these two files.  If this parameter
	;;^DD(350.9,1.19,21,5,0)
	;;=is answered 'YES' then as CPT procedures are entered in a bill that
	;;^DD(350.9,1.19,21,6,0)
	;;=are also Ambulatory Procedures, then the user will be prompted as to whether
	;;^DD(350.9,1.19,21,7,0)
	;;=they should be transfered to the Scheduling Visits file also.  The
	;;^DD(350.9,1.19,21,8,0)
	;;=reverse of this is the parameter USE OP CPT SCREEN? which allows
	;;^DD(350.9,1.19,21,9,0)
	;;=importing of Ambulatory Procedures into a bill.
	;;^DD(350.9,1.19,21,10,0)
	;;= 
	;;^DD(350.9,1.19,21,11,0)
	;;=Only CPT procedures that are either Billable Ambulatory Surgical Codes
	;;^DD(350.9,1.19,21,12,0)
	;;=or either Nationally or Locally active Ambulatory Procedures may be
	;;^DD(350.9,1.19,21,13,0)
	;;=transfered.
	;;^DD(350.9,1.19,"DT")
	;;=2920205
	;;^DD(350.9,1.2,0)
	;;=HOLD MT BILLS W/INS^S^1:YES;0:NO;^1;20^Q
	;;^DD(350.9,1.2,3)
	;;=Enter 'Yes' if automated Means Test Charges should be held until claim disposition from an insurance Company.  If 'Yes' and a patient has insurance then the bills will automatically be placed on hold.
	;;^DD(350.9,1.2,21,0)
	;;=^^5^5^2920302^
	;;^DD(350.9,1.2,21,1,0)
	;;=If this parameter is answered 'YES' then the automated Category C
	;;^DD(350.9,1.2,21,2,0)
	;;=bills will automatically be placed on hold if the Patient has 
	;;^DD(350.9,1.2,21,3,0)
	;;=active Insurance.  The bills will need to
	;;^DD(350.9,1.2,21,4,0)
	;;=be released to Accounts Receivable after claim disposition from
	;;^DD(350.9,1.2,21,5,0)
	;;=the Insurance Company.
