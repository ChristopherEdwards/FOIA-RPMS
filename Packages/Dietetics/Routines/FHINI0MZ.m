FHINI0MZ	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(119.8)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(119.8,0,"GL")
	;;=^FH(119.8,
	;;^DIC("B","DIETETIC EVENTS",119.8)
	;;=
	;;^DIC(119.8,"%D",0)
	;;=^^4^4^2920705^
	;;^DIC(119.8,"%D",1,0)
	;;=This file contains entries for all patient movements, diet changes,
	;;^DIC(119.8,"%D",2,0)
	;;=tubefeeding orders, additional orders, food preferences, standing
	;;^DIC(119.8,"%D",3,0)
	;;=orders, and patient isolation orders requiring action by the
	;;^DIC(119.8,"%D",4,0)
	;;=Dietetic Service.
	;;^DD(119.8,0)
	;;=FIELD^^8^9
	;;^DD(119.8,0,"DT")
	;;=2950317
	;;^DD(119.8,0,"IX","AD",119.8,1)
	;;=
	;;^DD(119.8,0,"IX","AP",119.8,2)
	;;=
	;;^DD(119.8,0,"IX","AP1",119.8,1)
	;;=
	;;^DD(119.8,0,"IX","B",119.8,.01)
	;;=
	;;^DD(119.8,0,"NM","DIETETIC EVENTS")
	;;=
	;;^DD(119.8,.01,0)
	;;=NUMBER^RNJ9,0X^^0;1^K:+X'=X!(X>999999999)!(X<1)!(X?.E1"."1N.N) X I $D(X) S DINUM=X
	;;^DD(119.8,.01,1,0)
	;;=^.1
	;;^DD(119.8,.01,1,1,0)
	;;=119.8^B
	;;^DD(119.8,.01,1,1,1)
	;;=S ^FH(119.8,"B",$E(X,1,30),DA)=""
	;;^DD(119.8,.01,1,1,2)
	;;=K ^FH(119.8,"B",$E(X,1,30),DA)
	;;^DD(119.8,.01,1,1,"%D",0)
	;;=^^1^1^2911118^
	;;^DD(119.8,.01,1,1,"%D",1,0)
	;;=This is the normal B cross-reference of the NUMBER field.
	;;^DD(119.8,.01,3)
	;;=Type a Number between 1 and 999999999, 0 Decimal Digits
	;;^DD(119.8,.01,21,0)
	;;=^^2^2^2921107^^^^
	;;^DD(119.8,.01,21,1,0)
	;;=This field contains a sequential number assigned to the event
	;;^DD(119.8,.01,21,2,0)
	;;=and has no meaning.
	;;^DD(119.8,.01,"DEL",1,0)
	;;=I DUZ(0)'["@",'$D(^XUSEC("FHMGR",DUZ))
	;;^DD(119.8,.01,"DT")
	;;=2890719
	;;^DD(119.8,1,0)
	;;=DATE/TIME^RD^^0;2^S %DT="ESTXR" D ^%DT S X=Y K:Y<1 X
	;;^DD(119.8,1,1,0)
	;;=^.1
	;;^DD(119.8,1,1,1,0)
	;;=119.8^AD
	;;^DD(119.8,1,1,1,1)
	;;=S ^FH(119.8,"AD",$E(X,1,30),DA)=""
	;;^DD(119.8,1,1,1,2)
	;;=K ^FH(119.8,"AD",$E(X,1,30),DA)
	;;^DD(119.8,1,1,1,"DT")
	;;=2920704
	;;^DD(119.8,1,1,2,0)
	;;=119.8^AP1^MUMPS
	;;^DD(119.8,1,1,2,1)
	;;=S X1=$P(^FH(119.8,DA,0),U,3) I X1 S ^FH(119.8,"AP",X1,X,DA)=""
	;;^DD(119.8,1,1,2,2)
	;;=S X1=$P(^FH(119.8,DA,0),U,3) I X1 K ^FH(119.8,"AP",X1,X,DA)
	;;^DD(119.8,1,1,2,"%D",0)
	;;=^^2^2^2940823^^
	;;^DD(119.8,1,1,2,"%D",1,0)
	;;=This is a cross-reference of dietetic events by patient and date/time.
	;;^DD(119.8,1,1,2,"%D",2,0)
	;;=Field 2 is also used to set the cross-reference.
	;;^DD(119.8,1,1,2,"DT")
	;;=2920705
	;;^DD(119.8,1,21,0)
	;;=^^1^1^2921107^
	;;^DD(119.8,1,21,1,0)
	;;=This is the date/time at which the event occurred.
	;;^DD(119.8,1,"DT")
	;;=2920705
	;;^DD(119.8,2,0)
	;;=PATIENT^RP115'^FHPT(^0;3^Q
	;;^DD(119.8,2,1,0)
	;;=^.1
	;;^DD(119.8,2,1,1,0)
	;;=119.8^AP^MUMPS
	;;^DD(119.8,2,1,1,1)
	;;=S X1=$P(^FH(119.8,DA,0),U,2) I X1 S ^FH(119.8,"AP",X,X1,DA)=""
	;;^DD(119.8,2,1,1,2)
	;;=S X1=$P(^FH(119.8,DA,0),U,2) I X1 K ^FH(119.8,"AP",X,X1,DA)
	;;^DD(119.8,2,1,1,"%D",0)
	;;=^^2^2^2940823^
	;;^DD(119.8,2,1,1,"%D",1,0)
	;;=This is a cross-reference of dietetic events by patient and date/time.
	;;^DD(119.8,2,1,1,"%D",2,0)
	;;=Field 1 is also used to set the cross-reference.
	;;^DD(119.8,2,1,1,"DT")
	;;=2920705
	;;^DD(119.8,2,21,0)
	;;=^^2^2^2921107^
	;;^DD(119.8,2,21,1,0)
	;;=This is a pointer to the patient with which the event is
	;;^DD(119.8,2,21,2,0)
	;;=associated.
	;;^DD(119.8,2,"DT")
	;;=2920705
	;;^DD(119.8,3,0)
	;;=ADMISSION^RP405'^DGPM(^0;4^Q
	;;^DD(119.8,3,1,0)
	;;=^.1^^0
	;;^DD(119.8,3,21,0)
	;;=^^2^2^2921107^
	;;^DD(119.8,3,21,1,0)
	;;=This is a pointer to the admission (Movement) with which the
	;;^DD(119.8,3,21,2,0)
	;;=event is associated.
	;;^DD(119.8,3,"DT")
	;;=2920705
	;;^DD(119.8,4,0)
	;;=TYPE OF EVENT^RS^L:LOCATION;D:DIET;I:ISOLATION;T:T/F;O:OTHER;P:PREF.;S:STD. ORDERS;^0;5^Q
	;;^DD(119.8,4,21,0)
	;;=^^1^1^2930913^^
	;;^DD(119.8,4,21,1,0)
	;;=This is a set of codes indicating the type of event.
	;;^DD(119.8,4,"DT")
	;;=2920704
	;;^DD(119.8,5,0)
	;;=ACTION^S^O:ORDERED;C:CANCELLED;A:ADMIT;T:TRANSFER;D:DISCHARGE;^0;6^Q
	;;^DD(119.8,5,21,0)
	;;=^^2^2^2930913^^
	;;^DD(119.8,5,21,1,0)
	;;=This is a set of codes indicating the type of action; A D T are
	;;^DD(119.8,5,21,2,0)
	;;=associated only with location changes.
	;;^DD(119.8,5,"DT")
	;;=2920705
	;;^DD(119.8,6,0)
	;;=ORDER #^RNJ7,0^^0;7^K:+X'=X!(X>9999999)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(119.8,6,3)
	;;=Type a Number between 1 and 9999999, 0 Decimal Digits
	;;^DD(119.8,6,21,0)
	;;=^^1^1^2921107^
	;;^DD(119.8,6,21,1,0)
	;;=This value corresponds to the associated Order for the event.
	;;^DD(119.8,6,"DT")
	;;=2920704
	;;^DD(119.8,7,0)
	;;=TEXT^F^^0;8^K:$L(X)>120!($L(X)<3) X
	;;^DD(119.8,7,3)
	;;=Answer must be 3-120 characters in length.
	;;^DD(119.8,7,21,0)
	;;=^^2^2^2921107^
	;;^DD(119.8,7,21,1,0)
	;;=This is the text of the order; for location changes it represents
