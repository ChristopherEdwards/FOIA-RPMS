APCLDV1 ; IHS/CMI/LAB - list refusals ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;
INFORM ;
 W !,$$CTR($$USR)
 W !,$$LOC()
 W !!,$$CTR("TALLY AND LISTING OF PATIENT'S RECEIVING IPV SCREENING,INCLUDING REFUSALS",80)
 W !!,"This report will tally and optionally list all patients who have had "
 W !,"IPV screening (Exam code 34) or a refusal documented in the time frame"
 W !,"specified by the user."
 W !,"This report will tally the patients by age, gender, result, provider (either"
 W !,"exam provider, if available, or primary provider on the visit), and date of"
 W !,"screening/refusal."
 W !,"  Notes:  "
 W !?10,"- the last screening/refusal for each patient is used.  If a patient"
 W !?10,"  was screened more than once in the time period, only the latest"
 W !?10,"  is used in this report."
 W !?10,"- this report will optionally, look at both PCC and the Behavioral"
 W !?10,"   Health databases for evidence of screening/refusal"
 W !
 D XIT
 S APCLEXC=$O(^AUTTEXAM("C",34,0))
 I 'APCLEXC W !!,"Exam code 34 is missing from the EXAM table.  Cannot run report.",! H 3 D XIT Q
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
TALLY ;which items to tally
 K APCLTALL
 W !!,"Please select which items you wish to tally on this report:",!
 W !?3,"0)  Do not include any Tallies",?40,"5)  Primary Provider of Visit"
 W !?3,"1)  Result of Screening",?40,"6)  Designated Primary Care Provider"
 W !?3,"2)  Gender",?40,"7)  Clinic"
 W !?3,"3)  Age of Patient",?40,"8)  Date of Screening"
 W !?3,"4)  Provider who Screened"
 K DIR S DIR(0)="L^0:8",DIR("A")="Which items should be tallied",DIR("B")="" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G DATES
 I Y="" G DATES
 S APCLTALL=Y
 S A=Y,C="" F I=1:1 S C=$P(A,",",I) Q:C=""  S APCLTALL(C)=""
EXCL ;
 S APCLEXBH=""
 W !!,"Would you like to include screenings done in the behavioral health clinics: "
 W !,"Mental Health (14); Alcohol and Substance Abuse (43) and Medical"
 S DIR(0)="Y",DIR("A")="Social Services (48)",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G DATES
 S APCLEXBH=Y
FAC ;
 K APCLQ
 S APCLLOCT=""
 S DIR(0)="S^A:ALL Locations/Facilities;S:One SERVICE UNIT'S Locations/Facilities;O:ONE Location/Facility",DIR("A")="Include Visits to Which Location/Facilities",DIR("B")="A"
 S DIR("A")="Include screenings done at which facilities",DIR("B")="O" K DA D ^DIR K DIR,DA
 G:$D(DIRUT) EXCL
 S APCLLOCT=Y
 I APCLLOCT="A" G COMM
 D @APCLLOCT
 G:$D(APCLQ) FAC
COMM ;
 K APCLQ
 S APCLCOMT=""
 W !!,"You can just include patients living in certain communities",!,"or include all patients regardless of where they live."
 S DIR(0)="S^A:ALL Patient Communitiess;S:Selected Set (taxonomy) of Communities;O:ONE Community",DIR("A")="Include Visits to Which Location/Facilities",DIR("B")="A"
 S DIR("A")="Include screenings done at which facilities",DIR("B")="O" K DA D ^DIR K DIR,DA
 G:$D(DIRUT) FAC
 S APCLCOMT=Y
 I APCLCOMT="A" G LIST
 D @(APCLCOMT_"C")
 G:$D(APCLQ) COMM
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
DEMO ;
 D DEMOCHK^APCLUTL(.APCLDEMO)
 I APCLDEMO=-1 G LIST
 S XBRP="PRINT^APCLDV1P",XBRC="PROC^APCLDV1",XBRX="XIT^APCLDV1",XBNS="APCL"
 D ^XBDBQUE
 D XIT
 Q
XIT ;
 D EN^XBVK("APCL")
 D ^XBFMK
 Q
O ;EP one location
 S DIC="^AUTTLOC(",DIC(0)="AEMQ",DIC("A")="Which LOCATION: " D ^DIC K DIC
 I Y=-1 S APCLQ="" Q
 S APCLLOCT("ONE")=+Y
 Q
S ;EP all LOCATIONS within APCLSU su
 S DIC="^AUTTSU(",DIC("B")=$$VAL^XBDIQ1(9999999.06,DUZ(2),.05),DIC(0)="AEMQ",DIC("A")="Which SERVICE UNIT: " D ^DIC K DIC
 I Y=-1 S APCLQ="" Q
 S APCLLOCT("SU")=+Y
 Q
OC ;EP one COMMUNITY
 S DIC="^AUTTCOM(",DIC(0)="AEMQ",DIC("A")="Which COMMUNITY: " D ^DIC K DIC
 I Y=-1 S APCLQ="" Q
 S APCLCOMT("ONE")=+Y
 Q
SC ;EP all communities within TAXONOMY
 D ^XBFMK
 S DIC("S")="I $P(^(0),U,15)=9999999.05",DIC="^ATXAX(",DIC(0)="AEMQ",DIC("A")="Enter the Name of the Community Taxonomy: "
 ;S B=$P($G(^BGPSITE(DUZ(2),0)),U,5) I B S DIC("B")=$P(^ATXAX(B,0),U)
 D ^DIC K DIC
 I Y=-1 S APCLQ="" Q
 S APCLCOMT("SU")=+Y
COM1 S X=0
 F  S X=$O(^ATXAX(+Y,21,X)) Q:'X  D
 .S APCLTAX($P(^ATXAX(+Y,21,X,0),U))=""
 .Q
 I '$D(APCLTAX) W !!,"There are no communities in that taxonomy." S APCLQ="" Q
 Q
PROC ;
 S APCLCNT=0
 S APCLH=$H,APCLJ=$J
 K ^XTMP("APCLDV1",APCLJ,APCLH)
 D XTMP^APCLOSUT("APCLDV1","IPV SCREENING REPORT")
 ;go through exam IPV, then through AUPNPREF for refusals
 S APCLEIEN=0 F  S APCLEIEN=$O(^AUPNVXAM("B",APCLEXC,APCLEIEN)) Q:APCLEIEN'=+APCLEIEN  D
 .Q:'$D(^AUPNVXAM(APCLEIEN,0))
 .S DFN=$P(^AUPNVXAM(APCLEIEN,0),U,2)
 .Q:$$DEMO^APCLUTL(DFN,$G(APCLDEMO))
 .I APCLCOMT="O",$$COMMRES^AUPNPAT(DFN,"I")'=APCLCOMT("ONE") Q  ;not in community
 .I APCLCOMT="S" S X=$$COMMRES^AUPNPAT(DFN,"E") I '$D(APCLTAX(X)) Q  ;not in comm taxonomy
 .S APCLVIEN=$P(^AUPNVXAM(APCLEIEN,0),U,3)
 .Q:'APCLVIEN
 .S APCLDATE=$P($P($G(^AUPNVSIT(APCLVIEN,0)),U),".")
 .Q:APCLDATE=""
 .Q:APCLDATE>APCLED
 .Q:APCLDATE<APCLBD
 .I APCLLOCT="O",$P(^AUPNVSIT(APCLVIEN,0),U,6)'=APCLLOCT("ONE") Q
 .I APCLLOCT="S",$$VALI^XBDIQ1(9999999.06,$P(^AUPNVSIT(APCLVIEN,0),U,6),.05)'=APCLLOCT("SU") Q
 .I 'APCLEXBH S C=$$CLINIC^APCLV(APCLVIEN,"C") I C=14!(C=45)!(C=48) Q
 .;S X=$O(^XTMP("APCLDV1",APCLJ,APCLH,"PTS",DFN,0))
 .;I X]"",X<APCLDATE K ^XTMP("APCLDV1",APCLJ,APCLH,"PTS",DFN,X)
 .S APCLRES=$$VAL^XBDIQ1(9000010.13,APCLEIEN,.04) S:APCLRES["REFUSED" APCLRES="REFUSED SCREENING" S:APCLRES["NEGATIVE" APCLRES="NEGATIVE"
 .S ^XTMP("APCLDV1",APCLJ,APCLH,"PTS",DFN,APCLDATE)="EX"_U_$$PPV(APCLVIEN)_U_APCLRES_U_$$VAL^XBDIQ1(9000010.13,APCLEIEN,81101)_U_$$AGE^AUPNPAT(DFN,APCLDATE)_U_$$VAL^XBDIQ1(2,DFN,.02)_U_APCLDATE_U_APCLEIEN
 .S $P(^XTMP("APCLDV1",APCLJ,APCLH,"PTS",DFN,APCLDATE),U,9)=$$VAL^XBDIQ1(9000010,APCLVIEN,.08)
 .S $P(^XTMP("APCLDV1",APCLJ,APCLH,"PTS",DFN,APCLDATE),U,15)=APCLVIEN
 .S $P(^XTMP("APCLDV1",APCLJ,APCLH,"PTS",DFN,APCLDATE),U,16)=$$SPRV(APCLEIEN)
 .S $P(^XTMP("APCLDV1",APCLJ,APCLH,"PTS",DFN,APCLDATE),U,17)=$$VAL^XBDIQ1(9000001,DFN,.14)
 ;now go through refusals in pcc
 S APCLRIEN=0 F  S APCLRIEN=$O(^AUPNPREF(APCLRIEN)) Q:APCLRIEN'=+APCLRIEN  D
 .Q:'$D(^AUPNPREF(APCLRIEN,0))
 .Q:$P(^AUPNPREF(APCLRIEN,0),U,5)'=9999999.15
 .Q:$P(^AUPNPREF(APCLRIEN,0),U,6)'=APCLEXC
 .S APCLDATE=$P(^AUPNPREF(APCLRIEN,0),U,3)
 .Q:APCLDATE=""
 .Q:APCLDATE>APCLED
 .Q:APCLDATE<APCLBD
 .S DFN=$P(^AUPNPREF(APCLRIEN,0),U,2)
 .Q:$$DEMO^APCLUTL(DFN,$G(APCLDEMO))
 .I APCLCOMT="O",$$COMMRES^AUPNPAT(DFN,"I")'=APCLCOMT("ONE") Q  ;not in community
 .I APCLCOMT="S" S X=$$COMMRES^AUPNPAT(DFN,"E") I '$D(APCLTAX(X)) Q  ;not in comm taxonomy
 .Q:$D(^XTMP("APCLDV1",APCLJ,APCLH,"PTS",DFN,APCLDATE))  ;already got one from v exam on this date
 .;S X=$O(^XTMP("APCLDV1",APCLJ,APCLH,"PTS",DFN,0))
 .;I X]"",X<APCLDATE K ^XTMP("APCLDV1",APCLJ,APCLH,"PTS",DFN,X)
 .S APCLRES=$$VAL^XBDIQ1(9000022,APCLRIEN,.07) S:APCLRES["REFUSED" APCLRES="REFUSED SCREENING" S:APCLRES["NEGATIVE" APCLRES="NEGATIVE"
 .S ^XTMP("APCLDV1",APCLJ,APCLH,"PTS",DFN,APCLDATE)="REF"_U_"UNKNOWN"_U_APCLRES_U_$$VAL^XBDIQ1(9000022,APCLRIEN,1101)_U_$$AGE^AUPNPAT(DFN,APCLDATE)_U_$$VAL^XBDIQ1(2,DFN,.02)_U_APCLDATE_U_APCLRIEN_U
 .S $P(^XTMP("APCLDV1",APCLJ,APCLH,"PTS",DFN,APCLDATE),U,16)=$$PRVREF(APCLRIEN)
 .S $P(^XTMP("APCLDV1",APCLJ,APCLH,"PTS",DFN,APCLDATE),U,17)=$$VAL^XBDIQ1(9000001,DFN,.14)
 ;now go through BH
 Q:'APCLEXBH  ;not if user doesn't want to
 S APCLSD=$$FMADD^XLFDT(APCLBD,-1),APCLSD=APCLSD_".9999"
 F  S APCLSD=$O(^AMHREC("B",APCLSD)) Q:APCLSD'=+APCLSD!($P(APCLSD,".")>APCLED)  D
 .S APCLBIEN=0 F  S APCLBIEN=$O(^AMHREC("B",APCLSD,APCLBIEN)) Q:APCLBIEN'=+APCLBIEN  D
 ..S APCLDATE=$P(APCLSD,".")
 ..Q:'$D(^AMHREC(APCLBIEN,0))
 ..Q:$P($G(^AMHREC(APCLBIEN,14)),U)=""
 ..Q:APCLDATE>APCLED
 ..Q:APCLDATE<APCLBD
 ..I APCLLOCT="O",$P(^AMHREC(APCLBIEN,0),U,4)'=APCLLOCT("ONE") Q
 ..I APCLLOCT="S",$$VALI^XBDIQ1(9999999.06,$P(^AMHREC(APCLBIEN,0),U,4),.05)'=APCLLOCT("SU") Q
 ..S DFN=$P(^AMHREC(APCLBIEN,0),U,8) Q:'DFN
 ..Q:$$DEMO^APCLUTL(DFN,$G(APCLDEMO))
 ..I APCLCOMT="O",$$COMMRES^AUPNPAT(DFN,"I")'=APCLCOMT("ONE") Q  ;not in community
 ..I APCLCOMT="S" S X=$$COMMRES^AUPNPAT(DFN,"E") I '$D(APCLTAX(X)) Q  ;not in comm taxonomy
 ..Q:$D(^XTMP("APCLDV1",APCLJ,APCLH,"PTS",DFN,APCLDATE))  ;already got one from PCC on this date
 ..;S X=$O(^XTMP("APCLDV1",APCLJ,APCLH,"PTS",DFN,0))
 ..;I X]"",X<APCLDATE K ^XTMP("APCLDV1",APCLJ,APCLH,"PTS",DFN,X)
 ..S APCLRES=$$VAL^XBDIQ1(9002011,APCLBIEN,1401) S:APCLRES["REFUSED" APCLRES="REFUSED SCREENING" S:APCLRES["NEGATIVE" APCLRES="NEGATIVE"
 ..S ^XTMP("APCLDV1",APCLJ,APCLH,"PTS",DFN,APCLDATE)="BH"_U_$$BHPPNAME(APCLBIEN)_U_APCLRES_U_$$VAL^XBDIQ1(9002011,APCLBIEN,1501)_U_$$AGE^AUPNPAT(DFN,APCLDATE)_U_$$VAL^XBDIQ1(2,DFN,.02)_U_APCLDATE_U_APCLBIEN
 ..S $P(^XTMP("APCLDV1",APCLJ,APCLH,"PTS",DFN,APCLDATE),U,9)=$$VAL^XBDIQ1(9002011,APCLBIEN,.25)
 ..S $P(^XTMP("APCLDV1",APCLJ,APCLH,"PTS",DFN,APCLDATE),U,15)=APCLBIEN
 ..S $P(^XTMP("APCLDV1",APCLJ,APCLH,"PTS",DFN,APCLDATE),U,16)=$S($P($G(^AMHREC(APCLBIEN,14)),U,2):$$VAL^XBDIQ1(9002011,APCLBIEN,1402),1:"UNKNOWN")
 ..S $P(^XTMP("APCLDV1",APCLJ,APCLH,"PTS",DFN,APCLDATE),U,17)=$$VAL^XBDIQ1(9000001,DFN,.14)
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
