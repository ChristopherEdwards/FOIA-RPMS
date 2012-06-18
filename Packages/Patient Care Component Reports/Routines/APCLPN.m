APCLPN ; IHS/CMI/LAB - PROVIDER NARRATIVE/CODING QA REPORT ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;
 ;
START ; 
 I '$G(DUZ(2)) W $C(7),$C(7),!!,"SITE NOT SET IN DUZ(2) - NOTIFY SITE MANAGER!!",!! K APCLSITE Q
 S APCLJOB=$J,APCLBTH=$H
 D INFORM
GETDATES ;
BD ;
 S DIR(0)="D^::EP",DIR("A")="Enter Beginning Visit Date",DIR("?")="Enter the beginning visit date for the search." D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) XIT
 S APCLBD=Y D DD^%DT S APCLBDD=Y
ED ;
 S DIR(0)="D^::EP",DIR("A")="Enter Ending Visit Date",DIR("B")=APCLBDD D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) XIT
 I Y<APCLBD W !,"Ending date must be greater than or equal to beginning date!" G ED
 S APCLED=Y
 S X1=APCLBD,X2=-1 D C^%DTC S APCLSD=X
CHECK ;
PRV ;
 S (APCLPROV,APCLDISC,APCLPSRT)=""
 S DIR(0)="SO^O:One Provider Only;P:All Providers;D:One Provider Discipline;A:All Provider Disciplines",DIR("A")="Report should include and sort by"
 S DIR("?")="If you wish to count only one provider of service enter a 'O'.  To include ALL providers enter an 'A'.  To include all providers of one discipline enter a 'D'." D ^DIR K DIR
 G:$D(DIRUT) XIT
 S APCLPSRT=Y
 I Y="P" S APCLPROV="" G PRIM
 G:Y="D" DISC
 I Y="X" S APCLCDIS="",APCLPSRT="P" G DISC
 I Y="A" S APCLDISC="" G PRIM
PRV1 ;
 S DIC("A")="Which Provider: ",DIC="^DIC(6,",DIC(0)="AEMQ" D ^DIC K DIC,DA G:Y<0 PRV
 S APCLPROV=+Y
 G PRIM
DISC ;
 S DIC("A")="Which Provider Discipline: ",DIC="^DIC(7,",DIC(0)="AEMQ" D ^DIC K DIC,DA G:Y<0 PRV
 S APCLDISC=+Y
PRIM ;
 S DIR(0)="S^P:Primary Provider;S:Primary or Secondary Provider",DIR("A")="Include if Provider is",DIR("B")="P" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) PRV
 I Y="P" S APCLPRIM=1 G ZIS
 S APCLPRIM=0
ZIS ;
 S XBRP="^APCLPNP",XBRC="^APCLPN1",XBRX="XIT^APCLPN",XBNS="APCL"
 D ^XBDBQUE
 D XIT
 Q
ERR W $C(7),$C(7),!,"Must be a valid date and be Today or earlier. Time not allowed!" Q
XIT ;
 K APCLBD,APCLED,APCLBDD,APCLEDD,APCLVDFN,APCLVLOC,APCLLOC,APCLLOCT,APCLPROV,APCLPOS,APCLPROT,APCLPG,APCLBT,APCLSITE,APCLPRIM,APCLDT,APCLODAT,APCLSD,APCLVREC,APCL80S,APCLTOT,APCLCAT,APCLLENG,APCLTEXT,APCLTAB
 K APCLQUIT,APCLPROS,APCLDISC,APCLPSRT,APCLCDIS,APCLJOB,APCLBTH
 K DA,D0,S,TS,X,Y,DIC,DR,H,M,POP,ZTSK
 Q
 ;
INFORM ;
 W:$D(IOF) @IOF
 W !,"This report is designed to allow Providers to compare the narrative",!,"that they enter for a diagnosis to the code/narrative that it gets coded to.",!,"Providers can then monitor the coding being done by the PCC Data entry Staff.",!
 Q
 ;
