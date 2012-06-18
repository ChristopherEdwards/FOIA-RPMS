APCLCV ; IHS/CMI/LAB - Indian Beneficiary Calendar Year Visit Summary ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;IHS/CMI/LAB - fixed per California Area
START ; 
 D INFORM
 K DUOUT,DTOUT
YEAR ;Calendar Year Default
 S APCLYEAR="01/01/"_(1700+$E(DT,1,3)) ;IHS/CMI/LAB - fixed to 4 digit year
BD ;get beginning date
 W ! K DIR,X,Y S DIR(0)="D^:DT:EP",DIR("A")="Enter Beginning Visit Date for search" S DIR("B")=APCLYEAR D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) D EOJ Q
 S APCLBD=Y
ED ;get ending date
 W ! K DIR,X,Y S DIR(0)="DA^"_APCLBD_":DT:EP",DIR("A")="Enter Ending Visit Date for search: " D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 G:Y="" BD
 S APCLED=Y
 S X1=APCLBD,X2=-1 D C^%DTC S APCLSD=X S Y=APCLBD D DD^%DT S APCLBDD=Y S Y=APCLED D DD^%DT S APCLEDD=Y
 I $D(DIRUT) G YEAR
 ;
 W !!,"This report will be run for ",APCLBDD," to ",APCLEDD,".",!
F ;
 S APCLLOC=""
 S DIR(0)="S^A:All Locations;O:One Location: ",DIR("A")="Do you want to include Visits to",DIR("B")="A" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) YEAR
 S APCLVFL=Y
 I APCLVFL="A" G CLINIC
 S DIC("A")="Run for which Facility of Encounter: ",DIC="^AUTTLOC(",DIC(0)="AEMQ" D ^DIC K DIC,DA G:Y<0 F
 S APCLLOC=+Y
 ;
CLINIC ;
 W !!
 S APCLCL="" S APCLCLIN=""
 S DIR(0)="Y",DIR("A")="Print for ALL clinics",DIR("B")="Y" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) F
 I Y=1 G ZIS
 ;
CLINIC1 ;Get Multiple Clinics in Search
 K APCLCLNT
 ;
 S X="CLINIC",DIC="^AMQQ(5,",DIC(0)="FM",DIC("S")="I $P(^(0),U,14)" D ^DIC K DIC,DA I Y=-1 W "OPPS - QMAN NOT CURRENT - QUITTING" G EOJ
 D PEP^AMQQGTX0(+Y,"APCLCLNT(")
 I '$D(APCLCLNT) G CLINIC
 I $D(APCLCLNT("*")) K APCLCLNT
 ;K DIC S DIC=40.7,DIC(0)="AEQMZ",DIC("A")="Which Clinic:  " D ^DIC
 G CLINIC:Y<1
 ;S APCLCL=+Y
 ;
ZIS ;
DEMO ;
 D DEMOCHK^APCLUTL(.APCLDEMO)
 I APCLDEMO=-1 G CLINIC
 S XBRP="^APCLCVP",XBRC="^APCLCV1",XBRX="EOJ^APCLCV",XBNS="APCL"
 D ^XBDBQUE
 D EOJ
 Q
ERR W $C(7),$C(7),!,"Must be a valid Year.  Enter a year only!!" Q
EOJ K APCLFY,APCLLOC,APCLSD,APCLVDFN,APCLVREC,APCLSKIP,APCL1,APCL2,APCLDISC,APCLAP,APCLPPOV,APCLX,APCLDPTR,APCLVLOC,APCLMOL,APCLFYD,APCLMOS,APCLBT,APCLJOB,APCLTRIB,APCL1N,APCL2N,APCL3N,APCL4N,APCLGN,APCLSDD ;IHS/CMI/LAB
 K APCLDT,APCLAREA,APCLLOCP,APCLLOC,APCLAREC,APCLSU,APCLSUC,APCLGRAN,APCLPG,APCLQUIT,APCLMON,APCLTAB,APCLJ,APCLDISN,APCLPRIM,APCLP,APCLT,APCLPRIT,APCL132,APCLFYE,APCLLOCC,DFN
 K X,X1,X2,IO("Q"),%,Y,%DT,%Y,%W,%T,%H,DUOUT,DTOUT,POP,ZTSK,ZTQUEUED,H,S,TS,M
 K APCLFAC,APCLLOC,APCLBD,APCLBDD,APCLCLAS,APCLDTE,APCLED,APCLEDD,APCLET,APCLVFL,APCLVIEN,APCLCL,APCLCLIN,APCLCLNT,APCLCLP,APCLLOCP,APCLYEAR
 Q
 ;
INFORM ;
 W:$D(IOF) @IOF
 W !,?10,"**********  INDIAN/ALASKA NATIVE VISIT COUNTSS  **********",!
 W !,"This report will print Visit Counts for the Facility and Clinic and",!,"Time Frame that you select.  Visit Counts are summarized according to"
 W !,"Indian/Alaska Native and All Other Beneficiaries.",! W !,"Each Classification is Sub-Totaled by the following:  "
 W "(1) New Patient's 1st",!,"(2) Established Patient's 1st and (3) All additional Patient's Visits.",!
 W !,"NOTE:  Calendar Year Reports must be inclusive & begin with the 1st Day of the",!,?7,"the desired Calendar Year.",!
 Q
 ;
 ;
