FHNO8	; HISC/REL - History of Supp. Fdgs. ;5/17/93  14:24 
	;;5.0;Dietetics;;Oct 11, 1995
	S ALL=1 D ^FHDPA G:'DFN KIL
	I $O(^FHPT(DFN,"A",0))<1 W !!,"NO ADMISSIONS ON FILE!" G FHNO8
	S DIC="^FHPT(DFN,""A"",",DIC(0)="Q",DA=DFN,X="??" D ^DIC
A0	W !!,"Select ADMISSION",$S($D(^DPT(DFN,.1)):" (or C for CURRENT)",1:""),": " R X:DTIME G:'$T!("^"[X) KIL D:X="c" TR^FH
	I X="C" D ADM G P0:ADM'<1,FHNO8
	S DIC="^FHPT(DFN,""A"",",DIC(0)="EQM" D ^DIC G:Y<1 A0 S ADM=+Y
P0	S (N1,LST)=0 F K=0:0 S K=$O(^FHPT(DFN,"A",ADM,"SF",K)) Q:K<1  S X=^(K,0),LST=K D LIS
	I 'N1 W !!,"No Supplemental Feedings for this Admission!" G FHNO8
P1	R !!,"Detailed Display of which Order #? ",X:DTIME G:'$T!("^"[X) FHNO8 I X'?1N.N!(X<1)!(X>LST) W *7," Enter # of Order to List" G P1
	S NO=+X,Y=$G(^FHPT(DFN,"A",ADM,"SF",NO,0)) D L1^FHNO7
	G FHNO8
ADM	S WARD=$G(^DPT(DFN,.1))
	I WARD="" W *7,!!,"NOT CURRENTLY AN INPATIENT!",! S ADM="" Q
	S ADM=$G(^DPT("CN",WARD,DFN)) Q
LIS	I 'N1 W !!,"Ord  Date/Time Ordered  Supplemental Feeding Menu    Date/Time Cancelled",!
	S N1=N1+1,D1=$P(X,"^",2),NM=$P(X,"^",4),D2=$P(X,"^",32)
	S DTP=D1 D DTP^FH W !,$J(K,3),"  ",DTP
	S X=$P($G(^FH(118.1,+NM,0)),"^",1) W:X'="" ?24,X
	I D2 S DTP=D2 D DTP^FH W ?54,DTP
	Q
KIL	G KILL^XUSCLEAN
