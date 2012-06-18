PSGWI022 ; ; 04-JAN-1994
 ;;2.3; Automatic Replenishment/Ward Stock ;;4 JAN 94
 Q:'DIFQ(58.3)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^DD(58.32,1,21,0)
 ;;=^^2^2^2871009^^^
 ;;^DD(58.32,1,21,1,0)
 ;;=This contains the quantity backordered (Amount to be dispensed - 
 ;;^DD(58.32,1,21,2,0)
 ;;=Actual Dispensed).
 ;;^DD(58.32,1,"DT")
 ;;=2850719
 ;;^DD(58.32,2,0)
 ;;=ORIGINAL BACKORDER^NJ6,0^^0;3^K:+X'=X!(X>999999)!(X<0)!(X?.E1"."1N.N) X
 ;;^DD(58.32,2,3)
 ;;=Type a whole number between 0 and 999999
 ;;^DD(58.32,2,5,1,0)
 ;;=58.32^1^1
 ;;^DD(58.32,2,21,0)
 ;;=^^2^2^2871009^
 ;;^DD(58.32,2,21,1,0)
 ;;=If the backorder quantity is partially filled, this stores the amount
 ;;^DD(58.32,2,21,2,0)
 ;;=of the original backorder.
 ;;^DD(58.32,2,"DT")
 ;;=2850110
 ;;^DD(58.32,3,0)
 ;;=DATE OF LAST CHG^D^^0;4^S %DT="ET" D ^%DT S X=Y K:Y<1 X
 ;;^DD(58.32,3,21,0)
 ;;=^^2^2^2871009^
 ;;^DD(58.32,3,21,1,0)
 ;;=This identifies the date that the backorder quantity was edited
 ;;^DD(58.32,3,21,2,0)
 ;;=or partially filled.
 ;;^DD(58.32,3,"DT")
 ;;=2850110
 ;;^DD(58.32,4,0)
 ;;=DATE FILLED^D^^0;5^S %DT="ET" D ^%DT S X=Y K:Y<1 X
 ;;^DD(58.32,4,1,0)
 ;;=^.1^^0
 ;;^DD(58.32,4,21,0)
 ;;=^^2^2^2871009^
 ;;^DD(58.32,4,21,1,0)
 ;;=This identifies the date that the backorder quantity was completely
 ;;^DD(58.32,4,21,2,0)
 ;;=filled.
 ;;^DD(58.32,4,"DT")
 ;;=2870817
