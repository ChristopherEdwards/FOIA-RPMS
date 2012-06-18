ADGT15 ; GENERATED FROM 'ADGWARD' INPUT TEMPLATE(#1595), FILE 42;05/04/99
 D DE G BEGIN
DE S DIE="^DIC(42,",DIC=DIE,DP=42,DL=1,DIEL=0,DU="" K DG,DE,DB Q:$O(^DIC(42,DA,""))=""
 I $D(^(0)) S %Z=^(0) S %=$P(%Z,U,1) S:%]"" DE(1)=% S %=$P(%Z,U,4) S:%]"" DE(5)=% S %=$P(%Z,U,6) S:%]"" DE(6)=%
 I $D(^(44)) S %Z=^(44) S %=$P(%Z,U,1) S:%]"" DE(3)=%
 I $D(^("IHS")) S %Z=^("IHS") S %=$P(%Z,U,4) S:%]"" DE(4)=%
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
BEGIN S DNM="ADGT15",DQ=1
 S:$D(DTIME)[0 DTIME=300 S D0=DA,DIEZ=1595,U="^"
1 S DW="0;1",DV="RFa",DU="",DLB="NAME",DIFLD=.01
 S DE(DW)="C1^ADGT15"
 G RE
C1 G C1S:$D(DE(1))[0 K DB S X=DE(1),DIC=DIE
 K ^DIC(42,"B",$E(X,1,30),DA)
 S X=DE(1),DIC=DIE
 X "S %=$P(^DIC(42,DA,0),""^"",1) F J=""ACN"",""CN"" F I=0:0 S I=$O(^DPT(J,X,I)) Q:'I  S DGWU=^DPT(J,X,I) K ^DPT(J,X,I) K:J=""CN"" ^DGPM(J,X,DGWU) I %]"""" S ^DPT(J,%,I)=DGWU S:J=""CN"" ^DGPM(J,%,DGWU)="""" K DGWU I $D(^DPT(I,.1)),^(.1)=X S ^(.1)=%"
 S X=DE(1),DIC=DIE
 ;
 S X=DE(1),DIIX=2_U_DIFLD D AUDIT^DIET
C1S S X="" Q:DG(DQ)=X  K DB S X=DG(DQ),DIC=DIE
 S ^DIC(42,"B",$E(X,1,30),DA)=""
 S X=DG(DQ),DIC=DIE
 ;
 S X=DG(DQ),DIC=DIE
 X ^DD(42,.01,1,3,1.3) I X S X=DIV X ^DD(42,.01,1,3,9.2) S X=$P(Y(101),U,1) S D0=I(0,0) S DIU=X K Y S X=DIV S X=DIV X ^DD(42,.01,1,3,1.4)
 Q:$D(DE(1))[0&(^DD(DP,DIFLD,"AUDIT")="e")  S X=DG(DQ),DIIX=3_U_DIFLD D AUDIT^DIET
 Q
X1 K:$L(X)>30!($L(X)<2)!'(X'?1P.E)!(X'?.ANP) X
 I $D(X),X'?.ANP K X
 Q
 ;
2 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=2 G A
3 D:$D(DG)>9 F^DIE17,DE S DQ=3,DW="44;1",DV="RP44X",DU="",DLB="HOSPITAL LOCATION FILE POINTER",DIFLD=44
 S DE(DW)="C3^ADGT15"
 S DU="SC("
 G RE
C3 G C3S:$D(DE(3))[0 K DB S X=DE(3),DIC=DIE
 K DIV S DIV=X,D0=DA,DIV(0)=D0 S I(0,0)=$S($D(D0):D0,1:""),D0=DIV S:'$D(^SC(+D0,0)) D0=-1 S DIV(0)=D0 S Y(101)=$S($D(^SC(D0,42)):^(42),1:"") S X=$P(Y(101),U,1),X=X S X=X S D0=I(0,0) S DIU=X K Y S X="" X ^DD(42,44,1,1,2.4)
C3S S X="" Q:DG(DQ)=X  K DB S X=DG(DQ),DIC=DIE
 X ^DD(42,44,1,1,1.3) I X S X=DIV S I(0,0)=$S($D(D0):D0,1:""),D0=DIV S:'$D(^SC(+D0,0)) D0=-1 S DIV(0)=D0 S Y(101)=$S($D(^SC(D0,42)):^(42),1:"") S X=$P(Y(101),U,1),X=X S X=X S D0=I(0,0) S DIU=X K Y X ^DD(42,44,1,1,1.1) X ^DD(42,44,1,1,1.4)
 Q
X3 I $D(^SC(+X,42)),+^(42),+^(42)'=DA W !?20,"This Hospital location points to ",$P(^DIC(42,+^SC(+X,42),0),"^",1) K X
 Q
 ;
4 D:$D(DG)>9 F^DIE17,DE S DQ=4,DW="IHS;4",DV="RS",DU="",DLB="INACTIVE",DIFLD=9999999.04
 S DE(DW)="C4^ADGT15"
 S DU="1:YES;0:NO;"
 G RE
C4 G C4S:$D(DE(4))[0 K DB S X=DE(4),DIC=DIE
 ;
C4S S X="" Q:DG(DQ)=X  K DB S X=DG(DQ),DIC=DIE
 K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DIC(42,D0,"ORDER")):^("ORDER"),1:"") S X=$P(Y(1),U,1),X=X S DIU=X K Y S X=DIV S X=$S(X=0:1,1:"") X ^DD(42,9999999.04,1,1,1.4)
 Q
X4 Q
5 D:$D(DG)>9 F^DIE17,DE S DQ=5,DW="0;4",DV="RNJ3,0",DU="",DLB="OPERATIONAL BEDS",DIFLD=.04
 G RE
X5 K:+X'=X!(X>200)!(X<0)!(X?.E1"."1N.N) X
 Q
 ;
6 S DW="0;6",DV="RNJ3,0",DU="",DLB="AUTHORIZED BEDS",DIFLD=.06
 G RE
X6 K:+X'=X!(X>200)!(X<0)!(X?.E1"."1N.N) X
 Q
 ;
7 D:$D(DG)>9 F^DIE17 G ^ADGT151
