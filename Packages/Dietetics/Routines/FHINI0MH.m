FHINI0MH	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(119.4)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(119.4,0,"GL")
	;;=^FH(119.4,
	;;^DIC("B","ISOLATION/PRECAUTION TYPE",119.4)
	;;=
	;;^DIC(119.4,"%D",0)
	;;=^^5^5^2871124^
	;;^DIC(119.4,"%D",1,0)
	;;=This file contains the list of isolation/precaution types, as
	;;^DIC(119.4,"%D",2,0)
	;;=commonly identified by medical personnel, and indicates the
	;;^DIC(119.4,"%D",3,0)
	;;=characteristics of those types important to the Dietetic
	;;^DIC(119.4,"%D",4,0)
	;;=Service such as type of china and appropriate tray delivery
	;;^DIC(119.4,"%D",5,0)
	;;=person.
	;;^DD(119.4,0)
	;;=FIELD^^99^4
	;;^DD(119.4,0,"ID",99)
	;;=W:$D(^("I")) "   (** INACTIVE **)"
	;;^DD(119.4,0,"IX","AC",119.4,99)
	;;=
	;;^DD(119.4,0,"IX","B",119.4,.01)
	;;=
	;;^DD(119.4,0,"NM","ISOLATION/PRECAUTION TYPE")
	;;=
	;;^DD(119.4,0,"PT",115.01,9)
	;;=
	;;^DD(119.4,0,"SCR")
	;;=I '$D(^FH(119.4,+Y,"I"))!$D(^XUSEC("FHMGR",DUZ))!(DUZ(0)["@")
	;;^DD(119.4,.01,0)
	;;=NAME^RF^^0;1^K:$L(X)>30!($L(X)<3)!'(X'?1P.E)!(X'?.ANP) X
	;;^DD(119.4,.01,1,0)
	;;=^.1
	;;^DD(119.4,.01,1,1,0)
	;;=119.4^B
	;;^DD(119.4,.01,1,1,1)
	;;=S ^FH(119.4,"B",$E(X,1,30),DA)=""
	;;^DD(119.4,.01,1,1,2)
	;;=K ^FH(119.4,"B",$E(X,1,30),DA)
	;;^DD(119.4,.01,1,1,"%D",0)
	;;=^^1^1^2911118^
	;;^DD(119.4,.01,1,1,"%D",1,0)
	;;=This is the normal B cross-reference of the NAME field.
	;;^DD(119.4,.01,3)
	;;=ANSWER MUST BE 3-30 CHARACTERS IN LENGTH
	;;^DD(119.4,.01,21,0)
	;;=^^2^2^2880709^
	;;^DD(119.4,.01,21,1,0)
	;;=This field contains the name of isolation/precaution type
	;;^DD(119.4,.01,21,2,0)
	;;=as it would normally be known to ward/medical personnel.
	;;^DD(119.4,.01,"DEL",1,0)
	;;=I DUZ(0)'["@",'$D(^XUSEC("FHMGR",DUZ))
	;;^DD(119.4,1,0)
	;;=PAPER OR CHINA^RS^P:PAPER;C:CHINA;^0;2^Q
	;;^DD(119.4,1,21,0)
	;;=^^2^2^2880709^
	;;^DD(119.4,1,21,1,0)
	;;=This field indicates whether food is served on paper products
	;;^DD(119.4,1,21,2,0)
	;;=or china for this isolation type.
	;;^DD(119.4,2,0)
	;;=DELIVERED BY NURSE OR FSW^RS^N:NURSE;F:FSW;^0;3^Q
	;;^DD(119.4,2,21,0)
	;;=^^2^2^2880709^
	;;^DD(119.4,2,21,1,0)
	;;=This field indicates whether food tray delivery is done by
	;;^DD(119.4,2,21,2,0)
	;;=food service workers (FSW) or by ward personnel (NURSE).
	;;^DD(119.4,2,"DT")
	;;=2871110
	;;^DD(119.4,99,0)
	;;=INACTIVE?^S^Y:YES;N:NO;^I;1^Q
	;;^DD(119.4,99,1,0)
	;;=^.1
	;;^DD(119.4,99,1,1,0)
	;;=119.4^AC^MUMPS
	;;^DD(119.4,99,1,1,1)
	;;=K:X'="Y" ^FH(119.4,DA,"I")
	;;^DD(119.4,99,1,1,2)
	;;=K ^FH(119.4,DA,"I")
	;;^DD(119.4,99,1,1,"%D",0)
	;;=^^2^2^2940818^
	;;^DD(119.4,99,1,1,"%D",1,0)
	;;=This cross-reference is used to create an 'I' node for
	;;^DD(119.4,99,1,1,"%D",2,0)
	;;=inactive entries.
	;;^DD(119.4,99,21,0)
	;;=^^2^2^2880709^
	;;^DD(119.4,99,21,1,0)
	;;=This field, if answered YES, will inactivate an isolation
	;;^DD(119.4,99,21,2,0)
	;;=type and prohibit further selection by ward personnel.
	;;^DD(119.4,99,"DT")
	;;=2860813
