IBINI0AL	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(399)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(399,201,1,1,"DELETE VALUE")
	;;=NO EFFECT
	;;^DD(399,201,1,1,"FIELD")
	;;=#210
	;;^DD(399,201,3)
	;;=Enter the total amount of the revenue code charges for this bill in dollars.
	;;^DD(399,201,9)
	;;=^
	;;^DD(399,201,21,0)
	;;=^^1^1^2880901^
	;;^DD(399,201,21,1,0)
	;;=This is the total amount of the revenue code charges for this bill.
	;;^DD(399,201,"DT")
	;;=2880831
	;;^DD(399,202,0)
	;;=OFFSET AMOUNT^NJ8,2^^U1;2^S:X["$" X=$P(X,"$",2) K:X'?.N.1".".2N!(X>99999)!(X<0) X
	;;^DD(399,202,1,0)
	;;=^.1
	;;^DD(399,202,1,1,0)
	;;=^^TRIGGER^399^203
	;;^DD(399,202,1,1,1)
	;;=Q
	;;^DD(399,202,1,1,2)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X S Y(1)=$S($D(^DGCR(399,D0,"U1")):^("U1"),1:"") S X=$P(Y(1),U,2)="" I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,"U1")):^("U1"),1:"") S X=$P(Y(1),U,3),X=X S DIU=X K Y S X="" X ^DD(399,202,1,1,2.4)
	;;^DD(399,202,1,1,2.4)
	;;=S DIH=$S($D(^DGCR(399,DIV(0),"U1")):^("U1"),1:""),DIV=X S $P(^("U1"),U,3)=DIV,DIH=399,DIG=203 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(399,202,1,1,"CREATE VALUE")
	;;=NO EFFECT
	;;^DD(399,202,1,1,"DELETE CONDITION")
	;;=OFFSET AMOUNT=""
	;;^DD(399,202,1,1,"DELETE VALUE")
	;;=@
	;;^DD(399,202,1,1,"FIELD")
	;;=#203
	;;^DD(399,202,3)
	;;=Enter the dollar amount between 0 and 99999.99 that is to be subtracted from the total charges on this bill.  Offset includes, but is not limited to, co-payments and deductibles.
	;;^DD(399,202,21,0)
	;;=^^3^3^2880901^
	;;^DD(399,202,21,1,0)
	;;=This is the dollar amount which is to be subtracted from the total charges
	;;^DD(399,202,21,2,0)
	;;=on this bill. Offset includes, but is not limited to, co-payments, credits,
	;;^DD(399,202,21,3,0)
	;;=and deductibles.
	;;^DD(399,202,"DT")
	;;=2880525
	;;^DD(399,203,0)
	;;=OFFSET DESCRIPTION^FX^^U1;3^K:$L(X)>24!($L(X)<3) X
	;;^DD(399,203,3)
	;;=Enter reason for Offset Amount.  Offset Description may include, but is not limited to, deductibles, copayments, credits, etc.
	;;^DD(399,203,5,1,0)
	;;=399^202^1
	;;^DD(399,203,21,0)
	;;=^^1^1^2940317^^^^
	;;^DD(399,203,21,1,0)
	;;=This defines the reason for offset amount.  Maximum length is 24 characters.
	;;^DD(399,203,"DT")
	;;=2940317
	;;^DD(399,204,0)
	;;=FORM LOCATOR 2^F^^U1;4^K:$L(X)>30!($L(X)<2) X
	;;^DD(399,204,3)
	;;=Enter the information (2-30 characters) which is to appear in form locator 2 on the UB-82 form.
	;;^DD(399,204,21,0)
	;;=^^2^2^2940120^^
	;;^DD(399,204,21,1,0)
	;;=This allows the user to enter information which will appear in form locator
	;;^DD(399,204,21,2,0)
	;;=2 on the UB-82 form.
	;;^DD(399,204,"DT")
	;;=2880523
	;;^DD(399,205,0)
	;;=FORM LOCATOR 9^F^^U1;5^K:$L(X)>7!($L(X)<2) X
	;;^DD(399,205,3)
	;;=Enter the information (2-7 characters) which will appear in form locator 9 on the UB-82 form.
	;;^DD(399,205,21,0)
	;;=^^2^2^2940214^^^^
	;;^DD(399,205,21,1,0)
	;;=This allows the user to enter information which will appear in form locator
	;;^DD(399,205,21,2,0)
	;;=9 on the UB-82 form.       
	;;^DD(399,205,23,0)
	;;=^^2^2^2940214^^^
	;;^DD(399,205,23,1,0)
	;;=Was temporarily used to hold Admitting DX for the UB-92 (FL 76), but was 
	;;^DD(399,205,23,2,0)
	;;=replaced by FL 215.
	;;^DD(399,205,"DT")
	;;=2880523
	;;^DD(399,206,0)
	;;=FORM LOCATOR 27^F^^U1;6^K:$L(X)>8!($L(X)<2) X
	;;^DD(399,206,3)
	;;=Enter the information (2-8 characters) which is to appear in form locator 27 on the UB-82 form.
	;;^DD(399,206,21,0)
	;;=^^2^2^2880901^
	;;^DD(399,206,21,1,0)
	;;=This allows the user to enter information will will appear in form locator
	;;^DD(399,206,21,2,0)
	;;=27 on the UB-82 form.
	;;^DD(399,206,"DT")
	;;=2880523
