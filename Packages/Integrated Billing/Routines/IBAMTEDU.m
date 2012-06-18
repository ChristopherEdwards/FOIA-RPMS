IBAMTEDU	;ALB/CPM - MEANS TEST BULLETIN UTILITIES ; 15-JUN-93
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
CHG(IBDAT)	; Any charges billed on or after IBDAT?
	;  Input:  IBDAT  --  Date on or after which charges have been billed
	; Output:    0    --  No charges billed
	;            1    --  Charges were billed; IBARR contains array
	;                      of those charges
	N IBFND,IBD,IBN,IBX,IBJOB,IBWHER K IBARR
	;
	; - if the effective date of the test is today, cancel today's charges.
	I $P(IBDAT,".")=DT D CANC G CHGQ
	;
	; - find all charges which may need to be cancelled.
	S IBX="" F  S IBX=$O(^IB("AFDT",DFN,IBX)) Q:'IBX  S IBD=0 F  S IBD=$O(^IB("AFDT",DFN,IBX,IBD)) Q:'IBD  D
	.I $P($G(^IB(IBD,0)),"^",8)'["ADMISSION" D:-IBX'<IBDAT CHK(IBD) Q
	.S IBN=0 F  S IBN=$O(^IB("AF",IBD,IBN)) Q:'IBN  D CHK(IBN)
CHGQ	Q +$G(IBFND)
	;
CHK(IBN)	; Place charge into the array.
	;  Input:  IBN   --  Charge to check
	N IBND,IBNDL,IBLAST
	S IBND=$G(^IB(IBN,0)) I $P(IBND,"^",15)<IBDAT G CHKQ
	S IBLAST=$$LAST^IBECEAU(+$P(IBND,"^",9)),IBNDL=$G(^IB(+IBLAST,0))
	I $P($G(^IBE(350.1,+$P(IBNDL,"^",3),0)),"^",5)'=2,"^1^2^3^4^8^20^"[("^"_$P(IBNDL,"^",5)_"^") S IBARR(+$P(IBNDL,"^",14),IBLAST)="",IBFND=1
CHKQ	Q
	;
CANC	; Cancel any charges for the patient for today.
	N IBD,IBN,IBCRES,IBFAC,IBSITE,IBSERV,IBDUZ
	Q:'$$CHECK^IBECEAU
	S IBCRES=+$O(^IBE(350.3,"B","MT CATEGORY CHANGED FROM C",0))
	S:'IBCRES IBCRES=22 S IBJOB=7,IBWHER=30,IBDUZ=DUZ
	S IBD=0 F  S IBD=$O(^IB("AFDT",DFN,-DT,IBD)) Q:'IBD  D
	.I $P($G(^IB(IBD,0)),"^",8)'["ADMISSION" D CANCH^IBECEAU4(IBD,IBCRES,1) Q
	.S IBN=0 F  S IBN=$O(^IB("AF",IBD,IBN)) Q:'IBN  D CANCH^IBECEAU4(IBN,IBCRES,1)
	Q
	;
	;
EP(IBDAT)	; Any billable episodes of care since IBDAT?
	;  Input:  IBDAT  --  Date on or after which patient received care
	; Output:    0    --  No billable episodes found
	;            1    --  Billable episodes were found; IBARR contains an
	;                      array of those episodes
	;
	N IBD,IBAD,IBNOW,IBEP,IBDT,IBI,IBPM,VA,VAIP,VAERR
	;
	; - quit if the effective date of the test is today
	I $P(IBDAT,".")=DT G EPQ
	;
	; - find scheduled visits on or after IBDAT
	D NOW^%DTC S IBNOW=% K IBARR
	S IBD=IBDAT F  S IBD=$O(^DPT(DFN,"S",IBD)) Q:'IBD!(IBD>IBNOW)  S IBAD=$G(^(IBD,0)) D
	.Q:$P(IBAD,"^",2)]""  ; visit cancelled
	.Q:$$IGN^IBEFUNC(+$P(IBAD,"^",16),IBD)  ; non-billable appt type
	.Q:$P($G(^SC(+IBAD,0)),"^",17)="Y"  ; non-count clinic
	.Q:$$ENCL^IBAMTS2($P(IBAD,"^",20))[1  ; claimed exposure
	.S IBARR(IBD,"APP")=+IBAD_"^"_$P(IBAD,"^",16),IBEP=1
	;
	; - find stops on or after IBDAT
	S IBD=IBDAT F  S IBD=$O(^SDV("ADT",DFN,IBD)) Q:'IBD!(IBD>DT)  S IBDT=^(IBD),IBI=0 F  S IBI=$O(^SDV(IBDT,"CS",IBI)) Q:'IBI  S IBAD=$G(^(IBI,0)) D
	.Q:$$IGN^IBEFUNC(+$P(IBAD,"^",5),IBD)  ; non-billable appt type
	.Q:$P($G(^SC(+($P(IBAD,"^",3)),0)),"^",17)="Y"  ; non-count clinic
	.Q:$$ENCL^IBAMTS2($P(IBAD,"^",8))[1  ; claimed exposure
	.S IBARR(IBD,"SC"_IBI)=+IBAD_"^"_$P(IBAD,"^",5),IBEP=1
	;
	; - find registrations on or after IBDAT
	S IBD=0 F  S IBD=$O(^DPT(DFN,"DIS",IBD)) Q:'IBD  S IBDT=9999999-IBD Q:IBDT<IBDAT  S IBAD=$G(^(IBD,0)) D
	.Q:$P(IBAD,"^",2)=2  ; application w/o exam
	.Q:$$ENCL^IBAMTS2($P(IBAD,"^",18))[1  ; claimed exposure
	.S IBARR(IBDT,"R")=$P(IBAD,"^",7),IBEP=1
	;
	; - find admissions since IBDAT
	S VAIP("D")=IBDAT D IN5^VADPT I VAIP(13) S IBPM=$G(^DGPM(+VAIP(13),0)),IBARR(+IBPM,"ADM")=$P(IBPM,"^",6),IBEP=1
	S IBD="" F  S IBD=$O(^DGPM("ATID1",DFN,IBD)) Q:'IBD!(9999999.999999-IBD<IBDAT)  S IBPM=$G(^DGPM(+$O(^(IBD,0)),0)),IBARR(+IBPM,"ADM")=$P(IBPM,"^",6),IBEP=1
	;
EPQ	Q +$G(IBEP)
