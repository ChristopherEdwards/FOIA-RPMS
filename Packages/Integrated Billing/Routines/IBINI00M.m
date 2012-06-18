IBINI00M	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(36)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(36,.119,21,1,0)
	;;=Enter the fax number of this insurance carrier.
	;;^DD(36,.119,"DT")
	;;=2931123
	;;^DD(36,.12,0)
	;;=FILING TIME FRAME^F^^0;12^K:$L(X)>30!($L(X)<3) X
	;;^DD(36,.12,3)
	;;=Enter maximum amount of time from date of service that the insurance company allows for submitting claims.  Answer must be 3-30 characters in length.
	;;^DD(36,.12,21,0)
	;;=^^4^4^2940204^^
	;;^DD(36,.12,21,1,0)
	;;=Enter the maximum amount of time from the date of service that the
	;;^DD(36,.12,21,2,0)
	;;=insurance company allows for submitting claims.  Examples:  60 days,
	;;^DD(36,.12,21,3,0)
	;;=90 days, 6 months, 1 year, 18 months;  March 30 following year of
	;;^DD(36,.12,21,4,0)
	;;=service, June 1 following year of service.
	;;^DD(36,.12,"DT")
	;;=2940201
	;;^DD(36,.121,0)
	;;=CLAIMS (INPT) STREET ADDRESS 1^F^^.12;1^K:$L(X)>30!($L(X)<3) X
	;;^DD(36,.121,1,0)
	;;=^.1
	;;^DD(36,.121,1,1,0)
	;;=^^TRIGGER^36^.122
	;;^DD(36,.121,1,1,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DIC(36,D0,.12)):^(.12),1:"") S X=$P(Y(1),U,2),X=X S DIU=X K Y S X="" X ^DD(36,.121,1,1,1.4)
	;;^DD(36,.121,1,1,1.4)
	;;=S DIH=$S($D(^DIC(36,DIV(0),.12)):^(.12),1:""),DIV=X S $P(^(.12),U,2)=DIV,DIH=36,DIG=.122 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(36,.121,1,1,2)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DIC(36,D0,.12)):^(.12),1:"") S X=$P(Y(1),U,2),X=X S DIU=X K Y S X="" X ^DD(36,.121,1,1,2.4)
	;;^DD(36,.121,1,1,2.4)
	;;=S DIH=$S($D(^DIC(36,DIV(0),.12)):^(.12),1:""),DIV=X S $P(^(.12),U,2)=DIV,DIH=36,DIG=.122 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(36,.121,1,1,"%D",0)
	;;=^^2^2^2930715^^^^
	;;^DD(36,.121,1,1,"%D",1,0)
	;;=When changing or deleting CLAIMS (INPT) STREET ADDRESS 1 delete
	;;^DD(36,.121,1,1,"%D",2,0)
	;;=CLAIMS (INPT) STREET ADDRESS 2.
	;;^DD(36,.121,1,1,"CREATE VALUE")
	;;=@
	;;^DD(36,.121,1,1,"DELETE VALUE")
	;;=@
	;;^DD(36,.121,1,1,"DT")
	;;=2930401
	;;^DD(36,.121,1,1,"FIELD")
	;;=CLAIMS STREET ADDRESS [LINE 2]
	;;^DD(36,.121,1,2,0)
	;;=^^TRIGGER^36^.123
	;;^DD(36,.121,1,2,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DIC(36,D0,.12)):^(.12),1:"") S X=$P(Y(1),U,3),X=X S DIU=X K Y S X="" X ^DD(36,.121,1,2,1.4)
	;;^DD(36,.121,1,2,1.4)
	;;=S DIH=$S($D(^DIC(36,DIV(0),.12)):^(.12),1:""),DIV=X S $P(^(.12),U,3)=DIV,DIH=36,DIG=.123 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(36,.121,1,2,2)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DIC(36,D0,.12)):^(.12),1:"") S X=$P(Y(1),U,3),X=X S DIU=X K Y S X="" X ^DD(36,.121,1,2,2.4)
	;;^DD(36,.121,1,2,2.4)
	;;=S DIH=$S($D(^DIC(36,DIV(0),.12)):^(.12),1:""),DIV=X S $P(^(.12),U,3)=DIV,DIH=36,DIG=.123 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(36,.121,1,2,"%D",0)
	;;=^^2^2^2930715^^^
	;;^DD(36,.121,1,2,"%D",1,0)
	;;=When changing or deleting CLAIMS (INPT) STREET ADDRESS 1 delete
	;;^DD(36,.121,1,2,"%D",2,0)
	;;=CLAIMS (INPT) STREET ADDRESS 3.
	;;^DD(36,.121,1,2,"CREATE VALUE")
	;;=@
	;;^DD(36,.121,1,2,"DELETE VALUE")
	;;=@
	;;^DD(36,.121,1,2,"DT")
	;;=2930401
	;;^DD(36,.121,1,2,"FIELD")
	;;=CLAIMS STREET ADDRESS [LINE 3]
	;;^DD(36,.121,3)
	;;=If the inpatient claims process address of this company is different from its main address, enter Line 1 of the inpatient claims street address.  Answer must be 3-30 characters in length.
	;;^DD(36,.121,21,0)
	;;=^^2^2^2930715^^^^
	;;^DD(36,.121,21,1,0)
	;;=Enter the first line of the street address for the inpatient 
	;;^DD(36,.121,21,2,0)
	;;=claims office of this insurance carrier.
	;;^DD(36,.121,"DT")
	;;=2930715
	;;^DD(36,.122,0)
	;;=CLAIMS (INPT) STREET ADDRESS 2^F^^.12;2^K:$L(X)>30!($L(X)<3) X
	;;^DD(36,.122,1,0)
	;;=^.1
