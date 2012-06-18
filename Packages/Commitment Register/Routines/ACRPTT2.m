ACRPTT2 ; GENERATED FROM 'ACR STATUS DISPLAY' PRINT TEMPLATE (#3879) ; 09/29/09 ; (FILE 9002196, MARGIN=80)
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
 D N:$X>0 Q:'DN  W ?0 W "DOCUMENT:"
 S X=$G(^ACRDOC(D0,0)) W ?11,$E($P(X,U,1),1,17)
 D N:$X>40 Q:'DN  W ?40 W "IDENTIFIER:"
 W ?53,$E($P(X,U,14),1,16)
 D N:$X>2 Q:'DN  W ?2 W "STATUS:  WAITING FOR "
 S X=$G(^ACRDOC(D0,"PA")) S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^ACRPA(Y,0))#2:$P(^(0),U),1:Y) S Y=$S(Y="":Y,$D(^VA(200,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,35)
 W " TO PROCESS PO."
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
