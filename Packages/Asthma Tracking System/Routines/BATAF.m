BATAF ; IHS/CMI/LAB - ;
 ;;1.0;IHS ASTHMA REGISTER;;FEB 19, 2003
 ;
EN ;
 W:$D(IOF) @IOF
 W !!,$$CTR^BATU("*** Print ASTHMA DAILY SELF MANAGEMENT PLAN FORM ***"),!!
 W "This option will produce an Asthma Daily Self-Management Plan form that",!,"can be given to the patient.",!!
PG ;
 K BATDFN
 S DIR(0)="S^P:Print Patient's Name on Form (Customized);G:Generic Form",DIR("A")="Do you want to print the patient's name or a generic form",DIR("B")="P" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D EXIT Q
 I Y'="P" G ZIS
 S DIC="^AUPNPAT(",DIC(0)="AEMQ" D ^DIC
 I Y=-1 D EXIT Q
 S BATDFN=+Y
 W !
ZIS ;
 W ! S DIR(0)="S^P:PRINT Output;B:BROWSE Output on Screen",DIR("A")="Do you wish to",DIR("B")="P" K DA D ^DIR K DIR
 I $D(DIRUT) D EXIT Q
 S BATOPT=Y
 I Y="B" D BROWSE,EXIT Q
 S XBRP="PRINT^BATAF",XBRC="",XBRX="EXIT^BATAF",XBNS="BAT"
 D ^XBDBQUE
 D EXIT
 Q
BROWSE ;
 S XBRP="VIEWR^XBLM(""PRINT^BATAF"")"
 S XBRC="",XBRX="EXIT^BATAF",XBIOP=0 D ^XBDBQUE
 Q
PRINT ;EP
 S BATAF=$O(^BATAF("B","ASTHMA SELF MANAGEMENT PLAN",0))
 S BATPG=1 K BATQ
 W:$D(IOF) @IOF
 W !,$$CTR("ASTHMA DAILY SELF-MANAGEMENT PLAN",80),!
 W !,"ASTHMA SELF-MANAGEMENT PLAN FOR "_$S($G(BATDFN):$P(^DPT(BATDFN,0),U),1:"____________________________________"),!
 S BATX=0 F  S BATX=$O(^BATAF(BATAF,11,BATX)) Q:BATX'=+BATX  D
 .I $Y>(IOSL-3) D HEADER Q:$D(BATQ)
 .W !,^BATAF(BATAF,11,BATX,0)
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
