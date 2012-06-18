FHIPST8	; HISC/NCA - Main Routine For Ingredient Match ;4/11/94  13:55
	;;5.0;Dietetics;;Oct 11, 1995
MAT	; Get Updated Ingredient List and Match Entries
	W !!,"Updating Ingredient File with Nutrient Pointers ..."
	K ^TMP($J,"FHING") S CTR=1 F L=9:1:16 S ROU="^FHIPST"_L D @ROU
	F K=0:0 S K=$O(^TMP($J,"FHING",K)) Q:K<1  S Z1=$G(^(K)),NAM=$P(Z1,"^",1) D M1
KIL	K ^TMP($J,"FHING"),A,A1,A2,CTR,I,K,L,L1,NAM,ROU,Z1,Z2 Q
M1	S Z2=$E(NAM,1,30) F L1=0:0 S L1=$O(^FHING("B",Z2,L1)) Q:L1<1  I $P(^FHING(L1,0),"^",1)=NAM G M2
	Q
M2	S A1=$P(Z1,"^",2),A2=$P(Z1,"^",3)
	I A1 S:$P($G(^FHING(L1,0)),"^",21)="" $P(^FHING(L1,0),"^",21)=A1
	I A2 S:$P($G(^FHING(L1,0)),"^",22)="" $P(^FHING(L1,0),"^",22)=A2
	Q
