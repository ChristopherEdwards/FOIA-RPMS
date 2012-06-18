FHWTRN	; HISC/REL - Process Transfers ;3/17/92  14:39
	;;5.0;Dietetics;;Oct 11, 1995
	I FHOLD="" G T0
	; Edit,Delete Transfers
	I $P(FHOLD,"^",18)=$P(FHNEW,"^",18) G EX
	S XT=$P(FHOLD,"^",18)
	I "^1^2^3^"[("^"_XT_"^") D RET
	I "^22^23^24^"[("^"_XT_"^") D PASS
T0	S XT=$P(FHNEW,"^",18)
	I "^1^2^3^"[("^"_XT_"^") D PASS
	I "^22^23^24^"[("^"_XT_"^") D RET
EX	D WRD^FHWADM G KIL
PASS	; Place on Pass
	D SET Q:FHLD="P"  Q:'$D(^FHPT(DFN,"A",ADM))
	S FHOR="^^^^",FHLD="P",TYP="",D1=X1,D2="",D4=0,COM="" D STR^FHORD7 Q
RET	; Remove from Pass
	D SET I FHLD'="P",FHLD'="X" Q
	S X=^FHPT(DFN,"A",ADM,"DI",FHORD,0),D1=$P(X,"^",9),D2=$S(D1'>X1:X1,1:D1)
	S $P(^FHPT(DFN,"A",ADM,"DI",FHORD,0),"^",10)=D2
	S A2=0 F KK=0:0 S KK=$O(^FHPT(DFN,"A",ADM,"AC",KK)) Q:KK<1!(KK>X1)  S A2=KK
	Q:'A2  Q:$P(^FHPT(DFN,"A",ADM,"AC",A2,0),"^",2)'=FHORD
	F K9=A2-.000001:0 S K9=$O(^FHPT(DFN,"A",ADM,"AC",K9)) Q:K9<1  I $P(^(K9,0),"^",2)=FHORD S D1=K9 D S0^FHORD3
	D UPD^FHORD7 Q
SET	D NOW^%DTC S NOW=%,DT=%\1,FHPV=DUZ,FHWF=$S($D(^ORD(101)):1,1:0)
	S X=$P($G(^DGPM(ADM,0)),"^",1),X1=$S(X'>NOW:NOW,1:X)
	S A1=0,(FHOR,FHLD)="" F KK=0:0 S KK=$O(^FHPT(DFN,"A",ADM,"AC",KK)) Q:KK<1!(KK>X1)  S A1=KK
	Q:'A1  S FHORD=$P(^FHPT(DFN,"A",ADM,"AC",A1,0),"^",2),X=^FHPT(DFN,"A",ADM,"DI",FHORD,0),FHOR=$P(X,"^",2,6),FHLD=$P(X,"^",7) Q
KIL	K %,%DT,A1,A2,COM,D1,D2,D4,FHDU,FHLD,FHOR,FHPV,FHX1,FHX2,FHX3,K,K9,KK,NOW,FHORD,TYP,X,X1,X2,X9 Q
