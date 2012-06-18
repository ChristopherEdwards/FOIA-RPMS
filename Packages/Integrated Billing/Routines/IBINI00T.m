IBINI00T	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(36)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(36,.149,21,1,0)
	;;=Enter the fax number of the appeals office of this insurance carrier.
	;;^DD(36,.149,"DT")
	;;=2931122
	;;^DD(36,.15,0)
	;;=PRESCRIPTION REFILL REV. CODE^*P399.2'^DGCR(399.2,^0;15^S DIC("S")="I $P(^(0),U,3)" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(36,.15,3)
	;;=Enter revenue code to be used for Rx refills.
	;;^DD(36,.15,12)
	;;=This is the Revenue Code that will automatically be generated for this insurance company if a prescription refill is listed on this bill.
	;;^DD(36,.15,12.1)
	;;=S DIC("S")="I $P(^(0),U,3)"
	;;^DD(36,.15,21,0)
	;;=^^1^1^2940110^^
	;;^DD(36,.15,21,1,0)
	;;=This is the Revenue Code that will automatically be generated for this insurance company if a prescription refill is listed on this bill.
	;;^DD(36,.15,"DT")
	;;=2940110
	;;^DD(36,.151,0)
	;;=INQUIRY ADDRESS ST. [LINE 1]^F^^.15;1^K:$L(X)>30!($L(X)<3) X
	;;^DD(36,.151,1,0)
	;;=^.1
	;;^DD(36,.151,1,1,0)
	;;=^^TRIGGER^36^.152
	;;^DD(36,.151,1,1,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DIC(36,D0,.15)):^(.15),1:"") S X=$P(Y(1),U,2),X=X S DIU=X K Y S X="" X ^DD(36,.151,1,1,1.4)
	;;^DD(36,.151,1,1,1.4)
	;;=S DIH=$S($D(^DIC(36,DIV(0),.15)):^(.15),1:""),DIV=X S $P(^(.15),U,2)=DIV,DIH=36,DIG=.152 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(36,.151,1,1,2)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DIC(36,D0,.15)):^(.15),1:"") S X=$P(Y(1),U,2),X=X S DIU=X K Y S X="" X ^DD(36,.151,1,1,2.4)
	;;^DD(36,.151,1,1,2.4)
	;;=S DIH=$S($D(^DIC(36,DIV(0),.15)):^(.15),1:""),DIV=X S $P(^(.15),U,2)=DIV,DIH=36,DIG=.152 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(36,.151,1,1,"%D",0)
	;;=^^2^2^2930402^
	;;^DD(36,.151,1,1,"%D",1,0)
	;;=When changing or deleting INQUIRY ADDRESS ST. [LINE 1]
	;;^DD(36,.151,1,1,"%D",2,0)
	;;=delete INQUIRY ADDRESS ST. [LINE 2].
	;;^DD(36,.151,1,1,"CREATE VALUE")
	;;=@
	;;^DD(36,.151,1,1,"DELETE VALUE")
	;;=@
	;;^DD(36,.151,1,1,"DT")
	;;=2930401
	;;^DD(36,.151,1,1,"FIELD")
	;;=INQUIRY ADDRESS ST. [LINE 2]
	;;^DD(36,.151,1,2,0)
	;;=^^TRIGGER^36^.153
	;;^DD(36,.151,1,2,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DIC(36,D0,.15)):^(.15),1:"") S X=$P(Y(1),U,3),X=X S DIU=X K Y S X="" X ^DD(36,.151,1,2,1.4)
	;;^DD(36,.151,1,2,1.4)
	;;=S DIH=$S($D(^DIC(36,DIV(0),.15)):^(.15),1:""),DIV=X S $P(^(.15),U,3)=DIV,DIH=36,DIG=.153 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(36,.151,1,2,2)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DIC(36,D0,.15)):^(.15),1:"") S X=$P(Y(1),U,3),X=X S DIU=X K Y S X="" X ^DD(36,.151,1,2,2.4)
	;;^DD(36,.151,1,2,2.4)
	;;=S DIH=$S($D(^DIC(36,DIV(0),.15)):^(.15),1:""),DIV=X S $P(^(.15),U,3)=DIV,DIH=36,DIG=.153 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(36,.151,1,2,"%D",0)
	;;=^^2^2^2930402^
	;;^DD(36,.151,1,2,"%D",1,0)
	;;=When changing or deleting INQUIRY ADDRESS ST. [LINE 1] delete
	;;^DD(36,.151,1,2,"%D",2,0)
	;;=INQUIRY ADDRESS ST. [LINE 3].
	;;^DD(36,.151,1,2,"CREATE VALUE")
	;;=@
	;;^DD(36,.151,1,2,"DELETE VALUE")
	;;=@
	;;^DD(36,.151,1,2,"DT")
	;;=2930401
	;;^DD(36,.151,1,2,"FIELD")
	;;=INQUIRY ADDRESS ST. [LINE 3]
	;;^DD(36,.151,3)
	;;=If the inquiry address of this company is different from its main address, enter Line 1 of the inquiry street address.  Answer must be 3-30 characters in length.
	;;^DD(36,.151,21,0)
	;;=^^2^2^2930607^
	;;^DD(36,.151,21,1,0)
	;;=Enter the first line of the street address of the inquiry office of
	;;^DD(36,.151,21,2,0)
	;;=this insurance carrier.
	;;^DD(36,.151,"DT")
	;;=2930401
	;;^DD(36,.152,0)
	;;=INQUIRY ADDRESS ST. [LINE 2]^F^^.15;2^K:$L(X)>30!($L(X)<3) X
	;;^DD(36,.152,1,0)
	;;=^.1
	;;^DD(36,.152,1,1,0)
	;;=^^TRIGGER^36^.153
