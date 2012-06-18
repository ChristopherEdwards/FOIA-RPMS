FHINI0KN	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(115)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(115.02,15,21,2,0)
	;;=(Reviews are based upon the coded Production Diet). Further reviews are
	;;^DD(115.02,15,21,3,0)
	;;=based upon this last review date/time.
	;;^DD(115.02,15,"DT")
	;;=2910430
	;;^DD(115.02,16,0)
	;;=REVIEW CLERK^P200'^VA(200,^0;17^Q
	;;^DD(115.02,16,21,0)
	;;=^^1^1^2941110^^
	;;^DD(115.02,16,21,1,0)
	;;=This is a pointer to File 200 of the person entering the review.
	;;^DD(115.02,16,"DT")
	;;=2910430
	;;^DD(115.02,17,0)
	;;=CANCELLED DATE/TIME^D^^0;18^S %DT="ET" D ^%DT S X=Y K:Y<1 X
	;;^DD(115.02,17,21,0)
	;;=^^1^1^2941110^^^
	;;^DD(115.02,17,21,1,0)
	;;=This field contains the Date/Time when the NPO was cancelled.
	;;^DD(115.02,17,"DT")
	;;=2920318
	;;^DD(115.02,18,0)
	;;=CANCELLING CLERK^P200'^VA(200,^0;19^Q
	;;^DD(115.02,18,21,0)
	;;=^^2^2^2920318^^
	;;^DD(115.02,18,21,1,0)
	;;=This field contains the user who cancelled the NPO and is
	;;^DD(115.02,18,21,2,0)
	;;=captured automatically at the time of cancellation.
	;;^DD(115.02,18,"DT")
	;;=2920318
	;;^DD(115.02,19,0)
	;;=INDIVIDUAL PATTERN^FI^^2;1^K:$L(X)>200!($L(X)<2) X
	;;^DD(115.02,19,3)
	;;=Answer must be 2-200 characters in length.
	;;^DD(115.02,19,21,0)
	;;=^^6^6^2940526^^^
	;;^DD(115.02,19,21,1,0)
	;;=This field is the individual meal pattern for the patient which
	;;^DD(115.02,19,21,2,0)
	;;=contains three strings of codes, each code separated by a space contains
	;;^DD(115.02,19,21,3,0)
	;;=the internal number of the recipe category and the quantity separated
	;;^DD(115.02,19,21,4,0)
	;;=by a comma for the three meals, breakfast, noon, and evening, each
	;;^DD(115.02,19,21,5,0)
	;;=separated by a semicolon.  The meal pattern will take precedence over
	;;^DD(115.02,19,21,6,0)
	;;=the diet pattern entered in the Diet Pattern file (111.1).
	;;^DD(115.02,19,"DT")
	;;=2941110
	;;^DD(115.02,20,0)
	;;=PATTERN CLERK^P200'^VA(200,^3;1^Q
	;;^DD(115.02,20,21,0)
	;;=^^2^2^2941110^
	;;^DD(115.02,20,21,1,0)
	;;=This is a pointer to File 200 of the person entering the patient's
	;;^DD(115.02,20,21,2,0)
	;;=individual Diet Pattern.
	;;^DD(115.02,20,"DT")
	;;=2941110
	;;^DD(115.02,21,0)
	;;=DATE/TIME PATTERN ENTERED^D^^3;2^S %DT="ET" D ^%DT S X=Y K:Y<1 X
	;;^DD(115.02,21,21,0)
	;;=^^2^2^2941110^
	;;^DD(115.02,21,21,1,0)
	;;=This field contains the Date/Time when the Diet Pattern was
	;;^DD(115.02,21,21,2,0)
	;;=entered.
	;;^DD(115.02,21,"DT")
	;;=2941110
	;;^DD(115.021,0)
	;;=LAB DATA SUB-FIELD^^6^7
	;;^DD(115.021,0,"IX","B",115.021,.01)
	;;=
	;;^DD(115.021,0,"NM","LAB DATA")
	;;=
	;;^DD(115.021,0,"UP")
	;;=115.011
	;;^DD(115.021,.01,0)
	;;=TEST NAME^MF^^0;1^K:$L(X)>30!($L(X)<1) X
	;;^DD(115.021,.01,1,0)
	;;=^.1
	;;^DD(115.021,.01,1,1,0)
	;;=115.021^B
	;;^DD(115.021,.01,1,1,1)
	;;=S ^FHPT(DA(2),"N",DA(1),"L","B",$E(X,1,30),DA)=""
	;;^DD(115.021,.01,1,1,2)
	;;=K ^FHPT(DA(2),"N",DA(1),"L","B",$E(X,1,30),DA)
	;;^DD(115.021,.01,1,1,"%D",0)
	;;=^^1^1^2911118^
	;;^DD(115.021,.01,1,1,"%D",1,0)
	;;=This is the normal B cross-reference of the TEST NAME field.
	;;^DD(115.021,.01,3)
	;;=Answer must be 1-30 characters in length.
	;;^DD(115.021,.01,21,0)
	;;=^^1^1^2891121^
	;;^DD(115.021,.01,21,1,0)
	;;=This field contains the name of the lab test.
	;;^DD(115.021,.01,"DT")
	;;=2890705
	;;^DD(115.021,1,0)
	;;=LAB TEST^P60'^LAB(60,^0;2^Q
	;;^DD(115.021,1,21,0)
	;;=^^2^2^2910813^^^^
	;;^DD(115.021,1,21,1,0)
	;;=This field contains a pointer to the Lab Test file (60)
	;;^DD(115.021,1,21,2,0)
	;;=corresponding to this lab test.
	;;^DD(115.021,1,"DT")
	;;=2890705
	;;^DD(115.021,2,0)
	;;=SPECIMEN^NJ4,0^^0;3^K:+X'=X!(X>9999)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(115.021,2,3)
	;;=Type a Number between 1 and 9999, 0 Decimal Digits
	;;^DD(115.021,2,21,0)
	;;=2
	;;^DD(115.021,2,21,1,0)
	;;=This field contains a pointer to the specimen type used
	;;^DD(115.021,2,21,2,0)
	;;=for the lab test.
	;;^DD(115.021,2,"DT")
	;;=2890705
	;;^DD(115.021,3,0)
	;;=UNITS^F^^0;4^K:$L(X)>10!($L(X)<1) X
	;;^DD(115.021,3,3)
	;;=Answer must be 1-10 characters in length.
	;;^DD(115.021,3,21,0)
	;;=1^^1^1^2901217^
	;;^DD(115.021,3,21,1,0)
	;;=This field indicates the units in which the result is expressed.
	;;^DD(115.021,3,"DT")
	;;=2890705
	;;^DD(115.021,4,0)
	;;=REF. RANGE^F^^0;5^K:$L(X)>11!($L(X)<4) X
	;;^DD(115.021,4,3)
	;;=Answer must be 4-11 characters in length.
	;;^DD(115.021,4,21,0)
	;;=^^2^2^2940616^
	;;^DD(115.021,4,21,1,0)
	;;=This field provides the low-high reference (or normal) range
	;;^DD(115.021,4,21,2,0)
	;;=for the lab test.
	;;^DD(115.021,4,"DT")
	;;=2890705
	;;^DD(115.021,5,0)
	;;=RESULT^F^^0;6^K:$L(X)>10!($L(X)<1) X
	;;^DD(115.021,5,3)
	;;=Answer must be 1-10 characters in length.
