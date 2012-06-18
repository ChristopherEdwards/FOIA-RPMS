APSPT09 ; IHS/DSD/ENM - GENERATED FROM 'APSP PREPACK LOG ADD' INPUT TEMPLATE(#992), FILE 9009031 ; [ 09/03/97 1:30 PM ]
 ;;6.0;IHS PHARMACY MODIFICATIONS;;09/03/97
 D DE G BEGIN
DE S DIE="^APSPP(31,",DIC=DIE,DP=9009031,DL=1,DIEL=0,DU="" K DG,DE,DB Q:$O(^APSPP(31,DA,-1))<0
 I $D(^(0)) S %Z=^(0) S %=$P(%Z,"^",2) S:%]"" DE(1)=% S %=$P(%Z,"^",7) S:%]"" DE(2)=% S %=$P(%Z,"^",8) S:%]"" DE(7)=% S %=$P(%Z,"^",16) S:%]"" DE(4)=%
 K %Z Q
 ;
W W !?DL+DL-2,DLB_": "
 Q
O D W W Y W:$X>45 !?9
 I $L(Y)>19,'DV,(DV["F"!(DV["K")) G RW^DIED
 W:Y]"" "// " I 'DV,DV["I" S X="" W "  (No Editing)" Q
TR R X:DTIME E  S (DTOUT,X)=U W *7
 Q
A K DQ(DQ) S DQ=DQ+1
B G @DQ
RE G PR:$D(DE(DQ)) D W,TR
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
Y I '$D(DE(DQ)) D O G A:X="@",RD:X]"" S X=Y G N
PR S DG=DV,Y=DE(DQ),X=DU I $D(DQ(DQ,2)) X DQ(DQ,2) G RP
R I DG["P",@("$D(^"_X_"0))") S X=+$P(^(0),U,2) G RP:'$D(^(Y,0)) S Y=$P(^(0),U),X=$P(^DD(X,.01,0),U,3),DG=$P(^(0),U,2) G R
 I DG["V",+Y,$D(@(U_$P(Y,";",2)_"0)")) S X=+$P(^(0),U,2) G RP:'$D(^(+Y,0)) S Y=$P(^(0),U) I $D(^DD(+X,.01,0)) S DG=$P(^(0),U,2),X=$P(^(0),U,3) G R
 X:DG["D" ^DD("DD") I DG["S" S %=$P($P(";"_X,";"_Y_":",2),";") S:%]"" Y=%
RP D O I X="" S X=DE(DQ) G A:'DV,A:DC<2,N^DIE17
I I DV'["I",DV'["#" G RD
 D E^DIE0 G RD:$D(X),PR
 Q
BEGIN S DNM="APSPT09",DQ=1
 S:$D(DTIME)[0 DTIME=999 S D0=DA,DIEZ=992,U="^"
1 S DW="0;2",DV="RD",DU="",DLB="FILL DATE",DIFLD=.02
 S DE(DW)="C1^APSPT09"
 S X=DT
 S Y=X
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G Z:X,RD
C1 G C1S:$D(DE(1))[0 K DB S X=DE(1),DIC=DIE
 K ^APSPP(31,"AD",X,DA,0)
C1S S X="" Q:DG(DQ)=X  K DB S X=DG(DQ),DIC=DIE
 S ^APSPP(31,"AD",X,DA,0)=""
 Q
X1 S %DT="TX" D ^%DT S X=Y K:Y<1 X
 Q
 ;
2 D:$D(DG)>9 F^DIE17,DE S DQ=2,DW="0;7",DV="RS",DU="",DLB="TYPE",DIFLD=.07
 S DU="P:PREPACK;U:UNIT DOSE;"
 S Y="P"
 G Y
X2 Q
3 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=3 D X3 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X3 I $D(%PSITE),$P(%PSITE,U,1)'=1 S Y="@1"
 Q
4 S DW="0;16",DV="RS",DU="",DLB="SUBTRACT FROM INVENTORY",DIFLD=.16
 S DE(DW)="C4^APSPT09"
 S DU="y:YES;n:NO;"
 S Y="Y"
 G Y
C4 G C4S:$D(DE(4))[0 K DB S X=DE(4),DIC=DIE
 K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X X ^DD(9009031,.16,1,1,79.3) S X=X&Y I X S X=DIV X ^DD(9009031,.16,1,1,89.3) S X=$P(Y(201),U,1) S D0=I(0,0) S DIU=X K Y X ^DD(9009031,.16,1,1,2.1) X ^DD(9009031,.16,1,1,2.4)
 S X=DE(4),DIC=DIE
 K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X X ^DD(9009031,.16,1,2,79.3) S X=X&Y I X S X=DIV X ^DD(9009031,.16,1,2,89.3) S X=$P(Y(201),U,1) S D0=I(0,0) S DIU=X K Y X ^DD(9009031,.16,1,2,2.1) X ^DD(9009031,.16,1,2,2.4)
C4S S X="" Q:DG(DQ)=X  K DB S X=DG(DQ),DIC=DIE
 ;
 S X=DG(DQ),DIC=DIE
 ;
 Q
X4 Q
5 S DQ=6 ;@1
6 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=6 D X6 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X6 S APSPRT("QTY")=$S($P(^APSPP(31,DA,0),U,7)="P":$P(^APSPP(31.1,$P(^APSPP(31,DA,0),U,3),0),U,2),$P(^APSPP(31,DA,0),U,7)="U":"1",1:"")
 Q
7 D:$D(DG)>9 F^DIE17,DE S DQ=7,DW="0;8",DV="RNJ7,2X",DU="",DLB="QTY PER CONTAINER",DIFLD=.08
 S DE(DW)="C7^APSPT09"
 S X=APSPRT("QTY")
 S Y=X
 G Y
C7 G C7S:$D(DE(7))[0 K DB S X=DE(7),DIC=DIE
 K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X S X=$D(DIU(0))=0 I X S X=DIV S Y(1)=$S($D(^APSPP(31,D0,0)):^(0),1:"") S X=$P(Y(1),U,11),X=X S DIU=X K Y S X="" X ^DD(9009031,.08,1,1,2.4)
 S X=DE(7),DIC=DIE
 X ^DD(9009031,.08,1,2,2.3) I X S X=DIV X ^DD(9009031,.08,1,2,89.3) S X=$P(Y(201),U,1) S D0=I(0,0) S DIU=X K Y X ^DD(9009031,.08,1,2,2.1) X ^DD(9009031,.08,1,2,2.4)
 S X=DE(7),DIC=DIE
 S APSP("PREPACK LOG FLG")=""
C7S S X="" Q:DG(DQ)=X  K DB S X=DG(DQ),DIC=DIE
 K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X S X=$D(DIU(0))=0 I X S X=DIV S Y(1)=$S($D(^APSPP(31,D0,0)):^(0),1:"") S X=$P(Y(1),U,11),X=X S DIU=X K Y X ^DD(9009031,.08,1,1,1.1) X ^DD(9009031,.08,1,1,1.4)
 S X=DG(DQ),DIC=DIE
 X ^DD(9009031,.08,1,2,1.3) I X S X=DIV X ^DD(9009031,.08,1,2,89.3) S X=$P(Y(201),U,1) S D0=I(0,0) S DIU=X K Y X ^DD(9009031,.08,1,2,1.1) X ^DD(9009031,.08,1,2,1.4)
 S X=DG(DQ),DIC=DIE
 K APSP("PREPACK LOG FLG")
 Q
X7 K:+X<.01!(+X>9999.99)!($L(X)>10)!'(X?1.4N!(X?.4N1"."1.2N)!(X?1.4N1" ".ANP)!(X?.4N1"."1.2N1" ".ANP)) X
 Q
 ;
8 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=8 D X8 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X8 K APSPRT("QTY")
 Q
9 D:$D(DG)>9 F^DIE17 G ^APSPT091
