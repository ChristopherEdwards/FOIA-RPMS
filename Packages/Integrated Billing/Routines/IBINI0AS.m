IBINI0AS	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(399)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(399.0304,3,1,0)
	;;=^.1
	;;^DD(399.0304,3,1,1,0)
	;;=399.0304^D
	;;^DD(399.0304,3,1,1,1)
	;;=S ^DGCR(399,DA(1),"CP","D",$E(X,1,30),DA)=""
	;;^DD(399.0304,3,1,1,2)
	;;=K ^DGCR(399,DA(1),"CP","D",$E(X,1,30),DA)
	;;^DD(399.0304,3,1,1,"DT")
	;;=2911030
	;;^DD(399.0304,3,3)
	;;=Type a Number between 1 and 99, 0 Decimal Digits
	;;^DD(399.0304,3,21,0)
	;;=^^3^3^2940120^^^^
	;;^DD(399.0304,3,21,1,0)
	;;=This is the relative order that this procedure will appear on the
	;;^DD(399.0304,3,21,2,0)
	;;=bill.  The lowest numbers will appear on the UB forms in the blocks
	;;^DD(399.0304,3,21,3,0)
	;;=for procedure.  The highest numbers will appear as additional procedures.
	;;^DD(399.0304,3,"DT")
	;;=2911030
	;;^DD(399.0304,4,0)
	;;=BASC BILLABLE^S^1:YES;^0;5^Q
	;;^DD(399.0304,4,1,0)
	;;=^.1
	;;^DD(399.0304,4,1,1,0)
	;;=399.0304^AREV7^MUMPS
	;;^DD(399.0304,4,1,1,1)
	;;=S DGRVRCAL=1
	;;^DD(399.0304,4,1,1,2)
	;;=S DGRVRCAL=2
	;;^DD(399.0304,4,1,1,"%D",0)
	;;=^^2^2^2911119^
	;;^DD(399.0304,4,1,1,"%D",1,0)
	;;=When this field is edited or changed, the revenue codes and charges for this
	;;^DD(399.0304,4,1,1,"%D",2,0)
	;;=bill will automatically be recalculated.
	;;^DD(399.0304,4,1,1,"DT")
	;;=2911119
	;;^DD(399.0304,4,1,2,0)
	;;=399.0304^ASC
	;;^DD(399.0304,4,1,2,1)
	;;=S ^DGCR(399,DA(1),"CP","ASC",$E(X,1,30),DA)=""
	;;^DD(399.0304,4,1,2,2)
	;;=K ^DGCR(399,DA(1),"CP","ASC",$E(X,1,30),DA)
	;;^DD(399.0304,4,1,2,"%D",0)
	;;=^^2^2^2930611^^
	;;^DD(399.0304,4,1,2,"%D",1,0)
	;;=This cross-reference is used to determine if any procedures entered are
	;;^DD(399.0304,4,1,2,"%D",2,0)
	;;=billable as Ambulatory Surgery Codes.
	;;^DD(399.0304,4,1,2,"DT")
	;;=2911120
	;;^DD(399.0304,4,3)
	;;=
	;;^DD(399.0304,4,5,1,0)
	;;=399.0304^5^1
	;;^DD(399.0304,4,5,2,0)
	;;=399.0304^.01^3
	;;^DD(399.0304,4,5,3,0)
	;;=399.0304^1^2
	;;^DD(399.0304,4,21,0)
	;;=2^^2^2^2940214^
	;;^DD(399.0304,4,21,1,0)
	;;=This field will be completed by the system if this procedure is an
	;;^DD(399.0304,4,21,2,0)
	;;=Ambulatory Surgery that can be billed under the HCFA rate system.
	;;^DD(399.0304,4,"DT")
	;;=2920228
	;;^DD(399.0304,5,0)
	;;=DIVISION^RP40.8'^DG(40.8,^0;6^Q
	;;^DD(399.0304,5,1,0)
	;;=^.1
	;;^DD(399.0304,5,1,1,0)
	;;=^^TRIGGER^399.0304^4
	;;^DD(399.0304,5,1,1,1)
	;;=K DIV S DIV=X,D0=DA(1),DIV(0)=D0,D1=DA,DIV(1)=D1 S Y(1)=$S($D(^DGCR(399,D0,"CP",D1,0)):^(0),1:"") S X=$P(Y(1),U,5),X=X S DIU=X K Y X ^DD(399.0304,5,1,1,1.1) X ^DD(399.0304,5,1,1,1.4)
	;;^DD(399.0304,5,1,1,1.1)
	;;=S X=DIV S X=$$CP^IBEFUNC1(DA(1),DA) I X'="" S X=1
	;;^DD(399.0304,5,1,1,1.4)
	;;=S DIH=$S($D(^DGCR(399,DIV(0),"CP",DIV(1),0)):^(0),1:""),DIV=X S $P(^(0),U,5)=DIV,DIH=399.0304,DIG=4 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(399.0304,5,1,1,2)
	;;=K DIV S DIV=X,D0=DA(1),DIV(0)=D0,D1=DA,DIV(1)=D1 S Y(1)=$S($D(^DGCR(399,D0,"CP",D1,0)):^(0),1:"") S X=$P(Y(1),U,5),X=X S DIU=X K Y S X="" X ^DD(399.0304,5,1,1,2.4)
	;;^DD(399.0304,5,1,1,2.4)
	;;=S DIH=$S($D(^DGCR(399,DIV(0),"CP",DIV(1),0)):^(0),1:""),DIV=X S $P(^(0),U,5)=DIV,DIH=399.0304,DIG=4 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(399.0304,5,1,1,"%D",0)
	;;=^^1^1^2930903^
	;;^DD(399.0304,5,1,1,"%D",1,0)
	;;=Calculate and set BASC billable flag.
	;;^DD(399.0304,5,1,1,"CREATE VALUE")
	;;=S X=$$CP^IBEFUNC1(DA(1),DA) I X'="" S X=1
	;;^DD(399.0304,5,1,1,"DELETE VALUE")
	;;=@
	;;^DD(399.0304,5,1,1,"DT")
	;;=2930903
	;;^DD(399.0304,5,1,1,"FIELD")
	;;=BASC BILLABLE
	;;^DD(399.0304,5,3)
	;;=Enter the division where this procedure was performed.
	;;^DD(399.0304,5,21,0)
	;;=^^3^3^2930611^^^^
	;;^DD(399.0304,5,21,1,0)
	;;=Enter the Division at which this procedure was performed.  If this field
