AQAOT90 ; GENERATED FROM 'AQAO USER INQ' PRINT TEMPLATE (#1307) ; 05/13/96 ; (FILE 9002168.9, MARGIN=80)
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
 I $D(DXS)<9 F X=0:0 S X=$O(^DIPT(1307,"DXS",X)) Q:'X  S Y=$O(^(X,"")) F X=X:0 Q:Y=""  S DXS(X,Y)=^(Y),Y=$O(^(Y))
 S X=$G(^AQAO(9,D0,0)) D N:$X>34 Q:'DN  W ?34 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^VA(200,Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,30)
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 W "QI STAFF MEMBER?  "
 X DXS(1,9.3) S X=$S(DIP(3):DIP(4),DIP(5):X) K DIP K:DN Y W X
 D N:$X>0 Q:'DN  W ?0 W "ACCESS TO CAPTURE DATA IN ASCII FORMAT?  "
 S X=$G(^AQAO(9,D0,0)) S Y=$P(X,U,7) W:Y]"" $S($D(DXS(2,Y)):DXS(2,Y),1:Y)
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 W "  "
 S I(1)="""TM""",J(1)=9002168.91 F D1=0:0 Q:$O(^AQAO(9,D0,"TM",D1))'>0  X:$D(DSC(9002168.91)) DSC(9002168.91) S D1=$O(^(D1)) Q:D1'>0  D:$X>4 T Q:'DN  D A1
 G A1R
A1 ;
 D N:$X>14 Q:'DN  W ?14 W "TEAM:  "
 S X=$G(^AQAO(9,D0,"TM",D1,0)) S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^AQAO1(1,Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,30)
 D N:$X>39 Q:'DN  W ?39 W "ACCESS LEVEL:  "
 S Y=$P(X,U,2) W:Y]"" $S($D(DXS(3,Y)):DXS(3,Y),1:Y)
 Q
A1R ;
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
