IBECPTZ	;ALB/ARH - CPT TRANSFER UTILITY, KILLS FROM 350.41,LIST ERRORS; 10/22/91
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
	;external entry point
CLEAN	;removes all entries from file 350.41 - to be used during a
	;preinit in which new updates (ie 350.41) are being released
	N X
	S X=$P($G(^IBE(350.41,0)),"^",1,2) I X'="" K ^IBE(350.41) S ^IBE(350.41,0)=X
	Q
	;
	;external entry point
PURGE	;deletes entries in 350.41 that have been transfered to 350.4
	W !!,?20,"Delete Transferred Codes from the Temporary BASC File",!!
	W !!!,"This option will only delete BASC codes in the temporary file that have"
	W !,"already been transferred to the permanent BASC file."
	S DIR(0)="Y",DIR("A")="Do you want to delete transferred codes now" D ^DIR K DIR
	G:$D(DIRUT)!('Y) KEND
	W !!,"Processing, this could take some time.   Please wait...",!!
	;
	S (IBCNT,IBX)=0
	F IBI=1:1 S IBX=$O(^IBE(350.41,IBX)) Q:'IBX  S IBLN=$G(^IBE(350.41,IBX,0)) I $P(IBLN,"^",7) S DIK="^IBE(350.41,",DA=IBX D ^DIK K DIK S IBCNT=IBCNT+1
	W !!,"Done.  ",IBCNT," entries deleted from 350.41."
KEND	;
	K IBX,IBI,IBCNT,DA,IBLN,DIC,DUOUT,DTOUT,DIRUT,DIROUT,Y,X
	Q
	;
	;external entry point
LIST	;lists all update errors in 350.41,  ie. status=0 only
	D HOME^%ZIS
	W @IOF,!,?15,"Billing Ambulatory Surgery Code Update Error List",!!!
	S DIC="^IBE(350.41,",FR="0,?,?",TO="0,?,?"
	S BY="@.07,.01,.02",FLDS="[IB CPT UPDATE ERROR]" D EN1^DIP
	K DIC,FR,TO,BY,FLDS,X,Y
	Q
