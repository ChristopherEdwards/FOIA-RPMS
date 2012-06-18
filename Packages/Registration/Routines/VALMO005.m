VALMO005 ; ; 13-AUG-1993
 ;;1;List Manager;;Aug 13, 1993
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^UTILITY(U,$J,"PRO",710,20)
 ;;=D CHG^VALMD
 ;;^UTILITY(U,$J,"PRO",710,99)
 ;;=55598,37421
 ;;^UTILITY(U,$J,"PRO",711,0)
 ;;=VALM DEMO PRINT^Print Protocol List^^A^^^^^^^^LIST MANAGER
 ;;^UTILITY(U,$J,"PRO",711,20)
 ;;=W !!,*7,"This is a test print protocol!" R X:DTIME S VALMBCK=""
 ;;^UTILITY(U,$J,"PRO",711,99)
 ;;=55598,37441
