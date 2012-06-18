IBOBCC	;ALB/ARH - UNBILLED APPOINTMENT BASC FOR INSURED PATIENTS ; 2/27/92
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;
EN	;get date range then run the report
	;I $D(XRT0) S:'$D(XRTN) XRTN="IBOBCC" D T1^%ZOSV ;stop rt clock
	;S XRTL=$ZU(0),XRTN="IBOBCC-1" D T0^%ZOSV ;start rt clock
	S IBHDR="UNBILLED BASC FOR INSURED PATIENT APPOINTMENTS" D HOME^%ZIS
	W @IOF W !!,?15,"Report Unbilled BASC for Insured Patient Appointments",!!!!
	D BDT^IBOUTL G:Y<0!(IBBDT="")!(IBEDT="") EXIT
DEV	;get the device
	W !!,"Report requires 132 columns."
	S %ZIS="QM",%ZIS("A")="OUTPUT DEVICE: " D ^%ZIS G:POP EXIT
	I $D(IO("Q")) S ZTRTN="EN1^IBOBCC",ZTDESC=IBHDR,ZTSAVE("IB*")="" D ^%ZTLOAD K IO("Q"),ZTSK G EXIT
	U IO D EN1 D ^%ZISC
	;
EXIT	;clean up and quit
	;I $D(XRT0) S:'$D(XRTN) XRTN="IBOBCC" D T1^%ZOSV ;stop clock
	I $D(ZTQUEUED) S ZTREQ="@" Q
	K IBBDT,IBEDT,IBHDR,X,Y,DTOUT,DUOUT,DIRUT,DIROUT
	Q
	;
EN1	;entry pt. for tasked jobs
	;I $D(XRT0) S:'$D(XRTN) XRTN="IBOBCC" D T1^%ZOSV ;stop rt clock
	;S XRTL=$ZU(0),XRTN="IBOBCC-2" D T0^%ZOSV ;start rt clock
	;find, save, and print each BASC entered in scheduling that has not been entered in billing (or doesn't/can't match)
	;for each patient appointment in scheduling, where patient has active insurance, and billable CPTs entered for appointment
	;must match between scheduling and billing: DFN, CPT, appointment date (procedure date) (doesn't match clinics)
APPT	;get all BASC CPTs for appointments in date range for patients with insurance
	S IBE=IBEDT+.3,IBADT=IBBDT-.001,IBQ=0
	F  S IBADT=$O(^SDV("AP",IBADT)) Q:'IBADT!(IBADT>IBE)!IBQ  S IBX="" D  S IBQ=$$STOP
	. F  S IBX=$O(^SDV("AP",IBADT,IBX)) Q:'IBX  D
	.. S IBAD=$E(IBADT,1,7),(DFN,IBDFN)=^(IBX),IBINDT=IBAD D ^IBCNS Q:'IBINS
	.. S IBPR=$G(^SDV(IBADT,"CS",IBX,"PR")) I IBPR D
	... F IBI=1:1 S IBCPT=$P(IBPR,"^",IBI) Q:'IBCPT  I $$CPTBSTAT^IBEFUNC1(IBCPT,IBAD) D
	.... S ^TMP("IBBC",$J,IBDFN,IBAD,IBCPT)=$G(^TMP("IBBC",$J,IBDFN,IBAD,IBCPT))+1
	K IBE,IBADT,IBDFN,IBAD,IBX,IBPR,IBI,IBCPT,DFN,IBINDT,IBINS
	;
	G:'$D(^TMP("IBBC",$J))!IBQ PRINT
BILLED	;determine which BASC procedures from scheduling were actually entered in billing
	;try to match scheduling and billing, the scheduling appointment date (^SDV) and the billing procedure date (^IB) must be
	;the same to be able to match procedures between scheduling and billing
	S IBDFN="" F  S IBDFN=$O(^TMP("IBBC",$J,IBDFN)) Q:(IBDFN'?1N.N)!IBQ  S IBAD="" D  S IBQ=$$STOP
	. F  S IBAD=$O(^TMP("IBBC",$J,IBDFN,IBAD)) Q:IBAD=""  S IBCPT="" D
	.. F  S IBCPT=$O(^TMP("IBBC",$J,IBDFN,IBAD,IBCPT)) Q:IBCPT=""  S IBCNT=^(IBCPT) I $D(^DGCR(399,"ASD",-IBAD,IBCPT)) D
	... S IBBN="" F  S IBBN=$O(^DGCR(399,"ASD",-IBAD,IBCPT,IBBN)) Q:IBBN=""!(IBCNT'>0)  I $D(^DGCR(399,"C",IBDFN,IBBN)) D
	.... S IBX="" F  S IBX=$O(^DGCR(399,"ASD",-IBAD,IBCPT,IBBN,IBX)) Q:IBX=""!(IBCNT'>0)  S IBCNT=IBCNT-1
	... I IBCNT'>0 K ^TMP("IBBC",$J,IBDFN,IBAD,IBCPT) Q
	... S ^TMP("IBBC",$J,IBDFN,IBAD,IBCPT)=IBCNT
	.. I $D(^TMP("IBBC",$J,IBDFN,IBAD)) S ^TMP("IBBC",$J,"N",$P($G(^DPT(IBDFN,0)),"^",1),IBDFN)=""
	K IBDFN,IBAD,IBCPT,IBCNT,IBBN,IBX
	;
PRINT	G PRINT^IBOBCC1
	Q
	;
STOP()	;determine if user requested task to be stopped
	I $D(ZTQUEUED),$$S^%ZTLOAD S ZTSTOP=1 K ZTREQ I +$G(IBPGN) W !!,"TASK STOPPED BY USER",!!
	Q +$G(ZTSTOP)
