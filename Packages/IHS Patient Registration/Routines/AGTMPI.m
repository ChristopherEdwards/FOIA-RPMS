AGTMPI ; GENERATED FROM 'AG TM INSURER' PRINT TEMPLATE (#669) ; 02/14/06 ; (FILE 9999999.18, MARGIN=80)
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
 I $D(DXS)<9 M DXS=^DIPT(669,"DXS")
 S I(0)="^AUTNINS(",J(0)=9999999.18
 S X=$G(^AUTNINS(D0,0)) D T Q:'DN  D N W ?0,$E($P(X,U,1),1,30)
 S X=$G(^AUTNINS(D0,1)) D N:$X>40 Q:'DN  W ?40,$E($P(X,U,1),1,30)
 S X=$G(^AUTNINS(D0,0)) D N:$X>0 Q:'DN  W ?0,$E($P(X,U,2),1,30)
 S X=$G(^AUTNINS(D0,1)) D N:$X>40 Q:'DN  W ?40,$E($P(X,U,2),1,30)
 S X=$G(^AUTNINS(D0,0)) D N:$X>0 Q:'DN  W ?0,$E($P(X,U,3),1,15)
 I $P($G(^AUTNINS(D0,0)),U,2)]"" W ", " K DIP K:DN Y
 X DXS(1,9.2) S X=X_"  "_$P(DIP(1),U,5) S D0=I(0,0) K DIP K:DN Y W X
 S X=$G(^AUTNINS(D0,1)) D N:$X>40 Q:'DN  W ?40,$E($P(X,U,3),1,15)
 I $D(^AUTNINS(D0,1)),$P(^(1),U,3)]"" W ", " K DIP K:DN Y
 X DXS(2,9.2) S X=X_"  "_$P(DIP(1),U,5) S D0=I(0,0) K DIP K:DN Y W X
 S X=$G(^AUTNINS(D0,0)) D N:$X>0 Q:'DN  W ?0,$E($P(X,U,6),1,13)
 I $P($G(^AUTNINS(D0,0)),U,9)]"" W ?40,"Attn: ",$P(^(0),U,9) K DIP K:DN Y
 K Y
 Q
HEAD ;
 W !,?0,"MAILING ADDRESS",?40,"BILLING ADDRESS"
 W !,"--------------------------------------------------------------------------------",!!
