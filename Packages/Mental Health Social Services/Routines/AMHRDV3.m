AMHRDV3 ; IHS/CMI/LAB - list IPV/DV screenings ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
 ;
INFORM ;
 W !,$$CTR($$USR)
 W !,$$LOC()
 W !!,$$CTR("LISTING OF PATIENTS RECEIVING IPV SCREENING,INCLUDING REFUSALS",80)
 W !!,"This report will list all patients you select who have had IPV screening "
 W !,"or a refusal documented in a specified time frame."
 W !,"You will select the patients based on age, gender, result, provider,"
 W !,"or clinic where the screening was done."
 W !
 D DBHUSR^AMHUTIL
 D XIT
 S AMHREXC=$O(^AUTTEXAM("C",34,0))
 I 'AMHREXC W !!,"Exam code 34 is missing from the EXAM table.  Cannot run report.",! H 3 D XIT Q
 ;
DATES K AMHRED,AMHRBD
 W !,"Please enter the date range during which the screening was done.",!,"To get all screenings ever put in a long date range like 01/01/1980",!,"to the present date.",!
 K DIR W ! S DIR(0)="DO^::EXP",DIR("A")="Enter Beginning Date for Screening"
 D ^DIR Q:Y<1  S AMHRBD=Y
 K DIR S DIR(0)="DO^:DT:EXP",DIR("A")="Enter Ending Date for Screening"
 D ^DIR Q:Y<1  S AMHRED=Y
 ;
 I AMHRED<AMHRBD D  G DATES
 . W !!,$C(7),"Sorry, Ending Date MUST not be earlier than Beginning Date."
 ;
EXCL ;
 S AMHREXPC=""
 W !!,"Would you like to include screenings documented in non-behavioral health"
 S DIR(0)="Y",DIR("A")="clinics (those documented in PCC)",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G DATES
 S AMHREXPC=Y
SEX ;
 S AMHRSEX=""
 S DIR(0)="S^F:FEMALES Only;M:MALES Only;B:Both MALE and FEMALES",DIR("A")="Include which patients in the list",DIR("B")="F" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G EXCL
 S AMHRSEX=Y
 I AMHRSEX="B" S AMHRSEX="MF"
AGE ;Age Screening
 K AMHRAGE,AMHRAGET
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
 S AMHRAGET=Y
RESULT ;result screenig
 K AMHRREST
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
 K DIR S DIR(0)="L^1:7",DIR("A")="Which result values do you want included on this list",DIR("B")="" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G AGE
 I Y="" G AGE
 S AMHRREST=Y
 S A=Y,C="" F I=1:1 S C=$P(A,",",I) Q:C=""  S AMHRREST(C)=""
CLINIC ;
 K AMHRCLNT
 W ! S DIR(0)="Y",DIR("A")="Include visits to ALL clinics",DIR("B")="Yes" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) RESULT
 I Y=1 G PRIMPRV
CLINIC1 ;
 S X="CLINIC",DIC="^AMQQ(5,",DIC(0)="FM",DIC("S")="I $P(^(0),U,14)" D ^DIC K DIC,DA I Y=-1 W "OOPS - QMAN NOT CURRENT - QUITTING" G XIT
 D PEP^AMQQGTX0(+Y,"AMHRCLNT(")
 I '$D(AMHRCLNT) G CLINIC
 I $D(AMHRCLNT("*")) K AMHRCLNT
PRIMPRV ;
 S (AMHRDISC,AMHRPSRT,AMHRPPUN)="" K AMHRPROV
 S DIR(0)="SO^O:One Provider Only;P:Any/All Providers (including unknown);U:Unknown Provider Only"
 S DIR("A")="Report should include visits whose PRIMARY PROVIDER on the visit is"
 S DIR("?")="If you wish to count only one primary provider of service enter a 'O'.  To include ALL providers enter an 'A'.  To include all providers of one discipline enter a 'D'." D ^DIR K DIR
 G:$D(DIRUT) XIT
 S AMHRPSRT=Y
 I Y="P" K AMHRPROV G PRVSCR
 I Y="U" S AMHRPPUN=1 G PRVSCR
PRV1 ;
 I $P(^DD(9000010.06,.01,0),U,2)[200 S DIC="^VA(200,",DIC(0)="AEMQ",D="AK.PROVIDER",DIC("A")="Enter PROVIDER (Lastname,Firstname): " D MIX^DIC1 K DIC,D
 I $P(^DD(9000010.06,.01,0),U,2)[6 S DIC="^DIC(6,",DIC(0)="AEMQ",DIC("A")="Enter PROVIDER (Lastname,Firstname): " D ^DIC K DIC
 I $D(DTOUT)!(Y=-1) G PRIMPRV
 S AMHRPROV=+Y
PRVSCR ;
 S (AMHRSSRT,AMHRSPUN)="" K AMHRSPRV
 S DIR(0)="SO^O:One Provider Only;P:Any/All Providers (including unknown);U:Unknown Provider Only"
 S DIR("A")="Select which providers who performed the screening should be included"
 S DIR("?")="If you wish to count only one Provider enter a 'O'.  To include ALL providers enter an 'A'.  To include all providers of one discipline enter a 'D'." D ^DIR K DIR
 G:$D(DIRUT) XIT
 S AMHRSSRT=Y
 I Y="P" K AMHRSPRV G DESPRV
 I Y="U" S AMHRSPUN=1 G DESPRV
SCRPRV1 ;
 S DIC="^VA(200,",DIC(0)="AEMQ",D="AK.PROVIDER",DIC("A")="Enter PROVIDER (Lastname,Firstname): " D MIX^DIC1 K DIC,D
 I $D(DTOUT)!(Y=-1) G PRVSCR
 S AMHRSPRV=+Y
DESPRV ;
 S AMHRDESP=""
 W !!,"Would you like to limit the list to just patients who have"
 S DIR(0)="Y",DIR("A")="a particular designated Mental Health provider",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G PRIMPRV
 I 'Y S AMHRDESP="" G SSPRV
DESPRV1 ;
 S DIC="^VA(200,",DIC(0)="AEMQ",D="AK.PROVIDER",DIC("A")="Enter PROVIDER (Lastname,Firstname): " D MIX^DIC1 K DIC,D
 I $D(DTOUT)!(Y=-1) G DESPRV
 S AMHRDESP=+Y
SSPRV ;
 S AMHRSSP=""
 W !!,"Would you like to limit the list to just patients who have"
 S DIR(0)="Y",DIR("A")="a particular designated Social Services provider",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G DESPRV
 I 'Y S AMHRSSP="" G CDPRV
SSPRV1 ;
 S DIC="^VA(200,",DIC(0)="AEMQ",D="AK.PROVIDER",DIC("A")="Enter PROVIDER (Lastname,Firstname): " D MIX^DIC1 K DIC,D
 I $D(DTOUT)!(Y=-1) G SSPRV
 S AMHRSSP=+Y
CDPRV ;
 S AMHRCDP=""
 W !!,"Would you like to limit the list to just patients who have"
 S DIR(0)="Y",DIR("A")="a particular designated ASA/CD provider",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G SSPRV
 I 'Y S AMHRCDP="" G TEMP
CDPRV1 ;
 S DIC="^VA(200,",DIC(0)="AEMQ",D="AK.PROVIDER",DIC("A")="Enter PROVIDER (Lastname,Firstname): " D MIX^DIC1 K DIC,D
 I $D(DTOUT)!(Y=-1) G CDPRV
 S AMHRCDP=+Y
TEMP ;TEMPLATE OR LIST
 S AMHRTMPL="",AMHRSTMP=""
 S DIR(0)="SO^L:List of Patient Screenings;S:Create a Search Template of Patients",DIR("B")="L",DIR("A")="Select Report Type"
 D ^DIR K DIR
 I $D(DIRUT) G DESPRV
 S AMHRTMPL=Y
 I AMHRTMPL="S" D ^AMHRSTMP G:AMHRSTMP="" TEMP G DEMO
LIST1 ;
 S AMHRSORT=""
 W !
 S DIR(0)="S^H:Health Record Number;N:Patient Name;P:Provider who screened;C:Clinic;R:Result of Exam;D:Date Screened;A:Age of Patient at Screening;G:Gender of Patient;T:Terminal Digit HRN"
 S DIR("A")="How would you like the list to be sorted",DIR("B")="H"
 KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G PRIMPRV
 S AMHRSORT=Y
DP ;
 S AMHRDP=""
 W !
 S DIR(0)="Y",DIR("A")="Display the Patient's Designated Providers on the list",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G LIST1
 S AMHRDP=Y
DEMO ;
 D DEMOCHK^AMHUTIL1(.AMHDEMO)
 I AMHDEMO=-1 G TEMP
ZIS ;
 S XBRP="PRINT^AMHRDV3P",XBRC="PROC^AMHRDV31",XBRX="XIT^AMHRDV3",XBNS="AMHR"
 D ^XBDBQUE
 D XIT
 Q
XIT ;
 D EN^XBVK("AMHR")
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
