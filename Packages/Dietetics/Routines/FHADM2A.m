FHADM2A	; HISC/REL/NCA - Calculate NPO/Trays for Served Meals ;6/18/93  14:03
	;;5.0;Dietetics;;Oct 11, 1995
EN1	; Calculate NPO/Trays
	D NOW^%DTC S NOW=%,DT=NOW\1,(TP,TC,TE,N,R)=0 F K=1:1:5 S S(K)=0
	F WRD=0:0 S WRD=$O(^FH(119.6,WRD)) Q:WRD'>0  F DFN=0:0 S DFN=$O(^FHPT("AW",WRD,DFN)) Q:DFN=""  S ADM=^(DFN) D CNT
	I '$D(^FH(117,DT,0)) S ^FH(117,DT,0)=DT,^FH(117,"B",DT,DT)="",X0=^FH(117,0),$P(^FH(117,0),"^",3,4)=DT_"^"_($P(X0,"^",4)+1)
	S MD=N-R
	S $P(^FH(117,DT,1),"^",19,27)=(3*TC)_"^"_(TP-TE*3)_"^"_S(1)_"^"_S(2)_"^"_S(3)_"^"_S(4)_"^"_S(5)_"^"_MD_"^"_N
	K %,%H,%I,A1,ADM,DFN,FHORD,K,MD,N,NOW,R,S,TC,TE,TP,TYP,WRD,X0,X1,Y0,ZZ Q
CNT	Q:'ADM  S TP=TP+1 Q:'$D(^FHPT(DFN,"A",ADM,0))
	S X5=$O(^FHPT(DFN,"S",0)) I X5 S X5=$G(^(X5,0))
	I  I $P(X5,"^",1)<$P($G(^FHPT(DFN,"A",ADM,0)),"^",1) S X5=5,S(X5)=S(X5)+1 G C1
	S X5=$P(X5,"^",2) S:X5=""!(X5>4) X5=5 S S(X5)=S(X5)+1
C1	S X0=^FHPT(DFN,"A",ADM,0)
	S FHORD=$P(X0,"^",2),X1=$P(X0,"^",3),ZZ=$P(X0,"^",5) Q:'FHORD
	S Y0=$G(^FHPT(DFN,"A",ADM,"DI",FHORD,0)) Q:Y0=""
	S FHOR=$P(Y0,"^",2,6),FHLD=$P(Y0,"^",7)
	I FHLD'="" Q:ZZ=""  S N=N+1 Q
	S Z=$P(Y0,"^",13) Q:Z=""  S TE=TE+1,TYP=$P(Y0,"^",8) S:TYP="C" TC=TC+1 S N=N+1
	I "1^^^^"[FHOR S R=R+1
	Q
