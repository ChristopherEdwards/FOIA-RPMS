RACTEX11 ; ;07/06/13
 D DE G BEGIN
DE S DIE="^RADPT(D0,""DT"",D1,""P"",",DIC=DIE,DP=70.03,DL=3,DIEL=2,DU="" K DG,DE,DB Q:$O(^RADPT(D0,"DT",D1,"P",DA,""))=""
 I $D(^(0)) S %Z=^(0) S %=$P(%Z,U,18) S:%]"" DE(4)=% S %=$P(%Z,U,28) S:%]"" DE(13)=%,DE(20)=%
 I $D(^("COMP")) S %Z=^("COMP") S %=$P(%Z,U,1) S:%]"" DE(1)=%
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
BEGIN S DNM="RACTEX11",DQ=1
1 D:$D(DG)>9 F^DIE17,DE S DQ=1,DW="COMP;1",DV="F",DU="",DLB="COMPLICATION TEXT",DIFLD=16.5
 G RE
X1 K:$L(X)>100!($L(X)<4) X
 I $D(X),X'?.ANP K X
 Q
 ;
2 S DQ=3 ;@130
3 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=3 D X3 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X3 S:'$P(RAMDV,U,9) Y="@140"
 Q
4 S DW="0;18",DV="*P78.6'",DU="",DLB="PRIMARY CAMERA/EQUIP/RM",DIFLD=18
 S DU="RA(78.6,"
 G RE
X4 S DIC("S")="I $D(^RA(79.1,+$P(^RADPT(DA(2),""DT"",DA(1),0),U,4),""R"",+Y,0))" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
 Q
 ;
5 S DQ=6 ;@140
6 S D=0 K DE(1) ;50
 S DIFLD=50,DGO="^RACTEX12",DC="3^70.04PA^F^",DV="70.04M*P78.4'",DW="0;1",DOW="FILM SIZE",DLB=$P($$EZBLD^DIALOG(8042,DOW),":") S:D DC=DC_D
 S DU="RA(78.4,"
 G RE:D I $D(DSC(70.04))#2,$P(DSC(70.04),"I $D(^UTILITY(",1)="" X DSC(70.04) S D=$O(^(0)) S:D="" D=-1 G M6
 S D=$S($D(^RADPT(D0,"DT",D1,"P",DA,"F",0)):$P(^(0),U,3,4),$O(^(0))'="":$O(^(0)),1:-1)
M6 I D>0 S DC=DC_D I $D(^RADPT(D0,"DT",D1,"P",DA,"F",+D,0)) S DE(6)=$P(^(0),U,1)
 G RE
R6 D DE
 S D=$S($D(^RADPT(D0,"DT",D1,"P",DA,"F",0)):$P(^(0),U,3,4),1:1) G 6+1
 ;
7 S DQ=8 ;@99
8 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=8 D X8 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X8 S:'$D(RANUZD1) Y="@700"
 Q
9 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=9 D X9 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X9 S RAREM="skip radio section if case' Img Typ's 'RADIO...USED' is NEVER"
 Q
10 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=10 D X10 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X10 S:$P(^RAMIS(71,+RAPRI,0),U,2)=1 Y="@700"
 Q
11 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=11 D X11 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X11 S RAIEN702=$$EN1^RANMPT1(RADFN,RADTE,RACN)
 Q
12 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=12 D X12 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X12 S:RAIEN702=-1 Y="@700"
 Q
13 S DW="0;28",DV="P70.2'",DU="",DLB="NUCLEAR MED DATA",DIFLD=500
 S DE(DW)="C13^RACTEX11"
 S DU="RADPTN("
 S X=RAIEN702
 S Y=X
 S X=Y,DB(DQ)=1,DE(DW,"4/")="" G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
C13 G C13S:$D(DE(13))[0 K DB
 S X=DE(13),DIC=DIE
 X "Q:$D(RAIEN702)  N DA,DIK S DA=X,DIK=""^RADPTN("" D ^DIK"
C13S S X="" G:DG(DQ)=X C13F1 K DB
 S X=DG(DQ),DIC=DIE
 ;
C13F1 Q
X13 Q
14 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=14 S I(2,0)=D2 S I(1,0)=D1 S I(0,0)=D0 S Y(1)=$S($D(^RADPT(D0,"DT",D1,"P",D2,0)):^(0),1:"") S X=$P(Y(1),U,28),X=X S D(0)=+X S X=$S(D(0)>0:D(0),1:"")
 S DGO="^RACTEX13",DC="^70.2^RADPTN(" G DIEZ^DIE0
R14 D DE G A
 ;
15 S DQ=16 ;@700
16 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=16 D X16 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X16 S RA00=$O(^RADPTN("AA",RADFN,RADTE,RACN,0))
 Q
17 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=17 D X17 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X17 S:'RA00 Y="@710"
 Q
18 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=18 D X18 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X18 S:$O(^RADPTN(RA00,"NUC",0)) Y="@710"
 Q
19 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=19 D X19 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X19 K RAIEN702
 Q
20 D:$D(DG)>9 F^DIE17,DE S DQ=20,DW="0;28",DV="P70.2'",DU="",DLB="NUCLEAR MED DATA",DIFLD=500
 S DE(DW)="C20^RACTEX11"
 S DU="RADPTN("
 S Y="@"
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
C20 G C20S:$D(DE(20))[0 K DB
 S X=DE(20),DIC=DIE
 X "Q:$D(RAIEN702)  N DA,DIK S DA=X,DIK=""^RADPTN("" D ^DIK"
C20S S X="" G:DG(DQ)=X C20F1 K DB
 S X=DG(DQ),DIC=DIE
 ;
C20F1 Q
X20 Q
21 S DQ=22 ;@710
22 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=22 D X22 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X22 S RACT=$S(RAQUICK:"C",1:"P")
 Q
23 D:$D(DG)>9 F^DIE17,DE S DQ=23,D=0 K DE(1) ;100
 S DIFLD=100,DGO="^RACTEX14",DC="4^70.07DA^L^",DV="70.07RDI",DW="0;1",DOW="LOG DATE",DLB=$P($$EZBLD^DIALOG(8042,DOW),":") S:D DC=DC_D
 I $D(DSC(70.07))#2,$P(DSC(70.07),"I $D(^UTILITY(",1)="" X DSC(70.07) S D=$O(^(0)) S:D="" D=-1 G M23
 S D=$S($D(^RADPT(D0,"DT",D1,"P",DA,"L",0)):$P(^(0),U,3,4),$O(^(0))'="":$O(^(0)),1:-1)
M23 I D>0 S DC=DC_D I $D(^RADPT(D0,"DT",D1,"P",DA,"L",+D,0)) S DE(23)=$P(^(0),U,1)
 S X="""NOW"""
 S Y=X
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
R23 D DE
 G A
 ;
24 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=24 D X24 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X24 S RAREM="here, DIE is ^RADPT(-,'DT',-,'P',"
 Q
25 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=25 D X25 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X25 S RA00=$O(@(DIE_DA_",""RX"","_"0)"))
 Q
26 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=26 D X26 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X26 S RA00=$G(@(DIE_DA_",""RX"","_+RA00_",0)"))
 Q
27 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=27 D X27 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X27 S:RA00]"" Y="@720"
 Q
28 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=28 D X28 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X28 S RASKMEDS=$P(^RAMIS(71,+RAPRI,0),U,5) S:RASKMEDS=""!("Yy"'[RASKMEDS) Y="@790"
 Q
29 S DQ=30 ;@720
30 D:$D(DG)>9 F^DIE17 G ^RACTEX15