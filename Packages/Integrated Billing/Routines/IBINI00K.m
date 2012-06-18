IBINI00K	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(36)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(36,.1,"DT")
	;;=2921028
	;;^DD(36,.11,0)
	;;=HOSPITAL PROVIDER NUMBER^F^^0;11^K:$L(X)>15!($L(X)<1) X
	;;^DD(36,.11,3)
	;;=Answer must be 1-15 characters in length.
	;;^DD(36,.11,21,0)
	;;=^^3^3^2931110^^^^
	;;^DD(36,.11,21,1,0)
	;;=An identifier assigned to the facility by the insurance company.
	;;^DD(36,.11,21,2,0)
	;;=Will be printed in form locator 51 of the UB-92 of bills for this
	;;^DD(36,.11,21,3,0)
	;;=insurance company.
	;;^DD(36,.11,23,0)
	;;=^^2^2^2931110^
	;;^DD(36,.11,23,1,0)
	;;=Printed in form locator 51 of the UB-92 if the insurance company is the
	;;^DD(36,.11,23,2,0)
	;;=primary insurance company.
	;;^DD(36,.11,"DT")
	;;=2930826
	;;^DD(36,.111,0)
	;;=STREET ADDRESS [LINE 1]^RFX^^.11;1^K:$L(X)>35!($L(X)<3) X
	;;^DD(36,.111,1,0)
	;;=^.1
	;;^DD(36,.111,1,1,0)
	;;=^^TRIGGER^36^.112
	;;^DD(36,.111,1,1,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DIC(36,D0,.11)):^(.11),1:"") S X=$P(Y(1),U,2),X=X S DIU=X K Y S X="" X ^DD(36,.111,1,1,1.4)
	;;^DD(36,.111,1,1,1.4)
	;;=S DIH=$S($D(^DIC(36,DIV(0),.11)):^(.11),1:""),DIV=X S $P(^(.11),U,2)=DIV,DIH=36,DIG=.112 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(36,.111,1,1,2)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DIC(36,D0,.11)):^(.11),1:"") S X=$P(Y(1),U,2),X=X S DIU=X K Y S X="" X ^DD(36,.111,1,1,2.4)
	;;^DD(36,.111,1,1,2.4)
	;;=S DIH=$S($D(^DIC(36,DIV(0),.11)):^(.11),1:""),DIV=X S $P(^(.11),U,2)=DIV,DIH=36,DIG=.112 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(36,.111,1,1,"%D",0)
	;;=^^2^2^2930402^
	;;^DD(36,.111,1,1,"%D",1,0)
	;;=When changing or deleting STREET ADDRESS [LINE 1] delete STREET 
	;;^DD(36,.111,1,1,"%D",2,0)
	;;=ADDRESS [LINE 2].
	;;^DD(36,.111,1,1,"CREATE VALUE")
	;;=@
	;;^DD(36,.111,1,1,"DELETE VALUE")
	;;=@
	;;^DD(36,.111,1,1,"DT")
	;;=2930401
	;;^DD(36,.111,1,1,"FIELD")
	;;=STREET ADDRESS [LINE 2]
	;;^DD(36,.111,1,2,0)
	;;=^^TRIGGER^36^.113
	;;^DD(36,.111,1,2,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DIC(36,D0,.11)):^(.11),1:"") S X=$P(Y(1),U,3),X=X S DIU=X K Y S X="" X ^DD(36,.111,1,2,1.4)
	;;^DD(36,.111,1,2,1.4)
	;;=S DIH=$S($D(^DIC(36,DIV(0),.11)):^(.11),1:""),DIV=X S $P(^(.11),U,3)=DIV,DIH=36,DIG=.113 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(36,.111,1,2,2)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DIC(36,D0,.11)):^(.11),1:"") S X=$P(Y(1),U,3),X=X S DIU=X K Y S X="" X ^DD(36,.111,1,2,2.4)
	;;^DD(36,.111,1,2,2.4)
	;;=S DIH=$S($D(^DIC(36,DIV(0),.11)):^(.11),1:""),DIV=X S $P(^(.11),U,3)=DIV,DIH=36,DIG=.113 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(36,.111,1,2,"%D",0)
	;;=^^2^2^2930402^
	;;^DD(36,.111,1,2,"%D",1,0)
	;;=When changing or deleting STREET ADDRESS [LINE 1] delete STREET
	;;^DD(36,.111,1,2,"%D",2,0)
	;;=ADDRESS [LINE 3].
	;;^DD(36,.111,1,2,"CREATE VALUE")
	;;=@
	;;^DD(36,.111,1,2,"DELETE VALUE")
	;;=@
	;;^DD(36,.111,1,2,"DT")
	;;=2930402
	;;^DD(36,.111,1,2,"FIELD")
	;;=STREET ADDRESS [LINE 3]
	;;^DD(36,.111,3)
	;;=Enter the first line of this company's street address with 3-35 characters.
	;;^DD(36,.111,21,0)
	;;=^^1^1^2930401^^^^
	;;^DD(36,.111,21,1,0)
	;;=Enter the first line of the mailing address for this insurance carrier.
	;;^DD(36,.111,"DEL",1,0)
	;;=I $D(DGINS)
	;;^DD(36,.111,"DT")
	;;=2930402
	;;^DD(36,.112,0)
	;;=STREET ADDRESS [LINE 2]^FX^^.11;2^K:$L(X)>30!($L(X)<3) X
	;;^DD(36,.112,1,0)
	;;=^.1
	;;^DD(36,.112,1,1,0)
	;;=^^TRIGGER^36^.113
	;;^DD(36,.112,1,1,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DIC(36,D0,.11)):^(.11),1:"") S X=$P(Y(1),U,3),X=X S DIU=X K Y S X="" X ^DD(36,.112,1,1,1.4)
	;;^DD(36,.112,1,1,1.4)
	;;=S DIH=$S($D(^DIC(36,DIV(0),.11)):^(.11),1:""),DIV=X S $P(^(.11),U,3)=DIV,DIH=36,DIG=.113 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
