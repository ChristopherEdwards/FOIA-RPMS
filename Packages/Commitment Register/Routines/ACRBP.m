ACRBP ; GENERATED FROM 'ACR BP' PRINT TEMPLATE (#3886) ; 09/29/09 ; (FILE 9002197.3, MARGIN=80)
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
 I $D(DXS)<9 M DXS=^DIPT(3886,"DXS")
 S I(0)="^ACRDOCBP(",J(0)=9002197.3
 S DIWF="W"
 S X=$G(^ACRDOCBP(D0,0)) D N:$X>4 Q:'DN  W ?4 S Y=$P(X,U,2) S Y=$S(Y="":Y,$D(^ACRDOC(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,17)
 W ?23 W "("
 X DXS(1,9.2) S X=$P(DIP(101),U,2) S D0=I(0,0) K DIP K:DN Y W X
 W ")"
 S X=$G(^ACRDOCBP(D0,0)) D N:$X>24 Q:'DN  W ?24 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^ACRBP(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,30)
 D N:$X>59 Q:'DN  W ?59 S X=DT S Y=X K DIP K:DN Y S Y=X D DT
 D T Q:'DN  W ?2 W !," " K DIP K:DN Y
 S I(1)=1,J(1)=9002197.31 F D1=0:0 Q:$O(^ACRDOCBP(D0,1,D1))'>0  S D1=$O(^(D1)) D:$X>13 T Q:'DN  D A1
 G A1R
A1 ;
 S X=$G(^ACRDOCBP(D0,1,D1,0)) S DIWL=1,DIWR=78 D ^DIWP
 Q
A1R ;
 D 0^DIWW
 D ^DIWW K Y K DIWF
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
