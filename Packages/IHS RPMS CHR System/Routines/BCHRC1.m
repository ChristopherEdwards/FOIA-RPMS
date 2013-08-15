BCHRC1 ; IHS/CMI/LAB - CHR Report 1 ; 
 ;;2.0;IHS RPMS CHR SYSTEM;;OCT 23, 2012;Build 27
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
 W !
 S BCHPRG=""
 S DIR(0)="Y",DIR("A")="Include data from ALL CHR Programs",DIR("B")="N",DIR("?")="If you wish to include visits from ALL programs answer Yes.  If you wish to tabulate for only one program enter NO." D ^DIR K DIR
 G:$D(DIRUT) BD
 I Y=1 S BCHPRG="" G CHRT
PROG1 ;enter program
 K X,DIC,DA,DD,DR,Y S DIC("A")="Which CHR Program: ",DIC="^BCHTPROG(",DIC(0)="AEMQ" D ^DIC K DIC,DA G:Y<0 PROG
 S BCHPRG=+Y
CHRT ;
 W !
 K BCHPROVT
 S DIR(0)="S^O:One CHR;A:All CHRs",DIR("A")="Include Data for",DIR("B")="A" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G PROG
 S BCHPROVT=Y
 I BCHPROVT="A" G SUB
CHR1 ;
 K DIC
 S DIC=200,DIC(0)="AEMQ",DIC("A")="Enter the CHR: " D ^DIC
 I Y=-1 G CHRT
 S BCHCHR1=+Y
SUB ;
 W !
 S BCHSUB=""
 S DIR(0)="Y",DIR("A")="Do you wish to subtotal by "_BCHSUBT,DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G CHRT
 S BCHSUB=Y
LT ;
 S BCHLEAVE=""
 S DIR(0)="S^I:Include Leave Time in this Report;D:DO NOT Include Leave Time in this Report",DIR("A")="Select",DIR("B")="D" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G SUB
 S BCHLEAVE=Y
REG ;
 S BCHREG="",BCHREGN=""
 S DIR(0)="S^R:Registered Patients;N:Non-Registered Patients;B:Both Registered and Non-Registered Patients",DIR("A")="Include which Patients",DIR("B")="B" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G LT
 S BCHREG=Y,BCHREGN=Y(0)
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
 S BCHCH="HEALTH PROBLEM",BCHSUBT="SERVICE CODE"
 Q
2 ;
 S BCHCH="SERVICE",BCHSUBT="HEALTH PROBLEM"
 Q
3 ;
 S BCHCH="SETTING",BCHSUBT="CHR"
 Q
INFORM ;
 W:$D(IOF) @IOF
 W !?20,"**********  CHR REPORT NO. ",BCHRPT,"  **********"
 W !!?10,"TIME SPENT, ",$S(BCHRPT=3:"# SERVED",1:"SERVICE ACTIVITIES"),", AND SERVICES by ",BCHCH,"",!!,"You must enter the time frame and the program for which the report",!,"will be run.",!!
 Q
 ;
 ;
