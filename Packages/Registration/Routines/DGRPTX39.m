DGRPTX39 ; ;05/27/04
 D DE G BEGIN
DE S DIE="^DPT(",DIC=DIE,DP=2,DL=1,DIEL=0,DU="" K DG,DE,DB Q:$O(^DPT(DA,""))=""
 I $D(^(.32)) S %Z=^(.32) S %=$P(%Z,U,3) S:%]"" DE(4)=%
 I $D(^(.36)) S %Z=^(.36) S %=$P(%Z,U,1) S:%]"" DE(2)=%
 I $D(^(.362)) S %Z=^(.362) S %=$P(%Z,U,14) S:%]"" DE(1)=%
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
BEGIN S DNM="DGRPTX39",DQ=1
1 D:$D(DG)>9 F^DIE17,DE S DQ=1,DW=".362;14",DV="SX",DU="",DLB="RECEIVING A VA PENSION?",DIFLD=.36235
 S DE(DW)="C1^DGRPTX39"
 S DU="Y:YES;N:NO;U:UNKNOWN;"
 G RE
C1 G C1S:$D(DE(1))[0 K DB
 S X=DE(1),DIC=DIE
 X ^DD(2,.36235,1,1,2.3) I X S X=DIV S Y(1)=$S($D(^DPT(D0,.362)):^(.362),1:"") S X=$P(Y(1),U,4),X=X S DIU=X K Y S X="" X ^DD(2,.36235,1,1,2.4)
 S X=DE(1),DIC=DIE
 S DFN=DA D EN^DGMTCOR K DGMTCOR
 S X=DE(1),DIC=DIE
 K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X S X='$$TOTCHK^DGLOCK2(DA) I X S X=DIV S Y(1)=$S($D(^DPT(D0,.362)):^(.362),1:"") S X=$P(Y(1),U,20),X=X S DIU=X K Y S X="" X ^DD(2,.36235,1,3,2.4)
 S X=DE(1),DIC=DIE
 D AUTOUPD^DGENA2(DA)
C1S S X="" Q:DG(DQ)=X  K DB
 S X=DG(DQ),DIC=DIE
 X ^DD(2,.36235,1,1,1.3) I X S X=DIV S Y(1)=$S($D(^DPT(D0,.362)):^(.362),1:"") S X=$P(Y(1),U,4),X=X S DIU=X K Y S X="" X ^DD(2,.36235,1,1,1.4)
 S X=DG(DQ),DIC=DIE
 S DFN=DA D EN^DGMTCOR K DGMTCOR
 S X=DG(DQ),DIC=DIE
 K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X S X='$$TOTCHK^DGLOCK2(DA) I X S X=DIV S Y(1)=$S($D(^DPT(D0,.362)):^(.362),1:"") S X=$P(Y(1),U,20),X=X S DIU=X K Y S X="" X ^DD(2,.36235,1,3,1.4)
 S X=DG(DQ),DIC=DIE
 D AUTOUPD^DGENA2(DA)
 Q
X1 S DFN=DA D MV^DGLOCK
 Q
 ;
2 D:$D(DG)>9 F^DIE17,DE S DQ=2,DW=".36;1",DV="*P8'X",DU="",DLB="PRIMARY ELIGIBILITY CODE",DIFLD=.361
 S DE(DW)="C2^DGRPTX39"
 S DU="DIC(8,"
 G RE
C2 G C2S:$D(DE(2))[0 K DB
 S X=DE(2),DIC=DIE
 ;
 S X=DE(2),DIC=DIE
 K DIV S DIV=X,D0=DA,DIV(0)=D0 X ^DD(2,.361,1,2,2.2) I DIV(1)>0 S DIK(0)=DA,DIK="^DPT(DIV(0),""E"",",DA(1)=DIV(0),DA=DIV(1) D ^DIK S DA=DIK(0) K DIK
 S X=DE(2),DIC=DIE
 X "I $S('$D(^DIC(8,+X,0)):0,$P(^(0),""^"",1)[""DOM"":0,'$D(^DPT(DA,.36)):1,'$D(^DIC(8,+^(.36),0)):1,$P(^(0),""^"",1)'[""DOM"":1,1:0) S DGXRF=.361 D ^DGDDC Q"
 S X=DE(2),DIC=DIE
 K ^DPT("AEL",DA,+X)
 S X=DE(2),DIC=DIE
 D AUTOUPD^DGENA2(DA)
C2S S X="" Q:DG(DQ)=X  K DB
 D ^DGRPTX40
 Q
X2 S DFN=DA D EV^DGLOCK I $D(X) D ECD^DGLOCK1
 Q
 ;
3 D:$D(DG)>9 F^DIE17,DE S DQ=3,D=0 K DE(1) ;361
 S DIFLD=361,DGO="^DGRPTX41",DC="3^2.0361IP^E^",DV="2.0361M*P8'X",DW="0;1",DOW="ELIGIBILITY",DLB="Select "_DOW S:D DC=DC_D
 S DU="DIC(8,"
 G RE:D I $D(DSC(2.0361))#2,$P(DSC(2.0361),"I $D(^UTILITY(",1)="" X DSC(2.0361) S D=$O(^(0)) S:D="" D=-1 G M3
 S D=$S($D(^DPT(DA,"E",0)):$P(^(0),U,3,4),$O(^(0))'="":$O(^(0)),1:-1)
M3 I D>0 S DC=DC_D I $D(^DPT(DA,"E",+D,0)) S DE(3)=$P(^(0),U,1)
 G RE
R3 D DE
 S D=$S($D(^DPT(DA,"E",0)):$P(^(0),U,3,4),1:1) G 3+1
 ;
4 S DW=".32;3",DV="*P21'X",DU="",DLB="PERIOD OF SERVICE",DIFLD=.323
 S DE(DW)="C4^DGRPTX39"
 S DU="DIC(21,"
 G RE
C4 G C4S:$D(DE(4))[0 K DB
 D ^DGRPTX42
C4S S X="" Q:DG(DQ)=X  K DB
 D ^DGRPTX43
 Q
X4 S DFN=DA D POS^DGLOCK1
 Q
 ;
5 S DQ=6 ;@98
6 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=6 D X6 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X6 S DGFIN=""
 Q
7 G 0^DIE17
