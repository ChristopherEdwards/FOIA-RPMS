IBINI09U	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(399)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(399,.01,1,3,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X S Y(1)=$S($D(^DGCR(399,D0,"S")):^("S"),1:"") S X=$P(Y(1),U,1)="" I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,"S")):^("S"),1:"") S X=$P(Y(1),U,1),X=X S DIU=X K Y S X=DIV S X=DT X ^DD(399,.01,1,3,1.4)
	;;^DD(399,.01,1,3,1.4)
	;;=S DIH=$S($D(^DGCR(399,DIV(0),"S")):^("S"),1:""),DIV=X S $P(^("S"),U,1)=DIV,DIH=399,DIG=1 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(399,.01,1,3,2)
	;;=Q
	;;^DD(399,.01,1,3,"CREATE CONDITION")
	;;=DATE ENTERED=""
	;;^DD(399,.01,1,3,"CREATE VALUE")
	;;=TODAY
	;;^DD(399,.01,1,3,"DELETE VALUE")
	;;=NO EFFECT
	;;^DD(399,.01,1,3,"FIELD")
	;;=#1
	;;^DD(399,.01,1,4,0)
	;;=^^TRIGGER^399^2
	;;^DD(399,.01,1,4,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DGCR(399,D0,"S")):^("S"),1:"") S X=$P(Y(1),U,2),X=X S DIU=X K Y S X=DIV S X=$S(($D(DUZ)#2):DUZ,1:"") X ^DD(399,.01,1,4,1.4)
	;;^DD(399,.01,1,4,1.4)
	;;=S DIH=$S($D(^DGCR(399,DIV(0),"S")):^("S"),1:""),DIV=X S $P(^("S"),U,2)=DIV,DIH=399,DIG=2 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(399,.01,1,4,2)
	;;=Q
	;;^DD(399,.01,1,4,"CREATE VALUE")
	;;=S X=$S(($D(DUZ)#2):DUZ,1:"")
	;;^DD(399,.01,1,4,"DELETE VALUE")
	;;=NO EFFECT
	;;^DD(399,.01,1,4,"FIELD")
	;;=#2
	;;^DD(399,.01,1,5,0)
	;;=^^TRIGGER^399^164
	;;^DD(399,.01,1,5,1)
	;;~K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X S Y(1)=$S($D(^DGCR(399,D0,"U")):^("U"),1:"") S X=$P(Y(1),U,14)="" I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,"U")):^("U"),1:""
	;;=) S X=$P(Y(1),U,14),X=X S DIU=X K Y X ^DD(399,.01,1,5,1.1) X ^DD(399,.01,1,5,1.4)
	;;^DD(399,.01,1,5,1.1)
	;;=S X=DIV S X=$S($D(^IBE(350.9,1,1)):$P(^(1),U,6),1:"")
	;;^DD(399,.01,1,5,1.4)
	;;=S DIH=$S($D(^DGCR(399,DIV(0),"U")):^("U"),1:""),DIV=X S $P(^("U"),U,14)=DIV,DIH=399,DIG=164 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(399,.01,1,5,2)
	;;=Q
	;;^DD(399,.01,1,5,"%D",0)
	;;=^^2^2^2920205^
	;;^DD(399,.01,1,5,"%D",1,0)
	;;=This will automatically store the default BC/BS PROVIDER # from the
	;;^DD(399,.01,1,5,"%D",2,0)
	;;=IB SITE PARAMETERS file into the BC/BS PROVIDER # field for this bill.
	;;^DD(399,.01,1,5,"CREATE CONDITION")
	;;=#164=""
	;;^DD(399,.01,1,5,"CREATE VALUE")
	;;=S X=$S($D(^IBE(350.9,1,1)):$P(^(1),U,6),1:"")
	;;^DD(399,.01,1,5,"DELETE VALUE")
	;;=NO EFFECT
	;;^DD(399,.01,1,5,"DT")
	;;=2920205
	;;^DD(399,.01,1,5,"FIELD")
	;;=#164
	;;^DD(399,.01,1,6,0)
	;;=^^TRIGGER^399^.13
	;;^DD(399,.01,1,6,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DGCR(399,D0,0)):^(0),1:"") S X=$P(Y(1),U,13),X=X S DIU=X K Y S X=DIV S X=1 X ^DD(399,.01,1,6,1.4)
	;;^DD(399,.01,1,6,1.4)
	;;=S DIH=$S($D(^DGCR(399,DIV(0),0)):^(0),1:""),DIV=X S $P(^(0),U,13)=DIV,DIH=399,DIG=.13 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(399,.01,1,6,2)
	;;=Q
	;;^DD(399,.01,1,6,"CREATE VALUE")
	;;=S X=1
	;;^DD(399,.01,1,6,"DELETE VALUE")
	;;=NO EFFECT
	;;^DD(399,.01,1,6,"FIELD")
	;;=#.13
	;;^DD(399,.01,1,7,0)
	;;=^^TRIGGER^399^.19
	;;^DD(399,.01,1,7,1)
	;;=X ^DD(399,.01,1,7,1.3) I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,0)):^(0),1:"") S X=$P(Y(1),U,19),X=X S DIU=X K Y S X=DIV S X=$P($G(^IBE(350.9,1,1)),U,26) X ^DD(399,.01,1,7,1.4)
	;;^DD(399,.01,1,7,1.3)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X S Y(1)=$S($D(^DGCR(399,D0,0)):^(0),1:"") S X=$S('$D(^IBE(353,+$P(Y(1),U,19),0)):"",1:$P(^(0),U,1))=""
	;;^DD(399,.01,1,7,1.4)
	;;=S DIH=$S($D(^DGCR(399,DIV(0),0)):^(0),1:""),DIV=X S $P(^(0),U,19)=DIV,DIH=399,DIG=.19 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(399,.01,1,7,2)
	;;=Q
	;;^DD(399,.01,1,7,3)
	;;=DO NOT DELETE
	;;^DD(399,.01,1,7,"%D",0)
	;;=^^2^2^2930608^
	;;^DD(399,.01,1,7,"%D",1,0)
	;;=Sets the bill's form type to the site's default form type (350.9,1.26)
