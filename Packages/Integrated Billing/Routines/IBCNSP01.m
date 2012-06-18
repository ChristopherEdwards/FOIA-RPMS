IBCNSP01	;ALB/AAS - INSURANCE MANAGEMENT - EXPANDED POLICY  ; 05-MAR-1993
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
	;
%	D SUBSC,VER,RIDER
	Q
	;
SUBSC	; -- subscriber region
	N OFFSET,START
	S START=15,OFFSET=2
	D SET^IBCNSP(START,OFFSET," Subscriber Information ",IORVON,IORVOFF)
	S Y=$P(IBCDFND,"^",6),C=$P(^DD(2.312,6,0),"^",2) D Y^DIQ
	D SET^IBCNSP(START+1,OFFSET," Whose Insurance: "_Y)
	D SET^IBCNSP(START+2,OFFSET," Subscriber Name: "_$P(IBCDFND,"^",17))
	S Y=$P(IBCDFND,"^",16),C=$P(^DD(2.312,16,0),"^",2) D Y^DIQ
	D SET^IBCNSP(START+3,OFFSET,"    Relationship: "_Y)
	D SET^IBCNSP(START+4,OFFSET,"Insurance Number: "_$P(IBCDFND,"^",2))
	S Y=$P(IBCDFND,"^",20),C=$P(^DD(2.312,.2,0),"^",2) D Y^DIQ
	D SET^IBCNSP(START+5,OFFSET,"Coord.  Benefits: "_Y)
	Q
	;
VER	; -- Entered/Verfied Region
	N OFFSET,START
	S START=22,OFFSET=2
	D SET^IBCNSP(START,OFFSET," User Information ",IORVON,IORVOFF)
	I IBCDFND1="" D SET^IBCNSP(START+1,OFFSET,"No User Information") G VERQ
	D SET^IBCNSP(START+1,OFFSET,"      Entered By: "_$E($P($G(^VA(200,+$P(IBCDFND1,"^",2),0)),"^",1),1,20))
	D SET^IBCNSP(START+2,OFFSET,"      Entered On: "_$$DAT1^IBOUTL(+IBCDFND1))
	D SET^IBCNSP(START+3,OFFSET,"Last Verified By: "_$E($P($G(^VA(200,+$P(IBCDFND1,"^",4),0)),"^",1),1,20))
	D SET^IBCNSP(START+4,OFFSET,"Last Verified On: "_$$DAT1^IBOUTL(+$P(IBCDFND1,"^",3)))
	D SET^IBCNSP(START+5,OFFSET," Last Updated By: "_$E($P($G(^VA(200,+$P(IBCDFND1,"^",6),0)),"^",1),1,20))
	D SET^IBCNSP(START+6,OFFSET," Last Updated On: "_$$DAT1^IBOUTL(+$P(IBCDFND1,"^",5)))
VERQ	Q
	;
RIDER	; -- Personal policy riders
	N OFFSET,START,IBI,IBL
	S START=34+$G(IBLCNT),OFFSET=2
	D SET^IBCNSP(START,OFFSET," Personal Riders ",IORVON,IORVOFF)
	S IBI="" F  S IBI=$O(^IBA(355.7,"APP",DFN,IBCDFN,IBI)) Q:'IBI  S IBPR=$O(^(IBI,0)),IBPRD=+$G(^IBA(355.7,IBPR,0)) D
	.S IBL=$G(IBL)+1
	.D SET^IBCNSP(START+IBL,OFFSET,"   Rider #"_IBL_": "_$$EXPAND^IBTRE(355.7,.01,IBPRD))
	Q
	;
AI	; -- Add ins. verification entry
	;    called from ai^ibcnsp1
	;N X,Y,I,J,DA,DR,DIC,DIE,DR,DD,DO,VA,VAIN,VAERR,IBQUIT,IBXIFN,IBTRN,DUOUT,IBX,IBQUIT,DTOUT
	;Q:'$G(DFN)
	;Q:'$G(IBCDFN)  S IBQUIT=0
	;
	; -- see if current inpatient
	D INP^VADPT I +VAIN(1) D
	.S IBTRN=$O(^IBT(356,"AD",+VAIN(1),0))
	;
	S IBXIFN=$O(^IBE(356.11,"ACODE",85,0))
	;
	; -- if not tracking id allow selecting
	I '$G(IBTRN) D  G:IBQUIT AIQ
	.W !,"You can now enter a contact and relate it to a Claims Tracking Admission entry."
	.S DIC("A")="Select RELATED ADMISSION DATE: "
	.S DIC="^IBT(356,",DIC(0)="AEQ",D="ADFN"_DFN,DIC("S")="I $P(^(0),U,5)"
	.D IX^DIC K DA,DR,DIC,DIE I $D(DUOUT)!($D(DTOUT)) S IBQUIT=1 Q
	.I +Y>1 S IBTRN=+Y
	;
	I '$G(IBTRN) W !!,"Warning: This contact is not associated with any care in Claims Tracking.",!,"You may only edit or view this contact using this action.",!
	;
	; -- select date
	S IBOK=0,IBI=0 F  S IBI=$O(^IBT(356.2,"D",DFN,IBI)) Q:'IBI  I $P($G(^IBT(356.2,+IBI,0)),"^",4)=IBXIFN,$P($G(^(1)),"^",5)=IBCDFN S IBOK=1
	I IBOK D  G:IBQUIT AIQ
	.S DIC="^IBT(356.2,",DIC("A")="Select Contact Date: "
	.S X="??",DIC(0)="EQ",DIC("S")="I $P($G(^(1)),U,5)=IBCDFN,$P(^(0),U,4)=IBXIFN" ;,DLAYGO=356.2
	.S D="ADFN"_DFN
	.D IX^DIC K DIC,DR,DA,DIE,D I $D(DUOUT)!($D(DTOUT)) S IBQUIT=1
	;
	S DIC="^IBT(356.2,",DIC("A")="Select Contact Date: ",DIC("B")="TODAY"
	S DIC("DR")=".02////"_$G(IBTRN)_";.04////"_IBXIFN_";.05////"_DFN_";.19////1;1.01///NOW;1.02////"_DUZ_";1.05////"_IBCDFN
	S DIC(0)="AEQL",DIC("S")="I $P(^(0),U,5)=DFN,$P($G(^(1)),U,5)=IBCDFN,$P(^(0),U,4)=IBXIFN",DLAYGO=356.2
	D ^DIC K DIC
	I $D(DTOUT)!($D(DUOUT))!(+Y<1) G AIQ
	S IBTRC=+Y
	I $G(IBTRC),$G(IBTRN),'$P(^IBT(356.2,+IBTRC,0),"^",2) S DA=IBTRC,DIE="^IBT(356.2,",DR=".02////"_$G(IBTRN) D ^DIE
	;
	; -- edit ins ver type
	D EDIT^IBTRCD1("[IBT INS VERIFICATION]",1)
AIQ	Q
