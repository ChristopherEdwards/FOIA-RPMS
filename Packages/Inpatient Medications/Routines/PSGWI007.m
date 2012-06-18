PSGWI007 ; ; 04-JAN-1994
 ;;2.3; Automatic Replenishment/Ward Stock ;;4 JAN 94
 Q:'DIFQ(58.1)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^DD(58.11,30,1,1,2)
 ;;=K ^PSI(58.1,DA(1),1,DA,"I",X)
 ;;^DD(58.11,30,1,1,"%D",0)
 ;;=^^1^1^2930827^
 ;;^DD(58.11,30,1,1,"%D",1,0)
 ;;=This cross-reference sets or deletes the "I" node for a stock item.
 ;;^DD(58.11,30,1,2,0)
 ;;=^^TRIGGER^58.11^34
 ;;^DD(58.11,30,1,2,1)
 ;;=K DIV S DIV=X,D0=DA(1),DIV(0)=D0,D1=DA,DIV(1)=D1 S Y(1)=$S($D(^PSI(58.1,D0,1,D1,0)):^(0),1:"") S X=$P(Y(1),U,10),X=X S DIU=X K Y S X=DIV S X="Y" X ^DD(58.11,30,1,2,1.4)
 ;;^DD(58.11,30,1,2,1.4)
 ;;=S DIH=$S($D(^PSI(58.1,DIV(0),1,DIV(1),0)):^(0),1:""),DIV=X X "F %=0:0 Q:$L($P(DIH,U,9,99))  S DIH=DIH_U" S %=$P(DIH,U,11,999),DIU=$P(DIH,U,10),^(0)=$P(DIH,U,1,9)_U_DIV_$S(%]"":U_%,1:""),DIH=58.11,DIG=34 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
 ;;^DD(58.11,30,1,2,2)
 ;;=K DIV S DIV=X,D0=DA(1),DIV(0)=D0,D1=DA,DIV(1)=D1 S Y(1)=$S($D(^PSI(58.1,D0,1,D1,0)):^(0),1:"") S X=$P(Y(1),U,10),X=X S DIU=X K Y S X=DIV S X="N" X ^DD(58.11,30,1,2,2.4)
 ;;^DD(58.11,30,1,2,2.4)
 ;;=S DIH=$S($D(^PSI(58.1,DIV(0),1,DIV(1),0)):^(0),1:""),DIV=X X "F %=0:0 Q:$L($P(DIH,U,9,99))  S DIH=DIH_U" S %=$P(DIH,U,11,999),DIU=$P(DIH,U,10),^(0)=$P(DIH,U,1,9)_U_DIV_$S(%]"":U_%,1:""),DIH=58.11,DIG=34 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
 ;;^DD(58.11,30,1,2,"%D",0)
 ;;=^^2^2^2930827^
 ;;^DD(58.11,30,1,2,"%D",1,0)
 ;;=This cross-reference sets the field INACTIVE DATE FLAG (58.11,34) to "YES"
 ;;^DD(58.11,30,1,2,"%D",2,0)
 ;;=or "NO".
 ;;^DD(58.11,30,1,2,"CREATE VALUE")
 ;;="Y"
 ;;^DD(58.11,30,1,2,"DELETE VALUE")
 ;;="N"
 ;;^DD(58.11,30,1,2,"FIELD")
 ;;=INACTIVE DATE FLAG
 ;;^DD(58.11,30,1,3,0)
 ;;=58.1^AD^MUMPS
 ;;^DD(58.11,30,1,3,1)
 ;;=I $D(^PSI(58.1,DA(1),1,DA,0)),^(0) S PSGWDRG=+^(0) F W=0:0 S W=$O(^PSI(58.1,DA(1),1,DA,4,W)) Q:'W  K:$P(^PSI(58.1,DA(1),1,DA,0),"^",3)=DT!($P(^(0),"^",3)<DT) ^PSI(58.1,"D",PSGWDRG,W,DA(1))
 ;;^DD(58.11,30,1,3,2)
 ;;=I $D(^PSI(58.1,DA(1),1,DA,0)),^(0) S PSGWDRG=+^(0) F W=0:0 S W=$O(^PSI(58.1,DA(1),1,DA,4,W)) Q:'W  S ^PSI(58.1,"D",PSGWDRG,W,DA(1))=""
 ;;^DD(58.11,30,1,3,"%D",0)
 ;;=^^3^3^2930827^
 ;;^DD(58.11,30,1,3,"%D",1,0)
 ;;=This cross-reference will delete the "D" cross reference on the field
 ;;^DD(58.11,30,1,3,"%D",2,0)
 ;;=WARD (FOR ITEM) for a stock item that has been inactivated. If the
 ;;^DD(58.11,30,1,3,"%D",3,0)
 ;;=INACTIVATION DATE is deleted, the "D" cross-reference is reset.
 ;;^DD(58.11,30,1,3,"DT")
 ;;=2930519
 ;;^DD(58.11,30,1,4,0)
 ;;=^^TRIGGER^58.11^31
 ;;^DD(58.11,30,1,4,1)
 ;;=Q
 ;;^DD(58.11,30,1,4,2)
 ;;=K DIV S DIV=X,D0=DA(1),DIV(0)=D0,D1=DA,DIV(1)=D1 S Y(1)=$S($D(^PSI(58.1,D0,1,D1,0)):^(0),1:"") S X=$P(Y(1),U,4),X=X S DIU=X K Y S X="" X ^DD(58.11,30,1,4,2.4)
 ;;^DD(58.11,30,1,4,2.4)
 ;;=S DIH=$S($D(^PSI(58.1,DIV(0),1,DIV(1),0)):^(0),1:""),DIV=X X "F %=0:0 Q:$L($P(DIH,U,3,99))  S DIH=DIH_U" S %=$P(DIH,U,5,999),DIU=$P(DIH,U,4),^(0)=$P(DIH,U,1,3)_U_DIV_$S(%]"":U_%,1:""),DIH=58.11,DIG=31 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
 ;;^DD(58.11,30,1,4,"%D",0)
 ;;=^^2^2^2930827^
 ;;^DD(58.11,30,1,4,"%D",1,0)
 ;;=This cross-reference will delete the field INACTIVATION REASON (58.11,31)
 ;;^DD(58.11,30,1,4,"%D",2,0)
 ;;=if the INACTIVATION DATE is deleted.
 ;;^DD(58.11,30,1,4,"CREATE VALUE")
 ;;=NO EFFECT
 ;;^DD(58.11,30,1,4,"DELETE VALUE")
 ;;=@
 ;;^DD(58.11,30,1,4,"FIELD")
 ;;=INACTIVATION REASON
 ;;^DD(58.11,30,1,5,0)
 ;;=^^TRIGGER^58.11^33
 ;;^DD(58.11,30,1,5,1)
 ;;=Q
 ;;^DD(58.11,30,1,5,2)
 ;;=K DIV S DIV=X,D0=DA(1),DIV(0)=D0,D1=DA,DIV(1)=D1 S Y(1)=$S($D(^PSI(58.1,D0,1,D1,0)):^(0),1:"") S X=$P(Y(1),U,9),X=X S DIU=X K Y S X="" X ^DD(58.11,30,1,5,2.4)
 ;;^DD(58.11,30,1,5,2.4)
 ;;=S DIH=$S($D(^PSI(58.1,DIV(0),1,DIV(1),0)):^(0),1:""),DIV=X X "F %=0:0 Q:$L($P(DIH,U,8,99))  S DIH=DIH_U" S %=$P(DIH,U,10,999),DIU=$P(DIH,U,9),^(0)=$P(DIH,U,1,8)_U_DIV_$S(%]"":U_%,1:""),DIH=58.11,DIG=33 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
 ;;^DD(58.11,30,1,5,"%D",0)
 ;;=^^2^2^2930827^
 ;;^DD(58.11,30,1,5,"%D",1,0)
 ;;=This cross-reference will delete the field INACTIVATION REASON (OTHER)
 ;;^DD(58.11,30,1,5,"%D",2,0)
 ;;=(58.11,33) if the INACTIVATION DATE is deleted.
 ;;^DD(58.11,30,1,5,"CREATE VALUE")
 ;;=NO EFFECT
 ;;^DD(58.11,30,1,5,"DELETE VALUE")
 ;;=@
