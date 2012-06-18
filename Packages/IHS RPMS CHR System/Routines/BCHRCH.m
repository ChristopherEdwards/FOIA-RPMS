BCHRCH ; IHS/TUCSON/LAB - CHRIS II Report 2 ;  [ 12/28/01  2:57 PM ]
 ;;1.0;IHS RPMS CHR SYSTEM;**13**;OCT 28, 1996
 ;
 I '$G(DUZ(2)) W $C(7),$C(7),!!,"SITE NOT SET IN DUZ(2) - NOTIFY SITE MANAGER!!",!! Q
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
 I Y=1 S BCHPRG="" G CHRT
PROG1 ;enter program
 K X,DIC,DA,DD,DR,Y S DIC("A")="Which CHR Program: ",DIC="^BCHTPROG(",DIC(0)="AEMQ" D ^DIC K DIC,DA G:Y<0 PROG
 S BCHPRG=+Y
CHRT ;EP
 S DIR(0)="S^L:List of items with Counts;B:Bar Chart (REQUIRES 132 COLUMN PRINTER)",DIR("A")="Select Type of Report",DIR("B")="L" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G PROG
 S BCHCHRT=Y
NUM ;get # entries
 S DIR(0)="NO^5:"_$S(BCHCHRT="B":35,1:100)_":0",DIR("A")="How many entries do you want in the "_$S(BCHCHRT="B":"bar chart",1:"list"),DIR("B")="10",DIR("?")="" D ^DIR S:$D(DUOUT) DIRUT=1 K DIR
 I $D(DIRUT) G CHRT
 S BCHLNO=Y
 I $D(DTOUT)!(Y=-1) G NUM
ZIS ;CALL TO XBDBQUE
 S XBRP="^BCHRCHP",XBRC="^BCHRCH1",XBRX="XIT^BCHRCH",XBNS="BCH"
 D ^XBDBQUE
 D XIT
 Q
ERR W $C(7),$C(7),!,"Must be a valid date and be Today or earlier. Time not allowed!" Q
XIT ;
 K BCHPRG,BCHTT,BCHQUIT,BCHJOB,BCHBTH,BCHBT,BCHET,BCHBD,BCHED,BCHBDD,BCHEDD,BCHSD,BCHODAT,BCHPROG,BCHX,BCHR,BCHR0,BCHPG,BCHDT,BCHC,BCHY,BCHCHRT,BCHLNO,BCHPROC,BCHTH
 ;K X,Y,P,S,H,Q,R
 Q
 ;
INFORM ;
 W:$D(IOF) @IOF
 W !?20,"**********  CHR REPORT NO. 13  **********"
 W !!?26,"CHR HIGHLIGHTS REPORT",!!,"You must enter the time frame for the report.",!!
 Q
 ;
 ;
