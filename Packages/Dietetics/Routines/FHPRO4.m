FHPRO4	; HISC/REL - Production/Meal Service Summary ;4/13/95  15:28
	;;5.0;Dietetics;;Oct 11, 1995
	S FHPAR=^FH(119.71,FHP,0) D:FHP1="Y" Q1 D:FHP2="Y" Q2 G ^FHPRO5
Q1	D SES S P0=0,OLD="" I $P(FHPAR,"^",7)'="Y" S PG=0 D HDR1
	S K4="" F LL=0:0 S K4=$O(^TMP($J,"T",K4)) Q:K4=""  F L1=0:0 S L1=$O(^TMP($J,"T",K4,L1)) Q:L1<1  S N1=^(L1),Y0=^FH(114,L1,0) D S1
	D HDR3 D:$P(FHPAR,"^",5)="Y" ^FHPRO4A K P Q
S1	I $P(FHPAR,"^",7)="Y",OLD'=$E(K4,1,2) S OLD=$E(K4,1,2),PG=0 D HDR1
	D:$Y>(IOSL-6) HDR1 W !!,$P(Y0,"^",1)
	I $P(FHPAR,"^",7)'="Y" S Z=$P(Y0,"^",12) S:Z Z=$P(^FH(114.2,Z,0),"^",2) W:Z'="" " (",Z,")"
	W ?40,$P(Y0,"^",3) S X=$P(Y0,"^",6) S:X X=$G(^FH(114.3,X,0)) W ?50,X,?62
	F K=1:1:N S P0=P(K),X=$G(^TMP($J,"T",K4,L1,P0)) W $J($S('X:"",1:X),6),"  "
	W ?S2,$J(^TMP($J,"T",K4,L1),6) Q
HDR1	S PG=PG+1 W @IOF,!,DTP,?(S1-35\2),"P R O D U C T I O N   S U M M A R Y",?(S1-6),"Page ",PG
	W !?(S1-$L(FHP6)),FHP6
	W ! D:$P(FHPAR,"^",7)="Y" PRE W ?(S1-$L(TIM)\2),TIM
	W !!,"Recipe",?40,"Portion",?50,"Utensil",?62,PD," TOTAL"
	S LN="",$P(LN,"-",S1+1)="" W !,LN Q
PRE	S Z=$P(Y0,"^",12) S:Z Z=$P($G(^FH(114.2,Z,0)),"^",1)
	W:Z'="" Z Q
SES	K N,P,S S PD="",N=0
	F P0=0:0 S P0=$O(^TMP($J,P0)) Q:P0<1  S Y=$P(^FH(119.72,P0,0),"^",4) S:Y="" Y=$E($P(^(0),"^",1),1,6) S S(Y_"~"_P0)=""
	S Y="" F  S Y=$O(S(Y)) Q:Y=""  S N=N+1,P(N)=$P(Y,"~",2),PD=PD_$J($P(Y,"~",1),6)_"  "
	K S S S2=62+$L(PD),S1=S2+6 Q
Q2	F P0=0:0 S P0=$O(^TMP($J,P0)) Q:P0<1  D M1
	Q
M1	D SET Q:NX=""  S PG=0
M2	S PD=$E(NX,1,53) Q:PD=""  S NX=$E(NX,55,999),S2=59+$L(PD),S1=S2+17 D HDR2
	S K4="" F LL=0:0 S K4=$O(^TMP($J,"T",K4)) Q:K4=""  F L1=0:0 S L1=$O(^TMP($J,"T",K4,L1)) Q:L1<1  S N1=$G(^TMP($J,"T",K4,L1,P0)) D:N1 M3
	D HDR3 G M2
M3	S Y0=^FH(114,L1,0),Z=$J("",$L(PD)) D:$Y>(IOSL-6) HDR2
	S K=$O(^FH(116.1,FHX1,"RE","B",L1,0))
	F CAT=0:0 S CAT=$O(^FH(116.1,FHX1,"RE",+K,"R",CAT)) Q:CAT<1  S FHPD=$P($G(^(CAT,0)),"^",2) D
	.F KK=1:1 S FHX2=$P(FHPD," ",KK) Q:FHX2=""  S X=$P(FHX2,";",1),X1=$F(PD,X) I X1>2 S Z=$E(Z,1,X1-3)_X_$E(Z,X1,999)
	.Q
	S X1=$P(Y0,"^",6) S:X1 X1=$G(^FH(114.3,X1,0))
	W !!,$P(Y0,"^",1),?32,$P(Y0,"^",3),?44,X1,?56,Z,?S2,$J(N1,5) Q
HDR2	S PG=PG+1 W @IOF,!,DTP,?(S1-39\2),"M E A L   S E R V I C E   S U M M A R Y",?(S1-6),"Page ",PG
	W !?(S1-$L(FHP6)),FHP6
	S X=$P(^FH(119.72,P0,0),"^",1) W !?(S1-$L(X)\2),X,!!?(S1-$L(TIM)\2),TIM
	W !!,"Recipe",?32,"Portion",?44,"Utensil",?56,PD,?S2,"Total"
	S LN="",$P(LN,"-",S1+1)="" W !,LN Q
HDR3	W !!!,"*** Note: Does NOT include add-ons and specials!",! Q
SET	K N F K=0:0 S K=$O(^TMP($J,P0,K)) Q:K<1  S X=$P($G(^FH(116.2,K,0)),"^",6) S:X<1 X=99 S N(X)=K
	S NX="" F K=0:0 S K=$O(N(K)) Q:K<1  S C0=$P($G(^FH(116.2,+N(K),0)),"^",2) S:C0="" C0="**" S NX=NX_C0_" "
	K N Q
T1	S K1=$O(^FH(116.2,"C",C0,0)) Q:K1<1  S X=$P(^FH(116.2,K1,0),"^",6)
	S:X<1 X=99 S N(X)=C0 Q
