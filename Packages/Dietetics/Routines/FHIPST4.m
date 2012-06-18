FHIPST4	; HISC/REL - Convert Meals ;12/3/91  14:56
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'$D(^FH(119.7))
	W !!,"Converting Meals ..."
	K DP F P0=0:0 S P0=$O(^FH(119.7,P0)) Q:P0<1  S DP(P0)=$G(^(P0,4))
	F KK=.9:0 S KK=$O(^FH(116.1,KK)) Q:KK<1  F M=0:0 S M=$O(^FH(116.1,KK,"RE",M)) Q:M<1  I $O(^FH(116.1,KK,"RE",M,"D",0))>0 D P1
	S DIU="^FH(119.7,",DIU(0)="DS" D EN^DIU2 Q
P1	K D,P F P0=0:0 S P0=$O(^FH(116.1,KK,"RE",M,"D",P0)) Q:P0<1  S D(P0)=$G(^(P0,0)) D P2
	K ^FH(116.1,KK,"RE",M,"D") S Z1=0,ZT=0
	F P0=0:0 S P0=$O(P(P0)) Q:P0=""  S ^FH(116.1,KK,"RE",M,"D",P0,0)=P(P0),^FH(116.1,KK,"RE",M,"D","B",P0,P0)="",Z1=Z1+1,ZT=P0
	S ^FH(116.1,KK,"RE",M,"D",0)="^116.112PA^"_ZT_"^"_Z1
	Q
P2	S ZT=$P(D(P0),"^",2) I ZT'="" S Z1=$P(DP(P0),"^",1) S:Z1 P(Z1)=Z1_"^"_ZT
	S ZC=$P(D(P0),"^",3) I ZC'="" S Z1=$P(DP(P0),"^",2) S:Z1 P(Z1)=Z1_"^"_ZC
	S Z1=$P(DP(P0),"^",3) I Z1 S ZT=$S($P(DP(P0),"^",4)="T":ZT,1:ZC) S:ZT'="" P(Z1)=Z1_"^"_ZT
	Q
