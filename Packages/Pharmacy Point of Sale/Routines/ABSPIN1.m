ABSPIN1 ; GENERATED FROM 'ABSP SETUP PHARMACY' INPUT TEMPLATE(#2388), FILE 9002313.56;01/20/12
 D DE G BEGIN
DE S DIE="^ABSP(9002313.56,",DIC=DIE,DP=9002313.56,DL=1,DIEL=0,DU="" K DG,DE,DB Q:$O(^ABSP(9002313.56,DA,""))=""
 I $D(^(0)) S %Z=^(0) S %=$P(%Z,U,2) S:%]"" DE(11)=% S %=$P(%Z,U,3) S:%]"" DE(16)=% S %=$P(%Z,U,4) S:%]"" DE(49)=% S %=$P(%Z,U,6) S:%]"" DE(8)=%
 I $D(^("CAID")) S %Z=^("CAID") S %=$P(%Z,U,1) S:%]"" DE(22)=% S %=$P(%Z,U,2) S:%]"" DE(28)=%
 I $D(^("REP")) S %Z=^("REP") S %=$P(%Z,U,3) S:%]"" DE(38)=% S %=$P(%Z,U,4) S:%]"" DE(40)=%
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
BEGIN S DNM="ABSPIN1",DQ=1
 N DIEZTMP,DIEZAR,DIEZRXR,DIIENS,DIXR K DIEFIRE,DIEBADK S DIEZTMP=$$GETTMP^DIKC1("DIEZ")
 M DIEZAR=^DIE(2388,"AR") S DICRREC="TRIG^DIE17"
 S:$D(DTIME)[0 DTIME=300 S D0=DA,DIIENS=DA_",",DIEZ=2388,U="^"
1 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=1 D X1 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X1 W !!,"OUTPATIENT SITE:  One or more of the RPMS pharmacy package's",!
 Q
2 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=2 D X2 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X2 W ?10,"Outpatient Sites (File 59) must be associated with",!
 Q
3 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=3 D X3 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X3 W ?10,"this Point of Sale pharmacy entry",!
 Q
4 S D=0 K DE(1) ;13800
 S DIFLD=13800,DGO="^ABSPIN11",DC="3^9002313.5601P^OPSITE^",DV="9002313.5601MP59'",DW="0;1",DOW="OUTPATIENT SITE",DLB=$P($$EZBLD^DIALOG(8042,DOW),":") S:D DC=DC_D
 S DU="PS(59,"
 G RE:D I $D(DSC(9002313.5601))#2,$P(DSC(9002313.5601),"I $D(^UTILITY(",1)="" X DSC(9002313.5601) S D=$O(^(0)) S:D="" D=-1 G M4
 S D=$S($D(^ABSP(9002313.56,DA,"OPSITE",0)):$P(^(0),U,3,4),$O(^(0))'="":$O(^(0)),1:-1)
M4 I D>0 S DC=DC_D I $D(^ABSP(9002313.56,DA,"OPSITE",+D,0)) S DE(4)=$P(^(0),U,1)
 G RE
R4 D DE
 S D=$S($D(^ABSP(9002313.56,DA,"OPSITE",0)):$P(^(0),U,3,4),1:1) G 4+1
 ;
5 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=5 D X5 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X5 W !!,"ENVOY TERMINAL ID:  This is a number assigned to",!
 Q
6 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=6 D X6 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X6 W ?10,"your pharmacy by Envoy.  The number is sent as part of ",!
 Q
7 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=7 D X7 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X7 W ?10,"each claim you send to Envoy.",!
 Q
8 S DW="0;6",DV="NJ10,0a",DU="",DLB="ENVOY TERMINAL ID",DIFLD=.06
 S DE(DW)="C8^ABSPIN1"
 G RE
C8 G C8S:$D(DE(8))[0 K DB
 S X=DE(8),DIIX=2_U_DIFLD D AUDIT^DIET
C8S S X="" G:DG(DQ)=X C8F1 K DB
 I $D(DE(8))'[0!(^DD(DP,DIFLD,"AUDIT")'="e") S X=DG(DQ),DIIX=3_U_DIFLD D AUDIT^DIET
C8F1 Q
X8 K:+X'=X!(X>9999999999)!(X<1)!(X?.E1"."1N.N) X
 Q
 ;
9 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=9 D X9 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X9 W !!,"NCPDP #:   This is a number assigned to your pharmacy",!
 Q
10 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=10 D X10 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X10 W ?10,"by the NCPDP.  It used to be called the NABP #",!
 Q
11 D:$D(DG)>9 F^DIE17,DE S DQ=11,DW="0;2",DV="Fa",DU="",DLB="NCPDP #",DIFLD=.02
 S DE(DW)="C11^ABSPIN1"
 G RE
C11 G C11S:$D(DE(11))[0 K DB
 S X=DE(11),DIIX=2_U_DIFLD D AUDIT^DIET
C11S S X="" G:DG(DQ)=X C11F1 K DB
 I $D(DE(11))'[0!(^DD(DP,DIFLD,"AUDIT")'="e") S X=DG(DQ),DIIX=3_U_DIFLD D AUDIT^DIET
C11F1 Q
X11 K:$L(X)>10!($L(X)<3) X
 I $D(X),X'?.ANP K X
 Q
 ;
12 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=12 D X12 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X12 W !!,"DEFAULT DEA #:  Many insurances require the prescriber's",!
 Q
13 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=13 D X13 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X13 W ?10,"DEA number as part of the claim.  If your pharmacy has",!
 Q
14 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=14 D X14 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X14 W ?10,"a DEA # that may be used in case a prescriber doesn't have",!
 Q
15 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=15 D X15 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X15 W ?10,"his DEA # on file with you, enter that default DEA # here.",!
 Q
16 D:$D(DG)>9 F^DIE17,DE S DQ=16,DW="0;3",DV="Fa",DU="",DLB="DEFAULT DEA #",DIFLD=.03
 S DE(DW)="C16^ABSPIN1"
 G RE
C16 G C16S:$D(DE(16))[0 K DB
 S X=DE(16),DIIX=2_U_DIFLD D AUDIT^DIET
C16S S X="" G:DG(DQ)=X C16F1 K DB
 I $D(DE(16))'[0!(^DD(DP,DIFLD,"AUDIT")'="e") S X=DG(DQ),DIIX=3_U_DIFLD D AUDIT^DIET
C16F1 Q
X16 K:$L(X)>12!($L(X)<3) X
 I $D(X),X'?.ANP K X
 Q
 ;
17 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=17 D X17 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X17 W !!,"MEDICAID #:  If you are sending claims to your state's",!
 Q
18 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=18 D X18 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X18 W ?10,"Medicaid program, and Medicaid has assigned a special",!
 Q
19 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=19 D X19 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X19 W ?10,"Medicaid pharmacy number to your pharmacy, enter that",!
 Q
20 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=20 D X20 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X20 W ?10,"number here.  It is usually required as part of",!
 Q
21 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=21 D X21 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X21 W ?10,"the Medicaid claim.",!
 Q
22 D:$D(DG)>9 F^DIE17,DE S DQ=22,DW="CAID;1",DV="Fa",DU="",DLB="MEDICAID #",DIFLD=3001.01
 S DE(DW)="C22^ABSPIN1"
 G RE
C22 G C22S:$D(DE(22))[0 K DB
 S X=DE(22),DIIX=2_U_DIFLD D AUDIT^DIET
C22S S X="" G:DG(DQ)=X C22F1 K DB
 I $D(DE(22))'[0!(^DD(DP,DIFLD,"AUDIT")'="e") S X=DG(DQ),DIIX=3_U_DIFLD D AUDIT^DIET
C22F1 Q
X22 K:$L(X)>12!($L(X)<3) X
 I $D(X),X'?.ANP K X
 Q
 ;
23 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=23 D X23 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X23 W !!,"DEFAULT MEDICAID PROVIDER #:  Usually, Medicaid assigns ID numbers",!
 Q
24 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=24 D X24 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X24 W ?10,"to prescribers and those numbers must be sent as part of a",!
 Q
25 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=25 D X25 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X25 W ?10,"Medicaid claim.  If you have a default number which may be ",!
 Q
26 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=26 D X26 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X26 W ?10,"used when you don't have a provider's Medicaid number on file",!
 Q
27 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=27 D X27 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X27 W ?10,"enter that number here.",!
 Q
28 D:$D(DG)>9 F^DIE17,DE S DQ=28,DW="CAID;2",DV="Fa",DU="",DLB="DEFAULT CAID PROVIDER #",DIFLD=3001.02
 S DE(DW)="C28^ABSPIN1"
 G RE
C28 G C28S:$D(DE(28))[0 K DB
 S X=DE(28),DIIX=2_U_DIFLD D AUDIT^DIET
C28S S X="" G:DG(DQ)=X C28F1 K DB
 I $D(DE(28))'[0!(^DD(DP,DIFLD,"AUDIT")'="e") S X=DG(DQ),DIIX=3_U_DIFLD D AUDIT^DIET
C28F1 Q
X28 K:$L(X)>10!($L(X)<1) X
 I $D(X),X'?.ANP K X
 Q
 ;
29 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=29 D X29 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X29 W !!,"INSURER-ASSIGNED #:  Usually, private insurance claims require the",!
 Q
30 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=30 D X30 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X30 W ?10,"NCPDP #.  But if any insurers have special numbers assigned to",!
 Q
31 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=31 D X31 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X31 W ?10,"your pharmacy to be used on their claims, then enter those",!
 Q
32 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=32 D X32 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X32 W ?10,"insurers and the numbers they assigned to you.",!
 Q
33 D:$D(DG)>9 F^DIE17,DE S DQ=33,D=0 K DE(1) ;950
 S DIFLD=950,DGO="^ABSPIN12",DC="4^9002313.6P^INSURER-ASSIGNED #^",DV="9002313.6MP9999999.18'a",DW="0;1",DOW="INSURER",DLB=$P($$EZBLD^DIALOG(8042,DOW),":") S:D DC=DC_D
 S DU="AUTNINS("
 G RE:D I $D(DSC(9002313.6))#2,$P(DSC(9002313.6),"I $D(^UTILITY(",1)="" X DSC(9002313.6) S D=$O(^(0)) S:D="" D=-1 G M33
 S D=$S($D(^ABSP(9002313.56,DA,"INSURER-ASSIGNED #",0)):$P(^(0),U,3,4),$O(^(0))'="":$O(^(0)),1:-1)
M33 I D>0 S DC=DC_D I $D(^ABSP(9002313.56,DA,"INSURER-ASSIGNED #",+D,0)) S DE(33)=$P(^(0),U,1)
 G RE
R33 D DE
 S D=$S($D(^ABSP(9002313.56,DA,"INSURER-ASSIGNED #",0)):$P(^(0),U,3,4),1:1) G 33+1
 ;
34 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=34 D X34 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X34 W !!,"Auto-Print Pharmacy Expense Report for:",!
 Q
35 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=35 D X35 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X35 W ?10,"""1"" All Patients.",!
 Q
36 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=36 D X36 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X36 W ?10,"""0"" No Patients. (Do not print)",!
 Q
37 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=37 D X37 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X37 W ?10,"""NB"" Non-Beneficiary Patients only.",!
 Q
38 S DW="REP;3",DV="Sa",DU="",DLB="AUTOPRINT PHARMACY EXPENSE RPT",DIFLD=115
 S DE(DW)="C38^ABSPIN1"
 S DU="1:All Patients;0:No Patients;NB:Only Non-Beneficiary Patients;"
 G RE
C38 G C38S:$D(DE(38))[0 K DB
 S X=DE(38),DIIX=2_U_DIFLD D AUDIT^DIET
C38S S X="" G:DG(DQ)=X C38F1 K DB
 I $D(DE(38))'[0!(^DD(DP,DIFLD,"AUDIT")'="e") S X=DG(DQ),DIIX=3_U_DIFLD D AUDIT^DIET
C38F1 Q
X38 Q
39 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=39 D X39 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X39 W !!,"What Device should the Pharmacy Expense Reports print to? ",!
 Q
40 D:$D(DG)>9 F^DIE17,DE S DQ=40,DW="REP;4",DV="P3.5'a",DU="",DLB="DEFAULT DEVICE",DIFLD=115.01
 S DE(DW)="C40^ABSPIN1"
 S DU="%ZIS(1,"
 G RE
C40 G C40S:$D(DE(40))[0 K DB
 S X=DE(40),DIIX=2_U_DIFLD D AUDIT^DIET
C40S S X="" G:DG(DQ)=X C40F1 K DB
 I $D(DE(40))'[0!(^DD(DP,DIFLD,"AUDIT")'="e") S X=DG(DQ),DIIX=3_U_DIFLD D AUDIT^DIET
C40F1 Q
X40 Q
41 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=41 D X41 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X41 I '$$ILCAR^ABSPOSS1 S Y="@999"
 Q
42 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=42 D X42 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X42 W !!,"These fields are used for printing pharmacy claims for non-electronic",!
 Q
43 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=43 D X43 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X43 W "insurers.  If you omit this data, the system will use the general",!
 Q
44 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=44 D X44 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X44 W "billing system setup information.",!
 Q
45 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=45 D X45 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X45 W !!,"The AR TYPE is required.  When charges from this pharmacy",!
 Q
46 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=46 D X46 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X46 W "are posted to Accounts Receivable, this is the AR TYPE assigned",!
 Q
47 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=47 D X47 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X47 W "to those accounts.  It might default if you have an RX type",!
 Q
48 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=48 D X48 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X48 W "but you should explicitly assign an A/R type here.",!
 Q
49 D:$D(DG)>9 F^DIE17,DE S DQ=49,DW="0;4",DV="P9001626'",DU="",DLB="AR TYPE",DIFLD=.04
 S DU="ABSBTYP("
 G RE
X49 Q
50 D:$D(DG)>9 F^DIE17 G ^ABSPIN13