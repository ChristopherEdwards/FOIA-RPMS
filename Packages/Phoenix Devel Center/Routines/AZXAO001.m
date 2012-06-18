AZXAO001 ; IHS/PHXAO/TMJ - NO DESCRIPTION PROVIDED ;
 ;;2.0;RELEASE OF INFORMATION;;FEB 21, 2002
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^UTILITY(U,$J,"PRO",959,0)
 ;;=AZXA RECORD DISPLAY^ROI Record Display^^M^^^^^^^^
 ;;^UTILITY(U,$J,"PRO",959,10,0)
 ;;=^101.01PA^3^3
 ;;^UTILITY(U,$J,"PRO",959,10,1,0)
 ;;=989^+^10
 ;;^UTILITY(U,$J,"PRO",959,10,1,"^")
 ;;=AZXA NEXT SCREEN
 ;;^UTILITY(U,$J,"PRO",959,10,2,0)
 ;;=990^-^20
 ;;^UTILITY(U,$J,"PRO",959,10,2,"^")
 ;;=AZXA PREVIOUS SCREEN
 ;;^UTILITY(U,$J,"PRO",959,10,3,0)
 ;;=991^Q^99
 ;;^UTILITY(U,$J,"PRO",959,10,3,"^")
 ;;=AZXA QUIT
 ;;^UTILITY(U,$J,"PRO",959,26)
 ;;=D SHOW^VALM
 ;;^UTILITY(U,$J,"PRO",959,28)
 ;;=Select Action:
 ;;^UTILITY(U,$J,"PRO",959,29)
 ;;=+
 ;;^UTILITY(U,$J,"PRO",959,99)
 ;;=58219,44875
 ;;^UTILITY(U,$J,"PRO",989,0)
 ;;=AZXA NEXT SCREEN^Next Screen^^A^^^^^^^^LIST MANAGER
 ;;^UTILITY(U,$J,"PRO",989,1,0)
 ;;=^^2^2^2920519^^^
 ;;^UTILITY(U,$J,"PRO",989,1,1,0)
 ;;=This action will allow the user to view the next screen
 ;;^UTILITY(U,$J,"PRO",989,1,2,0)
 ;;=of entries, if any exist.
 ;;^UTILITY(U,$J,"PRO",989,2,0)
 ;;=^101.02A^1^1
 ;;^UTILITY(U,$J,"PRO",989,2,1,0)
 ;;=NX
 ;;^UTILITY(U,$J,"PRO",989,2,"B","NX",1)
 ;;=
 ;;^UTILITY(U,$J,"PRO",989,20)
 ;;=D NEXT^VALM4
 ;;^UTILITY(U,$J,"PRO",989,99)
 ;;=58219,42882
 ;;^UTILITY(U,$J,"PRO",990,0)
 ;;=AZXA PREVIOUS SCREEN^Previous Screen^^A^^^^^^^^LIST MANAGER
 ;;^UTILITY(U,$J,"PRO",990,1,0)
 ;;=^^2^2^2920113^^
 ;;^UTILITY(U,$J,"PRO",990,1,1,0)
 ;;=This action will allow the user to view the previous screen
 ;;^UTILITY(U,$J,"PRO",990,1,2,0)
 ;;=of entries, if any exist.
 ;;^UTILITY(U,$J,"PRO",990,2,0)
 ;;=^101.02A^3^3
 ;;^UTILITY(U,$J,"PRO",990,2,1,0)
 ;;=PR
 ;;^UTILITY(U,$J,"PRO",990,2,2,0)
 ;;=BK
 ;;^UTILITY(U,$J,"PRO",990,2,3,0)
 ;;=PR
 ;;^UTILITY(U,$J,"PRO",990,2,"B","BK",2)
 ;;=
 ;;^UTILITY(U,$J,"PRO",990,2,"B","PR",1)
 ;;=
 ;;^UTILITY(U,$J,"PRO",990,2,"B","PR",3)
 ;;=
 ;;^UTILITY(U,$J,"PRO",990,20)
 ;;=D PREV^VALM4
 ;;^UTILITY(U,$J,"PRO",990,99)
 ;;=58219,42937
 ;;^UTILITY(U,$J,"PRO",991,0)
 ;;=AZXA QUIT^Quit^^A^^^^^^^^LIST MANAGER
 ;;^UTILITY(U,$J,"PRO",991,1,0)
 ;;=^^1^1^2911105^
 ;;^UTILITY(U,$J,"PRO",991,1,1,0)
 ;;=This protocol can be used as a generic 'quit' action.
 ;;^UTILITY(U,$J,"PRO",991,2,0)
 ;;=^101.02A^2^2
 ;;^UTILITY(U,$J,"PRO",991,2,1,0)
 ;;=EXIT
 ;;^UTILITY(U,$J,"PRO",991,2,2,0)
 ;;=QUIT
 ;;^UTILITY(U,$J,"PRO",991,2,"B","EXIT",1)
 ;;=
 ;;^UTILITY(U,$J,"PRO",991,2,"B","QUIT",2)
 ;;=
 ;;^UTILITY(U,$J,"PRO",991,20)
 ;;=Q
 ;;^UTILITY(U,$J,"PRO",991,99)
 ;;=58219,42961
