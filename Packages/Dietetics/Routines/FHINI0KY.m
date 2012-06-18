FHINI0KY	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(115.3)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(115.3,0,"GL")
	;;=^FH(115.3,
	;;^DIC("B","NUTRITION CLASSIFICATION",115.3)
	;;=
	;;^DIC(115.3,"%D",0)
	;;=^^2^2^2890709^^^^
	;;^DIC(115.3,"%D",1,0)
	;;=This file contains site-specific nutrition classifications used in
	;;^DIC(115.3,"%D",2,0)
	;;=nutrition assessment and screening.
	;;^DD(115.3,0)
	;;=FIELD^^101^3
	;;^DD(115.3,0,"DT")
	;;=2920501
	;;^DD(115.3,0,"ID",99)
	;;=W:$D(^("I")) "  (** INACTIVE **)"
	;;^DD(115.3,0,"IX","AC",115.3,99)
	;;=
	;;^DD(115.3,0,"IX","B",115.3,.01)
	;;=
	;;^DD(115.3,0,"IX","C",115.3,101)
	;;=
	;;^DD(115.3,0,"NM","NUTRITION CLASSIFICATION")
	;;=
	;;^DD(115.3,0,"PT",115.011,19)
	;;=
	;;^DD(115.3,0,"SCR")
	;;=I '$D(^FH(115.3,+Y,"I"))!$D(^XUSEC("FHMGR",DUZ))!(DUZ(0)["@")
	;;^DD(115.3,.01,0)
	;;=NAME^RF^^0;1^K:$L(X)>60!($L(X)<3)!'(X'?1P.E) X
	;;^DD(115.3,.01,1,0)
	;;=^.1
	;;^DD(115.3,.01,1,1,0)
	;;=115.3^B
	;;^DD(115.3,.01,1,1,1)
	;;=S ^FH(115.3,"B",$E(X,1,30),DA)=""
	;;^DD(115.3,.01,1,1,2)
	;;=K ^FH(115.3,"B",$E(X,1,30),DA)
	;;^DD(115.3,.01,1,1,"%D",0)
	;;=^^1^1^2911118^
	;;^DD(115.3,.01,1,1,"%D",1,0)
	;;=This is the normal B cross-reference of the NAME field.
	;;^DD(115.3,.01,1,2,0)
	;;=^^TRIGGER^115.3^101
	;;^DD(115.3,.01,1,2,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^FH(115.3,D0,0)):^(0),1:"") S X=$P(Y(1),U,2),X=X S DIU=X K Y X ^DD(115.3,.01,1,2,1.1) X ^DD(115.3,.01,1,2,1.4)
	;;^DD(115.3,.01,1,2,1.1)
	;;=S X=DIV S X=DIV X "F %=1:1:$L(X) S:$E(X,%)?1L X=$E(X,0,%-1)_$C($A(X,%)-32)_$E(X,%+1,999)" S X=X,Y(1)=X S X=1,Y(2)=X S X=30,X=$E(Y(1),Y(2),X)
	;;^DD(115.3,.01,1,2,1.4)
	;;=S DIH=$S($D(^FH(115.3,DIV(0),0)):^(0),1:""),DIV=X S $P(^(0),U,2)=DIV,DIH=115.3,DIG=101 D ^DICR:$O(^DD(DIH,DIG,1,0))>0
	;;^DD(115.3,.01,1,2,2)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^FH(115.3,D0,0)):^(0),1:"") S X=$P(Y(1),U,2),X=X S DIU=X K Y S X="" X ^DD(115.3,.01,1,2,2.4)
	;;^DD(115.3,.01,1,2,2.4)
	;;=S DIH=$S($D(^FH(115.3,DIV(0),0)):^(0),1:""),DIV=X S $P(^(0),U,2)=DIV,DIH=115.3,DIG=101 D ^DICR:$O(^DD(DIH,DIG,1,0))>0
	;;^DD(115.3,.01,1,2,"CREATE VALUE")
	;;=$E(UPPERCASE(NAME),1,30)
	;;^DD(115.3,.01,1,2,"DELETE VALUE")
	;;=@
	;;^DD(115.3,.01,1,2,"FIELD")
	;;=UPPERCASE NAME
	;;^DD(115.3,.01,3)
	;;=Answer must be 3-60 characters in length.
	;;^DD(115.3,.01,21,0)
	;;=^^1^1^2900713^^
	;;^DD(115.3,.01,21,1,0)
	;;=This field contains the name of a Dietetic Diagnosis.
	;;^DD(115.3,.01,"DEL",1,0)
	;;=I DUZ(0)'["@",'$D(^XUSEC("FHMGR",DUZ))
	;;^DD(115.3,.01,"DT")
	;;=2900713
	;;^DD(115.3,99,0)
	;;=INACTIVE?^S^Y:YES;N:NO;^I;1^Q
	;;^DD(115.3,99,1,0)
	;;=^.1
	;;^DD(115.3,99,1,1,0)
	;;=115.3^AC^MUMPS
	;;^DD(115.3,99,1,1,1)
	;;=K:X'="Y" ^FH(115.3,DA,"I")
	;;^DD(115.3,99,1,1,2)
	;;=K ^FH(115.3,DA,"I")
	;;^DD(115.3,99,1,1,"%D",0)
	;;=^^2^2^2940818^
	;;^DD(115.3,99,1,1,"%D",1,0)
	;;=This cross-reference is used to create an 'I' node for
	;;^DD(115.3,99,1,1,"%D",2,0)
	;;=inactive entries.
	;;^DD(115.3,99,1,1,"DT")
	;;=2920501
	;;^DD(115.3,99,21,0)
	;;=^^2^2^2920501^
	;;^DD(115.3,99,21,1,0)
	;;=This field, if answered YES, will prohibit further selection
	;;^DD(115.3,99,21,2,0)
	;;=of this classification unless the FHMGR key is held.
	;;^DD(115.3,99,"DT")
	;;=2920501
	;;^DD(115.3,101,0)
	;;=UPPERCASE NAME^F^^0;2^K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>30!($L(X)<3) X
	;;^DD(115.3,101,1,0)
	;;=^.1
	;;^DD(115.3,101,1,1,0)
	;;=115.3^C
	;;^DD(115.3,101,1,1,1)
	;;=S ^FH(115.3,"C",$E(X,1,30),DA)=""
	;;^DD(115.3,101,1,1,2)
	;;=K ^FH(115.3,"C",$E(X,1,30),DA)
	;;^DD(115.3,101,3)
	;;=Answer must be 3-30 characters in length.
	;;^DD(115.3,101,5,1,0)
	;;=115.3^.01^2
	;;^DD(115.3,101,9)
	;;=^
	;;^DD(115.3,101,21,0)
	;;=^^1^1^2950613^^^
	;;^DD(115.3,101,21,1,0)
	;;=This is the name of the entry in uppercase text.
	;;^DD(115.3,101,"DT")
	;;=2891112
