APCLVL ; IHS/CMI/LAB - PCC VISIT GENERAL RETRIEVAL DRIVER ROUTINE ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;visit general retrieval
START ; 
 I '$D(IOF) D HOME^%ZIS
 I '$G(DUZ(2)) W $C(7),$C(7),!!,"SITE NOT SET IN DUZ(2) - NOTIFY SITE MANAGER!!",!! Q
 I '$G(DUZ) W $C(7),$C(7),!!,"USER NOT SET IN DUZ - NOTIFY SITE MANAGER!!",!! Q
 K APCLQUIT ;--- this variable controls whether or not a user terminated input
TYPE ;--- get type of report (patient, date range or search template)
 D INFORM^APCLVL01
ORDER ;EP - called from qman
 S APCLLMOR=""
 W !!,"When the list of items for selection, print and sort are displayed to you"
 W !,"in list manager, would you like them sorted alphabetically or in a pre-defined"
 W !,"order.  The pre-defined order is set by the software and is how the list has"
 W !,"historically been displayed."
 W !
 S DIR(0)="S^P:Predefined Order (the original ordering);A:Alphabetical Order;G:Groups of Related Items",DIR("A")="What order would you like the Items displayed in",DIR("B")="P" KILL DA D ^DIR KILL D
 I $D(DIRUT) D XIT Q
 S APCLLMOR=Y
 ;IHS/CMI;GRL redirect if from Qman
 I $G(APCLSEAT),$G(AMQQFILE)=9000010 G BD
 I $G(APCLSEAT),$G(AMQQFILE)=9000001,APCLTYPE["V" G BD
 I $G(APCLSEAT),$G(AMQQFILE)=9000001,APCLTYPE["S" G PS1
 ;
N ;
 S (APCLPCNT,APCLPTCT)=0 ;APCLPTCT -- pt total for # of "V"isits
 K APCLTYPE ;--- just in case variable left around
 K DIR,X,Y
 I APCLPTVS="P" S DIR(0)="S^S:Search Template of Patients;P:Search All Patients;Q:QMAN Search;R:CMS Register of Patients"
 I APCLPTVS="V" S DIR(0)="S^P:Search Template of Patients;V:Search Template of Visits;S:Search All Visits;R:CMS Register of Patients",DIR("B")="S"
 I APCLPTVS="P" D SETPDIR
 S DIR("A")="     Select "_$S(APCLPTVS="P":"Patient ",1:"Visit ")_"List from" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) XIT
 S APCLTYPE=APCLPTVS_Y
 D @APCLTYPE
 Q
PP ;patient lister
 D ADD I $D(APCLQUIT) D DEL K APCLQUIT G TYPE
 I '$D(APCLCAND) D PP1 Q
 D TITLE I $D(APCLQUIT) K APCLQUIT G TYPE
 D ZIS
 Q
PP1 ;if patient, no prev defined report used
PP11 K ^APCLVRPT(APCLRPT,11) D SCREEN I $D(APCLQUIT) K APCLQUIT D DEL G TYPE
PP12 K ^APCLVRPT(APCLRPT,12) S APCLTCW=0 D COUNT I $D(APCLQUIT) K APCLQUIT G PP11
PP13 D TITLE I $D(APCLQUIT) K APCLQUIT G PP12
 D SAVE,ZIS
 Q
PS ;--- process report when search template used
 Q:$D(APCLQMAN)
 D PS0
 Q:$D(APCLQUIT)
PS1 ;EP
 D ADD I $D(APCLQUIT) G PS
PS12 K ^APCLVRPT(APCLRPT,12) S APCLTCW=0 D COUNT I $D(APCLQUIT) K APCLQUIT G PS
PS13 D TITLE I $D(APCLQUIT) K APCLQUIT G PS12
 D ZIS
 Q
PS0 ;
 S DIC("S")="I $P(^(0),U,4)=2!($P(^(0),U,4)=9000001)" S DIC="^DIBT(",DIC("A")="Enter Patient SEARCH TEMPLATE name: ",DIC(0)="AEMQ" D ^DIC K DIC,DA,DR,DICR
 I Y=-1 S APCLQUIT="" Q
 S APCLSEAT=+Y
 Q
PQ ;qman
 K APCLQUIT
 S APCLQMAN=""
PQ0 ;
 W !
 S DIR(0)="F^2:30",DIR("A")="Enter a NAME for the SEARCH TEMPLATE QMAN will create" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q:$D(DIRUT)
 S AMQQEN3=Y
 I $D(^DIBT("B",Y)) W !!,"That SEARCH TEMPLATE already exists!!" D  Q:$D(APCLQUIT)
 .S DIR(0)="Y",DIR("A")="Do you want to overlay that template",DIR("B")="Y" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 .I $D(DIRUT) S APCLQUIT=1 Q
 .I Y=0 S APCLQUIT=1
 .Q
 S AMQQND=1
 D EN3^AMQQ
 I AMQQEN3=-1 S APCLQUIT=1 Q
 S APCLSEAT=AMQQEN3,APCLTYPE="PS" G PS1
 Q
PR ;get cms register and statuses
 S APCLCMSR="",APCLCMSS=""
 W !
 S DIC="^ACM(41.1,",DIC(0)="AEMQ",DIC("A")="Enter the Name of the Register: " D ^DIC
 I Y=-1 W !,"No register selected." S APCLQUIT=1 Q
 I '$D(^ACM(41.1,+Y,"AU",DUZ)) W !!,"You are not an authorized user of the ",$P(^ACM(41.1,+Y,0),U)," register" G PR
 S APCLCMSR=+Y
PRSTAT ;get status
 K APCLCMSS
 S DIR(0)="Y",DIR("A")="Do you want to select register patients with a particular status",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) S APCLQUIT=1 Q
 I Y=0 K APCLCMSS G PS1
PRSTAT1 ;which status
 S DIR(0)="9002241,1O",DIR("A")="Which status" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) Q
 S APCLCMSS(Y)=""
 G PS1
VV ;visit/visit search template
 W ! S DIC("S")="I $P(^(0),U,4)=9000010" S DIC="^DIBT(",DIC("A")="Enter Visit SEARCH TEMPLATE name: ",DIC(0)="AEMQ" D ^DIC K DIC,DA,DR,DICR
 I Y=-1 S APCLQUIT="" Q
 S APCLSEAT=+Y
 G VS
 Q
VP ;visit/pt search template
 W ! S DIC("S")="I $P(^(0),U,4)=2!($P(^(0),U,4)=9000001)" S DIC="^DIBT(",DIC("A")="Enter Patient SEARCH TEMPLATE name: ",DIC(0)="AEMQ" D ^DIC K DIC,DA,DR,DICR
 I Y=-1 S APCLQUIT="" Q
 S APCLSEAT=+Y
 G VS
 Q
VR ;get cms register and statuses
 S APCLCMSR="",APCLCMSS=""
 W !
 S DIC="^ACM(41.1,",DIC(0)="AEMQ",DIC("A")="Enter the Name of the Register: " D ^DIC
 I Y=-1 W !,"No register selected." S APCLQUIT=1 Q
 I '$D(^ACM(41.1,+Y,"AU",DUZ)) W !!,"You are not an authorized user of the ",$P(^ACM(41.1,APCLCMSR,0),U)," register" G PR
 S APCLCMSR=+Y
VRSTAT ;get status
 K APCLCMSS
 S DIR(0)="Y",DIR("A")="Do you want to select register patients with a particular status",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) S APCLQUIT=1 Q
 I Y=0 K APCLCMSS G VS
VRSTAT1 ;which status
 S DIR(0)="9002241,1O",DIR("A")="Which status" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) Q
 S APCLCMSS(Y)=""
 G VS
VS ;
GETDATES ;
 S APCLLHDR="DATE RANGE SELECTION" W !!?((80-$L(APCLLHDR))/2),APCLLHDR
 W !!,"This is a required response.  Remember, if you are using a Search Template of",!,"Visits, the Date Range entered here must correspond to the date range"
 W !,"used to generate the template or be a subset of that date range.",!
BD ;EP - CALLED FROM QMAN get beginning date
 W ! K DIR,X,Y S DIR(0)="D^:DT:EP",DIR("A")="Enter Beginning Visit Date for search" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) D DEL G TYPE
 S APCLBD=Y
ED ;get ending date
 W ! K DIR,X,Y S DIR(0)="DA^"_APCLBD_":DT:EP",DIR("A")="Enter Ending Visit Date for search: " D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 G:Y="" BD
 S APCLED=Y
 S X1=APCLBD,X2=-1 D C^%DTC S APCLD=X S Y=APCLBD D DD^%DT S APCLBDD=Y S Y=APCLED D DD^%DT S APCLEDD=Y
 D ADD I $D(APCLQUIT) D DEL K APCLQUIT G VS
 I '$D(APCLCAND) D D1 Q
 D TITLE I $D(APCLQUIT) K APCLQUIT G TYPE
 D ZIS
 Q
D1 ;if visit, no prev defined report used
D11 K ^APCLVRPT(APCLRPT,11) D SCREEN I $D(APCLQUIT) K APCLQUIT D DEL G VS
D12 K ^APCLVRPT(APCLRPT,12) S APCLTCW=0 D COUNT I $D(APCLQUIT) K APCLQUIT G D11
D13 D TITLE I $D(APCLQUIT) K APCLQUIT G D12
 D SAVE,ZIS
 Q
SCREEN ;
 S APCLCNTL="S"
 D ^APCLVL4
 Q
COUNT ;count only or detailed report
 D COUNT^APCLVL3
 Q
TITLE ;
 D TITLE^APCLVL3
 Q
SAVE ;
 D SAVE^APCLVL3
 Q
ZIS ;call to XBDBQUE
DEMO ;
 D DEMOCHK^APCLUTL(.APCLDEMO)
 I APCLDEMO=-1 G XIT
 K APCLOPT
 I 'APCLTCW S APCLTCW=IOM
 S APCLDONE=""
 D SHOW^APCLVLS,SHOWP^APCLVLS,SHOWR^APCLVLS
 D XIT1
 I $G(APCLBQC)=1 Q
 I APCLCTYP="D"!(APCLCTYP="S") D
 .S DIR(0)="S^P:PRINT Output;B:BROWSE Output on Screen",DIR("A")="Do you wish to ",DIR("B")="P" K DA D ^DIR K DIR
 .I $D(DIRUT) S APCLQUIT="" Q
 .S APCLOPT=Y
 G:$G(APCLQUIT) XIT
 I $G(APCLOPT)="B" D BROWSE,XIT Q
 S XBRP="^APCLVLP",XBRC="^APCLVL1",XBRX="XIT^APCLVL",XBNS="APCL"
 D ^XBDBQUE
 D XIT
 Q
DEL ;EP DELETE LOG ENTRY IF ONE EXISTS AND USER "^" OUT
 I $G(APCLRPT),$D(^APCLVRPT(APCLRPT,0)),'$P(^APCLVRPT(APCLRPT,0),U,2) S DIK="^APCLVRPT(",DA=APCLRPT D ^DIK K DIK,DA,DIC
 Q
ADD ;
 D ADD^APCLVL01
 Q
BROWSE ;
 S XBRP="VIEWR^XBLM(""^APCLVLP"")"
 S XBRC="^APCLVL1",XBRX="XIT^APCLVL",XBIOP=0 D ^XBDBQUE
 Q
SETPDIR ;
 S DIR("?")="Enter an S, P or Q"
 S DIR("?",1)="Selection of 'S' permits you to enter the name of a Search Template of patients"
 S DIR("?",2)="which you have previously created using QMAN, Case Management, or Fileman."
 S DIR("?",3)=""
 S DIR("?",4)="Selection of 'P' will cause the program to search the entire patient database"
 S DIR("?",5)="according to the criteria you enter in the patient selection phase of "
 S DIR("?",6)="this report."
 S DIR("?",7)=""
 S DIR("?",8)="Selection of 'Q' will transfer you into QMan to do your selection of patients"
 S DIR("?",9)="and return you to this program to create a customized listing and sorting of"
 S DIR("?",10)="those patients."
 S DIR("?",11)=""
 Q
XIT ;
 D XIT^APCLVL1
XIT1 ;
 D XIT1^APCLVL1
 Q
