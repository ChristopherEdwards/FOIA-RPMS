BNITTOA ; IHS/CMI/LAB - toa table ;
 ;;1.0;BNI CPHD ACTIVITY DATASYSTEM;;DEC 20, 2006
 ;
 ;
START ;
 W:$D(IOF) @IOF
 W !,$$CTR($$LOC)
 W !,$$CTR($$USR)
 W !!,"This report will list the CPHAD Type of Activity table.",!!
SORT ;
 S BNISORT=""
 K DIR S DIR(0)="S^T:Type of Activity;C:Type of Activity Code",DIR("A")="How do you want the table sorted",DIR("B")="T" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D EXIT Q
 S BNISORT=Y
ZIS ;call to XBDBQUE
 S XBRP="PRINT^BNITTOA",XBRC="",XBRX="EXIT^BNITTOA",XBNS="BNI"
 D ^XBDBQUE
 D EXIT
 Q
EXIT ;clean up and exit
 D EN^XBVK("BNI")
 Q
PRINT ;EP - called from xbdbque
 S BNIPG=0,BNIQ="" D HEAD
 I BNISORT="C" D CODE
 I BNISORT="T" D TOPIC
DONE ;
 I $E(IOST)="C",IO=IO(0) S DIR(0)="EO",DIR("A")="End of report.  HIT RETURN" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q
CODE ;
 S BNIX="" F  S BNIX=$O(^BNITOA("C",BNIX)) Q:BNIX=""!(BNIQ)  D
 .S BNIY=0 F  S BNIY=$O(^BNITOA("C",BNIX,BNIY)) Q:BNIY'=+BNIY!(BNIQ)  D
 ..I $Y>(IOSL-2) D HEAD Q:BNIQ
 ..W !,$P(^BNITOA(BNIY,0),U),?65,$P(^BNITOA(BNIY,0),U,2),?74,$$VAL^XBDIQ1(90511.03,BNIY,.03)
 ..Q
 .Q
 Q
TOPIC ;
 S BNIX="" F  S BNIX=$O(^BNITOA("B",BNIX)) Q:BNIX=""!(BNIQ)  D
 .S BNIY=0 F  S BNIY=$O(^BNITOA("B",BNIX,BNIY)) Q:BNIY'=+BNIY!(BNIQ)  D
 ..I $Y>(IOSL-2) D HEAD Q:BNIQ
 ..W !,$E($P(^BNITOA(BNIY,0),U),1,63),?65,$P(^BNITOA(BNIY,0),U,2),?74,$$VAL^XBDIQ1(90511.03,BNIY,.03)
 ..Q
 .Q
 Q
HEAD I 'BNIPG G HEAD1
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BNIQ=1 Q
HEAD1 ;
 W:$D(IOF) @IOF S BNIPG=BNIPG+1
 W !,$P(^VA(200,DUZ,0),U,2),?72,"Page ",BNIPG,!
 W ?(80-$L($P(^DIC(4,DUZ(2),0),U))/2),$P(^DIC(4,DUZ(2),0),U),!
 W $$CTR("CPHAD TYPE OF ACTIVITY TABLE LISTING",80),!
PIH W !,"TYPE OF ACTIVITY",?65,"CODE",?74,"OTHER?",!,$$REPEAT^XLFSTR("-",80),!
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
EOP ;EP - End of page.
 Q:$E(IOST)'="C"
 Q:$D(ZTQUEUED)!'(IOT="TRM")!$D(IO("S"))
 NEW DIR
 K DIRUT,DFOUT,DLOUT,DTOUT,DUOUT
 S DIR(0)="E" D ^DIR
 Q
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
