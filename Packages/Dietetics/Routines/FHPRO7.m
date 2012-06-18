FHPRO7 ; HISC/REL - Print Recipes ;3/26/96  15:14
 ;;5.0;Dietetics;**2**;Mar 25, 1996
 K N,R S K4="" F P0=0:0 S K4=$O(^TMP($J,"T",K4)) Q:K4=""  F L1=0:0 S L1=$O(^TMP($J,"T",K4,L1)) Q:L1<1  D C0
R0 F K1=0:0 S K1=$O(N(K1)) Q:K1<1  K N(K1) D R1
 G:$O(N(""))'="" R0
 F R1=0:0 S R1=$O(R(R1)) Q:R1=""  I $G(^FH(114,R1,0))'="" D:$P(^FH(114,R1,0),"^",8)'="N" R3
 S NX="" F KK=0:0 S NX=$O(^TMP($J,"R",NX)) Q:NX=""  F R1=0:0 S R1=$O(^TMP($J,"R",NX,R1)) Q:R1<1  S S1=R(R1) D EN1^FHREC2
 Q
R1 F KK=0:0 S KK=$O(^FH(114,K1,"R",KK)) Q:KK<1  S Y=^(KK,0) D R2
 Q
R2 S P1=R(K1),MUL=$P(^FH(114,K1,0),"^",2) Q:'MUL  S MUL=P1/MUL
 S P1=$P(Y,"^",2)*MUL S:'$D(R(+Y)) R(+Y)=0 S R(+Y)=R(+Y)+P1 Q
R3 S X=$G(^FH(114,R1,0)),K4=$P(X,"^",12),K4=$S($D(^FH(114.2,+K4,0)):$P(^(0),"^",3),1:99)
 S K4="A"_$S(K4<10:"0"_K4,1:K4)_$E($P(X,"^",1),1,27),^TMP($J,"R",K4,R1)="" Q
C0 S:'$D(R(L1)) R(L1)=0 S R(L1)=R(L1)+^TMP($J,"T",K4,L1),N(L1)="" Q
