INHDIA3 ;GFT,JSH; 6 May 91 13:03 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
X ;
 I 'Y S:'DSC&DB DB=DB+1 F Y=0:0 S Y=$O(Y(Y)) G 2^INHDIA:Y="" D D^INHDIA
 S Y=X G B:Y'[";" I Y?.E1";"1L.E F D=97:1:122 S %=$F(Y,";"_$C(D)) I % S Y=$E(Y,1,%-2)_$C(D-32)_$E(Y,%,999)
 S X=$P(Y,";",2,9),DK=$P(X,";",2,9),DRS=99,D=$E(X),%=$P(X,";") S:DK]"" DK=";"_DK S:%["//" $P(Y,";")=$P(Y,";")_"//"_$P(%,"//",2,9),$P(X,";")=$P(%,"//")
 I D="U" S $P(DV,"//")=$P(DV,"//")_U_% G BACK
 S D=$S(D="N":D,D="F":D,D="T":2,D="""":$F(X,D,2),1:0) I 'D S D=$S(D'=0:D,X[";":$F(X,";")-1,1:999) S:'D $P(DV,"//")=$P(DV,"//")_U_D,D=2
 E  S %=$S(D=2:"T",1:$E(X,2,D-2)) G DIA3^DIQQQ:$A(%)>45&($A(%)<58)!(%[":") S DV=%_DV
 S DK=$E(X,D,999)
BACK S X=$P(Y,";")_DK S:'$D(DIAB) DIAB=Y G DIC^INHDIA
 ;
B I X'?.E1":",X[" ",DUZ(0)="@" D ^DIM G P:$D(X)=1
DF F DK="///+","//+","///","//" I Y[DK S DP=$P(Y,DK,2,9) I DP'?1"/".E&(DP'?1"^".E)!(DUZ(0)="@") G DEF
 G BAD:Y'?.E1":"
E K X S:'$D(DIAB) DIAB=Y S DIA3=$P($P($G(DIAT),";",DB),U,4),DICOMP=L_$E("L",DIA3["L")_$E(2,DIA3["A")_$E("N",DIA3["N")_"WE?",DQI="Y(",DA="DR(99,"_DXS_",",X=Y,DICMX=1 D ^DICOMPW I '$D(X) K DIAB G BAD
 I $D(X)>1 S DXS=DXS+1 F %=0:0 S %=$O(X(%)) Q:'%  S @(DA_"%)=X(%)")
 S %=2 I Y["E" S %=2-(DIA3["M") W:$X ! W "Having entered data for one '"_$E(DIAB,1,$L(DIAB)-1)_"' ENTRY,",!?9,"shall user be asked another" D YN^DICN I %<1 K DIAB G BAD
 S L=$S(Y>L:+Y,1:L\100+1*100),Y=U_DP_U_$E("M",%)_$E("L",Y["L")_$E("A",Y["A")_$E("N",Y'["E")_U_X_" S X=$S(D(0)>0:D(0),1:"""")",DRS=99 K X D DB^INHDIA S X=DI,DI=+DP G EN^INHDIA
 ;
DEF S DIA3=Y,X="DA,DV,DWLC,0)=X" F J=L:-1 Q:I(J)[U  S X="DA("_(L-J+1)_"),"_I(J)_","_X
 I $L(DP)>1!(DP="@") S DICMX="S DWLC=DWLC+1,"_DIA_X,DA="DR(99,"_DXS_",",X=DP,DQI="X(",DICOMP=L_"T?" D EN^DICOMP,DICS^INHDIA,XEC
 K X S X=$P(DIA3,DK),DV=DV_DK_DP G DIC^INHDIA:DV'[";"
BAD G X^INHDIA
 ;
XEC I $D(X),Y["m" S DIC("S")="S %=$P(^(0),U,2) I %,$D(^DD(+%,.01,0)),$P(^(0),U,2)[""W"",$D(^DD(DI,Y,0)) "_DIC("S")
 F Y=0:0 S Y=$O(X(Y)) Q:Y=""  S @(DA_"Y)=X(Y)")
 I $D(X) S %=1,Y="Do you mean '"_DP_"' as a variable" W !?63-$L(Y),Y D YN^DICN Q:%-1  S Y="Q",DXS=DXS+1,DP=U_X,DRS=99 D D^INHDIA:$S(DIAP:$P(DR(DIAR,DI),";",DIAP#1000)'="Q",1:1) S:'$D(DIAB) DIAB=DIA3
 Q:DP'="@"  I DK="//" S DA=U_U Q
 Q
 ;
AT ;
 S DIAB=X I X?1P1N.N1";"1E.E S X=$P(X,";") G P
 K X S X=$P($E(DIAB,2,999),";"),DICOMP=L_"T?",DQI="X(",DA="DR(99,"_DXS_","
 D EN^DICOMP,DICS^INHDIA G BAD:'$D(X)
 S DXS=DXS+1,X=X_" K Y" F Y=0:0 S Y=$O(X(Y)) Q:Y=""  S @(DA_"Y)=X(Y)") K X(Y)
P G P^INHDIA
