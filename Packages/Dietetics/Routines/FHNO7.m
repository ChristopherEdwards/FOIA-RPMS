FHNO7	; HISC/REL - List Supplemental Fdgs. ;12/15/94  09:14 
	;;5.0;Dietetics;;Oct 11, 1995
LIS	; Display Feeding
	S NAM=$P(^DPT(DFN,0),"^",1) D CUR^FHORD7
	W:$E(IOST,1,2)="C-" @IOF W !!,NAM,"  " W:WARD'="" "( ",WARD," )"
	W !!,"Current Diet: ",$S(Y'="":Y,1:"No current order")
	S NO=$P(^FHPT(DFN,"A",ADM,0),"^",7),Y=$S('NO:"",1:$G(^FHPT(DFN,"A",ADM,"SF",NO,0)))
L1	; Display SF Order
	S NM=$P(Y,"^",4) W !!,"Feeding Menu: ",$S('NM:"None",1:$P(^FH(118.1,NM,0),"^",1)) Q:'NO  S DTP=$P(Y,"^",30) D DTP^FH W ?50,"Reviewed: ",DTP
	W !!,"10AM",?26,"2PM",?52,"8PM",!,"-----------------------   -----------------------   -----------------------"
	K N F K1=1:1:3 F K2=1:1:4 S N(K1,K2)=""
	S L=4 F K1=1:1:3 S K=0 F K2=1:1:4 S Z=$P(Y,"^",L+1),Q=$P(Y,"^",L+2),L=L+2 I Z'="" S:'Q Q=1 S K=K+1,N(K1,K)=$J(Q,2)_" "_$P($G(^FH(118,Z,0)),"^",1)
	F K2=1:1:4 W !,N(1,K2),?26,N(2,K2),?52,N(3,K2)
	W:$P(Y,"^",34)'="" !!,"Diet Pattern Associated: ",$S($P(Y,"^",34)="Y":"YES",1:"NO")
	Q
EN2	; Supplemental Feeding Inquiry
	S ALL=0 D ^FHDPA G:'DFN KIL D LIS G EN2
KIL	G KILL^XUSCLEAN
