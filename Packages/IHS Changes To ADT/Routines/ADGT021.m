ADGT021 ; ;05/04/99
 D DE G BEGIN
DE S DIE="^ADGAUTH(D0,1,",DIC=DIE,DP=9009013.13,DL=2,DIEL=1,DU="" K DG,DE,DB Q:$O(^ADGAUTH(D0,1,DA,""))=""
 I $D(^(0)) S %Z=^(0) S %=$P(%Z,U,1) S:%]"" DE(1)=% S %=$P(%Z,U,2) S:%]"" DE(8)=%,DE(17)=% S %=$P(%Z,U,3) S:%]"" DE(16)=% S %=$P(%Z,U,4) S:%]"" DE(9)=% S %=$P(%Z,U,5) S:%]"" DE(3)=% S %=$P(%Z,U,6) S:%]"" DE(10)=% S %=$P(%Z,U,8) S:%]"" DE(15)=%
 I  S %=$P(%Z,U,9) S:%]"" DE(7)=%,DE(13)=% S %=$P(%Z,U,12) S:%]"" DE(6)=% S %=$P(%Z,U,13) S:%]"" DE(2)=% S %=$P(%Z,U,14) S:%]"" DE(14)=%
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
BEGIN S DNM="ADGT021",DQ=1+D G B
1 S DW="0;1",DV="DX#",DU="",DLB="DATE EXPECTED IN",DIFLD=.01
 S DE(DW)="C1^ADGT021"
 G RE:'D S DQ=2 G 2
C1 G C1S:$D(DE(1))[0 K DB S X=DE(1),DIC=DIE
 K ^ADGAUTH("AB",$E(X,1,30),DA(1),DA)
C1S S X="" Q:DG(DQ)=X  K DB S X=DG(DQ),DIC=DIE
 S ^ADGAUTH("AB",$E(X,1,30),DA(1),DA)=""
 Q
X1 S %DT="ET" D ^%DT S X=Y K:Y<1 X S:$D(X) DINUM=X
 Q
 ;
2 D:$D(DG)>9 F^DIE17,DE S DQ=2,DW="0;13",DV="S",DU="",DLB="PAYMENT FOR TRAVEL AUTHORIZED",DIFLD=10
 S DU="Y:YES;"
 G RE
X2 Q
3 S DW="0;5",DV="S",DU="",DLB="TYPE OF VISIT",DIFLD=4
 S DE(DW)="C3^ADGT021"
 S DU="I:IP;O:OP;D:DS;Q:QU;"
 G RE
C3 G C3S:$D(DE(3))[0 K DB S X=DE(3),DIC=DIE
 K ^ADGAUTH("AD",$E(X,1,30),DA(1),DA)
C3S S X="" Q:DG(DQ)=X  K DB S X=DG(DQ),DIC=DIE
 S ^ADGAUTH("AD",$E(X,1,30),DA(1),DA)=""
 Q
X3 Q
4 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=4 D X4 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X4 S Y=$S(X="I":"@2",X="D":"@2",1:"@1")
 Q
5 S DQ=6 ;@1
6 D:$D(DG)>9 F^DIE17,DE S DQ=6,DW="0;12",DV="P44'",DU="",DLB="CLINIC",DIFLD=2.5
 S DU="SC("
 G RE
X6 Q
7 S DW="0;9",DV="F",DU="",DLB="DIAGNOSIS",DIFLD=8
 G RE
X7 K:$L(X)>28!($L(X)<1) X
 I $D(X),X'?.ANP K X
 Q
 ;
8 S DW="0;2",DV="P200'",DU="",DLB="PROVIDER",DIFLD=1
 S DU="VA(200,"
 G RE
X8 Q
9 S DW="0;4",DV="F",DU="",DLB="REFERRING MD",DIFLD=3
 G RE
X9 K:$L(X)>15!($L(X)<3) X
 I $D(X),X'?.ANP K X
 Q
 ;
10 S DW="0;6",DV="NJ3,0",DU="",DLB="EXPECTED LENGTH OF STAY",DIFLD=5
 G RE
X10 K:+X'=X!(X>999)!(X<1)!(X?.E1"."1N.N) X
 Q
 ;
11 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=11 D X11 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X11 S Y="@3"
 Q
12 S DQ=13 ;@2
13 S DW="0;9",DV="F",DU="",DLB="DIAGNOSIS",DIFLD=8
 G RE
X13 K:$L(X)>28!($L(X)<1) X
 I $D(X),X'?.ANP K X
 Q
 ;
14 S DW="0;14",DV="F",DU="",DLB="PROCEDURE",DIFLD=8.5
 G RE
X14 K:$L(X)>30!($L(X)<3) X
 I $D(X),X'?.ANP K X
 Q
 ;
15 S DW="0;8",DV="D",DU="",DLB="SURGERY DATE",DIFLD=7
 G RE
X15 S %DT="EX" D ^%DT S X=Y K:Y<1 X
 Q
 ;
16 S DW="0;3",DV="P45.7'",DU="",DLB="TREATING SPECIALTY",DIFLD=2
 S DU="DIC(45.7,"
 G RE
X16 Q
17 S DW="0;2",DV="P200'",DU="",DLB="PROVIDER",DIFLD=1
 S DU="VA(200,"
 G RE
X17 Q
18 D:$D(DG)>9 F^DIE17 G ^ADGT022
