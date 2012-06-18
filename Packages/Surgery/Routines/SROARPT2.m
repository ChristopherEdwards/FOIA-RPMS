SROARPT2 ;B'HAM ISC/MAM - ANESTHESIA REPORT (CONT); 01/21/88 7:24
 ;;3.0; Surgery ;;24 Jun 93
 S Z(3)=$S($D(^SRF(SRTN,6,V,3)):^(3),1:"")
 S DURAL=$P(Z(3),"^",4) W:DURAL'="" !,"Dural Puncture: "_$S(DURAL="N":"NO",1:"YES") I $P(Z(3),"^",5) S USER=$P(Z(3),"^",5) D N W:DURAL'="" ?40,"Catheter Removed By: "_USER W:DURAL="" !,"Catheter Removed By: "_USER
 I $P(S(8),"^",4) W !,"Date/Time Catheter Removed: " S Y=$P(S(8),"^",4) D D^DIQ W Y
 I $O(^SRF(SRTN,6,V,5,0)) S BB=0 F I=0:0 S BB=$O(^SRF(SRTN,6,V,5,BB)) Q:'BB  S BB(0)=^SRF(SRTN,6,V,5,BB,0),SITE=$P(BB(0),"^",1),NLENGTH=$P(BB(0),"^",2),NGAUGE=$P(BB(0),"^",3) D BLOCK
 Q
S Q:Q(7)=""  S Z1=$P(Q(3),"^",3) F X1=1:1 Q:Q(7)=$P($P(Z1,";",X1),":",1)  Q:X1=50
 Q:X1=50  S Q(7)=$P($P(Z1,";",X1),":",2) Q
 Q
N S:'$D(USER) USER="" S USER=$S(USER="":USER,$D(^VA(200,USER,0)):$P(^(0),"^",1),1:USER)
 Q
BLOCK S SITE=$P(^LAB(61,SITE,0),"^") W !,"Block Site: "_SITE_"   Needle Length: "_NLENGTH_"   Needle Gauge: "_NGAUGE
 Q
