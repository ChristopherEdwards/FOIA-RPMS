IBONI003	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"PRO",463,0)
	;;=IB MEANS TEST EVENT^IB Edit a means test event^^A^^^^^^^^
	;;^UTILITY(U,$J,"PRO",463,1,0)
	;;=^^2^2^2920403^
	;;^UTILITY(U,$J,"PRO",463,1,1,0)
	;;=This protocol will send a bulletin to billing when ever
	;;^UTILITY(U,$J,"PRO",463,1,2,0)
	;;=a change to a past means test may affect billing.
	;;^UTILITY(U,$J,"PRO",463,20)
	;;=D ^IBAMTED
	;;^UTILITY(U,$J,"PRO",463,99)
	;;=55356,43344
	;;^UTILITY(U,$J,"PRO",463,"MEN","DG MEANS TEST EVENTS")
	;;=463
	;;^UTILITY(U,$J,"PRO",562,0)
	;;=IBACM PASS CHARGE^Pass a Charge^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",562,.1)
	;;=Pass
	;;^UTILITY(U,$J,"PRO",562,1,0)
	;;=^^2^2^2920428^
	;;^UTILITY(U,$J,"PRO",562,1,1,0)
	;;=This protocol passes a Category C charge to Accounts Recievable, resulting
	;;^UTILITY(U,$J,"PRO",562,1,2,0)
	;;=in a change in its STATUS.
	;;^UTILITY(U,$J,"PRO",562,2,0)
	;;=^101.02A^1^1
	;;^UTILITY(U,$J,"PRO",562,2,1,0)
	;;=PC
	;;^UTILITY(U,$J,"PRO",562,2,"B","PC",1)
	;;=
	;;^UTILITY(U,$J,"PRO",562,4)
	;;=^^^Pass a Charge
	;;^UTILITY(U,$J,"PRO",562,20)
	;;=D PASS^IBECEA1
	;;^UTILITY(U,$J,"PRO",562,99)
	;;=55356,43473
	;;^UTILITY(U,$J,"PRO",562,"MEN","IBACM1 MENU")
	;;=562^PC^12
	;;^UTILITY(U,$J,"PRO",680,0)
	;;=IB EXEMPTION EVENTS^IB Exemption Event Driver^^X^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",680,1,0)
	;;=^^3^3^2930121^
	;;^UTILITY(U,$J,"PRO",680,1,1,0)
	;;=This is the Integrated Billing Exemption Event driver.  It is invoked
	;;^UTILITY(U,$J,"PRO",680,1,2,0)
	;;=every time an Pharmacy Co-pay Exemption is added.  See routine
	;;^UTILITY(U,$J,"PRO",680,1,3,0)
	;;=IBARXEVT for details.
	;;^UTILITY(U,$J,"PRO",680,4)
	;;=^^^RX
	;;^UTILITY(U,$J,"PRO",680,10,0)
	;;=^101.01PA^0^1
	;;^UTILITY(U,$J,"PRO",680,99)
	;;=55763,56723
	;;^UTILITY(U,$J,"PRO",783,0)
	;;=IBACM UPDATE EVENT^Update Events^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",783,1,0)
	;;=^^5^5^2940211^^
	;;^UTILITY(U,$J,"PRO",783,1,1,0)
	;;=This menu protocol provides the user the tools needed to adjust the
	;;^UTILITY(U,$J,"PRO",783,1,2,0)
	;;=Means Test billing event record which is established for inpatient
	;;^UTILITY(U,$J,"PRO",783,1,3,0)
	;;=billing episodes.  Normally, the event record does not need to be
	;;^UTILITY(U,$J,"PRO",783,1,4,0)
	;;=managed, but if the system crashes or a logical error occurs, it
	;;^UTILITY(U,$J,"PRO",783,1,5,0)
	;;=may be necessary to adjust this record.
	;;^UTILITY(U,$J,"PRO",783,4)
	;;=^^^Update Events
	;;^UTILITY(U,$J,"PRO",783,20)
	;;=D EN^IBECEA5
	;;^UTILITY(U,$J,"PRO",783,99)
	;;=55924,41864
	;;^UTILITY(U,$J,"PRO",784,0)
	;;=IBACME EVENT MENU^Event Menu^^M^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",784,4)
	;;=26^4^^Event Menu
	;;^UTILITY(U,$J,"PRO",784,10,0)
	;;=^101.01PA^2^2
	;;^UTILITY(U,$J,"PRO",784,10,1,0)
	;;=785^CS^10
	;;^UTILITY(U,$J,"PRO",784,10,1,"^")
	;;=IBACME CHANGE STATUS
	;;^UTILITY(U,$J,"PRO",784,10,2,0)
	;;=786^LC^11
	;;^UTILITY(U,$J,"PRO",784,10,2,"^")
	;;=IBACME LAST CALC
	;;^UTILITY(U,$J,"PRO",784,26)
	;;=D SHOW^VALM
	;;^UTILITY(U,$J,"PRO",784,28)
	;;=Select Event: 
	;;^UTILITY(U,$J,"PRO",784,99)
	;;=55878,44550
	;;^UTILITY(U,$J,"PRO",785,0)
	;;=IBACME CHANGE STATUS^Change Status^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",785,1,0)
	;;=^^5^5^2930826^
	;;^UTILITY(U,$J,"PRO",785,1,1,0)
	;;=This protocol may be used to open or close a Means Test Billing event
	;;^UTILITY(U,$J,"PRO",785,1,2,0)
	;;=record.  If the record is opened, and the patient still admitted,
	;;^UTILITY(U,$J,"PRO",785,1,3,0)
	;;=Means Test billing will resume.  If the patient has been discharged
