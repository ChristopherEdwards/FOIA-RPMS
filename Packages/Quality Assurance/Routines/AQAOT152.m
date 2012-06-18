AQAOT152 ; ;05/13/96
 D DE G BEGIN
DE S DIE="^AQAO(5,",DIC=DIE,DP=9002168.5,DL=1,DIEL=0,DU="" K DG,DE,DB Q:$O(^AQAO(5,DA,""))=""
 I $D(^(0)) S %Z=^(0) S %=$P(%Z,U,4) S:%]"" DE(1)=% S %=$P(%Z,U,6) S:%]"" DE(10)=% S %=$P(%Z,U,7) S:%]"" DE(17)=% S %=$P(%Z,U,11) S:%]"" DE(11)=% S %=$P(%Z,U,13) S:%]"" DE(13)=% S %=$P(%Z,U,15) S:%]"" DE(15)=%
 K %Z Q
 ;
W W !?DL+DL-2,DLB_": "
 Q
O D W W Y W:$X>45 !?9
 I $L(Y)>19,'DV,DV'["I",(DV["F"!(DV["K")) G RW^DIR2
 W:Y]"" "// " I 'DV,DV["I",$D(DE(DQ))#2 S X="" W "  (No Editing)" Q
TR R X:DTIME E  S (DTOUT,X)=U W $C(7)
 Q
A K DQ(DQ) S DQ=DQ+1
B G @DQ
RE G PR:$D(DE(DQ)) D W,TR
N I X="" G A:DV'["R",X:'DV,X:D'>0,A
RD G QS:X?."?" I X["^" D D G ^DIE17
 I X="@" D D G Z^DIE2
 I X=" ",DV["d",DV'["P",$D(^DISV(DUZ,"DIE",DLB)) S X=^(DLB) I DV'["D",DV'["S" W "  "_X
T G M^DIE17:DV,^DIE3:DV["V",P:DV'["S" X:$D(^DD(DP,DIFLD,12.1)) ^(12.1) D SET I 'DDER X:$D(DIC("S")) DIC("S") I  W:'$D(DB(DQ)) "  "_% G V
 K DDER G X
P I DV["P" S DIC=U_DU,DIC(0)=$E("EN",$D(DB(DQ))+1)_"M"_$E("L",DV'["'") S:DIC(0)["L" DLAYGO=+$P(DV,"P",2) I DV'["*" D ^DIC S X=+Y,DIC=DIE G X:X<0
 G V:DV'["N" D D I $L($P(X,"."))>24 K X G Z
 I $P(DQ(DQ),U,5)'["$",X?.1"-".N.1".".N,$P(DQ(DQ),U,5,99)["+X'=X" S X=+X
V D @("X"_DQ) K YS
Z K DIC("S"),DLAYGO I $D(X),X'=U S DG(DW)=X S:DV["d" ^DISV(DUZ,"DIE",DLB)=X G A
X W:'$D(ZTQUEUED) $C(7),"??" I $D(DB(DQ)) G Z^DIE17
 S X="?BAD"
QS S DZ=X D D,QQ^DIEQ G B
D S D=DIFLD,DQ(DQ)=DLB_U_DV_U_DU_U_DW_U_$P($T(@("X"_DQ))," ",2,99) Q
Y I '$D(DE(DQ)) D O G RD:"@"'[X,A:DV'["R"&(X="@"),X:X="@" S X=Y G N
PR S DG=DV,Y=DE(DQ),X=DU I $D(DQ(DQ,2)) X DQ(DQ,2) G RP
R I DG["P",@("$D(^"_X_"0))") S X=+$P(^(0),U,2) G RP:'$D(^(Y,0)) S Y=$P(^(0),U),X=$P(^DD(X,.01,0),U,3),DG=$P(^(0),U,2) G R
 I DG["V",+Y,$P(Y,";",2)["(",$D(@(U_$P(Y,";",2)_"0)")) S X=+$P(^(0),U,2) G RP:'$D(^(+Y,0)) S Y=$P(^(0),U) I $D(^DD(+X,.01,0)) S DG=$P(^(0),U,2),X=$P(^(0),U,3) G R
 X:DG["D" ^DD("DD") I DG["S" S %=$P($P(";"_X,";"_Y_":",2),";") S:%]"" Y=%
RP D O I X="" S X=DE(DQ) G A:'DV,A:DC<2,N^DIE17
I I DV'["I",DV'["#" G RD
 D E^DIE0 G RD:$D(X),PR
 Q
SET I X'?.ANP S DDER=1 Q 
 N DIR S DIR(0)="SMV^"_DU,DIR("V")=1
 I $D(DB(DQ)),'$D(DIQUIET) N DIQUIET S DIQUIET=1
 D ^DIR I 'DDER S %=Y(0),X=Y
 Q
BEGIN S DNM="AQAOT152",DQ=1
1 S DW="0;4",DV="D",DU="",DLB="PROPOSED REVIEW DATE",DIFLD=.04
 G RE
X1 S %DT="EX" D ^%DT S X=Y K:Y<1 X
 Q
 ;
2 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=2 D X2 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X2 D CRITERIA^AQAOHAPL
 Q
3 S D=0 K DE(1) ;3
 S Y="PERFORMANCE MEASUREMENTS^W^^0;1^Q",DG="EVAL",DC="^9002168.53" D DIEN^DIWE K DE(1) G A
 ;
4 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=4 D X4 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X4 S:AQAOSTAT=2 Y="@1"
 Q
5 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=5 D X5 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X5 D REPORT^AQAOHAPL
 Q
6 S D=0 K DE(1) ;4
 S Y="ACTION ASSESSMENT REPORT^W^^0;1^Q",DG="RPT",DC="^9002168.54" D DIEN^DIWE K DE(1) G A
 ;
7 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=7 D X7 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X7 S Y="@2"
 Q
8 S DQ=9 ;@9
9 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=9 G A
10 S DW="0;6",DV="D",DU="",DLB="CLOSE DATE",DIFLD=.06
 S Y="TODAY"
 G Y
X10 S %DT="EX" D ^%DT S X=Y K:Y<1 X
 Q
 ;
11 S DW="0;11",DV="P200'",DU="",DLB="CLOSED OUT BY",DIFLD=.11
 S DU="VA(200,"
 S X=$P(^VA(200,DUZ,0),U)
 S Y=X
 G Y
X11 Q
12 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=12 D X12 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X12 S:AQAOSTAT'=9 Y="@2"
 Q
13 S DW="0;13",DV="RF",DU="",DLB="DELETION REASON",DIFLD=.13
 G RE
X13 K:$L(X)>30!($L(X)<3) X
 I $D(X),X'?.ANP K X
 Q
 ;
14 S DQ=15 ;@2
15 S DW="0;15",DV="P9002168.6'",DU="",DLB="NEXT STEP",DIFLD=.15
 S DU="AQAO(6,"
 G RE
X15 Q
16 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=16 D X16 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X16 S:AQAOSTAT=3 Y="@1"
 Q
17 S DW="0;7",DV="F",DU="",DLB="NEW ACTION PLAN NUMBER",DIFLD=.07
 G RE
X17 K:$L(X)>10!($L(X)<1) X
 I $D(X),X'?.ANP K X
 Q
 ;
18 S DQ=19 ;@1
19 G 0^DIE17
