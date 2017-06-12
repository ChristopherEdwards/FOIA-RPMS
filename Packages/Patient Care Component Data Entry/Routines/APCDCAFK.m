APCDCAFK ; IHS/CMI/LAB - ; 19 Dec 2014  2:06 PM
 ;;2.0;IHS PCC SUITE;**2,5,11,16**;MAY 14, 2009;Build 9
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
 ;
VD ;
 S (APCDBD,APCDED)=""
 S DIR(0)="S^A:All Visits;S:Visits in a Date Range",DIR("A")="What Visit date range should be included",DIR("B")="A" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G XIT
 I Y="A" G FAC
DATES ;K APCDED,APCDBD
 K DIR W ! S DIR(0)="DO^::EXP",DIR("A")="Enter Beginning Visit Date"
 D ^DIR G:Y<1 VD S APCDBD=Y
 K DIR S DIR(0)="DO^:DT:EXP",DIR("A")="Enter Ending Visit Date"
 D ^DIR G:Y<1 VD  S APCDED=Y
 ;
 I APCDED<APCDBD D  G DATES
 . W !!,$C(7),"Sorry, Ending Date MUST not be earlier than Beginning Date."
 ;
FAC ;
 K APCDQ
 W !!,$G(IORVON)_"Please enter which FACILITY visits will be included in the list."_$G(IORVOFF),!
 S APCDLOCT=""
 K APCDLOCS
 S DIR(0)="S^A:ALL Locations/Facilities;S:Selected set or Taxonomy of Locations;O:ONE Location/Facility",DIR("A")="Include Visits to Which Location/Facilities",DIR("B")="A"
 S DIR("A")="Enter a code indicating what LOCATIONS/FACILITIES are of interest",DIR("B")="A" K DA D ^DIR K DIR,DA
 G:$D(DIRUT) XIT
 S APCDLOCT=Y
 I APCDLOCT="A" G HOSPLOC
 D @(APCDLOCT_"LOC")
 G:$D(APCDQ) FAC
HOSPLOC ;
 K APCDQ
 W !!,$G(IORVON)_"Please enter which HOSPITAL LOCATIONS will be included in the list."_$G(IORVOFF),!
 S APCDHLT=""
 K APCDHLS
 S DIR(0)="S^A:ALL Hospital Locations;S:Selected set of Hospital Locations;O:ONE Hospital Location",DIR("A")="Include Visits to Which Hospital Locations",DIR("B")="A"
 S DIR("A")="Enter a code indicating what HOSPITAL LOCATIONS are of interest",DIR("B")="A" K DA D ^DIR K DIR,DA
 G:$D(DIRUT) FAC
 S APCDHLT=Y
 I APCDHLT="A" G CLINIC
 D @(APCDHLT_"HL")
 G:$D(APCDQ) HOSPLOC
CLINIC ;
 K APCDQ
 W !!,$G(IORVON)_"Please enter which CLINIC (IHS clinic codes) visits will be included",!,"in the list."_$G(IORVOFF),!
 S APCDCLNT=""
 K APCDCLNS
 K DIR S DIR(0)="S^A:ALL Clinics;S:Selected set or Taxonomy of Clinics;O:ONE Clinic",DIR("A")="Include Visits to Which Clinics",DIR("B")="A"
 S DIR("A")="Enter a code indicating what CLINICS (IHS clinic code) are of interest",DIR("B")="A" K DA D ^DIR K DIR,DA
 G:$D(DIRUT) HOSPLOC
 S APCDCLNT=Y
 I APCDCLNT="A" G SC
 D @(APCDCLNT_"CLN")
 G:$D(APCDQ) CLINIC
SC ;
 K APCDQ
 W !!,$G(IORVON)_"Please enter which SERVICE CATEGORIES will be included",!,"in the list."_$G(IORVOFF),!
 S APCDSCT=""
 K APCDSCS
 K DIR S DIR(0)="S^A:ALL Service Categories;S:Selected set or Taxonomy of Service Categories;O:One Service Category",DIR("A")="Include Visits to Which Service Categories",DIR("B")="A"
 S DIR("A")="Enter a code indicating what SERVICE CATEGORIES are of interest",DIR("B")="A" K DA D ^DIR K DIR,DA
 G:$D(DIRUT) CLINIC
 S APCDSCT=Y
 I APCDSCT="A" G PROV
 D @(APCDSCT_"SC")
 G:$D(APCDQ) SC
PROV ;
 K APCDQ
 S APCDPRVT=""
 K APCDPRVS
 S DIR(0)="S^A:ALL Providers;S:Selected set or Taxonomy of Providers;O:ONE Provider",DIR("A")="Include Which Providers",DIR("B")="A"
 S DIR("A")="Enter a code indicating which providers are of interest",DIR("B")="A" K DA D ^DIR K DIR,DA
 G:$D(DIRUT) SC
 S APCDPRVT=Y
 I APCDPRVT="A" G PROCESS
 D @(APCDPRVT_"PRV")
 G:$D(APCDQ) PROV
PROCESS ;
 W:$D(IOF) @IOF W !!
 W !!,"I will display provider deficiencies that meet the following criteria:"
 W !!,"LOCATION OF ENCOUNTER: " D
 .I '$D(APCDLOCS) W "All" Q
 .S Y=0,C=0 F  S Y=$O(APCDLOCS(Y)) Q:Y'=+Y  S C=C+1 W:C>1 ";" W ?24,$E($P(^DIC(4,Y,0),U),1,15)
 W !!,"HOSPITAL LOCATIONS: " D
 .I '$D(APCDHLS) W "All" Q
 .S Y=0,C=0 F  S Y=$O(APCDHLS(Y)) Q:Y'=+Y  S C=C+1 W:C>1 ";" W ?24,$E($P(^SC(Y,0),U),1,15)
 W !!,"CLINICS: " D
 .I '$D(APCDCLNS) W "All" Q
 .S Y=0,C=0 F  S Y=$O(APCDCLNS(Y)) Q:Y'=+Y  S C=C+1 W:C>1 ";" W ?24,$E($P(^DIC(40.7,Y,0),U),1,15)
 W !!,"SERVICE CATEGORIES: " D
 .I '$D(APCDSCS) W "All" Q
 .S Y=0,C=0 F  S Y=$O(APCDSCS(Y)) Q:Y'=+Y  S C=C+1 W:C>1 ";" W ?24,$$EXTSET^XBFUNC(9000010,.07,Y)
 W !!,"PROVIDERS: " D
 .I '$D(APCDPRVS) W "All" Q
 .S Y=0,C=0 F  S Y=$O(APCDPRVS(Y)) Q:Y'=+Y  S C=C+1 W:C>1 ";" W ?24,$E($P(^VA(200,Y,0),U),1,15)
RTYPE ;how to sort list of visits
 S APCDRTYP=""
 S DIR(0)="S^1:Individual Provider Listings Only;2:Summary Page Only;3:Both",DIR("A")="Select Report Type",DIR("B")="3" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G PROV
 S APCDRTYP=Y
 I APCDRTYP=2 G ZIS
PAGE ;
 S APCDSPAG=0
 S DIR(0)="Y",DIR("A")="Do you want each provider's listing on a separate page",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G RTYPE
 S APCDSPAG=Y
ZIS ;call xbdbque
 S DIR(0)="S^P:PRINT Output;B:BROWSE Output on Screen",DIR("A")="Do you wish to ",DIR("B")="P" K DA D ^DIR K DIR
 I $D(DIRUT) G RTYPE
 I $G(Y)="B" D BROWSE,XIT Q
 S XBRC="DRIVER^APCDCAFK",XBRP="PRINT^APCDCAFK",XBRX="XIT^APCDCAFK",XBNS="APCD"
 D ^XBDBQUE
 D XIT
 Q
BROWSE ;
 S XBRP="VIEWR^XBLM(""PRINT^APCDCAFK"")"
 S XBNS="APCD",XBRC="DRIVER^APCDCAFK",XBRX="XIT^APCDCAFK",XBIOP=0 D ^XBDBQUE
 Q
 ;
DRIVER ;EP entry point for taskman
 S APCDBT=$H,APCDJOB=$J
 K ^XTMP("APCDCAFK",APCDJOB,APCDBT)
 S APCDPROV=0
 F  S APCDPROV=$O(^AUPNCANT("APEND",APCDPROV)) Q:APCDPROV'=+APCDPROV  D
 .I $D(APCDPRVS),'$D(APCDPRVS(APCDPROV)) Q  ;not a PROV we want
 .S APCDV=0 F  S APCDV=$O(^AUPNCANT("APEND",APCDPROV,APCDV)) Q:APCDV'=+APCDV  D
 ..S APCDV0=^AUPNVSIT(APCDV,0)
 ..Q:'$P(APCDV0,U,9)        ;NO DEP ENTRIES
 ..Q:$P(APCDV0,U,11)        ;DELETED
 ..I APCDBD,$$VD^APCLV(APCDV)<APCDBD Q
 ..I APCDED,$$VD^APCLV(APCDV)>APCDED Q
 ..S APCDVLOC=$P(APCDV0,U,6)
 ..Q:APCDVLOC=""
 ..I $D(APCDLOCS),'$D(APCDLOCS(APCDVLOC)) Q  ;not a location we want
 ..S X=$P(APCDV0,U,7)
 ..Q:X=""  ;no sc
 ..I $D(APCDSCS),'$D(APCDSCS(X)) Q  ;not a sc we want
 ..S APCDVCLN=$P(APCDV0,U,8)
 ..I APCDVCLN="",$D(APCDCLNS) Q  ;clinic blank and want certain clinics
 ..I $D(APCDCLNS),'$D(APCDCLNS(APCDVCLN)) Q  ;not a CLINIC we want
 ..S APCDVHL=$P(APCDV0,U,22)
 ..I APCDVHL="",$D(APCDHLS) Q  ;HOSP LOC blank and want certain HOSP LOCS
 ..I $D(APCDHLS),'$D(APCDHLS(APCDVHL)) Q  ;not a HOSP LOC we want
 ..S $P(^XTMP("APCDCAFK",APCDJOB,APCDBT,"PROV","SUMMARY",APCDPROV),U,1)=$P($G(^XTMP("APCDCAFK",APCDJOB,APCDBT,"PROV","SUMMARY",APCDPROV)),U,1)+1
 ..S D=$$FMDIFF^XLFDT(DT,$$VD^APCLV(APCDV))
 ..S E=$P($G(^APCDSITE(DUZ(2),0)),U,38) S:E="" E=3 I D>E S $P(^XTMP("APCDCAFK",APCDJOB,APCDBT,"PROV","SUMMARY",APCDPROV),U,2)=$P($G(^XTMP("APCDCAFK",APCDJOB,APCDBT,"PROV","SUMMARY",APCDPROV)),U,2)+1
 ..;NOW STORE EACH DEFICIENCY
 ..S APCDI=0 F  S APCDI=$O(^AUPNCANT("APEND",APCDPROV,APCDV,APCDI)) Q:APCDI'=+APCDI  D
 ...S ^XTMP("APCDCAFK",APCDJOB,APCDBT,"PROV",APCDPROV,$$VD^APCLV(APCDV),APCDV,APCDI)=""
 ...;SUMMARY INFO
 ...S X=$P(^AUPNCANT(APCDV,12,APCDI,0),U,2)
 ...S ^XTMP("APCDCAFK",APCDJOB,APCDBT,"PROV","CDR",APCDPROV,X)=$G(^XTMP("APCDCAFK",APCDJOB,APCDBT,"PROV","CDR",APCDPROV,X))+1
 S APCDET=$H
 Q
XIT ;
 K DIR
 D EN^XBVK("APCD")
 D ^XBFMK
 D KILL^AUPNPAT
 D EN^XBVK("AMQQ")
 Q
 ;
D(D) ;
 I $G(D)="" Q ""
 Q $E(D,4,5)_"/"_$E(D,6,7)_"/"_$E(D,2,3)
CTR(X,Y) ;EP
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
USR() ;EP
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
INFORM ;
 W !,$$CTR($$LOC)
 W !!,$$CTR("PCC/EHR CODING AUDIT")
 W !!,"This report will list all PENDING deficiencies for a selected"
 W !,"set of providers."
 Q
OLOC ;one location
 D OLOC^APCDCAFD
 Q
SLOC ;
 D SLOC^APCDCAFD
 Q
 ;
OCLN ;one clinic
 D OCLN^APCDCAFD
 Q
SCLN ;taxonomy of clinics
 D SCLN^APCDCAFD
 Q
 ;
OHL ;
 S DIC="^SC(",DIC(0)="AEMQ",DIC("A")="Which HOSPITAL LOCATION: " D ^DIC K DIC
 I Y=-1 S APCDQ="" Q
 S APCDHLS(+Y)=""
 Q
SHL ;
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
SPRV ;
 S X="PRIMARY PROVIDER",DIC="^AMQQ(5,",DIC(0)="FM",DIC("S")="I $P(^(0),U,14)" D ^DIC K DIC,DA I Y=-1 W "OOPS - QMAN NOT CURRENT - QUITTING" G XIT
 D PEP^AMQQGTX0(+Y,"APCDPRVS(")
 I '$D(APCDPRVS) S APCDQ="" Q
 I $D(APCDPRVS("*")) S APCDPRVT="A" K APCDPRVS W !!,"**** all PROVIDERS will be included ****",! Q
 Q
 ;
SSC ;
 S X="SERVICE CATEGORY",DIC="^AMQQ(5,",DIC(0)="FM",DIC("S")="I $P(^(0),U,14)" D ^DIC K DIC,DA I Y=-1 W "OOPS - QMAN NOT CURRENT - QUITTING" G FAC
 D PEP^AMQQGTX0(+Y,"APCDSCS(")
 I '$D(APCDSCS) S APCDQ="" Q
 I $D(APCDSCS("*")) S APCDSCT="A" K APCDSCS W !!,"**** all Services Categories will be included ****",! Q
 Q
OSC ;
 K DIR S DIR(0)="9000010,.07",DIR("A")="Enter SERVICE CATEGORY" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) S APCDQ="" Q
 S APCDSCS(Y)=""
 Q
 ;----------
PRINT ;EP - called from xbdbque
 S APCD80S="-------------------------------------------------------------------------------"
 S APCDPG=0
 K APCDQUIT
 D COVPAGE
 D PRINT1
DONE ;
 I $D(APCDQUIT) G XIT1
 I $E(IOST)="C",IO=IO(0) S DIR(0)="E" D ^DIR K DIR
 W:$D(IOF) @IOF
XIT1 ; Clean up and exit
 K ^XTMP("APCDCAFK",APCDJOB,APCDBT,"PROV")
 D EN^XBVK("APCD")
 Q
SH ;
 W !!?10,"Incomplete Charts for ",$$GET1^DIQ(200,APCDS,.01)
 Q
PRINT1 ;
 K APCDQUIT
 I APCDRTYP=2 G SUMPAGE
 I 'APCDSPAG D HEAD
 I '$D(^XTMP("APCDCAFK",APCDJOB,APCDBT,"PROV")) W !!,"There are no pending deficiencies that meet the report criteria." Q
 S APCDS="" F  S APCDS=$O(^XTMP("APCDCAFK",APCDJOB,APCDBT,"PROV",APCDS)) Q:APCDS'=+APCDS!($D(APCDQUIT))  D
 .I APCDSPAG D HEAD Q:$D(APCDQUIT)
 .D SH
 .S APCDDATE=0 F  S APCDDATE=$O(^XTMP("APCDCAFK",APCDJOB,APCDBT,"PROV",APCDS,APCDDATE)) Q:APCDDATE'=+APCDDATE!($D(APCDQUIT))  D
 ..S APCDV="" F  S APCDV=$O(^XTMP("APCDCAFK",APCDJOB,APCDBT,"PROV",APCDS,APCDDATE,APCDV)) Q:APCDV=""!($D(APCDQUIT))  D
 ...I $Y>(IOSL-5) D HEAD Q:$D(APCDQUIT)  D SH
 ...W !,$E($$VAL^XBDIQ1(9000010,APCDV,.05),1,21)
 ...S APCDVR=^AUPNVSIT(APCDV,0) S:'$P(APCDVR,U,6) $P(APCDVR,U,6)=0
 ...S DFN=$P(APCDVR,U,5)
 ...S APCDHRN="" S APCDHRN=$$HRN^AUPNPAT(DFN,$P(APCDVR,U,6),2)
 ...S APCDHRN="" S APCDHRN=$$HRN^AUPNPAT(DFN,DUZ(2))
 ...W ?22,APCDHRN
 ...W ?29,$$DATE(APCDDATE),?40,$P(APCDVR,U,7)
 ...S APCDC=0 S APCDI=0 F  S APCDI=$O(^XTMP("APCDCAFK",APCDJOB,APCDBT,"PROV",APCDS,APCDDATE,APCDV,APCDI)) Q:APCDI'=+APCDI!($D(APCDQUIT))  D
 ....S APCDC=APCDC+1
 ....I $Y>(IOSL-3) D HEAD Q:$D(APCDQUIT)  D SH
 ....I APCDC>1 W !
 ....S APCDIENS=APCDI_","_APCDV W ?43,$$GET1^DIQ(9000095.12,APCDIENS,.02)
 ....W ?76,$$FMDIFF^XLFDT(DT,$$VD^APCLV(APCDV))
 ....I $$GET1^DIQ(9000095.12,APCDIENS,.1)]"" W !?2,"Comment: ",$$GET1^DIQ(9000095.12,APCDIENS,.1)
 ...I $O(^AUPNCANT(APCDV,11,0)) D
 ....I $Y>(IOSL-3) D HEAD Q:$D(APCDQUIT)  D SH
 ....W !?2,"Chart Audit Notes:"
 ....K ^UTILITY($J,"W")
 ....S DIWR=70,DIWL=0 S Y=0 S Y=$O(^AUPNCANT(APCDV,11,Y)) Q:Y'=+Y  S X=^AUPNCANT(APCDV,11,Y,0) D ^DIWP
 ....S Z=0 F  S Z=$O(^UTILITY($J,"W",DIWL,Z)) Q:Z'=+Z  D
 .....I $Y>(IOSL-2) D HEAD Q:$D(APCDQUIT)  D SH
 .....W !?2,^UTILITY($J,"W",DIWL,Z,0)
 ...K DIWL,DIWR,DIWF,Z
 ...K ^UTILITY($J,"W")
 I APCDRTYP=1 Q
 I $D(APCDQUIT) Q
 D SUMPAGE
 Q
DATE(D) ;EP
 I D="" Q ""
 Q $E(D,4,5)_"/"_$E(D,6,7)_"/"_(1700+$E(D,1,3))
HEAD ;EP;HEADER
 I 'APCDPG G HEAD1
HEAD2 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCDQUIT="" Q
HEAD1 ;
 W:$D(IOF) @IOF S APCDPG=APCDPG+1
 W !,$$FMTE^XLFDT($$NOW^XLFDT),?40,$P(^VA(200,DUZ,0),U,2),?70,"Page: ",APCDPG
 W !,$$CTR("Confidential Patient Data Covered by Privacy Act",80)
 W !,$$CTR("Incomplete Charts by Provider and Deficiency",80)
 I $G(APCDSUM) W !,$$CTR("SUMMARY PAGE",80)
 W !,$TR($J(" ",80)," ","-")
 I '$G(APCDSUM) W !!,"Patient",?22,"HRCN",?29,"Visit Date",?40,"SC",?43,"Deficiencies",?76,"Days"
 I $G(APCDSUM) W !!,"PROVIDER",?26,"INCOMP",?33,"DELINQ",?40,"DEFICIENCIES"
 I $G(APCDSUM) W !?26,"CHARTS",?33,"CHARTS"
 W !,APCD80S
 Q
COVPAGE ;
 W !,$$FMTE^XLFDT($$NOW^XLFDT()),?40,$P(^VA(200,DUZ,0),U,2),"   Confidential Patient Data Covered by Privacy Act" ;,?70,"Page: ",APCDPG
 W !,$$CTR("***********************************",80)
 W !,$$CTR("*   PROVIDER CHART DEFICIENCIES   *",80)
 W !,$$CTR("***********************************",80)
 W !!,"PROVIDERS: " D
 .I '$D(APCDPRV) W "All" Q
 .S Y=0,C=0 F  S Y=$O(APCDPRVS(Y)) Q:Y'=+Y  S C=C+1 W:C>1 ";" W ?24,$E($P(^VA(200,Y,0),U),1,15)
 W !!,$$CTR("VISIT DEFICIENCY CRITERIA",80)
 W !!,"LOCATION OF ENCOUNTER: " D
 .I '$D(APCDLOCS) W "All" Q
 .S Y=0,C=0 F  S Y=$O(APCDLOCS(Y)) Q:Y'=+Y  S C=C+1 W:C>1 ";" W ?24,$E($P(^DIC(4,Y,0),U),1,15)
 W !!,"HOSPITAL LOCATIONS: " D
 .I '$D(APCDHLS) W "All" Q
 .S Y=0,C=0 F  S Y=$O(APCDHLS(Y)) Q:Y'=+Y  S C=C+1 W:C>1 ";" W ?24,$E($P(^SC(Y,0),U),1,15)
 W !!,"CLINICS: " D
 .I '$D(APCDCLNS) W "All" Q
 .S Y=0,C=0 F  S Y=$O(APCDCLNS(Y)) Q:Y'=+Y  S C=C+1 W:C>1 ";" W ?24,$E($P(^DIC(40.7,Y,0),U),1,15)
 W !!,"SERVICE CATEGORIES: " D
 .I '$D(APCDSCS) W "All" Q
 .S Y=0,C=0 F  S Y=$O(APCDSCS(Y)) Q:Y'=+Y  S C=C+1 W:C>1 ";" W ?24,$$EXTSET^XBFUNC(9000010,.07,Y)
 Q
SUMPAGE ;
 S APCDSUM=1
 D HEAD
 I '$D(^XTMP("APCDCAFK",APCDJOB,APCDBT,"PROV")) W !!,"There are no pending deficiencies that meet the report criteria." Q
 S APCDS=0 F  S APCDS=$O(^XTMP("APCDCAFK",APCDJOB,APCDBT,"PROV","SUMMARY",APCDS)) Q:APCDS'=+APCDS  D
 .I $Y>(IOSL-4) D HEAD Q:$D(APCDQUIT)
 .S S=^XTMP("APCDCAFK",APCDJOB,APCDBT,"PROV","SUMMARY",APCDS)
 .W !,$E($P(^VA(200,APCDS,0),U),1,25),?27,+$P(S,U,1),?33,+$P(S,U,2)
 .;deficiencies
 .S APCDDEF=""
 .S APCDI=0 F  S APCDI=$O(^XTMP("APCDCAFK",APCDJOB,APCDBT,"PROV","CDR",APCDS,APCDI)) Q:APCDI'=+APCDI  D
 ..S:APCDDEF]"" APCDDEF=APCDDEF_", "
 ..S APCDDEF=APCDDEF_$P(^AUTTCDR(APCDI,0),U,1)_" ("_^XTMP("APCDCAFK",APCDJOB,APCDBT,"PROV","CDR",APCDS,APCDI)_")"
 .K ^UTILITY($J,"W") S X=APCDDEF,DIWL=0,DIWR=40 D ^DIWP
 .W ?40,$G(^UTILITY($J,"W",0,1,0))
 .I $O(^UTILITY($J,"W",0,1)) D
 ..S X=1 S X=$O(^UTILITY($J,"W",0,X)) Q:X'=+X  W !?40,^UTILITY($J,"W",0,X,0)
 .W !
 .K ^UTILITY($J,"W")
 Q
