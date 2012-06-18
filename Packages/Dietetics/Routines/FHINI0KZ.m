FHINI0KZ	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(115.4)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(115.4,0,"GL")
	;;=^FH(115.4,
	;;^DIC("B","NUTRITION STATUS",115.4)
	;;=
	;;^DIC(115.4,"%D",0)
	;;=^^2^2^2950919^^^^
	;;^DIC(115.4,"%D",1,0)
	;;=This file contains the four nutrition statuses of the established
	;;^DIC(115.4,"%D",2,0)
	;;=guidelines that are used in nutrition assessment and screening.
	;;^DD(115.4,0)
	;;=FIELD^^101^3
	;;^DD(115.4,0,"DDA")
	;;=N
	;;^DD(115.4,0,"DT")
	;;=2920106
	;;^DD(115.4,0,"ID","WRITE")
	;;=W "   ",$P(^(0),U,2)
	;;^DD(115.4,0,"IX","B",115.4,.01)
	;;=
	;;^DD(115.4,0,"IX","C",115.4,101)
	;;=
	;;^DD(115.4,0,"IX","D",115.4,1)
	;;=
	;;^DD(115.4,0,"NM","NUTRITION STATUS")
	;;=
	;;^DD(115.4,0,"PT",115.011,18)
	;;=
	;;^DD(115.4,0,"PT",115.012,1)
	;;=
	;;^DD(115.4,.01,0)
	;;=CATEGORY^RF^^0;1^K:$L(X)>3!($L(X)<1)!'(X'?1P.E) X
	;;^DD(115.4,.01,1,0)
	;;=^.1^^-1
	;;^DD(115.4,.01,1,1,0)
	;;=115.4^B
	;;^DD(115.4,.01,1,1,1)
	;;=S ^FH(115.4,"B",$E(X,1,30),DA)=""
	;;^DD(115.4,.01,1,1,2)
	;;=K ^FH(115.4,"B",$E(X,1,30),DA)
	;;^DD(115.4,.01,1,1,"%D",0)
	;;=^^1^1^2950405^^
	;;^DD(115.4,.01,1,1,"%D",1,0)
	;;=This is the normal B cross-reference of the CATEGORY field.
	;;^DD(115.4,.01,3)
	;;=Answer must be 1-3 characters in length.
	;;^DD(115.4,.01,21,0)
	;;=^^1^1^2900203^^
	;;^DD(115.4,.01,21,1,0)
	;;=This field contains a nutrition status or risk category.
	;;^DD(115.4,.01,"DEL",1,0)
	;;=I DUZ(0)'["@",'$D(^XUSEC("FHMGR",DUZ))
	;;^DD(115.4,.01,"DT")
	;;=2900203
	;;^DD(115.4,1,0)
	;;=STATUS TEXT (U/L CASE)^F^^0;2^K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>30!($L(X)<3) X
	;;^DD(115.4,1,1,0)
	;;=^.1
	;;^DD(115.4,1,1,1,0)
	;;=^^TRIGGER^115.4^101
	;;^DD(115.4,1,1,1,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^FH(115.4,D0,0)):^(0),1:"") S X=$P(Y(1),U,3),X=X S DIU=X K Y X ^DD(115.4,1,1,1,1.1) X ^DD(115.4,1,1,1,1.4)
	;;^DD(115.4,1,1,1,1.1)
	;;=S X=DIV S X=DIV X "F %=1:1:$L(X) S:$E(X,%)?1L X=$E(X,0,%-1)_$C($A(X,%)-32)_$E(X,%+1,999)" S X=X,Y(1)=X S X=1,Y(2)=X S X=30,X=$E(Y(1),Y(2),X)
	;;^DD(115.4,1,1,1,1.4)
	;;=S DIH=$S($D(^FH(115.4,DIV(0),0)):^(0),1:""),DIV=X S $P(^(0),U,3)=DIV,DIH=115.4,DIG=101 D ^DICR:$O(^DD(DIH,DIG,1,0))>0
	;;^DD(115.4,1,1,1,2)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^FH(115.4,D0,0)):^(0),1:"") S X=$P(Y(1),U,3),X=X S DIU=X K Y S X="" X ^DD(115.4,1,1,1,2.4)
	;;^DD(115.4,1,1,1,2.4)
	;;=S DIH=$S($D(^FH(115.4,DIV(0),0)):^(0),1:""),DIV=X S $P(^(0),U,3)=DIV,DIH=115.4,DIG=101 D ^DICR:$O(^DD(DIH,DIG,1,0))>0
	;;^DD(115.4,1,1,1,"CREATE VALUE")
	;;=$E(UPPERCASE(STATUS TEXT (U/L CASE)),1,30)
	;;^DD(115.4,1,1,1,"DELETE VALUE")
	;;=@
	;;^DD(115.4,1,1,1,"FIELD")
	;;=UPPER
	;;^DD(115.4,1,1,2,0)
	;;=115.4^D
	;;^DD(115.4,1,1,2,1)
	;;=S ^FH(115.4,"D",$E(X,1,30),DA)=""
	;;^DD(115.4,1,1,2,2)
	;;=K ^FH(115.4,"D",$E(X,1,30),DA)
	;;^DD(115.4,1,3)
	;;=Answer must be 3-30 characters in length.
	;;^DD(115.4,1,21,0)
	;;=^^2^2^2900403^^
	;;^DD(115.4,1,21,1,0)
	;;=This field contains the text name (upper/lower case) of a 
	;;^DD(115.4,1,21,2,0)
	;;=Nutrition Status or risk category.
	;;^DD(115.4,1,"DT")
	;;=2900403
	;;^DD(115.4,101,0)
	;;=UPPERCASE NAME^F^^0;3^K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>30!($L(X)<3) X
	;;^DD(115.4,101,1,0)
	;;=^.1
	;;^DD(115.4,101,1,1,0)
	;;=115.4^C
	;;^DD(115.4,101,1,1,1)
	;;=S ^FH(115.4,"C",$E(X,1,30),DA)=""
	;;^DD(115.4,101,1,1,2)
	;;=K ^FH(115.4,"C",$E(X,1,30),DA)
	;;^DD(115.4,101,3)
	;;=Answer must be 3-30 characters in length.
	;;^DD(115.4,101,5,1,0)
	;;=115.4^1^1
	;;^DD(115.4,101,9)
	;;=^
	;;^DD(115.4,101,21,0)
	;;=^^1^1^2950613^^^^
	;;^DD(115.4,101,21,1,0)
	;;=This is the name of the status in uppercase text.
	;;^DD(115.4,101,"DT")
	;;=2891112
