ACRPSSA ; GENERATED FROM 'ACR SUB-SUB-ACTIVITY' PRINT TEMPLATE (#3927) ; 09/29/09 ; (FILE 9999999.56, MARGIN=80)
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
 S I(0)="^AUTTSSA(",J(0)=9999999.56
 D N:$X>4 Q:'DN  W ?4 W "CODE............:"
 S X=$G(^AUTTSSA(D0,0)) W ?23,$E($P(X,U,1),1,2)
 D N:$X>4 Q:'DN  W ?4 W "NAME............:"
 W ?23,$E($P(X,U,2),1,30)
 D N:$X>4 Q:'DN  W ?4 W "SUB-SUB-ACT. NO.:"
 W ?23,$E($P(X,U,3),1,8)
 D N:$X>4 Q:'DN  W ?4 W "ABBREVIATION....:"
 W ?23,$E($P(X,U,4),1,10)
 D N:$X>4 Q:'DN  W ?4 W "BUDGET ACTIVITY.:"
 S X=$G(^AUTTSSA(D0,"DT")) W ?23 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^AUTTBA(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,2)
 D N:$X>4 Q:'DN  W ?4 W "SUB-ACTIVITY....:"
 W ?23 S Y=$P(X,U,2) S Y=$S(Y="":Y,$D(^AUTTSA(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,2)
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
