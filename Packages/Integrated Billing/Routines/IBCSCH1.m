IBCSCH1	;ALB/MRL - BILLING HELPS (CONTINUED)  ;01 JUN 88 12:00
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
	;MAP TO DGCRSCH1
	;
1	W !!,"DO YOU WISH TO ADD/EDIT INSURANCE COMPANY DATA FOR THIS PATIENT" S %=2 D YN^DICN S IBADI=$S(%=1!(%=-1):%,1:0)
	I '% W !!?4,"YES - And I'll prompt you so that you may add insurance data to the PATIENT",!?9,"file for this patient.",!?4,"NO  - To bypass this editing of the PATIENT file." G 1
	Q
	;
2	W !!,"If you updated insurance information for any policy which is already specified",!,"as either a PRIMARY, SECONDARY or TERIARY for this billing episode, you will"
	W !,"need to press the <RETURN> key through the following prompts in order to insure",!,"that these new values are properly stored.  If you fail to do so, i.e.,"
	W !,"enter an up-arrow, the new values will not be stored as part of this billing",!,"record." Q
3	I '$D(IBIFN),$D(DA) S IBIFN=DA
	W:$P(^DGCR(399,IBIFN,0),"^",5)<3 !!?4," - Enter the alphanumeric designation of your choice from",!?7,"the display (e.g. 'A1') to input one of the codes shown",!?7,"above into this billing record."
	I $P(^IBE(350.9,1,1),U,15)'=1 G 4
	S DGCODMET=$P(^DGCR(399,IBIFN,0),"^",9),DGCODMET=$S(DGCODMET=9:"ICD",DGCODMET="":"",1:"CPT")
	W !!?4," - Enter the name or code number of an ",$S($D(IBPY):"ICD DIAGNOSIS ",1:DGCODMET_" PROCEDURE "),"CODE",!?7,"not displayed above to input a ",$S($D(IBPY):"DIAGNOSIS",1:"PROCEDURE")," code"
	I $P(^DGCR(399,IBIFN,0),"^",5)>2 W "." G 4
	W " not found",!?7,"in the PTF record into this billing record, or '??' for ",!?7,"a list of all ",$S($D(IBPY):"ICD DIAGNOSIS ",1:DGCODMET_" PROCEDURE "),"CODES."
4	W !!?4," - Enter <RETURN> to accept the default ",$S($D(IBPY):"DIAGNOSIS ",1:"PROCEDURE "),"code, or",!?7,"'^' to abort.",!!
	K DGCODMET Q
