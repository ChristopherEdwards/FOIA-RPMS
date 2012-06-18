GMPLISRV	; SLC/MKB -- Problem List Service file utility ;8/26/93  16:30
	;;2.0;Problem List;;Aug 25, 1994
EN	; Main entry point
	;W !!!?5,"***  Please update your Service File (#49) at this time  ***"
	N X D HELP,NOTE
EN1	I $D(^DIC(49,"F")) S DIR(0)="E" D ^DIR G:'Y ENQ W @IOF D CURRENT
	F  D  Q:$D(GMPDONE)!($D(GMPQUIT))
	. R !,"Select CLINICAL SERVICE: ",X:DTIME
	. I '$T!(X["^") S GMPQUIT=1 Q
	. I X="" S GMPDONE=1 Q
	. I X="?" D HELP,CURRENT Q
	. I X["??" D HELP H 3 D LISTALL Q
	. I X?1"-".E D REMOVE Q
	. D ADD
ENQ	K GMPSERV,GMPDONE,GMPQUIT,GMPRMOVE
	Q
	;
HELP	; Write [introductory] help text
	W !!?10,"Please designate those services that are clinical, that are"
	W !?10,"directly involved in patient care, by entering them below."
	W !?10,"If you select a 'parent' service, you will have the option"
	W !?10,"to automatically mark all of its sub-services as well."
	W !?10,"To de-select a service as clinical, enter the name of the"
	W !?10,"service preceded by a minus sign (-)."
	Q
	;
NOTE	; Display additional note
	W !!,?10,"NOTE:"
	W !?10,"Problems will be assigned a category based upon the service"
	W !?10,"of the clinician responsible for entering and/or treating"
	W !?10,"them; ONLY clinical services will be allowed.  The problem"
	W !?10,"list may then be searched or displayed according to the"
	W !?10,"desired discipline.",!!
	Q
	;
CURRENT	; Display currently designated clinical services, in GMPSERV()
	N DIC,D,DZ W !!,"CURRENTLY SELECTED CLINICAL SERVICES"
	S DIC="^DIC(49,",DIC(0)="E",DIC("S")="I $P(^(0),U,9)=""C"""
	S D="B",DZ="??" D DQ^DICQ
	Q
	;
LISTALL	; Display all entries in the Service file
	N DIC,D,DZ W !!,"ALL "_$P($G(^DIC(4,+$G(DUZ(2)),0)),U)_" SERVICES"
	S DIC="^DIC(49,",DIC(0)="E",D="B",DZ="??"
	D DQ^DICQ
	Q
	;
CKPG	; Check paging
	N DIR,X,Y
	I $Y>(IOSL-4) S DIR(0)="E" D ^DIR S:'Y GMPQUIT=1
	Q
	;
REMOVE	; Delete clinical flag
	N DIC,DR,DA,DIE
	S X=$E(X,2,999),DIC="^DIC(49,",DIC(0)="EQM" D ^DIC Q:Y<0
	S DA=+Y,DIE=DIC,DR="1.7////@" D ^DIE
	W ?50,"... Clinical flag removed",!
	Q
	;
ADD	; Add clinical flag to service
	N DIC,DR,DA,DIE,GMPIFN
	S DIC="^DIC(49,",DIC(0)="EQM" D ^DIC Q:Y<0
	S DA=+Y,DIE=DIC,DR="1.7////C" D ^DIE
	W " ... Clinical flag added",!
	Q:'$D(^DIC(49,"ACHLD",DA))  ; not a parent service
	W !,$P(^DIC(49,DA,0),U)_" has the following sub-services: " S GMPIFN=DA
	F I=0:0 S I=$O(^DIC(49,"ACHLD",GMPIFN,I)) Q:I'>0  W !?3,$P(^DIC(49,I,0),U)
	Q:'$$INCLCHLD^GMPLPRF1(GMPIFN)  ; don't include sub-services
	F I=0:0 S I=$O(^DIC(49,"ACHLD",GMPIFN,I)) Q:I'>0  D
	. S DA=I,DR="1.7////C" D ^DIE
	. W !?3,$P(^DIC(49,I,0),U)_" ... Clinical flag added"
	W !
	Q
