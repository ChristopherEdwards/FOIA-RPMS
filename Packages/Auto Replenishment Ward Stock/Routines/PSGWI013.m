PSGWI013 ; ; 04-JAN-1994
 ;;2.3; Automatic Replenishment/Ward Stock ;;4 JAN 94
 Q:'DIFQ(58.1)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^DD(58.28,4,21,1,0)
 ;;=This points to file #200 (New Person file).  It contains the pointer number to 
 ;;^DD(58.28,4,21,2,0)
 ;;=the user who LAST EDITED this request.
 ;;^DD(58.28,4,"DT")
 ;;=2900712
 ;;^DD(58.28,5,0)
 ;;=DATE/TIME LAST EDITED^D^^0;6^S %DT="ETX" D ^%DT S X=Y K:Y<1 X
 ;;^DD(58.28,5,21,0)
 ;;=^^1^1^2890531^
 ;;^DD(58.28,5,21,1,0)
 ;;=This field contains the date/time this on-demand request was last edited.
 ;;^DD(58.28,5,"DT")
 ;;=2881027
