IBCSCU	;ALB/MJB - MCCR SCREEN UTILITY ROUTINE  ;27 MAY 88 11:09
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
	;MAP TO DGCRSCU
	;
	S IBW=1,IBU="UNSPECIFIED",IBUN=IBU_" [NOT REQUIRED]",IBV=$S($D(IBV):IBV,1:1) D HOME^%ZIS
	;S IBWW1="X ""F Z2=1:1:(Z1-$L(Z)) S Z=Z_"""" """""" W Z Q"
	S (IBVO,IBVI)="" I $S('$D(IOST(0)):1,'$D(^DG(43,1,0)):1,'$P(^DG(43,1,0),"^",36):1,$D(^DG(43,1,"TERM",IOST(0))):1,1:0) G M
	;
	I $D(IOST(0)) S X="IOINHI;IOINLOW;IOINORM" D ENDR^%ZISS
	I $L(IOINHI),$L(IOINLOW) S IBVI=IOINHI,IBVO=$S(IOINORM]"":IOINORM,1:IBINLOW)
	D KILL^%ZISS
	;I $D(^%ZIS(2,IOST(0),7)) S I=^(7) I $L($P(I,"^",1)),$L($P(I,"^",2)) S IBVI=$P(I,"^",1),IBVO=$S($P(I,"^",3)]"":$P(I,"^",3),1:$P(I,"^",2))
	;
M	;I $L(IBVI_IBVO)>4 S X=80 X ^%ZOSF("RM")
	S IBWW="W:IBW ! S Z=$S(IBV:""<""_Z_"">"",$E(IBV1,Z):""<""_Z_"">"",1:""[""_Z_""]"") W:$E(Z)=""["" IBVI,Z,IBVO W:$E(Z)'=""["" Z Q"
	;S IBWW="W:IBW ! S Z=$S(IOST=""C-QUME""&($L(IBVI)'=2):Z,IBV:""<""_Z_"">"",$E(IBV1,Z):""<""_Z_"">"",1:""[""_Z_""]"") W:$E(Z)=""["" @IBVI,Z,@IBVO W:$E(Z)'=""["" Z Q"
	I $D(IBPAR) S IBV=0,IBVV="00000" Q
	S IBBNO=$P(^DGCR(399,IBIFN,0),"^",1)
	S IBVV=$S($P(^DGCR(399,IBIFN,0),"^",5)>2:"00010100",1:"00001010"),X="63266556"
	Q
H	;Screen Header
	S L="",$P(L,"=",80)=""
	I $D(IBH) S X="HELP SCREEN" W @IOF,!?(40-($L(X)\2)),IBVI,X,IBVO,!,L G HQ
	S X=$P("DEMOGRAPHIC^EMPLOYMENT^PAYER^EVENT - INPATIENT^EVENT - OUTPATIENT^BILLING - GENERAL^BILLING - GENERAL^BILLING - SPECIFIC","^",IBSR)_" INFORMATION",X1="SCREEN <"_+IBSR_">"
	S DGINPT=$S(($P(^DGCR(399,IBIFN,0),"^",5)<3):"Inpatient",1:"Outpatient")
	W @IOF,!,VADM(1),"   ",$P(VADM(2),"^",2),"   BILL#: ",IBBNO_" - "_DGINPT,?(79-$L(X1)),X1
	W !,L
	W !?(40-($L(X)\2)),IBVI,X,IBVO
HQ	K L,DGINPT Q
	;
A	;Format Address(es)
	N Y F I=IBA1:1:IBA1+2 I $P(IB(IBAD),U,I)]"" S IBA(IBA2)=$P(IB(IBAD),U,I),IBA2=IBA2+2
	I IBA2=1 S IBA(1)="STREET ADDRESS UNKNOWN",IBA2=IBA2+2
	S J=$S($D(^DIC(5,+$P(IB(IBAD),U,IBA1+4),0)):$P(^(0),U,2),1:""),J(1)=$P(IB(IBAD),U,IBA1+3),J(2)=$P(IB(IBAD),U,IBA1+11),IBA(IBA2)=$S(J(1)]""&(J]""):J(1)_", "_J,J(1)]"":J(1),J]"":J,1:"CITY/STATE UNKNOWN")
	S Y=$S(IBAD=.11!(IBAD=.121):$P(IB(IBAD),U,IBA1+11),IBAD=.25:$P($G(^DPT(+$G(DFN),.22)),U,6),IBAD=.311:$P($G(^DPT(+$G(DFN),.22)),U,5),1:"") D ZIPOUT^VAFADDR
	S IBA(IBA2)=IBA(IBA2)_" "_Y F I=0:0 S I=$O(IBA(I)) Q:I=""  S IBA(I)=$E(IBA(I),1,25)
	K IBA1,I,J Q
