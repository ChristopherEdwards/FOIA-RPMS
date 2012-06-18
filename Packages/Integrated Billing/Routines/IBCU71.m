IBCU71	;ALB/AAS - INTERCEPT SCREEN INPUT OF PROCEDURE CODES ; 29-OCT-91
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
	;MAP TO DGCRU71
	;
ADDCPT	;  - store cpt codes in scheduling visits file
	Q:$D(DGCPT)'>9
	N DA,DIC,DR,DIE
	S DIR(0)="Y",DIR("A")="OK to add CPT codes to Scheduling Visits file",DIR("B")="Y" D ^DIR K DIR Q:'Y!$D(DIRUT)
	K SDCPT
	S SDATE=DGPROCDT,SDIV=+$$SITE^VASITE,SDC=900,SDCTYPE="C",SDMSG="B"
	W !!,"Adding Procedures to Scheduling Visits file."
	S CNT=0 S I=0 F  S I=$O(DGCPT(I)) Q:'I  S J=0 F K=1:1 S J=$O(DGCPT(I,J)) Q:'J  F L=0:0 S L=$O(DGCPT(I,J,L)) Q:'L  S:K>5 K=1 S:K=1 CNT=CNT+1,SDCPT(CNT)="900^"_I_"^" S SDCPT(CNT)=SDCPT(CNT)_J_"^" W "."
	I $D(SDCPT) D EN3^SDACS W "..Done.",!
	K SDCPT,SDATE,SDIV,DGCPT,SDC,SDCTYPE,SDMSG
	Q
	;
DISPDX	;  - display diagnosis codes available for associated dx (HCFA 1500)  NO LONGER USED?
	N I,J,X,IBDX,IBDXL
	F I=1:1:4 S IBDX=$P($G(^DGCR(399,IBIFN,"C")),"^",(I+13)),X=$G(^ICD9(+IBDX,0)) I X'="" S IBDXL(I)=IBDX_"^"_X
	I '$D(IBDXL) W !!,"Bill has no ICD DIAGNOSIS." Q
	W !!,?24,"<<<ASSOCIATED ICD-9 DIAGNOSIS>>>",!!
	F I=1,2 W ! S X=0 F J=0,2 I $D(IBDXL(I+J)) S IBDX=IBDXL(I+J) D  S X=40
	. W ?X,"    ",$P(IBDX,"^",2),?(X+13),$E($P(IBDX,"^",4),1,28)
	W !
	Q
	;
SCREEN(X,Y)	; -- screen logic for active procs or surgeries
	; -- input x = date to check
	;          y = procedure
	;
	; -- output 0 if not active for billing or amb proc on date
	;           1 if either active
	;
	I '$D(X)!('$D(Y)) Q 0
	I $D(^SD(409.72,+$O(^(+$O(^SD(409.72,"AIVDT",Y,(9999998-$P(X,".")))),0)),0)),$P(^(0),U,5) Q 1
	I $D(^IBE(350.4,+$O(^(+$O(^IBE(350.4,"AIVDT",Y,-($P(X,".")))),0)),0)),$P(^(0),U,4) Q 1
	Q 0
