AQAOT62 ; GENERATED FROM 'AQAO EVAL WORKSHEET' PRINT TEMPLATE (#1295) ; 05/13/96 ; (FILE 9002168.5, MARGIN=80)
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
 I $D(DXS)<9 F X=0:0 S X=$O(^DIPT(1295,"DXS",X)) Q:'X  S Y=$O(^(X,"")) F X=X:0 Q:Y=""  S DXS(X,Y)=^(Y),Y=$O(^(Y))
 D N:$X>0 Q:'DN  W ?0 W "Action Plan ID:  "
 S X=$G(^AQAO(5,D0,0)) W ?0,$E($P(X,U,1),1,10)
 D N:$X>39 Q:'DN  W ?39 W "Category:  "
 S Y=$P(X,U,2) S Y=$S(Y="":Y,$D(^AQAO(6,Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,75)
 D N:$X>0 Q:'DN  W ?0 W "Status:  "
 S Y=$P(X,U,5) W:Y]"" $S($D(DXS(3,Y)):DXS(3,Y),1:Y)
 D N:$X>39 Q:'DN  W ?39 W "Implemented: "
 S Y=$P(X,U,3) D DT
 D N:$X>0 Q:'DN  W ?0 X DXS(1,9) K DIP K:DN Y W X
 X DXS(2,9) K DIP K:DN Y W X
 D N:$X>39 Q:'DN  W ?39 W "Reviewed:  "
 S X=$G(^AQAO(5,D0,0)) S Y=$P(X,U,4) D DT
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 W "Action Taken:  "
 S I(1)="""SUMM""",J(1)=9002168.51 F D1=0:0 Q:$O(^AQAO(5,D0,"SUMM",D1))'>0  S D1=$O(^(D1)) D:$X>17 T Q:'DN  D A1
 G A1R
A1 ;
 S X=$G(^AQAO(5,D0,"SUMM",D1,0)) S DIWL=16,DIWR=78 D ^DIWP
 Q
A1R ;
 D A^DIWW
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 W "Implementation Team(s):  "
 S I(1)="""TEAM""",J(1)=9002168.52 F D1=0:0 Q:$O(^AQAO(5,D0,"TEAM",D1))'>0  X:$D(DSC(9002168.52)) DSC(9002168.52) S D1=$O(^(D1)) Q:D1'>0  D:$X>27 T Q:'DN  D B1
 G B1R
B1 ;
 S X=$G(^AQAO(5,D0,"TEAM",D1,0)) D N:$X>25 Q:'DN  W ?25 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^AQAO1(1,Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,30)
 Q
B1R ;
 D T Q:'DN  D N D N:$X>29 Q:'DN  W ?29 W "PERFORMANCE MEASUREMENTS"
 D N:$X>29 Q:'DN  W ?29 W "------------------------"
 S I(1)="""EVAL""",J(1)=9002168.53 F D1=0:0 Q:$O(^AQAO(5,D0,"EVAL",D1))'>0  S D1=$O(^(D1)) D:$X>55 T Q:'DN  D C1
 G C1R
C1 ;
 S X=$G(^AQAO(5,D0,"EVAL",D1,0)) S DIWL=1,DIWR=78 D ^DIWP
 Q
C1R ;
 D 0^DIWW K DIP K:DN Y
 D ^DIWW K Y K DIWF
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
