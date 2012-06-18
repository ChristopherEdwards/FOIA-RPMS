PSGWI003 ; ; 04-JAN-1994
 ;;2.3; Automatic Replenishment/Ward Stock ;;4 JAN 94
 Q:'DIFQ(50)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^DD(50,301,3)
 ;;=Enter the category that this drug is to be classified as for AMIS statistics in Automatic Replenishment/Ward Stock.
 ;;^DD(50,301,20,0)
 ;;=^.3LA^1^1
 ;;^DD(50,301,20,1,0)
 ;;=PSGW
 ;;^DD(50,301,21,0)
 ;;=^^2^2^2901030^
 ;;^DD(50,301,21,1,0)
 ;;=This refers to the category that this drug is to be classified as for AMIS 
 ;;^DD(50,301,21,2,0)
 ;;=statistics in Automatic Replenishment/Ward Stock.
 ;;^DD(50,301,"DT")
 ;;=2881213
 ;;^DD(50,302,0)
 ;;=AR/WS AMIS CONVERSION NUMBER^NJ4,0^^PSG;3^K:+X'=X!(X>9999)!(X<1)!(X?.E1"."1N.N) X
 ;;^DD(50,302,3)
 ;;=Enter a whole number between 1 and 9999, 0 Decimal Digits.
 ;;^DD(50,302,20,0)
 ;;=^.3LA^1^1
 ;;^DD(50,302,20,1,0)
 ;;=PSGW
 ;;^DD(50,302,21,0)
 ;;=^^8^8^2910221^^^^
 ;;^DD(50,302,21,1,0)
 ;;=This number reflects the number of doses/units contained in the dispensed
 ;;^DD(50,302,21,2,0)
 ;;=drug for Automatic Replenishment/Ward Stock AMIS statistics.
 ;;^DD(50,302,21,3,0)
 ;;=For example:  For a 20cc vial, the quantity dispensed is 1, and
 ;;^DD(50,302,21,4,0)
 ;;=              the conversion number is 20.
 ;;^DD(50,302,21,5,0)
 ;;=              For 5 oz. antacid, the quantity dispensed is 1, and
 ;;^DD(50,302,21,6,0)
 ;;=              the conversion number is 1.
 ;;^DD(50,302,21,7,0)
 ;;=              For a bottle of 100 aspirin, the quantity dispensed is 1,
 ;;^DD(50,302,21,8,0)
 ;;=              and the conversion number is 100.
 ;;^DD(50,302,"DT")
 ;;=2870501
