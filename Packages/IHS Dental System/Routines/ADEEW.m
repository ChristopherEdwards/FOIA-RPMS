ADEEW ; GENERATED FROM 'ADEFEWS' INPUT TEMPLATE(#1850), FILE 9002004;06/04/99
 D DE G BEGIN
DE S DIE="^ADEWS(",DIC=DIE,DP=9002004,DL=1,DIEL=0,DU="" K DG,DE,DB Q:$O(^ADEWS(DA,""))=""
 I $D(^(0)) S %Z=^(0) S %=$P(%Z,U,1) S:%]"" DE(1)=% S %=$P(%Z,U,2) S:%]"" DE(2)=% S %=$P(%Z,U,3) S:%]"" DE(3)=% S %=$P(%Z,U,4) S:%]"" DE(4)=% S %=$P(%Z,U,5) S:%]"" DE(6)=% S %=$P(%Z,U,6) S:%]"" DE(5)=% S %=$P(%Z,U,7) S:%]"" DE(7)=%
 I  S %=$P(%Z,U,8) S:%]"" DE(8)=%
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
BEGIN S DNM="ADEEW",DQ=1
 S:$D(DTIME)[0 DTIME=300 S D0=DA,DIEZ=1850,U="^"
1 S DW="0;1",DV="RF",DU="",DLB="NAME",DIFLD=.01
 S DE(DW)="C1^ADEEW"
 G RE
C1 G C1S:$D(DE(1))[0 K DB S X=DE(1),DIC=DIE
 K ^ADEWS("B",$E(X,1,30),DA)
C1S S X="" Q:DG(DQ)=X  K DB S X=DG(DQ),DIC=DIE
 S ^ADEWS("B",$E(X,1,30),DA)=""
 Q
X1 K:$L(X)>30!(X?.N)!($L(X)<3)!'(X'?1P.E) X
 I $D(X),X'?.ANP K X
 Q
 ;
2 D:$D(DG)>9 F^DIE17,DE S DQ=2,DW="0;2",DV="RF",DU="",DLB="SFC CODE",DIFLD=1
 S DE(DW)="C2^ADEEW"
 G RE
C2 G C2S:$D(DE(2))[0 K DB S X=DE(2),DIC=DIE
 I $D(^ADEWS("B",$E(X,1,30),DA)),^(DA) K ^(DA)
C2S S X="" Q:DG(DQ)=X  K DB S X=DG(DQ),DIC=DIE
 S:'$D(^ADEWS("B",$E(X,1,30),DA)) ^(DA)=1
 Q
X2 K:$L(X)>7!($L(X)<7) X
 I $D(X),X'?.ANP K X
 Q
 ;
3 D:$D(DG)>9 F^DIE17,DE S DQ=3,DW="0;3",DV="F",DU="",DLB="MNEMONIC",DIFLD=2
 S DE(DW)="C3^ADEEW"
 G RE
C3 G C3S:$D(DE(3))[0 K DB S X=DE(3),DIC=DIE
 I $D(^ADEWS("B",$E(X,1,30),DA)),^(DA) K ^(DA)
C3S S X="" Q:DG(DQ)=X  K DB S X=DG(DQ),DIC=DIE
 S:'$D(^ADEWS("B",$E(X,1,30),DA)) ^(DA)=1
 Q
X3 K:$L(X)>3!($L(X)<1) X
 I $D(X),X'?.ANP K X
 Q
 ;
4 D:$D(DG)>9 F^DIE17,DE S DQ=4,DW="0;4",DV="RNJ4,2",DU="",DLB="NATURAL FLUORIDE CONCENTRATION",DIFLD=3
 G RE
X4 K:+X'=X!(X>9.9)!(X<0)!(X?.E1"."3N.N) X
 Q
 ;
5 S DW="0;6",DV="P9999999.05'",DU="",DLB="COMMUNITY",DIFLD=4
 S DU="AUTTCOM("
 G RE
X5 Q
6 S DW="0;5",DV="RS",DU="",DLB="OPTIMUM FLUORIDE CONCENTRATION",DIFLD=5
 S DU="A:1.2;B:1.1;C:1.0;D:.9;E:.8;F:.7;G:5.4;H:5.0;I:4.5;J:4.1;K:3.6;L:3.2;"
 G RE
X6 Q
7 S DW="0;7",DV="NJ7,0",DU="",DLB="POPULATION SERVED",DIFLD=6
 G RE
X7 K:+X'=X!(X>9999999)!(X<1)!(X?.E1"."1N.N) X
 Q
 ;
8 S DW="0;8",DV="S",DU="",DLB="INACTIVE",DIFLD=7
 S DU="y:YES;n:NO;"
 G RE
X8 Q
9 G 0^DIE17
