FHINI0LH	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(117.1)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(117.1,0,"GL")
	;;=^FH(117.1,
	;;^DIC("B","STAFFING DATA",117.1)
	;;=
	;;^DIC(117.1,"%D",0)
	;;=^^2^2^2910725^^^^
	;;^DIC(117.1,"%D",1,0)
	;;=This file contains the statistical data necessary to prepare the
	;;^DIC(117.1,"%D",2,0)
	;;=Staffing Data report. Data is saved for each date.
	;;^DD(117.1,0)
	;;=FIELD^^19^20
	;;^DD(117.1,0,"DDA")
	;;=N
	;;^DD(117.1,0,"IX","B",117.1,.01)
	;;=
	;;^DD(117.1,0,"NM","STAFFING DATA")
	;;=
	;;^DD(117.1,.01,0)
	;;=DATE^RDX^^0;1^S %DT="EX" D ^%DT S X=Y K:Y<1 X I $D(X) S DINUM=X
	;;^DD(117.1,.01,1,0)
	;;=^.1
	;;^DD(117.1,.01,1,1,0)
	;;=117.1^B
	;;^DD(117.1,.01,1,1,1)
	;;=S ^FH(117.1,"B",$E(X,1,30),DA)=""
	;;^DD(117.1,.01,1,1,2)
	;;=K ^FH(117.1,"B",$E(X,1,30),DA)
	;;^DD(117.1,.01,1,1,"%D",0)
	;;=^^1^1^2911118^
	;;^DD(117.1,.01,1,1,"%D",1,0)
	;;=This is the normal B cross-reference of the DATE field.
	;;^DD(117.1,.01,3)
	;;=
	;;^DD(117.1,.01,21,0)
	;;=^^1^1^2910514^^
	;;^DD(117.1,.01,21,1,0)
	;;=This is the date for which staffing data is entered.
	;;^DD(117.1,1,0)
	;;=DAILY FTEE^NJ7,3^^0;2^K:+X'=X!(X>999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(117.1,1,3)
	;;=Type a Number between 0 and 999, 3 Decimal Digits
	;;^DD(117.1,1,21,0)
	;;=^^2^2^2920129^^^^
	;;^DD(117.1,1,21,1,0)
	;;=This field contains the count of all personnel assigned to the
	;;^DD(117.1,1,21,2,0)
	;;=Dietetic Service and includes full-time and part-time employees.
	;;^DD(117.1,1,"DT")
	;;=2891120
	;;^DD(117.1,2,0)
	;;=CLINICAL FTEE^NJ7,3^^0;3^K:+X'=X!(X>999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(117.1,2,3)
	;;=Type a Number between 0 and 999, 3 Decimal Digits
	;;^DD(117.1,2,21,0)
	;;=^^3^3^2950104^^^^
	;;^DD(117.1,2,21,1,0)
	;;=This field contains the FTEE of the clinical dietitians
	;;^DD(117.1,2,21,2,0)
	;;=and clinical technicians who work with the clinical
	;;^DD(117.1,2,21,3,0)
	;;=dietitians in patient care activities.
	;;^DD(117.1,2,"DT")
	;;=2891120
	;;^DD(117.1,3,0)
	;;=ADMINISTRATIVE FTEE^NJ7,3^^0;4^K:+X'=X!(X>999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(117.1,3,3)
	;;=Type a Number between 0 and 999, 3 Decimal Digits
	;;^DD(117.1,3,21,0)
	;;=5^^4^4^2950104^^
	;;^DD(117.1,3,21,1,0)
	;;=This field contains the FTEE of the Chief and Assistant Chief
	;;^DD(117.1,3,21,2,0)
	;;=of the Dietetic Service, Chief of the Administrative section,
	;;^DD(117.1,3,21,3,0)
	;;=Chief Clinical Section, administrative dietitians, internship,
	;;^DD(117.1,3,21,4,0)
	;;=education and staff development dietitians, and any QA dietitians.
	;;^DD(117.1,3,"DT")
	;;=2891120
	;;^DD(117.1,4,0)
	;;=SUPPORT STAFF FTEE^NJ7,3^^0;5^K:+X'=X!(X>999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(117.1,4,3)
	;;=Type a Number between 0 and 999, 3 Decimal Digits
	;;^DD(117.1,4,21,0)
	;;=^^3^3^2950222^^^^
	;;^DD(117.1,4,21,1,0)
	;;=This field contains the FTEE of all secretaries, clerk-typists,
	;;^DD(117.1,4,21,2,0)
	;;=cost accountants, and administrative technicians; it does not
	;;^DD(117.1,4,21,3,0)
	;;=include diet communications personnel.
	;;^DD(117.1,4,"DT")
	;;=2891120
	;;^DD(117.1,5,0)
	;;=CFWS FTEE^NJ7,3^^0;6^K:+X'=X!(X>999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(117.1,5,3)
	;;=Type a Number between 0 and 999, 3 Decimal Digits
	;;^DD(117.1,5,21,0)
	;;=^^2^2^2930204^^^
	;;^DD(117.1,5,21,1,0)
	;;=This field contains the FTEE of Supervisory Cooks and Supervisory
	;;^DD(117.1,5,21,2,0)
	;;=Food Service workers.
	;;^DD(117.1,5,"DT")
	;;=2891120
	;;^DD(117.1,6,0)
	;;=DAYS OFF HOURS^NJ7,2^^0;7^K:+X'=X!(X>9999)!(X<0)!(X?.E1"."3N.N) X
	;;^DD(117.1,6,3)
	;;=Type a Number between 0 and 9999, 2 Decimal Digits
	;;^DD(117.1,6,21,0)
	;;=^^2^2^2891121^^^
	;;^DD(117.1,6,21,1,0)
	;;=This field contains the count of hours not worked by measured
	;;^DD(117.1,6,21,2,0)
	;;=personnel.
	;;^DD(117.1,6,"DT")
	;;=2891121
	;;^DD(117.1,7,0)
	;;=LWOP & AWOL HOURS^NJ6,2^^0;8^K:+X'=X!(X>999)!(X<0)!(X?.E1"."3N.N) X
	;;^DD(117.1,7,3)
	;;=Type a Number between 0 and 999, 2 Decimal Digits
	;;^DD(117.1,7,21,0)
	;;=^^2^2^2891120^
	;;^DD(117.1,7,21,1,0)
	;;=This field contains the number of LWOP and AWOL hours for
	;;^DD(117.1,7,21,2,0)
	;;=measured personnel.
	;;^DD(117.1,8,0)
	;;=OVERTIME HOURS^NJ6,2^^0;9^K:+X'=X!(X>999)!(X<0)!(X?.E1"."3N.N) X
	;;^DD(117.1,8,3)
	;;=Type a Number between 0 and 999, 2 Decimal Digits
	;;^DD(117.1,8,21,0)
	;;=^^2^2^2891120^
	;;^DD(117.1,8,21,1,0)
	;;=This field contains the number of overtime hours worked by
	;;^DD(117.1,8,21,2,0)
	;;=measured personnel.
	;;^DD(117.1,9,0)
	;;=UNSCHEDULED HOURS^NJ6,2^^0;10^K:+X'=X!(X>999)!(X<0)!(X?.E1"."3N.N) X
	;;^DD(117.1,9,3)
	;;=Type a Number between 0 and 999, 2 Decimal Digits
	;;^DD(117.1,9,21,0)
	;;=^^2^2^2921124^^^
	;;^DD(117.1,9,21,1,0)
	;;=This field contains the number of unscheduled hours worked by
