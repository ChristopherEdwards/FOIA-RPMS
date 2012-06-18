FHINI0KL	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(115)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(115.011,48,21,0)
	;;=^^1^1^2900411^^
	;;^DD(115.011,48,21,1,0)
	;;=This is the calculated bone-free arm muscle area in sq. cm.
	;;^DD(115.011,48,"DT")
	;;=2900411
	;;^DD(115.011,49,0)
	;;=BONE-FREE AMA %^NJ2,0^^1;10^K:+X'=X!(X>99)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(115.011,49,3)
	;;=Type a Number between 1 and 99, 0 Decimal Digits
	;;^DD(115.011,49,21,0)
	;;=^^1^1^2900411^^
	;;^DD(115.011,49,21,1,0)
	;;=This is the percentile rank of the bone-free AMA.
	;;^DD(115.011,49,"DT")
	;;=2900411
	;;^DD(115.011,70,0)
	;;=LAB DATA^115.021^^L;0
	;;^DD(115.011,70,21,0)
	;;=^^2^2^2891121^
	;;^DD(115.011,70,21,1,0)
	;;=This multiple contains laboratory data available for the
	;;^DD(115.011,70,21,2,0)
	;;=nutrition assessment.
	;;^DD(115.011,71,0)
	;;=COMMENTS^115.1171^^X;0
	;;^DD(115.011,71,21,0)
	;;=^^1^1^2891121^
	;;^DD(115.011,71,21,1,0)
	;;=This multiple contains comments relating to the assessment.
	;;^DD(115.011,101,0)
	;;=ENTERING CLINICIAN^RP200'^VA(200,^0;23^Q
	;;^DD(115.011,101,21,0)
	;;=^^2^2^2891121^
	;;^DD(115.011,101,21,1,0)
	;;=This field points to the person entering the nutrition
	;;^DD(115.011,101,21,2,0)
	;;=assessment.
	;;^DD(115.011,101,"DT")
	;;=2891108
	;;^DD(115.011,102,0)
	;;=DATE/TIME ENTERED^RD^^0;24^S %DT="ESTXR" D ^%DT S X=Y K:Y<1 X
	;;^DD(115.011,102,21,0)
	;;=^^2^2^2891121^
	;;^DD(115.011,102,21,1,0)
	;;=This field contains the date/time the assessment was actually
	;;^DD(115.011,102,21,2,0)
	;;=entered.
	;;^DD(115.011,102,"DT")
	;;=2891108
	;;^DD(115.012,0)
	;;=NUTRITION STATUS SUB-FIELD^^5^6
	;;^DD(115.012,0,"DT")
	;;=2920826
	;;^DD(115.012,0,"IX","B",115.012,.01)
	;;=
	;;^DD(115.012,0,"NM","NUTRITION STATUS")
	;;=
	;;^DD(115.012,0,"UP")
	;;=115
	;;^DD(115.012,.01,0)
	;;=STATUS DATE/TIME^DX^^0;1^S %DT="ESTXR" D ^%DT S X=Y K:Y<1 X I $D(X) S DINUM=9999999-X
	;;^DD(115.012,.01,1,0)
	;;=^.1
	;;^DD(115.012,.01,1,1,0)
	;;=115.012^B
	;;^DD(115.012,.01,1,1,1)
	;;=S ^FHPT(DA(1),"S","B",$E(X,1,30),DA)=""
	;;^DD(115.012,.01,1,1,2)
	;;=K ^FHPT(DA(1),"S","B",$E(X,1,30),DA)
	;;^DD(115.012,.01,1,1,"%D",0)
	;;=^^1^1^2911118^
	;;^DD(115.012,.01,1,1,"%D",1,0)
	;;=This is the normal B cross-reference of the STATUS DATE/TIME field.
	;;^DD(115.012,.01,21,0)
	;;=^^2^2^2891113^
	;;^DD(115.012,.01,21,1,0)
	;;=This field contains the date/time that a nutrition status
	;;^DD(115.012,.01,21,2,0)
	;;=assessment was entered.
	;;^DD(115.012,.01,"DT")
	;;=2891113
	;;^DD(115.012,1,0)
	;;=STATUS^RP115.4'^FH(115.4,^0;2^Q
	;;^DD(115.012,1,21,0)
	;;=^^2^2^2891121^^
	;;^DD(115.012,1,21,1,0)
	;;=This is a pointer to the Nutrition Status file (115.4) indicating
	;;^DD(115.012,1,21,2,0)
	;;=the current status of this patient.
	;;^DD(115.012,1,"DT")
	;;=2891113
	;;^DD(115.012,2,0)
	;;=ENTRY CLERK^RP200'^VA(200,^0;3^Q
	;;^DD(115.012,2,21,0)
	;;=^^2^2^2891121^^
	;;^DD(115.012,2,21,1,0)
	;;=This is a pointer indicating the person actually making the entry
	;;^DD(115.012,2,21,2,0)
	;;=of the status.
	;;^DD(115.012,2,"DT")
	;;=2891113
	;;^DD(115.012,3,0)
	;;=LAST REVIEW DATE/TIME^D^^0;4^S %DT="ESTXR" D ^%DT S X=Y K:Y<1 X
	;;^DD(115.012,3,21,0)
	;;=^^2^2^2911204^
	;;^DD(115.012,3,21,1,0)
	;;=This is the date/time that this Nutrition Status was last reviewed.
	;;^DD(115.012,3,21,2,0)
	;;=Further reviews are based upon this last review date/time.
	;;^DD(115.012,3,"DT")
	;;=2910430
	;;^DD(115.012,4,0)
	;;=REVIEW CLERK^P200'^VA(200,^0;5^Q
	;;^DD(115.012,4,21,0)
	;;=^^1^1^2911204^
	;;^DD(115.012,4,21,1,0)
	;;=This is a pointer to File 200 of the person entering the review.
	;;^DD(115.012,4,"DT")
	;;=2910430
	;;^DD(115.012,5,0)
	;;=DIETETIC WARD^P119.6'^FH(119.6,^0;6^Q
	;;^DD(115.012,5,21,0)
	;;=^^2^2^2921107^
	;;^DD(115.012,5,21,1,0)
	;;=This field is a pointer to the Dietetic Ward on which the patient
	;;^DD(115.012,5,21,2,0)
	;;=resided when the Nutrition Status was entered.
	;;^DD(115.012,5,"DT")
	;;=2920826
	;;^DD(115.02,0)
	;;=DIET SUB-FIELD^NL^21^23
	;;^DD(115.02,0,"DT")
	;;=2941110
	;;^DD(115.02,0,"NM","DIET")
	;;=
	;;^DD(115.02,0,"UP")
	;;=115.01
	;;^DD(115.02,.01,0)
	;;=ORDER NUMBER^NJ5,0XI^^0;1^K:X'?1N.N X I $D(X) S DINUM=X
	;;^DD(115.02,.01,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 1 AND 99999
	;;^DD(115.02,.01,21,0)
	;;=^^2^2^2880710^
	;;^DD(115.02,.01,21,1,0)
	;;=This field is merely the sequence order in which the diets
	;;^DD(115.02,.01,21,2,0)
	;;=were ordered and has no further meaning.
	;;^DD(115.02,.01,"DT")
	;;=2880515
	;;^DD(115.02,1,0)
	;;=DIET1^P111'I^FH(111,^0;2^Q
	;;^DD(115.02,1,21,0)
	;;=^^2^2^2940526^^
	;;^DD(115.02,1,21,1,0)
	;;=This is the first diet modification selected from the Diets (111)
	;;^DD(115.02,1,21,2,0)
	;;=file.
