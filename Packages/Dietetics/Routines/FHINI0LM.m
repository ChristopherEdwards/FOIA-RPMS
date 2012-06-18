FHINI0LM	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(117.3)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(117.3,0,"GL")
	;;=^FH(117.3,
	;;^DIC("B","ANNUAL REPORT",117.3)
	;;=
	;;^DIC(117.3,"%D",0)
	;;=^^4^4^2950223^^^^
	;;^DIC(117.3,"%D",1,0)
	;;=The Annual Dietetic Report is designed to facilitate data gathering
	;;^DIC(117.3,"%D",2,0)
	;;=and to eliminate information that has been discontinued or deemed
	;;^DIC(117.3,"%D",3,0)
	;;=irrelevant.  The report will be compiled manually and submitted to
	;;^DIC(117.3,"%D",4,0)
	;;=Central office Dietetics through regular mail.
	;;^DD(117.3,0)
	;;=FIELD^^66^57
	;;^DD(117.3,0,"DDA")
	;;=N
	;;^DD(117.3,0,"DT")
	;;=2931228
	;;^DD(117.3,0,"IX","B",117.3,.01)
	;;=
	;;^DD(117.3,0,"NM","ANNUAL REPORT")
	;;=
	;;^DD(117.3,.01,0)
	;;=QTR/YR^RDX^^0;1^S %DT="E" D ^%DT S X=$E(Y,1,5)_"00" K:Y<1!($E(Y,4,5)>4)!($E(Y,2,3)<1) X I $D(X) S DINUM=X
	;;^DD(117.3,.01,1,0)
	;;=^.1
	;;^DD(117.3,.01,1,1,0)
	;;=117.3^B
	;;^DD(117.3,.01,1,1,1)
	;;=S ^FH(117.3,"B",$E(X,1,30),DA)=""
	;;^DD(117.3,.01,1,1,2)
	;;=K ^FH(117.3,"B",$E(X,1,30),DA)
	;;^DD(117.3,.01,1,1,"%D",0)
	;;=^^1^1^2931221^
	;;^DD(117.3,.01,1,1,"%D",1,0)
	;;=This is a normal B cross-reference of the QTR/YR field.
	;;^DD(117.3,.01,3)
	;;=ENTER A QTR AND A YEAR eg. 1/92, 2 92, 3-92, 04-92.
	;;^DD(117.3,.01,21,0)
	;;=^^1^1^2950223^^^^
	;;^DD(117.3,.01,21,1,0)
	;;=This field contains the Qtr/Yr of the Annual Report entry.
	;;^DD(117.3,.01,"DT")
	;;=2940104
	;;^DD(117.3,2,0)
	;;=REGION #^NJ1,0^^0;3^K:+X'=X!(X>7)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(117.3,2,3)
	;;=Type a Number between 1 and 7, 0 Decimal Digits
	;;^DD(117.3,2,21,0)
	;;=^^1^1^2920827^
	;;^DD(117.3,2,21,1,0)
	;;=This field contains the region number of the facility.
	;;^DD(117.3,2,"DT")
	;;=2920827
	;;^DD(117.3,3,0)
	;;=MULTI DIVISION FACILITY?^S^Y:YES;N:NO;^0;4^Q
	;;^DD(117.3,3,21,0)
	;;=^^1^1^2920827^
	;;^DD(117.3,3,21,1,0)
	;;=This field contains a Y or N if the facility is multi division.
	;;^DD(117.3,3,"DT")
	;;=2920827
	;;^DD(117.3,4,0)
	;;=RPM CLASSIFICATION^NJ1,0^^0;5^K:+X'=X!(X>6)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(117.3,4,3)
	;;=Type a Number between 1 and 6, 0 Decimal Digits
	;;^DD(117.3,4,21,0)
	;;=^^3^3^2920130^^^^
	;;^DD(117.3,4,21,1,0)
	;;=This field contains the RPM Classification which is number 1-6 used to
	;;^DD(117.3,4,21,2,0)
	;;=classify facilities by size, function, and specialty programs for
	;;^DD(117.3,4,21,3,0)
	;;=resource allocation purposes.
	;;^DD(117.3,4,"DT")
	;;=2920130
	;;^DD(117.3,5,0)
	;;=COMPLEXITY LEVEL^NJ1,0X^^0;6^K:+X'=X!(X>4)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(117.3,5,3)
	;;=Type a Number between 1 and 4, 0 Decimal Digits
	;;^DD(117.3,5,21,0)
	;;=^^3^3^2920130^
	;;^DD(117.3,5,21,1,0)
	;;=This field contains the Complexity Level which is number 1-4
	;;^DD(117.3,5,21,2,0)
	;;=that is determined by VACO criteria concerning size and complexity
	;;^DD(117.3,5,21,3,0)
	;;=and upon which grade structure is based.
	;;^DD(117.3,5,"DT")
	;;=2931230
	;;^DD(117.3,6,0)
	;;=VA SPON DIETETIC INTERNSHIP^S^Y:YES;N:NO;^0;7^Q
	;;^DD(117.3,6,21,0)
	;;=^^2^2^2950223^^
	;;^DD(117.3,6,21,1,0)
	;;=This field contains Y or N if there are VA Sponsored Dietetic
	;;^DD(117.3,6,21,2,0)
	;;=Internships.
	;;^DD(117.3,6,"DT")
	;;=2930202
	;;^DD(117.3,7,0)
	;;=AFFILIATED AP4?^S^Y:YES;N:NO;^0;8^Q
	;;^DD(117.3,7,21,0)
	;;=^^1^1^2920130^^
	;;^DD(117.3,7,21,1,0)
	;;=This field contains Y or N if there is Affiliated AP4.
	;;^DD(117.3,7,"DT")
	;;=2920130
	;;^DD(117.3,8,0)
	;;=AFFILIATED DIETETIC INTERN?^S^Y:YES;N:NO;^0;9^Q
	;;^DD(117.3,8,21,0)
	;;=^^1^1^2920130^^
	;;^DD(117.3,8,21,1,0)
	;;=This field contains Y or N if there is Affiliated Dietetic Internship.
	;;^DD(117.3,8,"DT")
	;;=2920130
	;;^DD(117.3,9,0)
	;;=AFFILIATED CUP?^S^Y:YES;N:NO;^0;10^Q
	;;^DD(117.3,9,21,0)
	;;=^^1^1^2920130^^
	;;^DD(117.3,9,21,1,0)
	;;=This field contains Y or N if there is Affiliated Cup.
	;;^DD(117.3,9,"DT")
	;;=2920130
	;;^DD(117.3,10,0)
	;;=VA SPONSORED AP4?^S^Y:YES;N:NO;^0;11^Q
	;;^DD(117.3,10,21,0)
	;;=^^1^1^2920130^^
	;;^DD(117.3,10,21,1,0)
	;;=This field contain Y or N if there is VA Sponsored AP4.
	;;^DD(117.3,10,"DT")
	;;=2920130
	;;^DD(117.3,11,0)
	;;=AFFILIATED DIETETIC TECH?^S^Y:YES;N:NO;^0;12^Q
	;;^DD(117.3,11,21,0)
	;;=^^1^1^2920130^^
	;;^DD(117.3,11,21,1,0)
	;;=This field contain Y or N if there is Affiliated Dietetic Technicians.
	;;^DD(117.3,11,"DT")
	;;=2920130
	;;^DD(117.3,12,0)
	;;=SPECIALIZED MEDICAL PROGRAMS^117.312P^^SPEC;0
	;;^DD(117.3,12,12)
	;;=SELECT ONLY THE SPECIALIZED MEDICAL PROGRAMS.
	;;^DD(117.3,12,12.1)
	;;=S DIC("S")="I $P(^(0),U,2)=""S"""
	;;^DD(117.3,12,21,0)
	;;=^^2^2^2930205^^^^
	;;^DD(117.3,12,21,1,0)
	;;=This multiple contains the categories of the Specialized Medical
