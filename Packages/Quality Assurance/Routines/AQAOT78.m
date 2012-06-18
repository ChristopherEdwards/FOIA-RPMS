AQAOT78 ; GENERATED FROM 'AQAO WORKSHEET' PRINT TEMPLATE (#1277) ; 05/13/96 ; (FILE 9002168.2, MARGIN=80)
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
 I $D(DXS)<9 F X=0:0 S X=$O(^DIPT(1277,"DXS",X)) Q:'X  S Y=$O(^(X,"")) F X=X:0 Q:Y=""  S DXS(X,Y)=^(Y),Y=$O(^(Y))
 S X=$G(^AQAO(2,D0,0)) D N:$X>0 Q:'DN  W ?0,$E($P(X,U,1),1,7)
 D N:$X>9 Q:'DN  W ?9,$E($P(X,U,2),1,30)
 D N:$X>49 Q:'DN  W ?49 S Y=$P(X,U,4) W:Y]"" $S($D(DXS(8,Y)):DXS(8,Y),1:Y)
 D N:$X>59 Q:'DN  W ?59 S Y=$P(X,U,5) S Y(0)=Y S:Y'="" Y=Y_"%" W $J(Y,4)
 S I(1)="""AOC""",J(1)=9002168.22 F D1=0:0 Q:$O(^AQAO(2,D0,"AOC",D1))'>0  X:$D(DSC(9002168.22)) DSC(9002168.22) S D1=$O(^(D1)) Q:D1'>0  D:$X>78 T Q:'DN  D A1
 G A1R
A1 ;
 S I(100)="^AQAO(1,",J(100)=9002168.1 S I(1,0)=D1 S I(0,0)=D0 S DIP(1)=$S($D(^AQAO(2,D0,"AOC",D1,0)):^(0),1:"") S X=$P(DIP(1),U,1),X=X S D(0)=+X S D0=D(0) I D0>0 D A2
 G A2R
A2 ;
 Q
A2R ;
 K J(100),I(100) S:$D(I(0,0)) D0=I(0,0) S:$D(I(1,0)) D1=I(1,0)
 Q
A1R ;
 D T Q:'DN  D N D N:$X>7 Q:'DN  W ?7 W "PATIENT ID:  "
 W "__________________"
 D N:$X>40 Q:'DN  W ?40 W "OCCURRENCE DATE:  "
 W "_________________"
 D N:$X>1 Q:'DN  W ?1 X DXS(1,9) K DIP K:DN Y W X
 D N:$X>44 Q:'DN  W ?44 X DXS(2,9.2) S X=X="YES",DIP(3)=X S X="WARD/CLINIC:  ",DIP(4)=X S X=1,DIP(5)=X S X="",X=$S(DIP(3):DIP(4),DIP(5):X) K DIP K:DN Y W X
 X DXS(3,9.2) S X=X="YES",DIP(3)=X S X="_________________",DIP(4)=X S X=1,DIP(5)=X S X="",X=$S(DIP(3):DIP(4),DIP(5):X) K DIP K:DN Y W X
 D N:$X>10 Q:'DN  W ?10 X DXS(4,9) K DIP K:DN Y W X
 S I(100)="^AQAO(3,",J(100)=9002168.3 S I(0,0)=D0 S DIP(1)=$S($D(^AQAO(2,D0,1)):^(1),1:"") S X=$P(DIP(1),U,1),X=X S D(0)=+X S D0=D(0) I D0>0 D B1
 G B1R
B1 ;
 S I(200)="^AQAQX(",J(200)=9002166.1 S I(100,0)=D0 S DIP(101)=$S($D(^AQAO(3,D0,0)):^(0),1:"") S X=$P(DIP(101),U,3),X=X S D(0)=+X S D0=D(0) I D0>0 D B2
 G B2R
B2 ;
 S I(201)="""PG""",J(201)=9002166.11 F D1=0:0 Q:$O(^AQAQX(D0,"PG",D1))'>0  X:$D(DSC(9002166.11)) DSC(9002166.11) S D1=$O(^(D1)) Q:D1'>0  D:$X>21 T Q:'DN  D A3
 G A3R
A3 ;
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 X DXS(5,9) K DIP K:DN Y W X
 Q
A3R ;
 Q
B2R ;
 K J(200),I(200) S:$D(I(100,0)) D0=I(100,0)
 Q
B1R ;
 K J(100),I(100) S:$D(I(0,0)) D0=I(0,0)
 D N:$X>29 Q:'DN  W ?29 W "REVIEW CRITERIA"
 D N:$X>29 Q:'DN  W ?29 W "==============="
 S DIXX(1)="C1",I(0,0)=D0 S I(0,0)=$S($D(D0):D0,1:"") X DXS(6,9.2) S X="" S D0=I(0,0)
 G C1R
C1 ;
 I $D(DSC(9002169.6)) X DSC(9002169.6) E  Q
 W:$X>46 ! S I(100)="^AQAO1(6,",J(100)=9002169.6
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 S DIP(101)=$S($D(^AQAO1(6,D0,0)):^(0),1:"") S X=$P(DIP(101),U,1)_":  " K DIP K:DN Y W X
 D N:$X>59 Q:'DN  W ?59 X DXS(7,9) K DIP K:DN Y W X
 D N:$X>78 Q:'DN  W ?78 W " "
 S I(101)="""CD""",J(101)=9002169.61 F D1=0:0 Q:$O(^AQAO1(6,D0,"CD",D1))'>0  X:$D(DSC(9002169.61)) DSC(9002169.61) S D1=$O(^(D1)) Q:D1'>0  D:$X>81 T Q:'DN  D C2
 G C2R
C2 ;
 W "  "
 S X=$G(^AQAO1(6,D0,"CD",D1,0)) S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^AQAO1(4,Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,6)
 W "  "
 Q
C2R ;
 Q
C1R ;
 K J(100),I(100) S:$D(I(0,0)) D0=I(0,0)
 D T Q:'DN  D N D N D N:$X>0 Q:'DN  W ?0 W "COMPLETED ON ___________________"
 D N:$X>34 Q:'DN  W ?34 W "BY ______________________________"
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 W "CASE SUMMARY:"
 K Y
 Q
HEAD ;
 W !,?0,"CODE #",?9,"NAME",?49,"SENTINEL/RATE-BASED"
 W !,?59,"THRESHOLD/TRIGGER"
 W !,?1,"$S(VISIT",?44,"$S(VISIT"
 W !,?1,"RELATED?=",?44,"RELATED?="
 W !,?10,"$S(VISIT"
 W !,?10,"RELATED?="
 W !,?0,"$S(SCREEN"
 W !,?0,"TITLE="
 W !,?0,"PHRASE_",?59,"$S(TYPE="
 W !,"--------------------------------------------------------------------------------",!!
