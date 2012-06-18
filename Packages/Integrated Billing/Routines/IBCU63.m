IBCU63	;ALB/AAS - BILLING UTILITY TO SET AMB SURG REV CODES ; 20-NOV-91
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
	;MAP TO DGCRU63
%	; BASC
	Q:IBIDS(.11)'="i"
	K ^UTILITY($J,"IB-ASC")
	S DGRVCOD=$S($P($G(DGINPAR),"^",4):$P(DGINPAR,"^",4),$P($G(^IBE(350.9,1,1)),"^",18):$P(^(1),"^",18),1:"") Q:DGRVCOD=""
	;
BLD	S DGASC=0 F  S DGASC=$O(^DGCR(399,IBIFN,"CP","ASC",1,DGASC)) Q:'DGASC  S DGPROC=$G(^DGCR(399,IBIFN,"CP",DGASC,0)) I DGPROC D
	.S DGDIV=$P(DGPROC,"^",6),DGDAT=$P(DGPROC,"^",2)
	.Q:'DGDIV
	.Q:DGDAT+.9<$$STDATE
	.S:'$D(^UTILITY($J,"IB-ASC",+DGPROC,+DGDAT,+DGDIV)) ^(+DGDIV)=0
	.S ^(+DGDIV)=^UTILITY($J,"IB-ASC",+DGPROC,+DGDAT,+DGDIV)+1
	;
STORREV	;build revenue codes in bill
	I '$D(^DGCR(399,IBIFN,"RC",0)) S ^DGCR(399,IBIFN,"RC",0)="^399.042PA"
	S DGPROC=0 F  S DGPROC=$O(^UTILITY($J,"IB-ASC",DGPROC)) Q:'DGPROC  S DGDAT=0 F  S DGDAT=$O(^UTILITY($J,"IB-ASC",DGPROC,DGDAT)) Q:'DGDAT  S DGDIV=0 F  S DGDIV=$O(^UTILITY($J,"IB-ASC",DGPROC,DGDAT,DGDIV)) Q:'DGDIV  S DGBSLOS=^(DGDIV) D
	.S X=DGDAT_"^"_DGDIV_"^"_DGPROC D ^IBAUTL1 S DGAMNT=Y Q:Y<1
	.S X=DGRVCOD,DGBSI=$O(^DGCR(399.1,"B",DGBILLBS,0))
	.D FILE
	.Q
	K DGDAT,DGPROC,DGDIV,DGRVCOD,DGASC
	Q
	;
FILE	;
	S DA(1)=IBIFN
	D FILE^IBCU62
	W:'$G(IBAUTO) !,"Adding",?12,$E(00_DGRVCOD,($L(DGRVCOD)-1),($L(DGRVCOD)+1)),?24,DGBSLOS,?31,"$",$J(DGAMNT,8,2),?44,DGBILLBS,?65,$P($G(^ICPT(+$G(DGPROC),0)),"^")
	Q
	;
STDATE()	;  -start date for basc billing
	Q $S($P($G(^IBE(350.9,1,1)),"^",24):$P(^(1),"^",24),1:9999999)
	;
RX	;add rx refill charges (adds default rx cpt for hcfa 1500)
	;tries to use ins rx rev code, then site rx rev code finally standard revcode all with $20
	I '$D(^DGCR(399,IBIFN,"RC",0)) S ^DGCR(399,IBIFN,"RC",0)="^399.042PA"
	S DGBSLOS=IBCNT
	S DGBS="PRESCRIPTION",DGBSI=$O(^DGCR(399.1,"B",DGBS,0)) Q:'DGBSI
	I $$FT^IBCU3(IBIFN)=2 S DGPROC=$P($G(^IBE(350.9,1,1)),"^",30),DGDIV=""
	S DGRVCOD=$P($G(DGINPAR),"^",10) ; ins rev cd
	I DGRVCOD="" S DGRVCOD=$P($G(^IBE(350.9,1,1)),"^",28) ; site rev cd
	I DGRVCOD="" D SETREV^IBCU62 G END ; standard rev cd
	S DGAMNT=20,X=DGRVCOD
	D FILE
END	K DGPROC,DGDIV,DGRVCOD
	Q
	;MAP TO DGCRU61
	;
ALL	;delete all revenue codes that may have been set up automatically
	;ie = $d(^IB(399.5,"d",code ifn))
	K DA S DA(1)=IBIFN,DA=0 I '$G(IBAUTO) W !,"Removing old Revenue Codes."
	F DGII=0:0 S DA=$O(^DGCR(399,IBIFN,"RC",DA)) Q:DA<1  S X=$G(^DGCR(399,IBIFN,"RC",DA,0)) D
	. ;remove revenue codes pre-defined for automatic use AND revenue codes for BASC charges (are automatically created)
	. W:'$G(IBAUTO) "." D DEL
	Q
DEL	S DIK="^DGCR(399,"_DA(1)_",""RC""," D ^DIK L ^DGCR(399,IBIFN):1
	Q
