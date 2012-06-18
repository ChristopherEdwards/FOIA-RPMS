ACMRCH ; GENERATED FROM 'ACM RG CASE HISTORY' PRINT TEMPLATE (#1338) ; 05/13/96 ; (FILE 9002241, MARGIN=80)
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
 S DIWF="W"
 D T Q:'DN  D N D N:$X>4 Q:'DN  W ?4 W "**************************    CASE HISTORY    ******************************"
 D N:$X>4 Q:'DN  W ?4 W "ONSET DATE:"
 W ?17 S DIP(1)=$S($D(^ACM(41,D0,"CH")):^("CH"),1:"") S X=$P(DIP(1),U,1) S:X X=$E(X,4,5)_"/"_$E(X,6,7)_"/"_$E(X,2,3) K DIP K:DN Y W X
 D N:$X>29 Q:'DN  W ?29 W "PLACE-ONSET:"
 S X=$G(^ACM(41,D0,"CH")) D N:$X>49 Q:'DN  W ?49,$E($P(X,U,2),1,25)
 D N:$X>7 Q:'DN  W ?7 W "CASE HX:"
 S I(1)=2,J(1)=9002241.023 F D1=0:0 Q:$O(^ACM(41,D0,2,D1))'>0  S D1=$O(^(D1)) D:$X>17 T Q:'DN  D A1
 G A1R
A1 ;
 S X=$G(^ACM(41,D0,2,D1,0)) S DIWL=18,DIWR=78 D ^DIWP
 Q
A1R ;
 D 0^DIWW K DIP K:DN Y
 D ^DIWW K Y K DIWF
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
