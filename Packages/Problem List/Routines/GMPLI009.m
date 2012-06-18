GMPLI009	; ; 25-AUG-1994
	;;2.0;Problem List;;Aug 25, 1994
	Q:'DIFQ(125.8)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(125.8,0,"GL")
	;;=^GMPL(125.8,
	;;^DIC("B","PROBLEM LIST AUDIT",125.8)
	;;=
	;;^DIC(125.8,"%D",0)
	;;=^^3^3^2940526^^^^
	;;^DIC(125.8,"%D",1,0)
	;;=This file holds an audit trail of all changes made to the Problem
	;;^DIC(125.8,"%D",2,0)
	;;=List entries including the old and new values, who made the change,
	;;^DIC(125.8,"%D",3,0)
	;;=and why.  Each entry here represents a single change to one problem.
	;;^DD(125.8,0)
	;;=FIELD^^10^9
	;;^DD(125.8,0,"DDA")
	;;=N
	;;^DD(125.8,0,"DT")
	;;=2930412
	;;^DD(125.8,0,"IX","AD",125.8,.01)
	;;=
	;;^DD(125.8,0,"IX","AD1",125.8,2)
	;;=
	;;^DD(125.8,0,"IX","B",125.8,.01)
	;;=
	;;^DD(125.8,0,"NM","PROBLEM LIST AUDIT")
	;;=
	;;^DD(125.8,.01,0)
	;;=PROBLEM^RP9000011'^AUPNPROB(^0;1^Q
	;;^DD(125.8,.01,1,0)
	;;=^.1
	;;^DD(125.8,.01,1,1,0)
	;;=125.8^B
	;;^DD(125.8,.01,1,1,1)
	;;=S ^GMPL(125.8,"B",$E(X,1,30),DA)=""
	;;^DD(125.8,.01,1,1,2)
	;;=K ^GMPL(125.8,"B",$E(X,1,30),DA)
	;;^DD(125.8,.01,1,2,0)
	;;=125.8^AD^MUMPS
	;;^DD(125.8,.01,1,2,1)
	;;=S:+$P(^GMPL(125.8,DA,0),U,3) ^GMPL(125.8,"AD",X,(9999999-$P(^(0),U,3)),DA)=""
	;;^DD(125.8,.01,1,2,2)
	;;=K ^GMPL(125.8,"AD",X,+(9999999-$P(^GMPL(125.8,DA,0),U,3)),DA)
	;;^DD(125.8,.01,1,2,"%D",0)
	;;=^^1^1^2930603^
	;;^DD(125.8,.01,1,2,"%D",1,0)
	;;=Used to retrieve a problem's audit trail in reverse-chronological order.
	;;^DD(125.8,.01,1,2,"DT")
	;;=2930603
	;;^DD(125.8,.01,3)
	;;=
	;;^DD(125.8,.01,21,0)
	;;=^^1^1^2940317^^
	;;^DD(125.8,.01,21,1,0)
	;;=This is the problem for which a change is being recorded.
	;;^DD(125.8,.01,"DT")
	;;=2930603
	;;^DD(125.8,1,0)
	;;=FIELD NUMBER^RNJ9,4^^0;2^K:+X'=X!(X>9999.9999)!(X<.01)!(X?.E1"."5N.N) X
	;;^DD(125.8,1,3)
	;;=Type a Number between .01 and 9999.9999, 4 Decimal Digits
	;;^DD(125.8,1,21,0)
	;;=^^1^1^2930908^
	;;^DD(125.8,1,21,1,0)
	;;=This is the number of the field for which a change is being recorded.
	;;^DD(125.8,1,"DT")
	;;=2921028
	;;^DD(125.8,2,0)
	;;=DATE/TIME MODIFIED^RD^^0;3^S %DT="ESTXR" D ^%DT S X=Y K:Y<1 X
	;;^DD(125.8,2,1,0)
	;;=^.1
	;;^DD(125.8,2,1,1,0)
	;;=125.8^AD1^MUMPS
	;;^DD(125.8,2,1,1,1)
	;;=S ^GMPL(125.8,"AD",$P(^GMPL(125.8,DA,0),U),(9999999-X),DA)=""
	;;^DD(125.8,2,1,1,2)
	;;=K ^GMPL(125.8,"AD",$P(^GMPL(125.8,DA,0),U),(9999999-X),DA)
	;;^DD(125.8,2,1,1,"%D",0)
	;;=^^1^1^2930603^
	;;^DD(125.8,2,1,1,"%D",1,0)
	;;=Used to retrieve a problem's audit trail in reverse-chronological order.
	;;^DD(125.8,2,1,1,"DT")
	;;=2930603
	;;^DD(125.8,2,21,0)
	;;=^^1^1^2930908^
	;;^DD(125.8,2,21,1,0)
	;;=This is the date and time that this data was changed.
	;;^DD(125.8,2,"DT")
	;;=2930603
	;;^DD(125.8,3,0)
	;;=WHO MODIFIED^P200'^VA(200,^0;4^Q
	;;^DD(125.8,3,21,0)
	;;=^^2^2^2930908^^^
	;;^DD(125.8,3,21,1,0)
	;;=This is the user who actually made the change to this data; the current
	;;^DD(125.8,3,21,2,0)
	;;=user's DUZ is stuffed in here.
	;;^DD(125.8,3,"DT")
	;;=2921028
	;;^DD(125.8,4,0)
	;;=OLD VALUE^F^^0;5^K:$L(X)>15!($L(X)<1) X
	;;^DD(125.8,4,3)
	;;=Answer must be 1-15 characters in length.
	;;^DD(125.8,4,21,0)
	;;=^^2^2^2930908^
	;;^DD(125.8,4,21,1,0)
	;;=This is the original value as stored in the Problem file global
	;;^DD(125.8,4,21,2,0)
	;;=(internal format).
	;;^DD(125.8,4,"DT")
	;;=2921028
	;;^DD(125.8,5,0)
	;;=NEW VALUE^F^^0;6^K:$L(X)>15!($L(X)<1) X
	;;^DD(125.8,5,3)
	;;=Answer must be 1-15 characters in length.
	;;^DD(125.8,5,21,0)
	;;=^^2^2^2930908^
	;;^DD(125.8,5,21,1,0)
	;;=This is the new value now stored in the Problem file global (internal
	;;^DD(125.8,5,21,2,0)
	;;=format).
	;;^DD(125.8,5,"DT")
	;;=2921028
	;;^DD(125.8,6,0)
	;;=REASON FOR CHANGE^F^^0;7^K:$L(X)>25!($L(X)<3) X
