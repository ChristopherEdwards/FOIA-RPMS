IBOEMP1	;ALB/ARH - EMPLOYER REPORT (SEARCH) ; 6/19/92
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;
	I IBCH="OPT" G OPT
	;
INPT	;search for outpatient admissions (patient movement file)
	S IBB=IBBEG-.001,IBE=IBEND+.3,IBHDR=IBHDR_" FOR INPATIENT ADMISSIONS ",IBQ=0
	F  S IBB=$O(^DGPM("AMV1",IBB)) Q:'IBB!(IBB>IBE)!(IBQ)  D  S IBQ=$$STOP^IBOEMP2
	. S IBDFN="" F  S IBDFN=$O(^DGPM("AMV1",IBB,IBDFN)) Q:'IBDFN  D
	.. Q:$D(^TMP("IBEMP",$J,IBDFN))  S Y=IBB D DD^%DT S IBAPDT=$P(Y,"@",1),IBPM=""
	.. F  S IBPM=$O(^DGPM("AMV1",IBB,IBDFN,IBPM)) Q:IBPM=""  S IBAPTYP=$P(^DGPM(IBPM,0),"^",2),IBAPTYP=$P($G(^DG(405.3,IBAPTYP,0)),"^",1)
	.. S IBAPDT=IBAPDT D PAT
	K IBB,IBE,IBDFN,IBAPDT,IBAPTYP,IBPM,X,Y
	Q
	;
OPT	;search for outpatient visits
	;find ALL outpatient visits within the date range and division
	;this includes registrations (2,1000), scheduled appointments (44,1900), and unscheduled appointments (409.5)
	;
DIS	;find all dispositions (2,1000) within the date range
	; - (2,1000,1) that are not 2-APPLICATION WITHOUT EXAM
	S IBB=IBBEG-.0001,IBE=IBEND+.9,IBHDR=IBHDR_" FOR OUTPATIENT VISITS ",IBQ=0
	F  S IBB=$O(^DPT("ADIS",IBB)) Q:'IBB!(IBB>IBE)!(IBQ)  S IBDFN=0 D  S IBQ=$$STOP^IBOEMP2
	. F  S IBDFN=$O(^DPT("ADIS",IBB,IBDFN)) Q:'IBDFN  S IBY=0 I '$D(^TMP("IBEMP",$J,IBDFN)) D
	.. F  S IBY=$O(^DPT("ADIS",IBB,IBDFN,IBY)) Q:'IBY  S IBX=$G(^DPT(IBDFN,"DIS",IBY,0)) I +IBX,$P(IBX,U,2)<2,(VAUTD=1!($D(VAUTD(+$P(IBX,"^",4))))) D
	... S IBAPTYP="DISPOSITION",IBAPDT=IBB\1
	... D PAT
	;
	;
APPT	;outpatient: find all scheduled appointments (44,1900 -> 2,1900)
	; - must be clinic appointments (44,2.1 -> "AC" x-ref)
	; - (2,1900,3) that are outpatient, have not been canceled or no-showed etc.
	S IBE=IBEND+.3,IBCLN=0
	F  S IBCLN=$O(^SC("AC","C",IBCLN)) Q:'IBCLN!(IBQ)  D  S IBQ=$$STOP^IBOEMP2
	. I VAUTD'=1,'$D(VAUTD(+$P($G(^SC(IBCLN,0)),"^",15))) Q  ; check division
	. S IBB=IBBEG-.0001 F  S IBB=$O(^SC(IBCLN,"S",IBB)) Q:'IBB!(IBB>IBE)  D
	.. S IBY=0 F  S IBY=$O(^SC(IBCLN,"S",IBB,1,IBY)) Q:'IBY  S IBX=$G(^SC(IBCLN,"S",IBB,1,IBY,0)) I +IBX D
	... S IBDFN=+IBX I $D(^TMP("IBEMP",$J,IBDFN)) Q
	... S IBXP=$G(^DPT(IBDFN,"S",IBB,0)) I +IBXP'=IBCLN,$P(IBXP,U,2)'="" Q
	... S IBAPTYP=$P($G(^SD(409.1,+$P(IBXP,U,16),0)),U,1),IBAPDT=IBB\1
	... D PAT
	;
	;
STOP	;outpatient: find all unscheduled outpatient appointments (409.5, add/edit) for the patient
	S IBB=IBBEG-.001,IBE=IBEND+.3
	F  S IBB=$O(^SDV(IBB)) Q:'IBB!(IBB>IBE)!(IBQ)  D  S IBQ=$$STOP^IBOEMP2
	. S IBX=$G(^SDV(IBB,0)) I IBX'="",(VAUTD=1!($D(VAUTD(+$P(IBX,"^",3))))) S IBDFN=+$P(IBX,"^",2) D
	.. Q:$D(^TMP("IBEMP",$J,IBDFN))  S Y=IBB D DD^%DT S IBAPDT=$P(Y,"@",1)
	.. S IBAPTYP=$O(^SDV(IBB,"CS",0)),IBAPTYP=$P($G(^SDV(IBB,"CS",+IBAPTYP,0)),"^",5),IBAPTYP=$P($G(^SD(409.1,+IBAPTYP,0)),"^",1)
	.. D PAT
	K IBB,IBE,IBX,IBY,IBCLN,IBXP,IBDFN,IBAPDT,IBAPTYP,X,Y
	Q
	;
	;Input:  IBB,IBDFN,IBAPTYP,IBAPDT
PAT	;gather data on patients with no insurance at time of care
	N IBX,IBY
	I $D(^TMP("IBEMP",$J,IBDFN)) G PEND ; quit if this patient has already been processed
	S ^TMP("IBEMP",$J,IBDFN)="" ; once a pt is checked don't check again
	S DFN=IBDFN,IBINDT=IBB D ^IBCNS G:IBINS PEND ; quit if patient has insurance
	D DEM^VADPT G:+VADM(6) PEND ; quit if patient is dead
	D ELIG^VADPT S IBPELG=$G(^DIC(8,+VAEL(1),0)),IBPELG=$S($P(IBPELG,"^",3)'="":$P(IBPELG,"^",3),1:$E($P(VAEL(1),"^",2),1,4)) K VAEL
	D OPD^VADPT S IBSES=$P($G(^DPT(DFN,.25)),"^",15) ; spouses employment status
	;
	;get patient and spouse's employer data
	;add to report if patient or spouse employment status is employed or the patients or spouse employer name is defined
	S DFN=IBDFN F Z=5,6 S VAOA("A")=Z D OAD^VADPT I VAOA(9)'=""!(Z=5&("1245"[+VAPD(7)))!(Z=6&("1245"[+IBSES)) D  K VAOA
	. S IBZ=$S(VAOA("A")=5:"P",1:"S"),IBADD="",IBADDN=VAOA(9),VAOA(5)=$P(VAOA(5),"^",2),IBX=0
	. S IBY=$A(IBADDN) I IBY>96,IBY<123 S IBY=IBY-82 ; deal with lower case
	. I IBY<IBRGB!(IBY>IBRGE) Q  ; is employer name within range?
	. I IBADDN="" S (VAOA(9),IBADDN)="{EMPLOYER NOT SPECIFIED}"
	. F IBI=9,1:1:6,8 S IBX=IBX+1 I VAOA(IBI)'="" S $P(IBADD,"^",IBX)=VAOA(IBI)
	. S IBY="",IBX=1
	. I $D(^TMP("IBEMP",$J,"E",IBADDN)) F  S IBY=$O(^TMP("IBEMP",$J,"E",IBADDN,IBY)) Q:IBY=""  Q:^TMP("IBEMP",$J,"E",IBADDN,IBY)=IBADD  S IBX=IBX+1
	. S ^TMP("IBEMP",$J,"E",IBADDN)=+$G(^TMP("IBEMP",$J,"E",IBADDN))+1
	. S ^TMP("IBEMP",$J,"E",IBADDN,IBX)=IBADD
	. S ^TMP("IBEMP",$J,"E",IBADDN,IBX,VADM(1),IBDFN,IBZ)=""
	. S ^TMP("IBEMP",$J,IBDFN)=VADM(1)_"^"_$P(VADM(2),U,2)_"^"_IBAPDT_"^"_IBAPTYP_"^"_IBPELG
	. I IBZ="P" D OPD^VADPT S ^TMP("IBEMP",$J,IBDFN,IBZ)=VADM(1)_"^"_VAPD(6)_"^"_$P(IBES,"^",+VAPD(7))_"^"_$P(VADM(2),"^",2) Q
	. D GETREL^DGMTU11(DFN,IBZ,IBEND) S IBY=$G(DGREL("S"))
	. S ^TMP("IBEMP",$J,IBDFN,IBZ)=$$NAME^DGMTU1(+IBY)_"^"_$P($G(^DPT(DFN,.25)),"^",14)_"^"_$P(IBES,"^",+IBSES)_"^"_$$SSN^DGMTU1(+IBY)
PEND	K VAIP,VADM,VAEL,VAPD,VAOA,DGREL,IBINDT,IBINS,DFN,IBPELG,IBSES,IBPAT,IBADD,IBADDN,IBI,IBX,IBY,IBZ,Z
	Q
