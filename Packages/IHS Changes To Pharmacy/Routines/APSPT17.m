APSPT17 ; GENERATED FROM 'APSP PCV REPORT' PRINT TEMPLATE (#496) ; 02/14/03 ; (FILE 9009032.6, MARGIN=80)
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
 I $D(DXS)<9 F X=0:0 S X=$O(^DIPT(496,"DXS",X)) Q:'X  S Y=$O(^(X,"")) F X=X:0 Q:Y=""  S DXS(X,Y)=^(Y),Y=$O(^(Y))
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 W "VISIT DATE:"
 S X=$G(^APSPQA(32.6,D0,0)) D N:$X>15 Q:'DN  W ?15 S Y=$P(X,U,1) S:Y]"" N(1)=N(1)+1 D DT
 D N:$X>39 Q:'DN  W ?39 W "PATIENT:"
 D N:$X>50 Q:'DN  W ?50 S Y=$P(X,U,2) S Y=$S(Y="":Y,$D(^DPT(Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,30)
 D N:$X>0 Q:'DN  W ?0 W "PHARMACIST:"
 D N:$X>15 Q:'DN  W ?15 S Y=$P(X,U,3) S Y=$S(Y="":Y,$D(^DIC(3,Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,35)
 D N:$X>39 Q:'DN  W ?39 W "TYPE OF VISIT:"
 D N:$X>54 Q:'DN  W ?54 S Y=$P(X,U,4) W:Y]"" $S($D(DXS(1,Y)):DXS(1,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "ASSESTMENT:"
 S I(1)=11,J(1)=9009032.6011 F D1=0:0 Q:$O(^APSPQA(32.6,D0,11,D1))'>0  X:$D(DSC(9009032.6011)) DSC(9009032.6011) S D1=$O(^(D1)) Q:D1'>0  D:$X>13 T Q:'DN  D A1
 G A1R
A1 ;
 S X=$G(^APSPQA(32.6,D0,11,D1,0)) D N:$X>15 Q:'DN  W ?15 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^APSPQA(32.7,Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,50)
 Q
A1R ;
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
