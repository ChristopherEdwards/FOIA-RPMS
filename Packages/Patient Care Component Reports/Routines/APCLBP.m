APCLBP ; IHS/CMI/LAB - AGE BUCKET/DIAGNOSIS REPORT ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ; If APCLREP (repeat) = 1 then the last tag executed in APCLTAG is
 ; repeated.
 ; If DIRUT = 1 execution starts at the tag in APCLTAG that is the one
 ; before the last one executed.
START ;
 S APCLERR=0,APCLREP=0,APCLTAGS="ASKPT\CMMNTS\CLINIC\DATERNG\AGE\SEX\INDBEN\RTYPE\ZIS"
 W !!?15,"*****  BLOOD PRESSURE OUT OF CONTROL REPORT  *****",!!
 D DESCR
 F APCLI=1:1:$L(APCLTAGS,"\") D @($P(APCLTAGS,"\",APCLI)) Q:APCLERR  Q:$G(Y)="^^"  S:APCLREP APCLREP=0,APCLI=APCLI-1 I $D(DIRUT) Q:APCLI=1  S APCLI=APCLI-2
 D EXIT
 Q
 ;
 ; Ask to search all patients or use a template
ASKPT ;
 S APCLTYPE=""
 S APCLSEAT=""
 K DIR,X,Y
 S DIR(0)="S^S:Search Template of Patients;P:Search All Patients"
 S DIR("A")="   Select List " D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 S APCLTYPE=Y
 D:APCLTYPE="S" TEMPLATE
 Q
 ;
 ; Template was selected
TEMPLATE ;
 ;
 W ! S DIC("S")="I $P(^(0),U,4)=9000001" S DIC="^DIBT(",DIC("A")="Enter Visit SEARCH TEMPLATE name: ",DIC(0)="AEMQ" D ^DIC K DIC,DA,DR,DICR
 S:$D(DUOUT)!$D(DIRUT) APCLREP=1 S:Y<0 APCLREP=1
 ; If APCLREP = 1 the program will return to ASKPT (the last tag executed in the main for loop)
 I APCLREP K DIRUT,APCLTYPE Q
 S APCLSEAT=+Y
 Q
 ;
 ; Ask for communities
CMMNTS ;
 K APCLCOMM
 S DIR(0)="S^O:One particular Community;A:All Communities;S:Selected Set of Communities (Taxonomy)",DIR("A")="List patients who live in",DIR("B")="O" K DA D ^DIR K DIR
 Q:$D(DIRUT)
 I Y="A" W !!,"Patients from all communities will be included in the report.",! Q
 I Y="O" D  S:'$D(APCLCOMM) APCLREP=1 Q
 .S DIC="^AUTTCOM(",DIC(0)="AEMQ",DIC("A")="Which COMMUNITY: " D ^DIC K DIC
 .Q:Y=-1
 .S APCLCOMM($P(^AUTTCOM(+Y,0),U))=""
 S X="COMMUNITY",DIC="^AMQQ(5,",DIC(0)="FM",DIC("S")="I $P(^(0),U,14)" D ^DIC K DIC,DA I Y=-1 W "OOPS - QMAN NOT CURRENT - QUITTING" S APCLERR=1 Q
 D PEP^AMQQGTX0(+Y,"APCLCOMM(")
 I '$D(APCLCOMM) S APCLREP=1 Q
 I $D(APCLCOMM("*")) K APCLCOMM
 Q
 ;
 ; Ask for Clinic
CLINIC ;
 K APCLCLNT
 W ! S DIR(0)="Y",DIR("A")="Include visits to ALL clinics",DIR("B")="Yes" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q:$D(DIRUT)
 Q:Y=1
 S X="CLINIC",DIC="^AMQQ(5,",DIC(0)="FM",DIC("S")="I $P(^(0),U,14)" D ^DIC K DIC,DA I Y=-1 S APCLERR=1 W "OOPS - QMAN NOT CURRENT - QUITTING" Q
 D PEP^AMQQGTX0(+Y,"APCLCLNT(")
 I '$D(APCLCLNT) S APCLREP=1 Q
 I $D(APCLCLNT("*")) K APCLCLNT
 Q
 ;
 ; Ask for date range
DATERNG ;
BD ; Ask starting date
 I $D(DIRUT) S APCLI=APCLI-3 K DIRUT Q  ; temporary line
 S APCLSD=0,APCLED=9999999
 W ! S DIR(0)="D^:DT:EP",DIR("A")="Enter beginning Visit Date" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q:$D(DIRUT)
 S APCLBD=Y,APCLSD=9999999-Y
 D ED
 Q
 ;
ED ; ask ending date
 W ! S DIR(0)="DA^"_APCLBD_":DT:EP",DIR("A")="Enter ending Visit Date:  " S Y=APCLBD D DD^%DT S Y="" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 S:$D(DUOUT)!$D(DIRUT) APCLREP=1 S:Y<0 APCLREP=1
 ; If APCLREP = 1 the program will return to BD (the last tag executed in the main for loop)
 I APCLREP K DIRUT,APCLTYPE Q
 S APCLED=9999999-Y
 Q
 ;
AGE ;
 W !
 K APCLAGER
 S DIR(0)="FO^1:7",DIR("A")="Enter a Range of Ages (e.g. 5-12) [HIT RETURN TO INCLUDE ALL RANGES]" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !!,"No age range entered.  All ages will be included." K DIRUT Q
 Q:$D(DIRUT)
 I Y'?1.3N1"-"1.3N W !!,$C(7),$C(7),"Enter an age range in the format nnn-nnn.  E.g. 2-5, 12-74, 5-20." S APCLREP=1 Q
 I $P(Y,"-")<2 W !,$C(7),"Cannot run for patients under 2." S APCLREP=1 Q
 ;I $P(Y,"-",2)>74 W !,$C(7),"Cannot run for patients over 74." S APCLREP=1 Q
 S APCLAGER=Y
 Q
 ;
SEX ;
 S DIR(0)="S^M:Males;F:Females;B:Both",DIR("A")="Report should include",DIR("B")="B" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 S APCLSEX=Y
 Q
 ;
INDBEN ;
 W !
 S DIR(0)="Y",DIR("A")="Do you wish to include ONLY Indian/Alaska Native Beneficiaries",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 S APCLIBEN=Y
 Q
 ;
 ; Ask if suppressing identifying information
IDENT ;
 S DIR(0)="S^P:Patient Name;C:Chart #;B:Both;N:Neither",DIR("A")="Do you wish to suppress patient identifying data",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 S:$D(DUOUT)!$D(DIRUT) APCLREP=1 S:Y<0 APCLREP=1
 ; If APCLREP = 1 the program will return to RTYPE (the last tag executed in the main for loop)
 I APCLREP K DIRUT,APCLTYPE Q
 S APCLIDEN=$S(Y="P":1,Y="C":10,Y="B":11,1:0)
 Q
 ;
 ; Ask if Detail or Summary type report
RTYPE ;
 S DIR(0)="S^D:Detail;S:Summary;C:Cohort/Template Save",DIR("A")="Report type should be",DIR("B")="D" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 S APCLRTYP=Y
 Q:APCLRTYP="S"!$D(DIRUT)
 I APCLRTYP="D" D SORT Q
 ; Create a cohort/template
 D ^APCLSTMP
 I X="^^" S Y="^^" Q
 S:$D(DUOUT)!$D(DIRUT) APCLREP=1 S:$G(Y)<0 APCLREP=1
 K:APCLREP DIRUT
 Q
 ;
SORT ;
 S DIR(0)="S^P:Patient Name;A:Age of Patient",DIR("A")="Sort the report by",DIR("B")="P" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 S:$D(DUOUT)!$D(DIRUT) APCLREP=1 S:Y<0 APCLREP=1
 ; If APCLREP = 1 the program will return to RTYPE (the last tag executed in the main for loop)
 I APCLREP K DIRUT,APCLTYPE Q
 S APCLSORT=Y
 W ! D IDENT
 Q
 ;
DESCR ;
 W ?26,"LIST OF BLOOD PRESSURE OUT OF CONTROL PATIENTS"
 W !!,"This report will produce a listing of all patients for the specified age, sex,"
 W !,"communities, clinic and time period, who are considered out of control based on",!,"their mean Systolic or Diastolic blood pressure .",!
 Q
 ;
ZIS ;
DEMO ;
 D DEMOCHK^APCLUTL(.APCLDEMO)
 I APCLDEMO=-1 G RTYPE
 S XBRC="^APCLBP1",XBNS="APCL",XBRX=""
 S XBRP=$S(APCLRTYP'="C":"^APCLBPP",1:"")
 D ^XBDBQUE
 Q
 ;
EXIT ;
 K APCL80,APCLA,APCLAGE,APCLAGER,APCLBD,APCLBHGH,APCLBMI,APCLBPC,APCLBPTY,APCLBPX,APCLBTH,APCLBTYP,APCLCBC,APCLCHT,APCLCLAS,APCLCLIN,APCLCLNC,APCLCMTS,APCLCMTY,APCLCOMM,APCLCPT,APCLCTB,APCLDT,APCLDTL,APCLED
 K APCLEDD,APCLER,APCLERR,APCLI,APCLIBEN,APCLIDEN,APCLJOB,APCLLENG,APCLMDBP,APCLMGI,APCLMHT,APCLMIEN,APCLMSBP,APCLMWT,APCLNAME,APCLOCTL,APCLPCT,APCLPG,APCLPTOT,APCLQUIT,APCLREF,APCLREP,APCLROHT,APCLROWT,APCLRPT
 K APCLRTYP,APCLSD,APCLSDD,APCLSEAT,APCLSEX,APCLSEXP,APCLSORT,APCLSRT,APCLTAGS,APCLTBP,APCLTDBP,APCLTOBC,APCLTOBP,APCLTOP,APCLTPOC,APCLTPT,APCLTSBP,APCLTYPE,APCLX,APCLY,DA,DFN,DIC,DIR,DIRUT,J,K,M,R,S,X,X1
 K X2,XBNS,XBRC,XBRP,XBRX,Y
 Q
