FHIPST2	; HISC/REL - Move Room-Beds to Wards ;5/14/92  13:58
	;;5.0;Dietetics;;Oct 11, 1995
	Q:$D(^FH(119.6,"AR"))
	W !!,"Insert Ward names in File 119.6 ..."
	F KK=0:0 S KK=$O(^DIC(42,KK)) Q:KK<1  S X=$P($G(^(KK,0)),"^",1) D WRD
	W !!,"Move Room-Beds to Dietetic Wards ..."
	F KK=0:0 S KK=$O(^DG(405.4,KK)) Q:KK<1  I '$D(^FH(119.6,"AR",KK)) D SET
	Q
WRD	K ^FH(119.6,"B",KK) I '$G(^DIC(42,KK,"ORDER")) K ^FH(119.6,KK) Q
	S $P(^FH(119.6,KK,0),"^",1)=X S ^FH(119.6,"B",X,KK)=""
	S ^FH(119.6,KK,"W",0)="^119.63P^1^1",^FH(119.6,KK,"W",1,0)=KK,^FH(119.6,KK,"W","B",KK,1)="",^FH(119.6,"AW",KK,KK,1)=""
	Q
SET	F WRD=0:0 S WRD=$O(^DG(405.4,KK,"W",WRD)) Q:WRD<1  I $G(^DIC(42,WRD,"ORDER")) G S1
	W !?5,"No Active Ward found for ",$P(^DG(405.4,KK,0),"^",1)," in Room-Bed File (405.4)" Q
S1	I '$D(^FH(119.6,WRD,"R",0)) S ^(0)="^119.62P^^"
	S NX=$P(^FH(119.6,WRD,"R",0),"^",3)+1,$P(^(0),"^",3,4)=NX_"^"_NX
	S ^FH(119.6,WRD,"R",NX,0)=KK,^FH(119.6,WRD,"R","B",KK,NX)=""
	S ^FH(119.6,"AR",KK,WRD,NX)="" Q
