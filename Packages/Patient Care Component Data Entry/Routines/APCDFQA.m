APCDFQA ; IHS/CMI/LAB - QA AUDIT ON ICD CODING ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
START ; 
 S APCDSITE="" S:$D(DUZ(2)) APCDSITE=DUZ(2)
 I '$D(DUZ(2)) W $C(7),$C(7),!!,"SITE NOT SET IN DUZ(2) - NOTIFY SITE MANAGER!!",!! K APCDSITE Q
 I 'DUZ(2) W $C(7),$C(7),!!,"SITE NOT SET IN DUZ(2) - NOTIFY SITE MANAGER",!! K APCDSITE Q
 W:$D(IOF) @IOF
 S APCDLHDR="ICD DIAGNOSIS CODING AUDIT"
 W !?((80-$L(APCDLHDR))/2),APCDLHDR
 W !!,"This report will list visits (by POSTING date with an option of random",!,"samples) for a selected data entry operator.  Purpose of Visit ",!,"ICD DIAGNOSIS Code and Provider Narrative will also be listed.",!!
 S APCDJOB=$J,APCDBT=$H
 K ^XTMP("APCDFQA",APCDJOB,APCDBT)
GETDATES ;
BD ;get beginning date
 W ! S DIR(0)="D^:DT:EP",DIR("A")="Enter Beginning POSTING Date" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G XIT
 S APCDBD=Y
ED ;get ending date
 W ! S DIR(0)="DA^"_APCDBD_":DT:EP",DIR("A")="Enter Ending POSTING Date: " S Y=APCDBD D DD^%DT S DIR("B")=Y,Y="" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 S APCDED=Y
 S X1=APCDBD,X2=-1 D C^%DTC S APCDSD=X
 ;
PROV S DIC="^VA(200,",DIC(0)="AEQM",DIC("A")="Enter DATA ENTRY OPERATOR: " D ^DIC K DIC
 I $D(DTOUT)!(Y=-1) G BD
 S APCDPROV=+Y
SC ;
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
CLN S APCDCLN="",DIR(0)="YO",DIR("A")="Want to limit search by CLINIC TYPE",DIR("B")="NO",DIR("?")="" D ^DIR K DIR
 I $E(X)=U!($D(DTOUT)) G PROV
 I $E(X)="N" G ICD
 S DIC="^DIC(40.7,",DIC(0)="AEQM",DIC("A")="Clinic: "
 D ^DIC K DIC,DA
 G:Y=-1 CLN
 S APCDCLN=+Y
 ;
ICD ;
 K ^XTMP("APCDFQA",APCDJOB,APCDBT,"DEPOV"),DA,DIR,DTOUT,DIRUT,Y,X,DIC
 S DIR(0)="Y",DIR("A")="Do you wish to include only a subset of ICD Diagnoses",DIR("B")="NO",DIR("?")="If you wish to limit the search of POV's to a subset of ICD Codes, enter Y" D ^DIR K DIR
 G:$D(DIRUT) CLN
 I Y=0 S ^XTMP("APCDFQA",APCDJOB,APCDBT,"DEPOV","ALL")="" G RAND
 K APCDTABL D ^APCDFQA3
 I '$D(APCDTABL) G ICD
RAND ;
 S APCDMAX="",DIR(0)="Y",DIR("A")="Do you want ALL Visits Selected",DIR("B")="N",DIR("?")="If you want ALL Visits in this date range displayed Answer Y, if you want a random sample answer NO." D ^DIR K DIR
 I $D(DTOUT)!(X="^") G ICD
 I Y=1 S APCDRSM=0 G ZIS
 S DIR(0)="N^1:100:",DIR("A")="How many randomized visits do you want" D ^DIR K DIR
 I $D(DIRUT) G RAND
 S APCDMAX=Y,APCDRSM=1
ZIS W !! S %ZIS="PQM" D ^%ZIS
 I POP G XIT
 I $D(IO("Q")) G TSKMN
DRIVER ; entry point for taskman
ZTSK ;
 D ^APCDFQA1
 S APCDDT=$$FMTE^XLFDT(DT)
 U IO
 D ^APCDFQAP
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
 K ZTSAVE F %="APCDMAX","APCDBD","APCDED","APCDSD","APCDPROV","APCDCLN","APCDJOB","APCDBT","APCDLHDR","^XTMP(""APCDFQA"",APCDJOB,APCDBT," S ZTSAVE(%)=""
 S ZTCPU=$G(IOCPU),ZTRTN="DRIVER^APCDFQA",ZTDTH="",ZTDESC="PCC DE QA" D ^%ZTLOAD D XIT Q
 ;
 ;
XIT ;
 D ^%ZISC
 I '$D(ZTSK) S IOP="HOME" D ^%ZIS U IO(0)
 K DIC,%DT,IO("Q"),X,Y,POP,DIRUT,ZTSK,ZTIO
 K APCD1,APCD2,APCD80D,APCDBD,APCDBDD,APCDBT,APCDCLN,APCDDATE,APCDDT,APCDED,APCDEDD,APCDHRN,APCDLENG,APCDMAX,APCDNQ,APCDQUIT,APCDC,APCDDFN,APCDSLCT,APCDIRNG,APCD1SV,APCD1,APCDI,APCDDLT,APCD2,APCD11,APCDQ,APCDMSG,APCDDSP,APCDICDD
 K APCDODAT,APCDPAT,APCDPG,APCDPOV,APCDPOVA,APCDPOVC,APCDPOVD,APCDPOVN,APCDPROV,APCDSD,APCDSITE,APCDVCNT,APCDVDFN,APCDVREC,APCDGOT,APCDX,APCDJOB,APCDBT,APCDICDP,APCDTABL,APCDRSM,APCDLHDR
 Q
 ;
 ;
