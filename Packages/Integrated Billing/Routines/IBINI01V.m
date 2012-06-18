IBINI01V	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(350.5)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(350.5,.04,"DT")
	;;=2920121
	;;^DD(350.5,.05,0)
	;;=WAGE PERCENTAGE^RNJ10,8^^0;5^K:+X'=X!(X>1)!(X<0)!(X?.E1"."9N.N) X
	;;^DD(350.5,.05,1,0)
	;;=^.1
	;;^DD(350.5,.05,1,1,0)
	;;=^^TRIGGER^350.5^.06
	;;^DD(350.5,.05,1,1,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^IBE(350.5,D0,0)):^(0),1:"") S X=$P(Y(1),U,6),X=X S DIU=X K Y S X=DIV S X=1-DIV X ^DD(350.5,.05,1,1,1.4)
	;;^DD(350.5,.05,1,1,1.4)
	;;=S DIH=$S($D(^IBE(350.5,DIV(0),0)):^(0),1:""),DIV=X S $P(^(0),U,6)=DIV,DIH=350.5,DIG=.06 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(350.5,.05,1,1,2)
	;;=Q
	;;^DD(350.5,.05,1,1,"CREATE VALUE")
	;;=1-WAGE PERCENTAGE
	;;^DD(350.5,.05,1,1,"DELETE VALUE")
	;;=NO EFFECT
	;;^DD(350.5,.05,1,1,"FIELD")
	;;=NON-WAGE PERCENTAGE
	;;^DD(350.5,.05,3)
	;;=Type a number between 0 and 1, with up to 8 decimal digits.  This is the wage component fraction of the Ambulatory Surgery charge.
	;;^DD(350.5,.05,21,0)
	;;=^^2^2^2920723^^^^
	;;^DD(350.5,.05,21,1,0)
	;;=This is the percentage of the rate group unit charge that is the wage
	;;^DD(350.5,.05,21,2,0)
	;;=component to be used in calculating the ambulatory surgery charge.
	;;^DD(350.5,.05,"DT")
	;;=2920122
	;;^DD(350.5,.06,0)
	;;=NON-WAGE PERCENTAGE^RNJ10,8X^^0;6^K:+X'=X!(X>1)!(X<0)!(X?.E1"."9N.N)!(X'=(1-$P(^IBE(350.5,DA,0),U,5))) X
	;;^DD(350.5,.06,3)
	;;=Type a Number between 0 and 1, 8 Decimal Digits.  Wage and non-wage percentage must total 1.
	;;^DD(350.5,.06,5,1,0)
	;;=350.5^.05^1
	;;^DD(350.5,.06,21,0)
	;;=^^2^2^2920415^^^^
	;;^DD(350.5,.06,21,1,0)
	;;=This is the percentage of the rate group unit charge that is the non-wage 
	;;^DD(350.5,.06,21,2,0)
	;;=component to be used in calculating the ambulatory surgery charge.
	;;^DD(350.5,.06,"DT")
	;;=2920122
	;;^DD(350.5,.07,0)
	;;=LOCALITY RATE MODIFIER^RNJ11,8^^0;7^K:+X'=X!(X>99)!(X<0)!(X?.E1"."9N.N) X
	;;^DD(350.5,.07,3)
	;;=Type a Number between 0 and 99, 8 Decimal Digits
	;;^DD(350.5,.07,21,0)
	;;=^^4^4^2920415^^^
	;;^DD(350.5,.07,21,1,0)
	;;=This is the Geographic Wage Index that is used to account for wage differences
	;;^DD(350.5,.07,21,2,0)
	;;=in different localities when calculating the ambulatory surgery charge. It is
	;;^DD(350.5,.07,21,3,0)
	;;=multiplied by the wage component to get the final geographic wage component
	;;^DD(350.5,.07,21,4,0)
	;;=of the charge.
	;;^DD(350.5,.07,"DT")
	;;=2920121
