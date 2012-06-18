AMHRL01 ; IHS/CMI/LAB - TUCSON-OHPRD/LAB - SCREEN LOGIC ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
 ;
INFORM ;EP
 S AMHTCW=0
 W:$D(IOF) @IOF
 I AMHPTVS="S" D SUIN
 I AMHPTVS'="S" D
 .S AMHLHDR="BEHAVIORAL HEALTH ENCOUNTER GENERAL RETRIEVAL"
 .W ?((80-$L(AMHLHDR))/2),AMHLHDR
 .W !!!,"This report will produce a listing of "_AMHPTTX_"s selected by the",!,"user.  "
 .W "The ",AMHPTTX,"s printed can be selected based on any combination of",!,"items.  The user will select these items.  The items printed on the report",!
 .W "are also selected by the user.",!!,"If selected print data items exceed 80 characters, a 132-column capacity",!,"printer will be needed.",!!
 S (AMHPCNT,AMHPTCT)=0 ;AMHPTCT -- pt total for # of "V"isits
 K AMHRDTR,AMHBDD,AMHBD,AMHEDD,AMHED
 S AMHXREF=$S(AMHPTVS="V":"C",AMHPTVS="P":"PO",1:"SU")
 K AMHTYPE ;--- just in case variable left around
 I AMHPTVS="V" D DBHUSR^AMHUTIL
 I AMHPTVS="P"!(AMHPTVS="S"),$D(^AMHBHUSR(DUZ)),$O(^AMHBHUSR(DUZ,11,0)) D
 .W !!,$G(IORVON),"Please note:",$G(IORVOFF),"  Only patients who have HRN's at the following "
 .W !?15,"locations will be included in this report:"
 .S X=0 F  S X=$O(^AMHBHUSR(DUZ,11,X)) Q:X'=+X  W !?15,$P(^DIC(4,X,0),U)
 .W !!
 .K DIR S DIR(0)="E",DIR("A")="Press return to continue" D ^DIR K DIR
 Q
 ;
SUIN ;
 W !!,"SGR Listing of Suicide Forms by Selected Variables"
 W !!,"This report is a 'general retrieval' type report and will list the"
 W !,"data items selected by the user for Suicide Forms in a date range."
 W !,"The user can also specify how to display the items in the printed"
 W !,"report.",!
 Q
ADD ;EP
 K AMHCAND
 W !!
 I $D(AMHSEAT),'$D(AMHEP1) G ADD1
 I AMHPTVS="S" G ADD1
 S DIR(0)="Y",DIR("A")="Do you want to use a PREVIOUSLY DEFINED REPORT",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) S AMHQUIT=1 Q
 I 'Y G ADD1
 S DIC="^AMHTRPT(",DIC("S")="I $P(^(0),U,2)&($P(^(0),U,6)=AMHPTVS)" S:$D(AMHEP1) DIC("S")=DIC("S")_"&($P(^(0),U,9)=AMHPACK)" S DIC(0)="AEQ",DIC("A")="REPORT NAME:  ",D="C" D IX^DIC K DIC,DA,DR
 I Y=-1 S AMHQUIT=1 Q
 S AMHRPT=+Y,AMHCAND=1
 ;--- set up sorting and report control variables
 S AMHSORT=$P(^AMHTRPT(AMHRPT,0),U,7),AMHSORV=$P(^(0),U,8),AMHSPAG=$P(^(0),U,4),AMHCTYP=$P(^(0),U,5)
 S X=0 F  S X=$O(^AMHTRPT(AMHRPT,12,X)) Q:X'=+X  S AMHTCW=AMHTCW+$P(^AMHTRPT(AMHRPT,12,X,0),U,2)+2
 Q
ADD1 ;
 ;CREATE REPORT ENTRY IN FILEMAN FILE
 S %H=$H D YX^%DTC S X=$P(^VA(200,DUZ,0),U)_"-"_Y,DIC(0)="L",DIC="^AMHTRPT(",DLAYGO=9002013.8,DIADD=1 D ^DIC K DIC,DA,DR,DIADD,DLAYGO I Y=-1 W !!,"UNABLE TO CREATE REPORT FILE ENTRY - NOTIFY SITE MANAGER!" S AMHQUIT=1 Q
 S AMHRPT=+Y
 K DIC,DIADD,DLAYGO,DR,DA,DD,X,Y,DINUM
 ;DELETE ALL 11 MULTIPLE HERE
 K ^AMHTRPT(AMHRPT,11)
 Q
PAUSE ;EP
 Q:$E(IOST)'="C"!(IO'=IO(0))
 W ! S DIR(0)="EO",DIR("A")="Press enter to continue...." D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q
Y ;EP - called from apclvl0
 S DIR(0)="S^1:"_AMHTEXT_";0:NO "_AMHTEXT_"",DIR("A")="Should "_$S(AMHPTVS="P":"patient",1:"visit")_" have",DIR("B")="1" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q:$D(DIRUT)
 Q:Y=""
 S ^AMHTRPT(AMHRPT,11,AMHCRIT,0)=AMHCRIT,^AMHTRPT(AMHRPT,11,"B",AMHCRIT,AMHCRIT)=""
 S ^AMHTRPT(AMHRPT,11,AMHCRIT,11,1,0)=Y,^AMHTRPT(AMHRPT,11,AMHCRIT,11,"B",Y,1)="",^AMHTRPT(AMHRPT,11,AMHCRIT,11,0)="^9001003.8110101A^"_1_"^"_1
 Q
SPECIAL ;EP
 K ^AMHTRPT(AMHRPT,11,AMHCRIT),^AMHTPRT(AMHRPT,11,"B",AMHCRIT)
 S Y="" X:$D(^AMHSORT(AMHCRIT,4)) ^(4)
 I Y="" Q
 S ^AMHTRPT(AMHRPT,11,AMHCRIT,0)=AMHCRIT,^AMHTRPT(AMHRPT,11,"B",AMHCRIT,AMHCRIT)=""
 S AMHCNT=AMHCNT+1,^AMHTRPT(AMHRPT,11,AMHCRIT,11,AMHCNT,0)=$P(Y,U),^AMHTRPT(AMHRPT,11,AMHCRIT,11,"B",$P(Y,U),AMHCNT)="",^AMHTRPT(AMHRPT,11,AMHCRIT,11,0)="^9002013.8110101A^"_AMHCNT_"^"_AMHCNT
 Q
