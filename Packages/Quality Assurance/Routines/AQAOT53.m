AQAOT53 ; GENERATED FROM 'AQAO IND LISTING' PRINT TEMPLATE (#1276) ; 05/13/96 ; (FILE 9002168.2, MARGIN=80)
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
 I $D(DXS)<9 F X=0:0 S X=$O(^DIPT(1276,"DXS",X)) Q:'X  S Y=$O(^(X,"")) F X=X:0 Q:Y=""  S DXS(X,Y)=^(Y),Y=$O(^(Y))
 D N:$X>0 Q:'DN  W ?0 X DXS(1,9.2) S X=X="ACTIVE",DIP(3)=X S X="",DIP(4)=X S X=1,DIP(5)=X S X="*",X=$S(DIP(3):DIP(4),DIP(5):X) K DIP K:DN Y W $E(X,1,1)
 S X=$G(^AQAO(2,D0,0)) D N:$X>1 Q:'DN  W ?1,$E($P(X,U,1),1,7)
 D N:$X>10 Q:'DN  W ?10,$E($P(X,U,2),1,30)
 D N:$X>42 Q:'DN  W ?42 S Y=$P(X,U,4) W:Y]"" $S($D(DXS(3,Y)):DXS(3,Y),1:Y)
 D N:$X>54 Q:'DN  W ?54 X DXS(2,9) K DIP K:DN Y W $E(X,1,4)
 S I(1)="""QTM""",J(1)=9002168.25 F D1=0:0 Q:$O(^AQAO(2,D0,"QTM",D1))'>0  X:$D(DSC(9002168.25)) DSC(9002168.25) S D1=$O(^(D1)) Q:D1'>0  D:$X>60 T Q:'DN  D A1
 G A1R
A1 ;
 S X=$G(^AQAO(2,D0,"QTM",D1,0)) D N:$X>61 Q:'DN  W ?61 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^AQAO1(1,Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,17)
 Q
A1R ;
 K Y
 Q
HEAD ;
 W !,?10,"INDICATOR",?42,"TYPE",?54,"",?61,"QI TEAMS"
 W !,"--------------------------------------------------------------------------------",!!
