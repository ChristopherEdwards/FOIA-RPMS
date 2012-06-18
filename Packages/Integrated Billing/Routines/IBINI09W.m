IBINI09W	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(399)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(399,.04,21,0)
	;;=^^1^1^2931221^^^^
	;;^DD(399,.04,21,1,0)
	;;=This identifies the type of facility at which care was administered.
	;;^DD(399,.04,"DT")
	;;=2931221
	;;^DD(399,.05,0)
	;;=BILL CLASSIFICATION^RSX^1:INPATIENT (MEDICARE PART A);2:HUMANITARIAN EMERGENCY (INPT./MEDICARE PART B);3:OUTPATIENT;4:HUMANITARIAN EMERGENCY (OPT./ESRD);^0;5^Q
	;;^DD(399,.05,.1)
	;;=TYPE OF BILL (2ND DIGIT)
	;;^DD(399,.05,1,0)
	;;=^.1
	;;^DD(399,.05,1,1,0)
	;;=399^ABT
	;;^DD(399,.05,1,1,1)
	;;=S ^DGCR(399,"ABT",$E(X,1,30),DA)=""
	;;^DD(399,.05,1,1,2)
	;;=K ^DGCR(399,"ABT",$E(X,1,30),DA)
	;;^DD(399,.05,3)
	;;=Enter the code which designates inpatient or outpatient care.
	;;^DD(399,.05,21,0)
	;;=^^1^1^2931220^^^^
	;;^DD(399,.05,21,1,0)
	;;=This code identifies the care being billed for as inpatient or outpatient.
	;;^DD(399,.05,"DT")
	;;=2900508
	;;^DD(399,.06,0)
	;;~TIMEFRAME OF BILL^RS^1:ADMIT THRU DISCHARGE CLAIM;2:INTERIM - FIRST CLAIM;3:INTERIM - CONTINUING CLAIM;4:INTERIM - LAST CLAIM;5:LATE CHARGE(S) ONLY CLAIM;6:ADJU
	;;=STMENT OF PRIOR CLAIM;7:REPLACEMENT OF PRIOR CLAIM;0:NON-PAYMENT/ZERO CLAIM;^0;6^Q
	;;^DD(399,.06,.1)
	;;=TYPE OF BILL (3RD DIGIT)
	;;^DD(399,.06,3)
	;;=Enter the code which defines the frequency of this bill.
	;;^DD(399,.06,21,0)
	;;=^^1^1^2931220^^^
	;;^DD(399,.06,21,1,0)
	;;=This code defines the frequency of this bill.
	;;^DD(399,.06,"DT")
	;;=2891221
	;;^DD(399,.07,0)
	;;=RATE TYPE^R*P399.3'^DGCR(399.3,^0;7^S DIC("S")="I '$P(^(0),U,3)" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(399,.07,1,0)
	;;=^.1
	;;^DD(399,.07,1,1,0)
	;;=^^TRIGGER^399^156
	;;^DD(399,.07,1,1,1)
	;;=X ^DD(399,.07,1,1,1.3) I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,"U")):^("U"),1:"") S X=$P(Y(1),U,6),X=X S DIU=X K Y S X=DIV S X="Y" X ^DD(399,.07,1,1,1.4)
	;;^DD(399,.07,1,1,1.3)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X X ^DD(399,.07,1,1,69.2) S X=$P($P(Y(102),$C(59)_$P(Y(101),U,5)_":",2),$C(59),1)="YES" S D0=I(0,0)
	;;^DD(399,.07,1,1,1.4)
	;;=S DIH=$S($D(^DGCR(399,DIV(0),"U")):^("U"),1:""),DIV=X S $P(^("U"),U,6)=DIV,DIH=399,DIG=156 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(399,.07,1,1,2)
	;;=X ^DD(399,.07,1,1,2.3) I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,"U")):^("U"),1:"") S X=$P(Y(1),U,6),X=X S DIU=X K Y S X=DIV S X="N" X ^DD(399,.07,1,1,2.4)
	;;^DD(399,.07,1,1,2.3)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X X ^DD(399,.07,1,1,79.2) S Y(101)=$S($D(^DGCR(399.3,D0,0)):^(0),1:"") S X=$P($P(Y(102),$C(59)_$P(Y(101),U,5)_":",2),$C(59),1)'="YES" S D0=I(0,0)
	;;^DD(399,.07,1,1,2.4)
	;;=S DIH=$S($D(^DGCR(399,DIV(0),"U")):^("U"),1:""),DIV=X S $P(^("U"),U,6)=DIV,DIH=399,DIG=156 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(399,.07,1,1,69.2)
	;;=S I(0,0)=$S($D(D0):D0,1:""),D0=Y(0) S:'$D(^DGCR(399.3,+D0,0)) D0=-1 S Y(102)=$C(59)_$S($D(^DD(399.3,.05,0)):$P(^(0),U,3),1:""),Y(101)=$S($D(^DGCR(399.3,D0,0)):^(0),1:"")
	;;^DD(399,.07,1,1,79.2)
	;;=S I(0,0)=$S($D(D0):D0,1:""),Y(1)=$S($D(^DGCR(399,D0,0)):^(0),1:""),D0=$P(Y(1),U,7) S:'$D(^DGCR(399.3,+D0,0)) D0=-1 S Y(102)=$C(59)_$S($D(^DD(399.3,.05,0)):$P(^(0),U,3),1:"")
	;;^DD(399,.07,1,1,"CREATE CONDITION")
	;;=RATE TYPE:IS THIS A THIRD PARTY BILL?="YES"
	;;^DD(399,.07,1,1,"CREATE VALUE")
	;;=S X="Y"
	;;^DD(399,.07,1,1,"DELETE CONDITION")
	;;=RATE TYPE:IS THIS A THIRD PARTY BILL?'="YES"
	;;^DD(399,.07,1,1,"DELETE VALUE")
	;;=S X="N"
	;;^DD(399,.07,1,1,"FIELD")
	;;=#156
	;;^DD(399,.07,1,2,0)
	;;=^^TRIGGER^399^.11
	;;^DD(399,.07,1,2,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DGCR(399,D0,0)):^(0),1:"") S X=$P(Y(1),U,11),X=X S DIU=X K Y X ^DD(399,.07,1,2,1.1) X ^DD(399,.07,1,2,1.4)
