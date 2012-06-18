PSJAI005 ; ; 20-MAR-1996
 ;;4.5;Inpatient Medications;**27**;OCT 07, 1994
 Q:'DIFQ(59.5)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^DD(59.5,17,21,0)
 ;;=^^2^2^2940714^^^^
 ;;^DD(59.5,17,21,1,0)
 ;;=This field is used to determine the stop date for the Syringes order.
 ;;^DD(59.5,17,21,2,0)
 ;;= 
 ;;^DD(59.5,17,"DT")
 ;;=2910312
 ;;^DD(59.5,18,0)
 ;;=CHEMO'S GOOD FOR HOW MANY DAYS^NJ5,2^^5;2^K:+X'=X!(X>31)!(X<1)!(X?.E1"."3N.N) X
 ;;^DD(59.5,18,3)
 ;;=Type a Number between 1 and 31, 2 Decimal Digits
 ;;^DD(59.5,18,20,0)
 ;;=^.3LA^1^1
 ;;^DD(59.5,18,20,1,0)
 ;;=PSJI
 ;;^DD(59.5,18,21,0)
 ;;=^^2^2^2940714^^^^
 ;;^DD(59.5,18,21,1,0)
 ;;=This field is used to determined the stop date for the Chemo order.
 ;;^DD(59.5,18,21,2,0)
 ;;= 
 ;;^DD(59.5,18,"DT")
 ;;=2910312
 ;;^DD(59.5,19,0)
 ;;=INACTIVATION DATE^D^^I;1^S %DT="ETX" D ^%DT S X=Y K:Y<1 X
 ;;^DD(59.5,19,3)
 ;;=Enter the date this IV Room will no longer be used.
 ;;^DD(59.5,19,21,0)
 ;;=^^4^4^2920220^^^
 ;;^DD(59.5,19,21,1,0)
 ;;=  This is used to place an IV Room out of service. An IV Room should 
 ;;^DD(59.5,19,21,2,0)
 ;;=NEVER be deleted as some IV orders may still be using it. Once the
 ;;^DD(59.5,19,21,3,0)
 ;;=inactivation date entered is reached, the IV Room will no longer be
 ;;^DD(59.5,19,21,4,0)
 ;;=selectable in IV order entry options.
 ;;^DD(59.5,19,23,0)
 ;;=^^3^3^2920220^^
 ;;^DD(59.5,19,23,1,0)
 ;;= Used to place an IV Room out of service. Once the IV Room's inactivation
 ;;^DD(59.5,19,23,2,0)
 ;;=date has been reached, it will no longer be selectable in the Inpatient
 ;;^DD(59.5,19,23,3,0)
 ;;=Medications package.
 ;;^DD(59.5,19,"DT")
 ;;=2910923
 ;;^DD(59.5,20,0)
 ;;=DAYS TO RETAIN IV STATS^NJ4,0^^1;19^K:+X'=X!(X>2000)!(X<100)!(X?.E1"."1N.N) X
 ;;^DD(59.5,20,3)
 ;;=Type a Number between 100 and 2000, 0 Decimal Digits
 ;;^DD(59.5,20,21,0)
 ;;=^^3^3^2920528^^
 ;;^DD(59.5,20,21,1,0)
 ;;=  This is used to allow the site to specify the number of days to keep
 ;;^DD(59.5,20,21,2,0)
 ;;=data in the IV STATS file (50.8). Information may be retained in the
 ;;^DD(59.5,20,21,3,0)
 ;;=IV STATS file for 100 to 2000 days.
 ;;^DD(59.5,20,23,0)
 ;;=^^3^3^2920528^
 ;;^DD(59.5,20,23,1,0)
 ;;=  This is used to allow the site to specify the number of days to keep
 ;;^DD(59.5,20,23,2,0)
 ;;=data in the IV STATS file (50.8). If no value is found for this field,
 ;;^DD(59.5,20,23,3,0)
 ;;=the IV STATS data will be retained for 100 days.
 ;;^DD(59.5,20,"DT")
 ;;=2920528
 ;;^DD(59.51,0)
 ;;=START OF COVERAGE SUB-FIELD^NL^.06^6
 ;;^DD(59.51,0,"DT")
 ;;=2940708
 ;;^DD(59.51,0,"ID","WRITE")
 ;;=W "   ",$P(^(0),"^",2)_" covering from "_$P(^(0),"^",3)
 ;;^DD(59.51,0,"IX","AC",59.51,.02)
 ;;=
 ;;^DD(59.51,0,"NM","START OF COVERAGE")
 ;;=
 ;;^DD(59.51,0,"UP")
 ;;=59.5
 ;;^DD(59.51,.01,0)
 ;;=START OF COVERAGE^MRFX^^0;1^K:$L(X)>4!($L(X)<4)!'(X?1N.N)!(+X>2400)!(X#100>59) X
 ;;^DD(59.51,.01,3)
 ;;=Answer must be in military time (i.e., 4 NUMBERS)!
 ;;^DD(59.51,.01,20,0)
 ;;=^.3LA^1^1
 ;;^DD(59.51,.01,20,1,0)
 ;;=PSJI
 ;;^DD(59.51,.01,21,0)
 ;;=^^4^4^2940708^^^^
 ;;^DD(59.51,.01,21,1,0)
 ;;=Enter the military time that designates the first administration time
 ;;^DD(59.51,.01,21,2,0)
 ;;=covered by this manufacturing run.  In other words, if the previous
 ;;^DD(59.51,.01,21,3,0)
 ;;=manufacturing period covered up to and including the 0900 dose,
 ;;^DD(59.51,.01,21,4,0)
 ;;=the start of coverage would begin at 0901.
 ;;^DD(59.51,.01,"DT")
 ;;=2940708
 ;;^DD(59.51,.02,0)
 ;;=TYPE^RS^A:ADMIXTURES AND PRIMARIES;P:PIGGYBACKS;H:HYPERALS;S:SYRINGE;C:CHEMOTHERAPY;^0;2^Q
 ;;^DD(59.51,.02,1,0)
 ;;=^.1
 ;;^DD(59.51,.02,1,1,0)
 ;;=59.51^AC
 ;;^DD(59.51,.02,1,1,1)
 ;;=S ^PS(59.5,DA(1),2,"AC",$E(X,1,30),DA)=""
 ;;^DD(59.51,.02,1,1,2)
 ;;=K ^PS(59.5,DA(1),2,"AC",$E(X,1,30),DA)
 ;;^DD(59.51,.02,20,0)
 ;;=^.3LA^1^1
 ;;^DD(59.51,.02,20,1,0)
 ;;=PSJI
 ;;^DD(59.51,.02,21,0)
 ;;=^^2^2^2920519^^^^
 ;;^DD(59.51,.02,21,1,0)
 ;;=Enter the IV type for this queue.  You may enter ONLY ONE type
 ;;^DD(59.51,.02,21,2,0)
 ;;=for each queue that you define.
 ;;^DD(59.51,.02,"DT")
 ;;=2920519
 ;;^DD(59.51,.03,0)
 ;;=DESCRIPTION^F^^0;3^K:$L(X)>30!($L(X)<3) X
 ;;^DD(59.51,.03,3)
 ;;=Answer must be 3-30 characters in length.
 ;;^DD(59.51,.03,20,0)
 ;;=^.3LA^1^1
 ;;^DD(59.51,.03,20,1,0)
 ;;=PSJI
 ;;^DD(59.51,.03,21,0)
 ;;=^^5^5^2940714^^^^
 ;;^DD(59.51,.03,21,1,0)
 ;;=You may enter a description for each delivery time (3 to 30 characters).
 ;;^DD(59.51,.03,21,2,0)
 ;;=You will be prompted with a default description and you are
 ;;^DD(59.51,.03,21,3,0)
 ;;=encouraged to USE IT!  This description will appear when you
 ;;^DD(59.51,.03,21,4,0)
 ;;=request manufacturing records and ward lists.  Using the default
 ;;^DD(59.51,.03,21,5,0)
 ;;=prompt will probably lead to less confusion for your users.
