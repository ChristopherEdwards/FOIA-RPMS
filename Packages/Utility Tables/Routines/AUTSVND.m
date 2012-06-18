AUTSVND ; GENERATED FROM 'AUT SMALL PURCHASE VENDOR' PRINT TEMPLATE (#1088) ; 06/14/00 ; (FILE 9999999.11, MARGIN=80)
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
 I $D(DXS)<9 F X=0:0 S X=$O(^DIPT(1088,"DXS",X)) Q:'X  S Y=$O(^(X,"")) F X=X:0 Q:Y=""  S DXS(X,Y)=^(Y),Y=$O(^(Y))
 D N:$X>0 Q:'DN  W ?0 W "VENDOR:"
 S X=$G(^AUTTVNDR(D0,0)) W ?9,$E($P(X,U,1),1,30)
 D N:$X>40 Q:'DN  W ?40 W "EIN NO:"
 S X=$G(^AUTTVNDR(D0,11)) W ?49,$E($P(X,U,13),1,12)
 D N:$X>0 Q:'DN  W ?0 W "TYPE BUSINESS:"
 W ?16 S Y=$P(X,U,27) W:Y]"" $S($D(DXS(1,Y)):DXS(1,Y),1:Y)
 D N:$X>40 Q:'DN  W ?40 W "DUNS..:"
 S X=$G(^AUTTVNDR(D0,0)) W ?49,$E($P(X,U,7),1,9)
 D N:$X>0 Q:'DN  W ?0 W "TYPE VENDOR..:"
 S X=$G(^AUTTVNDR(D0,11)) W ?16 S Y=$P(X,U,28) W:Y]"" $S($D(DXS(2,Y)):DXS(2,Y),1:Y)
 D T Q:'DN  D N D N:$X>9 Q:'DN  W ?9 W "MAILING ADDRESS:"
 D N:$X>9 Q:'DN  W ?9 W "-----------------------------"
 D N:$X>0 Q:'DN  W ?0 W "STREET:"
 S X=$G(^AUTTVNDR(D0,13)) W ?9,$E($P(X,U,1),1,30)
 D N:$X>9 Q:'DN  W ?9,$E($P(X,U,10),1,30)
 D N:$X>0 Q:'DN  W ?0 W "CITY..:"
 W ?9,$E($P(X,U,2),1,20)
 D N:$X>0 Q:'DN  W ?0 W "STATE.:"
 W ?9 S Y=$P(X,U,3) S Y=$S(Y="":Y,$D(^DIC(5,Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,30)
 D N:$X>0 Q:'DN  W ?0 W "ZIP...:"
 W ?9,$E($P(X,U,4),1,10)
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
