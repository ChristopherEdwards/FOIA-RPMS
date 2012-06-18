BATLRP ; IHS/CMI/LAB - ;
 ;;1.0;IHS ASTHMA REGISTER;;FEB 19, 2003
 ;
EN ;
 W:$D(IOF) @IOF
 W !!,$$CTR^BATU("*** Print ASTHMA REMINDER LETTER for Patient's on the Asthma Register ***"),!!
 W "This option will produce an Asthma Visit Reminder Letter for patients on the ",!,"asthma register.",!!
 W !!,"You will be presented with a list of all patients on the register with an",!,"active or unreviewed status whose last asthma visit (visit on which",!,"asthma data elements were entered) was over 6 months ago.",!
 W !,"You can then choose to print a letter for all of these patients or choose",!,"selected patients for whom a letter should be printed.",!!
 S DIR(0)="Y",DIR("A")="Do you wish to continue",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D EXIT Q
 I 'Y D EXIT Q
GATHER ;gather up and display in list man
 K BATPATS
 D EN^BATLRP1
 I '$D(BATPATS) W !!,"No patients selected." H 2 D EXIT Q
ZIS ;
 W ! S DIR(0)="S^P:PRINT Output;B:BROWSE Output on Screen",DIR("A")="Do you wish to",DIR("B")="P" K DA D ^DIR K DIR
 I $D(DIRUT) D EXIT Q
 S BATOPT=Y
 I Y="B" D BROWSE,EXIT Q
 S XBRP="PRINT^BATLRP",XBRC="",XBRX="EXIT^BATLRP",XBNS="BAT"
 D ^XBDBQUE
 D EXIT
 Q
BROWSE ;
 S XBRP="VIEWR^XBLM(""PRINT^BATLRP"")"
 S XBRC="",XBRX="EXIT^BATLRP",XBIOP=0 D ^XBDBQUE
 Q
PRINT ;EP
 S BATAL=$O(^BATAL("B","ASTHMA VISIT REMINDER",0))
 S BATPG=1 K BATQ
 S BATCNT=0 F  S BATCNT=$O(BATPATS(BATCNT)) Q:BATCNT'=+BATCNT  D
 .S BATDFN=BATPATS(BATCNT)
 .K ^TMP($J,"ASTHMA LETTER")
 .D SET^BATLOP(BATDFN)
 .W:$D(IOF) @IOF
 .S BATX=0 F  S BATX=$O(^TMP($J,"ASTHMA LETTER",BATX)) Q:BATX'=+BATX!($D(BATQ))  D
 ..I $Y>(IOSL-3) D HEADER Q:$D(BATQ)
 ..W !,^TMP($J,"ASTHMA LETTER",BATX)
 K ^TMP($J,"ASTHMA LETTER")
 Q
HEADER ;
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BATQ="" Q
HEAD1 ;
 W:$D(IOF) @IOF
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
EXIT ;
 D EN^XBVK("BAT")
 D ^XBFMK
 Q
