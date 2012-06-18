BCHRL01 ; IHS/TUCSON/LAB - TUCSON-OHPRD/LAB - SCREEN LOGIC ;  [ 10/28/96  2:05 PM ]
 ;;1.0;IHS RPMS CHR SYSTEM;;OCT 28, 1996
 ;
 ;
INFORM ;EP
 S BCHTCW=0
 W:$D(IOF) @IOF
 S BCHLHDR="CHR ENCOUNTER GENERAL RETRIEVAL"
 W ?((80-$L(BCHLHDR))/2),BCHLHDR
 W !!!,"This report will produce a listing of ",$S(BCHPTVS="V":"records",1:"Patients")," in a date range selected by the",!,"user.  "
 W "The ",$S(BCHPTVS="V":"records",1:"Patients")," printed can be selected based on any combination of items.",!,"The user will select these criteria.  The items printed on the report",!
 W "are also selected by the user.",!!,"Be sure to have a printer available that has 132-column print capability.",!!
 S (BCHPCNT,BCHPTCT)=0 ;BCHPTCT -- pt total for # of "V"isits
 K BCHRDTR,BCHBDD,BCHBD,BCHEDD,BCHED
 S BCHXREF=$S(BCHPTVS="V":"C",1:"PO")
 K BCHTYPE ;--- just in case variable left around
 Q
 ;
ADD ;EP
 K BCHCAND
 W !!
 I $D(BCHSEAT),'$D(BCHEP1) G ADD1
 S DIR(0)="Y",DIR("A")="Do you want to use a PREVIOUSLY DEFINED REPORT",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) S BCHQUIT=1 Q
 I 'Y G ADD1
 S DIC="^BCHTRPT(",DIC("S")="I $P(^(0),U,2)&($P(^(0),U,6)=BCHPTVS)" S:$D(BCHEP1) DIC("S")=DIC("S")_"&($P(^(0),U,9)=BCHPACK)" S DIC(0)="AEQ",DIC("A")="REPORT NAME:  ",D="C" D IX^DIC K DIC,DA,DR
 I Y=-1 S BCHQUIT=1 Q
 S BCHRPT=+Y,BCHCAND=1
 ;--- set up sorting and report control variables
 S BCHSORT=$P(^BCHTRPT(BCHRPT,0),U,7),BCHSORV=$P(^(0),U,8),BCHSPAG=$P(^(0),U,4),BCHCTYP=$P(^(0),U,5)
 S X=0 F  S X=$O(^BCHTRPT(BCHRPT,12,X)) Q:X'=+X  S BCHTCW=BCHTCW+$P(^BCHTRPT(BCHRPT,12,X,0),U,2)+2
 Q
ADD1 ;EP
 ;CREATE REPORT ENTRY IN FILEMAN FILE
 S %H=$H D YX^%DTC S X=$P(^VA(200,DUZ,0),U)_"-"_Y,DIC(0)="L",DIC="^BCHTRPT(",DLAYGO=90002.42,DIADD=1 D ^DIC K DIC,DA,DR,DIADD,DLAYGO I Y=-1 W !!,"UNABLE TO CREATE REPORT FILE ENTRY - NOTIFY SITE MANAGER!" S BCHQUIT=1 Q
 S BCHRPT=+Y
 K DIC,DIADD,DLAYGO,DR,DA,DD,X,Y,DINUM
 ;DELETE ALL 11 MULTIPLE HERE
 K ^BCHTRPT(BCHRPT,11)
 Q
PAUSE ;EP
 Q:$E(IOST)'="C"!(IO'=IO(0))
 W ! S DIR(0)="EO",DIR("A")="Hit return to continue...." D ^DIR K DIR S:$D(DUOUT) (DIRUT,BCHBRK)=1
 Q
Y ;EP - called from apclvl0
 S DIR(0)="S^1:"_BCHTEXT_";0:NO "_BCHTEXT_"",DIR("A")="Should "_$S(BCHPTVS="P":"patient",1:"visit")_" have",DIR("B")="1" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q:$D(DIRUT)
 Q:Y=""
 S ^BCHTRPT(BCHRPT,11,BCHCRIT,0)=BCHCRIT,^BCHTRPT(BCHRPT,11,"B",BCHCRIT,BCHCRIT)=""
 S ^BCHTRPT(BCHRPT,11,BCHCRIT,11,1,0)=Y,^BCHTRPT(BCHRPT,11,BCHCRIT,11,"B",Y,1)="",^BCHTRPT(BCHRPT,11,BCHCRIT,11,0)="^9001003.8110101A^"_1_"^"_1
 Q
SPECIAL ;EP
 K ^BCHTRPT(BCHRPT,11,BCHCRIT),^BCHTPRT(BCHRPT,11,"B",BCHCRIT)
 S Y="" X:$D(^BCHSORT(BCHCRIT,4)) ^(4)
 I Y="" Q
 S ^BCHTRPT(BCHRPT,11,BCHCRIT,0)=BCHCRIT,^BCHTRPT(BCHRPT,11,"B",BCHCRIT,BCHCRIT)=""
 S BCHCNT=BCHCNT+1,^BCHTRPT(BCHRPT,11,BCHCRIT,11,BCHCNT,0)=$P(Y,U),^BCHTRPT(BCHRPT,11,BCHCRIT,11,"B",$P(Y,U),BCHCNT)="",^BCHTRPT(BCHRPT,11,BCHCRIT,11,0)="^90002.42110101A^"_BCHCNT_"^"_BCHCNT
 Q
