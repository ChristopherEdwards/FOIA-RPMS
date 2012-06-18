IBONI002	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"PRO",441,0)
	;;=IBACM OP LINK^Integrated Billing link to Scheduling^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",441,1,0)
	;;=^^1^1^2940210^^^^
	;;^UTILITY(U,$J,"PRO",441,1,1,0)
	;;=Automate OP billing via link to Scheduling
	;;^UTILITY(U,$J,"PRO",441,20)
	;;=D ^IBAMTS
	;;^UTILITY(U,$J,"PRO",441,99)
	;;=55755,47370
	;;^UTILITY(U,$J,"PRO",441,"MEN","SDAM APPOINTMENT EVENTS")
	;;=441^^4
	;;^UTILITY(U,$J,"PRO",442,0)
	;;=IBACM CANCEL CHARGE ONE^Cancel a Charge^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",442,1,0)
	;;=^^1^1^2920203^^^^
	;;^UTILITY(U,$J,"PRO",442,1,1,0)
	;;=Cancel a charge .
	;;^UTILITY(U,$J,"PRO",442,20)
	;;=D CAN^IBECEA1
	;;^UTILITY(U,$J,"PRO",442,99)
	;;=55356,43395
	;;^UTILITY(U,$J,"PRO",442,"MEN","IBACM CANCEL CHARGE")
	;;=442^^1
	;;^UTILITY(U,$J,"PRO",443,0)
	;;=IBACM UPDATE CHARGE ONE^Update a charge.^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",443,1,0)
	;;=^^1^1^2920203^^^^
	;;^UTILITY(U,$J,"PRO",443,1,1,0)
	;;=Update a charge (cancel previous charge, create a new one).
	;;^UTILITY(U,$J,"PRO",443,15)
	;;=
	;;^UTILITY(U,$J,"PRO",443,20)
	;;=D UPD^IBECEA1
	;;^UTILITY(U,$J,"PRO",443,99)
	;;=55356,43483
	;;^UTILITY(U,$J,"PRO",443,"MEN","IBACM UPDATE CHARGE")
	;;=443^^1
	;;^UTILITY(U,$J,"PRO",445,0)
	;;=IBACM1 MENU^Add/Edit/Cancel Charges^^M^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",445,4)
	;;=26^4
	;;^UTILITY(U,$J,"PRO",445,10,0)
	;;=^101.01PA^7^15
	;;^UTILITY(U,$J,"PRO",445,10,1,0)
	;;=435^AC^1
	;;^UTILITY(U,$J,"PRO",445,10,1,"^")
	;;=IBACM ADD CHARGE
	;;^UTILITY(U,$J,"PRO",445,10,2,0)
	;;=438^EC^2
	;;^UTILITY(U,$J,"PRO",445,10,2,"^")
	;;=IBACM UPDATE CHARGE
	;;^UTILITY(U,$J,"PRO",445,10,3,0)
	;;=437^CC^3
	;;^UTILITY(U,$J,"PRO",445,10,3,"^")
	;;=IBACM CANCEL CHARGE
	;;^UTILITY(U,$J,"PRO",445,10,4,0)
	;;=421^CP^10
	;;^UTILITY(U,$J,"PRO",445,10,4,"^")
	;;=IBACM PATIENT CHANGE
	;;^UTILITY(U,$J,"PRO",445,10,5,0)
	;;=420^CD^11
	;;^UTILITY(U,$J,"PRO",445,10,5,"^")
	;;=IBACM1 DATE CHANGE
	;;^UTILITY(U,$J,"PRO",445,10,13,0)
	;;=562^PC^12
	;;^UTILITY(U,$J,"PRO",445,10,13,"^")
	;;=IBACM PASS CHARGE
	;;^UTILITY(U,$J,"PRO",445,10,15,0)
	;;=783^UE^20
	;;^UTILITY(U,$J,"PRO",445,10,15,"^")
	;;=IBACM UPDATE EVENT
	;;^UTILITY(U,$J,"PRO",445,20)
	;;=Q
	;;^UTILITY(U,$J,"PRO",445,26)
	;;=D SHOW^VALM
	;;^UTILITY(U,$J,"PRO",445,28)
	;;=Select Action: 
	;;^UTILITY(U,$J,"PRO",445,99)
	;;=55924,41897
	;;^UTILITY(U,$J,"PRO",446,0)
	;;=IB CATEGORY C BILLING^CATEGORY C BILLING^^X^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",446,1,0)
	;;=^^1^1^2940311^^
	;;^UTILITY(U,$J,"PRO",446,1,1,0)
	;;=Category C billing for ADT activity will be initiated through this option.
	;;^UTILITY(U,$J,"PRO",446,5)
	;;=
	;;^UTILITY(U,$J,"PRO",446,20)
	;;=D ^IBAMTD
	;;^UTILITY(U,$J,"PRO",446,99)
	;;=55356,43342
	;;^UTILITY(U,$J,"PRO",446,"MEN","DGPM MOVEMENT EVENTS")
	;;=446^^10
	;;^UTILITY(U,$J,"PRO",460,0)
	;;=SD PARM PARAMETERS MENU^Scheduling Parameters^^M^^^^^^^^SCHEDULING
	;;^UTILITY(U,$J,"PRO",460,1,0)
	;;=^^1^1^2920616^^^^
	;;^UTILITY(U,$J,"PRO",460,1,1,0)
	;;=This menu contains all the activities for the scheduling parameter option.
	;;^UTILITY(U,$J,"PRO",460,4)
	;;=26^4
	;;^UTILITY(U,$J,"PRO",460,10,0)
	;;=^101.01PA^2^11
	;;^UTILITY(U,$J,"PRO",460,10,12,0)
	;;=876^CL^9
	;;^UTILITY(U,$J,"PRO",460,10,12,"^")
	;;=IBDF PRINT MANAGER CLINIC SETUP
	;;^UTILITY(U,$J,"PRO",460,10,13,0)
	;;=877^DV^10
	;;^UTILITY(U,$J,"PRO",460,10,13,"^")
	;;=IBDF PRINT MANAGER DIVISION SETUP
	;;^UTILITY(U,$J,"PRO",460,26)
	;;=D SHOW^VALM
	;;^UTILITY(U,$J,"PRO",460,28)
	;;=Select Action: 
	;;^UTILITY(U,$J,"PRO",460,99)
	;;=55867,31443
