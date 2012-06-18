IBCSC6	;ALB/MJB - MCCR SCREEN 6 (INPT. BILLING INFO)  ;27 MAY 88 10:19
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
	;MAP TO DGCRSC6
	;
EN	I $P(^DGCR(399,IBIFN,0),"^",5)>2 G EN^IBCSC7
	I $D(DGRVRCAL) D ^IBCU6 K DGRVRCAL
	D ^IBCSCU S IBSR=6,IBSR1="",IBV1="00000" S:IBV IBV1="11111" F I="U","U1",0,"U2" S IB(I)=$S($D(^DGCR(399,IBIFN,I)):^(I),1:"")
	D H^IBCSCU
	S IBBT=$P(IB(0),U,4)_$P(IB(0),U,5)_$P(IB(0),U,6)
	D 4^IBCVA1,5^IBCVA1
	;
1	S Z=1,IBW=1 X IBWW W " Bill Type   : ",$S('$D(IBBT):IBU,IBBT="":IBU,1:IBBT)
	W ?46,"Timeframe: ",$S($D(IBTF):IBTF,1:"") K IBTF
	;W !?4,"Provider # : ",$S(IB("U2")="":IBU,$P(IB("U2"),U,2)'="":$P(IB("U2"),U,2),1:IBU)
	W !?4,"Covered Days: ",$S(IB("U2")="":IBU,$P(IB("U2"),U,2)'="":$P(IB("U2"),U,2),1:IBU)
	W ?30,"Non-Covered Days: ",$S(IB("U2")="":IBU,$P(IB("U2"),U,3)'="":$P(IB("U2"),U,3),1:IBU)
	;
ROI	S Z=2,IBW=1 X IBWW
	W " Sensitive?  : ",$S(IB("U")="":IBU,$P(IB("U"),U,5)="":IBU,$P(IB("U"),U,5)=1:"YES",1:"NO")
	W ?45,"Assignment: ",$S(IB("U")="":IBU,$P(IB("U"),U,6)="":IBU,$P(IB("U"),U,6)["n":"NO",$P(IB("U"),U,6)["N":"NO",$P(IB("U"),U,6)=0:"NO",1:"YES")
	I $P(IB("U"),U,5)=1 W !?4,"R.O.I. Form : ",$S($P(IB("U"),U,7)=1:"COMPLETED",$P(IB("U"),U,7)=0:"NOT COMPLETED",1:"STATUS UNKNOWN")
	S IBOA="01^02^03^04^05^06^" F I=1:1:5 Q:'$D(IBOCN(I))  I IBOA[IBOCN(I)_"^" S IBOX=1
	W:$D(IBOX) !,?4,"Pow of Atty : ",$S($P(IB("U"),U,3)=1:"COMPLETED",$P(IB("U"),U,3)=0:"NOT COMPLETED",1:"STATUS UNKNOWN")
	;
3	S Z=3,IBW=1 X IBWW D FROMTO
	;
BED	S Z=4,IBW=1 X IBWW
	W " Bedsection  : ",$S(IB("U")="":IBU,$P(IB("U"),U,11)'="":$P(^DGCR(399.1,$P(IB("U"),U,11),0),U,1),1:IBU)
	;S IBI=1,D1=0,IBLS=$S($D(DGNEWLOS):0,IB("U")="":0,$P(IB("U"),U,15)'="":$P(IB("U"),U,15),1:0) K DGNEWLOS
	;I 'IBLS S D0=DFN,(D1,DGPMIFN)=$O(^DGPM("AMV1",$P(IBIP,U,2),DFN,0)),X2=$P(IB("U"),"^"),X1=$P(IB("U"),"^",2) D ^%DTC S IBLS(1)=X
	;I 'IBLS K X D:DGPMIFN ^DGPMLOS S IBLS=$S($D(X):$P(X,U,5),1:IBLS(1)),IBLS=$S(IBLS(1)<IBLS:IBLS(1),1:IBLS) S:'IBLS IBLS=1 S (DA,Y)=IBIFN,DIE="^DGCR(399,",DR="165///"_IBLS D ^DIE K DR
	W !?4,"LOS         : ",IBLS
	;
	I $P($G(^DPT(DFN,.3)),"^")="Y" D SC I IBSCM>0 W !?4,"PTF record indicates ",IBSCM," of ",IBM," movements are for Service Connected Care."
REV	S Z=5,IBW=1 X IBWW W " Rev. Code   : " F I=1:1:10 Q:'$D(IBREVC(I))  D REV^IBCSC61
	I $D(IBREVC(11)) W !,?4,"Too many Revenue Codes to display, enter '5' to list"
BILL	D OFFSET^IBCSC61
	W !?4,"FY 1        : ",$S($P(IB("U1"),U,9)]"":$P(IB("U1"),U,9),1:IBU),?40,"Charges: " S X=$P(IB("U1"),"^",10),X2="2$" D COMMA^%DTC W X
	I $P(IB("U1"),U,11)]"" W !?4,"FY 2        : ",$P(IB("U1"),U,11) S X=+$P(IB("U1"),U,12),X2="2$" D COMMA^%DTC W ?40,"Charges: ",X
	G ^IBCSCP
	Q
	;
FROMTO	;  - Print From and To dates of bill
	W " Bill From   : " S Y=$P(IB("U"),"^") D D^DIQ W $S($L(Y):Y,1:IBU)
	W ?48,"Bill To: " S Y=$P(IB("U"),"^",2) D D^DIQ W $S($L(Y):Y,1:IBU)
	Q
	;
SC	;  -if patient is sc, are movements for sc care
	S PTF=$P(IB(0),"^",8)
	;
SC1	;
	;  -input ptf
	;
	;  -output IBm   = number of movements
	;          IBscm = number of SC movements
	S (IBM,IBSCM,M)=0
	I $S('PTF:1,'$D(^DGPT(PTF,0)):1,1:0) Q
	F  S M=$O(^DGPT(PTF,"M",M)) Q:'M  S IBM=IBM+1 I $P($G(^DGPT(PTF,"M",M,0)),"^",18)=1 S IBSCM=IBSCM+1
	Q
	;
	;IBCSC6
