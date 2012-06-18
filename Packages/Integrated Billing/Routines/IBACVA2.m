IBACVA2	;ALB/CPM - BULLETINS FOR CHAMPVA BILLING ; 29-JUL-93
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
ERRMSG(IBIND)	; Process CHAMPVA Error Messages.
	;  Input:    IBIND  --  1=>billing 0=>cancelling
	K IBT S IBPT=$$PT^IBEFUNC(DFN)
	S XMSUB=$E($P(IBPT,"^"),1,14)_"  "_$P(IBPT,"^",3)_" - ERROR ENCOUNTERED"
	S IBT(1)="An error occurred while "_$S($G(IBIND):"billing",1:"cancelling")_" the CHAMPVA inpatient subsistence charge"
	S IBT(2)=$S($G(IBIND):"to",1:"for")_" the following patient:"
	S IBT(3)=" " S IBC=3
	S IBDUZ=DUZ D PAT^IBAERR1
	S Y=+DGPMA D DD^%DT
	S IBC=IBC+1,IBT(IBC)="Disc Date: "_Y
	S IBC=IBC+1,IBT(IBC)=" "
	S IBC=IBC+1,IBT(IBC)="The following error was encountered:"
	S IBC=IBC+1,IBT(IBC)=" "
	D ERR^IBAERR1
	S IBC=IBC+1,IBT(IBC)=" "
	S IBC=IBC+1,IBT(IBC)="Please review the circumstances surrounding this error and use the"
	S IBC=IBC+1,IBT(IBC)="Cancel/Edit/Add Patient Charges' option to bill or cancel any necessary"
	S IBC=IBC+1,IBT(IBC)="charges."
	D SEND
	Q
	;
ADM	; Send a bulletin when CHAMPVA patients are admitted.
	K IBT S IBPT=$$PT^IBEFUNC(DFN)
	S XMSUB=$E($P(IBPT,"^"),1,14)_"  "_$P(IBPT,"^",3)_" - CHAMPVA PATIENT"
	S IBT(1)="The following CHAMPVA patient has been admitted:"
	S IBT(2)=" ",IBC=2
	S IBDUZ=DUZ D PAT^IBAERR1
	S Y=+DGPMA D DD^%DT
	S IBC=IBC+1,IBT(IBC)=" Adm Date: "_Y
	S IBC=IBC+1,IBT(IBC)=" "
	S IBC=IBC+1,IBT(IBC)="This patient will be automatically billed the CHAMPVA inpatient"
	S IBC=IBC+1,IBT(IBC)="subsistence charge when discharged."
	D SEND
	Q
	;
WARN(IBB,IBE)	; Send bulletins when discharges are edited or deleted.
	;  Input:    IBB  --  Discharge date before edit
	;            IBE  --  Discharge date after edit
	K IBT S IBPT=$$PT^IBEFUNC(DFN)
	S XMSUB=$E($P(IBPT,"^"),1,14)_"  "_$P(IBPT,"^",3)_" - DISCHARGE CHANGED"
	S IBT(1)="A discharge was "_$S($G(IBB):"edited",1:"deleted")_" for the following CHAMPVA patient:"
	S IBT(2)=" " S IBC=2
	S IBDUZ=DUZ D PAT^IBAERR1
	S IBC=IBC+1,IBT(IBC)=" "
	I $G(IBB) D
	.S Y=IBB D DD^%DT S IBC=IBC+1,IBT(IBC)="Prev Discharge Date: "_Y
	.S Y=IBE D DD^%DT S IBC=IBC+1,IBT(IBC)=" New Discharge Date: "_Y
	.S IBC=IBC+1,IBT(IBC)=" "
	S IBC=IBC+1,IBT(IBC)="Please review the circumstances surrounding these movement changes,"
	S IBC=IBC+1,IBT(IBC)="and use the 'Cancel/Edit/Add Patient Charges' option to bill or cancel"
	S IBC=IBC+1,IBT(IBC)="any necessary charges."
	D SEND
	Q
	;
SEND	; Send bulletin to recipients of the Means Test billing mailgroup.
	D MAIL^IBAERR1
	K IBC,IBT,IBPT,XMSUB,XMY,XMTEXT,XMDUZ
	Q
	;
ON()	; Is the CHAMPVA billing module fully installed?
	N X S X=+$O(^IBE(350.1,"E","CHAMPVA SUBSISTENCE",0))
	Q +$P($G(^IBE(350.1,X,0)),"^",3)
