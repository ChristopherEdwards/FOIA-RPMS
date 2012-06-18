ACDON001 ;IHS/ADC/EDE/KML - NO DESCRIPTION PROVIDED;
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^UTILITY(U,$J,"PRO",563,0)
 ;;=ACD GR QUIT^Quit Item Selection^^A^^^^^^^^LIST MANAGER
 ;;^UTILITY(U,$J,"PRO",563,1,0)
 ;;=^^1^1^2960626^^^
 ;;^UTILITY(U,$J,"PRO",563,1,1,0)
 ;;=This protocol can be used as a generic 'quit' action.
 ;;^UTILITY(U,$J,"PRO",563,2,0)
 ;;=^101.02A^2^1
 ;;^UTILITY(U,$J,"PRO",563,2,2,0)
 ;;=QUIT
 ;;^UTILITY(U,$J,"PRO",563,2,"B","QUIT",2)
 ;;=
 ;;^UTILITY(U,$J,"PRO",563,20)
 ;;=D Q^ACDRL4
 ;;^UTILITY(U,$J,"PRO",563,99)
 ;;=56791,50488
 ;;^UTILITY(U,$J,"PRO",564,0)
 ;;=ACD GR EXIT REPORT^Exit Report^^A^^^^^^^^
 ;;^UTILITY(U,$J,"PRO",564,20)
 ;;=D EXITR^ACDRL4
 ;;^UTILITY(U,$J,"PRO",564,99)
 ;;=56791,50513
 ;;^UTILITY(U,$J,"PRO",565,0)
 ;;=ACD GR NEXT SCREEN^Next Screen^^A^^^^^^^^LIST MANAGER
 ;;^UTILITY(U,$J,"PRO",565,1,0)
 ;;=^^2^2^2920519^^^
 ;;^UTILITY(U,$J,"PRO",565,1,1,0)
 ;;=This action will allow the user to view the next screen
 ;;^UTILITY(U,$J,"PRO",565,1,2,0)
 ;;=of entries, if any exist.
 ;;^UTILITY(U,$J,"PRO",565,2,0)
 ;;=^101.02A^1^1
 ;;^UTILITY(U,$J,"PRO",565,2,1,0)
 ;;=NX
 ;;^UTILITY(U,$J,"PRO",565,2,"B","NX",1)
 ;;=
 ;;^UTILITY(U,$J,"PRO",565,20)
 ;;=D NEXT^VALM4
 ;;^UTILITY(U,$J,"PRO",565,99)
 ;;=56791,50542
 ;;^UTILITY(U,$J,"PRO",566,0)
 ;;=ACD GR PREVIOUS SCREEN^Previous Screen^^A^^^^^^^^LIST MANAGER
 ;;^UTILITY(U,$J,"PRO",566,1,0)
 ;;=^^2^2^2920113^^
 ;;^UTILITY(U,$J,"PRO",566,1,1,0)
 ;;=This action will allow the user to view the previous screen
 ;;^UTILITY(U,$J,"PRO",566,1,2,0)
 ;;=of entries, if any exist.
 ;;^UTILITY(U,$J,"PRO",566,2,0)
 ;;=^101.02A^3^3
 ;;^UTILITY(U,$J,"PRO",566,2,1,0)
 ;;=PR
 ;;^UTILITY(U,$J,"PRO",566,2,2,0)
 ;;=BK
 ;;^UTILITY(U,$J,"PRO",566,2,3,0)
 ;;=PR
 ;;^UTILITY(U,$J,"PRO",566,2,"B","BK",2)
 ;;=
 ;;^UTILITY(U,$J,"PRO",566,2,"B","PR",1)
 ;;=
 ;;^UTILITY(U,$J,"PRO",566,2,"B","PR",3)
 ;;=
 ;;^UTILITY(U,$J,"PRO",566,20)
 ;;=D PREV^VALM4
 ;;^UTILITY(U,$J,"PRO",566,99)
 ;;=56791,50569
 ;;^UTILITY(U,$J,"PRO",567,0)
 ;;=ACD GR MENU SELECTION^CDMIS General Retrieval Menu^^M^^^^^^^^
 ;;^UTILITY(U,$J,"PRO",567,4)
 ;;=25
 ;;^UTILITY(U,$J,"PRO",567,10,0)
 ;;=^101.01PA^6^6
 ;;^UTILITY(U,$J,"PRO",567,10,1,0)
 ;;=564^E^99
 ;;^UTILITY(U,$J,"PRO",567,10,1,"^")
 ;;=ACD GR EXIT REPORT
 ;;^UTILITY(U,$J,"PRO",567,10,2,0)
 ;;=565^+^30
 ;;^UTILITY(U,$J,"PRO",567,10,2,"^")
 ;;=ACD GR NEXT SCREEN
 ;;^UTILITY(U,$J,"PRO",567,10,3,0)
 ;;=566^-^40
 ;;^UTILITY(U,$J,"PRO",567,10,3,"^")
 ;;=ACD GR PREVIOUS SCREEN
 ;;^UTILITY(U,$J,"PRO",567,10,4,0)
 ;;=563^Q^50
 ;;^UTILITY(U,$J,"PRO",567,10,4,"^")
 ;;=ACD GR QUIT
 ;;^UTILITY(U,$J,"PRO",567,10,5,0)
 ;;=568^S^10
 ;;^UTILITY(U,$J,"PRO",567,10,5,"^")
 ;;=ACD GR SELECT ITEM
 ;;^UTILITY(U,$J,"PRO",567,10,6,0)
 ;;=569^R^20
 ;;^UTILITY(U,$J,"PRO",567,10,6,"^")
 ;;=ACD GR REMOVE ITEMS
 ;;^UTILITY(U,$J,"PRO",567,26)
 ;;=D SHOW^VALM
 ;;^UTILITY(U,$J,"PRO",567,28)
 ;;=Select Action: 
 ;;^UTILITY(U,$J,"PRO",567,29)
 ;;=S
 ;;^UTILITY(U,$J,"PRO",567,99)
 ;;=56791,51153
 ;;^UTILITY(U,$J,"PRO",568,0)
 ;;=ACD GR SELECT ITEM^Select Item(s)^^A^^^^^^^^
 ;;^UTILITY(U,$J,"PRO",568,20)
 ;;=D ADD^ACDRL4
 ;;^UTILITY(U,$J,"PRO",568,99)
 ;;=56791,50632
 ;;^UTILITY(U,$J,"PRO",569,0)
 ;;=ACD GR REMOVE ITEMS^Remove Item(s)^^A^^^^^^^^
 ;;^UTILITY(U,$J,"PRO",569,20)
 ;;=D REM^ACDRL4
 ;;^UTILITY(U,$J,"PRO",569,99)
 ;;=56791,50656
