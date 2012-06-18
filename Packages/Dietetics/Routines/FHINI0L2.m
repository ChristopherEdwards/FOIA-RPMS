FHINI0L2	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(115.6)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(115.6,0,"GL")
	;;=^FH(115.6,
	;;^DIC("B","ENCOUNTER TYPES",115.6)
	;;=
	;;^DIC(115.6,"%D",0)
	;;=^^3^3^2920623^^
	;;^DIC(115.6,"%D",1,0)
	;;=This file contains a list of types of dietetic encounters,
	;;^DIC(115.6,"%D",2,0)
	;;=or events, which are used to account for many of the professional
	;;^DIC(115.6,"%D",3,0)
	;;=activities of dietetic personnel.
	;;^DD(115.6,0)
	;;=FIELD^^101^11
	;;^DD(115.6,0,"DDA")
	;;=N
	;;^DD(115.6,0,"DT")
	;;=2920116
	;;^DD(115.6,0,"ID",99)
	;;=W:$D(^("I")) "   (** INACTIVE **)"
	;;^DD(115.6,0,"IX","AC",115.6,99)
	;;=
	;;^DD(115.6,0,"IX","AX",115.6,101)
	;;=
	;;^DD(115.6,0,"IX","B",115.6,.01)
	;;=
	;;^DD(115.6,0,"NM","ENCOUNTER TYPES")
	;;=
	;;^DD(115.6,0,"PT",115.7,3)
	;;=
	;;^DD(115.6,0,"SCR")
	;;=I '$D(^FH(115.6,+Y,"I"))!$D(^XUSEC("FHMGR",DUZ))!(DUZ(0)["@")
	;;^DD(115.6,.01,0)
	;;=NAME^RF^^0;1^K:$L(X)>30!($L(X)<3)!'(X'?1P.E) X
	;;^DD(115.6,.01,1,0)
	;;=^.1
	;;^DD(115.6,.01,1,1,0)
	;;=115.6^B
	;;^DD(115.6,.01,1,1,1)
	;;=S ^FH(115.6,"B",$E(X,1,30),DA)=""
	;;^DD(115.6,.01,1,1,2)
	;;=K ^FH(115.6,"B",$E(X,1,30),DA)
	;;^DD(115.6,.01,1,1,"%D",0)
	;;=^^1^1^2911118^
	;;^DD(115.6,.01,1,1,"%D",1,0)
	;;=This is the normal B cross-reference of the NAME field.
	;;^DD(115.6,.01,3)
	;;=Answer must be 3-30 characters in length.
	;;^DD(115.6,.01,21,0)
	;;=^^1^1^2891121^
	;;^DD(115.6,.01,21,1,0)
	;;=This is the text of the name of the encounter type.
	;;^DD(115.6,.01,"DEL",1,0)
	;;=I DUZ(0)'["@",'$D(^XUSEC("FHMGR",DUZ))
	;;^DD(115.6,.01,"DEL",2,0)
	;;=I DA<50
	;;^DD(115.6,.01,"DT")
	;;=2920116
	;;^DD(115.6,2,0)
	;;=INITIAL TIME^NJ3,0^^0;3^K:+X'=X!(X>999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(115.6,2,3)
	;;=Type a Number between 0 and 999, 0 Decimal Digits
	;;^DD(115.6,2,21,0)
	;;=^^1^1^2900112^^
	;;^DD(115.6,2,21,1,0)
	;;=This is the time units for an initial encounter of this type.
	;;^DD(115.6,2,"DT")
	;;=2900112
	;;^DD(115.6,3,0)
	;;=FOLLOW-UP TIME^NJ3,0^^0;4^K:+X'=X!(X>999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(115.6,3,3)
	;;=Type a Number between 0 and 999, 0 Decimal Digits
	;;^DD(115.6,3,21,0)
	;;=^^2^2^2891121^
	;;^DD(115.6,3,21,1,0)
	;;=This value, if defined, is the time units for a follow-up
	;;^DD(115.6,3,21,2,0)
	;;=encounter of this type.
	;;^DD(115.6,3,"DT")
	;;=2891107
	;;^DD(115.6,4,0)
	;;=ASK EVENT LOCATION?^S^Y:YES;N:NO;^0;5^Q
	;;^DD(115.6,4,21,0)
	;;=^^3^3^2891121^
	;;^DD(115.6,4,21,1,0)
	;;=This field, if YES, means that the event location will be asked
	;;^DD(115.6,4,21,2,0)
	;;=whenever an encounter of this type is entered into the
	;;^DD(115.6,4,21,3,0)
	;;=Encounter file (115.7).
	;;^DD(115.6,4,"DT")
	;;=2891107
	;;^DD(115.6,5,0)
	;;=INDIVIDUAL/GROUP/BOTH^S^I:INDIVIDUAL;G:GROUP;B:BOTH;^0;6^Q
	;;^DD(115.6,5,21,0)
	;;=^^2^2^2891121^
	;;^DD(115.6,5,21,1,0)
	;;=This field indicates whether the encounter type is an individual one,
	;;^DD(115.6,5,21,2,0)
	;;=a group one, or can be both.
	;;^DD(115.6,5,"DT")
	;;=2891107
	;;^DD(115.6,6,0)
	;;=ASK PATIENT NAME(S)?^S^Y:YES;N:NO;^0;7^Q
	;;^DD(115.6,6,21,0)
	;;=^^3^3^2891121^
	;;^DD(115.6,6,21,1,0)
	;;=This field, if answered YES, means that the clinician will be
	;;^DD(115.6,6,21,2,0)
	;;=prompted for patient names when an encounter of this type
	;;^DD(115.6,6,21,3,0)
	;;=is entered into the Encounter file (115.7).
	;;^DD(115.6,6,"DT")
	;;=2891107
	;;^DD(115.6,7,0)
	;;=ASK # COLLATERALS^S^Y:YES;N:NO;^0;8^Q
	;;^DD(115.6,7,21,0)
	;;=^^4^4^2891121^
	;;^DD(115.6,7,21,1,0)
	;;=This field, if answered YES, means that the clinician will be
	;;^DD(115.6,7,21,2,0)
	;;=prompted for the number of collaterals associated with each
	;;^DD(115.6,7,21,3,0)
	;;=patient when an encounter of this type is entered into the
	;;^DD(115.6,7,21,4,0)
	;;=Encounter file (115.7).
	;;^DD(115.6,7,"DT")
	;;=2891107
	;;^DD(115.6,8,0)
	;;=ASK FOR PATIENT COMMENT?^S^Y:YES;N:NO;^0;9^Q
	;;^DD(115.6,8,21,0)
	;;=^^4^4^2891121^
	;;^DD(115.6,8,21,1,0)
	;;=This field, if answered YES, means that the clinician will be
	;;^DD(115.6,8,21,2,0)
	;;=prompted for a comment to be associated with each patient
	;;^DD(115.6,8,21,3,0)
	;;=when an encounter of this type is entered into the
	;;^DD(115.6,8,21,4,0)
	;;=Encounter file (115.7).
	;;^DD(115.6,8,"DT")
	;;=2891107
	;;^DD(115.6,10,0)
	;;=CATEGORY^S^S:Screening;A:Assessment;E:Pat. Education;C:Community;N:Nutrition Inv.;F:Food Svc.;X:Administrative;^0;2^Q
	;;^DD(115.6,10,21,0)
	;;=^^1^1^2920107^^
	;;^DD(115.6,10,21,1,0)
	;;=The is the category of the Encounter Type.
	;;^DD(115.6,10,"DT")
	;;=2920107
	;;^DD(115.6,99,0)
	;;=INACTIVE?^S^Y:YES;N:NO;^I;1^Q
	;;^DD(115.6,99,1,0)
	;;=^.1
	;;^DD(115.6,99,1,1,0)
	;;=115.6^AC^MUMPS
	;;^DD(115.6,99,1,1,1)
	;;=K:X'="Y" ^FH(115.6,DA,"I")
