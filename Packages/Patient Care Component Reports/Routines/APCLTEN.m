APCLTEN ; IHS/CMI/LAB - TOP TEN POVS ;
 ;;2.0;IHS PCC SUITE;**7,11**;MAY 14, 2009;Build 58
 ;
 W !!?20,"*****  FREQUENCY OF DIAGNOSES REPORT  *****",!!
 D EXIT
GETDATES ;
BD ;get beginning date
 W ! S DIR(0)="D^:DT:EP",DIR("A")="Enter beginning Visit Date" D ^DIR S:$D(DUOUT) DIRUT=1 K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G EXIT
 S APCLBD=Y
ED ;get ending date
 W ! S DIR(0)="DA^"_APCLBD_":DT:EP",DIR("A")="Enter ending Visit Date:  " S Y=APCLBD D DD^%DT S Y="" D ^DIR S:$D(DUOUT) DIRUT=1 K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 S APCLED=Y
 S X1=APCLBD,X2=-1 D C^%DTC S APCLSD=X
 S Y=APCLBD D DD^%DT S APCLBDD=Y S Y=APCLED D DD^%DT S APCLEDD=Y
 ;
TEMP ;template of patients?
 S APCLSEAT=""
 S DIR(0)="S^A:ALL PATIENTS;S:SEARCH TEMPLATE OF PATIENTS",DIR("A")="Include which patients in the tally of diagnoses",DIR("B")="A" KILL DA D ^DIR KILL DIR
 G:$D(DIRUT) BD
 I Y="A" G CONT
 S APCLSEAT=""
 ;
 W ! S DIC("S")="I $P(^(0),U,4)=9000001" S DIC="^DIBT(",DIC("A")="Enter Patient SEARCH TEMPLATE name: ",DIC(0)="AEMQ" D ^DIC K DIC,DA,DR,DICR
 I Y=-1 S APCLSEAT="" G TEMP
 S APCLSEAT=+Y
CONT ;
 S APCLNCAN=1 D ADD^APCLVL01 I $D(APCLQUIT) D DEL^APCLVL K APCLQUIT G GETDATES
NUM S DIR(0)="NO^5:100:0",DIR("A")="How many entries do you want in the list",DIR("B")="10",DIR("?")="" D ^DIR S:$D(DUOUT) DIRUT=1 K DIR
 I $D(DIRUT) G GETDATES
 S APCLLNO=Y
SCREEN ;
 S APCLTCW=0,APCLPTVS="V",APCLTYPE="D",APCLCTYP="T"
 K ^APCLVRPT(APCLRPT,11) S APCLCNTL="S" D ^APCLVL4 K APCLCNTL I $D(APCLQUIT) D DEL^APCLVL G GETDATES
POV ;
 K APCLPRIM,APCLALL
 S DIR(0)="SO^P:Primary Purpose of Visit;A:All Purpose of Visits (Primary and Secondary)",DIR("A")="Report should include"
 S DIR("?")="If you wish to count only the primary purpose of visit enter a 'P'.  To include ALL purpose of visits enter an 'A'.  For outpatient visits (non-H service category) the primary pov is the first one entered." D ^DIR K DIR
 I $D(DIRUT) S APCLQUIT="" G SCREEN
 I Y="A" S APCLALL=""
 I Y="P" S APCLPRIM=""
EXCL ;
 W !!,"You have the opportunity to exclude certain diagnoses from this report."
 W !,"For example, to eliminate Pharmacy refill diagnoses, you need to exclude",!,"ICD-9 code V68.1 and ICD-10 code Z76.0 from this report."
 W !,"If you chose to include only the primary pov then visits with "
 W !,"a primary pov of V68.1/Z76.0 will be excluded.",!
 ;exclude any diagnoses codes?
 S APCLEXCL=""
 S DIR(0)="Y",DIR("A")="Do you wish to exclude any diagnoses codes from the report",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G POV
 S APCLEXCL=Y
EXCL1 ;which ones to exclude
 K APCLDXT
 I 'APCLEXCL G CHRT
 W !,"Enter the diagnoses to be excluded.",!
DX1 ;
 S X="DIAGNOSIS",DIC="^AMQQ(5,",DIC(0)="FM",DIC("S")="I $P(^(0),U,14)" D ^DIC K DIC,DA I Y=-1 W "OOPS - QMAN NOT CURRENT - QUITTING" G EXIT
 D PEP^AMQQGTX0(+Y,"APCLDXT(")
 I '$D(APCLDXT) G EXCL
 I $D(APCLDXT("*")) K APCLDXT
CHRT ;
 S DIR(0)="S^L:List of items with Counts;B:Bar Chart (132 col)",DIR("A")="Select TYPE OF OUTPUT",DIR("B")="L" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G POV
 S APCLCHRT=Y
ZIS ;
DEMO ;
 D DEMOCHK^APCLUTL(.APCLDEMO)
 I APCLDEMO=-1 G EXCL
 K APCLANS,APCLCNT,APCLCRIT,APCLCUT,AMQQTAX,APCLDISP,APCLHIGH,APCLI,APCLCAN,APCLSEL,APCLSKIP,APCLTEXT,APCLVAR,APCLVIEN,APCLVREC
 S XBRC="^APCLTEN1",XBRP="^APCLTENP",XBNS="APCL",XBRX="EXIT^APCLTEN"
 D ^XBDBQUE
 D EXIT
 Q
EXIT ;
 D EXIT^APCLTEN1
 Q
 ;
 ;
 ;
 ;
