FHCMS1	; HISC/NCA - Calculate Meals ;3/22/93  12:28
	;;5.0;Dietetics;;Oct 11, 1995
	S FHTOT=0 F LL=SDT:0 S LL=$O(^FH(117,LL)) Q:LL<1!($E(LL,1,5)>$E(EDT,1,5))  D N1
	Q
N1	S Y0=$G(^FH(117,LL,0)) Q:Y0=""  S Y1=$G(^FH(117,LL,1))
	S K=1 F L=1,2,4,5,7,8 S K=K+1,N(L)=$P(Y0,"^",K)
	S K=10 F L=1:3:16 S K=K+1,N(K)=$P(Y1,"^",L)+$P(Y1,"^",L+1)+$P(Y1,"^",L+2)
	S N(3)=N(1)-N(2)*3,N(6)=N(4)-N(5)*3,N(9)=N(7)-N(8)*3
	S N(10)=N(3)+N(6)+N(9)
	S N(16)=N(14)+N(15)+N(16),N(13)=N(12)+N(13),N(17)=N(11)+N(13)+N(16),N(18)=N(10)+N(17)
	S FHTOT=FHTOT+N(18) Q
