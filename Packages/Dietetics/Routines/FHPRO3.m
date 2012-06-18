FHPRO3	; HISC/REL - Recipe Calculations ;4/14/95  08:05
	;;5.0;Dietetics;;Oct 11, 1995
	K ^TMP($J,"T"),P,T
	F L1=0:0 S L1=$O(^FH(116.2,L1)) Q:L1<1  S Z=$P($G(^(L1,0)),"^",2) I Z'="" S P(Z)=L1
	F P0=0:0 S P0=$O(^TMP($J,P0)) Q:P0<1  S Z=$P($G(^FH(119.72,P0,0)),"^",2) I Z'="" S T(P0)=Z
	D P1 G ^FHPRO4
P1	F M=0:0 S M=$O(^FH(116.1,FHX1,"RE",M)) Q:M<1  S L1=^(M,0),L1=+L1 D P2
	K M,P,T,Y,Z,Z1 Q
P2	S N1=0,X=$G(^FH(114,L1,0)),K4=$P(X,"^",12),K4=$S($D(^FH(114.2,+K4,0)):$P(^(0),"^",3),1:99)
	S MCA=$O(^FH(116.1,FHX1,"RE",M,"R",0)),LL=$S(MCA:+$G(^FH(116.1,FHX1,"RE",M,"R",MCA,0)),1:99)
	S FHPD=$P(LL,"^",2),LL=+LL
	S LL=$S($D(^FH(114.1,+LL,0)):$P(^(0),"^",3),1:99)
	S K4=$S(K4<1:99,K4<10:"0"_K4,1:K4)_$S(LL<1:99,LL<10:"0"_LL,1:LL)_$E($P(X,"^",1),1,26)
	F P0=0:0 S P0=$O(^TMP($J,P0)) Q:P0<1  D R1 I N2 S ^TMP($J,"T",K4,L1,P0)=N2
	Q:'N1  S:'$G(^TMP($J,"T",K4,L1)) ^TMP($J,"T",K4,L1)=0 S ^(L1)=^(L1)+N1
	Q
R1	S Z1=$P($G(^FH(116.1,FHX1,"RE",M,"D",P0,0)),"^",2),N2=0
	F CAT=0:0 S CAT=$O(^FH(116.1,FHX1,"RE",M,"R",CAT)) Q:CAT<1  S FHPD=$P($G(^(CAT,0)),"^",2) D
	.F LL=1:1 S FHX2=$P(FHPD," ",LL) Q:FHX2=""  S X=$P(FHX2,";",1) I X'="",$D(P(X)) D P3
	.Q
	Q
P3	S X1=$G(^TMP($J,P0,P(X))) Q:'X1
	S Y=$P(FHX2,";",2) I Y="" S:Z1'="" X1=$J(Z1*X1/100,0,0) G P4
	D P5 S Y=$P(FHX2,";",3) D:Y'="" P5
P4	S N1=N1+X1,N2=N2+X1 S:X1 ^TMP($J,"T",K4,L1,P0)=X1 Q
P5	S:$E(Y,1)=T(P0) X1=$J($E(Y,2,99)*X1/100,0,0) Q
