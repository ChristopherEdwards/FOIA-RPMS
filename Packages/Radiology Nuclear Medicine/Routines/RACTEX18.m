RACTEX18 ; ;05/20/15
 D DE G BEGIN
DE S DIE="^RADPTN(D0,""NUC"",",DIC=DIE,DP=70.21,DL=5,DIEL=1,DU="" K DG,DE,DB Q:$O(^RADPTN(D0,"NUC",DA,""))=""
 I $D(^(0)) S %Z=^(0) S %=$P(%Z,U,2) S:%]"" DE(2)=% S %=$P(%Z,U,3) S:%]"" DE(1)=% S %=$P(%Z,U,6) S:%]"" DE(8)=% S %=$P(%Z,U,8) S:%]"" DE(4)=% S %=$P(%Z,U,9) S:%]"" DE(5)=% S %=$P(%Z,U,10) S:%]"" DE(12)=% S %=$P(%Z,U,11) S:%]"" DE(15)=%
 I  S %=$P(%Z,U,12) S:%]"" DE(18)=% S %=$P(%Z,U,13) S:%]"" DE(24)=% S %=$P(%Z,U,14) S:%]"" DE(27)=% S %=$P(%Z,U,15) S:%]"" DE(30)=%
 I $D(^("SITX")) S %Z=^("SITX") S %=$P(%Z,U,1) S:%]"" DE(21)=%
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
BEGIN S DNM="RACTEX18",DQ=1
1 S DW="0;3",DV="*P200'",DU="",DLB="PRESCRIBING PHYSICIAN",DIFLD=3
 S DU="VA(200,"
 G RE
X1 S DIC("S")="I $$VALADM^RADD1(D0,+Y,"""",1)" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
 Q
 ;
2 S DW="0;2",DV="NJ10,4",DU="",DLB="PRESCRIBED DOSE BY MD OVERRIDE (in mCi)",DIFLD=2
 G RE
X2 K:+X'=X!(X>99999.9999)!(X<.0001)!(X?.E1"."5N.N) X
 Q
 ;
3 S DQ=4 ;@270
4 S DW="0;8",DV="DX",DU="",DLB="DATE/TIME DOSE ADMINISTERED",DIFLD=8
 S X=$S($P($G(^RADPTN(DA(1),"NUC",DA,0)),"^",5)]"":$P(^(0),"^",5),1:"NOW")
 S Y=X
 G Y
X4 S %DT="ETXR",%DT(0)=$S($P($G(^RADPTN(D0,"NUC",D1,0)),"^",5)]"":$P(^(0),"^",5),1:$$FMADD^XLFDT($P($G(^RADPTN(D0,0)),"^",2),-7)) D ^%DT S X=Y K:Y<1 X K %DT(0)
 Q
 ;
5 S DW="0;9",DV="*P200'",DU="",DLB="PERSON WHO ADMINISTERED DOSE",DIFLD=9
 S DU="VA(200,"
 S X=$P(^VA(200,+$G(DUZ),0),U)
 S Y=X
 G Y
X5 S DIC("S")="I $$VALADM^RADD1(D0,+Y,"""",0)" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
 Q
 ;
6 S DQ=7 ;@290
7 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=7 D X7 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X7 S:$P(RA00,U,6)="" Y="@310"
 Q
8 S DW="0;6",DV="*P200'",DU="",DLB="PERSON WHO MEASURED DOSE",DIFLD=6
 S DU="VA(200,"
 G RE
X8 S DIC("S")="I $$VALADM^RADD1(D0,+Y,"""",0)" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
 Q
 ;
9 S DQ=10 ;@310
10 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=10 D X10 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X10 S RAREM="Note: 'RAASK' may not be defined, hit global for 'Prompt For Radiopharm RX'"
 Q
11 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=11 D X11 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X11 S:$P($G(^RAMIS(71,RAPRI,0)),"^",19)'="y" Y="@320"
 Q
12 S DW="0;10",DV="*P200'",DU="",DLB="WITNESS TO DOSE ADMINISTRATION",DIFLD=10
 S DU="VA(200,"
 G RE
X12 S DIC("S")="N RAPAD S RAPAD=+$P($G(^RADPTN(DA(1),""NUC"",DA,0)),""^"",9) I +Y'=RAPAD" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
 Q
 ;
13 S DQ=14 ;@320
14 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=14 D X14 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X14 S:$P(RA00,U,11)="" Y="@330"
 Q
15 S DW="0;11",DV="P71.6'",DU="",DLB="ROUTE OF ADMINISTRATION",DIFLD=11
 S DU="RAMIS(71.6,"
 G RE
X15 Q
16 S DQ=17 ;@330
17 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=17 D X17 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X17 S:$P(RA00,U,12)="" Y="@335"
 Q
18 S DW="0;12",DV="*P71.7'",DU="",DLB="SITE OF ADMINISTRATION",DIFLD=12
 S DU="RAMIS(71.7,"
 G RE
X18 S DIC("S")="N RA702 S RA702=$G(^RADPTN(DA(1),""NUC"",DA,0)) I $S(+$P(RA702,""^"",11):$D(^RAMIS(71.6,+$P(RA702,""^"",11),""SITE"",""B"",+Y)),1:1)" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
 Q
 ;
19 S DQ=20 ;@335
20 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=20 D X20 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X20 S:'$D(@(DIE_DA_",""SITX"")")) Y="@340"
 Q
21 S DW="SITX;1",DV="F",DU="",DLB="SITE OF ADMIN TEXT",DIFLD=12.5
 G RE
X21 K:$L(X)>45!($L(X)<3) X
 I $D(X),X'?.ANP K X
 Q
 ;
22 S DQ=23 ;@340
23 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=23 D X23 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X23 S:$P(RA00,U,13)="" Y="@350"
 Q
24 S DW="0;13",DV="*P71.9",DU="",DLB="LOT NO.",DIFLD=13
 S DU="RAMIS(71.9,"
 G RE
X24 S DIC("S")="I $P(^(0),U,6)="""",$$SCRLOT^RADD3" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
 Q
 ;
25 S DQ=26 ;@350
26 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=26 D X26 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X26 S:$P(RA00,U,14)="" Y="@360"
 Q
27 S DW="0;14",DV="FXO",DU="",DLB="VOLUME (in ml or caplets)",DIFLD=14
 S DQ(27,2)="S Y(0)=Y S Y=+Y_"" ""_$S($P(Y,"" "",2)=""c"":""caplet"",1:""ml"") S:+Y>1&($E($P(Y,"" "",2),1)=""c"") Y=Y_""s"""
 G RE
X27 S X=$$VOL^RADD1(X) K:X="" X
 I $D(X),X'?.ANP K X
 Q
 ;
28 S DQ=29 ;@360
29 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=29 D X29 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X29 S:$P(RA00,U,15)="" Y="@500"
 Q
30 S DW="0;15",DV="S",DU="",DLB="FORM",DIFLD=15
 S DU="L:Liquid;G:Gas;A:Aerosol;P:Solid (pill);S:Solid (other);"
 G RE
X30 Q
31 S DQ=32 ;@500
32 G 1^DIE17
