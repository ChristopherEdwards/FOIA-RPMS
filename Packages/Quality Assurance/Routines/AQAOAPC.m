AQAOAPC ; IHS/ORDC/LJF - REOPEN CLOSED ACTION PLANS ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn contains code for reopening a closed or deleted action
 ;plan.  An action plan is closed or deleted in rtn ^AQAOAPA during
 ;the edit action plan process.
 ;
 Q
 ;
EXIT ; >> eoj
 D KILL^AQAOUTIL Q
 ;
 ;
REOPEN ;ENTRY POINT for option to reopen a closed action plan
 ;called by option AQAO ACTPLAN REOPEN
 ;
 ; >>> ask user to select an action plan to reopen
 W !! K DIC S DIC="^AQAO(5,",DIC(0)="AEMZQ",AQAOINAC=""
 S DIC("S")="D ACTCHK^AQAOSEC I $D(AQAOCHK(""OK""))"
 S DIC("A")="Enter ACTION PLAN NUMBER:  "
 D ^DIC K AQAOCHK("OK") W ! G EXIT:X="",EXIT:X=U,REOPEN:Y=-1
 S AQAOPLAN=+Y K AQAOINAC
 ;
 ; >>> drop user into editing the action plan
 W !! L +^AQAO(5,AQAOPLAN):1 I '$T D  G REOPEN
 .W !!,"CANNOT REOPEN; ANOTHER USER HAS ENTRY LOCKED. TRY AGAIN!",!
 K DIE S DIE="^AQAO(5,",DA=AQAOPLAN,DR="[AQAO ACT REOPEN]" D ^DIE
 L -^AQAO(5,AQAOPLAN) G EXIT:$D(DTOUT),EXIT:$D(DUOUT),REOPEN
 ;
 ;
 ;
MSG1 ;ENTRY POINT for message on deleted plans
 ;called by input template AQAO ACT REOPEN
 W !!,"CANNOT REOPEN DELETED ACTION PLAN!!"
 W !!,"USE UPDATE OPTION TO CHANGE PLAN STATUS TO OTHER THAN DELETED!"
 W ! Q
 ;
 ;
 ;
MSG2 ;ENTRY POINT for message about reopening action plan
 ;called by input template AQAO ACT REOPEN
 W !!,"REOPENING ACTION PLAN . . ."
 W !,"DELETING DATE CLOSED . . ."
 W !,"DELETING CLOSED OUT BY . . ."
 W !,"ACTION PLAN IS NOW AVAILABLE FOR EDITING.  USE UPDATE OPTION."
 W ! Q
 ;
 ;
 ;
MSG3 ;ENTRY POINT for messge that plan is not a closed one
 ;called by input template AQAOACT REOPEN
 W !!,"This Action Plan is NOT CLOSED.  No need to reopen.",! Q
