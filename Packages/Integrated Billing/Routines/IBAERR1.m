IBAERR1	;ALB/CPM - INTEGRATED BILLING ERROR PROCESSING ROUTINE (CON'T) ; 03-JAN-92
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
	; This routine will be used to send mail messages when errors
	; have occurred during the processing of Means Test/Category C
	; charges.
	;  Input:  IBJOB = 1  Nightly Compilation job
	;                  2  Discharge job
	;                  4  Add/Edit/Cancel Charges
	;                  5  Appointment Event Driver
	;                  7  Means Test Event Driver
	;                  8  OPT Billing Update
	;          DFN {opt}, IBDUZ, IBY, IBWHER
	;
	N IBSTART K IBT
	I $D(DFN)#2 S IBPT=$$PT^IBEFUNC(DFN)
	S XMSUB=$S($D(IBPT)#2:$E($P(IBPT,"^"),1,14)_"  "_$P(IBPT,"^",3)_" -",1:"CATEGORY C BILLING")_" ERROR ENCOUNTERED"
	S IBT(1)="An error has been encountered while processing Means Test/Category C charges"
	S IBT(2)="during the "_$S(IBJOB=1:"Nightly Compilation job",IBJOB=2:"Discharge job",IBJOB=4:"Cancel/Edit/Add Option",IBJOB=5:"Check Out job",IBJOB=7:"Means Testing",1:"OPT Billing Update")_" for the following patient:"
	S IBT(3)=" ",IBC=3
	D PAT
	S IBC=IBC+1,IBT(IBC)=" "
	S IBC=IBC+1,IBT(IBC)="The Means Test/Category C billing history for this patient must be reviewed."
	S IBC=IBC+1,IBT(IBC)="The following error was encountered:"
	S IBC=IBC+1,IBT(IBC)=" "
	S:IBJOB=4 IBSTART=IBC D ERR
	S IBC=IBC+1,IBT(IBC)=" "
	S IBM=$P($T(TEXT+IBWHER^IBAMTEL),";;",2,99),IBC=IBC+1
	S:$L(IBM)<80 IBT(IBC)=IBM
	I $L(IBM)>79 S IBB=$E(IBM,1,79),IBT(IBC)=$P(IBB," ",1,$L(IBB," ")-1),IBC=IBC+1,IBT(IBC)=$P(IBM," ",$L(IBB," "),999)
	I IBJOB=4 F IBI=IBSTART:1:IBC W !,IBT(IBI)
	D MAIL K IBT,IBM,IBB,IBC,IBPT,XMSUB,XMY,XMTEXT,XMDUZ
	Q
	;
PAT	; Set up patient demographic and user data for message.
	S IBC=IBC+1,IBT(IBC)="  Patient: "_$S($D(IBPT)#2:$P(IBPT,"^")_"          Pt. ID: "_$P(IBPT,"^",2),1:"Not Defined")
	S IBC=IBC+1,IBT(IBC)="     User: "_$P($G(^VA(200,+IBDUZ,0)),"^")
	Q
	;
ERR	; Set up error message text.
	S X2=$P(IBY,"^",2) F K=1:1 S X=$P(X2,";",K) Q:X=""  D
	. S X1=$O(^IBE(350.8,"AC",X,0)),IBC=IBC+1
	. S IBT(IBC)=" "_$S($D(^IBE(350.8,+X1,0)):$P(^(0),"^",2),X]"":X,1:"Unknown Error")
	I $P(IBY,"^",3)]"" S IBC=IBC+1,IBT(IBC)=" "_$P(IBY,"^",3)
	K X,X1,X2 Q
	;
MAIL	; Transmit.
	N IBI,IBGRP S XMDUZ="INTEGRATED BILLING PACKAGE",XMTEXT="IBT("
	K XMY
	;S IBGRP=$P($G(^IBE(350.9,1,0)),"^",11)
	;F IBI=0:0 S IBI=$O(^XMB(3.8,+IBGRP,1,"B",IBI)) Q:'IBI  S XMY(IBI)=""
	S IBGRP=$P($G(^XMB(3.8,+$P($G(^IBE(350.9,1,0)),"^",11),0)),"^")
	I IBGRP]"" S XMY("G."_IBGRP_"@"_^XMB("NETNAME"))=""
	D ^XMD
	Q
