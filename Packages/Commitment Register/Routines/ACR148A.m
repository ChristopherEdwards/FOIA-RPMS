ACR148A ; GENERATED FROM 'ACR TRAINING NEED' PRINT TEMPLATE (#3860) ; 09/29/09 ; (FILE 9002196, MARGIN=80)
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
 S I(0)="^ACRDOC(",J(0)=9002196
 W ?0 W:$D(IOF) @IOF K DIP K:DN Y
 D T Q:'DN  D N D N:$X>12 Q:'DN  W ?12 W "EMPLOYEE'S TRAINING NEED:"
 D N:$X>12 Q:'DN  W ?12 W "========================="
 S X=$G(^ACRDOC(D0,"TRNGND1")) D N:$X>12 Q:'DN  W ?12,$E($P(X,U,1),1,67)
 S X=$G(^ACRDOC(D0,"TRNGND2")) D N:$X>12 Q:'DN  W ?12,$E($P(X,U,1),1,67)
 S X=$G(^ACRDOC(D0,"TRNGND3")) D N:$X>12 Q:'DN  W ?12,$E($P(X,U,1),1,67)
 S X=$G(^ACRDOC(D0,"TRNGND4")) D N:$X>12 Q:'DN  W ?12,$E($P(X,U,1),1,67)
 D T Q:'DN  D N D N:$X>12 Q:'DN  W ?12 W "RELATION TO OFFICIAL DUTIES:"
 D N:$X>12 Q:'DN  W ?12 W "============================"
 S X=$G(^ACRDOC(D0,"TRNGRL1")) D N:$X>12 Q:'DN  W ?12,$E($P(X,U,1),1,65)
 S X=$G(^ACRDOC(D0,"TRNGRL2")) D N:$X>12 Q:'DN  W ?12,$E($P(X,U,1),1,65)
 S X=$G(^ACRDOC(D0,"TRNGRL3")) D N:$X>12 Q:'DN  W ?12,$E($P(X,U,1),1,65)
 S X=$G(^ACRDOC(D0,"TRNGRL4")) D N:$X>12 Q:'DN  W ?12,$E($P(X,U,1),1,65)
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
