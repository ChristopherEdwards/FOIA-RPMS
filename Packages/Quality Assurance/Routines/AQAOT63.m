AQAOT63 ; GENERATED FROM 'AQAO FINDINGS LIST' PRINT TEMPLATE (#1286) ; 05/13/96 ; (FILE 9002168.8, MARGIN=80)
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
 I $D(DXS)<9 F X=0:0 S X=$O(^DIPT(1286,"DXS",X)) Q:'X  S Y=$O(^(X,"")) F X=X:0 Q:Y=""  S DXS(X,Y)=^(Y),Y=$O(^(Y))
 S X=$G(^AQAO(8,D0,0)) D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0,$E($P(X,U,1),1,75)
 D N:$X>4 Q:'DN  W ?4 S DIP(1)=$S($D(^AQAO(8,D0,0)):^(0),1:"") S X="("_$P(DIP(1),U,2)_")" K DIP K:DN Y W X
 S X=$G(^AQAO(8,D0,0)) D N:$X>39 Q:'DN  W ?39,$E($P(X,U,3),1,13)
 D N:$X>54 Q:'DN  W ?54 X DXS(1,9.2) S X=X="",DIP(3)=X S X="",DIP(4)=X S X=1,DIP(5)=X S X="YES",X=$S(DIP(3):DIP(4),DIP(5):X) K DIP K:DN Y W $E(X,1,10)
 S X=$G(^AQAO(8,D0,0)) D N:$X>66 Q:'DN  W ?66 S Y=$P(X,U,4) W:Y]"" $S($D(DXS(2,Y)):DXS(2,Y),1:Y)
 K Y
 Q
HEAD ;
 W !,?0,"FINDING NAME"
 W !,?4,"(ABBREVIATION)",?39,"REVIEW LEVELS",?54,"EXCEPTION?",?66,"INACTIVE?"
 W !,"--------------------------------------------------------------------------------",!!
