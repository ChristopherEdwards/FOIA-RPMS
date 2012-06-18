IBCB	;ALB/MRL - BILLING BEGINNING POINT/SELECT BILL OR PATIENT  ;01 JUN 88 12:00
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
	;MAP TO DGCRB
	;
EN	;
	D HOME^%ZIS Q:'$D(IBAC)
	;***
	;I $D(XRT0) S:'$D(XRTN) XRTN="IBCB" D T1^%ZOSV ;stop rt clock
	;S XRTL=$ZU(0),XRTN="IBCB-"_$G(IBAC) D T0^%ZOSV ;start rt clock
	;
	S:'$D(IBV) IBV=1 L  K ^UTILITY($J),DFN,IBIFN,DIC S DIC(0)="EQMZ" R !!,"Enter BILL NUMBER or PATIENT NAME: ",IBX:DTIME I IBX["^"!(IBX="") S IBAC1=0 Q
	S IBAC1=1
	I IBX?1A4N!(IBX?2.A)!(IBX?2.A1",".AP)!(IBX?1A1P.AP) S DIC="^DPT(",X=IBX D ^DIC G EN:Y'>0 S DFN=+Y D HINQ S X=$S('$D(^DGCR(399,"C",DFN)):1,'$D(^DGCR(399,"AOP",DFN)):2,1:0)
	I $D(DFN),X,IBAC<4 W !!,"No ",$S(X=1:"",1:"OPEN "),"billing records on file for this patient." D ASK I '$D(IBIFN) G EN
	I $D(DFN) D DATE:'$D(IBIFN),ASK:'$D(IBIFN) D ST:$D(IBIFN) G EN
	S DIC("S")=$S(IBAC'=4:"I $P(^(0),""^"",13)<3",1:"I $P(^(""S""),""^"",17)="""""),DIC="^DGCR(399,",X=IBX
	D ^DIC G:Y'>0 EN S IBIFN=+Y,DFN=$P(Y(0),"^",2) D HINQ,ST G EN
	G EN
HINQ	I $S('$D(^DPT(DFN,.361)):1,$P(^(.361),"^",1)'="V":1,1:0) W !?17,"*** ELIGIBILITY NOT VERIFIED ***" D HINQ1
MT	;I $D(DFN) D ^DGMT1 K DGMTLL
	I $D(DFN) D DIS^DGMTU(DFN)
	Q
HINQ1	I $P($G(^IBE(350.9,1,1)),"^",16) S X="DVBHQZ4" X ^%ZOSF("TEST") K X I $T W ! D EN^DVBHQZ4 Q
	;I $P($G(^IBE(350.9,1,1)),"^",16) F X="DVBHQZ4","DGHINQZ4" X ^%ZOSF("TEST") I $T S DGROUT=X K X W ! D @("EN^"_DGROUT) K DGROUT Q
	K Y Q
ASK	I IBAC'=1 K IBIFN Q
	W !!,"DO YOU WANT TO ESTABLISH A NEW BILLING RECORD FOR '",$P(^DPT(DFN,0),"^",1),"'" S %=2 D YN^DICN
	I '% W !!?4,"YES - To establish a new billing record in the billing file.",!?4,"NO  - To discontinue this process immediately." G ASK
	I %'=1 K IBIFN Q
	K DA,Y,DINUM,IBIFN S (IBNEW,IBYN)=1 D ^IBCA Q
DATE	I $D(^DGCR(399,"C",DFN)) S DA="" F I=1:1 S DA=$O(^DGCR(399,"APDT",DFN,DA)) Q:DA=""  D DATE1
	I IBAC=4,'$D(^UTILITY($J,"IB")) W !,"No ",$S($D(^DGCR(399,"C",DFN)):"UNCANCELLED ",1:""),"billing records on file for this patient." Q
	S CT=0,CT1=1,IBT="" F J=1:1 S IBT=$O(^UTILITY($J,"IB",IBT)) Q:IBT=""  F J1=0:0 S J1=$O(^UTILITY($J,"IB",IBT,J1)) Q:J1=""  S X=J1 D SET
CT	W ! S G="",CT2=$S(CT<(CT1+4):CT,1:(CT1+4)) F K=CT1:1:CT2 I $D(^UTILITY($J,"UB",K)) D WRLINE
	S X="" D WDATE Q:X["^"  I '$D(IB),$D(^UTILITY($J,"UB",K+1)) S CT1=K+1 G CT
	K CT,CT1,CT2,K,^UTILITY($J,"UB") Q
WRLINE	W !?2,K,?6 S IBDATA=^UTILITY($J,"UB",K),Y=+IBDATA X ^DD("DD") W Y,?25,$P(^DGCR(399,+$P(IBDATA,"^",2),0),"^",1),?34,$P(IBDATA,"^",3),?49,$P(IBDATA,"^",4),?71,$P(IBDATA,"^",5)
	Q
DATE1	S IBT=$O(^DGCR(399,"APDT",DFN,DA,0)) I $D(^DGCR(399,+DA,0)),$S(IBAC<3:$P(^(0),U,13)<3,IBAC=3:$P(^(0),U,13)<3,'$D(^("S")):0,$P(^("S"),"^",17)]"":0,1:1) S ^UTILITY($J,"IB",IBT,DA)=""
	Q
WDATE	Q:'CT  W !! W:K<CT "PRESS <RETURN> TO CONTINUE, OR",! W "CHOOSE 1",$S(CT=1:"",1:"-"_K),": " R X:DTIME Q:X["^"!(X="")  I X["?" W !!,"Select one of the above or <RETURN> to establish a new billing record." G WDATE
	I $S('$D(^UTILITY($J,"UB",+X)):1,+X>K:1,+X<1:1,'(X?.N):1,1:0) W !!,"NOT A VALID CHOICE!!",*7 G WDATE
	S IBIFN=$P(^UTILITY($J,"UB",X),"^",2),IB=1 Q
SET	I $S(IBV:1,$P(^DGCR(399,+X,0),"^",13):1,1:0) S CT=CT+1 D SET2
	Q
SET2	S IBND0=^DGCR(399,+X,0)
	S ^UTILITY($J,"UB",CT)=9999999-IBT_"^"_+X_"^"_$S($D(^DGCR(399.3,+$P(IBND0,"^",7),0)):$P(^(0),"^",4)_$S($P(IBND0,"^",5)<3:"-Inpt",1:"-Opt"),1:"")_"^"_$P($P($P(^DD(399,.13,0),"^",3),$P(IBND0,"^",13)_":",2),";",1)
	I +$P(IBND0,"^",19)'=$P($G(^IBE(350.9,1,1)),U,26) S ^UTILITY($J,"UB",CT)=^UTILITY($J,"UB",CT)_"^"_$E($P($G(^IBE(353,+$P(IBND0,"^",19),0)),"^",1),1,9)
	Q
ST	L ^DGCR(399,IBIFN):5 I '$T W !,"No further processing of this record permitted at this time.",!,"Record locked by another user.  Try again later." Q
	S ^DISV(DUZ,"^DGCR(399,")=IBIFN
	D NOPTF^IBCB2 I 'IBAC1 D NOPTF1^IBCB2 Q
	G ST2:IBAC'=1
ST1	K ^UTILITY($J) D ^IBCSCU,^IBCSC1 G Q:'$T
ST2	D ^IBCB1 Q
Q	;
	K IBIFN,IBV,IBAC
	;***
	;I $D(XRT0) S:'$D(XRTN) XRTN="IBCB" D T1^%ZOSV ;stop rt clock
	Q
	;
EDI	S IBAC=1,IBV=0 D EN G Q:'IBAC1,EDI
REV	;S IBAC=2,IBV=0 D EN G Q:'IBAC1,REV
AUT	S IBAC=3,IBV=0 D EN G Q:'IBAC1,AUT
GEN	S IBAC=4,IBV=1 D EN G Q:'IBAC1,GEN
	Q
