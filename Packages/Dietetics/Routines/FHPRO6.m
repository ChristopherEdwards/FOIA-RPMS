FHPRO6 ; HISC/REL - Storeroom Requisition ;4/25/93  15:59 
 ;;5.0;Dietetics;**35**;Oct 11, 1995
 S OLD="",R2="" I $P(FHPAR,"^",6)'="Y" S PG=0 D HDR
S1 S R2=$O(^TMP($J,"S",R2)) I R2="" W ! Q
 F X1=0:0 S X1=$O(^TMP($J,"S",R2,X1)) Q:X1<1  D S2
 G S1
S2 S Y(0)=$G(^FHING(X1,0)),UNT=$P(Y(0),"^",16),(FLG,TOT)=0
 I $P(FHPAR,"^",6)="Y",OLD'=$E(R2,1,2) S OLD=$E(R2,1,2),PG=0 D HDR
 S R1="" F K4=0:0 S R1=$O(^TMP($J,"S",R2,X1,R1)) Q:R1=""  F K1=0:0 S K1=$O(^TMP($J,"S",R2,X1,R1,K1)) Q:K1<1  S TOT=TOT+^(K1)
 S R1="" F K4=0:0 S R1=$O(^TMP($J,"S",R2,X1,R1)) Q:R1=""  F K1=0:0 S K1=$O(^TMP($J,"S",R2,X1,R1,K1)) Q:K1<1  S Y=^(K1) D S4
 Q
S4 D:$Y>(IOSL-7) HDR W ! G:FLG S5 W !,$P(Y(0),"^",1) S FLG=1 I $P(FHPAR,"^",6)'="Y",$E(R2,1,2)'=99 S Z=$P(Y(0),"^",12) S:Z Z=$P($G(^FH(113.1,Z,0)),"^",2) W:Z'="" " (",Z,")"
 S I2=$P(Y(0),"^",17) G:'I2 S5 S I1=TOT/I2
 S I1=$S(I1<1:1,I1#1<.1:I1\1,1:I1+.9\1) W ?60,I1," ",$P(Y(0),"^",6)
S5 D EN2^FHREC1 W ?80,$P($G(^FH(114,K1,0)),"^",1),?112,$E(Y,1,19) Q
HDR S PG=PG+1 W @IOF,!,DTP,?45,"S T O R E R O O M   R E Q U I S I T I O N",?125,"Page ",PG
 W !?(131-$L(FHP6)),FHP6
 W ! D:$P(FHPAR,"^",6)="Y" STO W ?(132-$L(TIM)\2),TIM
 W !!,"Ingredient",?60,"Storeroom Amount",?80,"Recipe",?112,"Quantity"
 W ! F K=1:1:131 W "-"
 Q
STO S K=$P(Y(0),"^",12) S:K K=$P($G(^FH(113.1,K,0)),"^",1)
 W:K'="" K Q
