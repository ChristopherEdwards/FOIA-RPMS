FHINI001	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(111)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(111,0,"GL")
	;;=^FH(111,
	;;^DIC("B","DIETS",111)
	;;=
	;;^DIC(111,"%D",0)
	;;=^^5^5^2871124^
	;;^DIC(111,"%D",1,0)
	;;=This file contains a list of all of the diet modifications allowed
	;;^DIC(111,"%D",2,0)
	;;=by the using facility. Associated with each diet are characteristics
	;;^DIC(111,"%D",3,0)
	;;=such as alternate names, an abbreviated name, whether a clinician
	;;^DIC(111,"%D",4,0)
	;;=is to be bulletined when ordered, and a diet precedence which
	;;^DIC(111,"%D",5,0)
	;;=is used to prevent diet conflicts and as a printing sequence order.
	;;^DD(111,0)
	;;=FIELD^^99^9
	;;^DD(111,0,"ID",99)
	;;=W:$D(^("I")) "   (** INACTIVE **)"
	;;^DD(111,0,"IX","AC",111,99)
	;;=
	;;^DD(111,0,"IX","B",111,.01)
	;;=
	;;^DD(111,0,"IX","B",111.01,.01)
	;;=
	;;^DD(111,0,"IX","C",111,1)
	;;=
	;;^DD(111,0,"NM","DIETS")
	;;=
	;;^DD(111,0,"PT",111.1,1)
	;;=
	;;^DD(111,0,"PT",111.1,2)
	;;=
	;;^DD(111,0,"PT",111.1,3)
	;;=
	;;^DD(111,0,"PT",111.1,4)
	;;=
	;;^DD(111,0,"PT",111.1,5)
	;;=
	;;^DD(111,0,"PT",115.02,1)
	;;=
	;;^DD(111,0,"PT",115.02,2)
	;;=
	;;^DD(111,0,"PT",115.02,3)
	;;=
	;;^DD(111,0,"PT",115.02,4)
	;;=
	;;^DD(111,0,"PT",115.02,5)
	;;=
	;;^DD(111,0,"PT",119.6,15)
	;;=
	;;^DD(111,0,"SCR")
	;;=I '$D(^FH(111,+Y,"I"))!$D(^XUSEC("FHMGR",DUZ))!(DUZ(0)["@")
	;;^DD(111,.01,0)
	;;=NAME^RF^^0;1^K:$L(X)>30!($L(X)<3)!'(X'?1P.E)!(X'?.ANP) X
	;;^DD(111,.01,1,0)
	;;=^.1
	;;^DD(111,.01,1,1,0)
	;;=111^B
	;;^DD(111,.01,1,1,1)
	;;=S ^FH(111,"B",$E(X,1,30),DA)=""
	;;^DD(111,.01,1,1,2)
	;;=K ^FH(111,"B",$E(X,1,30),DA)
	;;^DD(111,.01,1,1,"%D",0)
	;;=^^1^1^2911118^
	;;^DD(111,.01,1,1,"%D",1,0)
	;;=This is the normal B cross-reference of the NAME field.
	;;^DD(111,.01,3)
	;;=ANSWER MUST BE 3-30 CHARACTERS IN LENGTH
	;;^DD(111,.01,21,0)
	;;=^^2^2^2940526^^
	;;^DD(111,.01,21,1,0)
	;;=This field contains the name of a diet or diet modification as
	;;^DD(111,.01,21,2,0)
	;;=it would normally be known to ward/medical personnel.
	;;^DD(111,.01,"DEL",1,0)
	;;=I DUZ(0)'["@",'$D(^XUSEC("FHMGR",DUZ))
	;;^DD(111,.01,"DT")
	;;=2880108
	;;^DD(111,1,0)
	;;=SYNONYM^F^^0;2^K:$L(X)>12!($L(X)<1) X
	;;^DD(111,1,1,0)
	;;=^.1
	;;^DD(111,1,1,1,0)
	;;=111^C
	;;^DD(111,1,1,1,1)
	;;=S ^FH(111,"C",$E(X,1,30),DA)=""
	;;^DD(111,1,1,1,2)
	;;=K ^FH(111,"C",$E(X,1,30),DA)
	;;^DD(111,1,3)
	;;=ANSWER MUST BE 1-12 CHARACTERS IN LENGTH
	;;^DD(111,1,21,0)
	;;=^^2^2^2891120^^^
	;;^DD(111,1,21,1,0)
	;;=This field may contain a synonym for the diet name; the synonym
	;;^DD(111,1,21,2,0)
	;;=is generally terminology known and used by ward/medical personnel.
	;;^DD(111,1,"DT")
	;;=2850202
	;;^DD(111,2,0)
	;;=ASK EXPIRATION DATE?^S^Y:YES;N:NO;^0;3^Q
	;;^DD(111,2,21,0)
	;;=^^4^4^2880709^
	;;^DD(111,2,21,1,0)
	;;=This field, when answered YES, will result in the user
	;;^DD(111,2,21,2,0)
	;;=being prompted for a diet expiration date (as well as the
	;;^DD(111,2,21,3,0)
	;;=start date) whenever this diet is contained in a total
	;;^DD(111,2,21,4,0)
	;;=diet order.
	;;^DD(111,2,"DT")
	;;=2850608
	;;^DD(111,3,0)
	;;=DIET PRECEDENCE^RNJ2,0^^0;4^K:+X'=X!(X>99)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(111,3,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 1 AND 99
	;;^DD(111,3,21,0)
	;;=^^6^6^2880709^
	;;^DD(111,3,21,1,0)
	;;=This is a numerical value which performs two functions:
	;;^DD(111,3,21,2,0)
	;;=no two diet modifications with the same precedence may be
	;;^DD(111,3,21,3,0)
	;;=selected. The same number can therefore be assigned to
	;;^DD(111,3,21,4,0)
	;;=mutually-exclusive diet modifications. Secondly, the diet
	;;^DD(111,3,21,5,0)
	;;=modifications will be listed in precedence order, from
	;;^DD(111,3,21,6,0)
	;;=low to high.
	;;^DD(111,3,"DT")
	;;=2850129
	;;^DD(111,4,0)
	;;=PRODUCTION DIET^R*P116.2'^FH(116.2,^0;5^S DIC("S")="I $P(^(0),""^"",4)'=""Y""" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(111,4,12)
	;;=Include only non-combo production diets.
	;;^DD(111,4,12.1)
	;;=S DIC("S")="I $P(^(0),""^"",4)'=""Y"""
	;;^DD(111,4,21,0)
	;;=^^3^3^2880709^
	;;^DD(111,4,21,1,0)
	;;=This field contains the Production Diet entry (file 116.2) which
	;;^DD(111,4,21,2,0)
	;;=would be prepared for this diet modification were it to stand
	;;^DD(111,4,21,3,0)
	;;=alone from other diet modifications.
	;;^DD(111,4,"DT")
	;;=2870713
	;;^DD(111,5,0)
	;;=BULLETIN CLINICIAN?^S^Y:YES;N:NO;^0;6^Q
	;;^DD(111,5,21,0)
	;;=^^3^3^2950717^^
	;;^DD(111,5,21,1,0)
	;;=This field, if answered YES, will result in a bulletin being
	;;^DD(111,5,21,2,0)
	;;=sent to the clinician responsible for the ward on which the
	;;^DD(111,5,21,3,0)
	;;=patient resides any time this diet modification is ordered.
	;;^DD(111,5,"DT")
	;;=2850608
	;;^DD(111,6,0)
	;;=ABBREVIATED LABEL^RF^^0;7^K:$L(X)>12!($L(X)<1) X
