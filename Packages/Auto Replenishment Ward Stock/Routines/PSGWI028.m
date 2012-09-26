PSGWI028 ; ; 04-JAN-1994
 ;;2.3; Automatic Replenishment/Ward Stock ;;4 JAN 94
 Q:'DIFQ(59.7)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^DD(59.7,59.02,21,0)
 ;;=^^1^1^2891027^^
 ;;^DD(59.7,59.02,21,1,0)
 ;;=This field will contain the date the current version of AR/WS was installed.
 ;;^DD(59.7,59.02,"DT")
 ;;=2890620
 ;;^DD(59.7,59.1,0)
 ;;=BACKORDER CONVERSION^D^^59.99;3^S %DT="EX" D ^%DT S X=Y K:Y<1 X
 ;;^DD(59.7,59.1,3)
 ;;=Enter Date the BACKORDER CONVERSION was completed.
 ;;^DD(59.7,59.1,8.5)
 ;;=^
 ;;^DD(59.7,59.1,9)
 ;;=^
 ;;^DD(59.7,59.1,20,0)
 ;;=^.3LA^1^1
 ;;^DD(59.7,59.1,20,1,0)
 ;;=PSGW
 ;;^DD(59.7,59.1,21,0)
 ;;=^^2^2^2901107^^^
 ;;^DD(59.7,59.1,21,1,0)
 ;;=This field will contain the date the BACKORDER CONVERSION for AR/WS V2.04
 ;;^DD(59.7,59.1,21,2,0)
 ;;=was completed.
 ;;^DD(59.7,59.1,"DT")
 ;;=2890620
 ;;^DD(59.7,59.2,0)
 ;;=MULTI-DIVISION CONVERSION^D^^59.99;4^S %DT="EX" D ^%DT S X=Y K:Y<1 X
 ;;^DD(59.7,59.2,3)
 ;;=Enter Date the MULTI-DIVISION CONVERSION was completed.
 ;;^DD(59.7,59.2,8.5)
 ;;=^
 ;;^DD(59.7,59.2,9)
 ;;=^
 ;;^DD(59.7,59.2,20,0)
 ;;=^.3LA^1^1
 ;;^DD(59.7,59.2,20,1,0)
 ;;=PSGW
 ;;^DD(59.7,59.2,21,0)
 ;;=^^2^2^2901107^^^
 ;;^DD(59.7,59.2,21,1,0)
 ;;=This field will contain the date the MULTI-DIVISION CONVERSION for
 ;;^DD(59.7,59.2,21,2,0)
 ;;=AR/WS V2.04 was completed.
 ;;^DD(59.7,59.2,"DT")
 ;;=2890620
 ;;^DD(59.7,59.3,0)
 ;;=WARD (for %) CONVERSION^D^^59.99;5^S %DT="EX" D ^%DT S X=Y K:Y<1 X
 ;;^DD(59.7,59.3,3)
 ;;=Enter Date the WARD (for %) CONVERSION was completed
 ;;^DD(59.7,59.3,8.5)
 ;;=^
 ;;^DD(59.7,59.3,9)
 ;;=^
 ;;^DD(59.7,59.3,20,0)
 ;;=^.3LA^1^1
 ;;^DD(59.7,59.3,20,1,0)
 ;;=PSGW
 ;;^DD(59.7,59.3,21,0)
 ;;=^^2^2^2901107^^^^
 ;;^DD(59.7,59.3,21,1,0)
 ;;=This field contains the date the WARD (for %) pointer conversion for
 ;;^DD(59.7,59.3,21,2,0)
 ;;=AR/WS V2.04 was completed.
 ;;^DD(59.7,59.3,"DT")
 ;;=2891002
 ;;^DD(59.7,59.4,0)
 ;;=RETURN REASON CONVERSION^D^^59.99;6^S %DT="EX" D ^%DT S X=Y K:Y<1 X
 ;;^DD(59.7,59.4,3)
 ;;=Enter Date the RETURN REASON CONVERSION was completed.
 ;;^DD(59.7,59.4,8.5)
 ;;=^
 ;;^DD(59.7,59.4,9)
 ;;=^
 ;;^DD(59.7,59.4,20,0)
 ;;=^.3LA^1^1
 ;;^DD(59.7,59.4,20,1,0)
 ;;=PSGW
 ;;^DD(59.7,59.4,21,0)
 ;;=^^2^2^2901107^^^^
 ;;^DD(59.7,59.4,21,1,0)
 ;;=This field will contain the date the RETURN REASON CONVERSION for
 ;;^DD(59.7,59.4,21,2,0)
 ;;=AR/WS V2.2 was completed.
 ;;^DD(59.7,59.4,"DT")
 ;;=2900709
