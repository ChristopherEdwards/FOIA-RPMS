GMPLI004	; ; 25-AUG-1994
	;;2.0;Problem List;;Aug 25, 1994
	Q:'DIFQ(125.1)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(125.1,0,"GL")
	;;=^GMPL(125.1,
	;;^DIC("B","PROBLEM SELECTION LIST CONTENTS",125.1)
	;;=
	;;^DIC(125.1,"%D",0)
	;;=^^3^3^2940526^^^^
	;;^DIC(125.1,"%D",1,0)
	;;=This file contains the categories that make up the Problem Selection
	;;^DIC(125.1,"%D",2,0)
	;;=Lists defined in file #125.  Each entry links a problem category to
	;;^DIC(125.1,"%D",3,0)
	;;=a list, optionally with a subheader and a sequence order.
	;;^DD(125.1,0)
	;;=FIELD^^4^5
	;;^DD(125.1,0,"DDA")
	;;=N
	;;^DD(125.1,0,"DT")
	;;=2931210
	;;^DD(125.1,0,"IX","B",125.1,.01)
	;;=
	;;^DD(125.1,0,"IX","C",125.1,.01)
	;;=
	;;^DD(125.1,0,"IX","C1",125.1,1)
	;;=
	;;^DD(125.1,0,"IX","G",125.1,2)
	;;=
	;;^DD(125.1,0,"NM","PROBLEM SELECTION LIST CONTENTS")
	;;=
	;;^DD(125.1,.01,0)
	;;=LIST^RP125'^GMPL(125,^0;1^Q
	;;^DD(125.1,.01,1,0)
	;;=^.1
	;;^DD(125.1,.01,1,1,0)
	;;=125.1^B
	;;^DD(125.1,.01,1,1,1)
	;;=S ^GMPL(125.1,"B",$E(X,1,30),DA)=""
	;;^DD(125.1,.01,1,1,2)
	;;=K ^GMPL(125.1,"B",$E(X,1,30),DA)
	;;^DD(125.1,.01,1,2,0)
	;;=125.1^C^MUMPS
	;;^DD(125.1,.01,1,2,1)
	;;=S:$P(^GMPL(125.1,DA,0),U,2) ^GMPL(125.1,"C",X,$P(^(0),U,2),DA)=""
	;;^DD(125.1,.01,1,2,2)
	;;=K:$P(^GMPL(125.1,DA,0),U,2) ^GMPL(125.1,"C",X,$P(^(0),U,2),DA)
	;;^DD(125.1,.01,1,2,"%D",0)
	;;=^^1^1^2940511^^^^
	;;^DD(125.1,.01,1,2,"%D",1,0)
	;;=Allows retrieval of list contents in sequenced order.
	;;^DD(125.1,.01,1,2,"DT")
	;;=2931015
	;;^DD(125.1,.01,3)
	;;=Enter the list for which you wish to add, edit, or remove problem groups.
	;;^DD(125.1,.01,21,0)
	;;=^^3^3^2931004^
	;;^DD(125.1,.01,21,1,0)
	;;=This is the Problem Selection List which is to contain the problem group
	;;^DD(125.1,.01,21,2,0)
	;;=entered in field #1; this group may be assigned a sequence number for
	;;^DD(125.1,.01,21,3,0)
	;;=ordering and a subheader as well here.
	;;^DD(125.1,.01,"DT")
	;;=2931015
	;;^DD(125.1,1,0)
	;;=SEQUENCE^NJ6,2^^0;2^K:+X'=X!(X>999.99)!(X<.01)!(X?.E1"."3N.N) X
	;;^DD(125.1,1,1,0)
	;;=^.1
	;;^DD(125.1,1,1,1,0)
	;;=125.1^C1^MUMPS
	;;^DD(125.1,1,1,1,1)
	;;=S ^GMPL(125.1,"C",$P(^GMPL(125.1,DA,0),U),X,DA)=""
	;;^DD(125.1,1,1,1,2)
	;;=K ^GMPL(125.1,"C",$P(^GMPL(125.1,DA,0),U),X,DA)
	;;^DD(125.1,1,1,1,"%D",0)
	;;=^^1^1^2940511^^^^
	;;^DD(125.1,1,1,1,"%D",1,0)
	;;=Allows retrieval of list contents in sequenced order.
	;;^DD(125.1,1,1,1,"DT")
	;;=2940511
	;;^DD(125.1,1,3)
	;;=Type a Number between .01 and 999.99, 2 Decimal Digits
	;;^DD(125.1,1,21,0)
	;;=^^2^2^2931006^^
	;;^DD(125.1,1,21,1,0)
	;;=This is a number which will determine the order this group will appear
	;;^DD(125.1,1,21,2,0)
	;;=in the current list; up to two decimal places may be used.
	;;^DD(125.1,1,"DT")
	;;=2940511
	;;^DD(125.1,2,0)
	;;=CATEGORY^P125.11^GMPL(125.11,^0;3^Q
	;;^DD(125.1,2,1,0)
	;;=^.1
	;;^DD(125.1,2,1,1,0)
	;;=125.1^G
	;;^DD(125.1,2,1,1,1)
	;;=S ^GMPL(125.1,"G",$E(X,1,30),DA)=""
	;;^DD(125.1,2,1,1,2)
	;;=K ^GMPL(125.1,"G",$E(X,1,30),DA)
	;;^DD(125.1,2,1,1,"DT")
	;;=2931015
	;;^DD(125.1,2,3)
	;;=Enter the problem category you wish to include in this list.
	;;^DD(125.1,2,21,0)
	;;=^^2^2^2931129^^^^
	;;^DD(125.1,2,21,1,0)
	;;=This is the category whose problem items are to be included in the current
	;;^DD(125.1,2,21,2,0)
	;;=list; it may have a subheader in this list, and a designated order.
	;;^DD(125.1,2,"DT")
	;;=2931129
	;;^DD(125.1,3,0)
	;;=SUBHEADER^F^^0;4^K:$L(X)>30!($L(X)<2) X
	;;^DD(125.1,3,3)
	;;=Answer must be 2-30 characters in length.
	;;^DD(125.1,3,21,0)
	;;=^^3^3^2931004^
	;;^DD(125.1,3,21,1,0)
	;;=This is text which will appear in the list as a subheader or title to
	;;^DD(125.1,3,21,2,0)
	;;=this group of problems.  It will have a single blank row between it and
