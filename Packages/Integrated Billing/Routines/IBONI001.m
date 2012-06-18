IBONI001	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"PRO",420,0)
	;;=IBACM1 DATE CHANGE^Change Date Range^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",420,1,0)
	;;=^^1^1^2930305^^^^
	;;^UTILITY(U,$J,"PRO",420,1,1,0)
	;;=Change range of dates to search for Billable Events.
	;;^UTILITY(U,$J,"PRO",420,15)
	;;=D EXIT^IBECEA
	;;^UTILITY(U,$J,"PRO",420,20)
	;;=D DATE^IBECEA
	;;^UTILITY(U,$J,"PRO",420,99)
	;;=55356,43484
	;;^UTILITY(U,$J,"PRO",420,"MEN","IBACM1 MENU")
	;;=420^CD^11
	;;^UTILITY(U,$J,"PRO",421,0)
	;;=IBACM PATIENT CHANGE^Change Patient^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",421,1,0)
	;;=^^1^1^2920203^^^^
	;;^UTILITY(U,$J,"PRO",421,1,1,0)
	;;=Change patient to search for Billable Events.
	;;^UTILITY(U,$J,"PRO",421,15)
	;;=D EXIT^IBECEA
	;;^UTILITY(U,$J,"PRO",421,20)
	;;=D PAT^IBECEA
	;;^UTILITY(U,$J,"PRO",421,99)
	;;=55356,43475
	;;^UTILITY(U,$J,"PRO",421,"MEN","IBACM1 MENU")
	;;=421^CP^10
	;;^UTILITY(U,$J,"PRO",435,0)
	;;=IBACM ADD CHARGE^Add a Charge^^X^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",435,1,0)
	;;=^^1^1^2920427^^^^
	;;^UTILITY(U,$J,"PRO",435,1,1,0)
	;;=This extended protocol performs all actions for adding a charge.
	;;^UTILITY(U,$J,"PRO",435,2,0)
	;;=^101.02A^1^1
	;;^UTILITY(U,$J,"PRO",435,2,1,0)
	;;=AC
	;;^UTILITY(U,$J,"PRO",435,2,"B","AC",1)
	;;=
	;;^UTILITY(U,$J,"PRO",435,4)
	;;=^
	;;^UTILITY(U,$J,"PRO",435,10,0)
	;;=^101.01PA^1^1
	;;^UTILITY(U,$J,"PRO",435,10,1,0)
	;;=440^^1
	;;^UTILITY(U,$J,"PRO",435,10,1,"^")
	;;=IBACM ADD CHARGE ONE
	;;^UTILITY(U,$J,"PRO",435,15)
	;;=
	;;^UTILITY(U,$J,"PRO",435,20)
	;;=
	;;^UTILITY(U,$J,"PRO",435,99)
	;;=55356,43353
	;;^UTILITY(U,$J,"PRO",435,"MEN","IBACM1 MENU")
	;;=435^AC^1
	;;^UTILITY(U,$J,"PRO",437,0)
	;;=IBACM CANCEL CHARGE^Cancel a Charge^^X^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",437,1,0)
	;;=^^1^1^2920203^^^^
	;;^UTILITY(U,$J,"PRO",437,1,1,0)
	;;=Cancel an existing charge.
	;;^UTILITY(U,$J,"PRO",437,2,0)
	;;=^101.02A^1^1
	;;^UTILITY(U,$J,"PRO",437,2,1,0)
	;;=CC
	;;^UTILITY(U,$J,"PRO",437,2,"B","CC",1)
	;;=
	;;^UTILITY(U,$J,"PRO",437,10,0)
	;;=^101.01PA^1^1
	;;^UTILITY(U,$J,"PRO",437,10,1,0)
	;;=442^^1
	;;^UTILITY(U,$J,"PRO",437,10,1,"^")
	;;=IBACM CANCEL CHARGE ONE
	;;^UTILITY(U,$J,"PRO",437,15)
	;;=K IBNOD
	;;^UTILITY(U,$J,"PRO",437,20)
	;;=S IBNOD(0)=XQORNOD(0)
	;;^UTILITY(U,$J,"PRO",437,99)
	;;=55356,43395
	;;^UTILITY(U,$J,"PRO",437,"MEN","IBACM1 MENU")
	;;=437^CC^3
	;;^UTILITY(U,$J,"PRO",438,0)
	;;=IBACM UPDATE CHARGE^Edit a Charge^^X^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",438,1,0)
	;;=^^2^2^2920203^^^^
	;;^UTILITY(U,$J,"PRO",438,1,1,0)
	;;=This extended protocol performs all actions for updating a charge.
	;;^UTILITY(U,$J,"PRO",438,1,2,0)
	;;=(Cancel previous charge, add new charge.)
	;;^UTILITY(U,$J,"PRO",438,2,0)
	;;=^101.02A^1^1
	;;^UTILITY(U,$J,"PRO",438,2,1,0)
	;;=EC
	;;^UTILITY(U,$J,"PRO",438,2,"B","EC",1)
	;;=
	;;^UTILITY(U,$J,"PRO",438,10,0)
	;;=^101.01PA^1^1
	;;^UTILITY(U,$J,"PRO",438,10,1,0)
	;;=443^^1
	;;^UTILITY(U,$J,"PRO",438,10,1,"^")
	;;=IBACM UPDATE CHARGE ONE
	;;^UTILITY(U,$J,"PRO",438,15)
	;;=K IBNOD
	;;^UTILITY(U,$J,"PRO",438,20)
	;;=S IBNOD(0)=XQORNOD(0)
	;;^UTILITY(U,$J,"PRO",438,99)
	;;=55356,43483
	;;^UTILITY(U,$J,"PRO",438,"MEN","IBACM1 MENU")
	;;=438^EC^2
	;;^UTILITY(U,$J,"PRO",440,0)
	;;=IBACM ADD CHARGE ONE^Add a Charge^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",440,1,0)
	;;=^^1^1^2920427^^^^
	;;^UTILITY(U,$J,"PRO",440,1,1,0)
	;;=This protocol adds a charge to the ib action file.
	;;^UTILITY(U,$J,"PRO",440,20)
	;;=D ADD^IBECEA1
	;;^UTILITY(U,$J,"PRO",440,99)
	;;=55356,43353
	;;^UTILITY(U,$J,"PRO",440,"MEN","IBACM ADD CHARGE")
	;;=440^^1
