ACMRCMP ; GENERATED FROM 'ACM RG COMPLICATIONS' PRINT TEMPLATE (#1331) ; 05/13/96 ; (FILE 9002241, MARGIN=80)
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
 I $D(DXS)<9 F X=0:0 S X=$O(^DIPT(1331,"DXS",X)) Q:'X  S Y=$O(^(X,"")) F X=X:0 Q:Y=""  S DXS(X,Y)=^(Y),Y=$O(^(Y))
 D T Q:'DN  D N D N:$X>4 Q:'DN  W ?4 W "*************************    COMPLICATIONS     *****************************"
 D N:$X>4 Q:'DN  W ?4 W "COMPLICATION"
 D N:$X>36 Q:'DN  W ?36 W "ONSET DATE"
 D N:$X>51 Q:'DN  W ?51 W "STATUS"
 D N:$X>4 Q:'DN  W ?4 W "---------------------------"
 D N:$X>36 Q:'DN  W ?36 W "----------"
 D N:$X>51 Q:'DN  W ?51 W "--------------------"
 S DIXX(1)="A1",I(0,0)=D0 S I(0,0)=$S($D(D0):D0,1:"") X DXS(1,9.2) S X="" S D0=I(0,0)
 G A1R
A1 ;
 I $D(DSC(9002242)) X DSC(9002242) E  Q
 W:$X>73 ! S I(100)="^ACM(42,",J(100)=9002242
 S X=$G(^ACM(42,D0,0)) D N:$X>4 Q:'DN  W ?4 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^ACM(42.1,Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,30)
 S X=$G(^ACM(42,D0,"DT")) D N:$X>36 Q:'DN  W ?36 S Y=$P(X,U,1) S Y(0)=Y S X=Y(0) S:X X=$E(X,4,5)_"/"_$E(X,6,7)_"/"_$E(X,2,3) S Y=X W $E(Y,1,30)
 D N:$X>54 Q:'DN  W ?54 X ^DD(9002242,4,9.2) S Y(9002242,4,101)=$S($D(^ACM(42.3,D0,0)):^(0),1:"") S X=$P(Y(9002242,4,101),U,1) S D0=Y(9002242,4,80) W $E(X,1,20) K Y(9002242,4)
 Q
A1R ;
 K J(100),I(100) S:$D(I(0,0)) D0=I(0,0)
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
