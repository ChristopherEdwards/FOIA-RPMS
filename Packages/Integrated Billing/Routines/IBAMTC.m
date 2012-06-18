IBAMTC	;ALB/CPM - MEANS TEST NIGHTLY COMPILATION JOB ; 09-OCT-91
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
INIT	; Entry point - initialize variables and parameters
	;
	;***
	;S XRTL=$ZU(0),XRTN="IBAMTC-1" D T0^%ZOSV ;start rt clock
	;
	D NIGHTLY^IBTRKR ; claims tracking nightly update
	;
	D ^IBCD ; automated biller
	;
	D NOW^%DTC S IBAFY=$S($E(X,4,5)<10:$E(X,2,3),1:$E(X,2,3)+1),DT=X,U="^"
	S (IBERRN,IBWHER,IBJOB,IBY,Y)=1,IBCNT=0 K ^TMP($J,"IBAMTC")
	D SITE^IBAUTL I Y<1 S IBY=Y D ERR G CLEAN
	D SERV^IBAUTL2 I IBY<1 D ERR G CLEAN
	;
	; Compile Category C co-pay and per diem charges for all inpatients
	S (IBWARD,DFN)="" F  S IBWARD=$O(^DPT("CN",IBWARD)) Q:IBWARD=""  F  S DFN=$O(^DPT("CN",IBWARD,DFN)) Q:'DFN  S IBA=^(DFN),IBY=1 D PROC
	;
	; Clean up expired Category C billing clocks
CLEAN	S %H=+$H-1 D YMD^%DTC S IBDT=X,(IBN,DFN)=0,IBWHER=23
	F  S DFN=$O(^IBE(351,"ACT",DFN)) Q:'DFN  D
	. F  S IBN=$O(^IBE(351,"ACT",DFN,IBN)) Q:'IBN  D
	..  S IBY=1,X1=IBDT,(X2,IBCLDT)=+$P($G(^IBE(351,+IBN,0)),"^",3) D ^%DTC
	..  I X>364 S IBCLDA=IBN D CLOCKCL^IBAUTL3,ERR:IBY<1
	;
	; Close out incomplete events where the patient has been discharged,
	; pass the related charges if they appear correct, and send a bulletin
	; - also, send bulletins on old incomplete charges where there is no
	; incomplete event
	D MAIN^IBAMTC2
	;
	;D ^IBAMTC1
	;
	; Send bulletin reporting job completion
	D BULL^IBAMTC1
	;
	; -- purge alerts
	D PURGE^IBAERR3
	;
	; Monitor special inpatient billing cases
	D BGJ^IBAMTI
	;
	; Kill variables and quit.
	D KILL1
	;
	I $D(ZTQUEUED),$G(ZTSK) D KILL^%ZTLOAD
	;***
	;I $D(XRT0) S:'$D(XRTN) XRTN="IBAMTC" D T1^%ZOSV ;stop rt clock
	;
	Q
	;
	;
PROC	; Process all currently admitted patients.
	D ORIG ; find "original" admission date
	Q:$$BILST^DGMTUB(DFN)<IBADMDT  ; patient was last Cat C before admission
	Q:IBADMDT\1=DT  ; patient was admitted today - process tomorrow
	Q:$$OE^IBAUTL5(IBA)  ; admitted for Observation & Examination
	Q:$O(^IBE(351.2,"AC",IBA,0))  ; skip special inpatient admissions
	; - gather event information
	D EVFIND^IBAUTL3 I 'IBEVDA D BSEC Q:'IBBS  ; wasn't billable yesterday
	S X=IBADMDT D H^%DTC S IBBDT=%H D:'IBEVDA LAST^IBAUTL5
	I IBEVDA,IBEVCAL S X1=IBEVCAL,X2=1 D C^%DTC S IBBDT=%H
	S IBEDT=+$H-1
	; - gather clock information
	S IBWHER=24 D CLOCK^IBAUTL3 I IBY<1 D ERR G PROCQ
	I IBCLDA S X=IBCLDT D H^%DTC S IBCLCT=IBBDT-%H
	; - build charges for inpatient days
	D ^IBAUTL4 I IBY<1 D ERR G PROCQ
	; - pass per diem if over 30 days old, or both per diem and the copay
	; - if 4 days from patient's statement date; update event, clock
	S IBWHER=22
	I $G(IBCHPDA),$P($G(^IB(+IBCHPDA,0)),"^",6)>30!($$STD^IBAUTL5(DFN)) S IBNOS=IBCHPDA D FILER^IBAUTL5 I IBY<1 D ERR G PROCQ
	I $G(IBCHCDA),$$STD^IBAUTL5(DFN) S IBNOS=IBCHCDA D FILER^IBAUTL5 I IBY<1 D ERR G PROCQ
	I IBEVDA,$D(IBDT) S IBEVCLD=IBDT D EVUPD^IBAUTL3
	I IBCLDA D CLUPD^IBAUTL3
PROCQ	D KILL Q
	;
BSEC	; Determine patient's bedsection for the previous day.
	S X1=DT,X2=-1 D C^%DTC
	S VAIP("D")=X_.2359 D IN5^VADPT S IBBS=$$SECT^IBAUTL5(+VAIP(8)) Q
	;
ERR	; Error processing.  Input:  IBY, IBWHER, IBCNT
	S IBDUZ=DUZ,IBCNT=IBCNT+1 D ^IBAERR1 K IBDUZ Q
	;S ^TMP($J,"IBAMTC","E",IBERRN)=$P(IBY,"^",2)_"^"_$S($D(DFN):DFN,1:"")_"^"_IBWHER,IBERRN=IBERRN+1 Q
	;
ORIG	; Find first admission date, considering ASIH movements
	;  Input:  IBA    Output:  IBADMDT
	N X,Y,Z S Z=IBA
	F  S X=$G(^DGPM(Z,0)),Y=$P(X,"^",21) Q:Y=""  S Z=+$P($G(^DGPM(Y,0)),"^",14)
	S IBADMDT=+X Q
	;
KILL1	; Kill all IB variables.
	K VAERR,VAIP,IBA,IBADMDT,IBAFY,IBATYP,IBBDT,IBBS,IBCHARG,IBCHG,IBCNT,IBCUR,IBDESC,IBDISDT,IBDT,IBDUZ,IBFAC,IBI,IBIL,IBJOB,IBLC,IBMAX
	K IBN,IBNOS,IBSAVBS,IBSEQNO,IBSERV,IBSITE,IBSL,IBTRAN,IBX,IBY,IBWHER,IBWARD,IBEDT,IBCHCTY,IBCHPDE,IBERRN,IBASIH,IBRTED
KILL	; Kill all IB variables needed to build charges.
	K IBCLCT,IBCLDA,IBCLDT,IBCLDAY,IBCLDOL,IBCHPDA,IBCHCDA,IBCHG,IBCHFR,IBCHTO,IBCHTOTL,IBBS,IBNH
	K IBEVDA,IBEVDT,IBEVCLD,IBEVCAL,IBEVNEW,IBEVOLD,IBMED,IBTOTL,IBDESC,IBIL,IBTRAN,IBATYP,IBDATE
	Q
