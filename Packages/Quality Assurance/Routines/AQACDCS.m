AQACDCS ; GENERATED FROM 'AQACDAILY.CENSUS' PRINT TEMPLATE (#337) ; 03/01/90 ; (FILE 9002157, MARGIN=80)
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
 Q
DT I Y W $P("JAN^FEB^MAR^APR^MAY^JUN^JUL^AUG^SEP^OCT^NOV^DEC",U,$E(Y,4,5))_" " W:Y#100 $J(Y#100\1,2)_"," W Y\10000+1700 W:Y#1 "  "_$E(Y_0,9,10)_":"_$E(Y_"000",11,12) Q
 W Y Q
M D @DIXX
 Q
BEGIN ;
 S:'$D(DN) DN=1
 I $D(DXS)<9 F X=0:0 S X=$O(^DIPT(337,"DXS",X)) Q:'X  S Y=$O(^(X,"")) F X=X:0 Q:Y=""  S DXS(X,Y)=^(Y),Y=$O(^(Y))
 D N:$X>0 Q:'DN  W ?0 X DXS(1,9.2) S X=$S(DIP(3):DIP(4),DIP(5):X) K DIP,Y W $E(X,1,1)
 D N:$X>2 Q:'DN  W ?2 S X=$S('($D(DUZ(2))#2):"",'DUZ(2):"",'$D(^AUPNPAT($P(^AQACHSAD(D0,0),"^",2),41,DUZ(2),0)):"",1:$P(^AUPNPAT($P(^AQACHSAD(D0,0),"^",2),41,DUZ(2),0),"^",2)) W $J(X,6) K Y(9002157,27)
 S X=$S($D(^AQACHSAD(D0,0)):^(0),1:"") W ?10 S Y=$P(X,U,2) S:Y]"" N(1)=N(1)+1 S Y=$S(Y="":Y,$D(^AUPNPAT(Y,0))#2:$P(^(0),U,1),1:Y) S Y=$S(Y="":Y,$D(^DPT(Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,20)
 W ?32 S DIP(1)=$S($D(^AQACHSAD(D0,0)):^(0),1:"") S X=$P(DIP(1),U,1) S:X X=$E(X,4,5)_"/"_$E(X,6,7)_"/"_$E(X,2,3) K DIP,Y W $E(X,1,8)
 S X=$S($D(^AQACHSAD(D0,0)):^(0),1:"") W ?42 S Y=$P(X,U,7) W:Y]"" $J(Y,3,0)
 W ?47 X ^DD(9002157,3,9.6) S X=$S(Y(9002157,3,3):Y(9002157,3,4),Y(9002157,3,5):Y(9002157,3,6),Y(9002157,3,7):Y(9002157,3,8),Y(9002157,3,9):Y(9002157,3,11),Y(9002157,3,12):X) S X=$J(X,0,0) W:X'?."*" $J(X,3,0) K Y(9002157,3)
 S X=$S($D(^AQACHSAD(D0,0)):^(0),1:"") W ?52 S Y=$P(X,U,8) W:Y]"" $S($D(DXS(5,Y)):DXS(5,Y),1:Y)
 W ?61 X DXS(2,9) K DIP,Y W X
 S X=$S($D(^AQACHSAD(D0,0)):^(0),1:"") W ?72 S Y=$P(X,U,14) W:Y]"" $S($D(DXS(6,Y)):DXS(6,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 S Y=$P(X,U,17) W:Y]"" $S($D(DXS(7,Y)):DXS(7,Y),1:Y)
 D N:$X>10 Q:'DN  W ?10,$E($P(X,U,15),1,20)
 W ?32,$E($P(X,U,5),1,27)
 W ?61 X DXS(3,9.2) S X=$S('$D(^AUTTTRI(+$P(DIP(101),U,8),0)):"",1:$P(^(0),U,1)) S D0=I(0,0) K DIP,Y W $E(X,1,14)
 D N:$X>61 Q:'DN  W ?61 W "NRD: "
 S DIP(1)=$S($D(^AQACHSAD(D0,2)):^(2),1:"") S X=$P(DIP(1),U,3) S:X X=$E(X,4,5)_"/"_$E(X,6,7)_"/"_$E(X,2,3) K DIP,Y W $E(X,1,8)
 D N:$X>0 Q:'DN  W ?0 W "IND. FOR"
 D N:$X>61 Q:'DN  W ?61 W "AGE: "
 X ^DD(9002157,18,9.2) S X=X\365.25 S X=$J(X,0,0) W $E(X,1,3) K Y(9002157,18)
 D N:$X>0 Q:'DN  W ?0 W "EXT STAY:"
 D N:$X>10 Q:'DN  W ?10 X DXS(4,9) K DIP,Y W $E(X,1,69)
 K Y
 Q
HEAD ;
 W !,?42,"LOS",?47,"LOS",?61,"REFERRING",?72,"3RD"
 W !,?4,"HR #",?10,"NAME",?32,"DATE ADM",?42,"75%",?47,"ACT",?52,"SERVICE",?61,"PHYSICIAN",?72,"PTY"
 W !,?0,"CHS APP",?10,"CHS PHYSICIAN",?32,"DIAGNOSIS OR TREATMENT",?61,"TRIBE"
 W !,"--------------------------------------------------------------------------------",!!
