IBINI00W	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(36)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(36,.161,1,1,"%D",0)
	;;=^^2^2^2930715^^
	;;^DD(36,.161,1,1,"%D",1,0)
	;;=When changing or deleting CLAIMS (OPT) STREET ADDRESS 1 delete CLAIMS
	;;^DD(36,.161,1,1,"%D",2,0)
	;;=(OPT) STREET ADDRESS 2.
	;;^DD(36,.161,1,1,"CREATE VALUE")
	;;=@
	;;^DD(36,.161,1,1,"DELETE VALUE")
	;;=@
	;;^DD(36,.161,1,1,"FIELD")
	;;=#.162
	;;^DD(36,.161,1,2,0)
	;;=^^TRIGGER^36^.163
	;;^DD(36,.161,1,2,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DIC(36,D0,.16)):^(.16),1:"") S X=$P(Y(1),U,3),X=X S DIU=X K Y S X="" X ^DD(36,.161,1,2,1.4)
	;;^DD(36,.161,1,2,1.4)
	;;=S DIH=$S($D(^DIC(36,DIV(0),.16)):^(.16),1:""),DIV=X S $P(^(.16),U,3)=DIV,DIH=36,DIG=.163 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(36,.161,1,2,2)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DIC(36,D0,.16)):^(.16),1:"") S X=$P(Y(1),U,3),X=X S DIU=X K Y S X="" X ^DD(36,.161,1,2,2.4)
	;;^DD(36,.161,1,2,2.4)
	;;=S DIH=$S($D(^DIC(36,DIV(0),.16)):^(.16),1:""),DIV=X S $P(^(.16),U,3)=DIV,DIH=36,DIG=.163 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(36,.161,1,2,"%D",0)
	;;=^^2^2^2930715^^
	;;^DD(36,.161,1,2,"%D",1,0)
	;;=When changing or deleting CLAIMS (OPT) STREET ADDRESS 1 delete CLAIMS
	;;^DD(36,.161,1,2,"%D",2,0)
	;;=(OPT) STREET ADDRESS 3.
	;;^DD(36,.161,1,2,"CREATE VALUE")
	;;=@
	;;^DD(36,.161,1,2,"DELETE VALUE")
	;;=@
	;;^DD(36,.161,1,2,"DT")
	;;=2930715
	;;^DD(36,.161,1,2,"FIELD")
	;;=#.163
	;;^DD(36,.161,3)
	;;=If the outpatient claims process address of this company is different from its main address, enter Line 1 of the outpatient claims street address.  Answer must be 3-35 characters in length.
	;;^DD(36,.161,21,0)
	;;=^^2^2^2931007^^^
	;;^DD(36,.161,21,1,0)
	;;=Enter the first line of the street address for the outpatient claims
	;;^DD(36,.161,21,2,0)
	;;=office of this insurance carrier.
	;;^DD(36,.161,"DT")
	;;=2931007
	;;^DD(36,.162,0)
	;;=CLAIMS (OPT) STREET ADDRESS 2^F^^.16;2^K:$L(X)>35!($L(X)<3) X
	;;^DD(36,.162,1,0)
	;;=^.1
	;;^DD(36,.162,1,1,0)
	;;=^^TRIGGER^36^.163
	;;^DD(36,.162,1,1,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DIC(36,D0,.16)):^(.16),1:"") S X=$P(Y(1),U,3),X=X S DIU=X K Y S X="" X ^DD(36,.162,1,1,1.4)
	;;^DD(36,.162,1,1,1.4)
	;;=S DIH=$S($D(^DIC(36,DIV(0),.16)):^(.16),1:""),DIV=X S $P(^(.16),U,3)=DIV,DIH=36,DIG=.163 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(36,.162,1,1,2)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DIC(36,D0,.16)):^(.16),1:"") S X=$P(Y(1),U,3),X=X S DIU=X K Y S X="" X ^DD(36,.162,1,1,2.4)
	;;^DD(36,.162,1,1,2.4)
	;;=S DIH=$S($D(^DIC(36,DIV(0),.16)):^(.16),1:""),DIV=X S $P(^(.16),U,3)=DIV,DIH=36,DIG=.163 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(36,.162,1,1,"%D",0)
	;;=^^2^2^2930715^^
	;;^DD(36,.162,1,1,"%D",1,0)
	;;=When changing or deleting CLAIMS (OPT) STREET ADDRESS 2 delete CLAIMS (OPT) 
	;;^DD(36,.162,1,1,"%D",2,0)
	;;=STREET ADDRESS 3.
	;;^DD(36,.162,1,1,"CREATE VALUE")
	;;=@
	;;^DD(36,.162,1,1,"DELETE VALUE")
	;;=@
	;;^DD(36,.162,1,1,"FIELD")
	;;=#.163
	;;^DD(36,.162,3)
	;;=If the outpatient claims process address of this company is different from its main address, enter Line 2 of the outpatient claims street address.  Answer must be 3-35 characters in length.
	;;^DD(36,.162,5,1,0)
	;;=36^.161^1
	;;^DD(36,.162,21,0)
	;;=^^2^2^2930715^
	;;^DD(36,.162,21,1,0)
	;;=If this insurance company's outpatient claims office street address is
	;;^DD(36,.162,21,2,0)
	;;=longer than one line, enter the second line here.
	;;^DD(36,.162,"DT")
	;;=2930715
	;;^DD(36,.163,0)
	;;=CLAIMS (OPT) STREET ADDRESS 3^F^^.16;3^K:$L(X)>35!($L(X)<3) X
	;;^DD(36,.163,3)
	;;=If the outpatient claims process address of this company is different from its main address, enter Line 3 of the outpatient claims street address.  Answer must be 3-35 characters in length.
