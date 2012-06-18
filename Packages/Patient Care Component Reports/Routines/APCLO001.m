APCLO001 ; IHS/OHPRD/TMJ - NO DESCRIPTION PROVIDED ; 
 ;;3.0;IHS PCC REPORTS;;FEB 05, 1997
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^UTILITY(U,$J,"PRO",547,0)
 ;;=APCL VGEN SELECTION ITEMS^Selection Items for Visit General Retrieval^^M^^^^^^^^IHS PCC REPORTS
 ;;^UTILITY(U,$J,"PRO",547,4)
 ;;=25
 ;;^UTILITY(U,$J,"PRO",547,10,0)
 ;;=^101.01PA^6^8
 ;;^UTILITY(U,$J,"PRO",547,10,1,0)
 ;;=553^S^10
 ;;^UTILITY(U,$J,"PRO",547,10,1,"^")
 ;;=APCL VGEN ADD ITEM
 ;;^UTILITY(U,$J,"PRO",547,10,4,0)
 ;;=549^+^50
 ;;^UTILITY(U,$J,"PRO",547,10,4,"^")
 ;;=APCL VGEN NEXT SCREEN
 ;;^UTILITY(U,$J,"PRO",547,10,5,0)
 ;;=550^-^60
 ;;^UTILITY(U,$J,"PRO",547,10,5,"^")
 ;;=APCL VGEN PREVIOUS SCREEN
 ;;^UTILITY(U,$J,"PRO",547,10,6,0)
 ;;=548^Q^75
 ;;^UTILITY(U,$J,"PRO",547,10,6,"^")
 ;;=APCL VGEN QUIT
 ;;^UTILITY(U,$J,"PRO",547,10,7,0)
 ;;=554^R^20
 ;;^UTILITY(U,$J,"PRO",547,10,7,"^")
 ;;=APCL VGEN DESELECT ITEM
 ;;^UTILITY(U,$J,"PRO",547,10,8,0)
 ;;=555^E^99
 ;;^UTILITY(U,$J,"PRO",547,10,8,"^")
 ;;=APCL VGEN EXIT REPORT
 ;;^UTILITY(U,$J,"PRO",547,26)
 ;;=D SHOW^VALM
 ;;^UTILITY(U,$J,"PRO",547,28)
 ;;=Select Action: 
 ;;^UTILITY(U,$J,"PRO",547,29)
 ;;=S
 ;;^UTILITY(U,$J,"PRO",547,99)
 ;;=56874,26696
 ;;^UTILITY(U,$J,"PRO",547,101.04)
 ;;=^S
 ;;^UTILITY(U,$J,"PRO",548,0)
 ;;=APCL VGEN QUIT^Quit Item Selection^^A^^^^^^^^LIST MANAGER
 ;;^UTILITY(U,$J,"PRO",548,1,0)
 ;;=^^1^1^2960626^^^
 ;;^UTILITY(U,$J,"PRO",548,1,1,0)
 ;;=This protocol can be used as a generic 'quit' action.
 ;;^UTILITY(U,$J,"PRO",548,2,0)
 ;;=^101.02A^2^1
 ;;^UTILITY(U,$J,"PRO",548,2,2,0)
 ;;=QUIT
 ;;^UTILITY(U,$J,"PRO",548,2,"B","QUIT",2)
 ;;=
 ;;^UTILITY(U,$J,"PRO",548,20)
 ;;=D Q^APCLVL4
 ;;^UTILITY(U,$J,"PRO",548,99)
 ;;=56873,29039
 ;;^UTILITY(U,$J,"PRO",549,0)
 ;;=APCL VGEN NEXT SCREEN^Next Screen^^A^^^^^^^^LIST MANAGER
 ;;^UTILITY(U,$J,"PRO",549,1,0)
 ;;=^^2^2^2920519^^^
 ;;^UTILITY(U,$J,"PRO",549,1,1,0)
 ;;=This action will allow the user to view the next screen
 ;;^UTILITY(U,$J,"PRO",549,1,2,0)
 ;;=of entries, if any exist.
 ;;^UTILITY(U,$J,"PRO",549,2,0)
 ;;=^101.02A^1^1
 ;;^UTILITY(U,$J,"PRO",549,2,1,0)
 ;;=NX
 ;;^UTILITY(U,$J,"PRO",549,2,"B","NX",1)
 ;;=
 ;;^UTILITY(U,$J,"PRO",549,20)
 ;;=D NEXT^VALM4
 ;;^UTILITY(U,$J,"PRO",549,99)
 ;;=56873,29039
 ;;^UTILITY(U,$J,"PRO",550,0)
 ;;=APCL VGEN PREVIOUS SCREEN^Previous Screen^^A^^^^^^^^LIST MANAGER
 ;;^UTILITY(U,$J,"PRO",550,1,0)
 ;;=^^2^2^2920113^^
 ;;^UTILITY(U,$J,"PRO",550,1,1,0)
 ;;=This action will allow the user to view the previous screen
 ;;^UTILITY(U,$J,"PRO",550,1,2,0)
 ;;=of entries, if any exist.
 ;;^UTILITY(U,$J,"PRO",550,2,0)
 ;;=^101.02A^3^3
 ;;^UTILITY(U,$J,"PRO",550,2,1,0)
 ;;=PR
 ;;^UTILITY(U,$J,"PRO",550,2,2,0)
 ;;=BK
 ;;^UTILITY(U,$J,"PRO",550,2,3,0)
 ;;=PR
 ;;^UTILITY(U,$J,"PRO",550,2,"B","BK",2)
 ;;=
 ;;^UTILITY(U,$J,"PRO",550,2,"B","PR",1)
 ;;=
 ;;^UTILITY(U,$J,"PRO",550,2,"B","PR",3)
 ;;=
 ;;^UTILITY(U,$J,"PRO",550,20)
 ;;=D PREV^VALM4
 ;;^UTILITY(U,$J,"PRO",550,99)
 ;;=56873,29039
 ;;^UTILITY(U,$J,"PRO",553,0)
 ;;=APCL VGEN ADD ITEM^Select Item(s)^^A^^^^^^^^
 ;;^UTILITY(U,$J,"PRO",553,20)
 ;;=D ADD^APCLVL4
 ;;^UTILITY(U,$J,"PRO",553,99)
 ;;=56873,29039
 ;;^UTILITY(U,$J,"PRO",554,0)
 ;;=APCL VGEN DESELECT ITEM^Remove Item(s)^^A^^^^^^^^
 ;;^UTILITY(U,$J,"PRO",554,20)
 ;;=D REM^APCLVL4
 ;;^UTILITY(U,$J,"PRO",554,99)
 ;;=56873,29039
 ;;^UTILITY(U,$J,"PRO",555,0)
 ;;=APCL VGEN EXIT REPORT^Exit Report^^A^^^^^^^^
 ;;^UTILITY(U,$J,"PRO",555,20)
 ;;=D EXITR^APCLVL4
 ;;^UTILITY(U,$J,"PRO",555,99)
 ;;=56873,29039
