AQAOT66 ; GENERATED FROM 'AQAO LONG DISPLAY' PRINT TEMPLATE (#1272) ; 05/13/96 ; (FILE 9002168.5, MARGIN=80)
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
 I $D(DXS)<9 F X=0:0 S X=$O(^DIPT(1272,"DXS",X)) Q:'X  S Y=$O(^(X,"")) F X=X:0 Q:Y=""  S DXS(X,Y)=^(Y),Y=$O(^(Y))
 D N:$X>4 Q:'DN  W ?4 W "Plan ID:  "
 S X=$G(^AQAO(5,D0,0)) W ?0,$E($P(X,U,1),1,10)
 D N:$X>32 Q:'DN  W ?32 W "Category:  "
 S Y=$P(X,U,2) S Y=$S(Y="":Y,$D(^AQAO(6,Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,75)
 D N:$X>2 Q:'DN  W ?2 W "Indicator:  "
 S Y=$P(X,U,14) S Y=$S(Y="":Y,$D(^AQAO(2,Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,7)
 W "  "
 X DXS(1,9.2) S X=$P(DIP(101),U,2) S D0=I(0,0) K DIP K:DN Y W X
 D T Q:'DN  D N D N:$X>24 Q:'DN  W ?24 W "** Indicator Assessment **"
 S I(1)="""IND""",J(1)=9002168.55 F D1=0:0 Q:$O(^AQAO(5,D0,"IND",D1))'>0  S D1=$O(^(D1)) D:$X>52 T Q:'DN  D A1
 G A1R
A1 ;
 S X=$G(^AQAO(5,D0,"IND",D1,0)) S DIWL=1,DIWR=78 D ^DIWP
 Q
A1R ;
 D A^DIWW
 D T Q:'DN  D N D N:$X>24 Q:'DN  W ?24 W "** Action Taken **"
 S I(1)="""SUMM""",J(1)=9002168.51 F D1=0:0 Q:$O(^AQAO(5,D0,"SUMM",D1))'>0  S D1=$O(^(D1)) D:$X>44 T Q:'DN  D B1
 G B1R
B1 ;
 S X=$G(^AQAO(5,D0,"SUMM",D1,0)) S DIWL=1,DIWR=78 D ^DIWP
 Q
B1R ;
 D A^DIWW
 D T Q:'DN  D N D N:$X>9 Q:'DN  W ?9 W "Action Status: "
 S X=$G(^AQAO(5,D0,0)) S Y=$P(X,U,5) W:Y]"" $S($D(DXS(4,Y)):DXS(4,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "Implementation Team(s):  "
 S I(1)="""TEAM""",J(1)=9002168.52 F D1=0:0 Q:$O(^AQAO(5,D0,"TEAM",D1))'>0  X:$D(DSC(9002168.52)) DSC(9002168.52) S D1=$O(^(D1)) Q:D1'>0  D:$X>27 T Q:'DN  D C1
 G C1R
C1 ;
 S X=$G(^AQAO(5,D0,"TEAM",D1,0)) D N:$X>25 Q:'DN  W ?25 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^AQAO1(1,Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,30)
 Q
C1R ;
 D N:$X>3 Q:'DN  W ?3 W "Implementation Date:  "
 S X=$G(^AQAO(5,D0,0)) S Y=$P(X,U,3) D DT
 D N:$X>2 Q:'DN  W ?2 W "Proposed Review Date:  "
 S Y=$P(X,U,4) D DT
 D T Q:'DN  D N D N:$X>24 Q:'DN  W ?24 W "** Performance Measurements **"
 S I(1)="""EVAL""",J(1)=9002168.53 F D1=0:0 Q:$O(^AQAO(5,D0,"EVAL",D1))'>0  S D1=$O(^(D1)) D:$X>56 T Q:'DN  D D1
 G D1R
D1 ;
 S X=$G(^AQAO(5,D0,"EVAL",D1,0)) S DIWL=1,DIWR=78 D ^DIWP
 Q
D1R ;
 D A^DIWW
 D T Q:'DN  D N D N:$X>24 Q:'DN  W ?24 W "** Action Assessment **"
 S I(1)="""RPT""",J(1)=9002168.54 F D1=0:0 Q:$O(^AQAO(5,D0,"RPT",D1))'>0  S D1=$O(^(D1)) D:$X>49 T Q:'DN  D E1
 G E1R
E1 ;
 S X=$G(^AQAO(5,D0,"RPT",D1,0)) S DIWL=1,DIWR=78 D ^DIWP
 Q
E1R ;
 D A^DIWW
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 W "Close Out Date:  "
 S X=$G(^AQAO(5,D0,0)) S Y=$P(X,U,6) D DT
 D N:$X>39 Q:'DN  W ?39 W "Closed by:  "
 S Y=$P(X,U,11) S Y=$S(Y="":Y,$D(^VA(200,Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,30)
 D N:$X>0 Q:'DN  W ?0 X DXS(2,9.2) S X=$S(DIP(2):DIP(3),DIP(4):X) K DIP K:DN Y W X
 S X=$G(^AQAO(5,D0,0)) W ?0,$E($P(X,U,13),1,30)
 D N:$X>5 Q:'DN  W ?5 W "Next Step:  "
 S Y=$P(X,U,15) S Y=$S(Y="":Y,$D(^AQAO(6,Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,75)
 D N:$X>5 Q:'DN  W ?5 X DXS(3,9) K DIP K:DN Y W X
 S X=$G(^AQAO(5,D0,0)) W ?0,$E($P(X,U,7),1,10)
 K Y K DIWF
 Q
HEAD ;
 W !,?0,"INDICATOR ASSESSMENT REPORT"
 W !,?0,"ACTION TAKEN"
 W !,?0,"PERFORMANCE MEASUREMENTS"
 W !,?0,"ACTION ASSESSMENT REPORT"
 W !,"--------------------------------------------------------------------------------",!!
