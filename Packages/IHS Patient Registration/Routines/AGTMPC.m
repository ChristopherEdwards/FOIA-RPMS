AGTMPC ; GENERATED FROM 'AG TM COVERAGE TYPE' PRINT TEMPLATE (#667) ; 02/14/06 ; (FILE 9999999.65, MARGIN=80)
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
 I $D(DXS)<9 M DXS=^DIPT(667,"DXS")
 S I(0)="^AUTTPIC(",J(0)=9999999.65
 S X=$G(^AUTTPIC(D0,0)) W ?0 S Y=$P(X,U,2) S Y=$S(Y="":Y,$D(^AUTNINS(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,30)
 W ?32,$E($P(X,U,1),1,30)
 W ?64,$E($P(X,U,3),1,3)
 W ?70 S Y=$P(X,U,4) W:Y]"" $S($D(DXS(1,Y)):DXS(1,Y),1:Y)
 K Y
 Q
HEAD ;
 W !,?64,"PLAN",?70,"PLAN"
 W !,?0,"INSURER",?32,"NAME",?64,"CODE",?70,"TYPE"
 W !,"--------------------------------------------------------------------------------",!!
