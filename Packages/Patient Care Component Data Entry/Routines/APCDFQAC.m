APCDFQAC ; IHS/CMI/LAB - QA AUDIT ON ICD CODING ;
 ;;2.0;IHS PCC SUITE;**11**;MAY 14, 2009;Build 58
 ;
START ; 
 S APCDSITE="" S:$D(DUZ(2)) APCDSITE=DUZ(2)
 I '$D(DUZ(2)) W $C(7),$C(7),!!,"SITE NOT SET IN DUZ(2) - NOTIFY SITE MANAGER!!",!! K APCDSITE Q
 I 'DUZ(2) W $C(7),$C(7),!!,"SITE NOT SET IN DUZ(2) - NOTIFY SITE MANAGER",!! K APCDSITE Q
 W:$D(IOF) @IOF
 S APCDLHDR="ICD DIAGNOSIS CODING AUDIT FOR SELECTED SET OF VISITS"
 W !?((80-$L(APCDLHDR))/2),APCDLHDR
 W !!,"This report will list the purpose of visits for visits that you select."
 W !,"The ICD code and provider narrative will be displayed so that coding"
 W !,"can be reviewed."
 W !,"You will be able to select visits by the following items:"
 W !?5,"- Visit date or Date Last Modified"
 W !?5,"- Service Category"
 W !?5,"- Clinic"
 W !?5,"- Operator who last marked the visit as reviewed complete"
 W !?10,"or last modified the POV"
 W !?5,"- Visits marked as Reviewed/Complete or All Visits"
 W !?10,"NOTE:  since Hospital, Telephone, Chart Review visits don't need"
 W !?10,"to be marked as reviewed/complete in the coding queue, select all"
 W !?10,"visits if you want those included."
 W !?5,"- Visit by ICD diagnosis code"
 S APCDJOB=$J,APCDBT=$H
 K ^XTMP("APCDFQA",APCDJOB,APCDBT)
DLMVD ;RUN BY DATE LAST MODIFIED OR VISIT DATE?
 S APCDSITE="" S:$D(DUZ(2)) APCDSITE=DUZ(2)
 I '$D(DUZ(2)) S APCDSITE=+^AUTTSITE(1,0)
 S DIR(0)="S^1:Date Visit Last Modified;2:Visit Date",DIR("A")="Run Report by",DIR("B")="1" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G XIT
 S Y=$E(Y),APCDPROC=$S(Y=1:"M",Y=2:"V",1:Y),APCDPROD=$S(Y=1:"Last Modified",1:"Visit"),APCDXREF=$S(Y=1:"ADLM",2:"B")
GETDATES ;
BD ;get beginning date
 W ! S DIR(0)="D^:DT:EP",DIR("A")="Enter Beginning "_APCDPROD_" Date" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G DLMVD
 S APCDBD=Y
ED ;get ending date
 W ! S DIR(0)="DA^"_APCDBD_":DT:EP",DIR("A")="Enter Ending "_APCDPROD_" Date: " S Y=APCDBD D DD^%DT S DIR("B")=Y,Y="" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 S APCDED=Y
 S X1=APCDBD,X2=-1 D C^%DTC S APCDSD=X
SC ;
 W !
 K APCDSCT
 K APCDSC,APCDSCT W ! S DIR(0)="YO",DIR("A")="Include ALL Visit Service Categories",DIR("B")="Yes"
 S DIR("?")="If you wish to include all visit service categories (Ambulatory,Hospitalization,etc) answer Yes.  If you wish to list visits for only one service category enter NO." D ^DIR K DIR
 G:$D(DIRUT) BD
 I Y=1 G CLN
SC1 ;enter sc
 S X="SERVICE CATEGORY",DIC="^AMQQ(5,",DIC(0)="FM",DIC("S")="I $P(^(0),U,14)" D ^DIC K DIC,DA I Y=-1 W "OOPS - QMAN NOT CURRENT - QUITTING" G XIT
 D PEP^AMQQGTX0(+Y,"APCDSCT(")
 I '$D(APCDSCT) G SC
 I $D(APCDSCT("*")) K APCDSCT
CLN ;
 W !
 S APCDCLN="",DIR("A")="Include which Visits",DIR(0)="S^R:One Clinic;A:All Clinics",DIR("B")="A",DIR("?")="" D ^DIR K DIR
 I $D(DIRUT) G SC
 I Y="A" G PROV
 S DIC="^DIC(40.7,",DIC(0)="AEQM",DIC("A")="Clinic: "
 D ^DIC K DIC,DA
 G:Y=-1 CLN
 S APCDCLN=+Y
 ;
 ;
PROV ;
 W !
 S APCDPROV=""
 S DIR(0)="S^O:Visits completed by or w/POV last modified by one Operator;A:All visits, don't limit by operator",DIR("A")="Include which Visits",DIR("B")="O" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G CLN
 I Y="A" G RV
 S DIC="^VA(200,",DIC(0)="AEQM",DIC("A")="Which CODER/OPERATOR: " D ^DIC K DIC
 I $D(DTOUT)!(Y=-1) G PROV
 S APCDPROV=+Y
 ;
RV ;
 S APCDRVC=""
 S DIR(0)="S^R:Only Visits Marked as Reviewed/Complete;A:All visits regardless of Coding Status",DIR("A")="Include which Visits",DIR("B")="R" KILL DA D ^DIR K DIR
 I $D(DIRUT) G PROV
 S APCDRVC=Y
ICD ;
 W !
 K ^XTMP("APCDFQA",APCDJOB,APCDBT,"DEPOV"),DA,DIR,DTOUT,DIRUT,Y,X,DIC
 S DIR(0)="Y",DIR("A")="Do you wish to include only a subset of ICD Diagnoses",DIR("B")="NO",DIR("?")="If you wish to limit the search of POV's to a subset of ICD Codes, enter Y" D ^DIR K DIR
 G:$D(DIRUT) RAND
 I Y=0 S ^XTMP("APCDFQA",APCDJOB,APCDBT,"DEPOV","ALL")="" G RAND
 K APCDTABL D ^APCDFQA3
 I '$D(APCDTABL) G ICD
RAND ;
 W !
 S APCDMAX="",DIR("A")="Include which Visits",DIR(0)="S^R:Random Sample of Visits;A:All visits",DIR("B")="A",DIR("?")="If you want ALL Visits in this date range displayed Answer Y, if you want a random sample answer NO." D ^DIR K DIR
 I $D(DIRUT) G ICD
 I Y="A" S APCDRSM=0 G ZIS
 S DIR(0)="N^1:100:",DIR("A")="How many randomized visits do you want" D ^DIR K DIR
 I $D(DIRUT) G RAND
 S APCDMAX=Y,APCDRSM=1
ZIS W !! S %ZIS="PQM" D ^%ZIS
 I POP G XIT
 I $D(IO("Q")) G TSKMN
DRIVER ; entry point for taskman
ZTSK ;
 D ^APCDFQC1
 S APCDDT=$$FMTE^XLFDT(DT)
 U IO
 D ^APCDFQCP
 I $D(ZTQUEUED) S ZTREQ="@"
 K ^XTMP("APCDFQA",APCDJOB,APCDBT)
 D XIT
 Q
ERR W $C(7),$C(7),!,"Must be a valid date and be Today or earlier. Time not allowed!" Q
TSKMN ;
 S ZTIO=""
 S ZTIO=$S($D(ION):ION,1:IO) I $D(IOST)#2,IOST]"" S ZTIO=ZTIO_";"_IOST
 I $G(IO("DOC"))]"" S ZTIO=ZTIO_";"_$G(IO("DOC"))
 I $D(IOM)#2,IOM S ZTIO=ZTIO_";"_IOM I $D(IOSL)#2,IOSL S ZTIO=ZTIO_";"_IOSL
 K ZTSAVE F %="APCD*" S ZTSAVE(%)=""
 S ZTCPU=$G(IOCPU),ZTRTN="DRIVER^APCDFQAC",ZTDTH="",ZTDESC="PCC DE QA" D ^%ZTLOAD D XIT Q
 ;
 ;
XIT ;
 D ^%ZISC
 I '$D(ZTSK) S IOP="HOME" D ^%ZIS U IO(0)
 K DIC,%DT,IO("Q"),X,Y,POP,DIRUT,ZTSK,ZTIO
 D EN^XBVK("APCD")
 Q
 ;
 ;
