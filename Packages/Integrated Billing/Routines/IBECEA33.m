IBECEA33	;ALB/CPM - Cancel/Edit/Add... More Add Utilities ; 23-APR-93
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
NOCL	; Find the correct clock from the 'bill from' date.
	N IBCLST,IBALR S IBALR=0
	I IBCLDA S IBALR=1 W !!,"The Bill From date is prior to the start of the active clock..."
	D CLSTR^IBECEAU1(DFN,IBFR)
	I 'IBCLDA D  G NOCLQ
	.I IBALR W !!,"This patient has no clock which would cover this date.  You should use the",!,"Clock Maintenance option to adjust this patient's clocks before proceeding." S IBY=-1 Q
	.W !!,"Please note that I cannot find an active or closed clock for this patient",!,"on this date.",!
	D CLDATA^IBAUTL3,DED^IBAUTL3 I IBY<0 D NODED^IBECEAU3 G NOCLQ
	I IBXA=2,$P($G(^IBE(350.1,IBATYP,0)),"^",8)'["NHCU",IBCLDAY>90 S IBMED=IBMED/2
	W !!?5,"This charge will be billed under the following closed clock:"
	W !!?6,"Begin Date: ",$$DAT1^IBOUTL(IBCLDT),"     # Inpt Days: ",IBCLDAY
	W !?5,"Closed Date: ",$$DAT1^IBOUTL($P(IBCLST,"^",10)),"     ",$$INPT^IBECEAU(IBCLDAY)," 90 Days: $",+IBCLDOL
	I IBXA=2,IBCLDOL'<IBMED S IBY=-1 W !!?5,"This patient has been billed the full copayment under this billing clock!",!?5,"You cannot add another copay charge starting on this date."
NOCLQ	Q
	;
OPT	; Check for a C&P exam and determine the outpatient copay rate.
	I $$CNP^IBECEAU(DFN,IBFR) D  I IBY<0 G OPTQ
	.N DIR,DIRUT,DUOUT,DTOUT,Y
	.W !!,"This patient had a Compensation & Pension exam on this date."
	.S DIR(0)="Y",DIR("A")="Do you still want to add a charge"
	.S DIR("?")="Enter 'Y' to continue to add the charge, or 'N' or '^' to quit"
	.D ^DIR S:'Y IBY=-1
	;
	N IBDT,IBX,IBBS S (IBDT,IBTO)=IBFR,IBX="O",IBUNIT=1,IBEVDA="*"
	D TYPE^IBAUTL2,CTBB^IBECEAU3:IBY>0
OPTQ	Q
	;
CHTYP	; Ask for the Charge Type
	S DIC="^IBE(350.1,",DIC(0)="AEMQZ",D="E",DIC("S")="I $P(^(0),U)'[""MEDICARE"",$P(^(0),U)'[""CHAMPVA SUB""",DIC("A")="Select CHARGE TYPE: "
	D IX^DIC K DIC S IBATYP=+Y I Y<0 S IBY=-1 W !!,"No CHARGE TYPE entered - transaction cannot be completed." G CHTYPQ
	;
	; - perform charge type edits
	S IBSEQNO=$P(Y(0),"^",5),IBXA=$P(Y(0),"^",11),IBNH=$P(Y(0),"^",8)["NHCU"
	I 'IBSEQNO S IBY="-1^IB023" G CHTYPQ
	I IBXA=6 G:IBCVAEL CHTYPQ W !!,"This patient does not have a Primary Eligibility of CHAMPVA.",! G CHTYP
	I 'IBCATC,IBXA'=5 W !!,"This patient has never been Category C...",!,"You may only select a Pharmacy copay charge type.",! G CHTYP
	I +IBEXSTAT,IBXA=5 W !!,"Patient is Exempt from Medication Copayment",!,$P(IBEXSTAT,"^",4),! G CHTYP
	S:IBXA=2 IBBS=$O(^DGCR(399.1,"AC",IBATYP,0))
CHTYPQ	Q
	;
CLMSG	; Check the Medicare Deductible and Billing Clock
	I 'IBMED S IBCLDT=IBFR D DED^IBAUTL3 I IBY<0 D NODED^IBECEAU3 G CLMSGQ
	I "^1^2^"[("^"_IBXA_"^"),IBCLDA,IBFR'<IBCLDT,IBCLDOL'<IBMED S IBY=-1 D
	.W !!?5,*7,"This patient has already been billed the Medicare Deductible ($",IBMED,")"
	.W !?5,"for his current 90 days of care.  If you know this not to be the case,"
	.W !?5,"please adjust the billing clock before proceeding."
CLMSGQ	Q
