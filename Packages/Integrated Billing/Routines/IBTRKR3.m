IBTRKR3	;ALB/AAS - CLAIMS TRACKING - ADD/TRACK RX FILLS ; 13-AUG-93
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
%	; -- entry point for nightly background job
	N IBTSBDT,IBTSEDT
	S IBTSBDT=$$FMADD^XLFDT(DT,-14)-.1
	S IBTSEDT=$$FMADD^XLFDT(DT,-7)+.9
	D EN1
	Q
	;
EN	; -- entry point to ask date range
	N IBBDT,IBEDT,IBTSBDT,IBTSEDT,IBTALK,IBMESS
	S IBTALK=1
	I '$P($G(^IBE(350.9,1,6)),"^",4) W !!,"I'm sorry, Tracking of Prescription Refills is currrently turned off." G ENQ
	W !!!,"Select the Date Range of Rx Refills to Add to Claims Tracking.",!
	D DATE^IBOUTL
	I IBBDT<1!(IBEDT<1) G ENQ
	S IBTSBDT=IBBDT,IBTSEDT=IBEDT
	;
	; -- check selected dates
	S IBTRKR=$G(^IBE(350.9,1,6))
	; start date can't be before parameters
	I +IBTRKR,IBTSBDT<+IBTRKR S IBTSBDT=IBTRKR W !!,"Begin date is before Claims Tracking Start Date, changed to ",$$DAT1^IBOUTL(IBTSBDT)
	; -- end date into future
	I IBTSEDT>$$FMADD^XLFDT(DT,-3) W !!,"I'll automatically change the end date to 3 days prior to the date queued to run."
	;
	W !!!,"I'm going to automatically queue this off and send you a"
	W !,"mail message when complete.",!
	S ZTIO="",ZTRTN="EN1^IBTRKR3",ZTSAVE("IB*")="",ZTDESC="IB - Add Rx Refills to Claims Tracking"
	D ^%ZTLOAD I $G(ZTSK) K ZTSK W !,"Request Queued"
ENQ	K ZTSK,ZTIO,ZTSAVE,ZTDESC,ZTRTN
	D HOME^%ZIS
	Q
	;
EN1	; -- add rx refills to claims tracking file
	N I,J,X,Y,IBTRKR,IBDT,IBRXN,IBFILL,DFN,IBDATA,IBCNT,IBCNT1,IBCNT2
	;
	; -- check parameters
	S IBTRKR=$G(^IBE(350.9,1,6))
	G:'$P(IBTRKR,"^",4) EN1Q ; quit if rx tracking off
	I +IBTRKR,IBTSBDT<+IBTRKR S IBTSBDT=IBTRKR ; start date can't be before parameters
	;
	; -- users can queue into future, make sure dates not after date run
	I IBTSEDT>$$FMADD^XLFDT(DT,-3) S IBMESS="(Selected end date of "_$$DAT1^IBOUTL(IBTSEDT)_" automatically changed to "_$$DAT1^IBOUTL($$FMADD^XLFDT(DT,-3))_".)",IBTSEDT=$$FMADD^XLFDT(DT,-3)
	;
	S IBRXTYP=$O(^IBE(356.6,"AC",4,0)) ; event type pointer for rx billing
	;
	; -- cnt= total count, cnt1=count added nsc, cnt2=count of pending
	S (IBCNT,IBCNT1,IBCNT2)=0
	S IBDT=IBTSBDT-.0001
	F  S IBDT=$O(^PSRX("AD",IBDT)) Q:'IBDT!(IBDT>IBTSEDT)  S IBRXN="" F  S IBRXN=$O(^PSRX("AD",IBDT,IBRXN)) Q:'IBRXN  S IBFILL="" F  S IBFILL=$O(^PSRX("AD",IBDT,IBRXN,IBFILL)) Q:IBFILL=""  D RXCHK
	;
	I $G(IBTALK) D BULL^IBTRKR31
EN1Q	I $D(ZTQUEUED) S ZTREQ="@"
	Q
	;
RXCHK	; -- check and add rx
	S IBCNT=IBCNT+1
	I IBFILL<1 G RXCHKQ ;       original fill
	I IBDT>(DT+.24) G RXCHKQ ;  future fill
	I '$D(ZTQUEUED),($G(IBTALK)) W "."
	;
	S IBRXDATA=$G(^PSRX(IBRXN,0)),IBRXSTAT=$P(IBRXDATA,"^",15)
	S DFN=$P(IBRXDATA,"^",2)
	;I IBDT=$P($O(^DPT(DFN,"S",(IBDT-.00001))),".") G RXCHKQ ;scheduled appointment on same day as fill date
	I $$BABCSC^IBEFUNC(DFN,$P(IBDT,".",1)) G RXCHKQ ; is billable clinic stop in encounter file for data (allows telephone stops on same day, but not others)
	;
	; -- not already in claims tracking
	I $O(^IBT(356,"ARXFL",IBRXN,IBFILL,0)) G RXCHKQ ; already in claims tracking
	;
	; -- see if tracking only insured and pt is insured
	I $P(IBTRKR,"^",4)=1,'$$INSURED^IBCNS1(DFN,IBDT) G RXCHKQ ; patient not insure
	;
	; -- check rx status (not deleted)
	I IBRXSTAT=13 G RXCHKQ
	;
	; -- Version 6 and refill not released or returned to stock
	I +$G(^PS(59.7,1,49.99))'<6,'$P($G(^PSRX(IBRXN,1,IBFILL,0)),"^",18) G RXCHKQ
	I $P($G(^PSRX(IBRXN,1,IBFILL,0)),"^",16) G RXCHKQ
	;
	; -- check drug (not investigational, supply, or over the counter drug
	S IBDRUG=$P(IBRXDATA,"^",6)
	S IBDEA=$P($G(^PSDRUG(+$P(IBRXDATA,"^",6),0)),"^",3)
	I IBDEA["I"!(IBDEA["S")!(IBDEA["9") G RXCHKQ ; investigational drug, supply or otc
	;
	; -- check sc status
	D ELIG^VADPT
	I VAEL(3),'$G(^PSRX(IBRXN,"IB")) S IBRMARK="NEEDS SC DETERMINATION"
	;
	; -- ok to add to tracking module
	D REFILL^IBTUTL1(DFN,IBRXTYP,IBDT,IBRXN,IBFILL,$G(IBRMARK)) I '$D(ZTQUEUED),$G(IBTALK) W "+"
	I $G(IBRMARK)'="" S IBCNT2=IBCNT2+1
	I $G(IBRMARK)="" S IBCNT1=IBCNT1+1
	K IBRMARK,VAEL,VA,IBDEA,IBDRUG,IBRXSTAT,IBRXDATA,DFN,X,Y
RXCHKQ	Q
