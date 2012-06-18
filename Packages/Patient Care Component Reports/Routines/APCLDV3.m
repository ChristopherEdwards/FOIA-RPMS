APCLDV3 ; IHS/CMI/LAB - list IPV/DV screenings ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
INFORM ;
 W !,$$CTR($$USR)
 W !,$$LOC()
 W !!,$$CTR("LISTING OF PATIENT'S RECEIVING IPV SCREENING,INCLUDING REFUSALS",80)
 W !!,"This report will list all patients you select who have had IPV screening "
 W !,"(Exam code 34) or a refusal documented in a specified time frame."
 W !,"You will select the patients based on age, gender, result, provider,"
 W !,"or clinic where the screeing was done."
 W !!,"NOTE:  All screenings done in the time period for the patient's selected "
 W !,"will be displayed on the report."
 W !
 D XIT
 S APCLEXC=$O(^AUTTEXAM("C",34,0))
 I 'APCLEXC W !!,"Exam code 34 is missing from the EXAM table.  Cannot run report.",! H 3 D XIT Q
 ;
DATES K APCLED,APCLBD
 W !,"Please enter the date range during which the screening was done.",!,"To get all screenings ever put in a long date range like 01/01/1980",!,"to the present date.",!
 K DIR W ! S DIR(0)="DO^::EXP",DIR("A")="Enter Beginning Date for Screening"
 D ^DIR Q:Y<1  S APCLBD=Y
 K DIR S DIR(0)="DO^:DT:EXP",DIR("A")="Enter Ending Date for Screening"
 D ^DIR Q:Y<1  S APCLED=Y
 ;
 I APCLED<APCLBD D  G DATES
 . W !!,$C(7),"Sorry, Ending Date MUST not be earlier than Beginning Date."
 ;
FAC ;
 K APCLQ
 S APCLLOCT=""
 S DIR(0)="S^A:ALL Locations/Facilities;S:One SERVICE UNIT'S Locations/Facilities;O:ONE Location/Facility",DIR("A")="Include Visits to Which Location/Facilities",DIR("B")="A"
 S DIR("A")="Include screenings done at which facilities",DIR("B")="O" K DA D ^DIR K DIR,DA
 G:$D(DIRUT) DATES
 S APCLLOCT=Y
 I APCLLOCT="A" G COMM
 D @APCLLOCT^APCLDV1
 G:$D(APCLQ) FAC
COMM ;
 K APCLQ
 S APCLCOMT=""
 W !!,"You can just include patients living in certain communities",!,"or include all patients regardless of where they live."
 S DIR(0)="S^A:ALL Patient Communitiess;S:Selected Set (taxonomy) of Communities;O:ONE Community",DIR("A")="Include Visits to Which Location/Facilities",DIR("B")="A"
 S DIR("A")="Include screenings done at which facilities",DIR("B")="O" K DA D ^DIR K DIR,DA
 G:$D(DIRUT) FAC
 S APCLCOMT=Y
 I APCLCOMT="A" G EXCL
 D @(APCLCOMT_"C")^APCLDV1
 G:$D(APCLQ) COMM
EXCL ;
 S APCLEXBH=""
 W !!,"Would you like to include screenings done in the behavioral health clinics: "
 W !,"Mental Health (14); Alcohol and Substance Abuse (43) and Medical"
 S DIR(0)="Y",DIR("A")="Social Services (48)",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G DATES
 S APCLEXBH=Y
SEX ;
 S APCLSEX=""
 S DIR(0)="S^F:FEMALES Only;M:MALES Only;B:Both MALE and FEMALES",DIR("A")="Include which patients in the list",DIR("B")="F" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G EXCL
 S APCLSEX=Y
 I APCLSEX="B" S APCLSEX="MF"
AGE ;Age Screening
 K APCLAGE,APCLAGET
 W ! S DIR(0)="YO",DIR("A")="Would you like to restrict the report by Patient age range",DIR("B")="YES"
 S DIR("?")="If you wish to include visits from ALL age ranges, anwser No.  If you wish to list visits for only patients within a particular age range, enter Yes."
 D ^DIR K DIR
 G:$D(DIRUT) SEX
 I 'Y G RESULT
 ;
AGER ;Age Screening
 W !
 S DIR(0)="FO^1:7",DIR("A")="Enter an Age Range (e.g. 5-12,1-1)" D ^DIR
 I Y="" W !!,"No age range entered." G AGE
 I Y'?1.3N1"-"1.3N W !!,$C(7),$C(7),"Enter a numeric range in the format nnn-nnn. e.g. 0-5, 0-99, 5-20." G AGER
 S APCLAGET=Y
RESULT ;result screenig
 K APCLREST
 W !!,"You can limit the list to only patients who have had a screening"
 W !,"in the time period on which the result was any combination of the"
 W !,"following: (e.g. to get only those patients who have had a result of "
 W !,"Present enter 2 to get all patients who have had a screening result of"
 W !,"Past or Present, enter 2,3)",!
 W !?3,"1)  Normal/Negative"
 W !?3,"2)  Present"
 W !?3,"3)  Past"
 W !?3,"4)  Present and Past"
 W !?3,"5)  Refused"
 W !?3,"6)  Unable to Screen"
 W !?3,"7)  Screenings done with no result entered"
 W !
 W !
 K DIR S DIR(0)="L^1:7",DIR("A")="Which result values do you want included on this list",DIR("B")="" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G AGE
 I Y="" G AGE
 S APCLREST=Y
 S A=Y,C="" F I=1:1 S C=$P(A,",",I) Q:C=""  S APCLREST(C)=""
CLINIC ;
 K APCLCLNT
 W ! S DIR(0)="Y",DIR("A")="Include visits to ALL clinics",DIR("B")="Yes" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) RESULT
 I Y=1 G PRIMPRV
CLINIC1 ;
 S X="CLINIC",DIC="^AMQQ(5,",DIC(0)="FM",DIC("S")="I $P(^(0),U,14)" D ^DIC K DIC,DA I Y=-1 W "OOPS - QMAN NOT CURRENT - QUITTING" G XIT
 D PEP^AMQQGTX0(+Y,"APCLCLNT(")
 I '$D(APCLCLNT) G CLINIC
 I $D(APCLCLNT("*")) K APCLCLNT
PRIMPRV ;
 S (APCLDISC,APCLPSRT,APCLPPUN)="" K APCLPROV
 S DIR(0)="SO^O:One Provider Only;P:Any/All Providers (including unknown);U:Unknown Provider Only"
 S DIR("A")="Report should include visits whose PRIMARY PROVIDER on the visit is"
 S DIR("?")="If you wish to count only one primary provider of service enter a 'O'.  To include ALL providers enter an 'A'.  To include all providers of one discipline enter a 'D'." D ^DIR K DIR
 G:$D(DIRUT) XIT
 S APCLPSRT=Y
 I Y="P" K APCLPROV G PRVSCR
 I Y="U" S APCLPPUN=1 G PRVSCR
PRV1 ;
 I $P(^DD(9000010.06,.01,0),U,2)[200 S DIC="^VA(200,",DIC(0)="AEMQ",D="AK.PROVIDER",DIC("A")="Enter PROVIDER (Lastname,Firstname): " D MIX^DIC1 K DIC,D
 I $P(^DD(9000010.06,.01,0),U,2)[6 S DIC="^DIC(6,",DIC(0)="AEMQ",DIC("A")="Enter PROVIDER (Lastname,Firstname): " D ^DIC K DIC
 I $D(DTOUT)!(Y=-1) G PRIMPRV
 S APCLPROV=+Y
PRVSCR ;
 S (APCLSSRT,APCLSPUN)="" K APCLSPRV
 S DIR(0)="SO^O:One Provider Only;P:Any/All Providers (including unknown);U:Unknown Provider Only"
 S DIR("A")="Select which providers who performed the screening should be included"
 S DIR("?")="If you wish to count only one Provider enter a 'O'.  To include ALL providers enter an 'A'.  To include all providers of one discipline enter a 'D'." D ^DIR K DIR
 G:$D(DIRUT) XIT
 S APCLSSRT=Y
 I Y="P" K APCLSPRV G DESPRV
 I Y="U" S APCLSPUN=1 G DESPRV
SCRPRV1 ;
 I $P(^DD(9000010.06,.01,0),U,2)[200 S DIC="^VA(200,",DIC(0)="AEMQ",D="AK.PROVIDER",DIC("A")="Enter PROVIDER (Lastname,Firstname): " D MIX^DIC1 K DIC,D
 I $P(^DD(9000010.06,.01,0),U,2)[6 S DIC="^DIC(6,",DIC(0)="AEMQ",DIC("A")="Enter PROVIDER (Lastname,Firstname): " D ^DIC K DIC
 I $D(DTOUT)!(Y=-1) G PRVSCR
 S APCLSPRV=+Y
DESPRV ;
 S APCLDESP=""
 W !!,"Would you like to limit the list to just patients who have"
 S DIR(0)="Y",DIR("A")="a particular designated primary care provider",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G PRIMPRV
 I 'Y S APCLDESP="" G TEMP
DESPRV1 ;
 I $P(^DD(9000010.06,.01,0),U,2)[200 S DIC="^VA(200,",DIC(0)="AEMQ",D="AK.PROVIDER",DIC("A")="Enter PROVIDER (Lastname,Firstname): " D MIX^DIC1 K DIC,D
 I $P(^DD(9000010.06,.01,0),U,2)[6 S DIC="^DIC(6,",DIC(0)="AEMQ",DIC("A")="Enter PROVIDER (Lastname,Firstname): " D ^DIC K DIC
 I $D(DTOUT)!(Y=-1) G DESPRV
 S APCLDESP=+Y
TEMP ;TEMPLATE OR LIST
 S APCLTMPL="",APCLSTMP=""
 S DIR(0)="SO^L:List of Patient Screenings;S:Create a Search Template of Patients",DIR("B")="L",DIR("A")="Select Report Type"
 D ^DIR K DIR
 I $D(DIRUT) G DESPRV
 S APCLTMPL=Y
 I APCLTMPL="S" D ^APCLSTMP G:APCLSTMP="" TEMP G ZIS
LIST1 ;
 S APCLSORT=""
 W !
 S DIR(0)="S^H:Health Record Number;N:Patient Name;P:Provider who screened;C:Clinic;R:Result of Exam;D:Date Screened;A:Age of Patient at Screening;G:Gender of Patient;T:Terminal Digit HRN"
 S DIR("A")="How would you like the list to be sorted",DIR("B")="H"
 KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G PRIMPRV
 S APCLSORT=Y
DP ;
 S APCLDP=""
 W !
 S DIR(0)="Y",DIR("A")="Display the Patient's Designated Providers on the list",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G LIST1
 S APCLDP=Y
ZIS ;
DEMO ;
 D DEMOCHK^APCLUTL(.APCLDEMO)
 I APCLDEMO=-1 G DP
 S XBRP="PRINT^APCLDV3P",XBRC="PROC^APCLDV31",XBRX="XIT^APCLDV3",XBNS="APCL"
 D ^XBDBQUE
 D XIT
 Q
XIT ;
 D EN^XBVK("APCL")
 D ^XBFMK
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
EOP ;EP - End of page.
 Q:$E(IOST)'="C"
 Q:IO'=IO(0)
 Q:$D(ZTQUEUED)!'(IOT="TRM")!$D(IO("S"))
 NEW DIR
 K DIRUT,DFOUT,DLOUT,DTOUT,DUOUT
 W !
 S DIR("A")="End of Report.  Press Enter",DIR(0)="E" D ^DIR
 Q
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
