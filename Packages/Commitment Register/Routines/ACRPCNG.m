ACRPCNG ; GENERATED FROM 'ACR REQUEST FOR CHANGE' PRINT TEMPLATE (#3939) ; 09/29/09 ; (FILE 9002190, MARGIN=80)
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
 S I(0)="^ACRAPVS(",J(0)=9002190
 D N:$X>9 Q:'DN  W ?9 W "REQUEST FOR CLARIFICATION OR CHANGE"
 D N:$X>9 Q:'DN  W ?9 W "----------------------------------------"
 S X=$G(^ACRAPVS(D0,"CNG")) D N:$X>9 Q:'DN  W ?9,$E($P(X,U,1),1,40)
 D N:$X>9 Q:'DN  W ?9,$E($P(X,U,2),1,40)
 D N:$X>9 Q:'DN  W ?9,$E($P(X,U,3),1,40)
 D N:$X>9 Q:'DN  W ?9,$E($P(X,U,4),1,40)
 D N:$X>9 Q:'DN  W ?9,$E($P(X,U,5),1,40)
 S X=$G(^ACRAPVS(D0,"RSN")) D N:$X>9 Q:'DN  W ?9,$E($P(X,U,1),1,40)
 D N:$X>9 Q:'DN  W ?9,$E($P(X,U,2),1,40)
 D N:$X>9 Q:'DN  W ?9,$E($P(X,U,3),1,40)
 D N:$X>9 Q:'DN  W ?9,$E($P(X,U,4),1,40)
 D N:$X>9 Q:'DN  W ?9,$E($P(X,U,5),1,40)
 D N:$X>9 Q:'DN  W ?9 W "----------------------------------------"
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
