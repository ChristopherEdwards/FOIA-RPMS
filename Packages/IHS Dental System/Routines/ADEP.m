ADEP ; GENERATED FROM 'ADEPADA' PRINT TEMPLATE (#2163) ; 06/04/99 ; (FILE 9999999.31, MARGIN=80)
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
 I $D(DXS)<9 F X=0:0 S X=$O(^DIPT(2163,"DXS",X)) Q:'X  S Y=$O(^(X,"")) F X=X:0 Q:Y=""  S DXS(X,Y)=^(Y),Y=$O(^(Y))
 S X=$G(^AUTTADA(D0,0)) W ?0,$E($P(X,U,1),1,4)
 W ?6,$E($P(X,U,5),1,3)
 W ?11,$E($P(X,U,4),1,3)
 W ?16 X DXS(1,9.2) S DIP(101)=$S($D(^ADEFEE(D0,0)):^(0),1:"") S X=$P(DIP(101),U,2) S D0=I(0,0) K DIP K:DN Y W $E(X,1,7)
 S X=$G(^AUTTADA(D0,0)) W ?25,$E($P(X,U,2),1,44)
 S X=$G(^AUTTADA(D0,88)) W ?71,$E($P(X,U,1),1,5)
 K Y
 Q
HEAD ;
 W !,?11,"EST",?71,"MNE-"
 W !,?0,"CODE",?6,"LVL",?11,"MIN",?16,"FEE",?25,"DESCRIPTION",?71,"MONIC"
 W !,"--------------------------------------------------------------------------------",!!
