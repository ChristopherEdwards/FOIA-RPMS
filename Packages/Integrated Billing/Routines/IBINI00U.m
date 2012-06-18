IBINI00U	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(36)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(36,.152,1,1,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DIC(36,D0,.15)):^(.15),1:"") S X=$P(Y(1),U,3),X=X S DIU=X K Y S X="" X ^DD(36,.152,1,1,1.4)
	;;^DD(36,.152,1,1,1.4)
	;;=S DIH=$S($D(^DIC(36,DIV(0),.15)):^(.15),1:""),DIV=X S $P(^(.15),U,3)=DIV,DIH=36,DIG=.153 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(36,.152,1,1,2)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DIC(36,D0,.15)):^(.15),1:"") S X=$P(Y(1),U,3),X=X S DIU=X K Y S X="" X ^DD(36,.152,1,1,2.4)
	;;^DD(36,.152,1,1,2.4)
	;;=S DIH=$S($D(^DIC(36,DIV(0),.15)):^(.15),1:""),DIV=X S $P(^(.15),U,3)=DIV,DIH=36,DIG=.153 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(36,.152,1,1,"%D",0)
	;;=^^2^2^2930402^
	;;^DD(36,.152,1,1,"%D",1,0)
	;;=When changing or deleting INQUIRY ADDRESS ST. [LINE 2] delete
	;;^DD(36,.152,1,1,"%D",2,0)
	;;=INQUIRY ADDRESS ST. [LINE 3].
	;;^DD(36,.152,1,1,"CREATE VALUE")
	;;=@
	;;^DD(36,.152,1,1,"DELETE VALUE")
	;;=@
	;;^DD(36,.152,1,1,"DT")
	;;=2930401
	;;^DD(36,.152,1,1,"FIELD")
	;;=INQUIRY ADDRESS ST. [LINE 3]
	;;^DD(36,.152,3)
	;;=If the inquiry address of this company is different from its main address, enter Line 2 of the inquiry street address.  Answer must be 3-30 characters in length.
	;;^DD(36,.152,5,1,0)
	;;=36^.151^1
	;;^DD(36,.152,21,0)
	;;=^^2^2^2930607^
	;;^DD(36,.152,21,1,0)
	;;=If this insurance company's inquiry address is longer than one line,
	;;^DD(36,.152,21,2,0)
	;;=enter the second line here.
	;;^DD(36,.152,"DT")
	;;=2930401
	;;^DD(36,.153,0)
	;;=INQUIRY ADDRESS ST. [LINE 3]^F^^.15;3^K:$L(X)>30!($L(X)<3) X
	;;^DD(36,.153,3)
	;;=If the inquiry address of this company is different from its main address, enter Line 3 of the inquiry street address.  Answer must be 3-30 characters in length.
	;;^DD(36,.153,5,1,0)
	;;=36^.151^2
	;;^DD(36,.153,5,2,0)
	;;=36^.152^1
	;;^DD(36,.153,21,0)
	;;=^^2^2^2930607^
	;;^DD(36,.153,21,1,0)
	;;=If this insurance company's inquiry address is longer than two lines,
	;;^DD(36,.153,21,2,0)
	;;=enter the third line here.
	;;^DD(36,.153,"DT")
	;;=2930225
	;;^DD(36,.154,0)
	;;=INQUIRY ADDRESS CITY^F^^.15;4^K:$L(X)>25!($L(X)<2) X
	;;^DD(36,.154,3)
	;;=If the inquiry address of this company is different from its main address, enter city of the inquiry address.  Answer must be 2-25 characters in length.
	;;^DD(36,.154,21,0)
	;;=^^2^2^2930607^
	;;^DD(36,.154,21,1,0)
	;;=Enter the city in which this insurance company's inquiry address
	;;^DD(36,.154,21,2,0)
	;;=office is located.
	;;^DD(36,.154,"DT")
	;;=2930225
	;;^DD(36,.155,0)
	;;=INQUIRY ADDRESS STATE^P5'^DIC(5,^.15;5^Q
	;;^DD(36,.155,3)
	;;=If the inquiry address of this company is different from its main address, enter state of the inquiry address.
	;;^DD(36,.155,21,0)
	;;=^^3^3^2931007^^^^
	;;^DD(36,.155,21,1,0)
	;;=Enter the state in which this insurance company's inquiry address
	;;^DD(36,.155,21,2,0)
	;;=office is located.  Enter state even if it is the same as the state
	;;^DD(36,.155,21,3,0)
	;;=of the company's main address.
	;;^DD(36,.155,"DT")
	;;=2930225
	;;^DD(36,.156,0)
	;;=INQUIRY ADDRESS ZIP CODE^FXO^^.15;6^K:$L(X)>20!($L(X)<5) X I $D(X) D ZIPIN^VAFADDR
	;;^DD(36,.156,2)
	;;=S Y(0)=Y D ZIPOUT^VAFADDR
	;;^DD(36,.156,2.1)
	;;=D ZIPOUT^VAFADDR
	;;^DD(36,.156,3)
	;;=If the inquiry address of this company is different from its main address, enter zip code of the inquiry address.  Answer with either the 5 digit or 9 digit zip code.
	;;^DD(36,.156,21,0)
	;;=^^2^2^2930226^
	;;^DD(36,.156,21,1,0)
	;;=Answer with either the 5 digit zip code (format 12345) or with the 9
	;;^DD(36,.156,21,2,0)
	;;=digit zip code (in format 123456789 or 12345-6789).
