IBAMTS1	;ALB/CPM - PROCESS NEW OUTPATIENT ENCOUNTERS ; 22-JUL-93
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
NEW	; Appointment fully processed - prepare a new charge.
	;
	I IBBILLED G NEWQ ; patient has already been billed on this date
	;
	; - for registrations, get disposition, and use log-out date/time
	I IBORG=3 D  G:'IBDISP NEWQ
	.S IBDISP=+$P($G(^TMP("SDEVT",$J,SDHDL,IBORG,"DIS",0,"AFTER")),"^",7)
	.Q:'IBDISP
	.S IBTEMP=+$P($G(^TMP("SDEVT",$J,SDHDL,IBORG,"DIS",0,"AFTER")),"^",6)
	.S:IBTEMP IBDT=IBTEMP,IBDAT=$P(IBDT,".")
	;
	I '$$BIL^DGMTUB(DFN,IBDT) G NEWQ ; patient is not Category C
	;
	; - perform batch of edits
	I '$$CHKS G NEWQ
	;
	; - quit if AO/IR/EC exposure is indicated
	D CLSF(0,.IBCLSF)
	I +IBCLSF!($P(IBCLSF,"^",2))!($P(IBCLSF,"^",4)) G NEWQ
	;
	S IBSL="409.68:"_IBOE
	;
BLD	; - build the charge. May also enter from IBAMTS2 (requires IBSL)
	S IBX="O" D TYPE^IBAUTL2 G:IBY<0 NEWQ
	S IBUNIT=1,(IBFR,IBTO)=IBDAT,IBEVDA="*"
	D ADD^IBECEAU3 G:IBY<0 NEWQ
	;
	; - if stop is exempt from classification, but patient isn't, send msg
	I IBORG=2,$$CLPT(DFN,IBDAT),$$EX^SDCOU2(+$P(IBEVT,"^",3),IBDAT) D BULL^IBAMTS
	;
	; - if the opt billing rate is over a year old, place the charge on hold
	I $$OLDRATE(IBRTED,IBFR) D  G CLOCK
	.S DIE="^IB(",DA=IBN,DR=".05////20" D ^DIE K DIE,DA,DR
	;
	; - drop the charge into the background filer
	D IBFLR G:IBY<0 NEWQ
	;
	; - if there is no active billing clock, add one
CLOCK	I '$D(^IBE(351,"ACT",DFN)) S IBCLDT=IBDAT D CLADD^IBAUTL3
	;
NEWQ	I IBY<0 D ^IBAERR1
	K IBDISP,IBCLSF,IBCLDA,IBMED,IBCLDT,IBN,IBBS,IBTEMP
	K IBUNIT,IBFR,IBTO,IBSL,IBEVDA,IBX,IBDESC,IBATYP,IBCHG
	Q
	;
CHKS()	; Perform a batch of edits to determine whether to bill.
	;  Input variables required:   IBEVT  --  encounter
	;                             IBAPTY  --  appt type
	;                              IBDAT  --  appt date
	;                               IBDT  --  appt date/time
	;                              IBORG  --  originating process
	;                             IBDISP  --  disposition (if registration)
	N Y S Y=0
	;
	; - non-count clinic
	I $P($G(^SC(+$P(IBEVT,"^",4),0)),"^",17)="Y" G CHKSQ
	;
	; - non-billable appointment type
	I $$IGN^IBEFUNC(IBAPTY,IBDAT) G CHKSQ
	;
	; - non-billable disposition/stop code/clinic
	I IBORG=1!(IBORG=2),$$NBCL^IBEFUNC(+$P(IBEVT,"^",4),IBDT) G CHKSQ
	I IBORG=2,$$NBCSC^IBEFUNC(+$P(IBEVT,"^",3),IBDT) G CHKSQ
	I IBORG=3,$$NBDIS^IBEFUNC(IBDISP,IBDT) G CHKSQ
	;
	; - ignore if checked out late and pt was an inpatient at midnight
	I DT>IBDAT,$$INPT(DFN,IBDAT_".2359") G CHKSQ
	;
	S Y=1
CHKSQ	Q Y
	;
IBFLR	; Drop the charge into the IB Background filer.
	N IBSEQNO,IBNOS,IBNOW,IBTOTL,IBSERV,IBWHER,IBFAC,IBSITE,IBAFY,IBARTYP,IBIL,IBTRAN
	D NOW^%DTC S IBNOW=%,IBNOS=IBN
	S IBSEQNO=$P($G(^IBE(350.1,+IBATYP,0)),"^",5) I 'IBSEQNO S IBY="-1^IB023"
	I IBY>0 D ^IBAFIL
	Q
	;
CLPT(DFN,VDATE)	; Should the patient be asked the classification questions?
	;  Input:     DFN  --  Pointer to the patient in file #2
	;           VDATE  --  Visit date
	N X D CL^SDCO21(DFN,VDATE,"",.X)
	Q $D(X)>0
	;
INPT(DFN,VAINDT)	; Was the patient an inpatient at VAINDT?
	;  Input:     DFN  --  Pointer to the patient in file #2
	;          VAINDT  --  Date/time to check for inpatient status
	; Output:       1 - inpatient | 0 - not an inpatient
	N VADMVT D ADM^VADPT2
	Q VADMVT>0
	;
CLSF(IBUPD,Y)	; Examine classification questions.
	;  Input:   IBUPD  --  0 if event just checked out
	;                      1 if event is being updated
	;               Y  --  array to place output
	;  Output:  indicators returned as  ao^ir^sc^ec  [1|yes, 0|no]
	;             if IBUPD=0, Y is returned as a single string
	;             if IBUPD=1, Y("BEFORE"),Y("AFTER") are defined.
	N X,ZA,ZB S:'$G(IBUPD) Y="" S:$G(IBUPD) (Y("BEFORE"),Y("AFTER"))=""
	S X=0 F  S X=$O(^TMP("SDEVT",$J,SDHDL,IBORG,"SDOE",IBOE,"CL",X)) Q:'X  S ZB=$G(^(X,0,"BEFORE")),ZA=$G(^("AFTER")) D
	.I '$G(IBUPD) S:ZA $P(Y,"^",+ZA)=+$P(ZA,"^",3) Q
	.S $P(Y("BEFORE"),"^",+ZB)=+$P(ZB,"^",3),$P(Y("AFTER"),"^",+ZA)=+$P(ZA,"^",3)
	Q
	;
OLDRATE(IBRTED,IBFR)	; See if the copay rate effective date is too old.
	;  Input:   IBRTED  --  Charge Effective Date
	;             IBFR  --  Visit Date
	;  Output:       1  --  Effective Date is too old
	;                0  --  Not
	N IBNUM,IBYR
	S IBNUM=$$FMDIFF^XLFDT(IBFR,IBRTED),IBYR=$E(IBFR,1,3)
	Q IBYR#4&(IBNUM>364)!(IBYR#4=0&(IBNUM>365))
