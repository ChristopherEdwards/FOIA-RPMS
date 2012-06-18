ACMRDEM ; GENERATED FROM 'ACM RG DEMOGRAPHICS' PRINT TEMPLATE (#1330) ; 07/27/06 ; (FILE 9002241, MARGIN=80)
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
 I $D(DXS)<9 M DXS=^DIPT(1330,"DXS")
 S I(0)="^ACM(41,",J(0)=9002241
 D T Q:'DN  D N D N:$X>4 Q:'DN  W ?4 W "**********************    REGISTER STATUS DATA    *********************"
 D N:$X>0 Q:'DN  W ?0 W "FOLLOWD:"
 S X=$G(^ACM(41,D0,"DT")) D N:$X>10 Q:'DN  W ?10 S Y=$P(X,U,10) S Y=$S(Y="":Y,$D(^AUTTLOC(Y,0))#2:$P(^(0),U),1:Y) S Y=$S(Y="":Y,$D(^DIC(4,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,17)
 D N:$X>32 Q:'DN  W ?32 W "DOB:"
 S I(100)="^AUPNPAT(",J(100)=9000001 S I(0,0)=D0 S DIP(1)=$S($D(^ACM(41,D0,0)):^(0),1:"") S X=$P(DIP(1),U,2),X=X S D(0)=+X S D0=D(0) I D0>0 D A1
 G A1R
A1 ;
 S I(200)="^DPT(",J(200)=2 S I(100,0)=D0 S DIP(101)=$S($D(^AUPNPAT(D0,0)):^(0),1:"") S X=$P(DIP(101),U,1),X=X S D(0)=+X S D0=D(0) I D0>0 D A2
 G A2R
A2 ;
 W ?38 S DIP(201)=$S($D(^DPT(D0,0)):^(0),1:"") S X=$P(DIP(201),U,3) S:X X=$E(X,4,5)_"/"_$E(X,6,7)_"/"_$E(X,2,3) K DIP K:DN Y W X
 D N:$X>62 Q:'DN  W ?62 W "AGE:"
 W ?68 X $P(^DD(9000001,1102.98,0),U,5,99) S DIP(101)=X S X=DIP(101) K DIP K:DN Y W X
 Q
A2R ;
 K J(200),I(200) S:$D(I(100,0)) D0=I(100,0)
 Q
A1R ;
 K J(100),I(100) S:$D(I(0,0)) D0=I(0,0)
 D N:$X>0 Q:'DN  W ?0 W "PROVIDR:"
 S X=$G(^ACM(41,D0,"DT")) W ?10 S Y=$P(X,U,15) S Y=$S(Y="":Y,$D(^VA(200,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,18)
 D N:$X>29 Q:'DN  W ?29 W "STATUS:"
 W ?38 S Y=$P(X,U,1) W:Y]"" $S($D(DXS(1,Y)):DXS(1,Y),1:Y)
 D N:$X>57 Q:'DN  W ?57 W "PRIORITY:"
 W ?68 S Y=$P(X,U,5) W:Y]"" $S($D(DXS(2,Y)):DXS(2,Y),1:Y)
 D N:$X>4 Q:'DN  W ?4 W "MGR:"
 W ?10 S Y=$P(X,U,6) S Y=$S(Y="":Y,$D(^VA(200,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,20)
 D N:$X>32 Q:'DN  W ?32 W "PHN:"
 W ?38 S Y=$P(X,U,7) S Y=$S(Y="":Y,$D(^VA(200,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,20)
 D N:$X>61 Q:'DN  W ?61 W "COMM:"
 S I(100)="^AUPNPAT(",J(100)=9000001 S I(0,0)=D0 S DIP(1)=$S($D(^ACM(41,D0,0)):^(0),1:"") S X=$P(DIP(1),U,2),X=X S D(0)=+X S D0=D(0) I D0>0 D B1
 G B1R
B1 ;
 S X=$G(^AUPNPAT(D0,11)) W ?68,$E($P(X,U,18),1,11)
 Q
B1R ;
 K J(100),I(100) S:$D(I(0,0)) D0=I(0,0)
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
