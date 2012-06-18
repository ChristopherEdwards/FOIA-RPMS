GMPLI007	; ; 25-AUG-1994
	;;2.0;Problem List;;Aug 25, 1994
	Q:'DIFQ(125.12)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(125.12,0,"GL")
	;;=^GMPL(125.12,
	;;^DIC("B","PROBLEM SELECTION CATEGORY CONTENTS",125.12)
	;;=
	;;^DIC(125.12,"%D",0)
	;;=^^5^5^2940526^^^^
	;;^DIC(125.12,"%D",1,0)
	;;=This file contains the problems that make up the categories defined in
	;;^DIC(125.12,"%D",2,0)
	;;=file #125.11; these are groups of commonly selected, similar problems.
	;;^DIC(125.12,"%D",3,0)
	;;=Each entry in this file links one problem to a single category, and
	;;^DIC(125.12,"%D",4,0)
	;;=may have a sequence number and ICD code assigned to it.  Problems may
	;;^DIC(125.12,"%D",5,0)
	;;=appear in more than one category.
	;;^DD(125.12,0)
	;;=FIELD^^4^5
	;;^DD(125.12,0,"DDA")
	;;=N
	;;^DD(125.12,0,"DT")
	;;=2931007
	;;^DD(125.12,0,"IX","B",125.12,.01)
	;;=
	;;^DD(125.12,0,"IX","C",125.12,.01)
	;;=
	;;^DD(125.12,0,"IX","C1",125.12,1)
	;;=
	;;^DD(125.12,0,"NM","PROBLEM SELECTION CATEGORY CONTENTS")
	;;=
	;;^DD(125.12,.01,0)
	;;=CATEGORY^RP125.11'^GMPL(125.11,^0;1^Q
	;;^DD(125.12,.01,1,0)
	;;=^.1
	;;^DD(125.12,.01,1,1,0)
	;;=125.12^B
	;;^DD(125.12,.01,1,1,1)
	;;=S ^GMPL(125.12,"B",$E(X,1,30),DA)=""
	;;^DD(125.12,.01,1,1,2)
	;;=K ^GMPL(125.12,"B",$E(X,1,30),DA)
	;;^DD(125.12,.01,1,2,0)
	;;=125.12^C^MUMPS
	;;^DD(125.12,.01,1,2,1)
	;;=S:$P(^GMPL(125.12,DA,0),U,2) ^GMPL(125.12,"C",X,$P(^(0),U,2),DA)=""
	;;^DD(125.12,.01,1,2,2)
	;;=K:$P(^GMPL(125.12,DA,0),U,2) ^GMPL(125.12,"C",X,$P(^(0),U,2),DA)
	;;^DD(125.12,.01,1,2,"%D",0)
	;;=^^1^1^2940125^^^
	;;^DD(125.12,.01,1,2,"%D",1,0)
	;;=Allows retrieval of problem categories in sequenced order.
	;;^DD(125.12,.01,1,2,"DT")
	;;=2931005
	;;^DD(125.12,.01,3)
	;;=Enter the problem category to which this problem belongs.
	;;^DD(125.12,.01,21,0)
	;;=^^1^1^2931129^^
	;;^DD(125.12,.01,21,1,0)
	;;=This is the problem category that this problem entry belongs to.
	;;^DD(125.12,.01,"DT")
	;;=2931129
	;;^DD(125.12,1,0)
	;;=SEQUENCE NUMBER^NJ6,2^^0;2^K:+X'=X!(X>999.99)!(X<.01)!(X?.E1"."3N.N) X
	;;^DD(125.12,1,1,0)
	;;=^.1
	;;^DD(125.12,1,1,1,0)
	;;=125.12^C1^MUMPS
	;;^DD(125.12,1,1,1,1)
	;;=S ^GMPL(125.12,"C",$P(^GMPL(125.12,DA,0),U),X,DA)=""
	;;^DD(125.12,1,1,1,2)
	;;=K ^GMPL(125.12,"C",$P(^GMPL(125.12,DA,0),U),X,DA)
	;;^DD(125.12,1,1,1,"%D",0)
	;;=^^1^1^2940125^^
	;;^DD(125.12,1,1,1,"%D",1,0)
	;;=Allows retrieval of problem categories in sequenced order.
	;;^DD(125.12,1,1,1,"DT")
	;;=2931005
	;;^DD(125.12,1,3)
	;;=Type a Number between .01 and 999.99, 2 Decimal Digits
	;;^DD(125.12,1,21,0)
	;;=^^4^4^2931005^
	;;^DD(125.12,1,21,1,0)
	;;=This is a number which determines the order this problem will appear
	;;^DD(125.12,1,21,2,0)
	;;=within this group; up to two decimal places may be used.  Problems
	;;^DD(125.12,1,21,3,0)
	;;=in a selection list will be automatically numbered for display and
	;;^DD(125.12,1,21,4,0)
	;;=selection in whole numbers, beginning with 1.
	;;^DD(125.12,1,"DT")
	;;=2931005
	;;^DD(125.12,2,0)
	;;=PROBLEM^P757.01'^GMP(757.01,^0;3^Q
	;;^DD(125.12,2,3)
	;;=Enter the problem you wish to include in this group.
	;;^DD(125.12,2,21,0)
	;;=^^2^2^2931005^
	;;^DD(125.12,2,21,1,0)
	;;=This is a problem from the Clinical Lexicon Utility, which is to be
	;;^DD(125.12,2,21,2,0)
	;;=included in this group.
	;;^DD(125.12,2,"DT")
	;;=2931005
	;;^DD(125.12,3,0)
	;;=DISPLAY TEXT^F^^0;4^K:$L(X)>80!($L(X)<2) X
	;;^DD(125.12,3,3)
	;;=Answer must be 2-80 characters in length.
	;;^DD(125.12,3,21,0)
	;;=^^4^4^2931005^
	;;^DD(125.12,3,21,1,0)
	;;=This is the text of the problem as it is to appear on the selection list
	;;^DD(125.12,3,21,2,0)
	;;=display; if a suitable match was not found during a search of the Clinical
