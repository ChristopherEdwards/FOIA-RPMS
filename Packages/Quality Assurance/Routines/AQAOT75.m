AQAOT75 ; GENERATED FROM 'AQAO SEVERITY LIST' PRINT TEMPLATE (#1287) ; 05/13/96 ; (FILE 9002169.3, MARGIN=80)
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
 I $D(DXS)<9 F X=0:0 S X=$O(^DIPT(1287,"DXS",X)) Q:'X  S Y=$O(^(X,"")) F X=X:0 Q:Y=""  S DXS(X,Y)=^(Y),Y=$O(^(Y))
 D N:$X>24 Q:'DN  W ?24 W "LEVEL: "
 S X=$G(^AQAO1(3,D0,0)) S Y=$P(X,U,1) W:Y]"" $J(Y,2,0)
 D N:$X>39 Q:'DN  W ?39 X DXS(1,9.2) S X=X="INACTIVE",DIP(3)=X S X="(INACTIVE)",DIP(4)=X S X=1,DIP(5)=X S X="",X=$S(DIP(3):DIP(4),DIP(5):X) K DIP K:DN Y W X
 D N:$X>1 Q:'DN  W ?1 W "POTENTIAL OF ADVERSE OUTCOME:  "
 S X=$G(^AQAO1(3,D0,0)) W ?0,$E($P(X,U,2),1,48)
 D N:$X>0 Q:'DN  W ?0 W "ADVERSE OUTCOME OF OCCURRENCE:  "
 W ?0,$E($P(X,U,4),1,48)
 D N:$X>5 Q:'DN  W ?5 W "ULTIMATE PATIENT OUTCOME:  "
 W ?0,$E($P(X,U,5),1,48)
 D N:$X>12 Q:'DN  W ?12 W "PERFORMANCE LEVEL:  "
 W ?0,$E($P(X,U,6),1,48)
 D T Q:'DN  D N W ?0 W " "
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
