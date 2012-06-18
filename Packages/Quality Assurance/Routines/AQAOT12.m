AQAOT12 ; GENERATED FROM 'AQAO CLOSE OUT' INPUT TEMPLATE(#1142), FILE 9002167;05/13/96
 D DE G BEGIN
DE S DIE="^AQAOC(",DIC=DIE,DP=9002167,DL=1,DIEL=0,DU="" K DG,DE,DB Q:$O(^AQAOC(DA,""))=""
 I $D(^(1)) S %Z=^(1) S %=$P(%Z,U,1) S:%]"" DE(1)=%
 I $D(^("FINAL")) S %Z=^("FINAL") S %=$P(%Z,U,1) S:%]"" DE(4)=% S %=$P(%Z,U,2) S:%]"" DE(5)=% S %=$P(%Z,U,3) S:%]"" DE(6)=% S %=$P(%Z,U,4) S:%]"" DE(9)=% S %=$P(%Z,U,5) S:%]"" DE(2)=% S %=$P(%Z,U,6) S:%]"" DE(10)=% S %=$P(%Z,U,7) S:%]"" DE(7)=%
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
BEGIN S DNM="AQAOT12",DQ=1
 S:$D(DTIME)[0 DTIME=300 S D0=DA,DIEZ=1142,U="^"
1 S DW="1;1",DV="RS",DU="",DLB="CASE STATUS",DIFLD=.11
 S DE(DW)="C1^AQAOT12"
 S DU="0:OPEN;1:CLOSED;2:DELETED;"
 S Y="1"
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G Z
C1 G C1S:$D(DE(1))[0 K DB S X=DE(1),DIC=DIE
 X "K ^AQAOC(""AD"",$E(X,1,30),DA) S:X=2 ^AQAOC(""AFF"",$P(^AQAOC(DA,0),U),DA)="""""
 S X=DE(1),DIC=DIE
 X "S AQAO=$G(^AQAOC(DA,0)),AQAO(""DT"")=$P(AQAO,U,4) K:AQAO(""DT"")]"""" ^AQAOC(""ACL"",AQAO(""DT""),DA) K AQAO"
C1S S X="" Q:DG(DQ)=X  K DB S X=DG(DQ),DIC=DIE
 X "S ^AQAOC(""AD"",$E(X,1,3),DA)="""" K:X=2 ^AQAOC(""AFF"",$P(^AQAOC(DA,0),U),DA)"
 S X=DG(DQ),DIC=DIE
 X "S AQAO=$G(^AQAOC(DA,0)),AQAO(""DT"")=$P(AQAO,U,4) S:(X=1)&(AQAO(""DT"")]"""") ^AQAOC(""ACL"",AQAO(""DT""),DA)="""" K AQAO"
 Q
X1 Q
2 D:$D(DG)>9 F^DIE17,DE S DQ=2,DW="FINAL;5",DV="P9002168.9'",DU="",DLB="CLOSED BY",DIFLD=95
 S DU="AQAO(9,"
 S X="`"_DUZ
 S Y=X
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
X2 Q
3 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=3 G A
4 S DW="FINAL;1",DV="D",DU="",DLB="DATE CASE CLOSED",DIFLD=91
 S Y="TODAY"
 G Y
X4 S %DT="EX" D ^%DT S X=Y K:Y<1 X
 Q
 ;
5 S DW="FINAL;2",DV="P9002168.7'",DU="",DLB="FINAL REVIEW STAGE",DIFLD=92
 S DU="AQAO(7,"
 G RE
X5 Q
6 S DW="FINAL;3",DV="*P9002169.3'O",DU="",DLB="FINAL OUTCOME POTENTIAL",DIFLD=93
 S DQ(6,2)="S Y(0)=Y S:Y]"""" Y=$P(^AQAO1(3,Y,0),U)_""   ""_$P(^(0),U,2)"
 S DU="AQAO1(3,"
 G RE
X6 S DIC("S")="I $P(^AQAO1(3,Y,0),U,3)="""",$P(^(0),U,2)'=""""" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
 Q
 ;
7 S DW="FINAL;7",DV="*P9002169.3'O",DU="",DLB="FINAL OCC OUTCOME LEVEL",DIFLD=97
 S DQ(7,2)="S Y(0)=Y S:Y]"""" Y=$P(^AQAO1(3,Y,0),U)_""   ""_$P(^(0),U,4)"
 S DU="AQAO1(3,"
 G RE
X7 S DIC("S")="I $P(^AQAO1(3,Y,0),U,3)="""",$P(^(0),U,4)'=""""" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
 Q
 ;
8 S DW="FINAL;8",DV="*P9002169.3'O",DU="",DLB="ULTIMATE PATIENT OUTCOME",DIFLD=98
 S DQ(8,2)="S Y(0)=Y S:Y]"""" Y=$P(^AQAO1(3,Y,0),U)_""   ""_$P(^(0),U,5)"
 S DU="AQAO1(3,"
 G RE
X8 S DIC("S")="I $P(^AQAO1(3,Y,0),U,3)="""",$P(^(0),U,5)'=""""" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
 Q
 ;
9 S DW="FINAL;4",DV="P9002168.8'",DU="",DLB="CONCLUSION",DIFLD=94
 S DU="AQAO(8,"
 G RE
X9 Q
10 S DW="FINAL;6",DV="P9002168.6'",DU="",DLB="FINAL ACTION",DIFLD=96
 S DU="AQAO(6,"
 G RE
X10 Q
11 G 0^DIE17
