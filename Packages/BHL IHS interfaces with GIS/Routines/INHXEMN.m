INHXEMN ; GENERATED FROM 'INH MESSAGE NEW' INPUT TEMPLATE(#2135), FILE 4001;10/25/01
 D DE G BEGIN
DE S DIE="^INTHU(",DIC=DIE,DP=4001,DL=1,DIEL=0,DU="" K DG,DE,DB Q:$O(^INTHU(DA,""))=""
 I $D(^(0)) S %Z=^(0) S %=$P(%Z,U,2) S:%]"" DE(1)=% S %=$P(%Z,U,3) S:%]"" DE(2)=% S %=$P(%Z,U,4) S:%]"" DE(4)=% S %=$P(%Z,U,5) S:%]"" DE(5)=% S %=$P(%Z,U,7) S:%]"" DE(6)=% S %=$P(%Z,U,10) S:%]"" DE(3)=%
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
BEGIN S DNM="INHXEMN",DQ=1
 S:$D(DTIME)[0 DTIME=300 S D0=DA,DIEZ=2135,U="^"
1 S DW="0;2",DV="RP4005'",DU="",DLB="DESTINATION",DIFLD=.02
 S DE(DW)="C1^INHXEMN"
 S DU="INRHD("
 S X=INDEST
 S Y=X
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
C1 G C1S:$D(DE(1))[0 K DB S X=DE(1),DIC=DIE
 K ^INTHU("AD",$E(X,1,30),DA)
 S X=DE(1),DIC=DIE
 N P S P=+$P(^INTHU(DA,0),U,16) K ^INLHSCH("DEST",+X,P,DA)
C1S S X="" Q:DG(DQ)=X  K DB S X=DG(DQ),DIC=DIE
 S ^INTHU("AD",$E(X,1,30),DA)=""
 S X=DG(DQ),DIC=DIE
 ;
 Q
X1 Q
2 D:$D(DG)>9 F^DIE17,DE S DQ=2,DW="0;3",DV="RS",DU="",DLB="STATUS",DIFLD=.03
 S DE(DW)="C2^INHXEMN"
 S DU="N:NEW;P:PENDING;S:SENT (Awaiting Acknowledge);C:COMPLETE;E:ERROR;K:NEGATIVE ACKNOWLEDGED;A:ACCEPT ACK;"
 S Y="NEW"
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
C2 G C2S:$D(DE(2))[0 K DB S X=DE(2),DIC=DIE
 K ^INTHU("AS",$E(X,1,30),DA)
 S X=DE(2),DIC=DIE
 ;
 S X=DE(2),DIC=DIE
 N Y2 S Y2=$P(^INTHU(DA,0),U,16) I Y2]"" S Y2=$E(Y2,1,30) K ^INTHU("ASP",$E(X,1,30),Y2,DA)
C2S S X="" Q:DG(DQ)=X  K DB S X=DG(DQ),DIC=DIE
 S ^INTHU("AS",$E(X,1,30),DA)=""
 S X=DG(DQ),DIC=DIE
 D ECHK^INHU(DA)
 S X=DG(DQ),DIC=DIE
 N Y2 S Y2=$P(^INTHU(DA,0),U,16) I Y2]"" S Y2=$E(Y2,1,30) S ^INTHU("ASP",$E(X,1,30),Y2,DA)=""
 Q
X2 Q
3 D:$D(DG)>9 F^DIE17,DE S DQ=3,DW="0;10",DV="RS",DU="",DLB="IN/OUT",DIFLD=.1
 S DU="I:IN;O:OUT;"
 S X=INDIR
 S Y=X
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
X3 Q
4 S DW="0;4",DV="S",DU="",DLB="ACKNOWLEDGE REQUIRED?",DIFLD=.04
 S DU="0:NO;1:YES;"
 S X=INNEACK
 S Y=X
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
X4 Q
5 S DW="0;5",DV="F",DU="",DLB="MESSAGE ID",DIFLD=.05
 S DE(DW)="C5^INHXEMN"
 S X=INMID
 S Y=X
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
C5 G C5S:$D(DE(5))[0 K DB S X=DE(5),DIC=DIE
 K ^INTHU("C",$E(X,1,30),DA)
C5S S X="" Q:DG(DQ)=X  K DB S X=DG(DQ),DIC=DIE
 S ^INTHU("C",$E(X,1,30),DA)=""
 Q
X5 K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>30 X
 I $D(X),X'?.ANP K X
 Q
 ;
6 D:$D(DG)>9 F^DIE17,DE S DQ=6,DW="0;7",DV="P4001'O",DU="",DLB="PARENT MESSAGE",DIFLD=.07
 S DQ(6,2)="S Y(0)=Y S Y=$S($D(^INTHU(+Y,0)):$P(^(0),U,5),1:""<Purged>"")"
 S DU="INTHU("
 S X=INORGIEN
 S Y=X
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
X6 Q
7 D:$D(DG)>9 F^DIE17 G ^INHXEMN1
