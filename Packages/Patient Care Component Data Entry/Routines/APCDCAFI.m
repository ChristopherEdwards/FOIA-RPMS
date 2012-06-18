APCDCAFI ; IHS/CMI/LAB - ;
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
FAC ;
 K APCDQ
 W !!,$G(IORVON)_"Please enter which FACILITY visits will be included in the list."_$G(IORVOFF),!
 S APCDLOCT=""
 K APCDLOCS
 S DIR(0)="S^A:ALL Locations/Facilities;S:Selected set or Taxonomy of Locations;O:ONE Location/Facility",DIR("A")="Include Visits to Which Location/Facilities",DIR("B")="A"
 S DIR("A")="Enter a code indicating what LOCATIONS/FACILITIES are of interest",DIR("B")="A" K DA D ^DIR K DIR,DA
 G:$D(DIRUT) DATES
 S APCDLOCT=Y
 I APCDLOCT="A" G CLINIC
 D @(APCDLOCT_"LOC")
 G:$D(APCDQ) FAC
CLINIC ;
 K APCDQ
 W !!,$G(IORVON)_"Please enter which CLINIC (IHS clinic codes) visits will be included",!,"in the list."_$G(IORVOFF),!
 S APCDCLNT=""
 K APCDCLNS
 K DIR S DIR(0)="S^A:ALL Clinics;S:Selected set or Taxonomy of Clinics;O:ONE Clinic",DIR("A")="Include Visits to Which Clinics",DIR("B")="A"
 S DIR("A")="Enter a code indicating what CLINICS (IHS clinic code) are of interest",DIR("B")="A" K DA D ^DIR K DIR,DA
 G:$D(DIRUT) FAC
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
 ;K APCDQ
 ;W !!,"You can choose to display visits with a particular chart audit status: Reviewed",!,"or Incomplete.",!
 ;S APCDCAST=""
 ;K APCDCASS
STATUS1 ;
 ;S DIR(0)="9000010.45,.04O",DIR("A")="Include Visits with which Chart Audit Status",DIR("B")="I" KILL DA D ^DIR KILL DIR
 ;I $D(DIRUT) G CDR
 ;I Y="" G CDR
 ;S APCDCASS(Y)=""
CDR ;
 K APCDQ
 W !!,"A chart deficiency reason may have been previously entered for a visit."
 W !,"If you wish to display only visits whose LAST chart deficiency reason matches"
 W !,"one or more that you select, please enter them.",!
 S APCDCDRT=""
 K APCDCDRS
 S DIR(0)="S^D:Do NOT screen on Chart Deficiency Reason;S:Screen on Chart Deficiency Reason",DIR("A")="Include Visits to Which Hospital Locations",DIR("B")="A"
 S DIR("A")="Select visits based on chart deficiency reason",DIR("B")="D" K DA D ^DIR K DIR,DA
 G:$D(DIRUT) STATUS
 S APCDCDRT=Y
 I APCDCDRT="D" G PROCESS
 D @(APCDCDRT_"CDR")
 G:$D(APCDQ) CDR
PROCESS ;
 W:$D(IOF) @IOF W !!
 W !!,"I will display visits that meet the following criteria:"
 W !!,"VISIT DATES: ",$$FMTE^XLFDT(APCDBD)," to ",$$FMTE^XLFDT(APCDED)
 ;W !,"SERVICE CATEGORY: A, O, S, C, T, R"
 W !,"VISIT TYPE:  NOT Contract"
 W !,"Visits with at least one POV and Primary Provider."
 W !!,"LOCATION OF ENCOUNTER: " D
 .I '$D(APCLLOCS) W "All" Q
 .S Y=0,C=0 F  S Y=$O(APCDLOCS(Y)) Q:Y'=+Y  S C=C+1 W:C>1 ";" W ?24,$E($P(^DIC(4,Y,0),U),1,15)
 W !!,"CLINICS: " D
 .I '$D(APCLCLNS) W "All" Q
 .S Y=0,C=0 F  S Y=$O(APCDCLNS(Y)) Q:Y'=+Y  S C=C+1 W:C>1 ";" W ?24,$E($P(^DIC(40.7,Y,0),U),1,15)
 W !!,"HOSPITAL LOCATIONS: " D
 .I '$D(APCLHLS) W "All" Q
 .S Y=0,C=0 F  S Y=$O(APCDHLS(Y)) Q:Y'=+Y  S C=C+1 W:C>1 ";" W ?24,$E($P(^SC(Y,0),U),1,15)
 W !!,"PRIMARY PROVIDER ON VISIT: " D
 .I '$D(APCLPRV) W "All" Q
 .S Y=0,C=0 F  S Y=$O(APCDPRVS(Y)) Q:Y'=+Y  S C=C+1 W:C>1 ";" W ?24,$E($P(^VA(200,Y,0),U),1,15)
 ;W !!,"CHART AUDIT STATUS: " D
 ;.I '$D(APCDCASS) W "All" Q
 ;.S Y=0,C=0 F  S Y=$O(APCDCASS(Y)) Q:Y'=+Y  S C=C+1 W:C>1 ";" W ?24,$$EXTSET^XBFUNC(9000010.45,Y,.04)
 W !!,"CHART DEFICIENCY REASONS: " D
 .I '$D(APCLCDRS) W "All (includes visits with no chart deficiency reason entered" Q
 .S Y=0,C=0 F  S Y=$O(APCDCDRS(Y)) Q:Y'=+Y  S C=C+1 W:C>1 ";" W ?24,$E($P(^AUTTCDR(Y,0),U),1,15)
SORT ;how to sort list of visits
 S APCDSORT=""
 S DIR(0)="S^N:Patient Name;H:HRN;D:Date of Visit;T:Terminal Digit of HRN;S:Service Category;L:Location of Encounter;C:Clinic;O:Hospital Location;P:Primary Provider;A:Chart Audit Status;R:Chart Deficiency Reason (Last one entered)"
 S DIR("A")="How would you like the list of visits sorted",DIR("B")="D" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G XIT
 S APCDSORT=Y
ZIS ;call xbdbque
 S XBRC="DRIVER^APCDCAFI",XBRP="PRINT^APCDCAFJ",XBRX="XIT^APCDCAFI",XBNS="APCD"
 D ^XBDBQUE
 D XIT
 Q
DRIVER ;EP entry point for taskman
 S APCDBT=$H,APCDJOB=$J
 K ^XTMP("APCDCAFI",APCDJOB,APCDBT)
 D ^APCDCAFJ
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
 W !!,"This report will list all visits with a chart audit status of I-Incomplete."
 W !,"The visits can be selected by date, primary provider,"
 W !,"chart audit status.  This list can be sorted by date, primary provider"
 W !,"clinic code, hospital location (scheduling clinic), or facility."
 W !,"Contract Health visits are excluded."
 ;W !,"Visits with the following service categories are INCLUDED in the list:"
 ;I '$D(^APCDSITE(DUZ(2),13,"B","A")) W !,"   - A  Ambulatory"
 ;I '$D(^APCDSITE(DUZ(2),13,"B","H")) W !,"   - H  Hospitalization"
 ;I '$D(^APCDSITE(DUZ(2),13,"B","I")) W !,"   - I  In-Hospital"
 ;I '$D(^APCDSITE(DUZ(2),13,"B","S")) W !,"   - S  Day Surgery"
 ;I '$D(^APCDSITE(DUZ(2),13,"B","O")) W !,"   - O  Observation"
 ;I '$D(^APCDSITE(DUZ(2),13,"B","T")) W !,"   - T  Telecommunications"
 ;I '$D(^APCDSITE(DUZ(2),13,"B","C")) W !,"   - C  Chart Review"
 ;I '$D(^APCDSITE(DUZ(2),13,"B","R")) W !,"   - R  Nursing Home"
 ;I '$D(^APCDSITE(DUZ(2),13,"B","N")) W !,"   - N  Not Found"
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
 Q
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
 Q
