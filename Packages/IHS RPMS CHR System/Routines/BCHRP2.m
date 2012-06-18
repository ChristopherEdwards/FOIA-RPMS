BCHRP2 ; IHS/TUCSON/LAB - All visit report driver ;  [ 04/02/01  9:35 AM ]
 ;;1.0;IHS RPMS CHR SYSTEM;**12**;OCT 28, 1996
 ;
START ; 
 I '$G(DUZ(2)) W $C(7),$C(7),!!,"SITE NOT SET IN DUZ(2) - NOTIFY SITE MANAGER!!",!! K BCHSITE Q
 S BCHJOB=$J,BCHBTH=$H
 D INFORM
GETDATES ;
BD ;get beginning date
 W ! S DIR(0)="D^:DT:EP",DIR("A")="Enter beginning Date of Service" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G XIT
 S BCHBD=Y
ED ;get ending date
 W ! S DIR(0)="D^"_BCHBD_":DT:EP",DIR("A")="Enter ending Date of Service" S Y=BCHBD D DD^%DT S DIR("B")=Y,Y="" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 S BCHED=Y
 S X1=BCHBD,X2=-1 D C^%DTC S BCHSD=X
 ;
PROG ;IHS/CMI/LAB - added program screen
 S BCHPRG=""
 S DIR(0)="Y",DIR("A")="Include data from ALL CHR Programs",DIR("?")="If you wish to include visits from ALL programs answer Yes.  If you wish to tabulate for only one program enter NO." D ^DIR K DIR
 G:$D(DIRUT) BD
 I Y=1 S BCHPRG="" G ZIS
PROG1 ;enter program
 K X,DIC,DA,DD,DR,Y S DIC("A")="Which CHR Program: ",DIC="^BCHTPROG(",DIC(0)="AEMQ" D ^DIC K DIC,DA G:Y<0 PROG
 S BCHPRG=+Y
ZIS ;CALL TO XBDBQUE
 S XBRP="^BCHRP2P",XBRC="^BCHRP21",XBRX="XIT^BCHRP2",XBNS="BCH"
 D ^XBDBQUE
 D XIT
 Q
ERR W $C(7),$C(7),!,"Must be a valid date and be Today or earlier. Time not allowed!" Q
XIT ;
 K BCHACT,BCHAREA,BCHAT,BCHATOT,BCHBD,BCHBDD,BCHBT,BCHBTH,BCHDISC,BCHDT,BCHED,BCHEDD,BCHET,BCHFTOT,BCHJOB,BCHLENG,BCHLOC,BCHLTOT,BCHODAT,BCHPAT,BCHPG,BCHPNAME,BCHPROG,BCHPROV,BCHPTOT,BCHQUIT,BCHR,BCHR0,BCHRCNT,BCHREC,BCHSD,BCHSITE,BCHSTOT
 K BCHSU,BCHX,BCHACTN,BCHLOCN,BCHPROGN
 K DIR,DIRUT,DTOUT,DUOUT,X,X1,X2,Y
 Q
 ;
INFORM ;
 W:$D(IOF) @IOF
 W !,"****** ACTIVITY REPORT ******",!
 W !,"This report will tally activities by Program, Setting, and CHR.",!
 Q
 ;
 ;
