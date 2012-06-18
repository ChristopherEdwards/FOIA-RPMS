FHINI0LE	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(117)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(117,0,"GL")
	;;=^FH(117,
	;;^DIC("B","MEALS SERVED",117)
	;;=
	;;^DIC(117,"%D",0)
	;;=^^3^3^2950613^^^^
	;;^DIC(117,"%D",1,0)
	;;=This file contains the statistical data necessary to prepare the
	;;^DIC(117,"%D",2,0)
	;;=Served Meals Report and the Staffing Data Report. Data
	;;^DIC(117,"%D",3,0)
	;;=is saved for each date.
	;;^DD(117,0)
	;;=FIELD^^58^34
	;;^DD(117,0,"DDA")
	;;=N
	;;^DD(117,0,"DT")
	;;=2920618
	;;^DD(117,0,"IX","B",117,.01)
	;;=
	;;^DD(117,0,"NM","MEALS SERVED")
	;;=
	;;^DD(117,.01,0)
	;;=CENSUS DATE^RDX^^0;1^S %DT="EX" D ^%DT S X=Y K:Y<1 X I $D(X) S DINUM=X
	;;^DD(117,.01,1,0)
	;;=^.1
	;;^DD(117,.01,1,1,0)
	;;=117^B
	;;^DD(117,.01,1,1,1)
	;;=S ^FH(117,"B",$E(X,1,30),DA)=""
	;;^DD(117,.01,1,1,2)
	;;=K ^FH(117,"B",$E(X,1,30),DA)
	;;^DD(117,.01,1,1,"%D",0)
	;;=^^1^1^2911118^
	;;^DD(117,.01,1,1,"%D",1,0)
	;;=This is the normal B cross-reference of the CENSUS DATE field.
	;;^DD(117,.01,3)
	;;=
	;;^DD(117,.01,21,0)
	;;=^^2^2^2880716^
	;;^DD(117,.01,21,1,0)
	;;=This is the date for which various dietetic census and performance
	;;^DD(117,.01,21,2,0)
	;;=standards data are entered.
	;;^DD(117,.01,"DT")
	;;=2870122
	;;^DD(117,1,0)
	;;=DOM MEMBERS^NJ4,0^^0;2^K:+X'=X!(X>9999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(117,1,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 0 AND 9999
	;;^DD(117,1,21,0)
	;;=^^2^2^2880716^
	;;^DD(117,1,21,1,0)
	;;=This field contains the number of Domiciliary members shown by MAS
	;;^DD(117,1,21,2,0)
	;;=as being admitted patients on the census date.
	;;^DD(117,2,0)
	;;=DOM ABSENCES^NJ4,0^^0;3^K:+X'=X!(X>9999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(117,2,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 0 AND 9999
	;;^DD(117,2,21,0)
	;;=^^2^2^2880716^
	;;^DD(117,2,21,1,0)
	;;=This field contains the number of Domiciliary members on
	;;^DD(117,2,21,2,0)
	;;=authorized or unauthorized absence on the census date.
	;;^DD(117,4,0)
	;;=NHCU PATIENTS^NJ4,0^^0;4^K:+X'=X!(X>9999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(117,4,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 0 AND 9999
	;;^DD(117,4,21,0)
	;;=^^2^2^2880716^
	;;^DD(117,4,21,1,0)
	;;=This field contains the number of Nursing Home Care Unit patients
	;;^DD(117,4,21,2,0)
	;;=being shown by MAS as admitted patients on the census date.
	;;^DD(117,5,0)
	;;=NHCU ABSENCES^NJ4,0^^0;5^K:+X'=X!(X>9999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(117,5,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 0 AND 9999
	;;^DD(117,5,21,0)
	;;=^^2^2^2880716^
	;;^DD(117,5,21,1,0)
	;;=This field contains the number of Nursing Home Care Unit patients
	;;^DD(117,5,21,2,0)
	;;=on authorized or unauthorized absence on the census date.
	;;^DD(117,7,0)
	;;=HOSP INPATIENTS^NJ4,0^^0;6^K:+X'=X!(X>9999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(117,7,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 0 AND 9999
	;;^DD(117,7,21,0)
	;;=^^2^2^2880716^
	;;^DD(117,7,21,1,0)
	;;=This field contains the number of Hospital inpatients being shown
	;;^DD(117,7,21,2,0)
	;;=by MAS as admitted patients on the census date.
	;;^DD(117,8,0)
	;;=HOSP ABSENCES^NJ4,0^^0;7^K:+X'=X!(X>9999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(117,8,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 0 AND 9999
	;;^DD(117,8,21,0)
	;;=^^2^2^2910625^^
	;;^DD(117,8,21,1,0)
	;;=This field contains the number of Hospital inpatients on
	;;^DD(117,8,21,2,0)
	;;=authorized or unauthorized absence on the census date.
	;;^DD(117,30,0)
	;;=OUTPATIENT BREAKFAST^NJ4,0^^1;1^K:+X'=X!(X>9999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(117,30,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 0 AND 9999
	;;^DD(117,30,21,0)
	;;=^^2^2^2880716^
	;;^DD(117,30,21,1,0)
	;;=This field contains the number of breakfast meals served to
	;;^DD(117,30,21,2,0)
	;;=outpatients on the census date.
	;;^DD(117,31,0)
	;;=OUTPATIENT NOON^NJ4,0^^1;2^K:+X'=X!(X>9999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(117,31,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 0 AND 9999
	;;^DD(117,31,21,0)
	;;=^^2^2^2880716^
	;;^DD(117,31,21,1,0)
	;;=This field contains the number of noon meals served to
	;;^DD(117,31,21,2,0)
	;;=outpatients on the census date.
	;;^DD(117,32,0)
	;;=OUTPATIENT EVENING^NJ4,0^^1;3^K:+X'=X!(X>9999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(117,32,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 0 AND 9999
	;;^DD(117,32,21,0)
	;;=^^2^2^2880716^
	;;^DD(117,32,21,1,0)
	;;=This field contains the number of evening meals served to
	;;^DD(117,32,21,2,0)
	;;=outpatients on the census date.
	;;^DD(117,33,0)
	;;=CONTRACT BREAK^NJ4,0^^1;4^K:+X'=X!(X>9999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(117,33,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 0 AND 9999
	;;^DD(117,33,21,0)
	;;=^^2^2^2880716^
	;;^DD(117,33,21,1,0)
	;;=This field contains the number of breakfast meals served
	;;^DD(117,33,21,2,0)
	;;=under contract on the census date.
	;;^DD(117,34,0)
	;;=CONTRACT NOON^NJ4,0^^1;5^K:+X'=X!(X>9999)!(X<0)!(X?.E1"."1N.N) X
