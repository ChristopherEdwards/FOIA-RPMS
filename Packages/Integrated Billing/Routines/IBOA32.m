IBOA32	;ALB/CPM - PRINT ALL BILLS FOR A PATIENT (CON'T) ; 28-JAN-92
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;
	;MAP TO DGCRA32
	;
	; Print out IB Actions onto the list.
	D:($Y>(IOSL-5)) HDR^IBOA31 Q:IBQUIT
	N IBND,IBND1,X
	S IBND=$G(^IB($E(IBIFN,1,$L(IBIFN)-1),0)),IBND1=$G(^(1))
	W !,$S($P(IBND,"^",11)]"":$P($P(IBND,"^",11),"-",2),$P(IBND,"^",5)=99:"",$P(IBND,"^",5)=10:"",1:"Pending")
	W ?8,$$DAT1^IBOUTL($S($P(IBND,"^",11)="":"",$P(IBND,"^",5)>2&($P(IBND,"^",5)'=99):$P(IBND1,"^",4)\1,1:""))
	S X=$P($P($G(^IBE(350.1,+$P(IBND,"^",3),0)),"^")," ",2,99)
	W ?18,$E($P(X," ",1,$L(X," ")-1),1,17)
	W ?37,$S($P(IBND,"^",3)<7:"PHARMACY COPAY",$P(IBND1,"^",5):"CHAMPVA SUBSIST",1:"AUT MEANS TEST")
	W ?54,$$DAT1^IBOUTL(-IBDT)
	W ?64,$$DAT1^IBOUTL($S($P(IBND,"^",14):$P(IBND,"^",14),1:$P(IBND1,"^",2)\1))
	W ?74,$$DAT1^IBOUTL($S($P(IBND,"^",15):$P(IBND,"^",15),1:$P(IBND1,"^",2)\1))
	W ?89,"N/A",?94,$E($P($G(^IBE(350.21,+$P(IBND,"^",5),0)),"^",2),1,17)
	Q
	;
UTIL	; Gather all IB Actions for a patient.
	N DATE,IBN,X,A,B,C,D,E
	S IBN=0 F  S IBN=$O(^IB("C",DFN,IBN)) Q:'IBN  S X=$G(^IB(IBN,0)) D:X
	. I 'IBIBRX,$E($G(^IBE(350.1,+$P(X,"^",3),0)),1,3)="PSO" Q
	. Q:$P(X,"^",8)["ADMISSION"
	. Q:'$D(^IB("APDT",IBN))
	. S (C,D)="",C=$O(^IB("APDT",IBN,C)),D=$O(^IB("APDT",IBN,C,D))
	. S E=$P($G(^IB(D,0)),U,3)
	. S A=$P($G(^IBE(350.1,E,0)),U,5)
	. S IBN=$S(A=2:$P($Q(^IB("APDT",IBN,C,D)),")",1),A=3:$P($Q(^IB("APDT",IBN,C,D)),")",1),1:IBN)
	. I $P(IBN,",",4)>0 S IBN=$P(IBN,",",4)
	. S DATE=$P($G(^IB(+$P(X,"^",16),0)),"^",17)
	. S:'DATE DATE=$P($G(^IB(IBN,1)),"^",5)
	. S:'DATE DATE=$P($G(^IB(IBN,1)),"^",2)\1
	. S:DATE ^UTILITY($J,-DATE,IBN_"X")=""
	Q
