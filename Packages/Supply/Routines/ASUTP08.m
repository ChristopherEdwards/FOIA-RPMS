ASUTP08 ; GENERATED FROM 'ASULTP08' PRINT TEMPLATE (#2342) ; 09/07/00 ; (FILE 9002039.08, MARGIN=80)
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
 I $D(DXS)<9 F X=0:0 S X=$O(^DIPT(2342,"DXS",X)) Q:'X  S Y=$O(^(X,"")) F X=X:0 Q:Y=""  S DXS(X,Y)=^(Y),Y=$O(^(Y))
 S I(1)=1,J(1)=9002039.081 F D1=0:0 Q:$O(^ASUL(8,D0,1,D1))'>0  X:$D(DSC(9002039.081)) DSC(9002039.081) S D1=$O(^(D1)) Q:D1'>0  D:$X>0 T Q:'DN  D A1
 G A1R
A1 ;
 W ?0 X DXS(1,9) K DIP K:DN Y W $J(X,4)
 W ?6 W "-"
 W ?9 X DXS(2,9.2) S X=$S(DIP(2):DIP(3),DIP(4):X) K DIP K:DN Y W $E(X,1,6)
 D N:$X>29 Q:'DN  W ?29 X DXS(3,9.2) S X=$S(DIP(2):DIP(3),DIP(4):X) K DIP K:DN Y W $J(X,4)
 Q
A1R ;
 K Y
 Q
HEAD ;
 W !,?29,"MONTHS"
 W !,?33,"OF"
 W !,?9,"MONTHLY",?29,"SUPPLY"
 W !,?9,"ISSUE",?33,"TO"
 W !,?9,"VALUE",?30,"ORDER"
 W !,"--------------------------------------------------------------------------------",!!
