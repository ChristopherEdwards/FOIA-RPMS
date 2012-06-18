PSJAI003 ; ; 20-MAR-1996
 ;;4.5;Inpatient Medications;**27**;OCT 07, 1994
 Q:'DIFQ(59.5)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^DD(59.5,.111,3)
 ;;=Type a Number between 1 and 31, 2 Decimal Digits
 ;;^DD(59.5,.111,20,0)
 ;;=^.3LA^1^1
 ;;^DD(59.5,.111,20,1,0)
 ;;=PSJI
 ;;^DD(59.5,.111,21,0)
 ;;=^^4^4^2910312^^^
 ;;^DD(59.5,.111,21,1,0)
 ;;=This number is used when the stop date of a new order is 
 ;;^DD(59.5,.111,21,2,0)
 ;;=computed. In other words, if a hyperal order is good for
 ;;^DD(59.5,.111,21,3,0)
 ;;=14 days and a new order is entered today, the default stop
 ;;^DD(59.5,.111,21,4,0)
 ;;=date will be 14 days from today.
 ;;^DD(59.5,.111,"DT")
 ;;=2910312
 ;;^DD(59.5,.112,0)
 ;;=PB'S GOOD FOR HOW MANY DAYS^NJ5,2^^1;18^K:+X'=X!(X>31)!(X<1)!(X?.E1"."3N.N) X
 ;;^DD(59.5,.112,3)
 ;;=Type a Number between 1 and 31, 2 Decimal Digits
 ;;^DD(59.5,.112,20,0)
 ;;=^.3LA^1^1
 ;;^DD(59.5,.112,20,1,0)
 ;;=PSJI
 ;;^DD(59.5,.112,21,0)
 ;;=^^3^3^2910312^^^^
 ;;^DD(59.5,.112,21,1,0)
 ;;=This number is used when the stop date of a new order is computed.
 ;;^DD(59.5,.112,21,2,0)
 ;;=In other words, if a piggyback order is good for 14 days and a new order
 ;;^DD(59.5,.112,21,3,0)
 ;;=is entered today, the default stop date will be 14 days from now.
 ;;^DD(59.5,.112,"DT")
 ;;=2910312
 ;;^DD(59.5,2,0)
 ;;=START OF COVERAGE^59.51I^^2;0
 ;;^DD(59.5,2,20,0)
 ;;=^.3LA^1^1
 ;;^DD(59.5,2,20,1,0)
 ;;=PSJI
 ;;^DD(59.5,2,21,0)
 ;;=^^5^5^2940714^^^^
 ;;^DD(59.5,2,21,1,0)
 ;;=An 'IV ROOM' may have one or more 'MANUFACTURING QUEUES'.  A queue
 ;;^DD(59.5,2,21,2,0)
 ;;=will contain all IV orders of a SPECIFIED TYPE, that require
 ;;^DD(59.5,2,21,3,0)
 ;;=distribution to the wards during a SPECIFIED TIME INTERVAL.
 ;;^DD(59.5,2,21,4,0)
 ;;=EACH 'MANUFACTURING QUEUE' IS DEFINED FOR ONE TYPE AND ONE TYPE ONLY!
 ;;^DD(59.5,2,21,5,0)
 ;;=Enter midnight as 2400.
 ;;^DD(59.5,3,0)
 ;;=DELIVERY TIME^59.52^^3;0
 ;;^DD(59.5,3,20,0)
 ;;=^.3LA^1^1
 ;;^DD(59.5,3,20,1,0)
 ;;=PSJI
 ;;^DD(59.5,3,21,0)
 ;;=^^2^2^2940714^^^^
 ;;^DD(59.5,3,21,1,0)
 ;;=These are the times which IV orders are to be prepared for delivery
 ;;^DD(59.5,3,21,2,0)
 ;;=to the wards.
 ;;^DD(59.5,4,0)
 ;;=PIGGYBACK WARD LIST RUN FLAG^F^^P;E1,250^K:$L(X)>250!($L(X)<10) X
 ;;^DD(59.5,4,3)
 ;;=Answer must be 10-250 characters in length.
 ;;^DD(59.5,4,20,0)
 ;;=^.3LA^1^1
 ;;^DD(59.5,4,20,1,0)
 ;;=PSJI
 ;;^DD(59.5,4,21,0)
 ;;=^^1^1^2880708^^
 ;;^DD(59.5,4,21,1,0)
 ;;=This flag gets set when the ward list has been run.
 ;;^DD(59.5,4,21,2,0)
 ;;= 
 ;;^DD(59.5,4,21,3,0)
 ;;=THIS IS NO LONGER USED BY THE PACKAGE, AND WILL BE DELETED.
 ;;^DD(59.5,4,"DT")
 ;;=2850326
 ;;^DD(59.5,5,0)
 ;;=ADMIXTURES WARD LIST RUN FLAG^F^^A;E1,250^K:$L(X)>250!($L(X)<10) X
 ;;^DD(59.5,5,3)
 ;;=Answer must be 10-250 characters in length.
 ;;^DD(59.5,5,20,0)
 ;;=^.3LA^1^1
 ;;^DD(59.5,5,20,1,0)
 ;;=PSJI
 ;;^DD(59.5,5,21,0)
 ;;=^^1^1^2880708^^
 ;;^DD(59.5,5,21,1,0)
 ;;=This flag gets set when the ward list has been run.
 ;;^DD(59.5,5,21,2,0)
 ;;= 
 ;;^DD(59.5,5,21,3,0)
 ;;=THIS IS NO LONGER USED BY THE PACKAGE, AND WILL BE DELETED.
 ;;^DD(59.5,5,"DT")
 ;;=2850326
 ;;^DD(59.5,6,0)
 ;;=HYPERAL WARD LIST RUN FLAG^F^^H;E1,250^K:$L(X)>250!($L(X)<10) X
 ;;^DD(59.5,6,3)
 ;;=Answer must be 10-250 characters in length.
 ;;^DD(59.5,6,20,0)
 ;;=^.3LA^1^1
 ;;^DD(59.5,6,20,1,0)
 ;;=PSJI
 ;;^DD(59.5,6,21,0)
 ;;=^^1^1^2880708^^
 ;;^DD(59.5,6,21,1,0)
 ;;=This flag gets set when the ward list is run.
 ;;^DD(59.5,6,21,2,0)
 ;;= 
 ;;^DD(59.5,6,21,3,0)
 ;;=THIS IS NO LONGER USED BY THE PACKAGE, AND WILL BE DELETED.
 ;;^DD(59.5,6,"DT")
 ;;=2850326
 ;;^DD(59.5,7,0)
 ;;=*FILLED/CHECKED BY LABEL LINE^S^0:NO;1:YES;^1;11^Q
 ;;^DD(59.5,7,20,0)
 ;;=^.3LA^1^1
 ;;^DD(59.5,7,20,1,0)
 ;;=PSJI
 ;;^DD(59.5,7,21,0)
 ;;=^^2^2^2880708^^
 ;;^DD(59.5,7,21,1,0)
 ;;=To have the 'Filled by: ____ Checked by: ____" line printed on every
 ;;^DD(59.5,7,21,2,0)
 ;;=label, answer 'YES' to this field.
 ;;^DD(59.5,7,"DT")
 ;;=2860519
 ;;^DD(59.5,8,0)
 ;;=TOTAL VOL. ON HYPERAL LABELS^S^0:NO;1:YES;^1;12^Q
 ;;^DD(59.5,8,20,0)
 ;;=^.3LA^1^1
 ;;^DD(59.5,8,20,1,0)
 ;;=PSJI
 ;;^DD(59.5,8,21,0)
 ;;=^^2^2^2940708^^^^
 ;;^DD(59.5,8,21,1,0)
 ;;=To have the total volume of solutions and additives printed
 ;;^DD(59.5,8,21,2,0)
 ;;=on all hyperal labels, answer 'YES' to this site parameter.
 ;;^DD(59.5,8,"DT")
 ;;=2850621
 ;;^DD(59.5,9,0)
 ;;=WIDTH OF LABEL^RNJ3,0^^1;13^K:+X'=X!(X>100)!(X<10)!(X?.E1"."1N.N) X
 ;;^DD(59.5,9,3)
 ;;=Enter a number between 10 and 100 of maximum characters that may print on a single line of your labels.
 ;;^DD(59.5,9,20,0)
 ;;=^.3LA^1^1
 ;;^DD(59.5,9,20,1,0)
 ;;=PSJI
 ;;^DD(59.5,9,21,0)
 ;;=^^4^4^2940802^^^^
 ;;^DD(59.5,9,21,1,0)
 ;;=  Enter the maximum allowable width of your label in number of characters.
