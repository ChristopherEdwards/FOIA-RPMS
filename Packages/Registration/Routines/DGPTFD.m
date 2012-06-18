DGPTFD ;ALB/MTC - Sets Required Variables for DRG on 701 Screen ; 2/19/02 12:52pm
 ;;5.3;Registration;**60,441**;Aug 13, 1993
 ;
EN1 ;-- entry point from 701
 Q:'$D(^DGPT(PTF,70))  S DGPT(70)=^(70)
 ;
 ;-- check for DXLS
 I $P(DGPT(70),U,10)="",$P(DGPT(70),U,11)="" G Q
 ;-- did patient die during care
 S DGEXP=$S($P(DGPT(70),U,3)>5:1,1:0)
 ;-- discharged against med advice
 S DGDMS=$S($P(DGPT(70),U,3)=4:1,1:0)
 ;-- transfer to acute care facility
 S DGTRS=$S($P(DGPT(70),U,13):1,1:0)
 ;-- sex,age
 S SEX=$P(^DPT(DFN,0),U,2),AGE=$S(+DGPT(70):+DGPT(70),1:DT)-$P(^(0),U,3)\10000,DOB=$P(^(0),U,3) ; DOB added by abr for ICD calc.
 ;-- build diagnosis string
 S DGDX=""
 ;-- new record after 10/1/86
 I '+DGPT(70)!(+DGPT(70)>2861000) F DGI=16:1:24 I $P(DGPT(70),U,DGI)]"",$D(^ICD9($P(DGPT(70),U,DGI),0)) S DGDX=DGDX_U_$P(DGPT(70),U,DGI)
 ;-- old record format
 I +DGPT(70),+DGPT(70)<2861000 F DGI=0:0 S DGI=$O(^DGPT(PTF,"M","AM",DGI)) Q:DGI'>0  S DGJ=$O(^DGPT(PTF,"M","AM",DGI,0)) I $D(^DGPT(PTF,"M",+DGJ,0)) S DGNODE=$P(^(0),U,5,9) I DGNODE'="^^^^" D OLD
 S DGDX=$S($P(DGPT(70),U,10):$P(DGPT(70),"^",10),1:$P(DGPT(70),U,11))_DGDX
 ;-- build surgery and procedure strings
 K DGSURG,DGPROC
 ;-- start with surgeries (401)
 F DGI=0:0 S DGI=$O(^DGPT(PTF,"S",DGI)) Q:DGI'>0  S X=$P(^(DGI,0),U,8,12) I X]"",X'="^^^^" S K=+^(0),K=$S('$D(DGSURG(K)):K,K[".":K_DGI_1,1:K_".0000"_DGI_1),DGSURG(K)="" S DGVAR=0 D TAG
 ;-- build DGSURG
 N I,X,Y,Z ; eliminate duplicates as we go 
 I $D(DGSURG) S DGSURG=U F DGI=0:0 S DGI=$O(DGSURG(DGI)) Q:DGI'>0  D
 .S X=DGSURG(DGI)
 .F I=1:1:5 S Y=$P(X,U,I) Q:Y=""  D
 ..Q:$L(DGSURG)>240
 ..S Z=U_Y_U Q:DGSURG[Z
 ..S DGSURG=DGSURG_Y_U
 ;-- procedures next old records before 10/1/87
 I +DGPT(70),+DGPT(70)<2871000 G DRG:'$D(^DGPT(PTF,"401P")) S DGPROC="",X=^("401P") X:X]""&(X'="^^^^") "F DGI=1:1:5 I $P(X,""^"",DGI)]"""",$D(^ICD0($P(X,""^"",DGI),0)) S DGPROC=DGPROC_$P(X,""^"",DGI)_""^""" G DRG
 ;-- get procedures (601)
 F DGI=0:0 S DGI=$O(^DGPT(PTF,"P",DGI)) Q:DGI'>0  S X=$P(^(DGI,0),U,5,9) I X]"",X'="^^^^" S K=+^(0),K=$S('$D(DGPROC(K)):K,K[".":K_DGI_1,1:K_".0000"_DGI_1),DGPROC(K)="" S DGVAR=1 D TAG
 ;-- build DGPROC and eliminate duplicates as we go
 I $D(DGPROC) S DGPROC=U F DGI=0:0 S DGI=$O(DGPROC(DGI)) Q:DGI'>0  D
 .S X=DGPROC(DGI)
 .F I=1:1:5 S Y=$P(X,U,I) Q:Y=""  D
 ..Q:$L(DGPROC)>240
 ..S Z=U_Y_U Q:DGPROC[Z
 ..S DGPROC=DGPROC_Y_U
DRG ;
 S:'$D(DGCPT) DGDRGPRT=1 D ^DGPTICD
 ;
Q K AGE,SEX,DGEXP,DGDMS,DGPT,DGTRS,DGDX,DGNODE,DGPROC,DGSURG,DGDRGPRT,DGI,DGJ,K,DOB Q
 ;
OLD ;-- used to format diagnostic codes for old PTF records
 S X="" F DGJ=1:1:5 I $P(DGNODE,"^",DGJ)]"",$D(^ICD9($P(DGNODE,"^",DGJ),0)) S X=X_"^"_$P(DGNODE,"^",DGJ)
 S DGDX=X_$P(DGDX,"^",1,40)
 Q
TAG ;-- used to build sur/proc string date
 F DGJ=1:1:5 I $P(X,U,DGJ)]"",$D(^ICD0($P(X,U,DGJ),0)) S:DGVAR=0 DGSURG(K)=DGSURG(K)_$P(X,U,DGJ)_U S:DGVAR=1 DGPROC(K)=DGPROC(K)_$P(X,U,DGJ)_U
 Q
