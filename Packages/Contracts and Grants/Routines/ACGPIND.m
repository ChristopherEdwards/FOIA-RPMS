ACGPIND ; GENERATED FROM 'ACG INDIRECT DATA' PRINT TEMPLATE (#4006) ; 10/01/09 ; (FILE 9002330, MARGIN=80)
 G BEGIN
N W !
T W:$X ! I '$D(DIOT(2)),DN,$D(IOSL),$S('$D(DIWF):1,$P(DIWF,"B",2):$P(DIWF,"B",2),1:1)+$Y'<IOSL,$D(^UTILITY($J,1))#2,^(1)?1U1P1E.E X ^(1)
 S DISTP=DISTP+1,DILCT=DILCT+1 D:'(DISTP#100) CSTP^DIO2
 Q
DT I $G(DUZ("LANG"))>1,Y W $$OUT^DIALOGU(Y,"DD") Q
 I Y W $P("JAN^FEB^MAR^APR^MAY^JUN^JUL^AUG^SEP^OCT^NOV^DEC",U,$E(Y,4,5))_" " W:Y#100 $J(Y#100\1,2)_"," W Y\10000+1700 W:Y#1 "  "_$E(Y_0,9,10)_":"_$E(Y_"000",11,12) Q
 W Y Q
M D @DIXX
 Q
BEGIN ;
 S:'$D(DN) DN=1 S DISTP=$G(DISTP),DILCT=$G(DILCT)
 S I(0)="^ACGS(",J(0)=9002330
 D N:$X>0 Q:'DN  W ?0 W "1  BASE AMNT 1: "
 S X=$G(^ACGS(D0,"IC")) S Y=$P(X,U,1) W:Y]"" $J(Y,10,0)
 D N:$X>39 Q:'DN  W ?39 W "5  BASE AMNT 2:"
 S Y=$P(X,U,5) W:Y]"" $J(Y,10,0)
 D N:$X>0 Q:'DN  W ?0 W "2  COST RATE 1: "
 S Y=$P(X,U,2) W:Y]"" $J(Y,7,2)
 D N:$X>39 Q:'DN  W ?39 W "6  COST RATE 2: "
 S Y=$P(X,U,6) W:Y]"" $J(Y,7,2)
 D N:$X>0 Q:'DN  W ?0 W "3  TYPE RATE 1: "
 S DIP(1)=$S($D(^ACGS(D0,"IC")):^("IC"),1:"") S X=$P(DIP(1),U,3),X=X K DIP K:DN Y W X
 D N:$X>39 Q:'DN  W ?39 W "7  TYPE RATE 2: "
 S DIP(1)=$S($D(^ACGS(D0,"IC")):^("IC"),1:"") S X=$P(DIP(1),U,7),X=X K DIP K:DN Y W X
 D N:$X>0 Q:'DN  W ?0 W "4  BASE CODE 1: "
 S DIP(1)=$S($D(^ACGS(D0,"IC")):^("IC"),1:"") S X=$P(DIP(1),U,4),X=X K DIP K:DN Y W X
 D N:$X>39 Q:'DN  W ?39 W "8  BASE CODE 2: "
 S DIP(1)=$S($D(^ACGS(D0,"IC")):^("IC"),1:"") S X=$P(DIP(1),U,8),X=X K DIP K:DN Y W X
 D T Q:'DN  D N W ?0 W "9  BASE AMNT 3: "
 S X=$G(^ACGS(D0,"IC")) S Y=$P(X,U,9) W:Y]"" $J(Y,10,0)
 D N:$X>39 Q:'DN  W ?39 W "13 BASE AMNT 4: "
 S Y=$P(X,U,13) W:Y]"" $J(Y,10,0)
 D N:$X>0 Q:'DN  W ?0 W "10 COST RATE 3: "
 S Y=$P(X,U,10) W:Y]"" $J(Y,4,0)
 D N:$X>39 Q:'DN  W ?39 W "14 COST RATE 4: "
 S Y=$P(X,U,14) W:Y]"" $J(Y,4,0)
 D N:$X>0 Q:'DN  W ?0 W "11 TYPE RATE 3: "
 S DIP(1)=$S($D(^ACGS(D0,"IC")):^("IC"),1:"") S X=$P(DIP(1),U,11),X=X K DIP K:DN Y W X
 D N:$X>39 Q:'DN  W ?39 W "15 TYPE RATE 4: "
 S DIP(1)=$S($D(^ACGS(D0,"IC")):^("IC"),1:"") S X=$P(DIP(1),U,15),X=X K DIP K:DN Y W X
 D N:$X>0 Q:'DN  W ?0 W "12 BASE CODE 3: "
 S DIP(1)=$S($D(^ACGS(D0,"IC")):^("IC"),1:"") S X=$P(DIP(1),U,12),X=X K DIP K:DN Y W X
 D N:$X>39 Q:'DN  W ?39 W "16 BASE CODE 4: "
 S DIP(1)=$S($D(^ACGS(D0,"IC")):^("IC"),1:"") S X=$P(DIP(1),U,16),X=X K DIP K:DN Y W X
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
