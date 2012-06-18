ADELR ; GENERATED FROM 'ADEPRSDI' PRINT TEMPLATE (#2166) ; 06/04/99 ; (FILE 9002005, MARGIN=80)
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
 I $D(DXS)<9 F X=0:0 S X=$O(^DIPT(2166,"DXS",X)) Q:'X  S Y=$O(^(X,"")) F X=X:0 Q:Y=""  S DXS(X,Y)=^(Y),Y=$O(^(Y))
 S X=$G(^ADERSC(D0,0)) W ?0,$E($P(X,U,1),1,28)
 S X=$G(^ADERSC(D0,2)) D N:$X>47 Q:'DN  W ?47,$E($P(X,U,1),1,25)
 D N:$X>47 Q:'DN  W ?47,$E($P(X,U,2),1,25)
 D N:$X>47 Q:'DN  W ?47 X DXS(1,9.2) S X=$P(DIP(101),U,2) S D0=I(0,0) K DIP K:DN Y W $E(X,1,7)
 S X=$G(^ADERSC(D0,2)) D N:$X>55 Q:'DN  W ?55,$E($P(X,U,4),1,30)
 S I(1)=1,J(1)=9002005.01 F D1=0:0 Q:$O(^ADERSC(D0,1,D1))'>0  X:$D(DSC(9002005.01)) DSC(9002005.01) S D1=$O(^(D1)) Q:D1'>0  D:$X>55 T Q:'DN  D A1
 G A1R
A1 ;
 S X=$G(^ADERSC(D0,1,D1,0)) D N:$X>47 Q:'DN  W ?47,$E($P(X,U,1),1,16)
 Q
A1R ;
 D N:$X>0 Q:'DN  W ?0 W " "
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
