AQAOT86 ; GENERATED FROM 'AQAO QUICK CRITERIA' PRINT TEMPLATE (#1303) ; 05/13/96 ; (FILE 9002168.2, MARGIN=80)
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
 I $D(DXS)<9 F X=0:0 S X=$O(^DIPT(1303,"DXS",X)) Q:'X  S Y=$O(^(X,"")) F X=X:0 Q:Y=""  S DXS(X,Y)=^(Y),Y=$O(^(Y))
 D N:$X>0 Q:'DN  W ?0 W "INDICATOR:  "
 S X=$G(^AQAO(2,D0,0)) W ?0,$E($P(X,U,1),1,7)
 D N:$X>29 Q:'DN  W ?29,$E($P(X,U,2),1,30)
 D T Q:'DN  D N D N:$X>29 Q:'DN  W ?29 W "REVIEW CRITERIA"
 D N:$X>29 Q:'DN  W ?29 W "---------------"
 S DIXX(1)="A1",I(0,0)=D0 S I(0,0)=$S($D(D0):D0,1:"") X DXS(1,9.2) S X="" S D0=I(0,0)
 G A1R
A1 ;
 I $D(DSC(9002169.6)) X DSC(9002169.6) E  Q
 W:$X>29 ! S I(100)="^AQAO1(6,",J(100)=9002169.6
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 S X="CR"_$S('$D(D0):"",D0<0:"",1:D0) K DIP K:DN Y W X
 S X=$G(^AQAO1(6,D0,0)) D N:$X>7 Q:'DN  W ?7,$E($P(X,U,1),1,60)
 D N:$X>69 Q:'DN  W ?69 S Y=$P(X,U,2) W:Y]"" $S($D(DXS(4,Y)):DXS(4,Y),1:Y)
 D N:$X>64 Q:'DN  W ?64 X DXS(2,9.3) S X=$S(DIP(103):DIP(104),DIP(105):X) K DIP K:DN Y W X
 S I(101)="""CD""",J(101)=9002169.61 F D1=0:0 Q:$O(^AQAO1(6,D0,"CD",D1))'>0  X:$D(DSC(9002169.61)) DSC(9002169.61) S D1=$O(^(D1)) Q:D1'>0  D:$X>64 T Q:'DN  D A2
 G A2R
A2 ;
 S X=$G(^AQAO1(6,D0,"CD",D1,0)) D N:$X>2 Q:'DN  W ?2 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^AQAO1(4,Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,6)
 D N:$X>9 Q:'DN  W ?9 X DXS(3,9.2) S DIP(201)=$S($D(^AQAO1(4,D0,0)):^(0),1:"") S X=$P(DIP(201),U,2) S D0=I(100,0) S D1=I(101,0) K DIP K:DN Y W X
 Q
A2R ;
 Q
A1R ;
 K J(100),I(100) S:$D(I(0,0)) D0=I(0,0)
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
