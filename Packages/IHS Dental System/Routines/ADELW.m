ADELW ; GENERATED FROM 'ADEFPWS' PRINT TEMPLATE (#2159) ; 06/04/99 ; (FILE 9002004, MARGIN=80)
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
 I $D(DXS)<9 F X=0:0 S X=$O(^DIPT(2159,"DXS",X)) Q:'X  S Y=$O(^(X,"")) F X=X:0 Q:Y=""  S DXS(X,Y)=^(Y),Y=$O(^(Y))
 S X=$G(^ADEWS(D0,0)) W ?0,$E($P(X,U,1),1,30)
 W ?32,$E($P(X,U,2),1,7)
 W ?41,$E($P(X,U,3),1,3)
 W ?48 S Y=$P(X,U,4) W:Y]"" $J(Y,5,2)
 W ?55 S Y=$P(X,U,5) W:Y]"" $S($D(DXS(1,Y)):DXS(1,Y),1:Y)
 W ?60 S Y=$P(X,U,6) S Y=$S(Y="":Y,$D(^AUTTCOM(Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,15)
 W ?77 S Y=$P(X,U,8) W:Y]"" $S($D(DXS(2,Y)):DXS(2,Y),1:Y)
 K Y
 Q
HEAD ;
 W !,?32,"SFC",?50,"NAT",?55,"OPT",?77,"I"
 W !,?0,"NAME",?32,"CODE",?41,"ABREV",?50,"CON",?55,"CON",?60,"COMMUNITY",?77,"N"
 W !,"--------------------------------------------------------------------------------",!!
