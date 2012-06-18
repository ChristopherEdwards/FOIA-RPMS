AUTPVND1 ; GENERATED FROM 'AUT VENDOR DATA-AUTPVND' PRINT TEMPLATE (#1089) ; 06/14/00 ; (continued)
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
 S X=$G(^AUTTVNDR(D0,14)) D N:$X>27 Q:'DN  W ?27,$E($P(X,U,8),1,25)
 D N:$X>54 Q:'DN  W ?54,$E($P(X,U,7),1,25)
 D N:$X>0 Q:'DN  W ?0 W "FAX:"
 S X=$G(^AUTTVNDR(D0,11)) W ?6,$E($P(X,U,14),1,12)
 S X=$G(^AUTTVNDR(D0,14)) D N:$X>27 Q:'DN  W ?27,$E($P(X,U,9),1,25)
 D N:$X>54 Q:'DN  W ?54,$E($P(X,U,10),1,25)
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
