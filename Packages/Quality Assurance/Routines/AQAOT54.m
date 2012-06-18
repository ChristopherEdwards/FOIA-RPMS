AQAOT54 ; GENERATED FROM 'AQAO FUNCTION DISPLAY' PRINT TEMPLATE (#1300) ; 05/13/96 ; (FILE 9002168.1, MARGIN=80)
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
 I $D(DXS)<9 F X=0:0 S X=$O(^DIPT(1300,"DXS",X)) Q:'X  S Y=$O(^(X,"")) F X=X:0 Q:Y=""  S DXS(X,Y)=^(Y),Y=$O(^(Y))
 D N:$X>29 Q:'DN  W ?29 S DIP(1)=$S($D(^AQAO(1,D0,0)):^(0),1:"") S X="** "_$P(DIP(1),U,1)_" **" K DIP K:DN Y W X
 D N:$X>0 Q:'DN  W ?0 W " "
 D N:$X>0 Q:'DN  W ?0 X DXS(1,9.2) S DIP(4)=X S X=1,DIP(5)=X S X="",X=$S(DIP(3):DIP(4),DIP(5):X) K DIP K:DN Y W X
 D N:$X>0 Q:'DN  W ?0 W "TYPE:  "
 X DXS(2,9.2) S X=X="YES",DIP(3)=X S X="HIGH VOLUME   ",DIP(4)=X S X=1,DIP(5)=X S X="",X=$S(DIP(3):DIP(4),DIP(5):X) K DIP K:DN Y W X
 X DXS(3,9.2) S X=X="YES",DIP(3)=X S X="HIGH RISK   ",DIP(4)=X S X=1,DIP(5)=X S X="",X=$S(DIP(3):DIP(4),DIP(5):X) K DIP K:DN Y W X
 X DXS(4,9.2) S X=X="YES",DIP(3)=X S X="PROBLEM-PRONE   ",DIP(4)=X S X=1,DIP(5)=X S X="",X=$S(DIP(3):DIP(4),DIP(5):X) K DIP K:DN Y W X
 D T Q:'DN  D N D N:$X>29 Q:'DN  W ?29 W "INDICATORS"
 D N:$X>29 Q:'DN  W ?29 W "----------"
 S DIXX(1)="A1",I(0,0)=D0 S I(0,0)=$S($D(D0):D0,1:"") X DXS(5,9.2) S X="" S D0=I(0,0)
 G A1R
A1 ;
 I $D(DSC(9002168.2)) X DSC(9002168.2) E  Q
 W:$X>29 ! S I(100)="^AQAO(2,",J(100)=9002168.2
 S X=$G(^AQAO(2,D0,0)) D N:$X>0 Q:'DN  W ?0,$E($P(X,U,1),1,7)
 D N:$X>9 Q:'DN  W ?9,$E($P(X,U,2),1,30)
 D N:$X>44 Q:'DN  W ?44 S Y=$P(X,U,4) W:Y]"" $S($D(DXS(8,Y)):DXS(8,Y),1:Y)
 D N:$X>59 Q:'DN  W ?59 S Y=$P(X,U,5) S Y(0)=Y S:Y'="" Y=Y_"%" W $J(Y,4)
 D N:$X>4 Q:'DN  W ?4 W "MONITORING TEAM:  "
 S I(101)="""QTM""",J(101)=9002168.25 F D1=0:0 Q:$O(^AQAO(2,D0,"QTM",D1))'>0  X:$D(DSC(9002168.25)) DSC(9002168.25) S D1=$O(^(D1)) Q:D1'>0  D:$X>24 T Q:'DN  D A2
 G A2R
A2 ;
 S X=$G(^AQAO(2,D0,"QTM",D1,0)) D N:$X>24 Q:'DN  W ?24 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^AQAO1(1,Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,30)
 Q
A2R ;
 D N:$X>4 Q:'DN  W ?4 W "ACTION PLANS:  "
 S DIXX(2)="B2",I(100,0)=D0 S I(100,0)=$S($D(D0):D0,1:"") X DXS(6,9.2) S X="" S D0=I(100,0)
 G B2R
B2 ;
 I $D(DSC(9002168.5)) X DSC(9002168.5) E  Q
 W:$X>21 ! S I(200)="^AQAO(5,",J(200)=9002168.5
 S X=$G(^AQAO(5,D0,0)) D N:$X>19 Q:'DN  W ?19,$E($P(X,U,1),1,10)
 D N:$X>33 Q:'DN  W ?33 X DXS(7,9.2) S X=$P(DIP(301),U,2) S D0=I(200,0) K DIP K:DN Y W $E(X,1,5)
 S X=$G(^AQAO(5,D0,0)) D N:$X>44 Q:'DN  W ?44 S Y=$P(X,U,5) W:Y]"" $S($D(DXS(9,Y)):DXS(9,Y),1:Y)
 Q
B2R ;
 K J(200),I(200) S:$D(I(100,0)) D0=I(100,0)
 Q
A1R ;
 K J(100),I(100) S:$D(I(0,0)) D0=I(0,0)
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
