APCDCAFE ; IHS/CMI/LAB - ;
 ;;2.0;IHS PCC SUITE;**2**;MAY 14, 2009
 ;
START ;
 D XIT
 I '$D(IOF) D HOME^%ZIS
 D TERM^VALM0
 W @(IOF),!!
 D INFORM
 I $P(^APCCCTRL(DUZ(2),0),U,12)="" W !!,"The EHR/PCC Coding Audit Start Date has not been set",!,"in the PCC Master Control file." D  D XIT Q
 .W !!,"Please see your Clinical Coordinator or PCC Manager."
 .S DIR(0)="E",DIR("A")="Press Enter" KILL DA D ^DIR KILL DIR
 .Q
DATES K APCDED,APCDBD
 K DIR W ! S DIR(0)="DO^::EXP",DIR("A")="Enter Beginning Visit Date"
 D ^DIR G:Y<1 XIT S APCDBD=Y
 I APCDBD<$P($G(^APCCCTRL(DUZ(2),0)),U,12) D  G DATES
 .W !!,"That date is before the EHR/PCC Coding Start Date."
 .W !,"Please enter a date on or after "_$$FMTE^XLFDT($P(^APCCCTRL(DUZ(2),0),U,12))
 K DIR S DIR(0)="DO^:DT:EXP",DIR("A")="Enter Ending Visit Date"
 D ^DIR G:Y<1 XIT  S APCDED=Y
 ;
 I APCDED<APCDBD D  G DATES
 . W !!,$C(7),"Sorry, Ending Date MUST not be earlier than Beginning Date."
 S APCDSD=$$FMADD^XLFDT(APCDBD,-1)_".9999"
 ;
NOD ;
 S APCDNOD=""
 W !,"Enter the # of days to use to determine whether a visit was marked within"
 W !,"the appropriate time limit.  For example, if outpatient visits should"
 W !,"be marked as completed/reviewed within 3 days of the visit date, enter 3."
 S DIR(0)="N^1:9999:0",DIR("A")="How Many Days between the visit date and the date completed",DIR("B")="3" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G DATES
 S APCDNOD=Y
FAC ;
 K APCDQ
 W !!,$G(IORVON)_"Please enter which FACILITY visits will be included in the list."_$G(IORVOFF),!
 S APCDLOCT=""
 K APCDLOCS
 S DIR(0)="S^A:ALL Locations/Facilities;S:Selected set or Taxonomy of Locations;O:ONE Location/Facility",DIR("A")="Include Visits to Which Location/Facilities",DIR("B")="A"
 S DIR("A")="Enter a code indicating what LOCATIONS/FACILITIES are of interest",DIR("B")="A" K DA D ^DIR K DIR,DA
 G:$D(DIRUT) DATES
 S APCDLOCT=Y
 I APCDLOCT="A" G SC
 D @(APCDLOCT_"LOC")
 G:$D(APCDQ) FAC
SC ;
 K APCDQ
 W !!,$G(IORVON)_"Please enter which SERVICE CATEGORIES will be included",!,"in the list."_$G(IORVOFF),!
 S APCDSCT=""
 K APCDSCS
 K DIR S DIR(0)="S^A:ALL Service Categories;S:Selected set or Taxonomy of Service Categories;O:One Service Category",DIR("A")="Include Visits to Which Service Categories",DIR("B")="A"
 S DIR("A")="Enter a code indicating what SERVICE CATEGORIES are of interest",DIR("B")="A" K DA D ^DIR K DIR,DA
 G:$D(DIRUT) FAC
 S APCDSCT=Y
 I APCDSCT="A" G CLINIC
 D @(APCDSCT_"SC")
 G:$D(APCDQ) SC
CLINIC ;
 K APCDQ
 W !!,$G(IORVON)_"Please enter which CLINIC (IHS clinic codes) visits will be included",!,"in the list."_$G(IORVOFF),!
 S APCDCLNT=""
 K APCDCLNS
 K DIR S DIR(0)="S^A:ALL Clinics;S:Selected set or Taxonomy of Clinics;O:ONE Clinic",DIR("A")="Include Visits to Which Clinics",DIR("B")="A"
 S DIR("A")="Enter a code indicating what CLINICS (IHS clinic code) are of interest",DIR("B")="A" K DA D ^DIR K DIR,DA
 G:$D(DIRUT) SC
 S APCDCLNT=Y
 I APCDCLNT="A" G HOSPLOC
 D @(APCDCLNT_"CLN")
 G:$D(APCDQ) CLINIC
HOSPLOC ;
 K APCDQ
 W !!,$G(IORVON)_"Please enter which HOSPITAL LOCATIONS will be included in the list."_$G(IORVOFF),!
 S APCDHLT=""
 K APCDHLS
 S DIR(0)="S^A:ALL Hospital Locations;S:Selected set of Hospital Locations;O:ONE Hospital Location",DIR("A")="Include Visits to Which Hospital Locations",DIR("B")="A"
 S DIR("A")="Enter a code indicating what HOSPITAL LOCATIONS are of interest",DIR("B")="A" K DA D ^DIR K DIR,DA
 G:$D(DIRUT) CLINIC
 S APCDHLT=Y
 I APCDHLT="A" G PRIMPROV
 D @(APCDHLT_"HL")
 G:$D(APCDQ) HOSPLOC
PRIMPROV ;
 K APCDQ
 W !!,$G(IORVON)_"Please enter the Providers whose visits you want to display",!,"This will screen on the primary provider on the visit."_$G(IORVOFF),!
 S APCDPRVT=""
 K APCDPRVS
 S DIR(0)="S^A:ALL Providers;S:Selected set or Taxonomy of Providers;O:ONE Provider",DIR("A")="Include Visits to Which Providers",DIR("B")="A"
 S DIR("A")="Enter a code indicating which providers are of interest",DIR("B")="A" K DA D ^DIR K DIR,DA
 G:$D(DIRUT) HOSPLOC
 S APCDPRVT=Y
 I APCDPRVT="A" G STATUS
 D @(APCDPRVT_"PRV")
 G:$D(APCDQ) PRIMPROV
STATUS ;
PROCESS ;
 W:$D(IOF) @IOF W !!
 W !!,"I will count visits that meet the following criteria:"
 W !!,"VISIT DATES: ",$$FMTE^XLFDT(APCDBD)," to ",$$FMTE^XLFDT(APCDED)
 W !,"VISIT TYPE:  NOT Contract"
 W !!,"LOCATION OF ENCOUNTER: " D
 .I '$D(APCDLOCS) W "All" Q
 .S Y=0,C=0 F  S Y=$O(APCDLOCS(Y)) Q:Y'=+Y  S C=C+1 W:C>1 ";" W ?24,$E($P(^DIC(4,Y,0),U),1,15)
 W !!,"SERVICE CATEGORIES: " D
 .I '$D(APCDSCS) W "All" Q
 .S Y=0,C=0 F  S Y=$O(APCDSCS(Y)) Q:Y'=+Y  S C=C+1 W:C>1 ";" W ?24,$$EXTSET^XBFUNC(9000010,.07,Y)
 W !!,"CLINICS: " D
 .I '$D(APCDCLNS) W "All" Q
 .S Y=0,C=0 F  S Y=$O(APCDCLNS(Y)) Q:Y'=+Y  S C=C+1 W:C>1 ";" W ?24,$E($P(^DIC(40.7,Y,0),U),1,15)
 W !!,"HOSPITAL LOCATIONS: " D
 .I '$D(APCDHLS) W "All" Q
 .S Y=0,C=0 F  S Y=$O(APCDHLS(Y)) Q:Y'=+Y  S C=C+1 W:C>1 ";" W ?24,$E($P(^SC(Y,0),U),1,15)
 W !!,"PRIMARY PROVIDER ON VISIT: " D
 .I '$D(APCDPRV) W "All" Q
 .S Y=0,C=0 F  S Y=$O(APCDPRVS(Y)) Q:Y'=+Y  S C=C+1 W:C>1 ";" W ?24,$E($P(^VA(200,Y,0),U),1,15)
 ;
COUNT ;
 S APCDCORL=""
 S DIR(0)="S^C:Count of Visits Only;L:List of Visits and a Count of Visits",DIR("A")="Do you want",DIR("B")="C" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G PRIMPROV
 S APCDCORL=Y
SORT ;how to sort list of visits
 S APCDSORT=""
 S DIR(0)="S^C:Clinic;O:Hospital Location"
 S DIR("A")="How would you like to "_$S(APCDCORL="C":"tally the visits",1:"sort the list of visits"),DIR("B")="C" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G XIT
 S APCDSORT=Y
ZIS ;call xbdbque
 S XBRC="DRIVER^APCDCAFE",XBRP="PRINT^APCDCAFF",XBRX="XIT^APCDCAFE",XBNS="APCD"
 D ^XBDBQUE
 D XIT
 Q
DRIVER ;EP entry point for taskman
 S APCDBT=$H,APCDJOB=$J
 K ^XTMP("APCDCAFE",APCDJOB,APCDBT)
 D ^APCDCAFF
 S APCDET=$H
 Q
XIT ;
 K DIR
 D EN^XBVK("APCD")  ;clean up APCD variables
 D ^XBFMK  ;clean up fileman variables
 D KILL^AUPNPAT  ;clean up AUPN
 D EN^XBVK("AMQQ")  ;clean up after qman
 Q
 ;
D(D) ;
 I $G(D)="" Q ""
 Q $E(D,4,5)_"/"_$E(D,6,7)_"/"_$E(D,2,3)
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
EOP ;EP - End of page.
 Q:$E(IOST)'="C"
 Q:$D(ZTQUEUED)!'(IOT="TRM")!$D(IO("S"))
 NEW DIR
 K DIRUT,DFOUT,DLOUT,DTOUT,DUOUT
 S DIR("A")="End of report.  Press Enter",DIR(0)="E" D ^DIR
 Q
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
INFORM ;inform user what this report is all about
 W !,$$CTR($$LOC)
 W !!,$$CTR("PCC/EHR CODING AUDIT")
 W !!,"This report will count all visits that were not marked as"
 W !,"reviewed/complete within a specified # of days from the date of the visit."
 W !,"The visits can be selected by date, primary provider, facility"
 W !,"clinic or hospital location.  This list can be sorted by clinic code,"
 W !," or hospital location (scheduling clinic)."
 W !,"Contract Health visits are excluded."
 W !,"Visits with the following service categories are INCLUDED in the list, "
 W !,"unless you specify otherwise when prompted to do so:"
 I '$D(^APCDSITE(DUZ(2),13,"B","A")) W !,"   - A  Ambulatory"
 I '$D(^APCDSITE(DUZ(2),13,"B","H")) W !,"   - H  Hospitalization"
 I '$D(^APCDSITE(DUZ(2),13,"B","I")) W !,"   - I  In-Hospital"
 I '$D(^APCDSITE(DUZ(2),13,"B","S")) W !,"   - S  Day Surgery"
 I '$D(^APCDSITE(DUZ(2),13,"B","O")) W !,"   - O  Observation"
 I '$D(^APCDSITE(DUZ(2),13,"B","T")) W !,"   - T  Telecommunications"
 I '$D(^APCDSITE(DUZ(2),13,"B","C")) W !,"   - C  Chart Review"
 I '$D(^APCDSITE(DUZ(2),13,"B","R")) W !,"   - R  Nursing Home"
 I '$D(^APCDSITE(DUZ(2),13,"B","N")) W !,"   - N  Not Found"
 I '$D(^APCDSITE(DUZ(2),13,"B","M")) W !,"   - M  Telemedicine"
 ;W !,"Unless you opt to include a certain set of the above categories.",!
 Q
OLOC ;one location
 S DIC="^AUTTLOC(",DIC(0)="AEMQ",DIC("A")="Which LOCATION: " D ^DIC K DIC
 I Y=-1 S APCDQ="" Q
 S APCDLOCS(+Y)=""
 Q
SLOC ;taxonomy of locations
 S X="LOCATION OF ENCOUNTER",DIC="^AMQQ(5,",DIC(0)="FM",DIC("S")="I $P(^(0),U,14)" D ^DIC K DIC,DA I Y=-1 W "OOPS - QMAN NOT CURRENT - QUITTING" G XIT
 D PEP^AMQQGTX0(+Y,"APCDLOCS(")
 I '$D(APCDLOCS) S APCDQ="" Q
 I $D(APCDLOCS("*")) S APCDLOCT="A" K APCDLOCS W !!,"**** all locations will be included ****",! Q
 Q
 ;
OCLN ;one clinic
 S DIC="^DIC(40.7,",DIC(0)="AEMQ",DIC("A")="Which CLINIC: " D ^DIC K DIC
 I Y=-1 S APCDQ="" Q
 S APCDCLNS(+Y)=""
 Q
SCLN ;taxonomy of clinics
 S X="CLINIC",DIC="^AMQQ(5,",DIC(0)="FM",DIC("S")="I $P(^(0),U,14)" D ^DIC K DIC,DA I Y=-1 W "OOPS - QMAN NOT CURRENT - QUITTING" G XIT
 D PEP^AMQQGTX0(+Y,"APCDCLNS(")
 I '$D(APCDCLNS) S APCDQ="" Q
 I $D(APCDCLNS("*")) S APCDCLNT="A" K APCDCLNS W !!,"**** all CLINICS will be included ****",! Q
 Q
 ;
OHL ;one hosp location
 S DIC="^SC(",DIC(0)="AEMQ",DIC("A")="Which HOSPITAL LOCATION: " D ^DIC K DIC
 I Y=-1 S APCDQ="" Q
 S APCDHLS(+Y)=""
 Q
SHL ;selected hospital locations
 S DIC="^SC(",DIC(0)="AEMQ",DIC("A")="Which HOSPITAL LOCATION: " D ^DIC K DIC
 I X="" Q
 I Y=-1 S APCDQ="" Q
 S APCDHLS(+Y)=""
 G SHL
OPRV ;one clinic
 S DIC="^VA(200,",DIC(0)="AEMQ",DIC("A")="Which PROVIDER: " D ^DIC K DIC
 I Y=-1 S APCDQ="" Q
 S APCDPRVS(+Y)=""
 Q
SPRV ;taxonomy of PROVIDERS
 S X="PRIMARY PROVIDER",DIC="^AMQQ(5,",DIC(0)="FM",DIC("S")="I $P(^(0),U,14)" D ^DIC K DIC,DA I Y=-1 W "OOPS - QMAN NOT CURRENT - QUITTING" G XIT
 D PEP^AMQQGTX0(+Y,"APCDPRVS(")
 I '$D(APCDPRVS) S APCDQ="" Q
 I $D(APCDPRVS("*")) S APCDPRVT="A" K APCDPRVS W !!,"**** all PROVIDERS will be included ****",! Q
 Q
 ;
SCDR ;selected CHART DEF REASONS
 S DIC="^AUTTCDR(",DIC(0)="AEMQ",DIC("A")="Which CHART DEFICIENCY REASON: " D ^DIC K DIC
 I X="" Q
 I Y=-1 S APCDQ="" Q
 S APCDCDRS(+Y)=""
 G SCDR
SSC ;
 S X="SERVICE CATEGORY",DIC="^AMQQ(5,",DIC(0)="FM",DIC("S")="I $P(^(0),U,14)" D ^DIC K DIC,DA I Y=-1 W "OOPS - QMAN NOT CURRENT - QUITTING" G DATES
 D PEP^AMQQGTX0(+Y,"APCDSCS(")
 I '$D(APCDSCS) S APCDQ="" Q
 I $D(APCDSCS("*")) S APCDSCT="A" K APCDSCS W !!,"**** all Services Categories will be included ****",! Q
 Q
OSC ;
 K DIR S DIR(0)="9000010,.07",DIR("A")="Enter SERVICE CATEGORY" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) S APCDQ="" Q
 S APCDSCS(Y)=""
 Q
