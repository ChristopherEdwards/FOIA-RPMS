APCLCR1 ; IHS/CMI/LAB - visits by provider ;
 ;;2.0;IHS PCC SUITE;**2**;MAY 14, 2009
 ;
START ; 
 I '$G(DUZ(2)) W $C(7),$C(7),!!,"SITE NOT SET IN DUZ(2) - NOTIFY SITE MANAGER!!",!! K APCLSITE Q
 D XIT
 S APCLJOB=$J,APCLBTH=$H
 D INFORM
GETDATES ;
BD ;
 W !!
 S DIR(0)="D^::EP",DIR("A")="Enter Beginning Visit Date",DIR("?")="Enter the beginning visit date for the search." D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) XIT
 S APCLBD=Y D DD^%DT S APCLBDD=Y
ED ;
 S DIR(0)="DA^::EP",DIR("A")="Enter Ending Visit Date:  " D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) XIT
 I Y<APCLBD W !,"Ending date must be greater than or equal to beginning date!" G ED
 S APCLED=Y
 S X1=APCLBD,X2=-1 D C^%DTC S APCLSD=X
LOC ;
 K APCLLOCT,APCLLOC,APCLQ
 S DIR(0)="S^A:ALL Locations/Facilities;S:One SERVICE UNIT'S Locations/Facilities;O:ONE Location/Facility;T:A Taxonomy or Set of Locations/Facilities",DIR("A")="Include Visits to Which Location/Facilities",DIR("B")="A"
 S DIR("A")="Enter a code indicating what LOCATIONS/FACILITIES are of interest",DIR("B")="O" K DA D ^DIR K DIR,DA
 G:$D(DIRUT) GETDATES
 S APCLLOCT=Y
 I APCLLOCT="A" K APCLLOC G CLINIC
 D @APCLLOCT
 G:$D(APCLQ) LOC
CLINIC ;
 S X="CLINIC",DIC="^AMQQ(5,",DIC(0)="FM",DIC("S")="I $P(^(0),U,14)" D ^DIC K DIC,DA I Y=-1 W "OOPS - QMAN NOT CURRENT - QUITTING" G XIT
 D PEP^AMQQGTX0(+Y,"APCLCLNT(")
 I '$D(APCLCLNT) G GETDATES
 I $D(APCLCLNT("*")) K APCLCLNT
DISC ;
 S X="DISCIPLINE",DIC="^AMQQ(5,",DIC(0)="FM",DIC("S")="I $P(^(0),U,14)" D ^DIC K DIC,DA I Y=-1 W "OOPS - QMAN NOT CURRENT - QUITTING" G XIT
 D PEP^AMQQGTX0(+Y,"APCLDISP(")
 I '$D(APCLDISP) G CLINIC
 I $D(APCLDISP("*")) K APCLDISP
ZIS ;
DEMO ;
 D DEMOCHK^APCLUTL(.APCLDEMO)
 I APCLDEMO=-1 G DISC
 S XBRP="PRINT^APCLCR1",XBRC="PROC^APCLCR1",XBRX="XIT^APCLCR1",XBNS="APCL"
 D ^XBDBQUE
 D XIT
 Q
ERR W $C(7),$C(7),!,"Must be a valid date and be Today or earlier. Time not allowed!" Q
XIT ;
 D EN^XBVK("APCL")
 D ^XBFMK
 Q
 ;
INFORM ;
 W:$D(IOF) @IOF
 W !,"This report will list a count of all visits to clinics that"
 W !,"are within a taxonony of clinics you identify.  The report"
 W !,"will be a tally of all primary and secondary providers"
 W !,"on those visits.  Only those provider disciplines that are"
 W !,"within the discipline taxonomy you select will be talled."
 Q
 ;
PROC ;EP - called from xbdbque
 S APCLBT=$H
 K ^XTMP("APCLCR1",APCLJOB,APCLBTH)
 D XTMP^APCLOSUT("APCLCR1","PCC VISIT/PROVIDER TALLY")
 S APCLVCNT=0 K APCLPSCT
 ;
V ; Run by visit date
 S APCLODAT=APCLSD_".9999" F  S APCLODAT=$O(^AUPNVSIT("B",APCLODAT)) Q:APCLODAT=""!((APCLODAT\1)>APCLED)  D V1
 ;
END ;
 S APCLET=$H
 Q
V1 ;
 ;count only visits with service category of A, O, R, S
 S APCLVDFN="" F  S APCLVDFN=$O(^AUPNVSIT("B",APCLODAT,APCLVDFN)) Q:APCLVDFN'=+APCLVDFN  I $D(^AUPNVSIT(APCLVDFN,0)),$P(^(0),U,9),'$P(^(0),U,11) S APCLVREC=^(0) D PROC1
 Q
PROC1 ;
 ;I $P(APCLVREC,U,6)'=APCLLOC Q  ;not correct location
 S (APCLLOE,L)=$P(APCLVREC,U,6)
 Q:$$DEMO^APCLUTL($P(APCLVREC,U,5),$G(APCLDEMO))
 Q:L=""
 I $D(APCLLOC),'$D(APCLLOC(L)) Q  ;not a facility of interest
 S APCLCLIN=$P(APCLVREC,U,8)
 Q:APCLCLIN=""
 I $D(APCLCLIN),'$D(APCLCLNT(APCLCLIN)) Q
 ;go through all providers
 S APCLX=0 F  S APCLX=$O(^AUPNVPRV("AD",APCLVDFN,APCLX)) Q:APCLX'=+APCLX  D
 .S Y=$P($G(^AUPNVPRV(APCLX,0)),U)
 .Q:Y=""
 .S D=$P($G(^VA(200,Y,"PS")),U,5)
 .Q:D=""
 .I $D(APCLDISP),'$D(APCLDISP(D)) Q
 .S P=$P(^AUPNVPRV(APCLX,0),U,4) I P="" S P="S"
 .S APCLPSCT(P)=$G(APCLPSCT(P))+1
 .S ^XTMP("APCLCR1",APCLJOB,APCLBTH,"DATA",P,$P(^VA(200,Y,0),U),Y)=$G(^XTMP("APCLCR1",APCLJOB,APCLBTH,"DATA",P,$P(^VA(200,Y,0),U),Y))+1
 .S ^XTMP("APCLCR1",APCLJOB,APCLBTH,"DATALOC",P,$P(^VA(200,Y,0),U),Y,APCLLOE)=$G(^XTMP("APCLCR1",APCLJOB,APCLBTH,"DATALOC",P,$P(^VA(200,Y,0),U),Y,APCLLOE))+1
 .I $D(^XTMP("APCLCR1",APCLJOB,APCLBTH,"VISITS",APCLVDFN)) Q
 .S APCLVCNT=APCLVCNT+1,^XTMP("APCLCR1",APCLJOB,APCLBTH,"VISITS",APCLVDFN)=""
 .Q
 Q
PRINT ;EP - called from xbdbque
 D COVPAGE
 S APCLPG=0 K APCLQUIT
 D HEAD
 I '$D(^XTMP("APCLCR1",APCLJOB,APCLBTH,"DATA")) W !!,"No visits to report.",! D DONE Q
 W !!,"Total PCC Primary Provider Workload Count:",?45,$J($G(APCLPSCT("P")),7)
 W !,"Total PCC Secondary Provider Workload Count:",?45,$J($G(APCLPSCT("S")),7)
 W !,"Total PCC Provider Workload Count:",?45,$J(($G(APCLPSCT("P"))+$G(APCLPSCT("S"))),7)
 W !!,"Total Number of Visits: ",?45,$J(APCLVCNT,7)
 W !!,"PRIMARY PROVIDERS",?35,"# OF VISITS",!
 S APCLX="" F  S APCLX=$O(^XTMP("APCLCR1",APCLJOB,APCLBTH,"DATA","P",APCLX)) Q:APCLX=""!($D(APCLQUIT))  D
 .S APCLY=0 F  S APCLY=$O(^XTMP("APCLCR1",APCLJOB,APCLBTH,"DATA","P",APCLX,APCLY)) Q:APCLY'=+APCLY!($D(APCLQUIT))  D
 ..I $Y>(IOSL-2) D HEAD Q:$D(APCLQUIT)
 ..W !?3,APCLX,?35,$J(^XTMP("APCLCR1",APCLJOB,APCLBTH,"DATA","P",APCLX,APCLY),6)
 ..Q:APCLLOCT="O"
 ..S APCLZ=0 F  S APCLZ=$O(^XTMP("APCLCR1",APCLJOB,APCLBTH,"DATALOC","P",APCLX,APCLY,APCLZ)) Q:APCLZ'=+APCLZ!($D(APCLQUIT))  D
 ...I $Y>(IOSL-2) D HEAD Q:$D(APCLQUIT)
 ...W !?6,$P(^AUTTLOC(APCLZ,0),U,7),?14,$J(^XTMP("APCLCR1",APCLJOB,APCLBTH,"DATALOC","P",APCLX,APCLY,APCLZ),6)
 ..Q
 .Q
 W !!,"SECONDARY PROVIDERS",?35,"# OF VISITS",!
 S APCLX="" F  S APCLX=$O(^XTMP("APCLCR1",APCLJOB,APCLBTH,"DATA","S",APCLX)) Q:APCLX=""!($D(APCLQUIT))  D
 .S APCLY=0 F  S APCLY=$O(^XTMP("APCLCR1",APCLJOB,APCLBTH,"DATA","S",APCLX,APCLY)) Q:APCLY'=+APCLY!($D(APCLQUIT))  D
 ..I $Y>(IOSL-2) D HEAD Q:$D(APCLQUIT)
 ..W !?3,APCLX,?35,$J(^XTMP("APCLCR1",APCLJOB,APCLBTH,"DATA","S",APCLX,APCLY),6)
 ..Q:APCLLOCT="O"
 ..S APCLZ=0 F  S APCLZ=$O(^XTMP("APCLCR1",APCLJOB,APCLBTH,"DATALOC","S",APCLX,APCLY,APCLZ)) Q:APCLZ'=+APCLZ!($D(APCLQUIT))  D
 ...I $Y>(IOSL-2) D HEAD Q:$D(APCLQUIT)
 ...W !?6,$P(^AUTTLOC(APCLZ,0),U,7),?14,$J(^XTMP("APCLCR1",APCLJOB,APCLBTH,"DATALOC","S",APCLX,APCLY,APCLZ),6)
 ..Q
 .Q
DONE ;
 D DONE^APCLOSUT
 K ^XTMP("APCLCR1",APCLJOB,APCLBTH)
 Q
COVPAGE ;
 W:$D(IOF) @IOF
 W !!,$$CJ^XLFSTR("Tally of Selected Primary and Secondary Providers for selected Clinic Visits",80),!
 W !,$$CJ^XLFSTR("Visit Dates: "_$$FMTE^XLFDT(APCLBD)_"-"_$$FMTE^XLFDT(APCLED),80),!
 I '$D(APCLLOC) W !!,"Locations:  ALL"
 I $D(APCLLOC) W !!,"Locations:"
 S X=0 F  S X=$O(APCLLOC(X)) Q:X'=+X  W:$Y>(IOSL-2) @IOF,!,"Cover page (con't)",!! W !?10,$P(^DIC(4,X,0),U)
 I '$D(APCLCLNT) W !!,"Clinics:  ALL"
 I $D(APCLCLNT) W !!,"Clinics:"
 S X=0 F  S X=$O(APCLCLNT(X)) Q:X'=+X  W:$Y>(IOSL-2) @IOF,!,"Cover page (con't)",!! W !?10,$P(^DIC(40.7,X,0),U)
 I '$D(APCLDISP) W !!,"Disciplines:  ALL"
 I $D(APCLDISP) W !!,"Disciplines:"
 S X=0 F  S X=$O(APCLDISP(X)) Q:X'=+X  W:$Y>(IOSL-2) @IOF,!,"Cover page (con't)",!! W !?10,$P(^DIC(7,X,0),U)
 Q
HEAD I 'APCLPG G HEAD1
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCLQUIT="" Q
HEAD1 ;
 W:$D(IOF) @IOF S APCLPG=APCLPG+1
 W !?58,$$FMTE^XLFDT(DT),?72,"Page ",APCLPG,!
 W $$CJ^XLFSTR("TALLY OF SELECTED PRIMARY AND SECONDARY PROVIDERS FOR SELECTED CLINIC VISITS",80),!
 W $$CJ^XLFSTR("Visit Dates: "_$$FMTE^XLFDT(APCLBD)_"-"_$$FMTE^XLFDT(APCLED),80),!
 I '$D(APCLLOC) W $$CJ^XLFSTR("FOR: ALL Locations",80),!
 I APCLLOCT="O" W $$CJ^XLFSTR("FOR: "_$P(^DIC(4,$O(APCLLOC(0)),0),U),80),!
 I APCLLOCT="S" W $$CJ^XLFSTR("FOR: "_$P(^AUTTSU(APCLSU,0),U)_" Service Unit",80),!
 I APCLLOCT="T" W $$CJ^XLFSTR("FOR: A taxonomy or selected set of locations",80),!
 W $$REPEAT^XLFSTR("-",80),!
 Q
O ;
 W ! S DIC("A")="Which Facility: ",DIC="^AUTTLOC(",DIC(0)="AEMQ" D ^DIC K DIC,DA I Y<0 S APCLQ=1 Q
 S APCLLOC(+Y)=""
 Q
S ;all communities within APCLSU su
 S DIC="^AUTTSU(",DIC("B")=$$VAL^XBDIQ1(9999999.06,DUZ(2),.05),DIC(0)="AEMQ",DIC("A")="Which SERVICE UNIT: " D ^DIC K DIC
 I Y=-1 S APCLQ="" Q
 S APCLSU=+Y
 W !!,"Gathering up all the facilities..."
 S X=0 F  S X=$O(^AUTTLOC(X)) Q:X'=+X  I $P(^AUTTLOC(X,0),U,5)=+Y S APCLLOC(X)=""
 Q
T ;taxonomy - call qman interface
 K APCLLOC
 S X="ENCOUNTER LOCATION",DIC="^AMQQ(5,",DIC(0)="FM",DIC("S")="I $P(^(0),U,14)" D ^DIC K DIC,DA I Y=-1 W "OOPS - QMAN NOT CURRENT - QUITTING" S APCLQ=1 Q
 D PEP^AMQQGTX0(+Y,"APCLLOC(")
 I '$D(APCLLOC) S APCLQ=1 Q
 I $D(APCLLOC("*")) K APCLLOC W !!,$C(7),$C(7),"ALL locations is NOT an option with this report",! G T
 S X="" F  S X=$O(APCLLOC(X)) Q:X=""  S APCLLOC(X)=""
 Q
