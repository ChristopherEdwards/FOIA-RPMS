FHINI0LA	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(116.2)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(116.2,0,"GL")
	;;=^FH(116.2,
	;;^DIC("B","PRODUCTION DIET",116.2)
	;;=
	;;^DIC(116.2,"%D",0)
	;;=^^3^3^2871124^
	;;^DIC(116.2,"%D",1,0)
	;;=This file contains a list of the production diets which are the
	;;^DIC(116.2,"%D",2,0)
	;;=basic diets actually prepared and from which the wide variety
	;;^DIC(116.2,"%D",3,0)
	;;=of clinical diet modifications are derived.
	;;^DD(116.2,0)
	;;=FIELD^^99^9
	;;^DD(116.2,0,"DT")
	;;=2950629
	;;^DD(116.2,0,"ID",99)
	;;=W:$D(^("I")) "   (** INACTIVE **)"
	;;^DD(116.2,0,"IX","AC",116.2,99)
	;;=
	;;^DD(116.2,0,"IX","AD",116.2,99)
	;;=
	;;^DD(116.2,0,"IX","AO",116.2,8)
	;;=
	;;^DD(116.2,0,"IX","AP",116.2,7)
	;;=
	;;^DD(116.2,0,"IX","AR",116.2,8)
	;;=
	;;^DD(116.2,0,"IX","AR1",116.211,.01)
	;;=
	;;^DD(116.2,0,"IX","B",116.2,.01)
	;;=
	;;^DD(116.2,0,"IX","C",116.2,1)
	;;=
	;;^DD(116.2,0,"NM","PRODUCTION DIET")
	;;=
	;;^DD(116.2,0,"PT",111,4)
	;;=
	;;^DD(116.2,0,"PT",111.1,10)
	;;=
	;;^DD(116.2,0,"PT",112.62,3)
	;;=
	;;^DD(116.2,0,"PT",115.02,12)
	;;=
	;;^DD(116.2,0,"PT",116.211,.01)
	;;=
	;;^DD(116.2,0,"PT",119.721,.01)
	;;=
	;;^DD(116.2,0,"PT",119.7211,.01)
	;;=
	;;^DD(116.2,0,"SCR")
	;;=I '$D(^FH(116.2,+Y,"I"))!$D(^XUSEC("FHMGR",DUZ))!(DUZ(0)["@")
	;;^DD(116.2,.01,0)
	;;=NAME^RF^^0;1^K:$L(X)>30!($L(X)<3)!'(X'?1P.E)!(X'?.ANP) X
	;;^DD(116.2,.01,1,0)
	;;=^.1
	;;^DD(116.2,.01,1,1,0)
	;;=116.2^B
	;;^DD(116.2,.01,1,1,1)
	;;=S ^FH(116.2,"B",$E(X,1,30),DA)=""
	;;^DD(116.2,.01,1,1,2)
	;;=K ^FH(116.2,"B",$E(X,1,30),DA)
	;;^DD(116.2,.01,1,1,"%D",0)
	;;=^^1^1^2911118^
	;;^DD(116.2,.01,1,1,"%D",1,0)
	;;=This is the normal B cross-reference of the NAME field.
	;;^DD(116.2,.01,3)
	;;=Answer must be 3-30 characters in length.
	;;^DD(116.2,.01,21,0)
	;;=^^3^3^2950629^^
	;;^DD(116.2,.01,21,1,0)
	;;=This field contains the name of a production diet. This is a
	;;^DD(116.2,.01,21,2,0)
	;;=diet that is prepared in the kitchen (as compared to a clinical
	;;^DD(116.2,.01,21,3,0)
	;;=diet modification which is ordered).
	;;^DD(116.2,.01,"DEL",1,0)
	;;=I DUZ(0)'["@",'$D(^XUSEC("FHMGR",DUZ))
	;;^DD(116.2,.01,"DT")
	;;=2950629
	;;^DD(116.2,1,0)
	;;=CODE^RF^^0;2^K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>2!($L(X)<2)!'(X?1U1UN) X I $D(X) S Y=$O(^FH(116.2,"C",X,0)) I Y>0,Y-DA W *7,"  Code used by ",$P(^FH(116.2,Y,0),"^",1) K X
	;;^DD(116.2,1,1,0)
	;;=^.1
	;;^DD(116.2,1,1,1,0)
	;;=116.2^C
	;;^DD(116.2,1,1,1,1)
	;;=S ^FH(116.2,"C",$E(X,1,30),DA)=""
	;;^DD(116.2,1,1,1,2)
	;;=K ^FH(116.2,"C",$E(X,1,30),DA)
	;;^DD(116.2,1,3)
	;;=ANSWER MUST BE 2 CHARACTERS (2 LETTERS OR LETTER-NUMBER) AND UNIQUE
	;;^DD(116.2,1,21,0)
	;;=^^2^2^2931116^^^^
	;;^DD(116.2,1,21,1,0)
	;;=This is a simple two-character code for the diet and is used
	;;^DD(116.2,1,21,2,0)
	;;=extensively in the production summary listings.
	;;^DD(116.2,1,"DT")
	;;=2851217
	;;^DD(116.2,3,0)
	;;=# DAYS TO REVIEW^NJ3,0^^0;8^K:+X'=X!(X>120)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(116.2,3,3)
	;;=Type a Number between 1 and 120, 0 Decimal Digits
	;;^DD(116.2,3,21,0)
	;;=^^2^2^2920106^^
	;;^DD(116.2,3,21,1,0)
	;;=This field represents the number of days after which a patient on
	;;^DD(116.2,3,21,2,0)
	;;=this Production Diet should be reviewed.
	;;^DD(116.2,3,"DT")
	;;=2920106
	;;^DD(116.2,7,0)
	;;=PRINT ORDER^RNJ2,0X^^0;6^K:+X'=X!(X>99)!(X<1)!(X?.E1"."1N.N) X I $D(X) S Y=$O(^FH(116.2,"AP",X,0)) I Y>0,Y-DA W *7,"  Order used by ",$P(^FH(116.2,Y,0),"^",1) K X
	;;^DD(116.2,7,1,0)
	;;=^.1
	;;^DD(116.2,7,1,1,0)
	;;=116.2^AP
	;;^DD(116.2,7,1,1,1)
	;;=S ^FH(116.2,"AP",$E(X,1,30),DA)=""
	;;^DD(116.2,7,1,1,2)
	;;=K ^FH(116.2,"AP",$E(X,1,30),DA)
	;;^DD(116.2,7,3)
	;;=Type a Number between 1 and 99, 0 Decimal Digits
	;;^DD(116.2,7,21,0)
	;;=^^2^2^2880717^
	;;^DD(116.2,7,21,1,0)
	;;=This is the order in which this production diet will appear in lists,
	;;^DD(116.2,7,21,2,0)
	;;=from low print orders to high.
	;;^DD(116.2,7,"DT")
	;;=2871115
	;;^DD(116.2,7.5,0)
	;;=PRINT ON DAILY MENU?^RS^Y:YES;N:NO;^0;7^Q
	;;^DD(116.2,7.5,21,0)
	;;=^^2^2^2891006^^
	;;^DD(116.2,7.5,21,1,0)
	;;=This field, when answered YES, will result in the Production Diet
	;;^DD(116.2,7.5,21,2,0)
	;;=being listed on the Daily Menu sheets.
	;;^DD(116.2,7.5,"DT")
	;;=2891006
	;;^DD(116.2,8,0)
	;;=TALLY ORDER^RNJ2,0X^^0;5^K:+X'=X!(X>99)!(X<1)!(X?.E1"."1N.N) X I $D(X) S Y=$O(^FH(116.2,"AO",X,0)) I Y>0,Y-DA W *7,"  Order used by ",$P(^FH(116.2,Y,0),"^",1) K X
	;;^DD(116.2,8,1,0)
	;;=^.1
	;;^DD(116.2,8,1,1,0)
	;;=116.2^AO
	;;^DD(116.2,8,1,1,1)
	;;=S ^FH(116.2,"AO",$E(X,1,30),DA)=""
	;;^DD(116.2,8,1,1,2)
	;;=K ^FH(116.2,"AO",$E(X,1,30),DA)
	;;^DD(116.2,8,1,2,0)
	;;=116.2^AR^MUMPS
	;;^DD(116.2,8,1,2,1)
	;;=D SET^FHORDR
