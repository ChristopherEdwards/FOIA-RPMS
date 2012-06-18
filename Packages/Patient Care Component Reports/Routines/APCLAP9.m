APCLAP9 ; IHS/CMI/LAB - visits by provider ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
START ; 
 S APCLJOB=$J,APCLBTH=$H
 D INFORM
GETDATES ;
BD ;
 S DIR(0)="D^::EP",DIR("A")="Enter Beginning Visit Date",DIR("?")="Enter the beginning visit date for the search." D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) XIT
 S APCLBD=Y
ED ;
 S DIR(0)="DA^::EP",DIR("A")="Enter Ending Visit Date:  " D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) XIT
 I Y<APCLBD W !,"Ending date must be greater than or equal to beginning date!" G ED
 S APCLED=Y
 S X1=APCLBD,X2=-1 D C^%DTC S APCLSD=X
LOC ;enter location
 S APCLLOC=""
 S DIR(0)="9000010,.06",DIR("A")="Include visits for which Facility" K DA D ^DIR K DIR
 I $D(DIRUT) W !!,"No facilty entered." G BD
 S APCLLOC=+Y
ZIS ;
DEMO ;
 D DEMOCHK^APCLUTL(.APCLDEMO)
 I APCLDEMO=-1 G LOC
 S XBRP="^APCLAP9P",XBRC="^APCLAP91",XBRX="XIT^APCLAP9",XBNS="APCL"
 D ^XBDBQUE
 D XIT
 Q
XIT ;
 K APCLAPC,APCLBD,APCLBT,APCLBTH,APCLCLIN,APCLCLN,APCLED,APCLGRAN,APCLJOB,APCLLOC,APCLPG,APCLSC,APCLSD,APCLTYPE,APCLTOT,APCLVIEN,APCLX,APCLVREC
 K DFN,C
 K DA,D0,S,TS,X,Y,DIC,DR,H,M,POP,ZTSK
 Q
 ;
INFORM ;
 W:$D(IOF) @IOF
 W !!,?10,"**************   PCC DATA ANALYSIS REPORT   **************",!!
 W !,"This report will tally all visits processed in PCC and break them",!,"down by Type, Service Category and complete/incomplete."
 W !!,"It will also, to the best of our ability, determine which of the visits",!,"would be excluded from the APC system.",!!
 Q
 ;
