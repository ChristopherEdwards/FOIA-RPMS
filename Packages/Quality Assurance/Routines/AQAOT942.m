AQAOT942 ; GENERATED FROM 'AQAO LONG DISPLAY-E1' PRINT TEMPLATE (#1273) ; 05/13/96 ; (continued)
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
 S X=$G(^AQAOC(D0,"FINAL")) S Y=$P(X,U,7) S Y(0)=Y S:Y]"" Y=$P(^AQAO1(3,Y,0),U)_"   "_$P(^(0),U,4) W $E(Y,1,30)
 D N:$X>2 Q:'DN  W ?2 W "Ultimate Pt Outcome: "
 S X=$G(^AQAOC(D0,"FINAL")) S Y=$P(X,U,8) S Y(0)=Y S:Y]"" Y=$P(^AQAO1(3,Y,0),U)_"   "_$P(^(0),U,5) W $E(Y,1,30)
 D N:$X>53 Q:'DN  W ?53 W "Closed By: "
 X DXS(25,9) K DIP K:DN Y W X
 D N:$X>8 Q:'DN  W ?8 W "Final Finding: "
 X DXS(26,9.2) S X=$P(DIP(101),U,2) S D0=I(0,0) K DIP K:DN Y W X
 D N:$X>50 Q:'DN  W ?50 W "Final Action: "
 X DXS(27,9.2) S X=$P(DIP(101),U,2) S D0=I(0,0) K DIP K:DN Y W X
 K Y K DIWF
 Q
HEAD ;
 W !,?0,"K"
 W !,?0,"APCDLOOK"
 W !,"--------------------------------------------------------------------------------",!!
