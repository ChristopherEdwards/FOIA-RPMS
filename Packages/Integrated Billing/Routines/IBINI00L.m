IBINI00L	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(36)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(36,.112,1,1,2)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DIC(36,D0,.11)):^(.11),1:"") S X=$P(Y(1),U,3),X=X S DIU=X K Y S X="" X ^DD(36,.112,1,1,2.4)
	;;^DD(36,.112,1,1,2.4)
	;;=S DIH=$S($D(^DIC(36,DIV(0),.11)):^(.11),1:""),DIV=X S $P(^(.11),U,3)=DIV,DIH=36,DIG=.113 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(36,.112,1,1,"%D",0)
	;;=^^2^2^2930402^
	;;^DD(36,.112,1,1,"%D",1,0)
	;;=When changing or deleting STREET ADDRESS [LINE 2] delete STREET
	;;^DD(36,.112,1,1,"%D",2,0)
	;;=ADDRESS [LINE 3].
	;;^DD(36,.112,1,1,"CREATE VALUE")
	;;=@
	;;^DD(36,.112,1,1,"DELETE VALUE")
	;;=@
	;;^DD(36,.112,1,1,"DT")
	;;=2930401
	;;^DD(36,.112,1,1,"FIELD")
	;;=STREET ADDRESS [LINE 3]
	;;^DD(36,.112,3)
	;;=Enter the second line of this company's street address with 3-30 characters if the space provided in 'STREET ADDRESS' was not sufficient.
	;;^DD(36,.112,5,1,0)
	;;=36^.111^1
	;;^DD(36,.112,21,0)
	;;=^^2^2^2940209^^^
	;;^DD(36,.112,21,1,0)
	;;=If this insurance company's street address is longer than one line, enter
	;;^DD(36,.112,21,2,0)
	;;=the second line here.
	;;^DD(36,.112,"DT")
	;;=2930401
	;;^DD(36,.113,0)
	;;=STREET ADDRESS [LINE 3]^FX^^.11;3^K:$L(X)>30!($L(X)<3) X
	;;^DD(36,.113,3)
	;;=Enter the third line of this company's street address with 3-30 characters if the space provided in 'STREET ADDRESS' and 'STREET ADDRESS 2' was not sufficient.
	;;^DD(36,.113,5,1,0)
	;;=36^.112^1
	;;^DD(36,.113,5,2,0)
	;;=36^.111^2
	;;^DD(36,.113,21,0)
	;;=^^2^2^2930330^^
	;;^DD(36,.113,21,1,0)
	;;=If this insurance company's street address is longer than two lines, enter
	;;^DD(36,.113,21,2,0)
	;;=the third line here.
	;;^DD(36,.113,"DT")
	;;=2930226
	;;^DD(36,.114,0)
	;;=CITY^FX^^.11;4^K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>25!($L(X)<2) X
	;;^DD(36,.114,3)
	;;=Enter the city in which this company is located with 2-25 characters.  If the space provided is not sufficient, abbreviate the city to the best of your ability.
	;;^DD(36,.114,21,0)
	;;=^^1^1^2911222^
	;;^DD(36,.114,21,1,0)
	;;=Enter the city of the mailing address for this insurance carrier.
	;;^DD(36,.114,"DEL",1,0)
	;;=I $D(DGINS)
	;;^DD(36,.114,"DT")
	;;=2930226
	;;^DD(36,.115,0)
	;;=STATE^P5'X^DIC(5,^.11;5^Q
	;;^DD(36,.115,21,0)
	;;=^^1^1^2911222^
	;;^DD(36,.115,21,1,0)
	;;=Enter the state of the mailing address for this insurance carrier.
	;;^DD(36,.115,"DEL",1,0)
	;;=I $D(DGINS)
	;;^DD(36,.115,"DT")
	;;=2930312
	;;^DD(36,.116,0)
	;;=ZIP CODE^FXO^^.11;6^K:$L(X)>20!($L(X)<5) X I $D(X) D ZIPIN^VAFADDR
	;;^DD(36,.116,2)
	;;=S Y(0)=Y D ZIPOUT^VAFADDR
	;;^DD(36,.116,2.1)
	;;=D ZIPOUT^VAFADDR
	;;^DD(36,.116,3)
	;;=Answer with either 5 digit or 9 digit zip code.
	;;^DD(36,.116,21,0)
	;;=^^4^4^2930715^^^^
	;;^DD(36,.116,21,1,0)
	;;=Enter the zip code of the mailing address for this insurance carrier.
	;;^DD(36,.116,21,2,0)
	;;=Answer with either the 5 digit zip code (format 12345) or with the 9 
	;;^DD(36,.116,21,3,0)
	;;=digit zip code (in format 123456789 or 12345-6789).
	;;^DD(36,.116,21,4,0)
	;;= 
	;;^DD(36,.116,"DEL",1,0)
	;;=I $D(DGINS)
	;;^DD(36,.116,"DT")
	;;=2930226
	;;^DD(36,.117,0)
	;;=BILLING COMPANY NAME^F^^.11;7^K:$L(X)>30!($L(X)<3) X
	;;^DD(36,.117,3)
	;;=Answer must be 3-30 characters in length.
	;;^DD(36,.117,21,0)
	;;=^^1^1^2930715^
	;;^DD(36,.117,21,1,0)
	;;=Enter the name of the insurance carrier's billing company.
	;;^DD(36,.117,"DT")
	;;=2930715
	;;^DD(36,.119,0)
	;;=FAX NUMBER^F^^.11;9^K:$L(X)>20!($L(X)<7) X
	;;^DD(36,.119,3)
	;;=Enter the fax number of the company with 7 - 20 characters, ex. 999-999-9999.
	;;^DD(36,.119,21,0)
	;;=^^1^1^2931123^
