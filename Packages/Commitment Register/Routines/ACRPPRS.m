ACRPPRS ; GENERATED FROM 'ACR PAYROLL SUMMARY' PRINT TEMPLATE (#3872) ; 09/29/09 ; (FILE 9002196, MARGIN=80)
 G BEGIN
CP G CP^DIO2
C S DQ(C)=Y
S S Q(C)=Y*Y+Q(C) S:L(C)>Y L(C)=Y S:H(C)<Y H(C)=Y
P S N(C)=N(C)+1
A S S(C)=S(C)+Y
 Q
D I Y=DITTO(C) S Y="" Q
 S DITTO(C)=Y
 Q
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
 I $D(DXS)<9 M DXS=^DIPT(3872,"DXS")
 S I(0)="^ACRDOC(",J(0)=9002196
 D N:$X>0 Q:'DN  W ?0 W "PAYROLL SUMMARY FOR:"
 S X=$G(^ACRDOC(D0,"PR")) W ?22 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^ACRAU(Y,0))#2:$P(^(0),U),1:Y) S Y=$S(Y="":Y,$D(^VA(200,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,35)
 D N:$X>0 Q:'DN  W ?0 W "--------------------------------------------------------------------------------"
 S DIXX(1)="A1",I(0,0)=D0 S I(0,0)=$S($D(D0):D0,1:"") X DXS(1,9.2) S X="" S D0=I(0,0)
 G A1R
A1 ;
 I $D(DSC(9002193)) X DSC(9002193) E  Q
 W:$X>82 ! S I(100)="^ACRSS(",J(100)=9002193
 D N:$X>4 Q:'DN  W ?4 W "PAY PERIOD (THIS FY):"
 S X=$G(^ACRSS(D0,0)) W ?27 S Y=$P(X,U,1) W:Y]"" $J(Y,4,0)
 W ?33 W $S($P($P(^ACRSS(D0,"NMS"),U,5),"/",2)=1:"SALARY:",1:"BENEFITS:") K DIP K:DN Y
 S X=$G(^ACRSS(D0,"DT")) W ?44 S Y=$P(X,U,4),C=1 D A:Y]"" W:Y]"" $J(Y,13,4)
 Q
A1R ;
 K J(100),I(100) S:$D(I(0,0)) D0=I(0,0)
 W ?59 I IOST["C-" S DIR(0)="E" W ! D ^DIR K DIP K:DN Y
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
