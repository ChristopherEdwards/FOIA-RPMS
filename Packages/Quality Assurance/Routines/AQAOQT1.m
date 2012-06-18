AQAOQT1 ; IHS/ORDC/LJF - BRAINSTORMING & MULTIVOTING ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn is main driver for brainstorming & multivoting tool.
 ;
MENU ; >>> dir call for menu
 D INTRO^AQAOHQIT
 K DIR S DIR(0)="SO^1:GENERAL INFO;2:BRAINSTORMING SESSION;3:MULTIVOTING;4:REPORTS"
 S DIR("?")="Select one the the FUNCTIONS listed or press RETURN to exit"
 S DIR("A")="     Select Option" D ^DIR
 G EXIT:$D(DIRUT),MENU:Y=-1
 ;
 ; >>> call rtn for user's selection
 S AQAOPT=$S(Y=1:"MTG",Y=2:"BRAIN",Y=3:"MULTIV",1:"REPORT")
 D @AQAOPT G MENU
 ;
 ;
EXIT ; >>> eoj
 D ^%ZISC D KILL^AQAOUTIL Q
 ; >>>> END OF MAIN SECTION OF RTN <<<<
 ;
 ;
 ;
MTG ; >>> SUBRTN to enter mtg info <<<
 W !! K DIC S DIC="^AQAO1(8,",DIC(0)="AEMQZL",DLAYGO=9002169
 S DIC("S")=$$DICS D ^DIC K DLAYGO
 Q:$D(DTOUT)  Q:$D(DUOUT)  Q:X=""  Q:Y=-1  S AQAOMTG=+Y
 W !! K DIE S DIE="^AQAO1(8,",DA=AQAOMTG,DR="[AQAO QIT MTG]"
 D ^DIE
 Q
 ;
 ;
BRAIN ;ENTRY POINT >>> SUBRTN for brainstorming session <<<
 W !!?20,"*** BRAINSTORMING SESSION ***"
 ; >>> find meeting entry # and display team and date/time
 I '$D(AQAOMTG) D
 .W !! K DIC S DIC="^AQAO1(8,",DIC("A")="Select SESSION DATE/TIME:  "
 .S DIC(0)="AEMZQ",DIC("S")=$$DICS D ^DIC I Y>0 S AQAOMTG=+Y
 I '$D(AQAOMTG) W !!,"NO SESSION SELECTED" D MTG Q:'$D(AQAOMTG)
 W !!?2,"QI TEAM:  ",$P(^AQAO1(1,$P(^AQAO1(8,AQAOMTG,0),U,2),0),U)
 W !,"DATE/TIME:  " S Y=$P(^AQAO1(8,AQAOMTG,0),U) X ^DD("DD") W Y
 W !?4,"TOPIC:  ",$P(^AQAO1(8,AQAOMTG,0),U,3)
 ;
 ; >>> choose next action; call SUBRTNS
CHOOSE K DIR S DIR("A")="     Select NEXT ACTION"
 S DIR(0)="SO^1:ADD IDEAS;2:LIST IDEAS;3:CATEGORIZE IDEAS;4:EDIT/DELETE IDEAS"
 D ^DIR Q:$D(DIRUT)
 S AQAOPT1=$S(Y=1:"IDEAS",Y=2:"LIST",Y=3:"CATEGORY",1:"EDIT")
 S AQAOPT1=AQAOPT1_"^AQAOQT11" D @AQAOPT1 G CHOOSE
 ;
 ;
MULTIV ; >>> SUBRTN to handle multivoting session <<<
 K AQAOAR1 W !!?20,"*** MULTIVOTING SESSION ***"
 ; >>> find meeting entry # and display team and date/time
 I '$D(AQAOMTG) D
 .W !! K DIC S DIC="^AQAO1(8,",DIC("A")="Select SESSION DATE/TIME:  "
 .S DIC(0)="AEMZQ",DIC("S")=$$DICS D ^DIC I Y>0 S AQAOMTG=+Y
 I '$D(AQAOMTG) D  Q:'$D(AQAOMTG)
 .W !!,"NO BRAINSTORMING SESSION SELECTED" D MTG
 ;
 W !!?2,"QI TEAM:  ",$P(^AQAO1(1,$P(^AQAO1(8,AQAOMTG,0),U,2),0),U)
 W !,"DATE/TIME:  " S Y=$P(^AQAO1(8,AQAOMTG,0),U) X ^DD("DD") W Y
 W !?4,"TOPIC:  ",$P(^AQAO1(8,AQAOMTG,0),U,3)
 I '$O(^AQAO1(7,"AC",AQAOMTG,0)) W !!,"NO IDEAS ENTERED!",!! Q
 ;
 ;  choose next action; call SUBRTNS
CHOOSE1 K DIR S DIR("A")="     Select NEXT ACTION"
 S DIR(0)="SO^1:LIST CATEGORIES;2:VOTE;3:VIEW VOTING RESULTS"
 D ^DIR Q:$D(DIRUT)
 S AQAOPT1=$S(Y=1:"LIST",Y=2:"VOTE",1:"RESULTS")
 S AQAOPT1=AQAOPT1_"^AQAOQT12" D @AQAOPT1 G CHOOSE1
 ;
 ;
REPORT ; >>> SUBRTN to print results of brainstorming session <<<
 W @IOF,!?20,"*** REPORT RESULTS OF BRAINSTORMING SESSION ***"
 ;  find meeting entry # and display team and date/time
 I '$D(AQAOMTG) W !! K DIC S DIC="^AQAO1(8,",DIC("A")="Select SESSION DATE/TIME:  ",DIC(0)="AEMZQ",DIC("S")=$$DICS D ^DIC I Y>0 S AQAOMTG=+Y
 I '$D(AQAOMTG) W !!,"NO SESSION SELECTED" D MTG Q:'$D(AQAOMTG)
 W !!?2,"QI TEAM:  ",$P(^AQAO1(1,$P(^AQAO1(8,AQAOMTG,0),U,2),0),U)
 W !,"DATE/TIME:  " S Y=$P(^AQAO1(8,AQAOMTG,0),U) X ^DD("DD") W Y
 W !?4,"TOPIC:  ",$P(^AQAO1(8,AQAOMTG,0),U,3)
 ;
 ;  choose next action; call SUBRTNS
CHOOSE2 K DIR S DIR("A")="     Select REPORT TYPE"
 S DIR(0)="SO^1:MULTIVOTING RESULTS ONLY;2:FULL REPORT ON BRAINSTORMING SESSION"
 D ^DIR Q:$D(DIRUT)
 S AQAOPT1=$S(Y=1:"RESULTS",1:"FULL")_"^AQAOQT13"
 ;
DEV ;ENTRY POINT  get print device
 W !! S %ZIS="QP" D ^%ZIS Q:POP
 I '$D(IO("Q")) U IO D @AQAOPT1 Q
 K IO("Q") S ZTRTN=AQAOPT1,ZTDESC="QI TOOLS REPORT"
 F I="AQAOPT1","AQAOMTG" S ZTSAVE(I)=""
 D ^%ZTLOAD K ZTSK D ^%ZISC
 Q
 ;
DICS() ;EXTR VAR to set dic(s) on brainstorm session lookup
 ;sessions are secured by membership in QI teams
 N X
 S X="I ($P(AQAOUA(""USER""),U,6)[""Q"")!($D(^AQAO(9,DUZ,""TM"",""B"",$P(^AQAO1(8,Y,0),U,2))))"
 Q X
