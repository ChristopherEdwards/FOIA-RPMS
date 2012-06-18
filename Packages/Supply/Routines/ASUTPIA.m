ASUTPIA ; IHS/ITSC/LMH - GENERATED FROM 'ASU3TPTA' PRINT TEMPLATE (#1594) ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 G BEGIN
CP G CP^DIO2
C S DQ(C)=Y
S S Q(C)=Y*Y+Q(C) S:L(C)>Y L(C)=Y S:H(C)<Y H(C)=Y
P S N(C)=N(C)+1
A S S(C)=S(C)+Y
 Q
D I Y=DITTO(C) S Y="" Q
 S DITTO(C)=Y
 Q
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
 I $D(DXS)<9 F X=0:0 S X=$O(^DIPT(1594,"DXS",X)) Q:'X  S Y=$O(^(X,"")) F X=X:0 Q:Y=""  S DXS(X,Y)=^(Y),Y=$O(^(Y))
 D N:$X>0 Q:'DN  W ?0 S DIP(1)=$S($D(^ASUT(3,D0,1)):^(1),1:"") S X=$P(DIP(1),U,2),X=X K DIP K:DN Y W $E(X,1,2)
 S X=$G(^ASUT(3,D0,1)) D N:$X>3 Q:'DN  W ?3,$E($P(X,U,3),1,2)
 D N:$X>6 Q:'DN  W ?6 S DIP(1)=$S($D(^ASUT(3,D0,1)):^(1),1:"") S X=$P(DIP(1),U,4),X=X K DIP K:DN Y W $E(X,1,1)
 D N:$X>8 Q:'DN  W ?8 S DIP(1)=$S($D(^ASUT(3,D0,1)):^(1),1:"") S X=$P(DIP(1),U,5),X=$E(X,1,5)_"."_$E(X,6,6) K DIP K:DN Y W $E(X,1,7)
 D N:$X>16 Q:'DN  W ?16 S DIP(1)=$S($D(^ASUT(3,D0,1)):^(1),1:"") S X=$P(DIP(1),U,1),X=X K DIP K:DN Y W $E(X,1,2) K Y(9002036.3,-1) S Y=X S:Y'?."*" N(1)=N(1)+1
 D N:$X>19 Q:'DN  W ?19 S DIP(1)=$S($D(^ASUT(3,D0,3)):^(3),1:"") S X=$P(DIP(1),U,1),X=X K DIP K:DN Y W $E(X,1,1)
 D N:$X>21 Q:'DN  W ?21 X DXS(1,9.2) S DIP(3)=X S X=1,DIP(4)=X S X=2,X=$E(DIP(3),DIP(4),X) K DIP K:DN Y W $E(X,1,2)
 D N:$X>24 Q:'DN  W ?24 X DXS(2,9) K DIP K:DN Y W $E(X,1,10)
 D N:$X>35 Q:'DN  W ?35 S DIP(2)=$S($D(^ASUT(3,D0,0)):^(0),1:""),DIP(1)=$S($D(^(1)):^(1),1:"") S X=$P(DIP(1),U,7)*$P(DIP(2),U,23) K DIP K:DN Y W:X'?."*" $J(X,7,2) K Y(9002036.3,-1) S Y=X,C=2 D A:Y'?."*"
 S X=$G(^ASUT(3,D0,0)) D N:$X>43 Q:'DN  W ?43 S Y=$P(X,U,20) W:Y]"" $S($D(DXS(3,Y)):DXS(3,Y),1:Y)
 D N:$X>45 Q:'DN  W ?45 S DIP(2)=$S($D(^ASUT(3,D0,0)):^(0),1:""),DIP(1)=$S($D(^(3)):^(3),1:"") S X=$P(DIP(1),U,6)*$P(DIP(2),U,23) K DIP K:DN Y W $J(X,5) K Y(9002036.3,-1) S Y=X,C=3 D A:Y'?."*"
 D N:$X>51 Q:'DN  W ?51 S DIP(2)=$S($D(^ASUT(3,D0,0)):^(0),1:""),DIP(1)=$S($D(^(1)):^(1),1:"") S X=$P(DIP(1),U,6)*$P(DIP(2),U,23) K DIP K:DN Y W $J(X,5) K Y(9002036.3,-1) S Y=X,C=4 D A:Y'?."*"
 D N:$X>57 Q:'DN  W ?57 S DIP(1)=$S($D(^ASUT(3,D0,1)):^(1),1:"") S X=$P(DIP(1),U,18),X=X K DIP K:DN Y W $E(X,1,1)
 S X=$G(^ASUT(3,D0,3)) D N:$X>59 Q:'DN  W ?59 S Y=$P(X,U,8) W:Y]"" $S($D(DXS(4,Y)):DXS(4,Y),1:Y)
 D N:$X>61 Q:'DN  W ?61 S Y=$P(X,U,7) W:Y]"" $S($D(DXS(5,Y)):DXS(5,Y),1:Y)
 D N:$X>63 Q:'DN  W ?63 S DIP(1)=$S($D(^ASUT(3,D0,1)):^(1),1:"") S X=$P(DIP(1),U,10) S:X X=$E(X,4,5)_"/"_$E(X,6,7)_"/"_$E(X,2,3) K DIP K:DN Y W $E(X,1,8)
 S X=$G(^ASUT(3,D0,1)) D N:$X>72 Q:'DN  W ?72,$E($P(X,U,15),1,7)
 D N:$X>80 Q:'DN  W ?80,$E($P(X,U,13),1,2)
 D N:$X>83 Q:'DN  W ?83,$E($P(X,U,14),1,3)
 D N:$X>87 Q:'DN  W ?87,$E($P(X,U,11),1,3)
 S X=$G(^ASUT(3,D0,3)) D N:$X>91 Q:'DN  W ?91,$E($P(X,U,4),1,7)
 D N:$X>99 Q:'DN  W ?99,$E($P(X,U,5),1,8)
 S X=$G(^ASUT(3,D0,0)) W ?109,$E($P(X,U,25),1,10)
 D N:$X>118 Q:'DN  W ?118 S DIP(1)=$S($D(^ASUT(3,D0,0)):^(0),1:"") S X=$P(DIP(1),U,1),X=X S X=X,DIP(2)=X S X=2,DIP(3)=X S X=14,X=$E(DIP(2),DIP(3),X) K DIP K:DN Y W $E(X,1,13)
 K Y
 Q
HEAD ;
 W !,?6,"A",?19,"P",?21,"TY",?43,"C",?57,"F",?59,"A",?61,"B",?87,"SUB"
 W !,?0,"AR",?3,"ST",?6,"C",?8,"INDEX",?16,"TR",?19,"C",?21,"IS",?24,"VOUCHER",?43,"A",?47,"QTY",?53,"QTY",?57,"P",?59,"D",?61,"/",?63,"DATE OF",?80,"SS",?83,"USE",?87,"SUB",?91,"REQUEST"
 W !,?0,"CD",?3,"CD",?6,"C",?8,"NUMBER",?16,"CD",?19,"D",?21,"RQ",?24,"NUMBER",?37,"VALUE",?43,"L",?47,"ISS",?53,"REQ",?57,"N",?59,"J",?61,"O",?63,"REQUEST",?72,"CAN",?80,"CD",?83,"CDE",?87,"ACT",?91,"NUMBER",?99,"CT/GT",?109,"REMARKS"
 W !,?118,"KEY"
 W !,"------------------------------------------------------------------------------------------------------------------------------------",!!
