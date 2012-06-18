FHINI0L6	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(115.7)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(115.7,20,21,2,0)
	;;=involved in the encounter.
	;;^DD(115.7,101,0)
	;;=ENTERING CLERK^RP200'^VA(200,^0;13^Q
	;;^DD(115.7,101,21,0)
	;;=^^2^2^2891121^
	;;^DD(115.7,101,21,1,0)
	;;=This field is a pointer indicating the person making the
	;;^DD(115.7,101,21,2,0)
	;;=encounter entry.
	;;^DD(115.7,101,"DT")
	;;=2891108
	;;^DD(115.7,102,0)
	;;=DATE/TIME ENTERED^RD^^0;14^S %DT="ESTXR" D ^%DT S X=Y K:Y<1 X
	;;^DD(115.7,102,21,0)
	;;=^^2^2^2891121^
	;;^DD(115.7,102,21,1,0)
	;;=This field contains the date/time the encounter was actually
	;;^DD(115.7,102,21,2,0)
	;;=entered.
	;;^DD(115.7,102,"DT")
	;;=2891108
	;;^DD(115.701,0)
	;;=PATIENT SUB-FIELD^^3^4
	;;^DD(115.701,0,"IX","B",115.701,.01)
	;;=
	;;^DD(115.701,0,"NM","PATIENT")
	;;=
	;;^DD(115.701,0,"UP")
	;;=115.7
	;;^DD(115.701,.01,0)
	;;=PATIENT^MP2'X^DPT(^0;1^I $D(X) S DINUM=X
	;;^DD(115.701,.01,1,0)
	;;=^.1
	;;^DD(115.701,.01,1,1,0)
	;;=115.701^B
	;;^DD(115.701,.01,1,1,1)
	;;=S ^FHEN(DA(1),"P","B",$E(X,1,30),DA)=""
	;;^DD(115.701,.01,1,1,2)
	;;=K ^FHEN(DA(1),"P","B",$E(X,1,30),DA)
	;;^DD(115.701,.01,1,1,"%D",0)
	;;=^^1^1^2911118^
	;;^DD(115.701,.01,1,1,"%D",1,0)
	;;=This is the normal B cross-reference of the PATIENT field.
	;;^DD(115.701,.01,1,2,0)
	;;=115.7^AP^MUMPS
	;;^DD(115.701,.01,1,2,1)
	;;=S X1=$P(^FHEN(DA(1),0),"^",2) S:X1 ^FHEN("AP",X,X1,DA(1))=""
	;;^DD(115.701,.01,1,2,2)
	;;=S X1=$P(^FHEN(DA(1),0),"^",2) K:X1 ^FHEN("AP",X,X1,DA(1))
	;;^DD(115.701,.01,1,2,"%D",0)
	;;=2^^2^2^2940824^
	;;^DD(115.701,.01,1,2,"%D",1,0)
	;;=This cross-reference creates an 'AP' node of a patient by date/time
	;;^DD(115.701,.01,1,2,"%D",2,0)
	;;=cross-reference.
	;;^DD(115.701,.01,21,0)
	;;=^^2^2^2910813^^
	;;^DD(115.701,.01,21,1,0)
	;;=This field contains a pointer to the Patient file (2) and indicates
	;;^DD(115.701,.01,21,2,0)
	;;=a patient involved in the encounter.
	;;^DD(115.701,.01,"DT")
	;;=2891113
	;;^DD(115.701,1,0)
	;;=LOCATION^P44'^SC(^0;2^Q
	;;^DD(115.701,1,21,0)
	;;=^^3^3^2891121^
	;;^DD(115.701,1,21,1,0)
	;;=This field contains a pointer to the Hospital Location
	;;^DD(115.701,1,21,2,0)
	;;=(file 44) for the patient. It is the patient location rather
	;;^DD(115.701,1,21,3,0)
	;;=than the event location.
	;;^DD(115.701,1,"DT")
	;;=2890719
	;;^DD(115.701,2,0)
	;;=# COLLATERALS^NJ1,0^^0;3^K:+X'=X!(X>9)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(115.701,2,3)
	;;=Type a Number between 0 and 9, 0 Decimal Digits
	;;^DD(115.701,2,21,0)
	;;=^^2^2^2891121^
	;;^DD(115.701,2,21,1,0)
	;;=This field contains the number of collaterals seen with the
	;;^DD(115.701,2,21,2,0)
	;;=patient.
	;;^DD(115.701,2,"DT")
	;;=2891107
	;;^DD(115.701,3,0)
	;;=PATIENT COMMENT^F^^0;4^K:$L(X)>60!($L(X)<3) X
	;;^DD(115.701,3,3)
	;;=Answer must be 3-60 characters in length.
	;;^DD(115.701,3,21,0)
	;;=^^2^2^2891121^
	;;^DD(115.701,3,21,1,0)
	;;=This field may be used for a patient-specific comment
	;;^DD(115.701,3,21,2,0)
	;;=concerning the encounter.
	;;^DD(115.701,3,"DT")
	;;=2891107
