ADGT11 ; GENERATED FROM 'ADGPARA' INPUT TEMPLATE(#1596), FILE 43;09/02/99
 D DE G BEGIN
DE S DIE="^DG(43,",DIC=DIE,DP=43,DL=1,DIEL=0,DU="" K DG,DE,DB Q:$O(^DG(43,DA,""))=""
 I $D(^(9999999)) S %Z=^(9999999) S %=$P(%Z,U,1) S:%]"" DE(1)=% S %=$P(%Z,U,2) S:%]"" DE(2)=% S %=$P(%Z,U,5) S:%]"" DE(5)=% S %=$P(%Z,U,6) S:%]"" DE(6)=%
 I $D(^(9999999.01)) S %Z=^(9999999.01) S %=$P(%Z,U,1) S:%]"" DE(10)=% S %=$P(%Z,U,2) S:%]"" DE(11)=% S %=$P(%Z,U,3) S:%]"" DE(12)=% S %=$P(%Z,U,4) S:%]"" DE(14)=% S %=$P(%Z,U,5) S:%]"" DE(15)=% S %=$P(%Z,U,7) S:%]"" DE(13)=%
 I $D(^(9999999.02)) S %Z=^(9999999.02) S %=$P(%Z,U,1) S:%]"" DE(16)=% S %=$P(%Z,U,3) S:%]"" DE(4)=% S %=$P(%Z,U,4) S:%]"" DE(3)=%
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
T G M^DIE17:DV,^DIE3:DV["V",P:DV'["S" X:$D(^DD(DP,DIFLD,12.1)) ^(12.1) I X?.ANP D SET I 'DDER X:$D(DIC("S")) DIC("S") I  W:'$D(DB(DQ)) "  "_% G V
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
SET N DIR S DIR(0)="SV"_$E("o",$D(DB(DQ)))_U_DU,DIR("V")=1
 I $D(DB(DQ)),'$D(DIQUIET) N DIQUIET S DIQUIET=1
 D ^DIR I 'DDER S %=Y(0),X=Y
 Q
BEGIN S DNM="ADGT11",DQ=1
 S:$D(DTIME)[0 DTIME=300 S D0=DA,DIEZ=1596,U="^"
1 S DW="9999999;1",DV="RS",DU="",DLB="TYPE OF FACILITY",DIFLD=9999999.01
 S DU="I:IHS;6:638;T:TRIBAL;"
 G RE
X1 Q
2 S DW="9999999;2",DV="RS",DU="",DLB="LINKED TO PCC?",DIFLD=9999999.02
 S DU="Y:YES;N:NO;"
 G RE
X2 Q
3 S DW="9999999.02;4",DV="RS",DU="",DLB="TRANSFER DISCHARGE TO INCOMPLETE CHARTS?",DIFLD=9999999.24
 S DU="1:YES;0:NO;"
 G RE
X3 Q
4 S DW="9999999.02;3",DV="RNJ2,0",DU="",DLB="DAYS TO CHART DELINQUENCY",DIFLD=9999999.23
 G RE
X4 K:+X'=X!(X>30)!(X<1)!(X?.E1"."1N.N) X
 Q
 ;
5 S DW="9999999;5",DV="RNJ2,0",DU="",DLB="MINIMUM AGE FOR ADULT PATIENTS",DIFLD=9999999.05
 G RE
X5 K:+X'=X!(X>18)!(X<12)!(X?.E1"."1N.N) X
 Q
 ;
6 S DW="9999999;6",DV="NJ3,0",DU="",DLB="CENSUS LOCKOUT TIME",DIFLD=9999999.06
 G RE
X6 K:+X'=X!(X>365)!(X<0)!(X?.E1"."1N.N) X
 Q
 ;
7 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=7 D X7 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X7 W !!,"This software offers the ability to have mail bulletins sent"
 Q
8 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=8 D X8 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X8 W !,"based on various events.  Please answer the following,"
 Q
9 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=9 D X9 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X9 W !,"remembering to set up mail groups to receive these bulletins.",!
 Q
10 S DW="9999999.01;1",DV="RS",DU="",DLB="ICU BULLETIN?",DIFLD=9999999.11
 S DU="1:YES;0:NO;"
 G RE
X10 Q
11 S DW="9999999.01;2",DV="RS",DU="",DLB="TRANSFER-IN BULLETIN?",DIFLD=9999999.12
 S DU="1:YES;0:NO;"
 G RE
X11 Q
12 S DW="9999999.01;3",DV="RS",DU="",DLB="TRANSFER-OUT BULLETIN?",DIFLD=9999999.13
 S DU="1:YES;0:NO;"
 G RE
X12 Q
13 S DW="9999999.01;7",DV="RS",DU="",DLB="AMA DISCHARGE BULLETIN",DIFLD=9999999.17
 S DU="1:YES;0:NO;"
 G RE
X13 Q
14 S DW="9999999.01;4",DV="RS",DU="",DLB="DEATH BULLETIN?",DIFLD=9999999.14
 S DU="1:YES;0:NO;"
 G RE
X14 Q
15 S DW="9999999.01;5",DV="RS",DU="",DLB="READMISSION BULLETIN?",DIFLD=9999999.15
 S DU="1:YES;0:NO;"
 G RE
X15 Q
16 S DW="9999999.02;1",DV="RNJ3,0",DU="",DLB="QA TIME LENGTH FOR READMISSION",DIFLD=9999999.21
 G RE
X16 K:+X'=X!(X>999)!(X<0)!(X?.E1"."1N.N) X
 Q
 ;
17 D:$D(DG)>9 F^DIE17 G ^ADGT111
