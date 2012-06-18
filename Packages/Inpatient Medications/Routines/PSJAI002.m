PSJAI002 ; ; 20-MAR-1996
 ;;4.5;Inpatient Medications;**27**;OCT 07, 1994
 Q:'DIFQ(59.5)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^DD(59.5,.104,21,0)
 ;;=^^4^4^2920612^^^^
 ;;^DD(59.5,.104,21,1,0)
 ;;=This number is used when the stop date of a new order is computed.
 ;;^DD(59.5,.104,21,2,0)
 ;;=In other words, if Large Volume IV's are good for 14 days and a new 
 ;;^DD(59.5,.104,21,3,0)
 ;;=order is input with a start date of today, the stop date will be 'T+14'.
 ;;^DD(59.5,.104,21,4,0)
 ;;= 
 ;;^DD(59.5,.104,"DT")
 ;;=2910312
 ;;^DD(59.5,.105,0)
 ;;=EXPIRE ALL ORDERS ON SAME DAY^S^0:NO;1:YES;^1;5^Q
 ;;^DD(59.5,.105,20,0)
 ;;=^.3LA^1^1
 ;;^DD(59.5,.105,20,1,0)
 ;;=PSJI
 ;;^DD(59.5,.105,21,0)
 ;;=^^6^6^2860221^^^^
 ;;^DD(59.5,.105,21,1,0)
 ;;=Enter a '1' to stop all IV orders automatically on the same day.
 ;;^DD(59.5,.105,21,2,0)
 ;;=The day the orders are stopped will be the 'STOP DATE' of the
 ;;^DD(59.5,.105,21,3,0)
 ;;=FIRST ACTIVE IV order found in the file.  The stop/date that is
 ;;^DD(59.5,.105,21,4,0)
 ;;=found will be shown as a default for the stop/date of the IV ORDER.
 ;;^DD(59.5,.105,21,5,0)
 ;;= 
 ;;^DD(59.5,.105,21,6,0)
 ;;= 
 ;;^DD(59.5,.105,"DT")
 ;;=2840613
 ;;^DD(59.5,.106,0)
 ;;=*DC ORDERS ON WARD TRANSFER^S^0:NO;1:YES;^1;6^Q
 ;;^DD(59.5,.106,3)
 ;;=
 ;;^DD(59.5,.106,20,0)
 ;;=^.3LA^1^1
 ;;^DD(59.5,.106,20,1,0)
 ;;=PSJI
 ;;^DD(59.5,.106,21,0)
 ;;=^^3^3^2890831^^^
 ;;^DD(59.5,.106,21,1,0)
 ;;=This only affects orders of patients transferring BETWEEN WARDS,
 ;;^DD(59.5,.106,21,2,0)
 ;;=and NOT transferring BETWEEN SERVICES.  Enter a '1' if you want
 ;;^DD(59.5,.106,21,3,0)
 ;;=this feature.
 ;;^DD(59.5,.106,21,4,0)
 ;;=** This is effective only for ward transfers not for transfers across
 ;;^DD(59.5,.106,21,5,0)
 ;;=   services !
 ;;^DD(59.5,.106,"DT")
 ;;=2840928
 ;;^DD(59.5,.107,0)
 ;;=HEADER LABEL^S^0:NO;1:YES;^1;7^Q
 ;;^DD(59.5,.107,3)
 ;;=
 ;;^DD(59.5,.107,20,0)
 ;;=^.3LA^1^1
 ;;^DD(59.5,.107,20,1,0)
 ;;=PSJI
 ;;^DD(59.5,.107,21,0)
 ;;=5^^5^5^2940720^^
 ;;^DD(59.5,.107,21,1,0)
 ;;=When set to "YES", an extra label is generated to record lot #'s and 
 ;;^DD(59.5,.107,21,2,0)
 ;;=provide a record for new orders entered since the last printing of the 
 ;;^DD(59.5,.107,21,3,0)
 ;;=active order list. This extra label, together with the active order list 
 ;;^DD(59.5,.107,21,4,0)
 ;;=provides a paper backup system in the event that the computer system 
 ;;^DD(59.5,.107,21,5,0)
 ;;=becomes "unavailable" to the user.
 ;;^DD(59.5,.107,22)
 ;;=
 ;;^DD(59.5,.107,"DT")
 ;;=2850319
 ;;^DD(59.5,.108,0)
 ;;=ACTIVITY RULER^S^0:NO;1:YES;^1;8^Q
 ;;^DD(59.5,.108,20,0)
 ;;=^.3LA^1^1
 ;;^DD(59.5,.108,20,1,0)
 ;;=PSJI
 ;;^DD(59.5,.108,21,0)
 ;;=^^5^5^2880708^^^^
 ;;^DD(59.5,.108,21,1,0)
 ;;=The 'ACTIVITY RULER' provides a visual representation of the relationship
 ;;^DD(59.5,.108,21,2,0)
 ;;=between coverage times, doses due and order start times.  The intent
 ;;^DD(59.5,.108,21,3,0)
 ;;=is to provide the 'on-the-floor' user with a means of 'tracking' activity
 ;;^DD(59.5,.108,21,4,0)
 ;;=in the IV room and determining when to call for doses before the normal
 ;;^DD(59.5,.108,21,5,0)
 ;;=delivery.
 ;;^DD(59.5,.108,"DT")
 ;;=2850321
 ;;^DD(59.5,.109,0)
 ;;=SHOW BED LOCATION ON LABEL^S^0:NO;1:YES;^1;9^Q
 ;;^DD(59.5,.109,20,0)
 ;;=^.3LA^1^1
 ;;^DD(59.5,.109,20,1,0)
 ;;=PSJI
 ;;^DD(59.5,.109,21,0)
 ;;=^^4^4^2860128^^
 ;;^DD(59.5,.109,21,1,0)
 ;;=The patient's 'WARD LOCATION' is ALWAYS printed on the IV label.
 ;;^DD(59.5,.109,21,2,0)
 ;;=If the 'BED LOCATION' is available, and if it is desired to have
 ;;^DD(59.5,.109,21,3,0)
 ;;=this ADDITIONAL information on the IV label, respond with a 'Y' or
 ;;^DD(59.5,.109,21,4,0)
 ;;=a '1' at this 'IV ROOM' parameter prompt.
 ;;^DD(59.5,.109,"DT")
 ;;=2850327
 ;;^DD(59.5,.11,0)
 ;;=*SHOW UNIT NEEDS^S^0:NO;1:YES;^1;10^Q
 ;;^DD(59.5,.11,20,0)
 ;;=^.3LA^1^1
 ;;^DD(59.5,.11,20,1,0)
 ;;=PSJI
 ;;^DD(59.5,.11,21,0)
 ;;=^^8^8^2860128^^^^
 ;;^DD(59.5,.11,21,1,0)
 ;;=If this parameter is turned on, a visual 'time scale' will be shown.
 ;;^DD(59.5,.11,21,2,0)
 ;;=This time scale will show what the orders' unit needs will be for 14
 ;;^DD(59.5,.11,21,3,0)
 ;;=24-hour periods.
 ;;^DD(59.5,.11,21,4,0)
 ;;=EXAMPLE:
 ;;^DD(59.5,.11,21,5,0)
 ;;=   If an order was given with an infusion rate of 220 ml/hr and a total
 ;;^DD(59.5,.11,21,6,0)
 ;;=   volume of 1000 ML, the unit needs would be:
 ;;^DD(59.5,.11,21,7,0)
 ;;=DAY  :  1   2   3   4   5   6   7   8   9  10  11  12  13  14
 ;;^DD(59.5,.11,21,8,0)
 ;;=UNIT :  5   5   5   6   5   5   6   5   5   5   6   5   5   6
 ;;^DD(59.5,.11,"DT")
 ;;=2850420
 ;;^DD(59.5,.111,0)
 ;;=HYPERAL GOOD FOR HOW MANY DAYS^NJ5,2^^1;17^K:+X'=X!(X>31)!(X<1)!(X?.E1"."3N.N) X
