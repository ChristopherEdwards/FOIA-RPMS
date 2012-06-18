FHIPST18	; HISC/NCA - Update for Recipe Category ;5/2/95  09:29
	;;5.0;Dietetics;;Oct 11, 1995
MAT	; Get Updated Recipe Category and match entries
	W !!,"Updating Recipe Category File with code for tray tickets ..."
	K ^TMP($J,"FHREC") S CTR=1 S ROU="^FHIPST19" D @ROU
	F K=0:0 S K=$O(^TMP($J,"FHREC",K)) Q:K<1  S Z1=$G(^(K)),NAM=$P(Z1,"^",1) D M1
	K ^FH(114.1,"B"),^FH(114.1,"C")
	K DIK S DIK="^FH(114.1," D IXALL^DIK K DIK
KIL	K ^TMP($J,"FHREC"),A,A1,A2,CTR,I,K,L,L1,NAM,ROU,Z1,Z2 Q
M1	S Z2=$E(NAM,1,15) S L1=0 S L1=$O(^FH(114.1,"B",Z2,L1)) Q:L1<1
	I $P(^FH(114.1,L1,0),"^",1)=NAM S A1=$P(Z1,"^",2) I A1'="" S:$P($G(^FH(114.1,L1,0)),"^",2)'?1U.1U1N.1"X" $P(^FH(114.1,L1,0),"^",2)=A1
	Q
