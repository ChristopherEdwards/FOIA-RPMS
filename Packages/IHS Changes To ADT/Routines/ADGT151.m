ADGT151 ; ;05/04/99
 D DE G BEGIN
DE S DIE="^DIC(42,",DIC=DIE,DP=42,DL=1,DIEL=0,DU="" K DG,DE,DB Q:$O(^DIC(42,DA,""))=""
 I $D(^("IHS")) S %Z=^("IHS") S %=$P(%Z,U,1) S:%]"" DE(1)=% S %=$P(%Z,U,2) S:%]"" DE(5)=% S %=$P(%Z,U,3) S:%]"" DE(6)=% S %=$P(%Z,U,5) S:%]"" DE(2)=%
 I $D(^("IHS1")) S %Z=^("IHS1") S %=$P(%Z,U,1) S:%]"" DE(7)=% S %=$P(%Z,U,2) S:%]"" DE(8)=% S %=$P(%Z,U,3) S:%]"" DE(9)=% S %=$P(%Z,U,4) S:%]"" DE(10)=% S %=$P(%Z,U,5) S:%]"" DE(11)=% S %=$P(%Z,U,6) S:%]"" DE(12)=% S %=$P(%Z,U,7) S:%]"" DE(13)=%
 I  S %=$P(%Z,U,8) S:%]"" DE(14)=%
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
BEGIN S DNM="ADGT151",DQ=1
1 S DW="IHS;1",DV="S",DU="",DLB="ICU/SCU WARD?",DIFLD=9999999.01
 S DE(DW)="C1^ADGT151"
 S DU="Y:YES;N:NO;"
 G RE
C1 G C1S:$D(DE(1))[0 K DB S X=DE(1),DIC=DIE
 K ^DIC(42,"AICU",$E(X,1,30),DA)
C1S S X="" Q:DG(DQ)=X  K DB S X=DG(DQ),DIC=DIE
 S ^DIC(42,"AICU",$E(X,1,30),DA)=""
 Q
X1 Q
2 D:$D(DG)>9 F^DIE17,DE S DQ=2,DW="IHS;5",DV="S",DU="",DLB="PROGRESSIVE CARE UNIT?",DIFLD=9999999.05
 S DU="1:YES;0:NO;"
 G RE
X2 Q
3 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=3 D X3 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X3 W !!,"Now you will need to break down the number of authorized beds"
 Q
4 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=4 D X4 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X4 W !,"in the following categories for reporting on the M202 Report.",!
 Q
5 S DW="IHS;2",DV="RNJ2,0",DU="",DLB="# ICU/SCU BEDS",DIFLD=9999999.02
 G RE
X5 K:+X'=X!(X>99)!(X<0)!(X?.E1"."1N.N) X
 Q
 ;
6 S DW="IHS;3",DV="RNJ2,0",DU="",DLB="# PCU BEDS",DIFLD=9999999.03
 G RE
X6 K:+X'=X!(X>99)!(X<0)!(X?.E1"."1N.N) X
 Q
 ;
7 S DW="IHS1;1",DV="RNJ2,0",DU="",DLB="# ADULT MEDICAL BEDS",DIFLD=9999999.11
 G RE
X7 K:+X'=X!(X>99)!(X<0)!(X?.E1"."1N.N) X
 Q
 ;
8 S DW="IHS1;2",DV="RNJ2,0",DU="",DLB="# ADULT SURGICAL BEDS",DIFLD=9999999.12
 G RE
X8 K:+X'=X!(X>99)!(X<0)!(X?.E1"."1N.N) X
 Q
 ;
9 S DW="IHS1;3",DV="RNJ2,0",DU="",DLB="# PEDIATRIC MEDICAL BEDS",DIFLD=9999999.13
 G RE
X9 K:+X'=X!(X>99)!(X<0)!(X?.E1"."1N.N) X
 Q
 ;
10 S DW="IHS1;4",DV="RNJ2,0",DU="",DLB="# PEDIATRIC SURGICAL BEDS",DIFLD=9999999.14
 G RE
X10 K:+X'=X!(X>99)!(X<0)!(X?.E1"."1N.N) X
 Q
 ;
11 S DW="IHS1;5",DV="RNJ2,0",DU="",DLB="# OBSTETRIC BEDS",DIFLD=9999999.15
 G RE
X11 K:+X'=X!(X>99)!(X<0)!(X?.E1"."1N.N) X
 Q
 ;
12 S DW="IHS1;6",DV="RNJ2,0",DU="",DLB="# NEWBORN BEDS",DIFLD=9999999.16
 G RE
X12 K:+X'=X!(X>99)!(X<0)!(X?.E1"."1N.N) X
 Q
 ;
13 S DW="IHS1;7",DV="RNJ2,0",DU="",DLB="# TUBERCULOSIS BEDS",DIFLD=9999999.17
 G RE
X13 K:+X'=X!(X>99)!(X<0)!(X?.E1"."1N.N) X
 Q
 ;
14 S DW="IHS1;8",DV="RNJ2,0",DU="",DLB="# ALCOHOL/SUBSTANCE ABUSE BEDS",DIFLD=9999999.18
 G RE
X14 K:+X'=X!(X>99)!(X<0)!(X?.E1"."1N.N) X
 Q
 ;
15 D:$D(DG)>9 F^DIE17 G ^ADGT152
