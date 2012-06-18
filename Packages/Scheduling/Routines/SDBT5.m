SDBT5 ; ;10/29/04
 D DE G BEGIN
DE S DIE="^SC(",DIC=DIE,DP=44,DL=1,DIEL=0,DU="" K DG,DE,DB Q:$O(^SC(DA,""))=""
 I $D(^(0)) S %Z=^(0) S %=$P(%Z,U,11) S:%]"" DE(21)=% S %=$P(%Z,U,18) S:%]"" DE(15)=% S %=$P(%Z,U,24) S:%]"" DE(1)=% S %=$P(%Z,U,30) S:%]"" DE(5)=%
 I $D(^("PC")) S %Z=^("PC") S %=$P(%Z,U,1) S:%]"" DE(3)=%
 I $D(^("SDP")) S %Z=^("SDP") S %=$P(%Z,U,1) S:%]"" DE(6)=% S %=$P(%Z,U,2) S:%]"" DE(7)=% S %=$P(%Z,U,3) S:%]"" DE(12)=% S %=$P(%Z,U,4) S:%]"" DE(13)=%
 I $D(^("SDPROT")) S %Z=^("SDPROT") S %=$P(%Z,U,1) S:%]"" DE(16)=%
 I $D(^("SL")) S %Z=^("SL") S %=$P(%Z,U,1) S:%]"" DE(25)=% S %=$P(%Z,U,3) S:%]"" DE(9)=% S %=$P(%Z,U,5) S:%]"" DE(22)=% S %=$P(%Z,U,7) S:%]"" DE(23)=% S %=$P(%Z,U,8) S:%]"" DE(14)=%
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
BEGIN S DNM="SDBT5",DQ=1
1 D:$D(DG)>9 F^DIE17,DE S DQ=1,DW="0;24",DV="S",DU="",DLB="ASK FOR CHECK IN/OUT TIME",DIFLD=24
 S DU="0:NO;1:YES;"
 G RE
X1 Q
2 S D=0 K DE(1) ;2600
 S DIFLD=2600,DGO="^SDBT6",DC="2^44.1P^PR^",DV="44.1M*P200'",DW="0;1",DOW="PROVIDER",DLB="Select "_DOW S:D DC=DC_D
 S DU="VA(200,"
 G RE:D I $D(DSC(44.1))#2,$P(DSC(44.1),"I $D(^UTILITY(",1)="" X DSC(44.1) S D=$O(^(0)) S:D="" D=-1 G M2
 S D=$S($D(^SC(DA,"PR",0)):$P(^(0),U,3,4),$O(^(0))'="":$O(^(0)),1:-1)
M2 I D>0 S DC=DC_D I $D(^SC(DA,"PR",+D,0)) S DE(2)=$P(^(0),U,1)
 G RE
R2 D DE
 S D=$S($D(^SC(DA,"PR",0)):$P(^(0),U,3,4),1:1) G 2+1
 ;
3 S DW="PC;1",DV="S",DU="",DLB="DEFAULT TO PC PRACTITIONER?",DIFLD=2801
 S DU="1:YES;0:NO;"
 G RE
X3 Q
4 S D=0 K DE(1) ;2700
 S DIFLD=2700,DGO="^SDBT7",DC="2^44.11P^DX^",DV="44.11M*P80'",DW="0;1",DOW="DIAGNOSIS",DLB="Select "_DOW S:D DC=DC_D
 S DU="ICD9("
 G RE:D I $D(DSC(44.11))#2,$P(DSC(44.11),"I $D(^UTILITY(",1)="" X DSC(44.11) S D=$O(^(0)) S:D="" D=-1 G M4
 S D=$S($D(^SC(DA,"DX",0)):$P(^(0),U,3,4),$O(^(0))'="":$O(^(0)),1:-1)
M4 I D>0 S DC=DC_D I $D(^SC(DA,"DX",+D,0)) S DE(4)=$P(^(0),U,1)
 G RE
R4 D DE
 S D=$S($D(^SC(DA,"DX",0)):$P(^(0),U,3,4),1:1) G 4+1
 ;
5 S DW="0;30",DV="S",DU="",DLB="WORKLOAD VALIDATION AT CHK OUT",DIFLD=30
 S DU="1:YES;0:NO;"
 G RE
X5 Q
6 S DW="SDP;1",DV="RNJ3,0",DU="",DLB="ALLOWABLE CONSECUTIVE NO-SHOWS",DIFLD=2001
 G RE
X6 K:+X'=X!(X>999)!(X<0)!(X?.E1"."1N.N) X
 Q
 ;
7 S DW="SDP;2",DV="RNJ3,0",DU="",DLB="MAX # DAYS FOR FUTURE BOOKING",DIFLD=2002
 G RE
X7 K:+X'=X!(X>999)!(X<1)!(X?.E1"."1.N) X
 Q
 ;
8 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=8 D X8 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X8 S:+$O(^SC(DA,"ST",0))>0 Y="@25"
 Q
9 S DW="SL;3",DV="NJ2,0",DU="",DLB="HOUR CLINIC DISPLAY BEGINS",DIFLD=1914
 G RE
X9 K:+X'=X!(X>16)!(X<0)!(X?.E1"."1N.N) X
 Q
 ;
10 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=10 G A
11 S DQ=12 ;@25
12 S DW="SDP;3",DV="NJ2,0X",DU="",DLB="START TIME FOR AUTO REBOOK",DIFLD=2003
 G RE
X12 K:+X'=X!(X>16)!(X<0)!(X?.E1"."1N.N) X I $D(X),$D(^SC(DA,"SL")) I X<$S('$P(^("SL"),"^",3):8,1:$P(^("SL"),"^",3)) W !,*7,"MUST NOT BE EARLIER THAN CLINIC START TIME" K X
 Q
 ;
13 S DW="SDP;4",DV="RNJ3,0",DU="",DLB="MAX # DAYS FOR AUTO-REBOOK",DIFLD=2005
 G RE
X13 K:+X'=X!(X>365)!(X<1)!(X?.E1"."1N.N) X
 Q
 ;
14 S DW="SL;8",DV="S",DU="",DLB="SCHEDULE ON HOLIDAYS?",DIFLD=1918.5
 S DU="Y:YES;"
 G RE
X14 Q
15 S DW="0;18",DV="*P40.7'",DU="",DLB="CREDIT STOP CODE",DIFLD=2503
 S DU="DIC(40.7,"
 G RE
X15 S DIC("S")="I $P(^(0),U,2)'=900&$S('$P(^(0),U,3):1,$P(^(0),U,3)>DT:1,1:0)" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
 Q
 ;
16 S DW="SDPROT;1",DV="S",DU="",DLB="PROHIBIT ACCESS TO CLINIC?",DIFLD=2500
 S DU="Y:YES;"
 G RE
X16 Q
17 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=17 D X17 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X17 S:X'="Y" Y="@30"
 Q
18 S D=0 K DE(1) ;2501
 S DIFLD=2501,DGO="^SDBT8",DC="1^44.04PA^SDPRIV^",DV="44.04P200'X",DW="0;1",DOW="PRIVILEGED USER",DLB="Select "_DOW S:D DC=DC_D
 S DU="VA(200,"
 I $D(DSC(44.04))#2,$P(DSC(44.04),"I $D(^UTILITY(",1)="" X DSC(44.04) S D=$O(^(0)) S:D="" D=-1 G M18
 S D=$S($D(^SC(DA,"SDPRIV",0)):$P(^(0),U,3,4),$O(^(0))'="":$O(^(0)),1:-1)
M18 I D>0 S DC=DC_D I $D(^SC(DA,"SDPRIV",+D,0)) S DE(18)=$P(^(0),U,1)
 G RE
R18 D DE
 G A
 ;
19 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=19 G A
20 S DQ=21 ;@30
21 S DW="0;11",DV="F",DU="",DLB="PHYSICAL LOCATION",DIFLD=10
 G RE
X21 K:$L(X)>25!($L(X)<1) X
 I $D(X),X'?.ANP K X
 Q
 ;
22 S DW="SL;5",DV="*P44'",DU="",DLB="PRINCIPAL CLINIC",DIFLD=1916
 S DE(DW)="C22^SDBT5"
 S DU="SC("
 G RE
C22 G C22S:$D(DE(22))[0 K DB
 S X=DE(22),DIC=DIE
 K ^SC("AIHSPC",$E(X,1,30),DA)
C22S S X="" G:DG(DQ)=X C22F1 K DB
 S X=DG(DQ),DIC=DIE
 S ^SC("AIHSPC",$E(X,1,30),DA)=""
C22F1 Q
X22 S DIC("S")="I $P(^(0),""^"",3)=""C"",'$G(^(""OOS""))" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
 Q
 ;
23 D:$D(DG)>9 F^DIE17,DE S DQ=23,DW="SL;7",DV="RNJ4,0",DU="",DLB="OVERBOOKS/DAY MAXIMUM",DIFLD=1918
 G RE
X23 K:+X'=X!(X>9999)!(X<0)!(X?.E1"."1N.N) X
 Q
 ;
24 S D=0 K DE(1) ;1910
 S DIFLD=1910,DGO="^SDBT9",DC="1^44.03A^SI^",DV="44.03F",DW="0;1",DOW="SPECIAL INSTRUCTIONS",DLB="Select "_DOW S:D DC=DC_D
 I $D(DSC(44.03))#2,$P(DSC(44.03),"I $D(^UTILITY(",1)="" X DSC(44.03) S D=$O(^(0)) S:D="" D=-1 G M24
 S D=$S($D(^SC(DA,"SI",0)):$P(^(0),U,3,4),$O(^(0))'="":$O(^(0)),1:-1)
M24 I D>0 S DC=DC_D I $D(^SC(DA,"SI",+D,0)) S DE(24)=$P(^(0),U,1)
 G RE
R24 D DE
 G A
 ;
25 S DW="SL;1",DV="RNJ2,0X",DU="",DLB="LENGTH OF APP'T",DIFLD=1912
 G RE
X25 K:+X'=X!(X>240)!(X<10)!(X?.E1"."1N.N)!($S('(X#10):0,'(X#15):0,1:1)) X I $D(X) S SDLA=X I $D(^SC(DA,"SL")),+$P(^("SL"),U,6) S SDZ0=$P(^("SL"),U,6),SDZ1=60\SDZ0 I X#SDZ1 D LAPPT^SDUTL
 Q
 ;
26 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=26 G A
27 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=27 D X27 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X27 I '$D(SDLA) S SDLA=X
 Q
28 D:$D(DG)>9 F^DIE17 G ^SDBT10
