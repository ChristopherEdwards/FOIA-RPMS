ADGT51 ; GENERATED FROM 'ADGAUTH' PRINT TEMPLATE (#1514) ; 05/04/99 ; (FILE 9009013.1, MARGIN=80)
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
 I $D(DXS)<9 F X=0:0 S X=$O(^DIPT(1514,"DXS",X)) Q:'X  S Y=$O(^(X,"")) F X=X:0 Q:Y=""  S DXS(X,Y)=^(Y),Y=$O(^(Y))
 S X=$G(^ADGAUTH(D0,0)) W ?0 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^AUPNPAT(Y,0))#2:$P(^(0),U,1),1:Y) S Y=$S(Y="":Y,$D(^DPT(Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,20)
 D N:$X>22 Q:'DN  W ?22 S X=$S($D(^AUPNPAT(D0,41,DUZ(2),0)):$P(^(0),"^",2),1:"") W $J(X,6) K Y(9009013.1,2)
 D N:$X>32 Q:'DN  W ?32 X ^DD(9009013.1,1,9.2) X $P(^DD(9000001,1102.2,0),U,5,99) S Y(9009013.1,1,101)=X S X=Y(9009013.1,1,101) S D0=Y(9009013.1,1,80) S Y=X D DT
 W "("
 X ^DD(9009013.1,1.5,9.2) X $P(^DD(9000001,1102.98,0),U,5,99) S Y(9009013.1,1.5,101)=X S X=Y(9009013.1,1.5,101) S D0=Y(9009013.1,1.5,80) W $E(X,1,7) K Y(9009013.1,1.5)
 W ")"
 D N:$X>54 Q:'DN  W ?54 X ^DD(9009013.1,4,9.2) S Y(9009013.1,4,101)=$S($D(^AUPNPAT(D0,11)):^(11),1:"") S X=$P(Y(9009013.1,4,101),U,18) S D0=Y(9009013.1,4,80) W $E(X,1,20) K Y(9009013.1,4)
 S I(1)=1,J(1)=9009013.13 F D1=0:0 Q:$O(^ADGAUTH(D0,1,D1))'>0  X:$D(DSC(9009013.13)) DSC(9009013.13) S D1=$O(^(D1)) Q:D1'>0  D:$X>76 T Q:'DN  D A1
 G A1R
A1 ;
 D N:$X>0 Q:'DN  W ?0 S DIP(1)=$S($D(^ADGAUTH(D0,1,D1,0)):^(0),1:"") S X=$P(DIP(1),U,1) S:X X=$E(X,4,5)_"/"_$E(X,6,7)_"/"_$E(X,2,3) K DIP K:DN Y W X
 S X=$G(^ADGAUTH(D0,1,D1,0)) D N:$X>11 Q:'DN  W ?11 S Y=$P(X,U,5) W:Y]"" $S($D(DXS(2,Y)):DXS(2,Y),1:Y)
 D N:$X>17 Q:'DN  W ?17 S DIP(1)=$S($D(^ADGAUTH(D0,1,D1,0)):^(0),1:"") S X=$P(DIP(1),U,8) S:X X=$E(X,4,5)_"/"_$E(X,6,7)_"/"_$E(X,2,3) K DIP K:DN Y W X
 D N:$X>27 Q:'DN  W ?27 S DIP(1)=$S($D(^ADGAUTH(D0,1,D1,0)):^(0),1:"") S X=$P(DIP(1),U,11) S:X X=$E(X,4,5)_"/"_$E(X,6,7)_"/"_$E(X,2,3) K DIP K:DN Y W X
 S X=$G(^ADGAUTH(D0,1,D1,0)) D N:$X>37 Q:'DN  W ?37,$E($P(X,U,6),1,3)
 D N:$X>42 Q:'DN  W ?42 X DXS(1,9.3) S X=$S(DIP(2):DIP(3),DIP(4):X) K DIP K:DN Y W $E(X,1,10)
 S X=$G(^ADGAUTH(D0,1,D1,0)) D N:$X>54 Q:'DN  W ?54 S Y=$P(X,U,7) S Y=$S(Y="":Y,$D(^DIC(42,Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,3)
 D N:$X>59 Q:'DN  W ?59 S Y=$P(X,U,13) W:Y]"" $S($D(DXS(3,Y)):DXS(3,Y),1:Y)
 D N:$X>67 Q:'DN  W ?67 S Y=$P(X,U,2) S Y=$S(Y="":Y,$D(^VA(200,Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,12)
 D N:$X>0 Q:'DN  W ?0,$E($P(X,U,9),1,30)
 D N:$X>32 Q:'DN  W ?32,$E($P(X,U,14),1,25)
 D N:$X>67 Q:'DN  W ?67,$E($P(X,U,4),1,12)
 D N:$X>0 Q:'DN  W ?0,$E($P(X,U,10),1,80)
 D N:$X>0 Q:'DN  W ?0 W "  "
 Q
A1R ;
 K Y
 Q
HEAD ;
 W !,?0,"NAME",?24,"HRCN",?32,"DOB/AGE",?54,"COMMUNITY"
 W !,?0,"EXPECTED",?11,"TYPE",?17,"OR DATE",?27,"PKG SENT",?37,"LOS",?42,"SRV/CLINIC",?54,"WARD",?59,"TRAVEL",?67,"PROVIDER"
 W !,?0,"DIAGNOSIS",?32,"PROCEDURE",?67,"REFERRING MD"
 W !,?0,"COMMENTS"
 W !,"--------------------------------------------------------------------------------",!!
