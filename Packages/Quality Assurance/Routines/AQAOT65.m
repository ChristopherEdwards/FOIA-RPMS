AQAOT65 ; GENERATED FROM 'AQAO LONG DISPLAY' PRINT TEMPLATE (#1271) ; 05/13/96 ; (FILE 9002167, MARGIN=80)
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
 I $D(DXS)<9 F X=0:0 S X=$O(^DIPT(1271,"DXS",X)) Q:'X  S Y=$O(^(X,"")) F X=X:0 Q:Y=""  S DXS(X,Y)=^(Y),Y=$O(^(Y))
 D N:$X>2 Q:'DN  W ?2 W "Occurrence ID: "
 S X=$G(^AQAOC(D0,0)) W ?0,$E($P(X,U,1),1,7)
 D N:$X>30 Q:'DN  W ?30 W "Occ Date: "
 S Y=$P(X,U,4) D DT
 W "   ("
 X DXS(1,9.2) S DIP(101)=$S($D(^AQAO(2,D0,0)):^(0),1:"") S X=$P($P(DIP(102),$C(59)_$P(DIP(101),U,4)_":",2),$C(59),1) S D0=I(0,0) K DIP K:DN Y W X
 W ")"
 D N:$X>0 Q:'DN  W ?0 W "Patient Chart #: "
 S APCDLOOK=DUZ(2) K DIP K:DN Y
 X DXS(2,9.3) S DIP(202)=$S($D(^AUPNPAT(D0,41,D1,0)):^(0),1:"") S X=$P(DIP(202),U,2) S D0=I(0,0) S D1=I(101,0) K DIP K:DN Y W X
 W ?0 K APCDLOOK K DIP K:DN Y
 D N:$X>28 Q:'DN  W ?28 W "Visit Date: "
 S X=$G(^AQAOC(D0,0)) S Y=$P(X,U,3) S Y=$S(Y="":Y,$D(^AUPNVSIT(Y,0))#2:$P(^(0),U,1),1:Y) D DT
 W "  ("
 X DXS(3,9.2) S DIP(101)=$S($D(^AUPNVSIT(D0,0)):^(0),1:"") S X=$P($P(DIP(102),$C(59)_$P(DIP(101),U,7)_":",2),$C(59),1) S D0=I(0,0) K DIP K:DN Y W X
 W ")  "
 D N:$X>8 Q:'DN  W ?8 W "Service: "
 S X=$G(^AQAOC(D0,0)) S Y=$P(X,U,7) S Y=$S(Y="":Y,$D(^DIC(49,Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,30)
 D N:$X>4 Q:'DN  W ?4 W "Ward/Clinic: "
 S Y=$P(X,U,6) S Y=$S(Y="":Y,$D(^SC(Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,30)
 D T Q:'DN  D N D N:$X>6 Q:'DN  W ?6 W "Indicator: "
 S Y=$P(X,U,8) S Y=$S(Y="":Y,$D(^AQAO(2,Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,7)
 W "   "
 X DXS(4,9.2) S X=$P(DIP(101),U,2) S D0=I(0,0) K DIP K:DN Y W X
 D N:$X>4 Q:'DN  W ?4 W "Review Type: "
 S I(100)="^AQAO(2,",J(100)=9002168.2 S I(0,0)=D0 S DIP(1)=$S($D(^AQAOC(D0,0)):^(0),1:"") S X=$P(DIP(1),U,8),X=X S D(0)=+X S D0=D(0) I D0>0 D A1
 G A1R
A1 ;
 S X=$G(^AQAO(2,D0,1)) S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^AQAO(3,Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,40)
 Q
A1R ;
 K J(100),I(100) S:$D(I(0,0)) D0=I(0,0)
 D N:$X>54 Q:'DN  W ?54 W "Case Status: "
 S X=$G(^AQAOC(D0,1)) S Y=$P(X,U,1) W:Y]"" $S($D(DXS(27,Y)):DXS(27,Y),1:Y)
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 W "Case Summary: "
 S I(1)="""CASE""",J(1)=9002167.02 F D1=0:0 Q:$O(^AQAOC(D0,"CASE",D1))'>0  S D1=$O(^(D1)) D:$X>16 T Q:'DN  D B1
 G B1R
B1 ;
 S X=$G(^AQAOC(D0,"CASE",D1,0)) S DIWL=15,DIWR=78 D ^DIWP
 Q
B1R ;
 D A^DIWW
 D N:$X>0 Q:'DN  W ?0 W "  "
 S DIXX(1)="C1",I(0,0)=D0 S I(0,0)=$S($D(D0):D0,1:"") X DXS(5,9.2) S X="" S D0=I(0,0)
 G C1R
C1 ;
 I $D(DSC(9002166.8)) X DSC(9002166.8) E  Q
 W:$X>4 ! S I(100)="^AQAOCC(8,",J(100)=9002166.8
 D N:$X>0 Q:'DN  W ?0 W "Clinical DX Code: "
 S X=$G(^AQAOCC(8,D0,0)) S Y=$P(X,U,1) S Y(0)=Y S Y=$P(^ICD9(Y,0),U)_"  "_$P(^ICD9(Y,0),U,3) W $E(Y,1,50)
 X DXS(6,9.3) S X=$S(DIP(103):DIP(104),DIP(105):X) K DIP K:DN Y W $E(X,1,5)
 Q
C1R ;
 K J(100),I(100) S:$D(I(0,0)) D0=I(0,0)
 S DIXX(1)="D1",I(0,0)=D0 S I(0,0)=$S($D(D0):D0,1:"") X DXS(7,9.2) S X="" S D0=I(0,0)
 G D1R
D1 ;
 I $D(DSC(9002166.9)) X DSC(9002166.9) E  Q
 W:$X>0 ! S I(100)="^AQAOCC(9,",J(100)=9002166.9
 D N:$X>2 Q:'DN  W ?2 W "Procedure Code: "
 S X=$G(^AQAOCC(9,D0,0)) D N:$X>19 Q:'DN  W ?19 S Y=$P(X,U,1) S Y(0)=Y S Y=$P(^ICD0(Y,0),U)_"  "_$P(^ICD0(Y,0),U,4) W $E(Y,1,50)
 X DXS(8,9.3) S X=$S(DIP(103):DIP(104),DIP(105):X) K DIP K:DN Y W $E(X,1,5)
 Q
D1R ;
 K J(100),I(100) S:$D(I(0,0)) D0=I(0,0)
 S DIXX(1)="E1",I(0,0)=D0 S I(0,0)=$S($D(D0):D0,1:"") X DXS(9,9.2) S X="" S D0=I(0,0)
 G E1R
E1 ;
 I $D(DSC(9002166.6)) X DSC(9002166.6) E  Q
 W:$X>19 ! S I(100)="^AQAOCC(6,",J(100)=9002166.6
 D N:$X>12 Q:'DN  W ?12 W "Drug: "
 S X=$G(^AQAOCC(6,D0,0)) D N:$X>19 Q:'DN  W ?19 S Y=$P(X,U,1) S C=$P(^DD(9002166.6,.01,0),U,2) D Y^DIQ:Y S C="," W $E(Y,1,50)
 X DXS(10,9) K DIP K:DN Y W X
 Q
E1R ;
 K J(100),I(100) S:$D(I(0,0)) D0=I(0,0)
 S DIXX(1)="F1",I(0,0)=D0 S I(0,0)=$S($D(D0):D0,1:"") X DXS(11,9.2) S X="" S D0=I(0,0)
 G F1R
F1 ;
 I $D(DSC(9002166.7)) X DSC(9002166.7) E  Q
 W:$X>19 ! S I(100)="^AQAOCC(7,",J(100)=9002166.7
 D N:$X>3 Q:'DN  W ?3 W "Provider Code: "
 D N:$X>19 Q:'DN  W ?19 S DIP(101)=$S($D(^AQAOCC(7,D0,0)):^(0),1:"") S X=$P(DIP(101),U,1),X=X K DIP K:DN Y W X
 X DXS(12,9.3) S X=X_"]",DIP(105)=X S X=1,DIP(106)=X S X="",X=$S(DIP(103):DIP(105),DIP(106):X) K DIP K:DN Y W X
 Q
F1R ;
 K J(100),I(100) S:$D(I(0,0)) D0=I(0,0)
 S DIXX(1)="G1",I(0,0)=D0 S I(0,0)=$S($D(D0):D0,1:"") X DXS(13,9.2) S X="" S D0=I(0,0)
 G G1R
G1 ;
 I $D(DSC(9002166.5)) X DSC(9002166.5) E  Q
 W:$X>19 ! S I(100)="^AQAOCC(5,",J(100)=9002166.5
 S X=$G(^AQAOCC(5,D0,0)) D N:$X>0 Q:'DN  W ?0 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^AQAO1(6,Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,60)
 D N:$X>64 Q:'DN  W ?64 X DXS(14,9) K DIP K:DN Y W X
 Q
G1R ;
 K J(100),I(100) S:$D(I(0,0)) D0=I(0,0)
 D T Q:'DN  D N D N:$X>29 Q:'DN  W ?29 W "** CASE REVIEWS **"
 D N:$X>2 Q:'DN  W ?2 W "Initial Review: "
 S X=$G(^AQAOC(D0,1)) S Y=$P(X,U,3) S Y=$S(Y="":Y,$D(^AQAO(7,Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,4)
 D N:$X>23 Q:'DN  W ?23 W "by "
 S Y=$P(X,U,4) S C=$P(^DD(9002167,.14,0),U,2) D Y^DIQ:Y S C="," W $E(Y,1,22)
 G ^AQAOT651
