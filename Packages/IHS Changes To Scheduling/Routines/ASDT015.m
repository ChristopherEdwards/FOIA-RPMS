ASDT015 ; ;06/30/03
 D DE G BEGIN
DE S DIE="^SC(",DIC=DIE,DP=44,DL=1,DIEL=0,DU="" K DG,DE,DB Q:$O(^SC(DA,""))=""
 I $D(^(9999999)) S %Z=^(9999999) S %=$P(%Z,U,6) S:%]"" DE(4)=%
 I $D(^("LTR")) S %Z=^("LTR") S %=$P(%Z,U,3) S:%]"" DE(1)=% S %=$P(%Z,U,4) S:%]"" DE(2)=%
 I $D(^("SDP")) S %Z=^("SDP") S %=$P(%Z,U,1) S:%]"" DE(3)=% S %=$P(%Z,U,2) S:%]"" DE(5)=% S %=$P(%Z,U,3) S:%]"" DE(10)=% S %=$P(%Z,U,4) S:%]"" DE(11)=%
 I $D(^("SDPROT")) S %Z=^("SDPROT") S %=$P(%Z,U,1) S:%]"" DE(13)=%
 I $D(^("SL")) S %Z=^("SL") S %=$P(%Z,U,3) S:%]"" DE(7)=% S %=$P(%Z,U,8) S:%]"" DE(12)=%
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
BEGIN S DNM="ASDT015",DQ=1
1 D:$D(DG)>9 F^DIE17,DE S DQ=1,DW="LTR;3",DV="*P407.5'",DU="",DLB="CLINIC CANCELLATION LETTER",DIFLD=2510
 S DE(DW)="C1^ASDT015"
 S DU="VA(407.5,"
 G RE
C1 G C1S:$D(DE(1))[0 K DB
 S X=DE(1),DIC=DIE
 K ^SC("ALTC",$E(X,1,30),DA)
C1S S X="" Q:DG(DQ)=X  K DB
 S X=DG(DQ),DIC=DIE
 S ^SC("ALTC",$E(X,1,30),DA)=""
 Q
X1 S DIC("S")="I $P(^(0),""^"",2)=""C""" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
 Q
 ;
2 D:$D(DG)>9 F^DIE17,DE S DQ=2,DW="LTR;4",DV="*P407.5'",DU="",DLB="APPT. CANCELLATION LETTER",DIFLD=2511
 S DE(DW)="C2^ASDT015"
 S DU="VA(407.5,"
 G RE
C2 G C2S:$D(DE(2))[0 K DB
 S X=DE(2),DIC=DIE
 K ^SC("ALTA",$E(X,1,30),DA)
C2S S X="" Q:DG(DQ)=X  K DB
 S X=DG(DQ),DIC=DIE
 S ^SC("ALTA",$E(X,1,30),DA)=""
 Q
X2 S DIC("S")="I $P(^(0),""^"",2)=""A""" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
 Q
 ;
3 D:$D(DG)>9 F^DIE17,DE S DQ=3,DW="SDP;1",DV="RNJ3,0",DU="",DLB="ALLOWABLE CONSECUTIVE NO-SHOWS",DIFLD=2001
 G RE
X3 K:+X'=X!(X>999)!(X<0)!(X?.E1"."1N.N) X
 Q
 ;
4 S DW="9999999;6",DV="NJ3,0",DU="",DLB="WAITING PERIOD FOR COUNTING UP NO-SHOWS",DIFLD=9999999.6
 G RE
X4 K:+X'=X!(X>365)!(X<0)!(X?.E1"."1N.N) X
 Q
 ;
5 S DW="SDP;2",DV="RNJ3,0",DU="",DLB="MAX # DAYS FOR FUTURE BOOKING",DIFLD=2002
 G RE
X5 K:+X'=X!(X>999)!(X<1)!(X?.E1"."1N.N) X
 Q
 ;
6 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=6 D X6 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X6 S:$O(^SC(DA,"ST",0))>0 Y="@12"
 Q
7 S DW="SL;3",DV="NJ2,0",DU="",DLB="HOUR CLINIC DISPLAY BEGINS",DIFLD=1914
 G RE
X7 K:+X'=X!(X>16)!(X<0)!(X?.E1"."1N.N) X
 Q
 ;
8 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=8 G A
9 S DQ=10 ;@12
10 S DW="SDP;3",DV="NJ2,0X",DU="",DLB="START TIME FOR AUTO REBOOK",DIFLD=2003
 G RE
X10 K:+X'=X!(X>16)!(X<0)!(X?.E1"."1N.N) X I $D(X),$D(^SC(DA,"SL")) I X<$S('$P(^("SL"),"^",3):8,1:$P(^("SL"),"^",3)) W !,*7,"MUST NOT BE EARLIER THAN CLINIC START TIME" K X
 Q
 ;
11 S DW="SDP;4",DV="RNJ3,0",DU="",DLB="MAX # DAYS FOR AUTO-REBOOK",DIFLD=2005
 G RE
X11 K:+X'=X!(X>365)!(X<1)!(X?.E1"."1N.N) X
 Q
 ;
12 S DW="SL;8",DV="S",DU="",DLB="SCHEDULE ON HOLIDAYS?",DIFLD=1918.5
 S DU="Y:YES;"
 G RE
X12 Q
13 S DW="SDPROT;1",DV="S",DU="",DLB="PROHIBIT ACCESS TO CLINIC?",DIFLD=2500
 S DU="Y:YES;"
 G RE
X13 Q
14 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=14 D X14 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X14 S:X'="Y" Y="@30"
 Q
15 D:$D(DG)>9 F^DIE17 G ^ASDT016
