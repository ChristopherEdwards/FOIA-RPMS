AQAOT59 ; GENERATED FROM 'AQAO AUDIT LIST' PRINT TEMPLATE (#1311) ; 05/13/96 ; (FILE 9002166.3, MARGIN=80)
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
 I $D(DXS)<9 F X=0:0 S X=$O(^DIPT(1311,"DXS",X)) Q:'X  S Y=$O(^(X,"")) F X=X:0 Q:Y=""  S DXS(X,Y)=^(Y),Y=$O(^(Y))
 S X=$G(^AQAGU(D0,0)) D N:$X>0 Q:'DN  W ?0 S Y=$P(X,U,1) D DT
 W ?20 S Y=$P(X,U,2) S Y=$S(Y="":Y,$D(^AQAOC(Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,7)
 W ?32 X DXS(1,9) K DIP K:DN Y W $E(X,1,4)
 S X=$G(^AQAGU(D0,0)) W ?38 S Y=$P(X,U,4) W:Y]"" $S($D(DXS(2,Y)):DXS(2,Y),1:Y)
 W ?46,$E($P(X,U,5),1,30)
 K Y
 Q
HEAD ;
 W !,?0,"AUDIT DATE & TIME",?20,"OCCURRENCE",?32,"USER",?38,"ACTION",?46,"COMMENT"
 W !,"--------------------------------------------------------------------------------",!!
