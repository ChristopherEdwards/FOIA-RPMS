FHINI0LS	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(117.3)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(117.313,.01,"DT")
	;;=2920915
	;;^DD(117.325,0)
	;;=SATELLITE LOC SUB-FIELD^^1^2
	;;^DD(117.325,0,"DT")
	;;=2920130
	;;^DD(117.325,0,"IX","B",117.325,.01)
	;;=
	;;^DD(117.325,0,"NM","SATELLITE LOC")
	;;=
	;;^DD(117.325,0,"UP")
	;;=117.3
	;;^DD(117.325,.01,0)
	;;=SATELLITE LOC^MF^^0;1^K:$L(X)>20!($L(X)<3) X
	;;^DD(117.325,.01,1,0)
	;;=^.1
	;;^DD(117.325,.01,1,1,0)
	;;=117.325^B
	;;^DD(117.325,.01,1,1,1)
	;;=S ^FH(117.3,DA(1),"CLIN","B",$E(X,1,30),DA)=""
	;;^DD(117.325,.01,1,1,2)
	;;=K ^FH(117.3,DA(1),"CLIN","B",$E(X,1,30),DA)
	;;^DD(117.325,.01,3)
	;;=Answer must be 3-20 characters in length.
	;;^DD(117.325,.01,21,0)
	;;=^^1^1^2920130^
	;;^DD(117.325,.01,21,1,0)
	;;=This field contains the Location of the Satellite Clinics.
	;;^DD(117.325,.01,"DT")
	;;=2920130
	;;^DD(117.325,1,0)
	;;=TOTAL # OF SAT OUTPAT VISITS^NJ9,0^^0;2^K:+X'=X!(X>999999999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(117.325,1,3)
	;;=Type a Number between 0 and 999999999, 0 Decimal Digits
	;;^DD(117.325,1,21,0)
	;;=^^1^1^2930126^^^
	;;^DD(117.325,1,21,1,0)
	;;=This field contains the number of Outpatients that visited the Clinics.
	;;^DD(117.325,1,"DT")
	;;=2930126
	;;^DD(117.332,0)
	;;=TOTAL COST PER DIEM SUB-FIELD^^7^8
	;;^DD(117.332,0,"DT")
	;;=2920323
	;;^DD(117.332,0,"IX","B",117.332,.01)
	;;=
	;;^DD(117.332,0,"NM","TOTAL COST PER DIEM")
	;;=
	;;^DD(117.332,0,"UP")
	;;=117.3
	;;^DD(117.332,.01,0)
	;;=830 REPORT OF COSTS^NJ13,2^^0;1^S:X["$" X=$P(X,"$",2) K:X'?.N.1".".2N!(X>9999999999)!(X<0) X
	;;^DD(117.332,.01,1,0)
	;;=^.1
	;;^DD(117.332,.01,1,1,0)
	;;=117.332^B
	;;^DD(117.332,.01,1,1,1)
	;;=S ^FH(117.3,DA(1),"COST","B",$E(X,1,30),DA)=""
	;;^DD(117.332,.01,1,1,2)
	;;=K ^FH(117.3,DA(1),"COST","B",$E(X,1,30),DA)
	;;^DD(117.332,.01,3)
	;;=Type a Dollar Amount between 0 and 9999999999, 2 Decimal Digits
	;;^DD(117.332,.01,21,0)
	;;=^^1^1^2920820^^^^
	;;^DD(117.332,.01,21,1,0)
	;;=This field contains the cumulative fiscal year totals on the 830 Report.
	;;^DD(117.332,.01,"DT")
	;;=2920325
	;;^DD(117.332,1,0)
	;;=TOTAL PERSONAL SERVICE^NJ13,2^^0;2^S:X["$" X=$P(X,"$",2) K:X'?.N.1".".2N!(X>9999999999)!(X<0) X
	;;^DD(117.332,1,3)
	;;=Type a Dollar Amount between 0 and 9999999999, 2 Decimal Digits
	;;^DD(117.332,1,21,0)
	;;=^^1^1^2920212^^^
	;;^DD(117.332,1,21,1,0)
	;;=This field contains the Total Personal Service.
	;;^DD(117.332,1,"DT")
	;;=2920323
	;;^DD(117.332,2,0)
	;;=PERSONAL SERVICE-TECH 1019^NJ13,2^^0;3^S:X["$" X=$P(X,"$",2) K:X'?.N.1".".2N!(X>9999999999)!(X<0) X
	;;^DD(117.332,2,3)
	;;=Type a Dollar Amount between 0 and 9999999999, 2 Decimal Digits
	;;^DD(117.332,2,21,0)
	;;=^^1^1^2920212^^
	;;^DD(117.332,2,21,1,0)
	;;=This field contains the Technicians Cost of Personal Service.
	;;^DD(117.332,2,"DT")
	;;=2930128
	;;^DD(117.332,3,0)
	;;=PERSONAL SERVICE-DIETITNS 1018^NJ13,2^^0;4^S:X["$" X=$P(X,"$",2) K:X'?.N.1".".2N!(X>9999999999)!(X<0) X
	;;^DD(117.332,3,3)
	;;=Type a Dollar Amount between 0 and 9999999999, 2 Decimal Digits
	;;^DD(117.332,3,21,0)
	;;=^^1^1^2920212^^
	;;^DD(117.332,3,21,1,0)
	;;=This field contains the Dietitians Cost of Personal Service.
	;;^DD(117.332,3,"DT")
	;;=2930128
	;;^DD(117.332,4,0)
	;;=PERSONAL SERVICE-WAGEBRD 1008^NJ13,2^^0;5^S:X["$" X=$P(X,"$",2) K:X'?.N.1".".2N!(X>9999999999)!(X<0) X
	;;^DD(117.332,4,3)
	;;=Type a Dollar Amount between 0 and 9999999999, 2 Decimal Digits
	;;^DD(117.332,4,21,0)
	;;=^^1^1^2920212^^
	;;^DD(117.332,4,21,1,0)
	;;=This field contains the Wageboard Cost of Personal Service.
	;;^DD(117.332,4,"DT")
	;;=2930128
	;;^DD(117.332,5,0)
	;;=PERSONAL SERVICE-CLERICAL 1002^NJ13,2^^0;6^S:X["$" X=$P(X,"$",2) K:X'?.N.1".".2N!(X>9999999999)!(X<0) X
	;;^DD(117.332,5,3)
	;;=Type a Dollar Amount between 0 and 9999999999, 2 Decimal Digits
	;;^DD(117.332,5,21,0)
	;;=^^1^1^2920212^^
	;;^DD(117.332,5,21,1,0)
	;;=This field contains the Clerical Cost of Personal Service.
	;;^DD(117.332,5,"DT")
	;;=2930128
	;;^DD(117.332,6,0)
	;;=SUBSISTENCE 2610^NJ13,2^^0;7^S:X["$" X=$P(X,"$",2) K:X'?.N.1".".2N!(X>9999999999)!(X<0) X
	;;^DD(117.332,6,3)
	;;=Type a Dollar Amount between 0 and 9999999999, 2 Decimal Digits
	;;^DD(117.332,6,21,0)
	;;=^^1^1^2920212^^
	;;^DD(117.332,6,21,1,0)
	;;=This field contains the Subsistence Cost.
	;;^DD(117.332,6,"DT")
	;;=2930128
	;;^DD(117.332,7,0)
	;;=OPERATING SUPPLIES 2660^NJ13,2^^0;8^S:X["$" X=$P(X,"$",2) K:X'?.N.1".".2N!(X>9999999999)!(X<0) X
	;;^DD(117.332,7,3)
	;;=Type a Dollar Amount between 0 and 9999999999, 2 Decimal Digits
	;;^DD(117.332,7,21,0)
	;;=^^1^1^2920212^^^
	;;^DD(117.332,7,21,1,0)
	;;=This field contains the Operating Supplies Cost.
	;;^DD(117.332,7,"DT")
	;;=2930128
