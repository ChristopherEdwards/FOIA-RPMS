FHIPST20	; HISC/REL/NCA - Remove American Diet Products ;12/14/94  15:44
	;;5.0;Dietetics;;Oct 11, 1995
STOR	; Store American Diet Products
	K ^TMP($J,"FHITEM"),^TMP($J,"FHPROD") F K=5999:0 S K=$O(^FHNU(K)) Q:K<1  D
	.S X=^(K,0),KL=0
	.I X["AMDIETPROD" S KL=1
	.I X["AMER.DIET" S KL=1
	.I X["(VA)" S KL=1
	.I X["AMHOSCO" S KL=1
	.I KL S ^TMP($J,"FHPROD",K)=""
	.Q
	I '$D(^TMP($J,"FHPROD")) K K,X,KL Q
CHK	; Check existing pointers in file 113,114,and 112.6
	W !!,"Checking Ingredient Default Nutrient in file 113 ..."
	F K=0:0 S K=$O(^FHING(K)) Q:K<1  S Y=+$P(^(K,0),"^",21) I Y D
	.I '$D(^FHNU(Y)) S $P(^FHING(K,0),"^",21)="" Q
	.Q:'$D(^TMP($J,"FHPROD",Y))
	.S $P(^FHING(K,0),"^",21)="" Q
	W !!,"Checking Recipe Default Nut in 114 ..."
	F L=0:0 S L=$O(^FH(114,L)) Q:L<1  F K=0:0 S K=$O(^FH(114,L,"I",K)) Q:K<1  S Y=+$P(^(K,0),"^",3) I Y D
	.I '$D(^FHNU(Y)) S $P(^FH(114,L,"I",K,0),"^",3)="" Q
	.Q:'$D(^TMP($J,"FHPROD",Y))
	.S $P(^FH(114,L,"I",K,0),"^",3)="" Q
	W !!,"Checking User Menu 112.6 ..."
	F L=0:0 S L=$O(^FHUM(L)) Q:L<1  F M=0:0 S M=$O(^FHUM(L,1,M)) Q:M<1  F N=0:0 S N=$O(^FHUM(L,1,M,1,N)) Q:N<1  F K=0:0 S K=$O(^FHUM(L,1,M,1,N,1,K)) Q:K<1  S Y=+^(K,0) I Y D
	.I '$D(^FHNU(Y)) S ^TMP($J,"FHITEM",L,M,N,K)="" Q
	.Q:'$D(^TMP($J,"FHPROD",Y))
	.S ^TMP($J,"FHITEM",L,M,N,K)="" Q
	F L=0:0 S L=$O(^TMP($J,"FHITEM",L)) Q:L<1  F M=0:0 S M=$O(^TMP($J,"FHITEM",L,M)) Q:M<1  F N=0:0 S N=$O(^TMP($J,"FHITEM",L,M,N)) Q:N<1  F K=0:0 S K=$O(^TMP($J,"FHITEM",L,M,N,K)) Q:K<1  D
	.K ^FHUM(L,1,M,1,N,1,K,0)
	.S $P(^FHUM(L,1,M,1,N,1,0),"^",4)=$P(^FHUM(L,1,M,1,N,1,0),"^",4)-1 Q
REMV	; Remove American Diet Product entries
	W !,"Remove American Diet Products From Food Nutrient File ..."
	K DA,DIK F K=0:0 S K=$O(^TMP($J,"FHPROD",K)) Q:K<1  D
	.S DA=K I DA S DIK="^FHNU(" D ^DIK
	.Q
	K ^TMP($J,"FHITEM"),^TMP($J,"FHPROD"),DA,DIK,K,KL,L,M,N,X,Y Q
