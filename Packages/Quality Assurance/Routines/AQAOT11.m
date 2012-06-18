AQAOT11 ; GENERATED FROM 'AQAO FIRST REVIEW' INPUT TEMPLATE(#1134), FILE 9002167;05/13/96
 D DE G BEGIN
DE S DIE="^AQAOC(",DIC=DIE,DP=9002167,DL=1,DIEL=0,DU="" K DG,DE,DB Q:$O(^AQAOC(DA,""))=""
 I $D(^(1)) S %Z=^(1) S %=$P(%Z,U,2) S:%]"" DE(12)=% S %=$P(%Z,U,3) S:%]"" DE(1)=% S %=$P(%Z,U,4) S:%]"" DE(3)=% S %=$P(%Z,U,5) S:%]"" DE(10)=% S %=$P(%Z,U,6) S:%]"" DE(14)=% S %=$P(%Z,U,7) S:%]"" DE(8)=% S %=$P(%Z,U,8) S:%]"" DE(4)=%
 I  S %=$P(%Z,U,11) S:%]"" DE(7)=%
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
BEGIN S DNM="AQAOT11",DQ=1
 S:$D(DTIME)[0 DTIME=300 S D0=DA,DIEZ=1134,U="^"
1 S DW="1;3",DV="R*P9002168.7'",DU="",DLB="INITIAL REVIEW STAGE",DIFLD=.13
 S DU="AQAO(7,"
 G RE
X1 S DIC("S")="I +$P(^(0),U,2)<4" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
 Q
 ;
2 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=2 D X2 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X2 S:X]"" AQAORLX=$P(^AQAO(7,$P(^AQAOC(D0,1),U,3),0),U,2)
 Q
3 S DW="1;4",DV="RV",DU="",DLB="INITIAL REVIEWER",DIFLD=.14
 G RE
X3 Q
4 S DW="1;8",DV="RD",DU="",DLB="INITIAL REVIEW DATE",DIFLD=.18
 G RE
X4 S %DT="EX" D ^%DT S X=Y K:Y<1 X
 Q
 ;
5 S D=0 K DE(1) ;.21
 S Y="REVIEW COMMENTS^W^^0;1^Q",DG="1RC",DC="^9002167.06" D DIEN^DIWE K DE(1) G A
 ;
6 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=6 D X6 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X6 I AQAORLX=1 S Y="@1"
 Q
7 S DW="1;11",DV="*P9002169.3'O",DU="",DLB="POTENTIAL FOR ADVERSE OUTCOME",DIFLD=.111
 S DQ(7,2)="S Y(0)=Y S:Y]"""" Y=$P(^AQAO1(3,Y,0),U)_""   ""_$P(^(0),U,2)"
 S DU="AQAO1(3,"
 G RE
X7 S DIC("S")="I $P(^AQAO1(3,Y,0),U,3)="""",$P(^(0),U,2)'=""""" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
 Q
 ;
8 S DW="1;7",DV="*P9002169.3'O",DU="",DLB="ADVERSE OUTCOME OF OCCURRENCE",DIFLD=.17
 S DQ(8,2)="S Y(0)=Y S:Y]"""" Y=$P(^AQAO1(3,Y,0),U)_""   ""_$P(^(0),U,4)"
 S DU="AQAO1(3,"
 G RE
X8 S DIC("S")="I $P(^AQAO1(3,Y,0),U,3)="""",$P(^(0),U,4)'=""""" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
 Q
 ;
9 S DQ=10 ;@1
10 S DW="1;5",DV="R*P9002168.8'",DU="",DLB="INITIAL FINDING",DIFLD=.15
 S DU="AQAO(8,"
 G RE
X10 S DIC("S")="I $P(^AQAO(8,Y,0),U,4)'=""I"",$D(AQAORLX),$P(^AQAO(8,Y,0),U,3)[AQAORLX" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
 Q
 ;
11 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=11 D X11 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X11 S:$P(^AQAO(8,$P(^AQAOC(D0,1),U,5),0),U,5)'=1 Y="@2"
 Q
12 S DW="1;2",DV="P9002169.2'",DU="",DLB="EXCEPTION",DIFLD=.12
 S DU="AQAO1(2,"
 G RE
X12 Q
13 S DQ=14 ;@2
14 S DW="1;6",DV="R*P9002168.6'",DU="",DLB="INITIAL ACTION",DIFLD=.16
 S DU="AQAO(6,"
 G RE
X14 S DIC("S")="I $D(AQAORLX),$P(^AQAO(6,Y,0),U,3)[AQAORLX" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
 Q
 ;
15 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=15 D X15 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X15 S:$P(^AQAO(6,$P(^AQAOC(AQAOIFN,1),U,6),0),U,4)'=1 Y="@3"
 Q
16 D:$D(DG)>9 F^DIE17 G ^AQAOT111
