AQAOENTS ; IHS/ORDC/LJF - CREATE OCC FROM SEARCH TEMPL ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn is called by ^AQAOENTR if the user chose to create occ
 ;from a visit-based search template.  The user is asked for the
 ;template name and indicator.  Then it loops through all entries in
 ;the template, asking for occ date for each one as it creates 
 ;occurrences.  The case ID name is displayed for each.
 ;
 W !!!,"CREATE OCCURRENCES FROM A VISIT SEARCH TEMPLATE",!!
TEMP ; >>> ask user for search template name
 K DIC S DIC="^DIBT(",DIC(0)="AEMQZ"
 S DIC("S")="I $P(^DIBT(Y,0),U,4)=9000010,$D(^DIBT(Y,1))" ;visit scrn
 S DIC("?")="Must be a search template created on the Visit file!"
 D ^DIC G EXIT:$D(DTOUT),EXIT:$D(DUOUT),EXIT:X="",TEMP:Y=-1
 S AQAOTMP=+Y ;search template ifn
 ;
IND ; >>> ask user to select indicator
 S Y=$$IND^AQAOLKP ;ask user to select an indicator for all visits
 S AQAOIN=$S(Y>0:+Y,1:"")
 I AQAOIN="" D  I Y'=1 G IND
 .W !!,"You have not selected an indicator"
 .W !,"This means you must enter the indicator for each template entry."
 .K DIR S DIR(0)="Y",DIR("B")="NO"
 .S DIR("A")="Do you wish to continue" D ^DIR
 ;
 W !!,"I will take all entries from the search template "
 W $P(^DIBT(AQAOTMP,0),U)
 W !,"and create occurrences for indicator "
 W $S(AQAOIN="":"you select as each is entered.",1:$P(^AQAO(2,AQAOIN,0),U))
 K DIR S DIR(0)="Y",DIR("B")="YES",DIR("A")="Is this correct" D ^DIR
 I Y'=1 G TEMP
 ;
LOOP ; >>> loop thru template entries and create occ
 S AQAOV=0,AQAOSTOP=""
 F  S AQAOV=$O(^DIBT(AQAOTMP,1,AQAOV)) Q:AQAOV=""  Q:AQAOSTOP=U  D
 .W !! S L=0,DIC="^AUPNVSIT(",FLDS="[AQAO VISIT DATA]",BY="@NUMBER"
 .S (TO,FR)=AQAOV,DHD="@@",IOP="HOME" D EN1^DIP
 .S X=$P(^AUPNVSIT(AQAOV,0),U),X=$$FMTE^XLFDT($P(X,"."),1) ;PATCH 2
 .S AQAODATE=$$OCCDT^AQAOLKP(X) Q:AQAODATE=""  ;ask for occ dt;PATCH 2
 .I $D(DIRUT)!(X=U) S AQAOSTOP=U Q
 .S AQAOIND=$S(AQAOIN="":$$IND^AQAOLKP,1:AQAOIN) Q:AQAOIND=""  ;ask ind
 .I $D(DIRUT)!(X=U) S AQAOSTOP=U Q
 .S AQAOPAT=$P(^AUPNVSIT(AQAOV,0),U,5) Q:AQAOPAT=""  ;pat dfn
 .D ^AQAOENTQ
 .I $D(DIRUT)!(X=U) S AQAOSTOP=U Q
 .I $D(AQAO) W !!,"Okay, I won't add another occurrence for this visit" Q
 .K AQAOIFN D CREATE^AQAOLKP Q:'$D(AQAOIFN)  ;create occ
 .S DIE="^AQAOC(",DA=AQAOIFN,DR=".03////"_AQAOV D ^DIE ;stuff visit
 .K DIR S DIR(0)="E",DIR("A")="Press RETURN to continue" D ^DIR
 .I Y=0 S AQAOSTOP=U
 ;
 ;
EXIT ; >>> eoj
 D KILL^AQAOUTIL Q
