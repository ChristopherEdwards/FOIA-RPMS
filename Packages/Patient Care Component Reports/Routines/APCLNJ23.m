APCLNJ23 ; IHS/CMI/LAB - INJURY REPORT COVER PAGE ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
TOP ;ENTRY POINT
 S APCLPAGE=0
 D HEAD
VD W !!,"1.  Visits from ",APCLBDD," through ",APCLEDD
LOC ;
 W !!,"2.  ",$S($D(APCLLOCT):"The following ",1:"All")," Locations of Encounter",$S($D(APCLLOCT):":",1:".") I $D(APCLLOCT) D
 .S %=0 F  S %=$O(APCLLOCT(%)) Q:%=""  D:$Y>(IOSL-4) HEAD Q:$D(APCLQUIT)  W !?10,$P(^DIC(4,%,0),U)
 .K %
TYPE ;
 W !!,"3.  ",$S($D(APCLTYPT):"The following ",1:"All")," Visit Types",$S($D(APCLTYPT):":",1:".") I $D(APCLTYPT) D
 .S %=0 F  S %=$O(APCLTYPT(%)) Q:%=""  S V=$$EXTSET^XBFUNC(9000010,.03,%) D:$Y>(IOSL-4) HEAD Q:$D(APCLQUIT)  W !?10,V
 K %,V
SC ;
 W !!,"4.  ",$S($D(APCLSCT):"The following ",1:"All")," Visit Service Categories",$S($D(APCLSCT):":",1:".") I $D(APCLSCT) D
 .S %=0 F  S %=$O(APCLSCT(%)) Q:%=""  S V=$$EXTSET^XBFUNC(9000010,.07,%) D:$Y>(IOSL-4) HEAD Q:$D(APCLQUIT)  W !?10,V
 K %,V
CLN ;
 W !!,"5.  ",$S($D(APCLCLNT):"The following ",1:"All")," Clinics",$S($D(APCLCLNT):":",1:".") I $D(APCLCLNT) D
 .S %=0 F  S %=$O(APCLCLNT(%)) Q:%=""  D:$Y>(IOSL-4) HEAD Q:$D(APCLQUIT)  W !?10,$P(^DIC(40.7,%,0),U)
 .K %
AGE ;
 W !!,"6.  ",$S($D(APCLAGET):"The following ",1:"All")," Ages",$S($D(APCLAGET):": "_APCLAGET,1:".")
ICD ;
 W !!,"7.  All vists with an ICD9 Diagnosis between 800 and 999 (injury codes)."
 I $E(IOST)="C",IO=IO(0) W !! S DIR("A")="End of cover page - Hit return",DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCLQUIT="" Q
 Q
HEAD ;
 I 'APCLPAGE G HEAD1
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCLQUIT="" Q
 ;
HEAD1 ;
 S APCLPAGE=APCLPAGE+1
 W:$D(IOF) @IOF
 S X=$P(^DIC(4,DUZ(2),0),"^")
 W !!,$P(^VA(200,DUZ,0),"^",2),?(80-$L(X)/2),X,!
 W !,"The Surveillance Injury Report is based on the following criteria:",!
 Q
