FHINI0M0	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(117.4)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(117.4,0,"GL")
	;;=^FH(117.4,
	;;^DIC("B","DIETETIC REPORT CATEGORIES",117.4)
	;;=
	;;^DIC(117.4,"%D",0)
	;;=^^3^3^2920623^^
	;;^DIC(117.4,"%D",1,0)
	;;=This file contains the categories, Specialized Medical Programs,
	;;^DIC(117.4,"%D",2,0)
	;;=Primary Delivery System, Primary Production System, and the
	;;^DIC(117.4,"%D",3,0)
	;;=Dietetic Service Equipment.
	;;^DD(117.4,0)
	;;=FIELD^^101^3
	;;^DD(117.4,0,"DDA")
	;;=N
	;;^DD(117.4,0,"DT")
	;;=2920130
	;;^DD(117.4,0,"IX","B",117.4,.01)
	;;=
	;;^DD(117.4,0,"IX","C",117.4,101)
	;;=
	;;^DD(117.4,0,"NM","DIETETIC REPORT CATEGORIES")
	;;=
	;;^DD(117.4,0,"PT",117.312,.01)
	;;=
	;;^DD(117.4,0,"PT",117.313,.01)
	;;=
	;;^DD(117.4,0,"PT",117.338,.01)
	;;=
	;;^DD(117.4,.01,0)
	;;=NAME^RF^^0;1^K:$L(X)>30!($L(X)<3)!'(X'?1P.E) X
	;;^DD(117.4,.01,1,0)
	;;=^.1
	;;^DD(117.4,.01,1,1,0)
	;;=117.4^B
	;;^DD(117.4,.01,1,1,1)
	;;=S ^FH(117.4,"B",$E(X,1,30),DA)=""
	;;^DD(117.4,.01,1,1,2)
	;;=K ^FH(117.4,"B",$E(X,1,30),DA)
	;;^DD(117.4,.01,1,2,0)
	;;=^^TRIGGER^117.4^101
	;;^DD(117.4,.01,1,2,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^FH(117.4,D0,0)):^(0),1:"") S X=$P(Y(1),U,3),X=X S DIU=X K Y X ^DD(117.4,.01,1,2,1.1) X ^DD(117.4,.01,1,2,1.4)
	;;^DD(117.4,.01,1,2,1.1)
	;;=S X=DIV S X=DIV X "F %=1:1:$L(X) S:$E(X,%)?1L X=$E(X,0,%-1)_$C($A(X,%)-32)_$E(X,%+1,999)" S X=X,Y(1)=X S X=1,Y(2)=X S X=30,X=$E(Y(1),Y(2),X)
	;;^DD(117.4,.01,1,2,1.4)
	;;=S DIH=$S($D(^FH(117.4,DIV(0),0)):^(0),1:""),DIV=X S $P(^(0),U,3)=DIV,DIH=117.4,DIG=101 D ^DICR:$O(^DD(DIH,DIG,1,0))>0
	;;^DD(117.4,.01,1,2,2)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^FH(117.4,D0,0)):^(0),1:"") S X=$P(Y(1),U,3),X=X S DIU=X K Y S X="" X ^DD(117.4,.01,1,2,2.4)
	;;^DD(117.4,.01,1,2,2.4)
	;;=S DIH=$S($D(^FH(117.4,DIV(0),0)):^(0),1:""),DIV=X S $P(^(0),U,3)=DIV,DIH=117.4,DIG=101 D ^DICR:$O(^DD(DIH,DIG,1,0))>0
	;;^DD(117.4,.01,1,2,"%D",0)
	;;=^^2^2^2911213^
	;;^DD(117.4,.01,1,2,"%D",1,0)
	;;=This trigger converts the upper/lower case name into all uppercase
	;;^DD(117.4,.01,1,2,"%D",2,0)
	;;=and stores it in field 101.
	;;^DD(117.4,.01,1,2,"CREATE VALUE")
	;;=$E(UPPERCASE(NAME),1,30)
	;;^DD(117.4,.01,1,2,"DELETE VALUE")
	;;=@
	;;^DD(117.4,.01,1,2,"DT")
	;;=2911213
	;;^DD(117.4,.01,1,2,"FIELD")
	;;=UPPER
	;;^DD(117.4,.01,3)
	;;=Answer must be 3-30 characters in length.
	;;^DD(117.4,.01,21,0)
	;;=^^2^2^2920130^
	;;^DD(117.4,.01,21,1,0)
	;;=This field contains the names of the categories used in the Annual
	;;^DD(117.4,.01,21,2,0)
	;;=Report.
	;;^DD(117.4,.01,"DT")
	;;=2911213
	;;^DD(117.4,1,0)
	;;=TYPE^RS^S:Specialized Medical Program;D:Primary Delivery System;P:Primary Production System;E:Dietetic Service Equipment;^0;2^Q
	;;^DD(117.4,1,21,0)
	;;=^^3^3^2920130^
	;;^DD(117.4,1,21,1,0)
	;;=This field contains the Type of Category. An "S" for Specialized
	;;^DD(117.4,1,21,2,0)
	;;=Medical Program, a "D" for Primary Delivery System, a "P" for
	;;^DD(117.4,1,21,3,0)
	;;=Primary Production System, and "E" for Dietetic Service Equipment.
	;;^DD(117.4,1,"DT")
	;;=2920130
	;;^DD(117.4,101,0)
	;;=UPPERCASE NAME^F^^0;3^K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>30!($L(X)<3) X
	;;^DD(117.4,101,1,0)
	;;=^.1
	;;^DD(117.4,101,1,1,0)
	;;=117.4^C
	;;^DD(117.4,101,1,1,1)
	;;=S ^FH(117.4,"C",$E(X,1,30),DA)=""
	;;^DD(117.4,101,1,1,2)
	;;=K ^FH(117.4,"C",$E(X,1,30),DA)
	;;^DD(117.4,101,1,1,"%D",0)
	;;=^^1^1^2911213^
	;;^DD(117.4,101,1,1,"%D",1,0)
	;;=This is a cross-reference of all uppercase text of the name.
	;;^DD(117.4,101,1,1,"DT")
	;;=2911213
	;;^DD(117.4,101,3)
	;;=Answer must be 3-30 characters in length.
	;;^DD(117.4,101,5,1,0)
	;;=117.4^.01^2
	;;^DD(117.4,101,21,0)
	;;=^^1^1^2920130^^^
	;;^DD(117.4,101,21,1,0)
	;;=This is the name of the entry in uppercase text.
	;;^DD(117.4,101,"DT")
	;;=2911213
