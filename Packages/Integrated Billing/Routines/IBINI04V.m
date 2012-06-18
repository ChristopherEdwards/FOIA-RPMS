IBINI04V	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(355.4)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(355.4,2.05,21,0)
	;;=^^2^2^2930607^
	;;^DD(355.4,2.05,21,1,0)
	;;=If this policy has a lifetime maximum benefit for mental health services,
	;;^DD(355.4,2.05,21,2,0)
	;;=then this is the amount of that benefit.
	;;^DD(355.4,2.05,"DT")
	;;=2931028
	;;^DD(355.4,2.06,0)
	;;=MH ANNUAL OUTPATIENT MAX.^NJ9,2^^2;6^S:X["$" X=$P(X,"$",2) K:X'?.N.1".".2N!(X>999999)!(X<0) X
	;;^DD(355.4,2.06,3)
	;;=Type a Dollar Amount between 0 and 999999, 2 Decimal Digits
	;;^DD(355.4,2.06,21,0)
	;;=^^2^2^2930713^^
	;;^DD(355.4,2.06,21,1,0)
	;;=If this policy has a benefit for mental health services,
	;;^DD(355.4,2.06,21,2,0)
	;;=then this amount is the maximum of that benefit for one year.
	;;^DD(355.4,2.06,"DT")
	;;=2930513
	;;^DD(355.4,2.07,0)
	;;=DENTAL COVERAGE TYPE^S^0:NONE;1:PER VISIT AMOUNT;2:PERCENTAGE AMOUNT;^2;7^Q
	;;^DD(355.4,2.07,1,0)
	;;=^.1
	;;^DD(355.4,2.07,1,1,0)
	;;=^^TRIGGER^355.4^2.08
	;;^DD(355.4,2.07,1,1,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^IBA(355.4,D0,2)):^(2),1:"") S X=$P(Y(1),U,8),X=X S DIU=X K Y S X="" X ^DD(355.4,2.07,1,1,1.4)
	;;^DD(355.4,2.07,1,1,1.4)
	;;=S DIH=$S($D(^IBA(355.4,DIV(0),2)):^(2),1:""),DIV=X S $P(^(2),U,8)=DIV,DIH=355.4,DIG=2.08 D ^DICR:$O(^DD(DIH,DIG,1,0))>0
	;;^DD(355.4,2.07,1,1,2)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^IBA(355.4,D0,2)):^(2),1:"") S X=$P(Y(1),U,8),X=X S DIU=X K Y S X="" X ^DD(355.4,2.07,1,1,2.4)
	;;^DD(355.4,2.07,1,1,2.4)
	;;=S DIH=$S($D(^IBA(355.4,DIV(0),2)):^(2),1:""),DIV=X S $P(^(2),U,8)=DIV,DIH=355.4,DIG=2.08 D ^DICR:$O(^DD(DIH,DIG,1,0))>0
	;;^DD(355.4,2.07,1,1,"%D",0)
	;;=^^1^1^2940107^^
	;;^DD(355.4,2.07,1,1,"%D",1,0)
	;;=When changing or deleting DENTAL COVERAGE TYPE delete DENTAL COVERAGE $ OR %.
	;;^DD(355.4,2.07,1,1,"CREATE VALUE")
	;;=@
	;;^DD(355.4,2.07,1,1,"DELETE VALUE")
	;;=@
	;;^DD(355.4,2.07,1,1,"FIELD")
	;;=#2.08
	;;^DD(355.4,2.07,3)
	;;=
	;;^DD(355.4,2.07,21,0)
	;;=^^2^2^2930607^
	;;^DD(355.4,2.07,21,1,0)
	;;=This indicates whether there is a dental benefit, and if so, the 
	;;^DD(355.4,2.07,21,2,0)
	;;=per visit or percentage amount.
	;;^DD(355.4,2.07,"DT")
	;;=2940107
	;;^DD(355.4,2.08,0)
	;;=DENTAL COVERAGE $ OR %^NJ5,0^^2;8^K:+X'=X!(X>99999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(355.4,2.08,3)
	;;=Type a Number between 0 and 99999, 0 Decimal Digits if coverage is a $ amount, or between 0 and 100 if %.
	;;^DD(355.4,2.08,5,1,0)
	;;=355.4^2.07^1
	;;^DD(355.4,2.08,21,0)
	;;=^^2^2^2931228^^
	;;^DD(355.4,2.08,21,1,0)
	;;=If there is a dental benefit, this number indicates the dollar
	;;^DD(355.4,2.08,21,2,0)
	;;=or percentage amount of that benefit.
	;;^DD(355.4,2.08,"DT")
	;;=2930513
	;;^DD(355.4,2.09,0)
	;;=OUTPATIENT VISIT (%)^NJ3,0^^2;9^K:+X'=X!(X>100)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(355.4,2.09,3)
	;;=Type a Number between 0 and 100, 0 Decimal Digits
	;;^DD(355.4,2.09,21,0)
	;;=^^2^2^2930607^^^
	;;^DD(355.4,2.09,21,1,0)
	;;=If this policy has an outpatient benefit, this is the percentage
	;;^DD(355.4,2.09,21,2,0)
	;;=coverage per outpatient visit.
	;;^DD(355.4,2.09,"DT")
	;;=2930603
	;;^DD(355.4,2.1,0)
	;;=EMERGENCY OUTPATIENT (%)^NJ6,0^^2;10^K:+X'=X!(X>999999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(355.4,2.1,3)
	;;=Type a Number between 0 and 999999, 0 Decimal Digits
	;;^DD(355.4,2.1,21,0)
	;;=^^2^2^2930607^^^
	;;^DD(355.4,2.1,21,1,0)
	;;=If this policy has a benefit for emergency outpatient services,
	;;^DD(355.4,2.1,21,2,0)
	;;=this is the percentage covered by that benefit.
	;;^DD(355.4,2.1,"DT")
	;;=2930607
	;;^DD(355.4,2.11,0)
	;;=MENTAL HEALTH OUTPATIENT (%)^NJ3,0^^2;11^K:+X'=X!(X>100)!(X<0)!(X?.E1"."1N.N) X
