APCLDOD1 ; IHS/CMI/LAB - INFANT FEEDING REPORT #1 ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;
 ;
EP ;EP - called from option interactive
 D EOJ
 W:$D(IOF) @IOF
 S APCLTEXT="INTROT" F APCLJ=1:1 S APCLX=$T(@APCLTEXT+APCLJ) Q:$P(APCLX,";;",2)="END"  S APCLT=$P(APCLX,";;",2) W !,APCLT
GETDATES ;
BD ;get beginning date
 W ! S DIR(0)="D^:DT:EP",DIR("A")="Enter beginning Date of Death" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G EOJ
 S APCLBD=Y
ED ;get ending date
 K DIR W ! S DIR(0)="DA^"_APCLBD_":DT:EP",DIR("A")="Enter ending Date of Death: " D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 S APCLED=Y
 S X1=APCLBD,X2=-1 D C^%DTC S APCLSD=X
 ;
TRIBE ;
 K APCLTRIM S APCLTRIT=""
 S DIR(0)="S^O:One particular Tribe;A:All Tribes;S:Selected Set of Tribes (Taxonomy)",DIR("A")="List patients who are members of",DIR("B")="O" K DA D ^DIR K DIR
 I $D(DIRUT) G GETDATES
 S APCLTRIT=Y
 I APCLTRIT="A" W !!,"Patients from all tribes will be included in the report.",! G CMMNTS
 I APCLTRIT="O" D  G:'$D(APCLTRIM) TRIBE  G CMMNTS
 .S DIC="^AUTTTRI(",DIC(0)="AEMQ",DIC("A")="Which TRIBE: " D ^DIC K DIC
 .Q:Y=-1
 .S APCLTRIM(+Y)=""
 S X="TRIBE",DIC="^AMQQ(5,",DIC(0)="FM",DIC("S")="I $P(^(0),U,14)" D ^DIC K DIC,DA I Y=-1 W "OOPS - QMAN NOT CURRENT - QUITTING" S APCLERR=1 Q
 D PEP^AMQQGTX0(+Y,"APCLTRIM(")
 I '$D(APCLTRIM) G TRIBE
 I $D(APCLTRIM("*")) K APCLTRIM G TRIBE
CMMNTS ;
 K APCLCOMM S APCLCOMT=""
 S DIR(0)="S^O:One particular Community;A:All Communities;S:Selected Set of Communities (Taxonomy)",DIR("A")="List patients who live in",DIR("B")="O" K DA D ^DIR K DIR
 I $D(DIRUT) G TRIBE
 S APCLCOMT=Y
 I APCLCOMT="A" W !!,"Patients from all communities will be included in the report.",! G SORTR
 I APCLCOMT="O" D  G:'$D(APCLCOMM) CMMNTS  G SORTR
 .S DIC="^AUTTCOM(",DIC(0)="AEMQ",DIC("A")="Which COMMUNITY: " D ^DIC K DIC
 .Q:Y=-1
 .S APCLCOMM($P(^AUTTCOM(+Y,0),U))=""
 S X="COMMUNITY",DIC="^AMQQ(5,",DIC(0)="FM",DIC("S")="I $P(^(0),U,14)" D ^DIC K DIC,DA I Y=-1 W "OOPS - QMAN NOT CURRENT - QUITTING" S APCLERR=1 Q
 D PEP^AMQQGTX0(+Y,"APCLCOMM(")
 I '$D(APCLCOMM) G CMMNTS
 I $D(APCLCOMM("*")) K APCLCOMM G CMMNTS
SORTR ;
 S APCLSORT=""
 S DIR(0)="S^D:Date of Death;H:HRN;R:Terminal Digit HRN;C:Community;T:Tribe;N:Patient Name",DIR("A")="Sort Report by",DIR("B")="D" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G CMMNTS
 S APCLSORT=Y
ZIS ;
DEMO ;
 D DEMOCHK^APCLUTL(.APCLDEMO)
 I APCLDEMO=-1 G SORTR
 S XBRP="PRINT^APCLDOD1",XBRC="PROC^APCLDOD1",XBRX="EOJ^APCLDOD1",XBNS="APCL"
 D ^XBDBQUE
 Q
EOJ ;
 D ^XBFMK
 K DIC,DIR
 D EN^XBVK("APCL")
 Q
 ;
PROC ;
 S APCLJ=$J,APCLH=$H,APCLSD=APCLSD_".9999"
 S ^XTMP("APCLDOD1",0)=$$FMADD^XLFDT(DT,14)_"^"_DT_"^"_"DATE OF DEATH REPORT"
 S DFN=0 F  S APCLSD=$O(^DPT("AEXP1",APCLSD)) Q:APCLSD'=+APCLSD!($P(APCLSD,".")>APCLED)  D
 .S DFN=0 F  S DFN=$O(^DPT("AEXP1",APCLSD,DFN)) Q:DFN'=+DFN  D
 ..Q:'$D(^DPT(DFN))
 ..Q:'$D(^AUPNPAT(DFN))
 ..Q:$$DEMO^APCLUTL(DFN,$G(APCLDEMO))
 ..;check tribe
 ..I $D(APCLTRIM) S X=$P($G(^AUPNPAT(DFN,11)),U,8) I '$D(APCLTRIM(X)) Q  ;not correct tribe
 ..I $D(APCLCOMM) S X=$P($G(^AUPNPAT(DFN,11)),U,18) I '$D(APCLCOMM(X)) Q  ;not correct community
 ..S X=$$SORT(DFN,APCLSORT)
 ..I X="" S X="---"
 ..S ^XTMP("APCLDOD1",APCLJ,APCLH,"PTS",X,DFN)=""
 ..Q
 Q
DONE ;
 I $E(IOST)="C",IO=IO(0) S DIR(0)="EO",DIR("A")="End of report.  PRESS ENTER" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 ;W:$D(IOF) @IOF
 K APCLTS,APCLS,APCLM,APCLET
 K ^XTMP("APCLDOD1",APCLJ,APCLH),APCLJ,APCLH
 Q
 ;
 ;
PRINT ;EP - called from xbdbque
 S APCLQ=0,APCLPG=0
 D HEADER
 S APCLSV="" F  S APCLSV=$O(^XTMP("APCLDOD1",APCLJ,APCLH,"PTS",APCLSV)) Q:APCLSV=""!(APCLQ)  D
 .S DFN=0 F  S DFN=$O(^XTMP("APCLDOD1",APCLJ,APCLH,"PTS",APCLSV,DFN)) Q:DFN'=+DFN!(APCLQ)  D
 ..S Y=DFN D ^AUPNPAT
 ..I $Y>(IOSL-3) D HEADER Q:APCLQ
 ..W !,$E($P(^DPT(DFN,0),U),1,23),?25,$$HRN^AUPNPAT(DFN,DUZ(2)),?32,$$D($P(^DPT(DFN,0),U,3)),?45,$$AGE^AUPNPAT(DFN,AUPNDOD)
 ..W ?50,$$D(AUPNDOD),?61,$E($$VAL^XBDIQ1(9000001,DFN,1108),1,18)
 ..W !?2,"Underlying Cause of Death: ",$$VAL^XBDIQ1(9000001,DFN,1114)
 ..W !?2,"Last Visit: ",$$LASTVD(DFN,AUPNDOB,AUPNDOD)
 ..W !?2,"Last Inpatient Visit: ",$$LASTVD(DFN,AUPNDOB,AUPNDOD,1)
 ..W !?2,"Community of Residence: ",$$VAL^XBDIQ1(9000001,DFN,1118)
 ..Q
 .Q
 Q
LASTVD(P,BDATE,EDATE,H) ;
 K ^TMP($J,"A")
 S H=$G(H)
 S A="^TMP($J,""A"",",B=P_"^ALL VISITS;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE),E=$$START1^APCLDF(B,A)
 I '$D(^TMP($J,"A",1)) Q ""
 S (X,G)="" F  S X=$O(^TMP($J,"A",X)) Q:X'=+X!(G)  S V=$P(^TMP($J,"A",X),U,5) D
 .Q:'$D(^AUPNVSIT(V,0))
 .Q:'$P(^AUPNVSIT(V,0),U,9)
 .Q:$P(^AUPNVSIT(V,0),U,11)
 .Q:'$D(^AUPNVPRV("AD",V))
 .Q:"SAHORI"'[$P(^AUPNVSIT(V,0),U,7)
 .I H,$P(^AUPNVSIT(V,0),U,7)'="H" Q
 .S G=V
 .Q
 I 'G Q ""
 Q $$D($P($P(^AUPNVSIT(G,0),U),"."))_" "_$$VAL^XBDIQ1(9000010,V,.06)_"  - "_$$VAL^XBDIQ1(9000010,V,.07)
HEADER ;EP
 G:'APCLPG HEADER1
 K DIR I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCLQ=1 Q
HEADER1 ;
 W:$D(IOF) @IOF S APCLPG=APCLPG+1
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",APCLPG,!
 W $$CTR($P(^DIC(4,DUZ(2),0),U),80),!
 W !,$$CTR("DEASEASED PATIENTS REPORT",80),!
 S X="Date of Death: "_$$FMTE^XLFDT(APCLBD)_" - "_$$FMTE^XLFDT(APCLED) W $$CTR(X,80),!
 W !,"Patient Name",?25,"HRN",?32,"DOB",?43,"Age at",?50,"DOD",?61,"Tribe"
 W !?43,"Death"
 W !,$TR($J("",80)," ","-")
 Q
D(D) ;
 Q $E(D,4,5)_"/"_$E(D,6,7)_"/"_(1700+$E(D,1,3))
C(X,X2,X3) ;
 D COMMA^%DTC
 Q X
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
SORT(P,S) ;
 NEW R
 S R=""
 D @(S_"SORT")
 I R="" S R="ZZZZZZZZ"
 Q R
 ;
DSORT ;
 S R=$$VALI^XBDIQ1(2,P,.351)
 Q
CSORT ;
 S X=$$VAL^XBDIQ1(9000001,P,1118)
 Q
TSORT ;
 S R=$$VAL^XBDIQ1(9000001,P,1108)
 Q
NSORT ;
 S R=$$VAL^XBDIQ1(2,P,.01)
 Q
 ;
HSORT ;
 S R=$$HRN^AUPNPAT(P,DUZ(2))
 Q
 ;
RSORT ;
 S R=$$HRN^AUPNPAT(P,DUZ(2))
 S R=R+10000000,R=$E(R,7,8)_$E(R,1,6)
 Q
INTROT ;
 ;;                 DECEASED PATIENT LISTING
 ;;
 ;;This option will produce a report of all patients who have a Date of
 ;;Death entered into RPMS. You will be required to enter a date of
 ;;death date range.  If you want all patients with a DOD entered then
 ;;enter a very early beginning date (e.g. 01/01/1890).
 ;;
 ;;The report can be sorted by either HRN, Terminal Digit HRN, Date of
 ;;Death, Community, Tribe, or Patient Name.
 ;;
 ;;END
