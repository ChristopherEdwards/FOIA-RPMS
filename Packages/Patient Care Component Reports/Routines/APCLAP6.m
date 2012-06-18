APCLAP6 ; IHS/CMI/LAB - APC visit counts by selected vars ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
START ; 
 I '$G(DUZ(2)) W $C(7),$C(7),!!,"SITE NOT SET IN DUZ(2) - NOTIFY SITE MANAGER!!",!! Q
 S APCLSITE=DUZ(2)
 S APCLJOB=$J,APCLBTH=$H
 D INFORM
 ;
DY ;determine whether to run yearly (calendar) or daily report
 K APCLDATE,APCLDY,APCLYEAR
 S DIR(0)="S^D:Daily Report;Y:Yearly Report",DIR("A")="Run which Report",DIR("B")="D" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) XIT
 S APCLDY=Y
 I APCLDY="Y" G Y
D ;which day?
 W ! S DIR(0)="D^:DT:EP",DIR("A")="Enter DATE" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G DY
 S APCLDATE=Y
 S X1=APCLDATE,X2=-1 D C^%DTC S APCLSD=X S (APCLBD,APCLED)=APCLDATE
 G CL
Y ;which year
  S %DT="AE",%DT("A")="Enter the Calendar Year: ",%DT("B")=$E(DT,2,3) D ^%DT I $D(DTOUT) G DY
 I X="^" G DY
 I Y=-1 D ERR G Y
 I $E(Y,4,7)'="0000" D ERR G Y
 S APCLYEAR=Y,APCLBD=$E(Y,1,3)_"0101",APCLED=$E(Y,1,3)_1231,X1=APCLBD,X2=-1 D C^%DTC S APCLSD=X
CL ;choose to tally by clinic or location
 K APCLLOC,APCLLOCT,APCLCLNT,APCLCLOC
 S DIR(0)="S^C:CLINIC;F:FACILITY (LOCATION)",DIR("A")="Do you wish to tally by",DIR("B")="C" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) DY
 S APCLCLOC=Y,APCLCLOC("NAME")=Y(0)
 G:APCLCLOC="F" F
CLINIC ;
 K APCLCLNT
 S X="CLINIC",DIC="^AMQQ(5,",DIC(0)="FM",DIC("S")="I $P(^(0),U,14)" D ^DIC K DIC,DA I Y=-1 W "OOPS - QMAN NOT CURRENT - QUITTING" G XIT
 D PEP^AMQQGTX0(+Y,"APCLCLNT(")
 I '$D(APCLCLNT) G CL
 S C=0,X=0 F  S X=$O(APCLCLNT(X)) Q:X'=+X  S C=C+1
 I C>12 W !,$C(7),$C(7),"I can't fit ",C," clinics on this report, please select 1-12 clinics." G CLINIC
LOC ;get location
 S APCLLOC=$$GETLOC^APCLOCCK
 I APCLLOC=-1 G CL
 G ZIS
F ;enter location
 S X="LOCATION OF ENCOUNTER",DIC="^AMQQ(5,",DIC(0)="FM",DIC("S")="I $P(^(0),U,14)" D ^DIC K DIC,DA I Y=-1 W "OOPS - QMAN NOT CURRENT - QUITTING" G XIT
 D PEP^AMQQGTX0(+Y,"APCLLOCT(")
 I '$D(APCLLOCT) G CL
 S C=0,X=0 F  S X=$O(APCLLOCT(X)) Q:X'=+X  S C=C+1
 I C>12 W !,$C(7),$C(7),"I can't fit ",C," facilities on this report, please select 1-12 facilities." G F
ZIS ;call to XBDBQUE
DEMO ;
 D DEMOCHK^APCLUTL(.APCLDEMO)
 I APCLDEMO=-1 G LOC
 S XBRP="^APCLAP6P",XBRC="^APCLAP61",XBRX="XIT^APCLAP6",XBNS="APCL"
 D ^XBDBQUE
 D XIT
 Q
XIT ;
 K X,X1,X2,IO("Q"),%,Y,POP,DIRUT,ZTSK,ZTQUEUED,H,S,TS,M,DA,D0,DR,DIC,DIE
 Q
ERR ;
 W !,$C(7),$C(7),"Enter a valid YEAR only!",!
 Q
INFORM ;
 W:$D(IOF) @IOF
 W !!,"This report will tally the number of visits by primary care providers, by",!,"provider at the locations or to the clinics that you specify.",!
 W !,"This report can be run for one day (daily report) or for a year (calendar).",!!
 W "A total number of 6 locations or clinics will fit on an 80 column report,",!,"you may specify up to 12 if you print the report with 132 columns."
 Q
 ;
