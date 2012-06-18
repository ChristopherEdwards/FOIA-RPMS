APCDDVD ; IHS/CMI/LAB - VISIT REVIEW DRIVER ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;;BJPC v1 patch 1
ZERO ;EP; for zero dependent entry report
 S APCDT="ZERO" G RDPV
PPPV ;EP; for no primary provider/pov report
 S APCDT="PPPV" G RDPV
MRG ;EP; for Merge Report
 S APCDT="MRG" G RDPV
TXER ;EP; for Transaction error Report
 S APCDT="TXER" G RDPV
INPT ;EP; for Inpatient review
 S APCDT="INPT" G RDPV
ALL ;EP;to run all Visit Error Reports
 S APCDT="ALL" G RDPV
RDPV ; Determine to run by Posting date or Visit date
 S APCDBEEP=$C(7)_$C(7),APCDSITE="" S:$D(DUZ(2)) APCDSITE=DUZ(2)
 I '$D(DUZ(2)) S APCDSITE=+^AUTTSITE(1,0)
 S DIR(0)="S^1:Posting Date;2:Visit Date",DIR("A")="Run Report by",DIR("B")="P" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G XIT
 S Y=$E(Y),APCDPROC=$S(Y=1:"P",Y=2:"V",1:Y)
GETDATES ;
BD ;get beginning date
 W ! S DIR(0)="D^:DT:EP",DIR("A")="Enter beginning "_$S(APCDPROC="P":"Posting",APCDPROC="V":"Visit",1:"Posting")_" Date for Search" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G XIT
 S APCDBD=Y
ED ;get ending date
 W ! S DIR(0)="D^"_APCDBD_":DT:EP",DIR("A")="Enter ending "_$S(APCDPROC="P":"Posting",APCDPROC="V":"Visit",1:"Posting")_" Date for Search" S Y=APCDBD D DD^%DT S DIR("B")=Y,Y="" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 S APCDED=Y
 S X1=APCDBD,X2=-1 D C^%DTC S APCDSD=X
 ;
LOC ;
 S APCDLOCT=""
 S DIR(0)="S^A:ALL Locations/Facilities;S:One SERVICE UNIT'S Locations/Facilities;O:ONE Location/Facility",DIR("A")="Include Visits to Which Location/Facilities",DIR("B")="A"
 S DIR("A")="Enter a code indicating what LOCATIONS/FACILITIES are of interest",DIR("B")="O" K DA D ^DIR K DIR,DA
 G:$D(DIRUT) GETDATES
 S APCDLOCT=Y
 I APCDLOCT="A" G CHS
 D @APCDLOCT
 G:$D(APCDQUIT) LOC
CHS ;exclude CHS or not?
 S APCDECHS=""
 W !! S DIR(0)="YO",DIR("A")="Do you want to Exclude CHS (Contract Health visits) from this report",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G LOC
 S APCDECHS=Y
 ;
CLN ;
 S APCDCLNL=""
 S DIR(0)="S^A:ALL Clinics (including null/blank clinic);O:One Clinic",DIR("A")="List Visits to",DIR("B")="A" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G CHS
 I Y="A" G ALLV
 ;which clinic
 K DIC S DIC=40.7,DIC(0)="AEMQ" D ^DIC
 I Y=-1 G CLN
 S APCDCLNL=+Y
ALLV ;
 S DIR(0)="S^1:ALL Visits in Date Range Specified;2:Only those Visits flagged to be Transmitted to DPSB",DIR("A")="Review which set of visits",DIR("B")="1" D ^DIR K DIR
 I $D(DIRUT) G BD
 S APCDVSET=+Y
SORT ;
 S APCDSORT=""
 K DIR S DIR(0)="S^H:Health Record Number;C:Clinic",DIR("A")="Sort the report by",DIR("B")="H" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G ALLV
 S APCDSORT=Y
 I APCDSORT="C" S APCDCSRT="T" G PPT
 W !!,"This report will be sorted by Patient Health Record Number."
 S APCDCSRT=""
 S DIR(0)="S^T:Terminal Digit Order;H:Health Record Number Order",DIR("A")="Sort the report by",DIR("B")="T" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G SORT
 S APCDCSRT=Y
PPT ;
 I APCDT'="PPPV" S APCDRTYP="" G DEMO
 W !!,"You have chosen to run the report of visits with No Primary Provider or Purpose",!,"of visit.  You can list only those visits with certain ancillary visits",!,"attached to them.",!
 S APCDRTYP=""
 S DIR(0)="S^R:Radiology (visits with V Radiology and no PP/PV);L:Lab (visits w/V LAB and no PP/PV);P:Pharmacy (visits w/V Medication and no PP/PV)"
 S DIR(0)=DIR(0)_";I:Immunization (visits w/V Immunization and no PP/PV);A:ALL visits with no PP/PV",DIR("A")="Which Incomplete Visits do you wish to list",DIR("B")="A" KILL DA D ^DIR KILL DIR
 G:$D(DIRUT) SORT
 S APCDRTYP=Y
DOPRV ;
 S APCDDOPP=""
 W !!,"Do you wish to display the different ordering providers from the",!,"ancillary items (labs, meds, immunizations) with the visit.",!,"Displaying these will make the report longer in length but"
 W !,"may assist you in visit merging or completion.",!
 S DIR(0)="Y",DIR("A")="Do you want to display the ORDERING PROVIDERS from the data items",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G PPT
 S APCDDOPP=Y
DLPOV ;
 S APCDDLPV=""
 I APCDRTYP'="L",APCDRTYP'="A" G DEMO
 W !!,"Your lab personnel may be entering a diagnosis with the lab tests.",!,"You can display these diagnoses on this report.  Displaying"
 W !,"these may make the report a little longer but could assist you",!,"with billing and/or visit clean up.",!
 S DIR(0)="Y",DIR("A")="Do you want to display the LAB diagnoses",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G DOPRV
 S APCDDLPV=Y
DEMO ;
 D DEMOCHK^APCLUTL(.APCDDEMO)
 I APCDDEMO=-1 G SORT
ZIS ;call xbdbque
 S XBRC="DRIVER^APCDDVD",XBRP="PRINT^APCDDVD",XBRX="XIT^APCDDVD",XBNS="APCD"
 D ^XBDBQUE
 D XIT
 Q
DRIVER ;EP entry point for taskman
 S APCDBT=$H,APCDJOB=$J
 K ^XTMP("APCDDV",APCDJOB,APCDBT)
 D ^APCDDVD1
 S APCDET=$H
 Q
PRINT ;EP
 D ^APCDDVW
 K ^XTMP("APCDDV",APCDJOB,APCDBT)
 Q
XIT ;EP
 K APCDBEEP,APCDX,APCDBD,APCDT,APCDED,APCDSD,APCDODAT,APCDVSIT,%,APCDL,X,X1,X2,IO("Q"),APCDDT,APCDSITE,APCDLC,APCDPAGE,APCDCAT,APCDTYPE,APCPTX,APCDADM,APCDPS,APCDPVP,APCDFILE,APCDEC,APCDBT,APCDET,APCDQIO,APCDJOB,APCDPROC,APCD
 K APCDDV("VREC"),APCDVSET,APCDBDFN,APCDDEMM,APCDDEM,APCDCLN,APCDCL,APCDH,APCDCLOC,APCDCSRT,APCDDCHS,APCDHRN,APCDLOC,APCDLOCT,APCDQUIT
 D EN2^APCDEKL
 K X,X1,X2,IO("Q"),%DT,%ZIS,%,DUOUT,DLOUT,Y
 Q
ERR W APCDBEEP,!,"Must be a valid date and be Today or earlier. Time not allowed!" Q
O ;one community
 S DIC="^AUTTLOC(",DIC(0)="AEMQ",DIC("A")="Which LOCATION: " D ^DIC K DIC
 I Y=-1 S APCDQUIT="" Q
 S APCDLOCT("ONE")=+Y
 Q
S ;all communities within APCDSU su
 S DIC="^AUTTSU(",DIC("B")=$$VAL^XBDIQ1(9999999.06,DUZ(2),.05),DIC(0)="AEMQ",DIC("A")="Which SERVICE UNIT: " D ^DIC K DIC
 I Y=-1 S APCDQUIT="" Q
 S APCDLOCT("SU")=+Y
 Q
 ;
