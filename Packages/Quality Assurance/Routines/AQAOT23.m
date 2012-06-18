AQAOT23 ; GENERATED FROM 'AQAO PARAM ADD' INPUT TEMPLATE(#1160), FILE 9002166.4;05/13/96
 D DE G BEGIN
DE S DIE="^AQAGP(",DIC=DIE,DP=9002166.4,DL=1,DIEL=0,DU="" K DG,DE,DB Q:$O(^AQAGP(DA,""))=""
 I $D(^("ADT")) S %Z=^("ADT") S %=$P(%Z,U,1) S:%]"" DE(1)=% S %=$P(%Z,U,3) S:%]"" DE(2)=% S %=$P(%Z,U,4) S:%]"" DE(3)=% S %=$P(%Z,U,11) S:%]"" DE(4)=% S %=$P(%Z,U,13) S:%]"" DE(5)=% S %=$P(%Z,U,14) S:%]"" DE(6)=% S %=$P(%Z,U,21) S:%]"" DE(7)=%
 I  S %=$P(%Z,U,23) S:%]"" DE(8)=% S %=$P(%Z,U,24) S:%]"" DE(9)=% S %=$P(%Z,U,31) S:%]"" DE(10)=% S %=$P(%Z,U,33) S:%]"" DE(11)=%
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
BEGIN S DNM="AQAOT23",DQ=1
 S:$D(DTIME)[0 DTIME=300 S D0=DA,DIEZ=1160,U="^"
1 S DW="ADT;1",DV="RS",DU="",DLB="ADT TRANSFER-IN LINK",DIFLD=1001
 S DU="1:ON;0:OFF;"
 S Y="OFF"
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
X1 Q
2 S DW="ADT;3",DV="RF",DU="",DLB="TRANSFER-IN GLOBAL REF",DIFLD=1003
 S Y="0"
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
X2 K:$L(X)>5!($L(X)<1) X
 I $D(X),X'?.ANP K X
 Q
 ;
3 S DW="ADT;4",DV="RSI",DU="",DLB="TRANSFER-IN DUP OK",DIFLD=1004
 S DU="1:YES;0:NO;"
 S Y="NO"
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
X3 Q
4 S DW="ADT;11",DV="RS",DU="",DLB="ADT READMISSION LINK",DIFLD=1011
 S DU="1:ON;0:OFF;"
 S Y="OFF"
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
X4 Q
5 S DW="ADT;13",DV="RF",DU="",DLB="READMISSION GLOBAL REF",DIFLD=1013
 S Y="0"
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
X5 K:$L(X)>5!($L(X)<1) X
 I $D(X),X'?.ANP K X
 Q
 ;
6 S DW="ADT;14",DV="RSI",DU="",DLB="READMISSION DUP OK",DIFLD=1014
 S DU="1:YES;0:NO;"
 S Y="NO"
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
X6 Q
7 S DW="ADT;21",DV="RS",DU="",DLB="ADT ADMIT AFTER DS LINK",DIFLD=1021
 S DU="1:ON;0:OFF;"
 S Y="OFF"
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
X7 Q
8 S DW="ADT;23",DV="RF",DU="",DLB="ADMIT AFTER DS GLOBAL REF",DIFLD=1023
 S Y="0"
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
X8 K:$L(X)>5!($L(X)<1) X
 I $D(X),X'?.ANP K X
 Q
 ;
9 S DW="ADT;24",DV="RSI",DU="",DLB="ADMIT AFTER DS DUP OK",DIFLD=1024
 S DU="1:YES;0:NO;"
 S Y="NO"
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
X9 Q
10 S DW="ADT;31",DV="RS",DU="",DLB="ADT ICU TRANSFER",DIFLD=1031
 S DU="1:ON;0:OFF;"
 S Y="OFF"
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
X10 Q
11 S DW="ADT;33",DV="RF",DU="",DLB="ICU TRANSFER GLOBAL REF",DIFLD=1033
 S Y="2,AQAOTR,0"
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
X11 K:$L(X)>10!($L(X)<1) X
 I $D(X),X'?.ANP K X
 Q
 ;
12 D:$D(DG)>9 F^DIE17 G ^AQAOT231
