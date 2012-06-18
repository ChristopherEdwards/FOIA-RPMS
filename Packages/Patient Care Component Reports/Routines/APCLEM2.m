APCLEM2 ; IHS/CMI/LAB - active users by community ;
 ;;2.0;IHS PCC SUITE;**6**;MAY 14, 2009;Build 11
 ;IHS/CMI/LAB - added a template creation option
START ;
 D INIT
SUF ;
F ;
 K APCLSU,APCLSUF
 W !!,"Enter the Facilities you want to report on.  To be included in this report"
 W !,"the patient must be registered at one of these facilities and must have"
 W !,"had at least one visit in the past 3 years to one of these facilities.",!
 W !,"If you are operating on a multi divisional database it might be best to"
 W !,"run one report for each facility."
 S X="LOCATION OF ENCOUNTER",DIC="^AMQQ(5,",DIC(0)="FM",DIC("S")="I $P(^(0),U,14)" D ^DIC K DIC,DA I Y=-1 W "OOPS - QMAN NOT CURRENT - QUITTING" G EOJ
 D PEP^AMQQGTX0(+Y,"APCLSU(")
 I '$D(APCLSU) D EOJ Q
 I $D(APCLSU("*")) W !,"You can't choose all locations." H 2 K APCLSU G SUF
FY ;
 S Y=DT X ^DD("DD") S APCLDTP=Y
 S %DT("A")="** Patients are to be considered ACTIVE 'as of' what date: ",%DT="AEPX" W ! D ^%DT
 I Y=-1 G F
 S APCLFYE=Y X ^DD("DD") S APCLFYEY=Y
ZIS ;
DEMO ;
 D DEMOCHK^APCLUTL(.APCLDEMO)
 I APCLDEMO=-1 G FY
 W !!!,"THIS REPORT WILL SEARCH THE ENTIRE PATIENT FILE!",!!,"IT IS STRONGLY RECOMMENDED THAT YOU QUEUE THIS REPORT FOR A TIME WHEN THE",!,"SYSTEM IS NOT IN HEAVY USE!",!
 S XBRP="PRINT^APCLEM2",XBRC="PROCESS^APCLEM2",XBRX="EOJ^APCLEM2",XBNS="APCL"
 D ^XBDBQUE
 D EOJ
 Q
 ;
INIT ;
ACC ;
 W:$D(IOF) @IOF
 W $$CTR("*****  Percent of Patient's Empanelled  *****")
 W !,"This option will produce either a count of active users and the "
 W !,"number and percent of those patients who were empanelled on the "
 W !,"as of the date the report is run."
 W !,"Your Report can be generated for one or more Facilities."
 W !!,"The system will select patients who have had a visit at the Facility(s) specified",!
 W "within the past 3 years of the date you specify."
 W !,"The visit used to determine if the patient is active must meet the following"
 W !,"criteria:"
 W !?5,"- must be to a location (facility) you specify"
 W !?5,"- must be a complete visit (have a POV and primary provider)"
 W !?5,"- must not be service category Chart Review, Telephone Call, Event"
 W !?10,"or In-Hospital visit"
 W !?5,"- must not be to clinics Home, Telephone, employee health or chart review"
 W !
 Q
 ;
EOJ ;ENTRY POINT
ACCEOJ K DIC,%DT,IO("Q"),I,J,K,JK,X,Y,POP,DIRUT,ZTSK,H,M,S,TS,ZTQUEUED
 D EN^XBVK("APCL")
 Q
PROCESS ;
 S APCLTOTP=0,APCLTOTR=0
X S X1=APCLFYE,X2=1 D C^%DTC S APCLFYB=($E(X,1,3)-3)_$E(X,4,7) S Y=APCLFYB D DD^%DT S APCLFYBY=Y
 S APCLJ=0
PAT S APCLDFN=0 F  S APCLDFN=$O(^AUPNPAT(APCLDFN)) Q:APCLDFN'=+APCLDFN  D C1
 K APCLDFN,APCLV,APCLFYBI,APCLFYEI,APCLGOTA
 S APCLET=$H
 Q
C1 ;
 Q:'$D(^DPT(APCLDFN,0))
 Q:$P(^DPT(APCLDFN,0),U,19)]""
 Q:$$DEMO^APCLUTL(APCLDFN,$G(APCLDEMO))
 I $D(^DPT(APCLDFN,.35)),$P(^(.35),U)]"",$P(^(.35),U)'>APCLFYE Q
HRN S (APCLGOT1,APCLHRN)=0 F J=0:0 S APCLHRN=$O(^AUPNPAT(APCLDFN,41,APCLHRN)) Q:APCLHRN'=+APCLHRN!(APCLGOT1)  I $D(APCLSU($P(^AUPNPAT(APCLDFN,41,APCLHRN,0),U))) S APCLGOT1=1
 Q:'APCLGOT1
VISITS ;
 S APCLFYBI=9999999-APCLFYB,APCLFYEI=9999999-APCLFYE
 K APCLGOTA,APCLSKIP
 S APCLV=0 F  S APCLV=$O(^AUPNVSIT("AA",APCLDFN,APCLV)) Q:APCLV'=+APCLV!($D(APCLGOTA))!($P(APCLV,".")>APCLFYBI)  S APCLVD=$P(APCLV,".") D PROC
 Q
PROC ;
 S APCLVDFN=0 F  S APCLVDFN=$O(^AUPNVSIT("AA",APCLDFN,APCLV,APCLVDFN)) Q:APCLVDFN'=+APCLVDFN!($D(APCLGOTA))  D ACTIVE
 Q
ACTIVE ;determine if patient was seen in FYs
 ;home clinic, telephone and employee health clinics ignored
 Q:$D(APCLGOTA)
 Q:APCLVD>APCLFYBI
 Q:APCLVD<APCLFYEI
 Q:$P(^AUPNVSIT(APCLVDFN,0),U,11)
 Q:'$P(^AUPNVSIT(APCLVDFN,0),U,9)
 Q:"DXECTI"[$P(^AUPNVSIT(APCLVDFN,0),U,7)
 S %=$$CLINIC^APCLV(APCLVDFN,"C") I %=11!(%=68)!(%=51)!(%=52) Q
 Q:'$D(^AUPNVPOV("AD",APCLVDFN))
 Q:$$PRIMPROV^APCLV(APCLVDFN,"I")=""
 S F=$P(^AUPNVSIT(APCLVDFN,0),U,6)
 Q:F=""
 I '$D(APCLSU(F)) Q
 S APCLGOTA=1
 S APCLTOTP=APCLTOTP+1
 I $P(^AUPNPAT(APCLDFN,0),U,14) S APCLTOTR=APCLTOTR+1
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
EOP ;EP - End of page.
 Q:$E(IOST)'="C"
 Q:$D(ZTQUEUED)!(IOT'["TRM")!$D(IO("S"))
 NEW DIR
 K DIRUT,DFOUT,DLOUT,DTOUT,DUOUT
 S DIR("A")="End of Report.  Press return",DIR(0)="E" D ^DIR
 Q
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC1() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
GETPROV ;
 ;get dpcp on date APCLFYE
 S P=""
 K S
 S X=$O(^BDPRECN("AA",APCLDFN,1,0))
 I 'X Q
 S Y=0 F  S Y=$O(^BDPRECN(X,1,Y)) Q:Y'=+Y  D
 .S B=$P(^BDPRECN(X,1,Y,0),U,3)
 .S Z=$O(^BDPRECN(X,1,Y))
 .I Z S E=$P(^BDPRECN(X,1,Z,0),U,3),E=$$FMADD^XLFDT(E,-1)
 .I 'Z S E=DT
 .S S(B,E)=$P(^BDPRECN(X,1,Y,0),U,1)
 .Q
 Q
PRINT ;
 S APCLPG=0
 D HEADER
 W !,"           Total # of active patients:  ",$$C^APCLEM1(APCLTOTP,0),!
 W !,"Total # of active patients Empanelled:  ",$$C^APCLEM1(APCLTOTR,0),!
 W !,"                   Percent Empanelled:       ",$$PER^APCLEM1(APCLTOTR,APCLTOTP),!!
 D PAUSE^APCLVL01
 Q
HEADER ;
 I 'APCLPG G HEAD1
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCLQUIT="" Q
HEAD1 ;
 I APCLPG W:$D(IOF) @IOF
 S APCLPG=APCLPG+1
 W !,$$CTR^APCLEM1($$FMTE^XLFDT(DT),80),?70,"Page ",APCLPG,!
 W $$CTR^APCLEM1($$LOC^APCLEM1,80),!
 W $$CTR^APCLEM1("Patients Active as of: "_$$FMTE^XLFDT(APCLFYE)),!
 W $$REPEAT^XLFSTR("-",79),!
 Q
