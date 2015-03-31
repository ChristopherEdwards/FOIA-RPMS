RACTEX1 ; ;07/06/13
 D DE G BEGIN
DE S DIE="^RADPT(D0,""DT"",",DIC=DIE,DP=70.02,DL=2,DIEL=1,DU="" K DG,DE,DB Q:$O(^RADPT(D0,"DT",DA,""))=""
 I $D(^("LMP")) S %Z=^("LMP") S %=$P(%Z,U,1) S:%]"" DE(3)=% S %=$P(%Z,U,2) S:%]"" DE(4)=% S %=$P(%Z,U,3) S:%]"" DE(5)=%
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
BEGIN S DNM="RACTEX1",DQ=1
1 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=1 D X1 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X1 I $P(^DPT(RADFN,0),U,2)'="F" S Y="@498"
 Q
2 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=2 D X2 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X2 S X1=DT,X2=$P(^DPT(RADFN,0),U,3) D ^%DTC S RAGE=X/365.25 I RAGE<13!(RAGE>50) S Y="@498"
 Q
3 S DW="LMP;1",DV="D",DU="",DLB="LAST MENSTRUAL PERIOD",DIFLD=498
 G RE
X3 S %DT="EX" D ^%DT S X=Y K:Y<1 X
 Q
 ;
4 S DW="LMP;2",DV="S",DU="",DLB="PRIMARY MEANS OF BIRTH CONTROL",DIFLD=499
 S DU="n:NOT SEXUALLY ACTIVE;p:PILLS;t:TUBAL LIGATION;v:VASECTOMY;d:DIAPHRAM;i:IUD;c:CONDOM;f:FOAM;g:GEL;h:HYSTERECTOMY;m:POST MENSTRUAL;b:BC IMPLANT;j:BC IM INJECTION;r:RHYTHM;s:SEXUALLY ACTIVE, NO BC;"
 G RE
X4 Q
5 S DW="LMP;3",DV="D",DU="",DLB="LAST NEGATIVE HCG TEST",DIFLD=500
 G RE
X5 S %DT="E" D ^%DT S X=Y K:Y<1 X
 Q
 ;
6 S DQ=7 ;@498
7 S D=0 K DE(1) ;50
 S DIFLD=50,DGO="^RACTEX2",DC="54^70.03IA^P^",DV="70.03NJ5,0X",DW="0;1",DOW="CASE NUMBER",DLB=$P($$EZBLD^DIALOG(8042,DOW),":") S:D DC=DC_D
 I $D(DSC(70.03))#2,$P(DSC(70.03),"I $D(^UTILITY(",1)="" X DSC(70.03) S D=$O(^(0)) S:D="" D=-1 G M7
 S D=$S($D(^RADPT(D0,"DT",DA,"P",0)):$P(^(0),U,3,4),$O(^(0))'="":$O(^(0)),1:-1)
M7 I D>0 S DC=DC_D I $D(^RADPT(D0,"DT",DA,"P",+D,0)) S DE(7)=$P(^(0),U,1)
 S X=RACN
 S Y=X
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
R7 D DE
 G A
 ;
8 S DQ=9 ;@800
9 G 1^DIE17
