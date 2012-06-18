ADGT041 ; ;04/08/09
 D DE G BEGIN
DE S DIE="^ADGDS(D0,""DS"",",DIC=DIE,DP=9009012.01,DL=2,DIEL=1,DU="" K DG,DE,DB Q:$O(^ADGDS(D0,"DS",DA,""))=""
 I $D(^(0)) S %Z=^(0) S %=$P(%Z,U,1) S:%]"" DE(2)=% S %=$P(%Z,U,2) S:%]"" DE(3)=% S %=$P(%Z,U,3) S:%]"" DE(6)=%,DE(20)=% S %=$P(%Z,U,4) S:%]"" DE(7)=% S %=$P(%Z,U,5) S:%]"" DE(8)=% S %=$P(%Z,U,6) S:%]"" DE(9)=% S %=$P(%Z,U,7) S:%]"" DE(5)=%
 I $D(^(2)) S %Z=^(2) S %=$P(%Z,U,1) S:%]"" DE(11)=% S %=$P(%Z,U,2) S:%]"" DE(17)=% S %=$P(%Z,U,3) S:%]"" DE(14)=% S %=$P(%Z,U,4) S:%]"" DE(12)=% S %=$P(%Z,U,5) S:%]"" DE(16)=% S %=$P(%Z,U,7) S:%]"" DE(4)=%
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
BEGIN S DNM="ADGT041",DQ=1
1 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=1 D X1 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X1 W:$P(^ADGDS(DFN,"DS",DGDFN1,0),"^")'["." !!,?5,"Remember to include the time before discharging the patient",!
 Q
2 S DW="0;1",DV="D",DU="",DLB="DAY SURGERY DATE/TIME",DIFLD=.01
 S DE(DW)="C2^ADGT041"
 G RE
C2 G C2S:$D(DE(2))[0 K DB
 S X=DE(2),DIC=DIE
 K ^ADGDS("AA",$E(X,1,30),DA(1),DA)
 S X=DE(2),DIC=DIE
 K ^ADGDS(DA(1),"DS","AA",$E(X,1,30),DA)
 S X=DE(2),DIC=DIE
 K ^ADGDS("APID",DA(1),9999999.9999999-$E(X,1,30),DA)
 S X=DE(2),DIC=DIE
 K ^ADGDS("AD",DA(1),$P(X,"."),DA)
C2S S X="" G:DG(DQ)=X C2F1 K DB
 S X=DG(DQ),DIC=DIE
 S ^ADGDS("AA",$E(X,1,30),DA(1),DA)=""
 S X=DG(DQ),DIC=DIE
 S ^ADGDS(DA(1),"DS","AA",$E(X,1,30),DA)=""
 S X=DG(DQ),DIC=DIE
 S ^ADGDS("APID",DA(1),9999999.9999999-$E(X,1,30),DA)=""
 S X=DG(DQ),DIC=DIE
 S ^ADGDS("AD",DA(1),$P(X,"."),DA)=""
C2F1 Q
X2 S %DT="ETXR" D ^%DT S X=Y K:Y<1 X
 Q
 ;
3 D:$D(DG)>9 F^DIE17,DE S DQ=3,DW="0;2",DV="RFX",DU="",DLB="PROCEDURE",DIFLD=1
 G RE
X3 K:$L(X)>30!($L(X)<3)!'(X'[";") X
 I $D(X),X'?.ANP K X
 Q
 ;
4 S DW="2;7",DV="RF",DU="",DLB="DIAGNOSIS",DIFLD=1.5
 G RE
X4 K:$L(X)>30!($L(X)<3) X
 I $D(X),X'?.ANP K X
 Q
 ;
5 S DW="0;7",DV="DX",DU="",DLB="DATE/TIME TO OBSERVATION",DIFLD=9
 S DE(DW)="C5^ADGT041"
 G RE
C5 G C5S:$D(DE(5))[0 K DB
 S X=DE(5),DIC=DIE
 K ^ADGDS("AC",$E(X,1,30),DA(1),DA)
C5S S X="" G:DG(DQ)=X C5F1 K DB
 S X=DG(DQ),DIC=DIE
 S ^ADGDS("AC",$E(X,1,30),DA(1),DA)=""
C5F1 Q
X5 S %DT="ETXR" D ^%DT S X=Y K:Y<1 X I $D(X) K:+^ADGDS(DA(1),"DS",DA,0)'<X X I $D(^ADGDS(DA(1),"DS",DA,2)),+^(2)'=0 K:+^(2)'>X X
 Q
 ;
6 D:$D(DG)>9 F^DIE17,DE S DQ=6,DW="0;3",DV="P42'",DU="",DLB="WARD LOCATION",DIFLD=2
 S DE(DW)="C6^ADGT041"
 S DU="DIC(42,"
 G RE
C6 G C6S:$D(DE(6))[0 K DB
 S X=DE(6),DIC=DIE
 K ^ADGDS("CN",$P(^DIC(42,X,0),"^"),DA(1),DA)
C6S S X="" G:DG(DQ)=X C6F1 K DB
 S X=DG(DQ),DIC=DIE
 S ^ADGDS("CN",$P(^DIC(42,X,0),"^"),DA(1),DA)=""
C6F1 Q
X6 Q
7 D:$D(DG)>9 F^DIE17,DE S DQ=7,DW="0;4",DV="FX",DU="",DLB="ROOM-BED",DIFLD=3
 S DE(DW)="C7^ADGT041"
 G RE
C7 G C7S:$D(DE(7))[0 K DB
 S X=DE(7),DIC=DIE
 K ^ADGDS("RM",$E(X,1,30),DA(1),DA)
C7S S X="" G:DG(DQ)=X C7F1 K DB
 S X=DG(DQ),DIC=DIE
 S ^ADGDS("RM",$E(X,1,30),DA(1),DA)=""
C7F1 Q
X7 ; K:X[""""!($A(X)=45) X I $D(X) S Z=$P(X,"-",2) K:Z=""&(X'="*")!($P(^ADGDS(DA(1),"DS",DA,0),"^",3)="") X I $D(X) S Y=$P(^(0),U,3),%=$S($D(^DIC(42,Y,0)):$P(^(0),U,1),1:"") K:Y="" X I $D(X) S DFN=DA(1) D ^DGBEDC
 I $D(X),X'?.ANP K X
 Q
 ;
8 D:$D(DG)>9 F^DIE17,DE S DQ=8,DW="0;5",DV="RP45.7'",DU="",DLB="SPECIALTY",DIFLD=4
 S DU="DIC(45.7,"
 G RE
X8 Q
9 S DW="0;6",DV="P200'",DU="",DLB="PROVIDER",DIFLD=5
 S DU="VA(200,"
 G RE
X9 Q
10 S D=0 K DE(1) ;6
 S Y="INTERVIEW COMMENTS^W^^0;1^Q",DG="1",DC="^9009012.02" D DIEN^DIWE K DE(1) G A
 ;
11 S DW="2;1",DV="DX",DU="",DLB="RELEASE DATE/TIME",DIFLD=7
 S DE(DW)="C11^ADGT041"
 G RE
C11 G C11S:$D(DE(11))[0 K DB
 S X=DE(11),DIC=DIE
 S:$D(^ADGDS(DA(1),"DS",DA,0)) XX=$P(^(0),"^",3) S:XX ^ADGDS("CN",$P(^DIC(42,XX,0),"^"),DA(1),DA)=""
 S X=DE(11),DIC=DIE
 S XX=$S($D(^ADGDS(DA(1),"DS",DA,0)):$P(^(0),"^",4),1:"") S:XX'="" ^ADGDS("RM",XX,DA(1),DA)=""
C11S S X="" G:DG(DQ)=X C11F1 K DB
 S X=DG(DQ),DIC=DIE
 S:$D(^ADGDS(DA(1),"DS",DA,0)) XX=$P(^(0),"^",3) K:XX ^ADGDS("CN",$P(^DIC(42,XX,0),"^"),DA(1),DA)
 S X=DG(DQ),DIC=DIE
 S XX=$S($D(^ADGDS(DA(1),"DS",DA,0)):$P(^(0),"^",4),1:"") K:XX'="" ^ADGDS("RM",XX,DA(1),DA)
C11F1 Q
X11 S %DT="ETXR" D ^%DT S X=Y K:Y<1 X I $D(X),+^ADGDS(DA(1),"DS",DA,0)'<X K X W !,"Must be after Day Surgery Date/Time"
 Q
 ;
12 D:$D(DG)>9 F^DIE17,DE S DQ=12,DW="2;4",DV="S",DU="",DLB="NO-SHOW?",DIFLD=13
 S DU="Y:YES;"
 G RE
X12 Q
13 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=13 D X13 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X13 S Y=$S(X="Y":"@3",1:12)
 Q
14 S DW="2;3",DV="S",DU="",DLB="SURGERY CANCELLED?",DIFLD=12
 S DU="Y:YES;"
 G RE
X14 Q
15 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=15 D X15 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X15 S Y=$S(X="Y":"@3",1:15)
 Q
16 S DW="2;5",DV="Sa",DU="",DLB="UNESCORTED?",DIFLD=15
 S DE(DW)="C16^ADGT041"
 S DU="Y:YES;"
 G RE
C16 G C16S:$D(DE(16))[0 K DB
 S X=DE(16),DIIX=2_U_DIFLD D AUDIT^DIET
C16S S X="" G:DG(DQ)=X C16F1 K DB
 I $D(DE(16))'[0!(^DD(DP,DIFLD,"AUDIT")'="e") S X=DG(DQ),DIIX=3_U_DIFLD D AUDIT^DIET
C16F1 Q
X16 Q
17 D:$D(DG)>9 F^DIE17,DE S DQ=17,DW="2;2",DV="S",DU="",DLB="PATIENT ADMITTED?",DIFLD=11
 S DU="Y:YES;"
 G RE
X17 Q
18 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=18 D X18 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X18 S Y="@2"
 Q
19 S DQ=20 ;@3
20 S DW="0;3",DV="P42'",DU="",DLB="WARD LOCATION",DIFLD=2
 S DE(DW)="C20^ADGT041"
 S DU="DIC(42,"
 S X=$S($P(^ADGDS(DFN,"DS",DGDFN1,0),"^",3)'="":"@",1:"")
 S Y=X
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
C20 G C20S:$D(DE(20))[0 K DB
 D ^ADGT042
C20S S X="" G:DG(DQ)=X C20F1 K DB
 D ^ADGT043
C20F1 Q
X20 Q
21 S DQ=22 ;@2
22 D:$D(DG)>9 F^DIE17 G ^ADGT044
