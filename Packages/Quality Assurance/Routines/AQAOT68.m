AQAOT68 ; GENERATED FROM 'AQAO OCC SHORT DISPLAY' PRINT TEMPLATE (#1279) ; 05/13/96 ; (FILE 9002167, MARGIN=80)
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
 I $D(DXS)<9 F X=0:0 S X=$O(^DIPT(1279,"DXS",X)) Q:'X  S Y=$O(^(X,"")) F X=X:0 Q:Y=""  S DXS(X,Y)=^(Y),Y=$O(^(Y))
 D N:$X>0 Q:'DN  W ?0 W "OCCURRENCE BEING REVIEWED"
 D N:$X>0 Q:'DN  W ?0 W "-------------------------"
 D N:$X>0 Q:'DN  W ?0 W "CASE ID #"
 D N:$X>13 Q:'DN  W ?13 W ": "
 S X=$G(^AQAOC(D0,0)) W ?0,$E($P(X,U,1),1,7)
 D N:$X>0 Q:'DN  W ?0 W "PATIENT ID"
 D N:$X>13 Q:'DN  W ?13 W ": "
 S Y=$P(X,U,2) S Y=$S(Y="":Y,$D(^AUPNPAT(Y,0))#2:$P(^(0),U,1),1:Y) S Y=$S(Y="":Y,$D(^DPT(Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,20)
 W "  #"
 S APCDLOOK=DUZ(2) K DIP K:DN Y
 X DXS(1,9.3) S DIP(202)=$S($D(^AUPNPAT(D0,41,D1,0)):^(0),1:"") S X=$P(DIP(202),U,2) S D0=I(0,0) S D1=I(101,0) K DIP K:DN Y W X
 K APCDLOOK K DIP K:DN Y
 W "  "
 X ^DD(9002167,.025,9.3) S Y=X,X=Y(9002167,.025,2),X=X,X1=X,X2=Y,X="" D:X2 ^%DTC:X1 S Z=X\365.25,X=$S(Z>2:Z_" YRS",X<31:X_" DYS",1:X\30_" MOS") K Z S D0=Y(9002167,.025,80) W $J(X,9) K Y(9002167,.025)
 D N:$X>0 Q:'DN  W ?0 W "VISIT DATE"
 D N:$X>13 Q:'DN  W ?13 W ": "
 S X=$G(^AQAOC(D0,0)) S Y=$P(X,U,3) S Y=$S(Y="":Y,$D(^AUPNVSIT(Y,0))#2:$P(^(0),U,1),1:Y) D DT
 D N:$X>0 Q:'DN  W ?0 W "CATEGORY"
 D N:$X>13 Q:'DN  W ?13 W ": "
 X DXS(2,9.2) S DIP(101)=$S($D(^AUPNVSIT(D0,0)):^(0),1:"") S X=$P($P(DIP(102),$C(59)_$P(DIP(101),U,7)_":",2),$C(59),1) S D0=I(0,0) K DIP K:DN Y W X
 D N:$X>0 Q:'DN  W ?0 W "CLINIC/SRV"
 D N:$X>13 Q:'DN  W ?13 W ": "
 W ?17 X DXS(3,9.2) S X=$S('$D(^DIC(40.7,+$P(DIP(101),U,8),0)):"",1:$P(^(0),U,1)) S D0=I(0,0) K DIP K:DN Y W X
 S DIXX(1)="A1",I(0,0)=D0 X DXS(4,9)
 G A1R
A1 ;
 I $D(DSC(9000010.02)) X DSC(9000010.02) E  Q
 W:$X>28 ! S I(100)="^AUPNVINP(",J(100)=9000010.02
 S X=$G(^AUPNVINP(D0,0)) S Y=$P(X,U,4) S Y=$S(Y="":Y,$D(^DIC(45.7,Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,30)
 Q
A1R ;
 K J(100),I(100) S:$D(I(0,0)) D0=I(0,0)
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 W "OCC DATE"
 D N:$X>13 Q:'DN  W ?13 W ": "
 S X=$G(^AQAOC(D0,0)) S Y=$P(X,U,4) D DT
 D N:$X>0 Q:'DN  W ?0 W "INDICATOR"
 D N:$X>13 Q:'DN  W ?13 W ": "
 S Y=$P(X,U,8) S Y=$S(Y="":Y,$D(^AQAO(2,Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,7)
 W "   "
 X DXS(5,9.2) S X=$P(DIP(101),U,2) S D0=I(0,0) K DIP K:DN Y W X
 D N:$X>0 Q:'DN  W ?0 W "REVIEW TYPE"
 D N:$X>13 Q:'DN  W ?13 W ": "
 X DXS(6,9.2) S X=$S('$D(^AQAO(3,+$P(DIP(101),U,1),0)):"",1:$P(^(0),U,1)) S D0=I(0,0) K DIP K:DN Y W X
 D N:$X>0 Q:'DN  W ?0 W "KEY FUNCTION"
 D N:$X>13 Q:'DN  W ?13 W ": "
 S I(100)="^AQAO(2,",J(100)=9002168.2 S I(0,0)=D0 S DIP(1)=$S($D(^AQAOC(D0,0)):^(0),1:"") S X=$P(DIP(1),U,8),X=X S D(0)=+X S D0=D(0) I D0>0 D B1
 G B1R
B1 ;
 S I(101)="""AOC""",J(101)=9002168.22 F D1=0:0 Q:$O(^AQAO(2,D0,"AOC",D1))'>0  X:$D(DSC(9002168.22)) DSC(9002168.22) S D1=$O(^(D1)) Q:D1'>0  D:$X>17 T Q:'DN  D A2
 G A2R
A2 ;
 S X=$G(^AQAO(2,D0,"AOC",D1,0)) D N:$X>15 Q:'DN  W ?15 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^AQAO(1,Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,40)
 Q
A2R ;
 Q
B1R ;
 K J(100),I(100) S:$D(I(0,0)) D0=I(0,0)
 K Y
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
