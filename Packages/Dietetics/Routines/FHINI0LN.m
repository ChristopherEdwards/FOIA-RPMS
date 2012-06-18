FHINI0LN	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(117.3)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(117.3,12,21,2,0)
	;;=Programs.
	;;^DD(117.3,13,0)
	;;=PRIMARY DELIVERY SYSTEM^117.313P^^DELV;0
	;;^DD(117.3,13,12)
	;;=SELECT ONLY THE PRIMARY DELIVERY SYSTEM.
	;;^DD(117.3,13,12.1)
	;;=S DIC("S")="I $P(^(0),U,2)=""D"""
	;;^DD(117.3,13,21,0)
	;;=^^1^1^2920916^^^^
	;;^DD(117.3,13,21,1,0)
	;;=This multiple contains the categories of the Primary Delivery System.
	;;^DD(117.3,15,0)
	;;=BEDSIDE TRAY^NJ4,0^^0;14^K:+X'=X!(X>9999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(117.3,15,3)
	;;=Type a Number between 0 and 9999, 0 Decimal Digits
	;;^DD(117.3,15,21,0)
	;;=^^1^1^2920130^
	;;^DD(117.3,15,21,1,0)
	;;=This field contains the number of Bedside Tray Service.
	;;^DD(117.3,15,"DT")
	;;=2920303
	;;^DD(117.3,16,0)
	;;=CAFETERIA^NJ4,0^^0;15^K:+X'=X!(X>9999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(117.3,16,3)
	;;=Type a Number between 0 and 9999, 0 Decimal Digits
	;;^DD(117.3,16,21,0)
	;;=^^1^1^2920130^
	;;^DD(117.3,16,21,1,0)
	;;=This field contains the number of Cafeteria Service.
	;;^DD(117.3,16,"DT")
	;;=2920303
	;;^DD(117.3,17,0)
	;;=DINING ROOM TRAY^NJ4,0^^0;16^K:+X'=X!(X>9999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(117.3,17,3)
	;;=Type a Number between 0 and 9999, 0 Decimal Digits
	;;^DD(117.3,17,21,0)
	;;=^^2^2^2920130^
	;;^DD(117.3,17,21,1,0)
	;;=This field contains number of trays delivered to patients' table
	;;^DD(117.3,17,21,2,0)
	;;=in a dining Area.
	;;^DD(117.3,17,"DT")
	;;=2920303
	;;^DD(117.3,21,0)
	;;=OUTPATIENTS VISIT HOSP^NJ9,0^^1;1^K:+X'=X!(X>999999999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(117.3,21,3)
	;;=Type a Number between 0 and 999999999, 0 Decimal Digits
	;;^DD(117.3,21,21,0)
	;;=^^1^1^2950223^^^
	;;^DD(117.3,21,21,1,0)
	;;=This field contains the number of Inpatients being treated.
	;;^DD(117.3,21,"DT")
	;;=2920211
	;;^DD(117.3,23,0)
	;;=NUMBER OF SATELLITES^NJ1,0^^1;3^K:+X'=X!(X>5)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(117.3,23,3)
	;;=Type a Number between 0 and 5, 0 Decimal Digits
	;;^DD(117.3,23,21,0)
	;;=^^2^2^2950223^^
	;;^DD(117.3,23,21,1,0)
	;;=This field contains the number of Outpatients that visited the Satellite
	;;^DD(117.3,23,21,2,0)
	;;=Clinics.
	;;^DD(117.3,23,"DT")
	;;=2920211
	;;^DD(117.3,25,0)
	;;=SATELLITE LOC^117.325^^CLIN;0
	;;^DD(117.3,25,21,0)
	;;=^^2^2^2920130^
	;;^DD(117.3,25,21,1,0)
	;;=This multiple contains the Locations of the Satellite Clinics and
	;;^DD(117.3,25,21,2,0)
	;;=the number of Outpatients that visited them.
	;;^DD(117.3,26,0)
	;;=TOTAL MEALS SERVED^NJ9,0^^1;5^K:+X'=X!(X>999999999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(117.3,26,3)
	;;=Type a Number between 0 and 999999999, 0 Decimal Digits
	;;^DD(117.3,26,21,0)
	;;=^^1^1^2920130^
	;;^DD(117.3,26,21,1,0)
	;;=The Total Meals Served calculated.
	;;^DD(117.3,26,"DT")
	;;=2920130
	;;^DD(117.3,27,0)
	;;=TOTAL DAILY FTEE^NJ7,3^^1;6^K:+X'=X!(X>999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(117.3,27,3)
	;;=Type a Number between 0 and 999, 3 Decimal Digits
	;;^DD(117.3,27,21,0)
	;;=^^2^2^2920130^
	;;^DD(117.3,27,21,1,0)
	;;=This field contains the count of all personnel assigned to the Dietetic
	;;^DD(117.3,27,21,2,0)
	;;=Service and includes full-time and part-time employees.
	;;^DD(117.3,27,"DT")
	;;=2920130
	;;^DD(117.3,28,0)
	;;=CLINICAL FTEE^NJ7,3^^1;7^K:+X'=X!(X>999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(117.3,28,3)
	;;=Type a Number between 0 and 999, 3 Decimal Digits
	;;^DD(117.3,28,21,0)
	;;=^^3^3^2950104^^^^
	;;^DD(117.3,28,21,1,0)
	;;=This field contains the FTEE of the Clinical Dietitians
	;;^DD(117.3,28,21,2,0)
	;;=and Clinical Technicians who work with the Clinical
	;;^DD(117.3,28,21,3,0)
	;;=Dietitians in patient care activities.
	;;^DD(117.3,28,"DT")
	;;=2920130
	;;^DD(117.3,29,0)
	;;=ADMINISTRATIVE FTEE^NJ7,3^^1;8^K:+X'=X!(X>999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(117.3,29,3)
	;;=Type a Number between 0 and 999, 3 Decimal Digits
	;;^DD(117.3,29,21,0)
	;;=^^4^4^2950104^^^^
	;;^DD(117.3,29,21,1,0)
	;;=This field contains the FTEE of the Chief and Assistant Chief of
	;;^DD(117.3,29,21,2,0)
	;;=the Dietetic Service, Chief of the Administrative Section, Chief
	;;^DD(117.3,29,21,3,0)
	;;=Clinical Section, Administrative dietitians, internship,
	;;^DD(117.3,29,21,4,0)
	;;=education and staff development dietitians and any QA dietitians.
	;;^DD(117.3,29,"DT")
	;;=2920130
	;;^DD(117.3,30,0)
	;;=SUPPORT STAFF FTEE^NJ7,3^^1;9^K:+X'=X!(X>999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(117.3,30,3)
	;;=Type a Number between 0 and 999, 3 Decimal Digits
	;;^DD(117.3,30,21,0)
	;;=^^3^3^2950223^^^^
	;;^DD(117.3,30,21,1,0)
	;;=This field contains the FTEE of all secretaries, clerk-typists,
	;;^DD(117.3,30,21,2,0)
	;;=cost accountants and administrative technicians; it does not
