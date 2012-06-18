ACMRAPP ; GENERATED FROM 'ACM RG APPOINTMENT' PRINT TEMPLATE (#1333) ; 07/27/06 ; (FILE 9002241, MARGIN=80)
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
 I $D(DXS)<9 M DXS=^DIPT(1333,"DXS")
 S I(0)="^ACM(41,",J(0)=9002241
 D T Q:'DN  D N D N:$X>4 Q:'DN  W ?4 W "**************************    RECALL DATES    ******************************"
 D N:$X>4 Q:'DN  W ?4 W "RECALL DATE:"
 D N:$X>19 Q:'DN  W ?19 W "PURPOSE:"
 D N:$X>52 Q:'DN  W ?52 W "STATUS    NXT DATE/TIME"
 D N:$X>4 Q:'DN  W ?4 W "-----------"
 D N:$X>19 Q:'DN  W ?19 W "-------"
 D N:$X>52 Q:'DN  W ?52 W "------    -------- ----"
 S DIXX(1)="A1",I(0,0)=D0 S I(0,0)=$S($D(D0):D0,1:"") X DXS(1,9.2) S X="" S D0=I(0,0)
 G A1R
A1 ;
 I $D(DSC(9002249)) X DSC(9002249) E  Q
 W:$X>77 ! S I(100)="^ACM(49,",J(100)=9002249
 D N:$X>4 Q:'DN  W ?4 S DIP(101)=$S($D(^ACM(49,D0,0)):^(0),1:"") S X=$P(DIP(101),U,1) S:X X=$E(X,4,5)_"/"_$E(X,6,7)_"/"_$E(X,2,3) K DIP K:DN Y W X
 S X=$G(^ACM(49,D0,"DT")) D N:$X>19 Q:'DN  W ?19,$E($P(X,U,5),1,30)
 D N:$X>52 Q:'DN  W ?52 S Y=$P(X,U,2) W:Y]"" $S($D(DXS(2,Y)):DXS(2,Y),1:Y)
 D N:$X>62 Q:'DN  W ?62 S DIP(101)=$S($D(^ACM(49,D0,"DT")):^("DT"),1:"") S X=$P(DIP(101),U,1) S:X X=$E(X,4,5)_"/"_$E(X,6,7)_"/"_$E(X,2,3) K DIP K:DN Y W X
 Q
A1R ;
 K J(100),I(100) S:$D(I(0,0)) D0=I(0,0)
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
