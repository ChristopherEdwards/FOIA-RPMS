ACMRAGE ; GENERATED FROM 'ACM PAGE' PRINT TEMPLATE (#1336) ; 05/13/96 ; (FILE 9002241, MARGIN=80)
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
 W ?0 W:$D(IOF)&(IOST["C-") @IOF K DIP K:DN Y
 W ?11 W "          ********** CONFIDENTIAL PATIENT INFORMATION  **********"
 D N:$X>4 Q:'DN  W ?4 W "****************"
 S X=$G(^ACM(41,D0,0)) W ?22 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^ACM(41.1,Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,30)
 D N:$X>50 Q:'DN  W ?50 W "REGISTER  ********************"
 D N:$X>6 Q:'DN  W ?6 W "CLIENT:"
 W ?15 S Y=$P(X,U,2) S Y=$S(Y="":Y,$D(^AUPNPAT(Y,0))#2:$P(^(0),U,1),1:Y) S Y=$S(Y="":Y,$D(^DPT(Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,30)
 D N:$X>51 Q:'DN  W ?51 W "CHART:"
 S I(100)="^AUPNPAT(",J(100)=9000001 S I(0,0)=D0 S DIP(1)=$S($D(^ACM(41,D0,0)):^(0),1:"") S X=$P(DIP(1),U,2),X=X S D(0)=+X S D0=D(0) I D0>0 D A1
 G A1R
A1 ;
 W ?59 I $D(DUZ(2))#2,DUZ(2) W $S($D(^AUPNPAT(D0,41,DUZ(2),0)):$P(^(0),U,2),1:"<NONE>") K DIP K:DN Y
 Q
A1R ;
 K J(100),I(100) S:$D(I(0,0)) D0=I(0,0)
 W ?70 S ACMPAGE="" K DIP K:DN Y
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
