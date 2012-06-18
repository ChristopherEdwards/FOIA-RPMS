ACMRMS ; GENERATED FROM 'ACM RG MEASUREMENTS' PRINT TEMPLATE (#1432) ; 05/13/96 ; (FILE 9002241, MARGIN=80)
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
 I $D(DXS)<9 F X=0:0 S X=$O(^DIPT(1432,"DXS",X)) Q:'X  S Y=$O(^(X,"")) F X=X:0 Q:Y=""  S DXS(X,Y)=^(Y),Y=$O(^(Y))
 D T Q:'DN  D N D N:$X>4 Q:'DN  W ?4 W "*************************    MEASUREMENTS    *******************************"
 D N:$X>4 Q:'DN  W ?4 W "MEASUREMENT"
 D N:$X>37 Q:'DN  W ?37 W "VALUE"
 D N:$X>59 Q:'DN  W ?59 W "DATE OF MEASUREMENT"
 D N:$X>4 Q:'DN  W ?4 W "-------------------------------"
 D N:$X>37 Q:'DN  W ?37 W "----------          ---------------------"
 S DIXX(1)="A1",I(0,0)=D0 S I(0,0)=$S($D(D0):D0,1:"") X DXS(1,9.2) S X="" S D0=I(0,0)
 G A1R
A1 ;
 I $D(DSC(9002257)) X DSC(9002257) E  Q
 W:$X>80 ! S I(100)="^ACM(57,",J(100)=9002257
 S X=$G(^ACM(57,D0,0)) D N:$X>4 Q:'DN  W ?4 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^AUTTMSR(Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,30)
 D N:$X>37 Q:'DN  W ?37,$E($P(X,U,5),1,30)
 W ?69 S DIP(101)=$S($D(^ACM(57,D0,0)):^(0),1:"") S X=$P(DIP(101),U,7) S:X X=$E(X,4,5)_"/"_$E(X,6,7)_"/"_$E(X,2,3) K DIP K:DN Y W X
 Q
A1R ;
 K J(100),I(100) S:$D(I(0,0)) D0=I(0,0)
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
