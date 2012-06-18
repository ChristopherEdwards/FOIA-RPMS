IBINI0AM	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(399)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(399,207,0)
	;;=FORM LOCATOR 45^F^^U1;7^K:$L(X)>17!($L(X)<2) X
	;;^DD(399,207,3)
	;;=Enter the information (2-17 characters) which will appear in form locator 45 on the UB-82 form.
	;;^DD(399,207,21,0)
	;;=^^2^2^2940120^^
	;;^DD(399,207,21,1,0)
	;;=This allows the user to enter information which will appear in form locator
	;;^DD(399,207,21,2,0)
	;;=45 on the UB-82 form.
	;;^DD(399,207,"DT")
	;;=2880523
	;;^DD(399,208,0)
	;;=BILL COMMENT^F^^U1;8^K:$L(X)>35!($L(X)<2) X
	;;^DD(399,208,3)
	;;=Enter a comment associated with this bill, if desired, which you want to print on the UB claim forms [2-35 CHARACTERS].
	;;^DD(399,208,21,0)
	;;=^^1^1^2940120^^^
	;;^DD(399,208,21,1,0)
	;;=This allows the user to enter an optional comment associated with this bill.
	;;^DD(399,208,"DT")
	;;=2880523
	;;^DD(399,209,0)
	;;=FISCAL YEAR 1^RNJ2,0X^^U1;9^K:+X'=X!(X>99)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(399,209,3)
	;;=Enter the 2 digit fiscal year associated with this bill.
	;;^DD(399,209,5,1,0)
	;;=399^151^3
	;;^DD(399,209,21,0)
	;;=^^1^1^2931018^^
	;;^DD(399,209,21,1,0)
	;;=This defines the first fiscal year with which this bill is associated.
	;;^DD(399,209,"DT")
	;;=2880711
	;;^DD(399,210,0)
	;;=FY 1 CHARGES^RNJ10,2^^U1;10^S:X["$" X=$P(X,"$",2) K:X'?.N.1".".2N!(X>9999999)!(X<0) X
	;;^DD(399,210,1,0)
	;;=^.1
	;;^DD(399,210,1,1,0)
	;;=^^TRIGGER^399^212
	;;^DD(399,210,1,1,1)
	;;=X ^DD(399,210,1,1,1.3) I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,"U1")):^("U1"),1:"") S X=$P(Y(1),U,12),X=X S DIU=X K Y X ^DD(399,210,1,1,1.1) X ^DD(399,210,1,1,1.4)
	;;^DD(399,210,1,1,1.1)
	;;=S X=DIV S Y(1)=$S($D(^DGCR(399,D0,"U1")):^("U1"),1:"") S X=$P(Y(1),U,1),Y(2)=X S X=DIV,Y=X,X=Y(2),X=X-Y
	;;^DD(399,210,1,1,1.3)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X S Y(1)=$S($D(^DGCR(399,D0,"U1")):^("U1"),1:"") S X=$P(Y(1),U,11)]""
	;;^DD(399,210,1,1,1.4)
	;;=S DIH=$S($D(^DGCR(399,DIV(0),"U1")):^("U1"),1:""),DIV=X S $P(^("U1"),U,12)=DIV,DIH=399,DIG=212 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(399,210,1,1,2)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DGCR(399,D0,"U1")):^("U1"),1:"") S X=$P(Y(1),U,12),X=X S DIU=X K Y S X="" X ^DD(399,210,1,1,2.4)
	;;^DD(399,210,1,1,2.4)
	;;=S DIH=$S($D(^DGCR(399,DIV(0),"U1")):^("U1"),1:""),DIV=X S $P(^("U1"),U,12)=DIV,DIH=399,DIG=212 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(399,210,1,1,"CREATE CONDITION")
	;;=(#211)]""
	;;^DD(399,210,1,1,"CREATE VALUE")
	;;=(#201)-(#210)
	;;^DD(399,210,1,1,"DELETE VALUE")
	;;=@
	;;^DD(399,210,1,1,"FIELD")
	;;=#212
	;;^DD(399,210,3)
	;;=Enter the charges incurred during the first fiscal year associated with this bill.
	;;^DD(399,210,5,1,0)
	;;=399^201^1
	;;^DD(399,210,21,0)
	;;=^^2^2^2880901^
	;;^DD(399,210,21,1,0)
	;;=These are the charges incurred during the first fiscal year associated
	;;^DD(399,210,21,2,0)
	;;=with this bill.
	;;^DD(399,210,"DT")
	;;=2880901
	;;^DD(399,211,0)
	;;=FISCAL YEAR 2^NJ2,0^^U1;11^K:+X'=X!(X>99)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(399,211,3)
	;;=Enter the 2 digit second fiscal year associated with this bill.
	;;^DD(399,211,21,0)
	;;=^^1^1^2931018^^
	;;^DD(399,211,21,1,0)
	;;=This is the second fiscal year with which this bill is associated.
	;;^DD(399,211,23,0)
	;;=^^2^2^2931018^
	;;^DD(399,211,23,1,0)
	;;=Beginning with 1.5 bills can no longer span fical years, so this is
	;;^DD(399,211,23,2,0)
	;;=no longer needed.
	;;^DD(399,211,"DT")
	;;=2880708
	;;^DD(399,212,0)
	;;=FY 2 CHARGES^NJ10,2^^U1;12^S:X["$" X=$P(X,"$",2) K:X'?.N.1".".2N!(X>9999999)!(X<0) X
	;;^DD(399,212,3)
	;;=Enter the charges incurred during the second fiscal year associated with this bill.
