APCLAUD ; IHS/CMI/LAB - audit report ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;location of encounter 02/13/95
START ;
 S APCLJOB=$J,APCLBT=$H
 K ^XTMP("APCLAUD",APCLJOB,APCLBT),APCLTABL S APCLIRNG=0,APCLPRNG=1
 D XTMP^APCLOSUT("APCLAUD","PCC AUDIT REPORT")
 D XTMP^APCLOSUT("APCLAUD2","PCC AUDIT REPORT")
GO W:$D(IOF) @IOF
 S APCLMSG="VISIT DATE RANGE Selection" D APCLMSGO
GETDATES ;
BD ;get beginning date
 W ! S DIR(0)="DA^:DT:EP",DIR("A")="Enter beginning Visit Date for Search:  " D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G QUIT
 S APCLBD=Y
ED ;get ending date
 W ! S DIR(0)="DA^"_APCLBD_":DT:EP",DIR("A")="Enter ending Visit Date for Search:  " S Y=APCLBD D DD^%DT S (APCLBDY)=Y,Y="" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 S APCLED=Y D DD^%DT S APCLEDY=Y
 S X1=APCLBD,X2=-1 D C^%DTC S APCLSD=X
 ;
MORE ;
 D ^APCLAUD3
 I $D(DIRUT) G GO
ICD S DIC(0)="AMEQZ",DIC="^ICD9("
ICDB S APCLMSG="ICD CODE RANGE Selection" W:$D(IOF) @IOF D APCLMSGO
 D ICDB1 G ICDB11
ICDB1  ;EP
 W !,"Visit Date Range: ",APCLBDY," through ",APCLEDY,"."
 I '$D(APCLLAGE) W !!,"No Age Range restrictions." G ICDB10
 W !!,"Age Range Selected: ",APCLLAGE," - ",APCLHAGE," Years."
ICDB10 I $D(^XTMP("APCLAUD",APCLJOB,APCLBT,"ICDDFN","ALL")) W !!,"All ICD Coded Diagnoses will be included." G ICDB101
 I APCLIRNG>0 W ! F APCLI=1:1:APCLIRNG W !,"ICD Code Range ",APCLI,": ",^XTMP("APCLAUD",APCLJOB,APCLBT,APCLI,"ICDB")," through ",^XTMP("APCLAUD",APCLJOB,APCLBT,APCLI,"ICDE"),"."
ICDB101 ;
 W !!,"Sex Selected: ",$S($D(APCLSEX):APCLSEXP,1:"ALL")
 W !!,"Service Category Selected: ",$S($D(APCLSC):APCLSCP,1:"ALL")
 W !!,"Visit Type Selected: ",$S($D(APCLTYPE):APCLTYPP,1:"ALL")
 W !!,"Visit Location of Encounter:  ",$S($D(APCLLOC):APCLLOCP,1:"ALL")
 W !!,"Visit Clinic Type Selected: ",$S($D(APCLCLN):APCLCLNP,1:"ALL")
 Q
ICDB11 ;
 S DIR(0)="Y",DIR("A")="Do you want all ICD Coded diagnoses in the report",DIR("B")="Y" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 I Y=1 S ^XTMP("APCLAUD",APCLJOB,APCLBT,"ICDDFN","ALL")="" G ^APCLAUD0
ICDB2 D ^APCLAUD5
ICDE1 W:$D(IOF) @IOF
 G ^APCLAUD0
APCLMSGO W ?30,"*** Audit Search ***",!!
 W !?80-$L(APCLMSG)\2,APCLMSG,!! Q
QUIT ;
 K APCLBT,APCLJOB,DIR,APCLPOVD
 Q
