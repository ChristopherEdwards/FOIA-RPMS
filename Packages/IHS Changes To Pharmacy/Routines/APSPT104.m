APSPT104 ; IHS/DSD/ENM - NO DESCRIPTION PROVIDED 10/11/91 ; [ 09/03/97 1:30 PM ]
 ;;6.0;IHS PHARMACY MODIFICATIONS;;09/03/97
 D DE G BEGIN
DE S DIE="^APSPP(31,",DIC=DIE,DP=9009031,DL=1,DIEL=0,DU="" K DG,DE,DB Q:$O(^APSPP(31,DA,-1))<0
 I $D(^(0)) S %Z=^(0) S %=$P(%Z,U,12) S:%]"" DE(4)=% S %=$P(%Z,U,13) S:%]"" DE(1)=% S %=$P(%Z,U,14) S:%]"" DE(2)=%
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
BEGIN S DNM="APSPT104",DQ=1
1 D:$D(DG)>9 F^DIE17,DE S DQ=1,DW="0;13",DV="RIP3'",DU="",DLB="CLERK CODE",DIFLD=.13
 S DU="DIC(3,"
 G RE
X1 Q
2 S DW="0;14",DV="R*P3'I",DU="",DLB="PHARMACIST",DIFLD=.14
 S DU="DIC(3,"
 G RE
X2 S DIC("S")="I $D(^XUSEC(""PSRPH"",Y))" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
 Q
 ;
3 S D=0 K DE(1) ;1501
 S DIFLD=1501,DGO="^APSPT105",DC="3^9009031.15PA^15^",DV="9009031.15M*P9009031.2",DW="0;1",DOW="LOCATION",DLB="Select "_DOW
 S DU="APSPP(31.2,"
 G RE:D I $D(DSC(9009031.15))#2,$P(DSC(9009031.15),"I $D(^TMP(",1)="" X DSC(9009031.15) S D=$O(^(0)) G M3
 S D=$S($D(^APSPP(31,DA,15,0)):$P(^(0),U,3,4),1:$O(^(0)))
M3 I D>0 S DC=DC_D I $D(^APSPP(31,DA,15,+D,0)) S DE(3)=$P(^(0),U,1)
 G RE
R3 D DE
 S D=1 G 3+1
 ;
4 S DW="0;12",DV="F",DU="",DLB="REMARKS",DIFLD=.12
 G RE
X4 K:$L(X)>80!($L(X)<1) X
 I $D(X),X'?.ANP K X
 Q
 ;
5 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=5 D X5 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X5 I $D(%PSITE),$P(%PSITE,U,1)'=1 S Y=""
 Q
6 D:$D(DG)>9 F^DIE17 G ^APSPT106
