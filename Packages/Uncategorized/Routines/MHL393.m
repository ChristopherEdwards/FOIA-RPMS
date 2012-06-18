MHL393 ; GENERATED FROM '393 INPUT TEMP' INPUT TEMPLATE(#745), FILE 1991004;10/17/91
 D DE G BEGIN
DE S DIE="^DIZ(1991004,",DIC=DIE,DP=1991004,DL=1,DIEL=0,DU="" K DG,DE,DB Q:$N(^DIZ(1991004,DA,-1))<0
 I $D(^(0)) S %Z=^(0) S %=$P(%Z,U,1) S:%]"" DE(1)=% S %=$P(%Z,U,2) S:%]"" DE(2)=% S %=$P(%Z,U,3) S:%]"" DE(3)=% S %=$P(%Z,U,4) S:%]"" DE(4)=% S %=$P(%Z,U,5) S:%]"" DE(5)=% S %=$P(%Z,U,6) S:%]"" DE(6)=% S %=$P(%Z,U,7) S:%]"" DE(7)=%
 I  S %=$P(%Z,U,8) S:%]"" DE(8)=% S %=$P(%Z,U,9) S:%]"" DE(9)=% S %=$P(%Z,U,10) S:%]"" DE(10)=%
 K %Z Q
 ;
W W !?DL+DL-2,DLB_": "
 Q
O D W W Y W:$X>45 !?9
 I $L(Y)>19,'DV,DV'["I",(DV["F"!(DV["K")) G RW^DIR2
 W:Y]"" "// " I 'DV,DV["I" S X="" W "  (No Editing)" Q
TR R X:DTIME E  S (DTOUT,X)=U W *7 K DG,DQ
 Q
A K DQ(DQ) S DQ=DQ+1
 I '$D(DDTM),$D(DIE("NO^")),DIE("NO^")="" S DDTM=DTIME,DTIME=DTIME+1800
B G @DQ
RE G PR:$D(DE(DQ)) D W,TR G:$D(DTOUT) QY^DIE1
N I X="" G A:DV'["R",X:'DV,X:D'>0,A
RD G QS:X?."?" I X["^" D D G ^DIE17
 I X="@" D D G Z^DIE2
 I X=" ",DV["d",DV'["P",$D(^DISV(DUZ,"DIE",DLB)) S X=^(DLB) I DV'["D",DV'["S" W "  "_X
T G M^DIE17:DV,^DIE3:DV["V",P:DV'["S" X:$D(^DD(DP,DIFLD,12.1)) ^(12.1) S %=$P($P(";"_DU,";"_X_":",2),";"),Y=X I %]"" X:$D(DIC("S")) DIC("S") I  W:'$D(DB(DQ)) "  "_% G V
 F %=1:1 S Y=$P(DU,";",%),DG=$F(Y,":"_X) G X:Y="" S YS=Y,Y=$P(Y,":") I DG X:$D(DIC("S")) DIC("S") I  Q:DG
 W:'$D(DB(DQ)) $E(YS,DG,999) S X=$P(YS,":")
P I DV["P" S DIC=U_DU,DIC(0)=$E("EN",$D(DB(DQ))+1)_"M"_$E("L",DV'["'") S:DIC(0)["L" DLAYGO=+$P(DV,"P",2) I DV'["*" D ^DIC S X=+Y,DIC=DIE G X:X<0
 G V:DV'["N" D D I $L($P(X,"."))>24 K X G Z
 I +$P(DV,",",2),X[".",$P(DQ(DQ),U,5)'["$" S X=$S($P(X,"00")="":"",$E(X)[0:$E(X,2,$L(X)),1:X) S:$E($P(X,".",2),$L($P(X,".",2)))[0 X=$E(X,1,$L(X)-1) I $P(X,".",2)=""&(X[".") S X=+X
V D @("X"_DQ) K YS
Z K DIC("S"),DLAYGO I $D(X),X'=U S DG(DW)=X S:DV["d" ^DISV(DUZ,"DIE",DLB)=X G A
X W *7,"??" I $D(DB(DQ)) G Z^DIE17
 S X="?BAD"
QS S DZ=X D D,QQ^DIEQ G B
D S D=DIFLD,DQ(DQ)=DLB_U_DV_U_DU_U_DW_U_$P($T(@("X"_DQ))," ",2,99) Q
Y I '$D(DE(DQ)) D O G QY^DIE1:$D(DTOUT),RD:"@"'[X,A:DV'["R"&(X="@"),X:X="@" S X=Y G N
PR S DG=DV,Y=DE(DQ),X=DU I $D(DQ(DQ,2)) X DQ(DQ,2) G RP
R I DG["P",@("$D(^"_X_"0))") S X=+$P(^(0),U,2) G RP:'$D(^(Y,0)) S Y=$P(^(0),U),X=$P(^DD(X,.01,0),U,3),DG=$P(^(0),U,2) G R
 I DG["V",+Y,$P(Y,";",2)["(",$D(@(U_$P(Y,";",2)_"0)")) S X=+$P(^(0),U,2) G RP:'$D(^(+Y,0)) S Y=$P(^(0),U) I $D(^DD(+X,.01,0)) S DG=$P(^(0),U,2),X=$P(^(0),U,3) G R
 X:DG["D" ^DD("DD") I DG["S" S %=$P($P(";"_X,";"_Y_":",2),";") S:%]"" Y=%
RP D O G:$D(DTOUT) QY^DIE1 I X="" S X=DE(DQ) G A:'DV,A:DC<2,N^DIE17
I I DV'["I",DV'["#" G RD
 D E^DIE0 G RD:$D(X),PR
 Q
BEGIN S DNM="MHL393",DQ=1
 S:$D(DTIME)[0 DTIME=999 S D0=DA,DIEZ=745,U="^"
1 S DW="0;1",DV="RF",DU="",DLB="OPEIR INTERNAL NUMBER",DIFLD=.01
 S DE(DW)="C1^MHL393"
 G RE
C1 G C1S:$D(DE(1))[0 K DB S X=DE(1),DIC=DIE
 K ^DIZ(1991004,"B",$E(X,1,30),DA)
C1S S X="" Q:DG(DQ)=X  K DB S X=DG(DQ),DIC=DIE
 S ^DIZ(1991004,"B",$E(X,1,30),DA)=""
 Q
X1 K:$L(X)>30!($L(X)<3)!'(X'?1P.E) X
 I $D(X),X'?.ANP K X
 Q
 ;
2 D:$D(DG)>9 F^DIE17,DE S DQ=2,DW="0;2",DV="RD",DU="",DLB="DATE",DIFLD=1
 G RE
X2 S %DT="E" D ^%DT S X=Y K:Y<1 X
 Q
 ;
3 S DW="0;3",DV="NJ7,0",DU="",DLB="REQUISITION NUMBER",DIFLD=2
 G RE
X3 K:+X'=X!(X>9999999)!(X<0)!(X?.E1"."1N.N) X
 Q
 ;
4 S DW="0;4",DV="F",DU="",DLB="PURCHASE ORDER NUMBER",DIFLD=3
 G RE
X4 K:$L(X)>30!($L(X)<3) X
 I $D(X),X'?.ANP K X
 Q
 ;
5 S DW="0;5",DV="NJ9,2",DU="",DLB="AMOUNT",DIFLD=4
 G RE
X5 S:X["$" X=$P(X,"$",2) K:X'?.N.1".".2N!(X>250000)!(X<0) X
 Q
 ;
6 S DW="0;6",DV="P1991000",DU="",DLB="CAN NUMBER",DIFLD=5
 S DU="DIZ(1991000,"
 G RE
X6 Q
7 S DW="0;7",DV="RP1991008",DU="",DLB="OBJECT CLASS CODE",DIFLD=6
 S DU="DIZ(1991008,"
 G RE
X7 Q
8 S DW="0;8",DV="RP1991005",DU="",DLB="VENDOR",DIFLD=7
 S DU="DIZ(1991005,"
 G RE
X8 Q
9 S DW="0;9",DV="P1991006",DU="",DLB="ITEM DESCRIPTION",DIFLD=8
 S DU="DIZ(1991006,"
 G RE
X9 Q
10 S DW="0;10",DV="F",DU="",DLB="ITEM COMMENTARY",DIFLD=9
 G RE
X10 K:$L(X)>100!($L(X)<3) X
 I $D(X),X'?.ANP K X
 Q
 ;
11 G 0^DIE17
