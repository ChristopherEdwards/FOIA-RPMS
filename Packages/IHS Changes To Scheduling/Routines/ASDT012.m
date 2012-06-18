ASDT012 ; ;06/30/03
 D DE G BEGIN
DE S DIE="^SC(",DIC=DIE,DP=44,DL=1,DIEL=0,DU="" K DG,DE,DB Q:$O(^SC(DA,""))=""
 I $D(^(99)) S %Z=^(99) S %=$P(%Z,U,1) S:%]"" DE(8)=%
 I $D(^(9999999)) S %Z=^(9999999) S %=$P(%Z,U,7) S:%]"" DE(9)=% S %=$P(%Z,U,8) S:%]"" DE(3)=% S %=$P(%Z,U,9) S:%]"" DE(2)=% S %=$P(%Z,U,13) S:%]"" DE(5)=% S %=$P(%Z,U,14) S:%]"" DE(1)=% S %=$P(%Z,U,15) S:%]"" DE(4)=%
 I $D(^("AT")) S %Z=^("AT") S %=$P(%Z,U,1) S:%]"" DE(7)=%
 I $D(^("LTR")) S %Z=^("LTR") S %=$P(%Z,U,1) S:%]"" DE(12)=% S %=$P(%Z,U,2) S:%]"" DE(13)=%
 I $D(^("PS")) S %Z=^("PS") S %=$P(%Z,U,1) S:%]"" DE(11)=%
 I $D(^("RAD")) S %Z=^("RAD") S %=$P(%Z,U,1) S:%]"" DE(10)=%
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
N I X="" G NKEY:$D(^DD("KEY","F",DP,DIFLD)),A:DV'["R",X:'DV,X:D'>0,A
RD G QS:X?."?" I X["^" D D G ^DIE17
 I X="@" D D G Z^DIE2
 I X=" ",DV["d",DV'["P",$D(^DISV(DUZ,"DIE",DLB)) S X=^(DLB) I DV'["D",DV'["S" W "  "_X
T G M^DIE17:DV,^DIE3:DV["V",P:DV'["S" X:$D(^DD(DP,DIFLD,12.1)) ^(12.1) I X?.ANP D SET I 'DDER X:$D(DIC("S")) DIC("S") I  W:'$D(DB(DQ)) "  "_% G V
 K DDER G X
P I DV["P" S DIC=U_DU,DIC(0)=$E("EN",$D(DB(DQ))+1)_"M"_$E("L",DV'["'") S:DIC(0)["L" DLAYGO=+$P(DV,"P",2) G:DV["*" AST^DIED D NOSCR^DIED S X=+Y,DIC=DIE G X:X<0
 G V:DV'["N" D D I $L($P(X,"."))>24 K X G Z
 I $P(DQ(DQ),U,5)'["$",X?.1"-".N.1".".N,$P(DQ(DQ),U,5,99)["+X'=X" S X=+X
V D @("X"_DQ) K YS
Z K DIC("S"),DLAYGO I $D(X),X'=U D:$G(DE(DW,"INDEX")) SAVEVALS G:'$$KEYCHK UNIQFERR^DIE17 S DG(DW)=X S:DV["d" ^DISV(DUZ,"DIE",DLB)=X G A
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
SAVEVALS S @DIEZTMP@("V",DP,DIIENS,DIFLD,"O")=$G(DE(DQ)) S:$D(^("F"))[0 ^("F")=$G(DE(DQ))
 I $D(DE(DW,"4/")) S @DIEZTMP@("V",DP,DIIENS,DIFLD,"4/")=""
 E  K @DIEZTMP@("V",DP,DIIENS,DIFLD,"4/")
 Q
NKEY W:'$D(ZTQUEUED) "??  Required key field" S X="?BAD" G QS
KEYCHK() Q:$G(DE(DW,"KEY"))="" 1 Q @DE(DW,"KEY")
BEGIN S DNM="ASDT012",DQ=1
1 S DW="9999999;14",DV="S",DU="",DLB="MULTIPLE CLINIC CODES USED?",DIFLD=9999999.14
 S DU="0:NO;1:YES;"
 G RE
X1 Q
2 S DW="9999999;9",DV="S",DU="",DLB="CREATE VISIT AT CHECK-IN?",DIFLD=9999999.9
 S DU="0:NO;1:YES;"
 G RE
X2 Q
3 S DW="9999999;8",DV="*P200'",DU="",DLB="DEFAULT VISIT PROVIDER",DIFLD=9999999.8
 S DU="VA(200,"
 G RE
X3 S DIC("S")="I $D(^XUSEC(""PROVIDER"",+Y))" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
 Q
 ;
4 S DW="9999999;15",DV="S",DU="",DLB="VISIT PROVIDER REQUIRED?",DIFLD=9999999.15
 S DU="0:NO;1:YES;"
 G RE
X4 Q
5 S DW="9999999;13",DV="F",DU="",DLB="PYXIS LOCATION",DIFLD=9999999.13
 G RE
X5 K:$L(X)>10!($L(X)<1) X
 I $D(X),X'?.ANP K X
 Q
 ;
6 S DQ=7 ;@999999901
7 S DW="AT;1",DV="*P409.1'",DU="",DLB="DEFAULT APPOINTMENT TYPE",DIFLD=2507
 S DU="SD(409.1,"
 S Y="REGULAR"
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
X7 S DIC("S")="I '$P(^(0),U,3)" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
 Q
 ;
8 S DW="99;1",DV="F",DU="",DLB="TELEPHONE",DIFLD=99
 G RE
X8 K:$L(X)>13!($L(X)<3) X
 I $D(X),X'?.ANP K X
 Q
 ;
9 S DW="9999999;7",DV="F",DU="",DLB="APPOINTMENT SLIP STATEMENT",DIFLD=9999999.7
 G RE
X9 K:$L(X)>50!($L(X)<3) X
 I $D(X),X'?.ANP K X
 Q
 ;
10 S DW="RAD;1",DV="S",DU="",DLB="REQUIRE X-RAY FILMS?",DIFLD=2000
 S DU="Y:YES;"
 G RE
X10 Q
11 S DW="PS;1",DV="RS",DU="",DLB="REQUIRE ACTION PROFILES?",DIFLD=2000.5
 S DU="0:YES;1:NO;"
 S Y="N"
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
X11 Q
12 S DW="LTR;1",DV="*P407.5'",DU="",DLB="NO SHOW LETTER",DIFLD=2508
 S DE(DW)="C12^ASDT012"
 S DU="VA(407.5,"
 G RE
C12 G C12S:$D(DE(12))[0 K DB
 S X=DE(12),DIC=DIE
 K ^SC("ALTN",$E(X,1,30),DA)
C12S S X="" Q:DG(DQ)=X  K DB
 S X=DG(DQ),DIC=DIE
 S ^SC("ALTN",$E(X,1,30),DA)=""
 Q
X12 S DIC("S")="I $P(^(0),""^"",2)=""N""" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
 Q
 ;
13 D:$D(DG)>9 F^DIE17,DE S DQ=13,DW="LTR;2",DV="*P407.5'",DU="",DLB="PRE-APPOINTMENT LETTER",DIFLD=2509
 S DE(DW)="C13^ASDT012"
 S DU="VA(407.5,"
 G RE
C13 G C13S:$D(DE(13))[0 K DB
 D ^ASDT013
C13S S X="" Q:DG(DQ)=X  K DB
 D ^ASDT014
 Q
X13 S DIC("S")="I $P(^(0),""^"",2)=""P""" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
 Q
 ;
14 D:$D(DG)>9 F^DIE17 G ^ASDT015
