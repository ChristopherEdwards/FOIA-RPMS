IBCU7	;ALB/AAS - INTERCEPT SCREEN INPUT OF PROCEDURE CODES ; 29-OCT-91
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
	;MAP TO DGCRU7
	;
CHKX	;  -interception of input x from Additional Procedure input
	G:X=" " CHKXQ
	I $P(^DGCR(399,DA(1),0),"^",5)<3,'$P($G(^IBE(350.9,1,1)),"^",15),X'?1A1N K X G CHKXQ
	G:'$D(^UTILITY($J,"IB")) CHKXQ
	S M=($A($E(X,1))-64),S=+$E(X,2) Q:'$G(^UTILITY($J,"IB",M,S))  S X="`"_+^(S)
	I $D(DGPROCDT),DGPROCDT'=$P($G(^UTILITY($J,"IB",M,1)),"^",2) S DGPROCDT=$P(^(1),"^",2) W !!,"Procedure Date: " S Y=DGPROCDT X ^DD("DD") W Y,!
CHKXQ	Q
	;
CODMUL	;Date oriented entry of procedure 
DELASK	I $D(IBZ20),IBZ20,IBZ20'=$P(^DGCR(399,IBIFN,0),U,9) S %=2 W !,"SINCE THE PROCEDURE CODING METHOD HAS BEEN CHANGED, DO YOU WANT TO DELETE ALL",!,"PROCEDURE CODES IN THIS BILL"
	I  D YN^DICN Q:%=-1  D:%=1 DELADD I %Y?1."?" W !!,"If you answer 'Yes', all procedure codes will be DELETED from this bill.",! G DELASK
	K %,%Y,DA,IBZ20,DIK ;W !,"Procedure Entry:"
	S:'$D(^DGCR(399,IBIFN,"CP",0)) ^DGCR(399,IBIFN,"CP",0)="^399.0304IAV^"
	;
CODDT	I $D(IBIFN),$D(^DGCR(399,IBIFN,0)),$P(^(0),U,9) S DIC("V")=$S($P(^(0),U,9)=9:"I +Y(0)=80.1",$P(^(0),U,9)=4!($P(^(0),U,9)=5):"I +Y(0)=81",1:"")
	I $P($G(^DGCR(399,IBIFN,0)),"^",5)<3 S IBZTYPE=1 I $P($G(^UTILITY($J,"IB",1,1)),"^",2) S DGPROCDT=$P(^(1),"^",2) D ASKCOD
	R !,"Select PROCEDURE DATE: ",X:DTIME G:'$T!("^"[X) CODQ D:X["?" CODHLP
	I X=" ",$D(DGPROCDT),DGPROCDT?7N S Y=DGPROCDT D D^DIQ W "   (",Y,")" D ASKCOD,ADDCPT^IBCU71:$D(DGCPT) G CODDT
	I X=" ",+$P($G(^DGCR(399,IBIFN,"OP",0)),"^",4) S (DGPROCDT,Y)=$O(^DGCR(399,IBIFN,"OP",0)) D D^DIQ W "   (",Y,")" D ASKCOD,ADDCPT^IBCU71:$D(DGCPT) G CODDT
	S %DT="EXP" D ^%DT G:Y<1 CODDT G:'$$OPV2^IBCU41(Y,IBIFN,1) CODDT S:'$G(IBZTYPE) X=$$OPV^IBCU41(Y,IBIFN) S DGPROCDT=Y D ASKCOD,ADDCPT^IBCU71:$D(DGCPT) G CODDT
	G CODDT
	Q
	;
ASKCOD	K DGCPT S DGCPT=0,DGCPTUP=$P($G(^IBE(350.9,1,1)),"^",19),DGADDVST=0,IBFT=$P($G(^DGCR(399,IBIFN,0)),"^",19)
	F  S DIC("A")="   Select PROCEDURE: ",DIC="^DGCR(399,"_IBIFN_",""CP"",",DIC(0)="AEQMNL",DIC("S")="I '$D(DIV(""S""))&($P(^(0),U,2)=DGPROCDT)",DIC("DR")="1///^S X=DGPROCDT",DA(1)=IBIFN D ^DIC Q:Y<1  D
	.I Y["ICD0",$P(^ICD0(+$P(Y,"^",2),0),"^",11),$P(^(0),"^",11)<DT W !,*7,"Warning:  Procedure code is currently inactive",!
	. I Y["ICPT",$P(^ICPT(+$P(Y,"^",2),0),"^",4) W !,*7,"Warning:  Procedure code is currently inactive",!
	.S DGCPTNEW=$P(Y,"^",3),DGADDVST=$S($P(Y,"^",3):1,$D(DGADDVST):DGADDVST,1:0)
	.S DIE=DIC,DR=".01;3",DA=+Y D ^DIE Q:'$D(DA)
	. I IBFT=2 S DR="8;9;D DISP1^IBCSC4D("_IBIFN_");10;S:X="""" Y=""@99"";11;S:X="""" Y=""@99"";12;S:X="""" Y=""@99"";13;@99" D ^DIE
	.;  -if billable get division, if amb proc get associated clinic, build  dgcpt(assoc clinic,cpt) array
	.Q:$P(^DGCR(399,IBIFN,0),"^",5)<3  ;only outpatient bills
	.S DGPROC=$G(^DGCR(399,IBIFN,"CP",+DA,0)) I 'DGCPTNEW,$P(DGPROC,"^",7)="" S DGCPTNEW=2
	.;I DGPROC["ICPT",IBFT=2 D DISPDX^IBCU71 S DR="7;" D ^DIE
	.Q:'$$SCREEN^IBCU71(DGPROCDT,+DGPROC)
	.S DR="" I $$CPTBSTAT^IBEFUNC1(+DGPROC,DGPROCDT) S DR="5//"_$P($G(^DG(40.8,+$P($G(^IBE(350.9,1,1)),"^",25),0)),"^")_";" D
	..;I $P(^DGCR(399,IBIFN,0),"^",19)'=2,$$TOMANY^IBCCPT(DGPROCDT) W !?4,"This bill has more than 1 visit date and you are adding a Billable Amb. Surg." S DGNOADD=1
	.S:DGCPTUP DR=DR_"6;" D ^DIE
	.I DGCPTUP,DGCPTNEW S DGCPT=DGCPT+1,DGPROC=$G(^DGCR(399,IBIFN,"CP",+DA,0)) I $P(DGPROC,"^",7) S DGCPT($P(DGPROC,"^",7),+DGPROC,DGCPT)=""
	.;I DGADDVST,'$D(DGNOADD),'$D(^DGCR(399,IBIFN,"OP",DGPROCDT)) S (X,DINUM)=DGPROCDT K DGNOADD D VFILE1^IBCOPV1 K DINUM,X,DGNOADD,DGADDVST
	.I DGADDVST S (X,DINUM)=DGPROCDT D VFILE1^IBCOPV1 K DINUM,X,DGNOADD,DGADDVST
	.Q
	Q
CODQ	K %DT,DGPROC,DIC,DIE,DR,DGPROCDT
	K IBFT,DGNOADD,DGADDVST,DGCPT,DGCPTUP,IBZTYPE,DGCPTNEW Q
	;
DELADD	S DA(1)=IBIFN,DIK="^DGCR(399,"_DA(1)_",""CP""," F DA=0:0 S DA=$O(^DGCR(399,DA(1),"CP",DA)) Q:'DA  D ^DIK
	Q
	;
DTMES	;Message if procedure date not in date range
	Q:'$D(IBIFN)  Q:'$D(^DGCR(399,IBIFN,"U"))  S DGNODUU=^("U")
	G:X'<$P(DGNODUU,"^")&(X'>$P(DGNODUU,"^",2)) DTMESQ
	W *7,!!?3,"Date must be within STATEMENT COVERS FROM and STATEMENT COVERS TO period."
	S Y=$P(DGNODUU,"^") X ^DD("DD")
	W !?3,"Enter a date between ",Y," and " S Y=$P(DGNODUU,"^",2) X ^DD("DD") W Y,!
	K X,Y
DTMESQ	K DGNODUU Q
	;
CODHLP	;Display Additional Procedure codes
	I '$O(^DGCR(399,IBIFN,"CP",0)) W !!?5,"No Codes Entered!",! Q
	F I=0:0 S I=$O(^DGCR(399,IBIFN,"CP",I)) Q:'I  S Y=$G(^(I,0)) S Z=$G(@(U_$P($P(Y,"^"),";",2)_$P($P(Y,"^"),";")_",0)")) W !?17,$E($P(Z,"^",$S($P(Y,"^")["ICD":4,1:2)),1,28),?47,"- ",$P(Z,"^"),?57,"Date: " S Y=$P(Y,"^",2) D DT^DIQ
	K Z Q
	;
DICV	I $D(IBIFN),$D(^DGCR(399,IBIFN,0)),$P(^(0),U,9) S DIC("V")=$S($P(^(0),U,9)=9:"I +Y(0)=80.1",$P(^(0),U,9)=4!($P(^(0),U,9)=5):"I +Y(0)=81",1:"")
	Q
