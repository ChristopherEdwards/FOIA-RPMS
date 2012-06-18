IBINI0AG	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(399)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(399,122,21,2,0)
	;;=Printed in Form Locator 51 for the Primary Insurance Carrier on the UB-92.
	;;^DD(399,122,23,0)
	;;=^^2^2^2940201^^
	;;^DD(399,122,23,1,0)
	;;=Loaded with Hospital Provider Number (36,.11) of the Primary Insurance
	;;^DD(399,122,23,2,0)
	;;=Carrier, if defined.
	;;^DD(399,122,"DT")
	;;=2940201
	;;^DD(399,123,0)
	;;=SECONDARY PROVIDER #^F^^M1;3^K:$L(X)>13!($L(X)<3) X
	;;^DD(399,123,3)
	;;=Answer must be 3-13 characters in length.
	;;^DD(399,123,5,1,0)
	;;=399^102^2
	;;^DD(399,123,21,0)
	;;=^^2^2^2940201^
	;;^DD(399,123,21,1,0)
	;;=This is the number assigned to the provider by the secondary payer.
	;;^DD(399,123,21,2,0)
	;;=Printed in Form Locator 51 for the Secondary Insurance Carrier on the UB-92.
	;;^DD(399,123,23,0)
	;;=^^2^2^2940201^
	;;^DD(399,123,23,1,0)
	;;=Loaded with Hospital Provider Number (36,.11) of the Secondary Insurance
	;;^DD(399,123,23,2,0)
	;;=Carrier, if defined.
	;;^DD(399,123,"DT")
	;;=2940201
	;;^DD(399,124,0)
	;;=TERTIARY PROVIDER #^F^^M1;4^K:$L(X)>13!($L(X)<3) X
	;;^DD(399,124,3)
	;;=Answer must be 3-13 characters in length.
	;;^DD(399,124,5,1,0)
	;;=399^103^2
	;;^DD(399,124,21,0)
	;;=^^2^2^2940201^
	;;^DD(399,124,21,1,0)
	;;=This is the number assigned to the provider by the tertiary payer.
	;;^DD(399,124,21,2,0)
	;;=Printed in Form Locator 51 for the Tertiary Insurance Carrier on the UB-92.
	;;^DD(399,124,23,0)
	;;=^^2^2^2940201^
	;;^DD(399,124,23,1,0)
	;;=Loaded with Hospital Provider Number (36,.11) of the Tertiary Insurance
	;;^DD(399,124,23,2,0)
	;;=Carrier, if defined.
	;;^DD(399,124,"DT")
	;;=2940201
	;;^DD(399,151,0)
	;;=STATEMENT COVERS FROM^RDX^^U;1^S %DT="ETP" D ^%DT S X=Y K:Y<1 X I $D(X) D DDAT^IBCU4 K IB00
	;;^DD(399,151,1,0)
	;;=^.1
	;;^DD(399,151,1,1,0)
	;;=^^TRIGGER^399^165
	;;^DD(399,151,1,1,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X I $P(^DGCR(399,DA,0),U,5)<3 I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,"U")):^("U"),1:"") S X=$P(Y(1),U,15),X=X S DIU=X K Y S X=DIV S X=$$LOS1^IBCU64(DA) X ^DD(399,151,1,1,1.4)
	;;^DD(399,151,1,1,1.4)
	;;=S DIH=$S($D(^DGCR(399,DIV(0),"U")):^("U"),1:""),DIV=X S $P(^("U"),U,15)=DIV,DIH=399,DIG=165 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(399,151,1,1,2)
	;;=Q
	;;^DD(399,151,1,1,"%D",0)
	;;=^^1^1^2931018^
	;;^DD(399,151,1,1,"%D",1,0)
	;;=Sets Length of Stay based on PTF record and date range of bill.  Inpatient only.
	;;^DD(399,151,1,1,"CREATE CONDITION")
	;;=I $P(^DGCR(399,DA,0),U,5)<3
	;;^DD(399,151,1,1,"CREATE VALUE")
	;;=S X=$$LOS1^IBCU64(DA)
	;;^DD(399,151,1,1,"DELETE VALUE")
	;;=NO EFFECT
	;;^DD(399,151,1,1,"DT")
	;;=2931018
	;;^DD(399,151,1,1,"FIELD")
	;;=LENGTH OF STAY
	;;^DD(399,151,1,2,0)
	;;=399^AREV2^MUMPS
	;;^DD(399,151,1,2,1)
	;;=S DGRVRCAL=1
	;;^DD(399,151,1,2,2)
	;;=S DGRVRCAL=2
	;;^DD(399,151,1,2,"%D",0)
	;;=^^2^2^2940214^
	;;^DD(399,151,1,2,"%D",1,0)
	;;=Variable causes revenue codes and chrges to be re-calculated on return
	;;^DD(399,151,1,2,"%D",2,0)
	;;=to the enter/edit billing screens.
	;;^DD(399,151,1,3,0)
	;;=^^TRIGGER^399^209
	;;^DD(399,151,1,3,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DGCR(399,D0,"U1")):^("U1"),1:"") S X=$P(Y(1),U,9),X=X S DIU=X K Y X ^DD(399,151,1,3,1.1) X ^DD(399,151,1,3,1.4)
	;;^DD(399,151,1,3,1.1)
	;;=S X=DIV S X=+^DGCR(399,DA,"U"),X=$E(X,2,3)+$S($E(X,4,5)<10:0,1:1)
	;;^DD(399,151,1,3,1.4)
	;;=S DIH=$S($D(^DGCR(399,DIV(0),"U1")):^("U1"),1:""),DIV=X S $P(^("U1"),U,9)=DIV,DIH=399,DIG=209 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(399,151,1,3,2)
	;;=Q
	;;^DD(399,151,1,3,"%D",0)
	;;=^^1^1^2931018^
	;;^DD(399,151,1,3,"%D",1,0)
	;;=Set Fiscal Year 1 to the FY the bill is within.  (Bills can not span FY.)
