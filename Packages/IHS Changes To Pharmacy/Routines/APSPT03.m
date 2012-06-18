APSPT03 ; GENERATED FROM 'APSP DUE STUDY ENTRY' INPUT TEMPLATE(#673), FILE 9009032.1;02/14/03
 D DE G BEGIN
DE S DIE="^APSPDUE(32.1,",DIC=DIE,DP=9009032.1,DL=1,DIEL=0,DU="" K DG,DE,DB Q:$O(^APSPDUE(32.1,DA,""))=""
 I $D(^(0)) S %Z=^(0) S %=$P(%Z,U,1) S:%]"" DE(1)=% S %=$P(%Z,U,2) S:%]"" DE(2)=% S %=$P(%Z,U,3) S:%]"" DE(3)=%
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
BEGIN S DNM="APSPT03",DQ=1
 S DR(99,1,9.2)="S DIC=9009032.2,DIADD=1,DIC(0)=""EQLAM"",DIC(""S"")=""I $D(^APSPDUE(32.2,""""AC"""",I(0,0),Y))"" D ^DIC K DIADD S D0=+Y,DIC(.02)=I(0,0),DIH=9009032.2 D DICL^DICR:$P(Y,U,3) K DIC"
 S:$D(DTIME)[0 DTIME=300 S D0=DA,DIEZ=673,U="^"
1 S DW="0;1",DV="RFX",DU="",DLB="NAME",DIFLD=.01
 S DE(DW)="C1^APSPT03"
 G RE
C1 G C1S:$D(DE(1))[0 K DB S X=DE(1),DIC=DIE
 K ^APSPDUE(32.1,"B",$E(X,1,30),DA)
C1S S X="" Q:DG(DQ)=X  K DB S X=DG(DQ),DIC=DIE
 S ^APSPDUE(32.1,"B",$E(X,1,30),DA)=""
 Q
X1 K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>30!($L(X)<3)!'(X'?1P.E) X I $D(X),$D(^APSPDUE(32.1,"B",X)) W "  This entry already exists " K X
 I $D(X),X'?.ANP K X
 Q
 ;
2 D:$D(DG)>9 F^DIE17,DE S DQ=2,DW="0;2",DV="D",DU="",DLB="BEGINNING DATE",DIFLD=.02
 G RE
X2 S %DT="ET" D ^%DT S X=Y K:Y<1 X
 Q
 ;
3 S DW="0;3",DV="D",DU="",DLB="ENDING DATE",DIFLD=.03
 G RE
X3 S %DT="ET" D ^%DT S X=Y K:Y<1 X
 Q
 ;
4 S DQ=5 ;@1
5 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=5 D X5 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X5 K APSPFLG
 Q
6 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=6 D X6 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X6 S APSPDUEC=1
 Q
7 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=7 S I(0,0)=$S($D(D0):D0,1:"") X DR(99,1,9.2) S X=$S(D0>0:D0,1:""),D(0)=X S D0=I(0,0) S X=$S(D(0)>0:D(0),1:"")
 S DGO="^APSPT031",DC="^9009032.2^APSPDUE(32.2," G DIEZ^DIE0
R7 D DE G A
 ;
8 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=8 D X8 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X8 I $D(APSPFLG) S Y="@1"
 Q
9 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=9 D X9 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X9 K APSPFLG,APSPDUEC
 Q
10 G 0^DIE17
