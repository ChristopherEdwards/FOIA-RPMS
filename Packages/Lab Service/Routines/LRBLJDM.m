LRBLJDM ; IHS/DIR/AAB - MULTIPLE COMP PREP, INVENTORY 5/21/97 14:56 ; [ 04/29/98 10:25 AM ]
 ;;5.2;LR;**1003**;JUN 01, 1998
 ;;5.2;LAB SERVICE;**90**;Sep 27, 1994
 S X=^LAB(66,LRV,0),LRP(LRV)=$P(X,"^")_"^"_$P(X,"^",10)_"^"_$P(X,"^",11)_"^"_$P(X,"^",18),LRZ=$P(X,"^",19)
C S DIC="^LAB(66,LRE(4),3,",DIC(0)="AEQMZ" D ^DIC K DIC I Y>0 S (X,Y)=+Y,X=^LAB(66,X,0),LRP(Y)=$P(X,"^")_"^"_$P(X,"^",10)_"^"_$P(X,"^",11)_"^"_$P(X,"^",18) D:'$P(^LAB(66,LRE(4),3,Y,0),"^",2) ONLY D:$D(LRP(Y)) CK G C
 G:'$D(LRP) OUT S S=0 W !,"You have selected the following component(s): " S X=0 F X(1)=0:1 S X=$O(LRP(X)) Q:'X  W !,$P(LRP(X),"^"),?40,"vol(ml):",$J($P(LRP(X),"^",2),5) S S=S+$P(LRP(X),"^",2)
 W !?48,"-----",!?34,"Total vol(ml):",$J(S,5) I S>LRM W !!,$C(7),"Total volume of components greater than unit. SELECTIONS DELETED TRY AGAIN !",!! K LRP S LRZ=0 G C
 W !?5,"All OK " S %=1 D YN^LRU I %'=1 W " SELECTIONS DELETED TRY AGAIN",! K LRP G C
 S LRE(1)=$P(LRE,"^"),LRV(10)=LRV(10)/X(1) I LRV(10)["." S LRV(10)=$P(LRV(10),".")_"."_$E($P(LRV(10),".",2),1,2)
 F LRH=0:0 S LRH=$O(LRP(LRH)) Q:'LRH  S LRV=LRH,LRV(1)=$P(LRP(LRH),"^"),LRM=$P(LRP(LRH),"^",2),LRO(1)=$P(LRP(LRH),"^",3),LRD=$P(LRP(LRH),"^",4) D:LRO(1) F D:LRO(1)="" T D S
 Q
ONLY W !!,$C(7),"Component selected must be the ONLY ONE for this unit.",!," Selection ",$P(LRP(Y),"^")," canceled !",! K LRP(Y) Q
CK I LRZ,$P(X,"^",19) W $C(7),!!,"Cannot select more than one red blood cell product.",!,"Selection ",$P(LRP(Y),"^")," canceled !",! K LRP(Y) Q
 S:'LRZ LRZ=$P(X,"^",19) Q
 ;
T S Y=$P(LRE,"^",6) D D^LRU S LRO(1)=Y Q
 ;
F ;from LRBLJD
 S T(2)="."_$P(LRO(1),".",2)*1440,LRO(1)=$P(LRO(1),".") S X="N",%DT="T" D ^%DT S X=Y,Y=Y_"000",T(3)=$E(Y,9,10)*60+$E(Y,11,12) D H^%DTC S T(5)=T(3)+T(2),%H=%H+LRO(1)+(T(5)\1440),T(5)=T(5)#1440\1
 D D^LRUT I LRO(9)<2 S T(3)=T(5)\60,T(3)=$E("00",1,2-$L(T(3)))_T(3),T(4)=T(5)#60,T(4)=$E("00",1,2-$L(T(4)))_T(4),T(4)=T(3)_T(4) S:+T(4) X=X_"."_T(4)
 S Y=$P(X,"."),X=$P(X,".",2) D D^LRU S LRO(1)=$S(X:Y_"@"_X,1:Y) Q
 ;
S ;from LRBLJD
 S LRE(1)=$P(LRE,"^")_LRV(11) S:'$D(^LRD(65,LRX,9,0)) ^(0)="^65.091PAI^^" S X=^(0),C=$P(X,"^",4)+1,^(0)=$P(X,"^",1,2)_"^"_C_"^"_C,^(C,0)=LRV_"^"_LRE(1)_"^"_2
 D:C>1 SET D ^LRBLJDA Q:'LRCAPA  F A=0:0 S A=$O(^LAB(66,LRV,9,A)) Q:'A  S LRT(A)=""
 D ^LRBLW K LRT S LRT=LRW("MO") Q
SET S C=0 F A=0:0 S A=$O(^LRD(65,LRX,9,A)) Q:'A  S:$P(^(A,0),"^",3)=2 C=C+1
 S $P(^LRD(65,LRX,4),"^",4)="("_C_")" Q
 ;
D I LRCAPA,'$O(^LAB(66,LRV,9,0)) W $C(7),!,!!,"Must enter WKLD CODES in BLOOD PRODUCT FILE (#66)",!,"for ",$P(^LAB(66,LRV,0),U)," to divide unit.",! D OUT Q
 R !,"Enter number of aliquots (1-5): ",A:DTIME I A=""!(A[U) D OUT Q
 S A=+A I A>5!(A<1) W !!,"Answer must be 1,2,3,4, or 5",! G D
 S LR("C")=A,LRM=LRM\A,LRV(10)=LRV(10)/A S:LRV(10)["." LRV(10)=$P(LRV(10),".")_"."_$E($P(LRV(10),".",2),1,2) F B=1:1:LR("C") S LRV(11)=$C(64+B) D S
 Q
 ;
OUT D K^LRBLJD Q
