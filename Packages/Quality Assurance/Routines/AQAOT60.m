AQAOT60 ; GENERATED FROM 'AQAO COMMITTEE LIST' PRINT TEMPLATE (#1285) ; 05/13/96 ; (FILE 9002169.1, MARGIN=80)
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
 I $D(DXS)<9 F X=0:0 S X=$O(^DIPT(1285,"DXS",X)) Q:'X  S Y=$O(^(X,"")) F X=X:0 Q:Y=""  S DXS(X,Y)=^(Y),Y=$O(^(Y))
 S X=$G(^AQAO1(1,D0,0)) W ?0,$E($P(X,U,1),1,30)
 W ?32,$E($P(X,U,2),1,5)
 W ?39 S Y=$P(X,U,4) W:Y]"" $S($D(DXS(2,Y)):DXS(2,Y),1:Y)
 S I(1)=1,J(1)=9002169.12 F D1=0:0 Q:$O(^AQAO1(1,D0,1,D1))'>0  X:$D(DSC(9002169.12)) DSC(9002169.12) S D1=$O(^(D1)) Q:D1'>0  D:$X>57 T Q:'DN  D A1
 G A1R
A1 ;
 W ?57 X DXS(1,9.2) S DIP(101)=$S($D(^DIC(49,D0,0)):^(0),1:"") S X=$P(DIP(101),U,2) S D0=I(0,0) S D1=I(1,0) K DIP K:DN Y W X
 Q
A1R ;
 S X=$G(^AQAO1(1,D0,0)) W ?68 S Y=$P(X,U,3) W:Y]"" $S($D(DXS(3,Y)):DXS(3,Y),1:Y)
 K Y
 Q
HEAD ;
 W !,?0,"NAME",?32,"ABBRV",?39,"TYPE",?57,"AFF SRV",?68,"INACTIVE?"
 W !,"--------------------------------------------------------------------------------",!!
