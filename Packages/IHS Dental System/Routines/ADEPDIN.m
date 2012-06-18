ADEPDIN ; GENERATED FROM 'ADEPDFIND' PRINT TEMPLATE (#2187) ; 06/04/99 ; (FILE 9002003.4, MARGIN=80)
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
 I $D(DXS)<9 F X=0:0 S X=$O(^DIPT(2187,"DXS",X)) Q:'X  S Y=$O(^(X,"")) F X=X:0 Q:Y=""  S DXS(X,Y)=^(Y),Y=$O(^(Y))
 D T Q:'DN  D N D N D N D N D N D N D N D N D N:$X>0 Q:'DN  W ?0 W "Current entries for:"
 S X=$G(^ADEDSR(D0,0)) D N:$X>22 Q:'DN  W ?22 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^AUPNPAT(Y,0))#2:$P(^(0),U,1),1:Y) S Y=$S(Y="":Y,$D(^DPT(Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,30)
 D N:$X>49 Q:'DN  W ?49 X DXS(1,9.2) S X=X_Y K DIP K:DN Y W $E(X,1,21)
 D N:$X>0 Q:'DN  W ?0 W "=================================================================="
 S I(1)=1,J(1)=9002003.43 F D1=0:0 Q:$O(^ADEDSR(D0,1,D1))'>0  X:$D(DSC(9002003.43)) DSC(9002003.43) S D1=$O(^(D1)) Q:D1'>0  D:$X>68 T Q:'DN  D A1
 G A1R
A1 ;
 S X=$G(^ADEDSR(D0,1,D1,0)) D N:$X>0 Q:'DN  W ?0 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^ADEDNT(Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,35)
 W ?37 S Y=$P(X,U,2) W:Y]"" $J(Y,3,0)
 Q
A1R ;
 D T Q:'DN  D N D N:$X>42 Q:'DN  W ?42 S DIP(1)=$S($D(^ADEDSR(D0,0)):^(0),1:"") S X="ESTIMATED COST: $"_$P(DIP(1),U,2) K DIP K:DN Y W X
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
