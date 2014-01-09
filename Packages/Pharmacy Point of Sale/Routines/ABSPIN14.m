ABSPIN14 ; ;08/10/13
 D DE G BEGIN
DE S DIE="^ABSP(9002313.56,",DIC=DIE,DP=9002313.56,DL=1,DIEL=0,DU="" K DG,DE,DB Q:$O(^ABSP(9002313.56,DA,""))=""
 I $D(^(0)) S %Z=^(0) S %=$P(%Z,U,4) S:%]"" DE(22)=%
 I $D(^("ADDR")) S %Z=^("ADDR") S %=$P(%Z,U,1) S:%]"" DE(23)=%
 I $D(^("CAID")) S %Z=^("CAID") S %=$P(%Z,U,2) S:%]"" DE(1)=%
 I $D(^("REP")) S %Z=^("REP") S %=$P(%Z,U,3) S:%]"" DE(11)=% S %=$P(%Z,U,4) S:%]"" DE(13)=%
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
BEGIN S DNM="ABSPIN14",DQ=1
1 D:$D(DG)>9 F^DIE17,DE S DQ=1,DW="CAID;2",DV="Fa",DU="",DLB="DEFAULT CAID PROVIDER #",DIFLD=3001.02
 S DE(DW)="C1^ABSPIN14"
 G RE
C1 G C1S:$D(DE(1))[0 K DB
 S X=DE(1),DIIX=2_U_DIFLD D AUDIT^DIET
C1S S X="" G:DG(DQ)=X C1F1 K DB
 I $D(DE(1))'[0!(^DD(DP,DIFLD,"AUDIT")'="e") S X=DG(DQ),DIIX=3_U_DIFLD D AUDIT^DIET
C1F1 Q
X1 K:$L(X)>10!($L(X)<1) X
 I $D(X),X'?.ANP K X
 Q
 ;
2 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=2 D X2 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X2 W !!,"INSURER-ASSIGNED #:  Usually, private insurance claims require the",!
 Q
3 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=3 D X3 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X3 W ?10,"NCPDP #.  But if any insurers have special numbers assigned to",!
 Q
4 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=4 D X4 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X4 W ?10,"your pharmacy to be used on their claims, then enter those",!
 Q
5 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=5 D X5 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X5 W ?10,"insurers and the numbers they assigned to you.",!
 Q
6 D:$D(DG)>9 F^DIE17,DE S DQ=6,D=0 K DE(1) ;950
 S DIFLD=950,DGO="^ABSPIN15",DC="4^9002313.6P^INSURER-ASSIGNED #^",DV="9002313.6MP9999999.18'a",DW="0;1",DOW="INSURER",DLB=$P($$EZBLD^DIALOG(8042,DOW),":") S:D DC=DC_D
 S DU="AUTNINS("
 G RE:D I $D(DSC(9002313.6))#2,$P(DSC(9002313.6),"I $D(^UTILITY(",1)="" X DSC(9002313.6) S D=$O(^(0)) S:D="" D=-1 G M6
 S D=$S($D(^ABSP(9002313.56,DA,"INSURER-ASSIGNED #",0)):$P(^(0),U,3,4),$O(^(0))'="":$O(^(0)),1:-1)
M6 I D>0 S DC=DC_D I $D(^ABSP(9002313.56,DA,"INSURER-ASSIGNED #",+D,0)) S DE(6)=$P(^(0),U,1)
 G RE
R6 D DE
 S D=$S($D(^ABSP(9002313.56,DA,"INSURER-ASSIGNED #",0)):$P(^(0),U,3,4),1:1) G 6+1
 ;
7 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=7 D X7 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X7 W !!,"Auto-Print Pharmacy Expense Report for:",!
 Q
8 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=8 D X8 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X8 W ?10,"""1"" All Patients.",!
 Q
9 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=9 D X9 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X9 W ?10,"""0"" No Patients. (Do not print)",!
 Q
10 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=10 D X10 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X10 W ?10,"""NB"" Non-Beneficiary Patients only.",!
 Q
11 S DW="REP;3",DV="Sa",DU="",DLB="AUTOPRINT PHARMACY EXPENSE RPT",DIFLD=115
 S DE(DW)="C11^ABSPIN14"
 S DU="1:All Patients;0:No Patients;NB:Only Non-Beneficiary Patients;"
 G RE
C11 G C11S:$D(DE(11))[0 K DB
 S X=DE(11),DIIX=2_U_DIFLD D AUDIT^DIET
C11S S X="" G:DG(DQ)=X C11F1 K DB
 I $D(DE(11))'[0!(^DD(DP,DIFLD,"AUDIT")'="e") S X=DG(DQ),DIIX=3_U_DIFLD D AUDIT^DIET
C11F1 Q
X11 Q
12 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=12 D X12 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X12 W !!,"What Device should the Pharmacy Expense Reports print to? ",!
 Q
13 D:$D(DG)>9 F^DIE17,DE S DQ=13,DW="REP;4",DV="P3.5'a",DU="",DLB="DEFAULT DEVICE",DIFLD=115.01
 S DE(DW)="C13^ABSPIN14"
 S DU="%ZIS(1,"
 G RE
C13 G C13S:$D(DE(13))[0 K DB
 S X=DE(13),DIIX=2_U_DIFLD D AUDIT^DIET
C13S S X="" G:DG(DQ)=X C13F1 K DB
 I $D(DE(13))'[0!(^DD(DP,DIFLD,"AUDIT")'="e") S X=DG(DQ),DIIX=3_U_DIFLD D AUDIT^DIET
C13F1 Q
X13 Q
14 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=14 D X14 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X14 I '$$ILCAR^ABSPOSS1 S Y="@999"
 Q
15 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=15 D X15 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X15 W !!,"These fields are used for printing pharmacy claims for non-electronic",!
 Q
16 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=16 D X16 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X16 W "insurers.  If you omit this data, the system will use the general",!
 Q
17 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=17 D X17 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X17 W "billing system setup information.",!
 Q
18 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=18 D X18 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X18 W !!,"The AR TYPE is required.  When charges from this pharmacy",!
 Q
19 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=19 D X19 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X19 W "are posted to Accounts Receivable, this is the AR TYPE assigned",!
 Q
20 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=20 D X20 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X20 W "to those accounts.  It might default if you have an RX type",!
 Q
21 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=21 D X21 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X21 W "but you should explicitly assign an A/R type here.",!
 Q
22 D:$D(DG)>9 F^DIE17,DE S DQ=22,DW="0;4",DV="P9001626'",DU="",DLB="AR TYPE",DIFLD=.04
 S DU="ABSBTYP("
 G RE
X22 Q
23 S DW="ADDR;1",DV="F",DU="",DLB="SITE ADDRESS 1",DIFLD=120.01
 G RE
X23 K:$L(X)>25!($L(X)<1) X
 I $D(X),X'?.ANP K X
 Q
 ;
24 D:$D(DG)>9 F^DIE17 G ^ABSPIN16
