ACRPFSL ; GENERATED FROM 'ACR FEDSTRIP LOCATION' PRINT TEMPLATE (#3908) ; 09/29/09 ; (FILE 9002193.4, MARGIN=80)
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
 S I(0)="^ACRFSCD(",J(0)=9002193.4
 W ?0 W:$D(IOF) @IOF K DIP K:DN Y
 D T Q:'DN  D N D N:$X>23 Q:'DN  W ?23 W "FEDSTRIP CODING INFORMATION"
 D N:$X>23 Q:'DN  W ?23 W "=============================="
 D N:$X>0 Q:'DN  W ?0 W "FACILITY............:"
 S X=$G(^ACRFSCD(D0,0)) W ?23 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^AUTTLOC(Y,0))#2:$P(^(0),U),1:Y) S Y=$S(Y="":Y,$D(^DIC(4,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,30)
 D N:$X>0 Q:'DN  W ?0 W "REQUISITIONER NUMBER:"
 W ?23,$E($P(X,U,2),1,6)
 D N:$X>0 Q:'DN  W ?0 W "FEDSTRIP FUND CODE..:"
 W ?23,$E($P(X,U,3),1,2)
 D N:$X>0 Q:'DN  W ?0 W "LOCATION DESCRIPTION:"
 W ?23,$E($P(X,U,4),1,15)
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
