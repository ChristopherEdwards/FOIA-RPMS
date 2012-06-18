AQAOT55 ; GENERATED FROM 'AQAO OPEN CASES' PRINT TEMPLATE (#1289) ; 05/13/96 ; (FILE 9002167, MARGIN=80)
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
 I $D(DXS)<9 F X=0:0 S X=$O(^DIPT(1289,"DXS",X)) Q:'X  S Y=$O(^(X,"")) F X=X:0 Q:Y=""  S DXS(X,Y)=^(Y),Y=$O(^(Y))
 S X=$G(^AQAOC(D0,0)) W:$X>8 ! D N:$X>0 Q:'DN  W ?0 S Y=$P(X,U,1) S:Y]"" N(1)=N(1)+1 W $E(Y,1,7)
 W ?9 S Y=$P(X,U,4) D DT
 S APCDLOOK=DUZ(2) K DIP K:DN Y
 W ?22 X DXS(1,9.3) S DIP(202)=$S($D(^AUPNPAT(D0,41,D1,0)):^(0),1:"") S X=$P(DIP(202),U,2) S D0=I(0,0) S D1=I(101,0) K DIP K:DN Y W $J(X,6)
 K APCDLOOK K DIP K:DN Y
 S X=$G(^AQAOC(D0,0)) W ?31 S Y=$P(X,U,8) S Y=$S(Y="":Y,$D(^AQAO(2,Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,7)
 W ?42 X DXS(2,9.2) S DIP(101)=$S($D(^AUPNVSIT(D0,0)):^(0),1:"") S X=$P($P(DIP(102),$C(59)_$P(DIP(101),U,7)_":",2),$C(59),1) S D0=I(0,0) K DIP K:DN Y W $E(X,1,3)
 W "/"
 X DXS(3,9.2) S X=$P(DIP(101),U,2) S D0=I(0,0) K DIP K:DN Y W $E(X,1,4)
 S X=$G(^AQAOC(D0,0)) D N:$X>54 Q:'DN  W ?54,$E(0,1,24)
 D N:$X>4 Q:'DN  W ?4 W "LAST REVIEW:"
 S D1=0 K DIP K:DN Y
 D N:$X>17 Q:'DN  W ?17 X DXS(4,9) K DIP K:DN Y W $E(X,1,10)
 D N:$X>29 Q:'DN  W ?29 X DXS(5,9) K DIP K:DN Y W X
 D N:$X>39 Q:'DN  W ?39 W "ACTION:"
 D N:$X>47 Q:'DN  W ?47 X DXS(6,9) K DIP K:DN Y W $E(X,1,31)
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 W " "
 K Y
 Q
HEAD ;
 W !,?0,"CASE #",?9,"OCC DATE",?22,"PATIENT",?31,"INDICATOR",?42,"VISIT/SRV"
 W !,"--------------------------------------------------------------------------------",!!
