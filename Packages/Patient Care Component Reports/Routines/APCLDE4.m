APCLDE4 ; IHS/CMI/LAB - list refusals ; 
 ;;2.0;IHS PCC SUITE;**2**;MAY 14, 2009
 ;
 ;
INFORM ;
 W !,$$CTR($$USR)
 W !,$$LOC()
 W !!,"*Please Note: This DEPRESSION report is intended for advanced RPMS users"
 W !,"who are experienced in building search templates and using Q-MAN."
 W !!,$$CTR("TALLY AND LISTING OF PATIENT'S RECEIVING DEPRESSION SCREENING, INCLUDING REFUSALS",80)
 W !,$$CTR("ONLY PATIENTS WHO ARE MEMBERS OF A USER DEFINED SEARCH TEMPLATE",80)
 W !,$$CTR("ARE INCLUDED IN THIS REPORT",80)
 W !!,"This report will tally and list all patients who are members of"
 W !,"of a user defined search template.  It will tally and list their latest"
 W !,"DEPRESSION screening or a refusal documented in the time frame specified by "
 W !,"the user.  Depression Screening is defined as any of the following documented:"
 W !?5,"- Depression Screening Exam (Exam code 36)"
 W !?5,"- Measurements: PHQ2, PHQ9"
 W !?5,"- Diagnoses V79.0, 14.1 (Behavioral Health Problem Code)"
 W !?5,"- Education Topics: DEP-SCR"
 W !?5,"- refusal of exam code 36"
 W !,"This report will tally the patients by age, gender, screening exam result,"
 W !,"provider (either exam provider, if available, or primary provider on the "
 W !,"visit), clinic, date of screening, designated PCP, MH Provider, SS Provider"
 W !,"and A/SA Provider."
 W !,"  Notes:  "
 W !?10,"- the last screening/refusal for each patient is used.  If a patient"
 W !?10,"  was screened more than once in the time period, only the latest"
 W !?10,"  is used in this report."
 W !?10,"- this report will optionally, look at both PCC and the Behavioral"
 W !?10,"   Health databases for evidence of screening/refusal"
 W !?10,"- this is a tally of Patients, not visits or screenings"
 W !
 D PAUSE^APCLVL01
 D XIT
 S APCLEXC=$O(^AUTTEXAM("C",36,0))
 I 'APCLEXC W !!,"Exam code 36 is missing from the EXAM table.  Cannot run report.",! H 3 D XIT Q
 ;
DATES K APCLED,APCLBD
 W !,"Please enter the date range during which the screening was done.",!,"To get all screenings ever put in a long date range like 01/01/1980 ",!,"to the present date.",!
 K DIR W ! S DIR(0)="DO^::EXP",DIR("A")="Enter Beginning Date for Screening"
 D ^DIR Q:Y<1  S APCLBD=Y
 K DIR S DIR(0)="DO^:DT:EXP",DIR("A")="Enter Ending Date for Screening"
 D ^DIR Q:Y<1  S APCLED=Y
 ;
 I APCLED<APCLBD D  G DATES
 . W !!,$C(7),"Sorry, Ending Date MUST not be earlier than Beginning Date."
 ;
STMP ;
 S APCLSEAT=""
 W ! S DIC("S")="I $P(^(0),U,4)=9000001!($P(^(0),U,4)=2)" S DIC="^DIBT(",DIC("A")="Enter Patient SEARCH TEMPLATE name: ",DIC(0)="AEMQ" D ^DIC K DIC,DA,DR,DICR
 I Y=-1 G DATES
 S APCLSEAT=+Y
 ;
TALLY ;which items to tally
 K APCLTALL
 W !!,"Please select which items you wish to tally on this report:",!
 W !?3,"0)  Do not include any Tallies",?40,"6)  Date of Screening"
 W !?3,"1)  Type/Result of Screening",?40,"7)  Primary Provider on Visit"
 W !?3,"2)  Gender",?40,"8)  Designated Primary Care Provider"
 W !?3,"3)  Age of Patient"  ;,?40,"9)  Designated SS Provider"
 W !?3,"4)  Provider who Screened"  ;,?40,"10) Designated ASA/CD Provider"
 W !?3,"5)  Clinic"  ;,?40,"11) Designated Primary Care Provider"
 K DIR S DIR(0)="L^0:8",DIR("A")="Which items should be tallied",DIR("B")="" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G DATES
 I Y="" G DATES
 S APCLTALL=Y
 S A=Y,C="" F I=1:1 S C=$P(A,",",I) Q:C=""  S APCLTALL(C)=""
EXCL ;
 S APCLEXPC=""
 W !!,"Would you like to include screenings recorded in the Behavioral Clinics"
 W !,"Mental Health (14); DEPRESSION and Substance Abuse (43), Medical Social"
 S DIR(0)="Y",DIR("A")="Services, Behavioral Health (C4) and Telebehavioral Health (C9): ",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G DATES
 S APCLEXPC=Y
LIST ;
 S APCLLIST=""
 W !
 S DIR(0)="Y",DIR("A")="Would you like to include a list of patients screened",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G DATES
 S APCLLIST=Y
 I 'APCLLIST G ZIS
LIST1 ;
 S APCLSORT=""
 W !
 S DIR(0)="S^H:Health Record Number;N:Patient Name;P:Provider who screened;C:Clinic;R:Result of Exam;D:Date Screened;A:Age of Patient at Screening;G:Gender of Patient;T:Terminal Digit HRN"
 S DIR("A")="How would you like the list to be sorted",DIR("B")="H"
 KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G LIST
 S APCLSORT=Y
DP ;
 S APCLDP=""
 W !
 S DIR(0)="Y",DIR("A")="Display the Patient's Designated Providers on the list",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G LIST
 S APCLDP=Y
ZIS ;
 S XBRP="PRINT^APCLDE4P",XBRC="PROC^APCLDE4",XBRX="XIT^APCLDE4",XBNS="APC"
 D ^XBDBQUE
 D XIT
 Q
XIT ;
 D EN^XBVK("APC")
 D ^XBFMK
 Q
PROC ;
 S APCLCNT=0
 S APCLH=$H,APCLJ=$J
 K ^XTMP("APCLDE4",APCLJ,APCLH)
 D XTMP^APCLOSUT("APCLDE4","DEPRESSION SCREENING REPORT")
 ;now go through BH
 S DFN=0 F  S DFN=$O(^DIBT(APCLSEAT,1,DFN)) Q:DFN'=+DFN  D
 .;Q:'$$ALLOWP^APCUTIL(DUZ,DFN)  ;allowed to see this patient?
 .S APCALSC="" I APCLEXPC S APCALSC=$$BHALCS^APCLDE1(DFN,APCLBD,APCLED),APCPFI="BH"  ;include refusals
 .S APCPCALS="" S APCPCALS=$$PCCALCS^APCLDE1(DFN,APCLBD,APCLED)  ;include refusals
 .I $P(APCPCALS,U,1)>$P(APCALSC,U,1) S APCALSC=APCPCALS,APCPFI="PCC"
 .S APCLEFS="" S APCLEFS=$$REFUSAL^APCLDE1(DFN,9999999.15,$O(^AUTTEXAM("C",36,0)),APCLBD,APCLED)
 .I $P(APCLEFS,U,1)>$P(APCALSC,U,1) S APCALSC=APCLEFS,APCPFI="PCC"
 .I APCALSC="" Q  ;no screenings
 .S ^XTMP("APCLDE4",APCLJ,APCLH,"PTS",DFN)=APCALSC,$P(^XTMP("APCLDE4",APCLJ,APCLH,"PTS",DFN),U,20)=APCPFI
 Q
 ;
BHPPNAME(R) ;EP primary provider internal # from 200
 NEW %,%1
 S %=0,%1="" F  S %=$O(^AMHRPROV("AD",R,%)) Q:%'=+%  I $P(^AMHRPROV(%,0),U,4)="P" S %1=$P(^AMHRPROV(%,0),U),%1=$P($G(^VA(200,%1,0)),U)
 I %1]"" Q %1
 Q "UNKNOWN"
SPRV(E) ;
 I $P($G(^AUPNVXAM(E,12)),U,4) Q $$VAL^XBDIQ1(9000010.13,E,1204)
 Q "UNKNOWN"
PRVREF(R) ;
 I $P($G(^AUPNPREF(R,12)),U,4)]"" Q $$VAL^XBDIQ1(9000022,R,1204)
 Q "UNKNOWN"
PPV(V) ;
 NEW %
 S %=$$PRIMPROV^APCLV(V)
 I %]"" Q %
 Q "UNKNOWN"
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
