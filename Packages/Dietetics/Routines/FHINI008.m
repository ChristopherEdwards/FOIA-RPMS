FHINI008	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(112)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(112,0,"GL")
	;;=^FHNU(
	;;^DIC("B","FOOD NUTRIENTS",112)
	;;=
	;;^DIC(112,"%D",0)
	;;=^^3^3^2871124^
	;;^DIC(112,"%D",1,0)
	;;=This file contains both standard USDA nutrient data based upon
	;;^DIC(112,"%D",2,0)
	;;=Handbook 456 and Revised Handbook 8 as well as user entered data.
	;;^DIC(112,"%D",3,0)
	;;=The standard data includes 32 common nutrients.
	;;^DD(112,0)
	;;=FIELD^^99^75
	;;^DD(112,0,"DT")
	;;=2930520
	;;^DD(112,0,"IX","AC",112,4)
	;;=
	;;^DD(112,0,"IX","AD",112,4.2)
	;;=
	;;^DD(112,0,"IX","AE",112,4.4)
	;;=
	;;^DD(112,0,"IX","AQ",112,.01)
	;;=
	;;^DD(112,0,"IX","B",112,.01)
	;;=
	;;^DD(112,0,"IX","B",112,4.2)
	;;=
	;;^DD(112,0,"IX","C",112,1)
	;;=
	;;^DD(112,0,"NM","FOOD NUTRIENTS")
	;;=
	;;^DD(112,0,"PT",112.63,.01)
	;;=
	;;^DD(112,0,"PT",113,27)
	;;=
	;;^DD(112,0,"PT",114,102)
	;;=
	;;^DD(112,0,"PT",114.01,2)
	;;=
	;;^DD(112,.01,0)
	;;=NAME^RF^^0;1^K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>60!($L(X)<3)!'(X'?1P.E)!(X'?.ANP) X
	;;^DD(112,.01,1,0)
	;;=^.1
	;;^DD(112,.01,1,1,0)
	;;=112^B
	;;^DD(112,.01,1,1,1)
	;;=S ^FHNU("B",$E(X,1,30),DA)=""
	;;^DD(112,.01,1,1,2)
	;;=K ^FHNU("B",$E(X,1,30),DA)
	;;^DD(112,.01,1,1,"%D",0)
	;;=^^1^1^2911118^
	;;^DD(112,.01,1,1,"%D",1,0)
	;;=This is the normal B cross-reference of the NAME field.
	;;^DD(112,.01,1,2,0)
	;;=112^AQ^MUMPS
	;;^DD(112,.01,1,2,1)
	;;=I $D(^FHNU(DA,.6)),$P(^(.6),"^",1)="Y" S ^FHNU("AQ",$E(X,1,30),DA)=""
	;;^DD(112,.01,1,2,2)
	;;=K ^FHNU("AQ",$E(X,1,30),DA)
	;;^DD(112,.01,1,2,"%D",0)
	;;=^^2^2^2940824^
	;;^DD(112,.01,1,2,"%D",1,0)
	;;=If Field 4 is Yes, then the name is set under an "AQ" quick-list for
	;;^DD(112,.01,1,2,"%D",2,0)
	;;=rapid selection.
	;;^DD(112,.01,3)
	;;=ANSWER MUST BE 3-60 CHARACTERS IN LENGTH
	;;^DD(112,.01,21,0)
	;;=^^1^1^2880717^
	;;^DD(112,.01,21,1,0)
	;;=This field contains the name of the food nutrient item.
	;;^DD(112,.01,"DEL",1,0)
	;;=I DUZ(0)'["@",'$D(^XUSEC("FHMGR",DUZ))
	;;^DD(112,.01,"DT")
	;;=2850406
	;;^DD(112,1,0)
	;;=CODE^F^^0;2^K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>6!($L(X)<1) X
	;;^DD(112,1,1,0)
	;;=^.1
	;;^DD(112,1,1,1,0)
	;;=112^C
	;;^DD(112,1,1,1,1)
	;;=S ^FHNU("C",$E(X,1,30),DA)=""
	;;^DD(112,1,1,1,2)
	;;=K ^FHNU("C",$E(X,1,30),DA)
	;;^DD(112,1,3)
	;;=ANSWER MUST BE 1-6 CHARACTERS IN LENGTH
	;;^DD(112,1,21,0)
	;;=^^3^3^2880717^
	;;^DD(112,1,21,1,0)
	;;=This field, if present, contains the USDA code of the food
	;;^DD(112,1,21,2,0)
	;;=nutrient item. It may be either a Revised Handbook 8 number
	;;^DD(112,1,21,3,0)
	;;=or a Handbook 456 number.
	;;^DD(112,2,0)
	;;=COMMON UNITS^F^^0;3^K:$L(X)>10!($L(X)<1) X
	;;^DD(112,2,3)
	;;=ANSWER MUST BE 1-10 CHARACTERS IN LENGTH
	;;^DD(112,2,21,0)
	;;=^^3^3^2880717^
	;;^DD(112,2,21,1,0)
	;;=This field represents the type of common units used (e.g., oz.,
	;;^DD(112,2,21,2,0)
	;;=serving, each) when quantities are to be represented in common
	;;^DD(112,2,21,3,0)
	;;=units.
	;;^DD(112,3,0)
	;;=GRAMS/COMMON UNIT^NJ8,3^^0;4^K:+X'=X!(X>9999)!(X<0)!(X?.E1"."4N.N) X
	;;^DD(112,3,3)
	;;=TYPE A NUMBER BETWEEN 0 AND 9999
	;;^DD(112,3,21,0)
	;;=^^2^2^2930510^^
	;;^DD(112,3,21,1,0)
	;;=This field contains the number of grams in the common unit
	;;^DD(112,3,21,2,0)
	;;=specified for this nutrient.
	;;^DD(112,4,0)
	;;=ORIGINAL NAME ON QUICK LIST?^S^Y:YES;N:NO;^.6;1^Q
	;;^DD(112,4,1,0)
	;;=^.1
	;;^DD(112,4,1,1,0)
	;;=112^AC^MUMPS
	;;^DD(112,4,1,1,1)
	;;=I X="Y" S X1=$P(^FHNU(DA,0),U,1) S:X1'="" ^FHNU("AQ",$E(X1,1,30),DA)=""
	;;^DD(112,4,1,1,2)
	;;=S X1=$P(^FHNU(DA,0),U,1) K:X1'="" ^FHNU("AQ",$E(X1,1,30),DA)
	;;^DD(112,4,1,1,"%D",0)
	;;=^^2^2^2940824^
	;;^DD(112,4,1,1,"%D",1,0)
	;;=If Field is Yes, then Name (.01 Field) is set under "AQ" Quick List
	;;^DD(112,4,1,1,"%D",2,0)
	;;=for rapid selection.
	;;^DD(112,4,21,0)
	;;=^^3^3^2880717^
	;;^DD(112,4,21,1,0)
	;;=This field, when answered YES, means that the main name
	;;^DD(112,4,21,2,0)
	;;=of this nutrient will be on a Quick List for rapid look-up.
	;;^DD(112,4,21,3,0)
	;;=In short, this is a commonly used item.
	;;^DD(112,4,"DT")
	;;=2850615
	;;^DD(112,4.2,0)
	;;=ALTERNATE NAME^F^^.6;2^K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>40!($L(X)<3) X
	;;^DD(112,4.2,1,0)
	;;=^.1
	;;^DD(112,4.2,1,1,0)
	;;=112^B^MNEMONIC
	;;^DD(112,4.2,1,1,1)
	;;=S:'$D(^FHNU("B",$E(X,1,30),DA)) ^(DA)=1
	;;^DD(112,4.2,1,1,2)
	;;=I $D(^FHNU("B",$E(X,1,30),DA)),^(DA) K ^(DA)
	;;^DD(112,4.2,1,1,"%D",0)
	;;=^^1^1^2911118^
	;;^DD(112,4.2,1,1,"%D",1,0)
	;;=This is the normal B cross-reference of the ALTERNATE NAME field.
	;;^DD(112,4.2,1,2,0)
	;;=112^AD^MUMPS
	;;^DD(112,4.2,1,2,1)
	;;=I $D(^FHNU(DA,.6)),$P(^(.6),U,3)="Y" S ^FHNU("AQ",$E(X,1,30),DA)=""
	;;^DD(112,4.2,1,2,2)
	;;=K ^FHNU("AQ",$E(X,1,30),DA)
