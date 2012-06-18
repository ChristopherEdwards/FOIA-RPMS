APCLW2 ; IHS/CMI/LAB - AGE BUCKET/DIAGNOSIS REPORT ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
START ;
 W !!?15,"*****  RISK FOR OVERWEIGHT PREVALENCE REPORT  *****",!!
 D @APCLRPT
 ;
 S APCLTYPE=""
 S APCLSEAT=""
 K DIR,X,Y
 S DIR(0)="S^S:Search Template of Patients;P:Search All Patients"
 S DIR("A")="   Select List " D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) EXIT
 S APCLTYPE=Y
 I APCLTYPE="S" G TEMPLATE
 G:$D(DUOUT) START
 ;
SEX ;
 S DIR(0)="S^M:Males;F:Females;B:Both",DIR("A")="Report should include",DIR("B")="B" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) START
 S APCLSEX=Y
 ;
INDBEN ;
 W !
 S DIR(0)="Y",DIR("A")="Do you wish to include ONLY Indian/Alaska Native Beneficiaries",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) SEX
 S APCLIBEN=Y
 ;
AGE ;
 W !
 K APCLAGER
 S DIR(0)="FO^1:7",DIR("A")="Enter a Range of Ages (e.g. 5-12) [HIT RETURN TO INCLUDE ALL RANGES]" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DUOUT) G INDBEN
 I Y="" W !!,"No age range entered.  All ages will be included." G BMIR
 I Y'?1.3N1"-"1.3N W !!,$C(7),$C(7),"Enter an age range in the format nnn-nnn.  E.g. 2-5, 12-74, 5-20." G AGE
 I $P(Y,"-")<2 W !,$C(7),"Cannot run for patients under 2." G AGE
 I $P(Y,"-",2)>74 W !,$C(7),"Cannot run for patients over 74." G AGE
 S APCLAGER=Y
 I APCLRPT'="T" G REPORT
BMIR ;range of BMIs
 K APCLBMIR
 W !!,"If you want to include only patients whose BMI is within a certain range"
 W !,"please enter that range below.  For example to include only patients"
 W !,"whose BMI is between 30 and 40 enter 30-40.  To include only patients"
 W !,"whose BMI is over 25 enter 25-99.",!
 S DIR(0)="FO^1:7",DIR("A")="Enter a Range of BMIs (e.g. 25-50) [HIT RETURN TO INCLUDE ALL BMI values]" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DUOUT) G AGE
 I Y="" W !!,"No BMI range entered.  All BMI values will be included." G REPORT
 I Y'?1.3N1"-"1.3N W !!,$C(7),$C(7),"Enter a BMI range in the format nnn-nnn.  E.g. 20-25, 30.5-99." G BMIR
 I $P(Y,"-")<1 W !,$C(7),"Cannot run for BMI values under 1." G AGE
 I $P(Y,"-",2)>99 W !,$C(7),"Cannot run for BMI values over 99." G AGE
 S APCLBMIR=Y
REPORT ;
 S APCLRTYP=""
 S DIR(0)="S^R:Report (Printed);S:Sort Template",DIR("A")="Type of Output",DIR("B")="R" KILL DA D ^DIR KILL DIR
 G:$D(DIRUT) AGE
 S APCLRTYP=Y
 I APCLRTYP="S" G STMP
SORT ;
 S DIR(0)="S^P:Patient Name;A:Age of Patient;B:BMI",DIR("A")="Sort the report by",DIR("B")="P" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) AGE
 S APCLSORT=Y
IDENT ;
 S DIR(0)="Y",DIR("A")="Do you wish to suppress patient identifying data (name,chart #)",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) SORT
 S APCLIDEN=Y
 G ZIS
STMP ;
 K APCLSTMP,APCLSNAM
 D ^APCLSTMP
 I $G(APCLSTMP)="" G REPORT
ZIS ;
DEMO ;
 D DEMOCHK^APCLUTL(.APCLDEMO)
 I APCLDEMO=-1 G STMP
 S XBRC="^APCLW21",XBRP="^APCLW2P",XBNS="APCL",XBRX="EXIT^APCLW2"
 D ^XBDBQUE
 D EXIT
 Q
EXIT ;
 K APCLSORT,APCLIDEN,APCLAGER,APCLSEX,APCL1YR,APCL3YR,APCL80,APCLA,APCLAGE,APCLAGER,APCLBD,APCLBHGH,APCLBMI,APCLBTH,APCLCHT,APCLCWT,APCLDT,APCLER,APCLGHT,APCLGRAN,APCLGWT,APCLHGHA,APCLHRN
 K APCLJOB,APCLLENG,APCLMGI,APCLMHT,APCLMWT,APCLNAME,APCLNN,APCLOBE,APCLOVR,APCLPG,APCLQUIT,APCLREF,APCLROHT,APCLROWT,APCLRPT,APCLSEX,APCLSEXP,APCLSORT,APCLSRT,APCLTEXT,APCLX,APCLY,APCLIBEN,APCLCLAS
 K DIR,DA,DIC,J,K,M,S,X,Y,APCLSEAT,APCLTYPE
 Q
 ;
V ;
 W ?26,"LIST OF PATIENTS AT NHANES 85-94TH PERCENTILE"
 W !,"This report will produce a listing of all patients of the age and sex ",!,"that you specify, who are, based on the BMI, considered overweight.",!
 Q
B ;
 W ?24,"LIST OF PATIENTS >=NHANES 95TH PERCENTILE"
 W !,"This report will produce a listing of all patients of the age and sex ",!,"that you specify, who are, based on the BMI, considered obese.",!
 Q
C ;
 W ?18,"COMBINED LIST OF PATIENTS NHANES 85-100TH PERCENTILE"
 W !,"This report will produce a listing of all patients of the age and sex ",!,"that you specify, who are, based on the BMI, considered overweight or obese.",!
 Q
T ;
 W ?33,"PATIENT LIST"
 W !,"This report will produce a listing of all patients of the age and sex ",!,"that you specify.  The report will list their weight, height and BMI.",!
 Q
E ;
 W ?5,"LIST OF PATIENTS WITH POTENTIAL HEIGHT OR WEIGHT ERROR"
 W !,"This report will produce a listing of all patients of the age and sex ",!,"that you specify, whose BMI falls below or exceeds the reasonable data check",!,"limits as shown in the BMI Standard reference table.",!
 W "These patient records should be checked for possible inaccurate height or ",!,"weight entries.",!
 Q
 ;
TEMPLATE ;If Template was selected
 ;
 W ! S DIC("S")="I $P(^(0),U,4)=9000001" S DIC="^DIBT(",DIC("A")="Enter Patient SEARCH TEMPLATE name: ",DIC(0)="AEMQ" D ^DIC K DIC,DA,DR,DICR
 I Y=-1 S APCLQUIT="" K APCLTYPE G START
 S APCLSEAT=+Y
 G:$D(DIRUT) START
 G SEX
 ;
