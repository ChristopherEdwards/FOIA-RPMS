AQAOT82 ; GENERATED FROM 'AQAO OCC LISTING' PRINT TEMPLATE (#1306) ; 05/13/96 ; (FILE 9002167, MARGIN=80)
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
 I $D(DXS)<9 F X=0:0 S X=$O(^DIPT(1306,"DXS",X)) Q:'X  S Y=$O(^(X,"")) F X=X:0 Q:Y=""  S DXS(X,Y)=^(Y),Y=$O(^(Y))
 S X=$G(^AQAOC(D0,0)) D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0,$E($P(X,U,1),1,7)
 S I(100)="^AUPNPAT(",J(100)=9000001 S I(0,0)=D0 S DIP(1)=$S($D(^AQAOC(D0,0)):^(0),1:"") S X=$P(DIP(1),U,2),X=X S D(0)=+X S D0=D(0) I D0>0 D A1
 G A1R
A1 ;
 S APCDLOOK=DUZ(2) K DIP K:DN Y
 W ?9 X DXS(1,9) K DIP K:DN Y W $E(X,1,6)
 K APCDLOOK K DIP K:DN Y
 Q
A1R ;
 K J(100),I(100) S:$D(I(0,0)) D0=I(0,0)
 W ?17 S DIP(1)=$S($D(^AQAOC(D0,0)):^(0),1:"") S X=$S('$D(^AUPNVSIT(+$P(DIP(1),U,3),0)):"",1:$P(^(0),U,1)) S:X X=$E(X,4,5)_"/"_$E(X,6,7)_"/"_$E(X,2,3) K DIP K:DN Y W X
 W ?28 S DIP(1)=$S($D(^AQAOC(D0,0)):^(0),1:"") S X=$P(DIP(1),U,4) S:X X=$E(X,4,5)_"/"_$E(X,6,7)_"/"_$E(X,2,3) K DIP K:DN Y W X
 S X=$G(^AQAOC(D0,0)) W ?39 S Y=$P(X,U,8) S Y=$S(Y="":Y,$D(^AQAO(2,Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,9)
 W ?50 X DXS(2,9.2) S X=$P(DIP(101),U,2) S D0=I(0,0) K DIP K:DN Y W $E(X,1,20)
 S I(100)="^AQAO(2,",J(100)=9002168.2 S I(0,0)=D0 S DIP(1)=$S($D(^AQAOC(D0,0)):^(0),1:"") S X=$P(DIP(1),U,8),X=X S D(0)=+X S D0=D(0) I D0>0 D B1
 G B1R
B1 ;
 S I(101)="""QTM""",J(101)=9002168.25 F D1=0:0 Q:$O(^AQAO(2,D0,"QTM",D1))'>0  X:$D(DSC(9002168.25)) DSC(9002168.25) S D1=$O(^(D1)) Q:D1'>0  D:$X>72 T Q:'DN  D A2
 G A2R
A2 ;
 D N:$X>71 Q:'DN  W ?71 X DXS(3,9.2) S DIP(201)=$S($D(^AQAO1(1,D0,0)):^(0),1:"") S X=$P(DIP(201),U,2) S D0=I(100,0) S D1=I(101,0) K DIP K:DN Y W $E(X,1,7)
 Q
A2R ;
 Q
B1R ;
 K J(100),I(100) S:$D(I(0,0)) D0=I(0,0)
 K Y
 Q
HEAD ;
 W !,?0,"CASE ID",?9,"CHART#",?17,"VISIT",?28,"OCC DATE",?39,"INDICATOR",?50,"",?71,"QI TEAM"
 W !,"--------------------------------------------------------------------------------",!!
