PSJAI007 ; ; 20-MAR-1996
 ;;4.5;Inpatient Medications;**27**;OCT 07, 1994
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^UTILITY(U,$J,"SBF",59.5,59.5)
 ;;=
 ;;^UTILITY(U,$J,"SBF",59.5,59.51)
 ;;=
 ;;^UTILITY(U,$J,"SBF",59.5,59.52)
 ;;=
