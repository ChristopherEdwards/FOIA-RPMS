AQAOAPA ; IHS/ORDC/LJF - ENTER NEW ACTION PLAN ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn contains code for user interface in adding a new action
 ;plan or editing one already created.
 ;
INDICATR ; >>> ask user for indicator tied to this action plan
 S AQAOIND=$$IND^AQAOLKP G EXIT:AQAOIND=U,EXIT:AQAOIND<1
 S AQAOINDN=$P(AQAOIND,U,2),AQAOIND=+AQAOIND
 ;
CATEGORY ; >>> ask user for action category to be tied to this action plan
 W !! K DIR S DIR(0)="PO^9002168.6:EMZQ"
 S DIR("A")="Select ACTION CATEGORY"
 D ^DIR G INDICATR:X="",EXIT:$D(DIRUT),CATEGORY:Y=-1
 S AQAOCT=+Y,AQAOCTN=$P(Y,U,2)
 ;
NUMBER ; >>> get new action plan number
 S AQAOAPN=$$NEWAP^AQAOCID
 I AQAOAPN="" D  G EXIT
 .W !!,"COULD NOT GENERATE ACTION PLAN #; SEE SITE MANAGER"
 W !!!,"I will create Action Plan #",AQAOAPN,":  ",AQAOCTN
 W !?40,"For INDICATOR: ",AQAOINDN,!
 ;
ASK ; >>> ask if user is sure wants to add plan
 W !! K DIR S DIR(0)="YO",DIR("B")="YES"
 S DIR("A")="ARE YOU SURE YOU WISH TO ADD THIS ACTION PLAN"
 D ^DIR G EXIT:$D(DIRUT),INDICATR:Y=0
 ;
ADDPLAN ; >>> add action plan
 K DD,DO,DIC S X=AQAOAPN,DIC="^AQAO(5,",DIC(0)=""
 S DIC("DR")=".02////"_AQAOCT_";.05////1;.08////"_DUZ_";.09////"_DT_";.12////"_DUZ(2)_";.14////"_AQAOIND
 L +(^AQAO(5,0)):1 I '$T D  G EXIT
 . W !!,*7,"CANNOT ADD; ANOTHER USER IS ADDING. TRY AGAIN.",!
 D FILE^DICN L -(^AQAO(5,0)) S AQAOPLAN=+Y
 ;
EDITPLAN ; >> drop user into editing the action plan
 W !! L +^AQAO(5,AQAOPLAN):1 I '$T D  G EXIT
 .W !!,"CANNOT EDIT; ANOTHER USER EDITING THIS ACTION PLAN.",!
 K DIE S DIE="^AQAO(5,",DA=AQAOPLAN,DR="[AQAO PLAN EDIT]" D ^DIE
 L -^AQAO(5,AQAOPLAN) G EXIT:$D(DTOUT),EXIT:$D(DUOUT)
 W !!,"ACTION PLAN CREATION COMPLETE . . ",!! G INDICATR
 ;
EXIT ; >> eoj
 D KILL^AQAOUTIL Q
 ;
 ;
EDIT ;ENTRY POINT for option to update action plan
 ;called by option AQAO ACTPLAN UPDATE
 D UPDATE^AQAOHAPL
 W !! K DIC S DIC="^AQAO(5,",DIC(0)="AEMZQ"
 S DIC("S")="I $P(^AQAO(5,Y,0),U,6)="""" D ACTCHK^AQAOSEC I $D(AQAOCHK(""OK""))"
 S DIC("A")="Enter ACTION PLAN NUMBER:  "
 D ^DIC K AQAOCHK("OK") W ! G EXIT:X="",EXIT:X=U,EDIT:Y=-1 S AQAOPLAN=+Y
 ;
 ; >> drop user into editing the action plan
 W !! L +^AQAO(5,AQAOPLAN):1 I '$T D  G EDIT
 .W !!,"CANNOT EDIT; ANOTHER USER EDITING THIS ACTION PLAN.",!
 K DIE S DIE="^AQAO(5,",DA=AQAOPLAN,DR="[AQAO PLAN EDIT]" D ^DIE
 I $G(AQAOSTAT)>2,$G(AQAOSTAT)<9 D
 .I $P(^AQAO(5,AQAOPLAN,0),U,4)]"",$P(^(0),U,4)>DT Q  ;PATCH 3
 .W !! K DIR S DIR(0)="Y",DIR("B")="YES"
 .S DIR("A")="Do you wish to CLOSE this Action Plan"
 .S DIR("?",1)="Answer YES to complete the processing of this plan."
 .S DIR("?",2)="Answer NO to allow continued editing of this plan."
 .S DIR("?",3)="Once closed, you must use the REOPEN option to edit"
 .S DIR("?",4)="it further.",DIR("?")=" "
 .D ^DIR Q:Y'=1
 .S DIE="^AQAO(5,",DA=AQAOPLAN
 .S DR=".06////"_DT_";.11////"_$P(^VA(200,DUZ,0),U) D ^DIE
 .W !!,"ACTION CLOSED!",!
 L -^AQAO(5,AQAOPLAN) G EXIT:$D(DTOUT),EXIT:$D(DUOUT)
 D PRTOPT^AQAOVAR G EDIT
