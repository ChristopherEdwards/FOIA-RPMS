FHINI0L1	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(115.5)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(115.5,0,"GL")
	;;=^FH(115.5,
	;;^DIC("B","DIETETIC NUTRITION PLAN",115.5)
	;;=
	;;^DIC(115.5,"%D",0)
	;;=^^2^2^2890709^
	;;^DIC(115.5,"%D",1,0)
	;;=This file contains a list of nutrition plan actions which are
	;;^DIC(115.5,"%D",2,0)
	;;=listed on the Nutrition Screening form.
	;;^DD(115.5,0)
	;;=FIELD^^101^2
	;;^DD(115.5,0,"IX","B",115.5,.01)
	;;=
	;;^DD(115.5,0,"IX","C",115.5,101)
	;;=
	;;^DD(115.5,0,"NM","DIETETIC NUTRITION PLAN")
	;;=
	;;^DD(115.5,.01,0)
	;;=NAME^RF^^0;1^K:$L(X)>60!($L(X)<3)!'(X'?1P.E) X
	;;^DD(115.5,.01,1,0)
	;;=^.1
	;;^DD(115.5,.01,1,1,0)
	;;=115.5^B
	;;^DD(115.5,.01,1,1,1)
	;;=S ^FH(115.5,"B",$E(X,1,30),DA)=""
	;;^DD(115.5,.01,1,1,2)
	;;=K ^FH(115.5,"B",$E(X,1,30),DA)
	;;^DD(115.5,.01,1,1,"%D",0)
	;;=^^1^1^2911118^
	;;^DD(115.5,.01,1,1,"%D",1,0)
	;;=This is the normal B cross-reference of the NAME field.
	;;^DD(115.5,.01,1,2,0)
	;;=^^TRIGGER^115.5^101
	;;^DD(115.5,.01,1,2,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^FH(115.5,D0,0)):^(0),1:"") S X=$P(Y(1),U,2),X=X S DIU=X K Y X ^DD(115.5,.01,1,2,1.1) X ^DD(115.5,.01,1,2,1.4)
	;;^DD(115.5,.01,1,2,1.1)
	;;=S X=DIV S X=DIV X "F %=1:1:$L(X) S:$E(X,%)?1L X=$E(X,0,%-1)_$C($A(X,%)-32)_$E(X,%+1,999)" S X=X,Y(1)=X S X=1,Y(2)=X S X=30,X=$E(Y(1),Y(2),X)
	;;^DD(115.5,.01,1,2,1.4)
	;;=S DIH=$S($D(^FH(115.5,DIV(0),0)):^(0),1:""),DIV=X S $P(^(0),U,2)=DIV,DIH=115.5,DIG=101 D ^DICR:$O(^DD(DIH,DIG,1,0))>0
	;;^DD(115.5,.01,1,2,2)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^FH(115.5,D0,0)):^(0),1:"") S X=$P(Y(1),U,2),X=X S DIU=X K Y S X="" X ^DD(115.5,.01,1,2,2.4)
	;;^DD(115.5,.01,1,2,2.4)
	;;=S DIH=$S($D(^FH(115.5,DIV(0),0)):^(0),1:""),DIV=X S $P(^(0),U,2)=DIV,DIH=115.5,DIG=101 D ^DICR:$O(^DD(DIH,DIG,1,0))>0
	;;^DD(115.5,.01,1,2,"CREATE VALUE")
	;;=$E(UPPERCASE(NAME),1,30)
	;;^DD(115.5,.01,1,2,"DELETE VALUE")
	;;=@
	;;^DD(115.5,.01,1,2,"FIELD")
	;;=UPPERCASE NAME
	;;^DD(115.5,.01,3)
	;;=Answer must be 3-60 characters in length.
	;;^DD(115.5,.01,21,0)
	;;=^^1^1^2950717^^^
	;;^DD(115.5,.01,21,1,0)
	;;=This is the text name of the nutrition plan entry.
	;;^DD(115.5,.01,"DEL",1,0)
	;;=I DUZ(0)'["@",'$D(^XUSEC("FHMGR",DUZ))
	;;^DD(115.5,.01,"DT")
	;;=2891208
	;;^DD(115.5,101,0)
	;;=UPPERCASE NAME^F^^0;2^K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>30!($L(X)<3) X
	;;^DD(115.5,101,1,0)
	;;=^.1
	;;^DD(115.5,101,1,1,0)
	;;=115.5^C
	;;^DD(115.5,101,1,1,1)
	;;=S ^FH(115.5,"C",$E(X,1,30),DA)=""
	;;^DD(115.5,101,1,1,2)
	;;=K ^FH(115.5,"C",$E(X,1,30),DA)
	;;^DD(115.5,101,3)
	;;=Answer must be 3-30 characters in length.
	;;^DD(115.5,101,5,1,0)
	;;=115.5^.01^2
	;;^DD(115.5,101,9)
	;;=^
	;;^DD(115.5,101,21,0)
	;;=^^1^1^2950613^^^
	;;^DD(115.5,101,21,1,0)
	;;=This is the text of the plan entry in uppercase text.
	;;^DD(115.5,101,"DT")
	;;=2891112
