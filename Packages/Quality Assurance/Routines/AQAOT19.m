AQAOT19 ; GENERATED FROM 'AQAO CRITERIA EDIT' INPUT TEMPLATE(#1129), FILE 9002166.5;05/13/96
 D DE G BEGIN
DE S DIE="^AQAOCC(5,",DIC=DIE,DP=9002166.5,DL=1,DIEL=0,DU="" K DG,DE,DB Q:$O(^AQAOCC(5,DA,""))=""
 I $D(^(0)) S %Z=^(0) S %=$P(%Z,U,1) S:%]"" DE(1)=% S %=$P(%Z,U,5) S:%]"" DE(6)=% S %=$P(%Z,U,6) S:%]"" DE(9)=% S %=$P(%Z,U,7) S:%]"" DE(12)=% S %=$P(%Z,U,8) S:%]"" DE(15)=%
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
BEGIN S DNM="AQAOT19",DQ=1
 S:$D(DTIME)[0 DTIME=300 S D0=DA,DIEZ=1129,U="^"
1 S DW="0;1",DV="RP9002169.6'",DU="",DLB="NAME",DIFLD=.01
 S DE(DW)="C1^AQAOT19"
 S DU="AQAO1(6,"
 G RE
C1 G C1S:$D(DE(1))[0 K DB S X=DE(1),DIC=DIE
 K ^AQAOCC(5,"B",$E(X,1,30),DA)
C1S S X="" Q:DG(DQ)=X  K DB S X=DG(DQ),DIC=DIE
 S ^AQAOCC(5,"B",$E(X,1,30),DA)=""
 Q
X1 Q
2 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=2 D X2 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X2 S AQAOCR=$P(^AQAOCC(5,DA,0),U)
 Q
3 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=3 D X3 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X3 S:$P(^AQAO1(6,AQAOCR,0),U,2)=2 Y="@2"
 Q
4 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=4 D X4 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X4 S:$P(^AQAO1(6,AQAOCR,0),U,2)=3 Y="@3"
 Q
5 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=5 D X5 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X5 S:$P(^AQAO1(6,AQAOCR,0),U,2)=4 Y="@4"
 Q
6 D:$D(DG)>9 F^DIE17,DE S DQ=6,DW="0;5",DV="RS",DU="",DLB="YES/NO/NA",DIFLD=.05
 S DU="1:YES;0:NO;2:N/A;"
 G RE
X6 Q
7 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=7 D X7 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X7 S Y="@9"
 Q
8 S DQ=9 ;@2
9 S DW="0;6",DV="R*P9002169.4'",DU="",DLB="CODE",DIFLD=.06
 S DU="AQAO1(4,"
 G RE
X9 S DIC("S")="I $D(^AQAO1(6,""AB"",Y,AQAOCR))" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
 Q
 ;
10 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=10 D X10 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X10 S Y="@9"
 Q
11 S DQ=12 ;@3
12 S DW="0;7",DV="RNJ4,0X",DU="",DLB="NUMBER",DIFLD=.07
 G RE
X12 D SETNUM^AQAODIC K:+X'=X!(X>9999.99)!(X<0)!(X?.E1"."3N.N)!(X<AQAOLOW)!(X>AQAOHI) X K AQAOLOW,AQAOHI
 Q
 ;
13 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=13 D X13 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X13 S Y="@9"
 Q
14 S DQ=15 ;@4
15 S DW="0;8",DV="RD",DU="",DLB="DATE",DIFLD=.08
 G RE
X15 S %DT="ET" D ^%DT S X=Y K:Y<1 X
 Q
 ;
16 S DQ=17 ;@9
17 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=17 D X17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X17 K AQAOCR
 Q
18 G 0^DIE17
