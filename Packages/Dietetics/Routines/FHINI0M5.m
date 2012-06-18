FHINI0M5	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(118.1)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(118.1,0,"GL")
	;;=^FH(118.1,
	;;^DIC("B","SUPPLEMENTAL FEEDING MENU",118.1)
	;;=
	;;^DIC(118.1,"%D",0)
	;;=^^5^5^2871124^
	;;^DIC(118.1,"%D",1,0)
	;;=This file contains a pattern of supplemental feedings (up to four
	;;^DIC(118.1,"%D",2,0)
	;;=items for each of three time periods) which are often requested
	;;^DIC(118.1,"%D",3,0)
	;;=in common situations (e.g., a diabetic patient) and avoids the
	;;^DIC(118.1,"%D",4,0)
	;;=necessity of individually selecting the various items when
	;;^DIC(118.1,"%D",5,0)
	;;=ordering supplemental feedings.
	;;^DD(118.1,0)
	;;=FIELD^^99^28
	;;^DD(118.1,0,"ID",99)
	;;=W:$D(^("I")) "   (** INACTIVE **)"
	;;^DD(118.1,0,"IX","AC",118.1,99)
	;;=
	;;^DD(118.1,0,"IX","B",118.1,.01)
	;;=
	;;^DD(118.1,0,"IX","C",118.1,1)
	;;=
	;;^DD(118.1,0,"NM","SUPPLEMENTAL FEEDING MENU")
	;;=
	;;^DD(118.1,0,"PT",111.1,18)
	;;=
	;;^DD(118.1,0,"PT",115.07,3)
	;;=
	;;^DD(118.1,0,"SCR")
	;;=I '$D(^FH(118.1,+Y,"I"))!$D(^XUSEC("FHMGR",DUZ))!(DUZ(0)["@")
	;;^DD(118.1,.01,0)
	;;=NAME^RF^^0;1^K:$L(X)>27!($L(X)<3)!'(X'?1P.E)!(X'?.ANP) X
	;;^DD(118.1,.01,1,0)
	;;=^.1
	;;^DD(118.1,.01,1,1,0)
	;;=118.1^B
	;;^DD(118.1,.01,1,1,1)
	;;=S ^FH(118.1,"B",$E(X,1,30),DA)=""
	;;^DD(118.1,.01,1,1,2)
	;;=K ^FH(118.1,"B",$E(X,1,30),DA)
	;;^DD(118.1,.01,1,1,"%D",0)
	;;=^^1^1^2911118^
	;;^DD(118.1,.01,1,1,"%D",1,0)
	;;=This is the normal B cross-reference of the NAME field.
	;;^DD(118.1,.01,3)
	;;=ANSWER MUST BE 3-27 CHARACTERS IN LENGTH
	;;^DD(118.1,.01,21,0)
	;;=^^2^2^2880710^
	;;^DD(118.1,.01,21,1,0)
	;;=This is the name of the supplemental feeding menu, a pre-set
	;;^DD(118.1,.01,21,2,0)
	;;=collection of feeding items for the three feeding times.
	;;^DD(118.1,.01,"DEL",1,0)
	;;=I DUZ(0)'["@",'$D(^XUSEC("FHMGR",DUZ))
	;;^DD(118.1,.01,"DT")
	;;=2850207
	;;^DD(118.1,1,0)
	;;=SYNONYM^F^^0;2^K:$L(X)>10!($L(X)<3) X
	;;^DD(118.1,1,1,0)
	;;=^.1
	;;^DD(118.1,1,1,1,0)
	;;=118.1^C
	;;^DD(118.1,1,1,1,1)
	;;=S ^FH(118.1,"C",$E(X,1,30),DA)=""
	;;^DD(118.1,1,1,1,2)
	;;=K ^FH(118.1,"C",$E(X,1,30),DA)
	;;^DD(118.1,1,3)
	;;=ANSWER MUST BE 3-10 CHARACTERS IN LENGTH
	;;^DD(118.1,1,21,0)
	;;=^^1^1^2880710^
	;;^DD(118.1,1,21,1,0)
	;;=This field may contain a synonym for the feeding menu.
	;;^DD(118.1,1,"DT")
	;;=2850316
	;;^DD(118.1,3,0)
	;;=DIETARY OR THERAPEUTIC^RS^D:DIETARY;T:THERAPEUTIC;^1;25^Q
	;;^DD(118.1,3,21,0)
	;;=^^2^2^2880710^
	;;^DD(118.1,3,21,1,0)
	;;=This field indicates whether the menu is generally ordered
	;;^DD(118.1,3,21,2,0)
	;;=for dietary or therapeutic reasons.
	;;^DD(118.1,3,"DT")
	;;=2851003
	;;^DD(118.1,10,0)
	;;=10AM FEEDING #1^*P118'^FH(118,^1;1^S DIC("S")="I $P(^(0),U,3)'=""Y""" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(118.1,10,12)
	;;=Cannot select bulk nourishments
	;;^DD(118.1,10,12.1)
	;;=S DIC("S")="I $P(^(0),U,3)'=""Y"""
	;;^DD(118.1,10,21,0)
	;;=^^1^1^2880710^^
	;;^DD(118.1,10,21,1,0)
	;;=This is the first supplemental feeding item for the 10am feeding.
	;;^DD(118.1,10,"DT")
	;;=2850604
	;;^DD(118.1,10.5,0)
	;;=10AM #1 QTY^NJ2,0^^1;2^K:+X'=X!(X>20)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(118.1,10.5,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 1 AND 20
	;;^DD(118.1,10.5,21,0)
	;;=^^1^1^2880710^^
	;;^DD(118.1,10.5,21,1,0)
	;;=This is the quantity of the first 10am feeding item.
	;;^DD(118.1,11,0)
	;;=10AM FEEDING #2^*P118'^FH(118,^1;3^S DIC("S")="I $P(^(0),U,3)'=""Y""" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(118.1,11,12)
	;;=Cannot select bulk nourishments
	;;^DD(118.1,11,12.1)
	;;=S DIC("S")="I $P(^(0),U,3)'=""Y"""
	;;^DD(118.1,11,21,0)
	;;=^^1^1^2880710^^
	;;^DD(118.1,11,21,1,0)
	;;=This is the second supplemental feeding item for the 10am feeding.
	;;^DD(118.1,11,"DT")
	;;=2850604
	;;^DD(118.1,11.5,0)
	;;=10AM #2 QTY^NJ2,0^^1;4^K:+X'=X!(X>20)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(118.1,11.5,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 1 AND 20
	;;^DD(118.1,11.5,21,0)
	;;=^^1^1^2880710^^
	;;^DD(118.1,11.5,21,1,0)
	;;=This is the quantity of the second 10am feeding item.
	;;^DD(118.1,12,0)
	;;=10AM FEEDING #3^*P118'^FH(118,^1;5^S DIC("S")="I $P(^(0),U,3)'=""Y""" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(118.1,12,12)
	;;=Cannot select bulk nourishments
	;;^DD(118.1,12,12.1)
	;;=S DIC("S")="I $P(^(0),U,3)'=""Y"""
	;;^DD(118.1,12,21,0)
	;;=^^1^1^2880710^^^
	;;^DD(118.1,12,21,1,0)
	;;=This is the third supplemental feeding item for the 10am feeding.
	;;^DD(118.1,12.5,0)
	;;=10AM #3 QTY^NJ2,0^^1;6^K:+X'=X!(X>20)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(118.1,12.5,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 1 AND 20
	;;^DD(118.1,12.5,21,0)
	;;=^^1^1^2880710^^^
	;;^DD(118.1,12.5,21,1,0)
	;;=This is the quantity of the third 10am feeding item.
	;;^DD(118.1,13,0)
	;;=10AM FEEDING #4^*P118'^FH(118,^1;7^S DIC("S")="I $P(^(0),U,3)'=""Y""" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
