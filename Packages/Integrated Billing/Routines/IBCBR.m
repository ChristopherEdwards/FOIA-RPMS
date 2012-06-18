IBCBR	;ALB/AAS - ADD/EDIT BILLING RATES FILE; 3 MAY 90
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
	;MAP TO DGCRBR
	;
	;ask date, bed section, revenue code, amount, the file.
	;     reask revenue code until null
	;     reask bed section untill null - then revenue code
	;     reask date until null .....
ADD	W ! S %DT="AEX",%DT("A")="Select BILLING RATE EFFECTIVE DATE: " D ^%DT G:Y<1 END1 S IBEFDT=+Y
	F I=0:0 D BS G:IBBS<1 ADD
	Q
BS	W ! S DIC("S")="I $P(^(0),U,5)",DIC="^DGCR(399.1,",DIC(0)="AEQM",DIC("A")="   Select BILLING BEDSECTION: " D ^DIC K DIC S IBBS=+Y Q:IBBS<1
	F J=0:0 D REV Q:IBREV<1
	Q
REV	W ! S DIC("S")="I $P(^(0),U,3)",DIC="^DGCR(399.2,",DIC(0)="AEQM",DIC("A")="      Select REVENUE CODE: " D ^DIC K DIC S IBREV=+Y Q:IBREV<1
	I $D(^DGCR(399.5,"AIVDT",IBBS,-IBEFDT,IBREV)) S DIC(0)="EMQF",X=IBEFDT,DIC="^DGCR(399.5,",DIC("S")="I $P(^(0),U,2)=IBBS,$P(^(0),U,3)=IBREV" D ^DIC K DIC D NEW:+Y<1 Q:Y<1  S DA=+Y D EDIT Q
	W !,"Filing New Entry!" D FILE,EDIT
	Q
FILE	S:'$D(DIC(0)) DIC(0)="L" S DIC="^DGCR(399.5,",X=IBEFDT,DIC("DR")=".02////"_IBBS_";.03////"_IBREV K DD,DO D FILE^DICN S DA=+Y
	Q
	;
NEW	;ask to add new entry from fast
	S Y=IBEFDT X ^DD("DD") W !?3,"ARE YOU ADDING '",Y,"' AS A NEW BILLING RATES" D YN^DICN Q:%=-1!(%=2)
	I '% W !!?3,"Enter 'YES' to add this as a new BILLING RATES",!?3,"or Enter 'NO' to not add a new entry",! G NEW
	S DIC(0)="EQL" D FILE Q
	Q
	;
EN1	;edit file entry, do lookup, then edit.
	W ! S DIC("A")="Select BEDSECTION: ",DIC="^DGCR(399.1,",DIC(0)="AEQMN",DIC("S")="I $P(^(0),U,5)" D ^DIC K DIC G:Y<1 END S IBBS=+Y D BR G EN1
	Q
BR	W ! S DIC("DR")=".02///"_IBBS,DIC("S")="I $P(^(0),U,2)=IBBS",DIC="^DGCR(399.5,",DIC(0)="AEQL" D ^DIC K DIC Q:Y<1  S DA=+Y D EDIT G BR
	;
EDIT	S (DIC,DIE)="^DGCR(399.5,",DR=".01:99" D ^DIE
	Q
	;
END1	D ENR^IBEMTO K IBRUN ; bill MT OPT charges awaiting the new copay rate
END	K I,J,X,Y,%DT,DA,DIC,DIE,DR,IBBS,IBREV,IBEFDT
	Q
	;
REDO	;re-index the aivdt x-ref in billing rates file.
	K ^DGCR(399.5,"AIVDT")
	S IBJ=0 F IBI=0:0 S IBJ=$O(^DGCR(399.5,IBJ)) Q:'IBJ  I $D(^DGCR(399.5,IBJ,0)) S X=^(0) I $P(X,"^",2)]"",$P(X,"^",3)]"" S ^DGCR(399.5,"AIVDT",$P(X,"^",2),-($P(X,"^")),$P(X,"^",3),IBJ)=""
