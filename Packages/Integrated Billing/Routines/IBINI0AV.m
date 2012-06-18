IBINI0AV	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(399)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(399.041,.02,21,2,0)
	;;=This is the beginning date for the time period covered by Occurrence Spans.
	;;^DD(399.041,.02,"DT")
	;;=2890331
	;;^DD(399.041,.03,0)
	;;=STATE^P5'^DIC(5,^0;3^Q
	;;^DD(399.041,.03,3)
	;;=Enter the state the accident occured in.  Used for auto accidents on the HCFA 1500.
	;;^DD(399.041,.03,21,0)
	;;=^^2^2^2920430^^
	;;^DD(399.041,.03,21,1,0)
	;;=This is the state in which the accident took place.  Currently only needed
	;;^DD(399.041,.03,21,2,0)
	;;=for auto accidents on the HCFA 1500.
	;;^DD(399.041,.03,"DT")
	;;=2920427
	;;^DD(399.041,.04,0)
	;;=END DATE^D^^0;4^S %DT="EX" D ^%DT S X=Y K:Y<1 X
	;;^DD(399.041,.04,3)
	;;=Enter the end date for the time period covered by this Occurrence Span.
	;;^DD(399.041,.04,"DT")
	;;=2931221
	;;^DD(399.042,0)
	;;=REVENUE CODE SUB-FIELD^^.08^9
	;;^DD(399.042,0,"DIK")
	;;=IBXX
	;;^DD(399.042,0,"DT")
	;;=2940207
	;;^DD(399.042,0,"ID",.05)
	;;=S %I=Y,Y=$S('$D(^(0)):"",$D(^DGCR(399.1,+$P(^(0),U,5),0))#2:$P(^(0),U,1),1:""),C=$P(^DD(399.1,.01,0),U,2) D Y^DIQ:Y]"" W "   ",Y,@("$E("_DIC_"%I,0),0)") S Y=%I K %I
	;;^DD(399.042,0,"IX","ABS",399.042,.05)
	;;=
	;;^DD(399.042,0,"IX","ABS1",399.042,.01)
	;;=
	;;^DD(399.042,0,"IX","ATC",399.042,.04)
	;;=
	;;^DD(399.042,0,"IX","B",399.042,.01)
	;;=
	;;^DD(399.042,0,"IX","TC",399.042,.03)
	;;=
	;;^DD(399.042,0,"IX","TC1",399.042,.02)
	;;=
	;;^DD(399.042,0,"NM","REVENUE CODE")
	;;=
	;;^DD(399.042,0,"UP")
	;;=399
	;;^DD(399.042,.001,0)
	;;=NUMBER^NJ5,0^^ ^K:+X'=X!(X>99999)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(399.042,.001,3)
	;;=Type a Number between 1 and 99999, 0 Decimal Digits
	;;^DD(399.042,.001,9)
	;;=^
	;;^DD(399.042,.001,21,0)
	;;=^^2^2^2911025^
	;;^DD(399.042,.001,21,1,0)
	;;=This is the sequential number of the entry.  Use of this number facilitates
	;;^DD(399.042,.001,21,2,0)
	;;=reference to the line item charges and revenue codes it is associated with.
	;;^DD(399.042,.001,"DT")
	;;=2900710
	;;^DD(399.042,.01,0)
	;;=REVENUE CODE^MR*P399.2'X^DGCR(399.2,^0;1^S D="D",DIC("S")="I $P(^(0),""^"",3)" D IX^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(399.042,.01,1,0)
	;;=^.1^^-1
	;;^DD(399.042,.01,1,1,0)
	;;=399.042^B
	;;^DD(399.042,.01,1,1,1)
	;;=S ^DGCR(399,DA(1),"RC","B",$E(X,1,30),DA)=""
	;;^DD(399.042,.01,1,1,2)
	;;=K ^DGCR(399,DA(1),"RC","B",$E(X,1,30),DA)
	;;^DD(399.042,.01,1,2,0)
	;;=399.042^ABS1^MUMPS
	;;^DD(399.042,.01,1,2,1)
	;;=I $P(^DGCR(399,DA(1),"RC",DA,0),U,5) S ^DGCR(399,DA(1),"RC","ABS",$P(^DGCR(399,DA(1),"RC",DA,0),U,5),$E(X,1,30),DA)=""
	;;^DD(399.042,.01,1,2,2)
	;;=I $P(^DGCR(399,DA(1),"RC",DA,0),U,5) K ^DGCR(399,DA(1),"RC","ABS",$P(^DGCR(399,DA(1),"RC",DA,0),U,5),$E(X,1,30),DA)
	;;^DD(399.042,.01,1,2,"%D",0)
	;;=^^1^1^2940214^
	;;^DD(399.042,.01,1,2,"%D",1,0)
	;;=Cross reference of all revenue codes with bedsections.
	;;^DD(399.042,.01,3)
	;;=Enter the code(s) which identify a specific accommodation, ancillary service, or billing calculation.  You may enter up to 10 codes per bill.
	;;^DD(399.042,.01,9.6)
	;;=I $D(^DGCR(399,+DA,"RC",0)),$P(^(0),"^",4)'<10,'$D(^DGCR(399,DA,"RC","B",X)) W !!,"No more than 10 Revenue Codes per bill may be entered.",! S DGCRR=1
	;;^DD(399.042,.01,12)
	;;=Select active revenue codes only!
	;;^DD(399.042,.01,12.1)
	;;=S DIC("S")="I $D(^DGCR(399.2,""AC"",+Y))"
	;;^DD(399.042,.01,"DT")
	;;=2930610
	;;^DD(399.042,.02,0)
	;;=CHARGES^RNJ8,2^^0;2^S:X["$" X=$P(X,"$",2) K:X'?.N.1".".2N!(X>99999)!(X<0) X
	;;^DD(399.042,.02,1,0)
	;;=^.1^^-1
	;;^DD(399.042,.02,1,1,0)
	;;=399.042^TC1^MUMPS
	;;^DD(399.042,.02,1,1,1)
	;;=D 21^IBCU2
	;;^DD(399.042,.02,1,1,2)
	;;=D 22^IBCU2
