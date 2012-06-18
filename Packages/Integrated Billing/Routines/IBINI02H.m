IBINI02H	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(350.9)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(350.9,1.04,21,0)
	;;=^^2^2^2940209^^^^
	;;^DD(350.9,1.04,21,1,0)
	;;=Enter any remarks that need to appear on every UB claim form.  This remark
	;;^DD(350.9,1.04,21,2,0)
	;;=will print in the remarks section of every UB-82 and UB-92.
	;;^DD(350.9,1.04,"DT")
	;;=2940119
	;;^DD(350.9,1.05,0)
	;;=FEDERAL TAX NUMBER^RF^^1;5^K:$L(X)>10!($L(X)<10)!'(X?2N1"-"7N) X
	;;^DD(350.9,1.05,3)
	;;=Enter the federal tax number for your facility in NN-NNNNNNN format.  Answer must be 10 characters in length.
	;;^DD(350.9,1.05,21,0)
	;;=^^2^2^2940209^^^^
	;;^DD(350.9,1.05,21,1,0)
	;;=This is your facility federal tax number.  If unknown, this may be obtained
	;;^DD(350.9,1.05,21,2,0)
	;;=from your Fiscal Service.
	;;^DD(350.9,1.05,23,0)
	;;=^^2^2^2940209^^^^
	;;^DD(350.9,1.05,23,1,0)
	;;=This is not editable from the billing screens.  Printed in Form Locator
	;;^DD(350.9,1.05,23,2,0)
	;;=6 of the UB-82 and in Form Locator 5 of the UB-92.
	;;^DD(350.9,1.05,"DT")
	;;=2920204
	;;^DD(350.9,1.06,0)
	;;=BLUE CROSS/SHIELD PROVIDER #^RF^^1;6^K:$L(X)>13!($L(X)<3) X
	;;^DD(350.9,1.06,3)
	;;=Enter the 3-13 character BC/BS Provider Number which will be the default for all billing episodes at this facility.  Answer must be 3-13 characters in length.
	;;^DD(350.9,1.06,21,0)
	;;=^^2^2^2920204^
	;;^DD(350.9,1.06,21,1,0)
	;;=This is the BC/BS Provider Number which Blue Cross has assigned your 
	;;^DD(350.9,1.06,21,2,0)
	;;=facility.
	;;^DD(350.9,1.06,"DT")
	;;=2920204
	;;^DD(350.9,1.07,0)
	;;=BILL CANCELLATION MAILGROUP^P3.8'^XMB(3.8,^1;7^Q
	;;^DD(350.9,1.07,3)
	;;=Enter the mail group you want notified whenever a third party bill is cancelled.  If none is entered no mailman notification will be made.
	;;^DD(350.9,1.07,21,0)
	;;=^^3^3^2940209^^^^
	;;^DD(350.9,1.07,21,1,0)
	;;=This is the mail group that will recieve automatic notification every
	;;^DD(350.9,1.07,21,2,0)
	;;=time a third party bill is cancelled.  This must be answered for the
	;;^DD(350.9,1.07,21,3,0)
	;;=automatic notification to occur.
	;;^DD(350.9,1.07,"DT")
	;;=2940119
	;;^DD(350.9,1.08,0)
	;;=BILLING SUPERVISOR NAME^RP200'^VA(200,^1;8^Q
	;;^DD(350.9,1.08,3)
	;;=Enter the Person who is the billing supervisor.
	;;^DD(350.9,1.08,21,0)
	;;=^^1^1^2920204^
	;;^DD(350.9,1.08,21,1,0)
	;;=This is the pointer to the PERSON file for the Billing Supervisor.
	;;^DD(350.9,1.08,"DT")
	;;=2920204
	;;^DD(350.9,1.09,0)
	;;=BILL DISAPPROVED MAILGROUP^P3.8'^XMB(3.8,^1;9^Q
	;;^DD(350.9,1.09,3)
	;;=When a third party bill is disapproved the supervisor and initiator of the bill will be notified.  If you want additional people notified create a mailgroup and specify it here.
	;;^DD(350.9,1.09,21,0)
	;;=^^5^5^2940209^^^^
	;;^DD(350.9,1.09,21,1,0)
	;;=When a third party bill is disapproved the supervisor and initiator of the
	;;^DD(350.9,1.09,21,2,0)
	;;=bill will be notified.  If you want additional people to be notified that a
	;;^DD(350.9,1.09,21,3,0)
	;;=bill has been disapproved then you must create a mail group and add the
	;;^DD(350.9,1.09,21,4,0)
	;;=member and then specify the group here.  The members of this mail group
	;;^DD(350.9,1.09,21,5,0)
	;;=will then recieve the disapproval bulletin.
	;;^DD(350.9,1.09,"DT")
	;;=2940119
	;;^DD(350.9,1.1,0)
	;;=PRINT '001' FOR TOTAL CHARGES?^S^1:YES;0:NO;^1;10^Q
	;;^DD(350.9,1.1,3)
	;;=Enter 'YES' if you want the Revenue Code '001' printed on each third party bill with the total charges.
	;;^DD(350.9,1.1,21,0)
	;;=^^2^2^2940209^^^
	;;^DD(350.9,1.1,21,1,0)
	;;=The revenue code '001', TOTAL CHARGES, may be printed on each bill with
