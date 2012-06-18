FHINI0L5	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(115.7)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(115.7,0,"GL")
	;;=^FHEN(
	;;^DIC("B","DIETETIC ENCOUNTERS",115.7)
	;;=
	;;^DIC(115.7,"%D",0)
	;;=^^4^4^2920623^^^
	;;^DIC(115.7,"%D",1,0)
	;;=This file contains the various dietetic encounters entered
	;;^DIC(115.7,"%D",2,0)
	;;=by dietetics personnel. It includes patient-related events,
	;;^DIC(115.7,"%D",3,0)
	;;=such as diet instructions, as well as non-patient-related
	;;^DIC(115.7,"%D",4,0)
	;;=events such as talks to the community.
	;;^DD(115.7,0)
	;;=FIELD^^102^13
	;;^DD(115.7,0,"DDA")
	;;=N
	;;^DD(115.7,0,"DT")
	;;=2920716
	;;^DD(115.7,0,"IX","AP",115.701,.01)
	;;=
	;;^DD(115.7,0,"IX","AT",115.7,1)
	;;=
	;;^DD(115.7,0,"IX","B",115.7,.01)
	;;=
	;;^DD(115.7,0,"NM","DIETETIC ENCOUNTERS")
	;;=
	;;^DD(115.7,.01,0)
	;;=NUMBER^RNJ9,0X^^0;1^K:+X'=X!(X>999999999)!(X<1)!(X?.E1"."1N.N) X I $D(X) S DINUM=X
	;;^DD(115.7,.01,1,0)
	;;=^.1
	;;^DD(115.7,.01,1,1,0)
	;;=115.7^B
	;;^DD(115.7,.01,1,1,1)
	;;=S ^FHEN("B",$E(X,1,30),DA)=""
	;;^DD(115.7,.01,1,1,2)
	;;=K ^FHEN("B",$E(X,1,30),DA)
	;;^DD(115.7,.01,1,1,"%D",0)
	;;=^^1^1^2931221^^
	;;^DD(115.7,.01,1,1,"%D",1,0)
	;;=This is the normal B cross-reference of the NUMBER field.
	;;^DD(115.7,.01,3)
	;;=Type a Number between 1 and 999999999, 0 Decimal Digits
	;;^DD(115.7,.01,21,0)
	;;=^^2^2^2891121^
	;;^DD(115.7,.01,21,1,0)
	;;=This field contains a sequential number assigned to the encounter
	;;^DD(115.7,.01,21,2,0)
	;;=and has no meaning.
	;;^DD(115.7,.01,"DEL",1,0)
	;;=I DUZ(0)'["@",'$D(^XUSEC("FHMGR",DUZ))
	;;^DD(115.7,.01,"DT")
	;;=2890719
	;;^DD(115.7,1,0)
	;;=DATE/TIME OF ENCOUNTER^RD^^0;2^S %DT="ETX" D ^%DT S X=Y K:Y<1 X
	;;^DD(115.7,1,1,0)
	;;=^.1
	;;^DD(115.7,1,1,1,0)
	;;=115.7^AT
	;;^DD(115.7,1,1,1,1)
	;;=S ^FHEN("AT",$E(X,1,30),DA)=""
	;;^DD(115.7,1,1,1,2)
	;;=K ^FHEN("AT",$E(X,1,30),DA)
	;;^DD(115.7,1,3)
	;;=
	;;^DD(115.7,1,21,0)
	;;=^^2^2^2911016^^
	;;^DD(115.7,1,21,1,0)
	;;=This field contains the date and time at which the dietetic encounter
	;;^DD(115.7,1,21,2,0)
	;;=took place.
	;;^DD(115.7,1,"DT")
	;;=2911016
	;;^DD(115.7,2,0)
	;;=CLINICIAN^RP200'^VA(200,^0;3^Q
	;;^DD(115.7,2,21,0)
	;;=^^2^2^2891120^
	;;^DD(115.7,2,21,1,0)
	;;=This field contains a pointer to the clinician who provided the
	;;^DD(115.7,2,21,2,0)
	;;=service during the encounter.
	;;^DD(115.7,2,"DT")
	;;=2890719
	;;^DD(115.7,3,0)
	;;=ENCOUNTER TYPE^RP115.6'^FH(115.6,^0;4^Q
	;;^DD(115.7,3,21,0)
	;;=^^2^2^2920716^^
	;;^DD(115.7,3,21,1,0)
	;;=This field contains a pointer to the Encounter Type file (115.6)
	;;^DD(115.7,3,21,2,0)
	;;=indicating the type of encounter.
	;;^DD(115.7,3,"DT")
	;;=2920716
	;;^DD(115.7,4,0)
	;;=EVENT LOCATION^P44'^SC(^0;5^Q
	;;^DD(115.7,4,21,0)
	;;=^^2^2^2891120^
	;;^DD(115.7,4,21,1,0)
	;;=This optional field contains a pointer to the Hospital Location
	;;^DD(115.7,4,21,2,0)
	;;=file (44) indicating where the encounter took place.
	;;^DD(115.7,4,"DT")
	;;=2891107
	;;^DD(115.7,5,0)
	;;=INITIAL/FOLLOWUP^S^I:INITIAL;F:FOLLOWUP;^0;7^Q
	;;^DD(115.7,5,21,0)
	;;=^^2^2^2920421^^
	;;^DD(115.7,5,21,1,0)
	;;=This field indicates whether the encounter was an initial one
	;;^DD(115.7,5,21,2,0)
	;;=of this type or a follow-up.
	;;^DD(115.7,5,"DT")
	;;=2890719
	;;^DD(115.7,6,0)
	;;=TIME UNITS^NJ3,0^^0;8^K:+X'=X!(X>999)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(115.7,6,3)
	;;=Type a Number between 1 and 999, 0 Decimal Digits
	;;^DD(115.7,6,21,0)
	;;=^^2^2^2891120^
	;;^DD(115.7,6,21,1,0)
	;;=This field contains the number of time units earned by this
	;;^DD(115.7,6,21,2,0)
	;;=encounter.
	;;^DD(115.7,6,"DT")
	;;=2890719
	;;^DD(115.7,7,0)
	;;=GROUP/INDIVIDUAL^S^G:GROUP;I:INDIVIDUAL;^0;9^Q
	;;^DD(115.7,7,21,0)
	;;=^^2^2^2891120^
	;;^DD(115.7,7,21,1,0)
	;;=This field indicates whether the encounter was a group one or
	;;^DD(115.7,7,21,2,0)
	;;=an encounter with a single individual.
	;;^DD(115.7,7,"DT")
	;;=2890719
	;;^DD(115.7,8,0)
	;;=GROUP SIZE^NJ4,0^^0;10^K:+X'=X!(X>9999)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(115.7,8,3)
	;;=Type a Number between 1 and 9999, 0 Decimal Digits
	;;^DD(115.7,8,21,0)
	;;=^^2^2^2891120^
	;;^DD(115.7,8,21,1,0)
	;;=This field contains the total number of persons involved,
	;;^DD(115.7,8,21,2,0)
	;;=including any collaterals.
	;;^DD(115.7,8,"DT")
	;;=2890719
	;;^DD(115.7,10,0)
	;;=EVENT COMMENT^F^^0;11^K:$L(X)>60!($L(X)<3) X
	;;^DD(115.7,10,3)
	;;=Answer must be 3-60 characters in length.
	;;^DD(115.7,10,21,0)
	;;=^^1^1^2891120^
	;;^DD(115.7,10,21,1,0)
	;;=This field may contain a short comment concerning the event.
	;;^DD(115.7,10,"DT")
	;;=2891107
	;;^DD(115.7,20,0)
	;;=PATIENT^115.701PA^^P;0
	;;^DD(115.7,20,21,0)
	;;=^^2^2^2910813^^
	;;^DD(115.7,20,21,1,0)
	;;=This field is a multiple containing data relating to patients
