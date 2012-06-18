IBINI00R	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(36)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(36,.141,1,2,1.4)
	;;=S DIH=$S($D(^DIC(36,DIV(0),.14)):^(.14),1:""),DIV=X S $P(^(.14),U,3)=DIV,DIH=36,DIG=.143 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(36,.141,1,2,2)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DIC(36,D0,.14)):^(.14),1:"") S X=$P(Y(1),U,3),X=X S DIU=X K Y S X="" X ^DD(36,.141,1,2,2.4)
	;;^DD(36,.141,1,2,2.4)
	;;=S DIH=$S($D(^DIC(36,DIV(0),.14)):^(.14),1:""),DIV=X S $P(^(.14),U,3)=DIV,DIH=36,DIG=.143 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(36,.141,1,2,"%D",0)
	;;=^^2^2^2930402^
	;;^DD(36,.141,1,2,"%D",1,0)
	;;=When changing or deleting APPEALS ADDRESS ST. [LINE 1] delete
	;;^DD(36,.141,1,2,"%D",2,0)
	;;=APPEALS ADDRESS ST. [LINE 3].
	;;^DD(36,.141,1,2,"CREATE VALUE")
	;;=@
	;;^DD(36,.141,1,2,"DELETE VALUE")
	;;=@
	;;^DD(36,.141,1,2,"DT")
	;;=2930401
	;;^DD(36,.141,1,2,"FIELD")
	;;=APPEALS ADDRESS ST. [LINE 3]
	;;^DD(36,.141,3)
	;;=If the appeals address of this company is different from its main address, enter Line 1 of the appeals street address.  Answer must be 3-30 characters in length.
	;;^DD(36,.141,21,0)
	;;=^^2^2^2930607^
	;;^DD(36,.141,21,1,0)
	;;=Enter the first line of the street address of the appeals office
	;;^DD(36,.141,21,2,0)
	;;=of this insurance carrier.
	;;^DD(36,.141,"DT")
	;;=2930401
	;;^DD(36,.142,0)
	;;=APPEALS ADDRESS ST. [LINE 2]^F^^.14;2^K:$L(X)>30!($L(X)<3) X
	;;^DD(36,.142,1,0)
	;;=^.1
	;;^DD(36,.142,1,1,0)
	;;=^^TRIGGER^36^.143
	;;^DD(36,.142,1,1,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DIC(36,D0,.14)):^(.14),1:"") S X=$P(Y(1),U,3),X=X S DIU=X K Y S X="" X ^DD(36,.142,1,1,1.4)
	;;^DD(36,.142,1,1,1.4)
	;;=S DIH=$S($D(^DIC(36,DIV(0),.14)):^(.14),1:""),DIV=X S $P(^(.14),U,3)=DIV,DIH=36,DIG=.143 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(36,.142,1,1,2)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DIC(36,D0,.14)):^(.14),1:"") S X=$P(Y(1),U,3),X=X S DIU=X K Y S X="" X ^DD(36,.142,1,1,2.4)
	;;^DD(36,.142,1,1,2.4)
	;;=S DIH=$S($D(^DIC(36,DIV(0),.14)):^(.14),1:""),DIV=X S $P(^(.14),U,3)=DIV,DIH=36,DIG=.143 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(36,.142,1,1,"%D",0)
	;;=^^2^2^2930402^
	;;^DD(36,.142,1,1,"%D",1,0)
	;;=When changing or deleting APPEALS ADDRESS ST. [LINE 2] delete
	;;^DD(36,.142,1,1,"%D",2,0)
	;;=APPEALS ADDRESS ST. [LINE 3].
	;;^DD(36,.142,1,1,"CREATE VALUE")
	;;=@
	;;^DD(36,.142,1,1,"DELETE VALUE")
	;;=@
	;;^DD(36,.142,1,1,"DT")
	;;=2930401
	;;^DD(36,.142,1,1,"FIELD")
	;;=APPEALS ADDRESS ST. [LINE 3]
	;;^DD(36,.142,3)
	;;=If the appeals address of this company is different from its main address, enter Line 2 of the appeals street address.  Answer must be 3-30 characters in length.
	;;^DD(36,.142,5,1,0)
	;;=36^.141^1
	;;^DD(36,.142,21,0)
	;;=^^2^2^2930607^
	;;^DD(36,.142,21,1,0)
	;;=If this insurance company's appeals office address is longer than
	;;^DD(36,.142,21,2,0)
	;;=one line, enter the second line here.
	;;^DD(36,.142,"DT")
	;;=2930401
	;;^DD(36,.143,0)
	;;=APPEALS ADDRESS ST. [LINE 3]^F^^.14;3^K:$L(X)>30!($L(X)<3) X
	;;^DD(36,.143,3)
	;;=If the appeals address of this company is different from its main address, enter Line 3 of the appeals street address.  Answer must be 3-30 characters in length.
	;;^DD(36,.143,5,1,0)
	;;=36^.142^1
	;;^DD(36,.143,5,2,0)
	;;=36^.141^2
	;;^DD(36,.143,21,0)
	;;=^^2^2^2930715^^
	;;^DD(36,.143,21,1,0)
	;;=If this insurance company's appeals office address is longer than
	;;^DD(36,.143,21,2,0)
	;;=two lines, enter the third line here.
	;;^DD(36,.143,"DT")
	;;=2930225
	;;^DD(36,.144,0)
	;;=APPEALS ADDRESS CITY^F^^.14;4^K:$L(X)>25!($L(X)<2) X
	;;^DD(36,.144,3)
	;;=If the appeals address of this company is different from its main address, enter city of the appeals address.  Answer must be 2-25 characters in length.
