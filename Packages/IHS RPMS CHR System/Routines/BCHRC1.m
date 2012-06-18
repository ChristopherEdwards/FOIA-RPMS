BCHRC1 ; IHS/TUCSON/LAB - CHRIS II Report 1 ;  [ 10/28/96  2:05 PM ]
 ;;1.0;IHS RPMS CHR SYSTEM;;OCT 28, 1996
 ;
START ; 
 I '$G(DUZ(2)) W $C(7),$C(7),!!,"SITE NOT SET IN DUZ(2) - NOTIFY SITE MANAGER!!",!! Q
 I '$G(BCHRPT) W !,$C(7),$C(7),"REPORT NUMBER MISSING" Q
 D @BCHRPT
 S BCHJOB=$J,BCHBTH=$H
 D INFORM
GETDATES ;
BD ;get beginning date
 W ! S DIR(0)="D^:DT:EP",DIR("A")="Enter BEGINNING Date of Service for Report" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G XIT
 S BCHBD=Y
ED ;get ending date
 W ! S DIR(0)="D^"_BCHBD_":DT:EP",DIR("A")="Enter ENDING Date of Service for Report" S Y=BCHBD D DD^%DT S DIR("B")=Y,Y="" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 S BCHED=Y
 S X1=BCHBD,X2=-1 D C^%DTC S BCHSD=X
 ;
PROG ;
 S BCHPRG=""
 S DIR(0)="Y",DIR("A")="Include data from ALL CHR Programs",DIR("?")="If you wish to include visits from ALL programs answer Yes.  If you wish to tabulate for only one program enter NO." D ^DIR K DIR
 G:$D(DIRUT) BD
 I Y=1 S BCHPRG="" G ZIS
PROG1 ;enter program
 K X,DIC,DA,DD,DR,Y S DIC("A")="Which CHR Program: ",DIC="^BCHTPROG(",DIC(0)="AEMQ" D ^DIC K DIC,DA G:Y<0 PROG
 S BCHPRG=+Y
ZIS ;CALL TO XBDBQUE
 S XBRP="^BCHRC1P",XBRC="^BCHRC11",XBRX="XIT^BCHRC1",XBNS="BCH"
 D ^XBDBQUE
 D XIT
 Q
ERR W $C(7),$C(7),!,"Must be a valid date and be Today or earlier. Time not allowed!" Q
XIT ;
 K BCHPRG,BCHTOTC,BCHTOTS,BCHTOTA,BCHTOTT,BCHHA,BCHCA,BCHCC,BCHCS,BCHCT,BCHQUIT,BCHJOB,BCHBTH,BCHBT,BCHET,BCHBD,BCHED,BCHBDD,BCHEDD,BCHSD,BCHODAT,BCHPROG,BCHX,BCHC,BCHPROB,BCHPROBN,BCHR,BCHR0,BCHPG,BCHDT,BCHRPT,BCHCH
 Q
 ;
1 ;
 S BCHCH="HEALTH PROBLEM"
 Q
2 ;
 S BCHCH="ACTIVITY (SERVICE)"
 Q
3 ;
 S BCHCH="SETTING"
 Q
INFORM ;
 W:$D(IOF) @IOF
 W !?20,"**********  CHR REPORT NO. ",BCHRPT,"  **********"
 W !!?10,"TIME SPENT, CLIENT CONTACTS, AND ACTIVITIES by ",BCHCH,"",!!,"You must enter the time frame and the program for which the report",!,"will be run.",!!
 Q
 ;
 ;
