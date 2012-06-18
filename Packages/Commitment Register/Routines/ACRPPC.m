ACRPPC ; GENERATED FROM 'ACR PER DIEM CITY' PRINT TEMPLATE (#3932) ; 09/29/09 ; (FILE 9002193.9, MARGIN=80)
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
 S I(0)="^ACRPD(",J(0)=9002193.9
 D N:$X>4 Q:'DN  W ?4 W "CITY...:"
 S X=$G(^ACRPD(D0,0)) W ?14,$E($P(X,U,1),1,30)
 D N:$X>4 Q:'DN  W ?4 W "STATE..:"
 W ?14 S Y=$P(X,U,2) S Y=$S(Y="":Y,$D(^DIC(5,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,30)
 D N:$X>4 Q:'DN  W ?4 W "LODGING:"
 W ?14 S Y=$P(X,U,3) W:Y]"" $J(Y,4,0)
 D N:$X>4 Q:'DN  W ?4 W "M & IE.:"
 W ?14 S Y=$P(X,U,4) W:Y]"" $J(Y,4,0)
 D N:$X>4 Q:'DN  W ?4 W "EFFECT.:"
 W ?14 S Y=$P(X,U,5) D DT
 D N:$X>4 Q:'DN  W ?4 W "BEGINS.:"
 W ?14 S DIP(1)=$S($D(^ACRPD(D0,0)):^(0),1:"") S X=$P(DIP(1),U,6),DIP(2)=X S X=4,DIP(3)=X S X=7,X=$E(DIP(2),DIP(3),X) K DIP K:DN Y W X
 D N:$X>4 Q:'DN  W ?4 W "ENDS...:"
 W ?14 S DIP(1)=$S($D(^ACRPD(D0,0)):^(0),1:"") S X=$P(DIP(1),U,7),DIP(2)=X S X=4,DIP(3)=X S X=7,X=$E(DIP(2),DIP(3),X) K DIP K:DN Y W X
 D N:$X>4 Q:'DN  W ?4 W "OTHER CITY NAMES:"
 S X=$G(^ACRPD(D0,0)) W ?23 S Y=$P(X,U,5) D DT
 S I(1)=1,J(1)=9002193.91 F D1=0:0 Q:$O(^ACRPD(D0,1,D1))'>0  X:$D(DSC(9002193.91)) DSC(9002193.91) S D1=$O(^(D1)) Q:D1'>0  D:$X>36 T Q:'DN  D A1
 G A1R
A1 ;
 S X=$G(^ACRPD(D0,1,D1,0)) D N:$X>23 Q:'DN  W ?23,$E($P(X,U,1),1,30)
 Q
A1R ;
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
