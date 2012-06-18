APCLW6 ; IHS/CMI/LAB - AGE BUCKET/DIAGNOSIS REPORT ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
START ;
 W !!,"*****  PATIENTS MOVING UP OR DOWN 2 PERCENTILES IN THE BMI CURVE  *****",!!
 W !,"This report will prompt you to enter a date range.  The report will"
 W !,"list all patients who have moved from the normal to the "
 W !,"NHANES 85th-94th Percentile or have moved from the NHANES 85th-94th"
 W !,"Percentile to the NHANES >= 95th Percentile in the date range"
 W !,"that you specify."
 W !
 D EXIT
 S APCLSEAT="",APCLCMS=""
 S APCLTYPE=""
 ;
DATES K APCLED,APCLBD
 K DIR W ! S DIR(0)="DO^::EXP",DIR("A")="Enter Beginning Visit Date"
 D ^DIR Q:Y<1  S APCLBD=Y
 K DIR S DIR(0)="DO^:DT:EXP",DIR("A")="Enter Ending Visit Date"
 D ^DIR Q:Y<1  S APCLED=Y
 ;
 I APCLED<APCLBD D  G DATES
 . W !!,$C(7),"Sorry, Ending Date MUST not be earlier than Beginning Date."
ST ;
 S DIR(0)="S^S:Search Template of Patients;P:All Patients within an age range"
 S DIR("A")="   Select List " D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) EXIT
 S APCLTYPE=Y
 I APCLTYPE="S" D TEMPLATE G:APCLSEAT="" START
 I APCLTYPE="P" D AGE I APCLLOWA=""!(APCLHGHA="")!(APCLBEG="") G DATES
 ;
SEX ;
 S DIR(0)="S^M:Males;F:Females;B:Both",DIR("A")="Do you want the report to include",DIR("B")="B" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) START
 S APCLSEX=Y
ZIS ;
DEMO ;
 D DEMOCHK^APCLUTL(.APCLDEMO)
 I APCLDEMO=-1 G SEX
 S XBRC="^APCLW61",XBRP="^APCLW6P",XBNS="APCL",XBRX="EXIT^APCLW6"
 D ^XBDBQUE
 D EXIT
 Q
AGE ;
 S (APCLLOWA,APCLHGHA,APCLBEG)=""
 S DIR(0)="N^2:74:0",DIR("A")="Enter the low age",DIR("B")="" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q:$D(DIRUT)
 S APCLLOWA=Y
 S DIR(0)="N^"_APCLLOWA_":74:0",DIR("A")="Enter the high age",DIR("B")="" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q:$D(DIRUT)
 S APCLHGHA=Y
 W !!,"When determining which patients are in the ",APCLLOWA," to ",APCLHGHA," age range"
 W !,"should the age of the patient be calculated based on the beginning"
 W !,"or ending date of the time period?",!
 S APCLBEG=""
 S DIR(0)="S^B:Beginning of Time Period ("_$$FMTE^XLFDT(APCLBD)_");E:End of Time Period ("_$$FMTE^XLFDT(APCLED)_"):",DIR("A")="Calculate Age based on what date",DIR("B")="B" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) AGE
 S APCLBEG=Y
 Q
EXIT ;
 D EN^XBVK("APCL")
 D KILL^AUPNPAT
 K B,D,DA,DFN,DIC,DIR,DIRUT,J,K,M,P,R,S,T,V,X,X1,X2,Y,Z
 K DIR,DA,DIC,J,K,M,S,X,Y,APCLSEAT,APCLTYPE
 Q
 ;
TEMPLATE ;If Template was selected
 S APCLSEAT=""
 ;
 W ! S DIC("S")="I $P(^(0),U,4)=9000001" S DIC="^DIBT(",DIC("A")="Enter Patient SEARCH TEMPLATE name: ",DIC(0)="AEMQ" D ^DIC K DIC,DA,DR,DICR
 I Y=-1 K APCLTYPE Q
 S APCLSEAT=+Y
 Q
