IBAMTS	;ALB/CPM - APPOINTMENT EVENT DRIVER INTERFACE ; 20-JUL-93
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
EN	; Main interface entry point.
	;
	S IBJOB=5,IBWHER="",IBDUZ=DUZ,IBY=1
	I '$$BILST^DGMTUB(DFN) G ENQ ; never Category C
	I '$$CHECK^IBECEAU(0) D ^IBAERR1 G ENQ ; can't set vital parameters
	;
	; - process all parent outpatient encounters
	S IBORG=0 F  S IBORG=$O(^TMP("SDEVT",$J,SDHDL,IBORG)) Q:'IBORG  D
	.S IBOE=0 F  S IBOE=$O(^TMP("SDEVT",$J,SDHDL,IBORG,"SDOE",IBOE)) Q:'IBOE  S IBEVT=$G(^(IBOE,0,"AFTER")),IBEV0=$G(^("BEFORE")) D
	..S IBDT=$S(IBEVT:+IBEVT,1:+IBEV0),IBDAT=$P(IBDT,".")
	..S IBAPTY=$S(IBEVT:$P(IBEVT,"^",10),1:$P(IBEV0,"^",10))
	..S IBBILLED=$$BFO^IBECEAU(DFN,IBDAT),IBY=1
	..;
	..; - if C&P encounter, cancel charges for the day and quit
	..I IBAPTY=1 D:IBBILLED  Q
	...S IBCRES=+$O(^IBE(350.3,"B","COMP & PENSION VISIT RECORDED",0))
	...S:'IBCRES IBCRES=23 S IBWHER=""
	...D CANCH^IBECEAU4(IBBILLED,IBCRES,0)
	..;
	..; - quit if there are any C&P encounters on the visit date
	..Q:$$CNP^IBECEAU(DFN,IBDAT)
	..;
	..; - don't process child events
	..I IBEVT]"" Q:$P(IBEVT,"^",6)
	..I IBEVT="",IBEV0]"" Q:$P(IBEV0,"^",6)
	..;
	..; - get statuses
	..S IBAST=+$P(IBEVT,"^",12),IBBST=+$P(IBEV0,"^",12)
	..;
	..; - do either NEW or UPDATED processing
	..I IBAST=2,IBBST'=2 D NEW^IBAMTS1 Q
	..D UPD^IBAMTS2
	;
ENQ	K IBJOB,IBWHER,IBORG,IBOE,IBEVT,IBEV0,IBAST,IBBST,IBDUZ,IBY
	K IBDT,IBDAT,IBAPTY,IBBILLED,IBSERV,IBSITE,IBFAC,IBCRES,IBRTED
	Q
	;
BULL	; Send bulletin when classified patients are billed stops which
	; are exempt from the classification process.
	N IBT,IBC,IBPT,IBDUZ S IBPT=$$PT^IBEFUNC(DFN)
	S XMSUB="CHARGE FOR STOP CODE EXEMPT FROM CLASSIFICATION"
	S IBT(1)="The following patient, who has claimed exposure to "_$$CLTY
	S IBT(2)="was billed the Means Test outpatient copay for a stop code which is"
	S IBT(3)="exempt from classification:"
	S IBT(4)=" " S IBC=4
	S IBDUZ=DUZ D PAT^IBAERR1
	S Y=IBDAT D DD^%DT
	S IBC=IBC+1,IBT(IBC)="Stop Date: "_Y
	S IBC=IBC+1,IBT(IBC)="Stop Code: "_$P($G(^DIC(40.7,+$P(IBEVT,"^",3),0)),"^")
	S IBC=IBC+1,IBT(IBC)=" "
	S IBC=IBC+1,IBT(IBC)="Please check this patient's medical record to determine if the care provided"
	S IBC=IBC+1,IBT(IBC)="was related to the claimed exposure, and, if related, cancel the charge."
	D MAIL^IBAERR1
	K X,Y,XMSUB,XMY,XMTEXT,XMDUZ
	Q
	;
CLTY()	; Return the classification type
	N X,Y D CL^SDCO21(DFN,IBDAT,"",.X) S Y=""
	I $D(X(1)) S Y="Agent Orange" G CLTYQ
	I $D(X(2)) S Y="Ionizing Radiation" G CLTYQ
	I $D(X(4)) S Y="Environmental Contaminants"
CLTYQ	Q Y_","
