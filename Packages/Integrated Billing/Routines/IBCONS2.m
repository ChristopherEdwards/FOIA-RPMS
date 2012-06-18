IBCONS2	;ALB/CPM - NSC W/INSURANCE OUTPUT (CON'T) ; 31-JAN-92
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;
	;MAP TO DGCRONS2
	;
LOOP1	; Compilation for both Inpatient Admisssion and Discharge reports.
	N DA,IBADM
	D DIV
	F I=(IBBEG-.0001):0 S I=$O(^DGPM(IBSUB,I)) Q:'I!(I>(IBEND+.99))  D
	. S DFN=0 F  S DFN=$O(^DGPM(IBSUB,I,DFN)) Q:'DFN  S DA=+$O(^(DFN,0)) D  D:PTF PTF I '$G(IBSC),$G(IBDV) D PROC K IBADMVT
	..  S:IBINPT=2 DA=+$P($G(^DGPM(DA,0)),"^",14),IBADM=+$G(^DGPM(DA,0))
	..  S PTF=$P($G(^DGPM(DA,0)),"^",16)
	..  S IBADMVT=DA
	..  S IBDV=+$P($G(^DIC(42,+$P($G(^DGPM(DA,0)),"^",6),0)),"^",11)
	Q
	;
	;
LOOP2	; Compilation for the Outpatient report.
	D DIV
DIS	F I=IBBEG-.0001:0 S I=$O(^DPT("ADIS",I)) Q:'I!(I>(IBEND+.99))  D
	. F DFN=0:0 S DFN=$O(^DPT("ADIS",I,DFN)) Q:'DFN  S J=$O(^(DFN,0)) D
	..  S IBOE="" I $D(^DPT(DFN,"DIS",J,0)) S IBOE=$P($G(^DPT(DFN,"DIS",J,0)),"^",18)
	..  I $D(^DPT(DFN,"DIS",J,0)),$P(^(0),U,2)<2 S IBSTOP="Registration: "_$P($G(^DIC(37,+$P(^(0),U,7),0)),"^"),IBDV=$P(^DPT(DFN,"DIS",J,0),"^",4) D PROC
	;
ADD	F I=IBBEG-.0001:0 S I=$O(^SDV(I)) Q:'I!(I>(IBEND+.99))  S X=$G(^(I,0)) D
	. K IBOE
	. S DFN=$P(X,"^",2),IBDV=$P(X,"^",3) Q:'$D(^DPT(+DFN,0))
	. F N=0:0 S N=$O(^SDV(I,"CS",N)) Q:'N  I $$RPT^IBEFUNC(+$P($G(^(N,0)),"^",5),I) D  D PROC Q
	..S IBOE=$G(IBOE)_$P($G(^SDV(I,"CS",N,0)),"^",8)_"^"
	..N X S X=0
	..S IBSTOP="Add/Edit Stop Code^"
	..F  S X=$O(^SDV(I,"CS","B",X)) Q:'X  S IBSTOP=IBSTOP_$P($G(^DIC(40.7,+X,0)),"^",2)_"^"
	;
CLIN	F IBDC=0:0 S IBDC=$O(^SC("AC","C",IBDC)) Q:'IBDC  I $D(^SC(IBDC,0)),$P(^(0),"^",17)="N" F I=IBBEG-.0001:0 S I=$O(^SC(IBDC,"S",I)) Q:'I!(I>(IBEND+.99))  F IBDFN=0:0 S IBDFN=$O(^SC(IBDC,"S",I,1,IBDFN)) Q:IBDFN<1  D CLIN1
	Q
	;
CLIN1	I $D(^SC(IBDC,"S",I,1,IBDFN,0)) S IBAPPT=^(0),DFN=+IBAPPT I $P(IBAPPT,"^",9)'="C",$D(^DPT(DFN,"S",I,0)),$P(^(0),"^",2)']"",$$RPT^IBEFUNC(+$P(^(0),"^",16),I) S IBOE=$P(^DPT(DFN,"S",I,0),"^",20),IBDV=$P(^SC(IBDC,0),"^",15) D STOPS,PROC
	Q
	;
STOPS	;  -finds stops
	N X
	S X=$G(^DPT(DFN,"S",I,0)) S IBSTOP="Clinic: "_$P(^SC(IBDC,0),"^")_"^"
	I X'="" S IBSTOP=IBSTOP_$S(+$P(X,"^",3):"LAB^",1:"")_$S(+$P(X,"^",4):"X-RAY^",1:"")_$S(+$P(X,"^",5):"EKG^",1:"")
	Q
	;
PROC	;  -process each episode of care
	I VAUTD'=1 Q:'$D(VAUTD(+IBDV))
	I VAUTD=1 Q:'+IBDV
	D PTCHK Q:'IBFLAG  ;  -is patient a vet and have ins data
	D INS Q:'IBFLAG  ;    -is insurance valid for date of care
	K IBRMARK
	D TRACK^IBCONS3 ;     -find tracking entry get reason not billable
	D BILL,SET ;          -on billed or unbilled list
	Q
	;
INS	;S IBINDT=I D ^IBCNS S IBFLAG=$S('$D(IBINS):0,1:IBINS)
	S IBFLAG=$$INSURED^IBCNS1(DFN,I)
	Q
	;
PTCHK	S IBFLAG=0 I $D(^DPT(+DFN,.312)),$G(^("VET"))="Y" S IBFLAG=1
	Q
	;
SET	N TERMD,DPT0,SSN S DPT0=$G(^DPT(+DFN,0)),SSN=$P(DPT0,"^",9)
	S TERMD=$S(IBTERM:$E(SSN,8,9)_$E(SSN,6,7)_$E(SSN,4,5)_$E(SSN,1,3),1:0)
	S ^TMP($J,IBDV,$S(B]"":2,1:1),$S(IBTERM:+TERMD,1:$P(DPT0,"^")),DFN,I)=B I $D(IBSTOP),'$D(^(I,1)) S ^(1)=IBSTOP
	I $G(IBRMARK)'="" S ^TMP($J,IBDV,$S(B]"":2,1:1),$S(IBTERM:+TERMD,1:$P(DPT0,"^")),DFN,I,2)=$G(IBRMARK)
	K IBSTOP,IBRMARK
	Q
	;
BILL	;  Add to billed list if is insurance bill, not canceled
	;     if opt, date is in list, if inpt, admission date = event date
	;
	S B="",I1=$S(IBINPT=2:IBADM,IBINPT:I,1:I\1)
	I IBINPT,$D(^DGCR(399,"C",DFN)) F M=0:0 S M=$O(^DGCR(399,"C",DFN,M)) Q:'M  I $D(^DGCR(399,M,0)),$P(^(0),"^",13)<7,$P($P(^(0),"^",3),".")=$P(I1,"."),$P(^(0),"^",11)="i" S B=B_M_"^" Q:$L(B)>200
	I 'IBINPT,$D(^DGCR(399,"AOPV",DFN,I1)) F M=0:0 S M=$O(^DGCR(399,"AOPV",DFN,I1,M)) Q:'M  I $P(^DGCR(399,M,0),"^",13)<7,$P(^(0),"^",11)="i" S B=B_M_"^" Q:$L(B)>200
	Q
	;
PTF	;  if all movements are for sc condition then not billable
	;
	S IBSC="" Q:'$D(^DGPT(+PTF))
	S IBMOV=0 F  S IBMOV=$O(^DGPT(PTF,"M",IBMOV)) Q:'IBMOV  S IBSC=$P($G(^(IBMOV,0)),"^",18) I IBSC=2!(IBSC="") Q
	S IBSC=$S(IBSC=2!(IBSC=""):0,1:1)
	Q
DIV	;adds the requested divisions to the report
	N IBDIV
	I VAUTD'=1 D
	.S IBDIV="" F  S IBDIV=$O(VAUTD(IBDIV)) Q:'IBDIV  S ^TMP($J,IBDIV)=""
	I VAUTD=1 D
	.S IBDIV="" F  S IBDIV=$O(^DG(40.8,IBDIV)) Q:IBDIV']""!(+IBDIV'=IBDIV)  I $P($G(^DG(40.8,IBDIV,0)),"^",1)]"" S ^TMP($J,IBDIV)=""
	Q
