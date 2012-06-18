CIMGAGPX ; IHS/OHPRD/TMJ - PRINT VISITS WITH INJURIES ;   [ 01/27/00  9:49 AM ]
 ;;1.0;ABERDEEN GPRA REPORT;;JAN 22, 2000
 ;
INIT ;initialize variables
 S CIMGPG=0
 D HEADER Q:CIMQUIT
 I '$D(^XTMP("CIMGAGP",CIMGJ,CIMGH)) W !,"No injury visits to report."  G END
 ;
SET ;
 S CIMNAME=0
 F  S CIMNAME=$O(^XTMP("CIMGAGP",CIMGJ,CIMGH,"INJURIES",CIMNAME)) Q:CIMNAME=""!(CIMQUIT)  D SET2
END ;
 Q
SET2 ;
 S DFN=0
 F  S DFN=$O(^XTMP("CIMGAGP",CIMGJ,CIMGH,"INJURIES",CIMNAME,DFN)) Q:DFN'=+DFN  D SET3
 Q
SET3  ;
 S CIMV=0 F  S CIMV=$O(^XTMP("CIMGAGP",CIMGJ,CIMGH,"INJURIES",CIMNAME,DFN,CIMV)) Q:CIMV=""!(CIMQUIT)  D SET4
 Q
SET4 ;
 I $Y>(IOSL-8) D HEADER Q:CIMQUIT
 W !!,$E(CIMNAME,1,20),?22,$J($$HRN^AUPNPAT(DFN,DUZ(2)),6),?32,$J($$AGE^AUPNPAT(DFN,$P($P(^AUPNVSIT(CIMV,0),U),".")),2),?40,$P($G(^AUPNPAT(DFN,11)),U,18)
 S D=$P(^AUPNVSIT(CIMV,0),U) W ?60,$E(D,4,5),"/",$E(D,6,7),"/",(1700+$E(D,1,3))
 ;
 ;
 ;
SET5 ;
 S CIMPOV=0 F  S CIMPOV=$O(^XTMP("CIMGAGP",CIMGJ,CIMGH,"INJURIES",CIMNAME,DFN,CIMV,CIMPOV)) Q:CIMPOV=""!(CIMQUIT)  D PRNT
 Q
PRNT ;
 I $Y>(IOSL-8) D HEADER Q:CIMQUIT
 W !,"ICD9:  ",$P(^ICD9(+^AUPNVPOV(CIMPOV,0),0),U),?19,"Provider Narrative:  ",$S($P(^AUPNVPOV(CIMPOV,0),U,4):$E($P(^AUTNPOV($P(^AUPNVPOV(CIMPOV,0),U,4),0),U),1,40),1:"<no narrative available>")
 I $P(^AUPNVPOV(CIMPOV,0),U,9)]"" W !,"Cause of Injury:  ",?19,$P(^ICD9($P(^AUPNVPOV(CIMPOV,0),U,9),0),U),"  -  ",$P(^(0),U,3)
 I $P(^AUPNVPOV(CIMPOV,0),U,13)]"" W !,"Date of Injury:  ",?19,$E($P(^AUPNVPOV(CIMPOV,0),U,13),4,5),"/",$E($P(^AUPNVPOV(CIMPOV,0),U,13),6,7),"/",$E($P(^AUPNVPOV(CIMPOV,0),U,13),2,3)
 Q
HEADER I 'CIMGPG G HEADER1
 I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S CIMQUIT=1 Q
HEADER1 ;
 W:$D(IOF) @IOF S CIMGPG=CIMGPG+1
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",CIMGPG,!
 W !,$$CTR("***  ABERDEEN AREA GPRA INDICATORS  ***",80),!
 W $$CTR($P(^DIC(4,DUZ(2),0),U)),!
 S X="Reporting Period: "_$$FMTE^XLFDT(CIMBD)_" to "_$$FMTE^XLFDT(CIMED) W $$CTR(X,80),!
 S X="Baseline Period:  "_$$FMTE^XLFDT(CIM98B)_" to "_$$FMTE^XLFDT(CIM98E) W $$CTR(X,80),!
 W ?26,"Visits with Injury Diagnosis",!
 W !!,"PATIENT",?23,"HRCN",?31,"AGE",?40,"COMMUNITY",?60,"VISIT DATE",!
 W "--------------------------------------------------------------------------------"
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
