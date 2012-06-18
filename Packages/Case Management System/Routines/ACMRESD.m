ACMRESD ; GENERATED FROM 'ACM RESOURCE DIRECTORY' PRINT TEMPLATE (#1420) ; 05/13/96 ; (FILE 9002250, MARGIN=80)
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
 I $D(DXS)<9 F X=0:0 S X=$O(^DIPT(1420,"DXS",X)) Q:'X  S Y=$O(^(X,"")) F X=X:0 Q:Y=""  S DXS(X,Y)=^(Y),Y=$O(^(Y))
 D T Q:'DN  D N D N D N:$X>6 Q:'DN  W ?6 W "NAME:"
 S X=$G(^ACM(50,D0,0)) W ?13,$E($P(X,U,1),1,30)
 D N:$X>4 Q:'DN  W ?4 W "STREET:"
 S X=$G(^ACM(50,D0,3)) W ?13,$E($P(X,U,1),1,30)
 D N:$X>6 Q:'DN  W ?6 W "CITY:"
 W ?13,$E($P(X,U,2),1,20)
 D N:$X>36 Q:'DN  W ?36 W "STATE:"
 W ?44 S Y=$P(X,U,3) S Y=$S(Y="":Y,$D(^DIC(5,Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,15)
 D N:$X>62 Q:'DN  W ?62 W "ZIP:  "
 W ?0,$E($P(X,U,4),1,10)
 D N:$X>5 Q:'DN  W ?5 W "PHONE:"
 W ?13,$E($P(X,U,5),1,20)
 D N:$X>3 Q:'DN  W ?3 W "CONTACT:"
 W ?13,$E($P(X,U,6),1,30)
 D N:$X>5 Q:'DN  W ?5 W "HOURS:"
 S X=$G(^ACM(50,D0,5)) W ?13,$E($P(X,U,1),1,50)
 D N:$X>4 Q:'DN  W ?4 W "REGION:"
 W ?13,$E($P(X,U,2),1,50)
 D T Q:'DN  D N W ?0 W "SERVICES(S):"
 D N:$X>13 Q:'DN  W ?13 W "SERVICE"
 D N:$X>35 Q:'DN  W ?35 W "CLINIC DATES"
 D N:$X>52 Q:'DN  W ?52 W "DESCRIPTIVE DATE"
 D N:$X>13 Q:'DN  W ?13 W "--------------------"
 D N:$X>35 Q:'DN  W ?35 W "--------------"
 D N:$X>52 Q:'DN  W ?52 W "---------------------------"
 S I(1)=2,J(1)=9002250.02 F D1=0:0 Q:$O(^ACM(50,D0,2,D1))'>0  X:$D(DSC(9002250.02)) DSC(9002250.02) S D1=$O(^(D1)) Q:D1'>0  D:$X>81 T Q:'DN  D A1
 G A1R
A1 ;
 S X=$G(^ACM(50,D0,2,D1,0)) D N:$X>13 Q:'DN  W ?13 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^ACM(47.1,Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,20)
 S I(2)=1,J(2)=9002250.21 F D2=0:0 Q:$O(^ACM(50,D0,2,D1,1,D2))'>0  X:$D(DSC(9002250.21)) DSC(9002250.21) S D2=$O(^(D2)) Q:D2'>0  D:$X>35 T Q:'DN  D A2
 G A2R
A2 ;
 S DICMX="D L^DIWP" D N:$X>35 Q:'DN  S DIWL=36,DIWR=53 X DXS(1,9.2):D1>0 S X="" S Y=X K DIP K:DN Y
 D A^DIWW
 Q
A2R ;
 S I(2)=2,J(2)=9002250.22 F D2=0:0 Q:$O(^ACM(50,D0,2,D1,2,D2))'>0  X:$D(DSC(9002250.22)) DSC(9002250.22) S D2=$O(^(D2)) Q:D2'>0  D:$X>55 T Q:'DN  D B2
 G B2R
B2 ;
 S X=$G(^ACM(50,D0,2,D1,2,D2,0)) D N:$X>52 Q:'DN  W ?52,$E($P(X,U,1),1,25)
 Q
B2R ;
 D N:$X>13 Q:'DN  W ?13 W "--------------------"
 D N:$X>35 Q:'DN  W ?35 W "--------------"
 D N:$X>52 Q:'DN  W ?52 W "---------------------------"
 Q
A1R ;
 D N:$X>0 Q:'DN  W ?0 W "ASSOCIATED REGISTERS:"
 S I(1)="""RG""",J(1)=9002250.01 F D1=0:0 Q:$O(^ACM(50,D0,"RG",D1))'>0  X:$D(DSC(9002250.01)) DSC(9002250.01) S D1=$O(^(D1)) Q:D1'>0  D:$X>23 T Q:'DN  D B1
 G B1R
B1 ;
 S X=$G(^ACM(50,D0,"RG",D1,0)) W ?23 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^ACM(41.1,Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,30)
 Q
B1R ;
 D T Q:'DN  D N W ?0 W "PROGRAM DESCRIPTION"
 D T Q:'DN  W ?0 W "--------------------------------------------------------------------------------"
 S I(1)=4,J(1)=9002250.03 F D1=0:0 Q:$O(^ACM(50,D0,4,D1))'>0  S D1=$O(^(D1)) D:$X>82 T Q:'DN  D C1
 G C1R
C1 ;
 S X=$G(^ACM(50,D0,4,D1,0)) S DIWL=5,DIWR=79 D ^DIWP
 Q
C1R ;
 D A^DIWW
 D T Q:'DN  D N W ?0 W "ELIGIBILITY REQUIREMENTS"
 D N:$X>0 Q:'DN  W ?0 W "--------------------------------------------------------------------------------"
 S I(1)=1,J(1)=9002250.04 F D1=0:0 Q:$O(^ACM(50,D0,1,D1))'>0  S D1=$O(^(D1)) D:$X>82 T Q:'DN  D D1
 G D1R
D1 ;
 S X=$G(^ACM(50,D0,1,D1,0)) S DIWL=5,DIWR=79 D ^DIWP
 Q
D1R ;
 D A^DIWW
 D T Q:'DN  D N W ?0 W "COST INFORMATION"
 D N:$X>0 Q:'DN  W ?0 W "--------------------------------------------------------------------------------"
 S I(1)=6,J(1)=9002250.07 F D1=0:0 Q:$O(^ACM(50,D0,6,D1))'>0  S D1=$O(^(D1)) D:$X>82 T Q:'DN  D E1
 G E1R
E1 ;
 S X=$G(^ACM(50,D0,6,D1,0)) S DIWL=5,DIWR=79 D ^DIWP
 Q
E1R ;
 D A^DIWW
 D T Q:'DN  D N W ?0 W "HOW TO APPLY"
 D N:$X>0 Q:'DN  W ?0 W "--------------------------------------------------------------------------------"
 S I(1)=7,J(1)=9002250.08 F D1=0:0 Q:$O(^ACM(50,D0,7,D1))'>0  S D1=$O(^(D1)) D:$X>82 T Q:'DN  D F1
 G F1R
F1 ;
 S X=$G(^ACM(50,D0,7,D1,0)) S DIWL=5,DIWR=79 D ^DIWP
 Q
F1R ;
 D A^DIWW
 D T Q:'DN  D N W ?0 W "OTHER INFORMATION"
 D N:$X>0 Q:'DN  W ?0 W "--------------------------------------------------------------------------------"
 G ^ACMRESD1
