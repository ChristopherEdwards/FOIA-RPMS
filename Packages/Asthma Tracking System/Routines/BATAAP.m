BATAAP ; IHS/CMI/LAB - ;
 ;;1.0;IHS ASTHMA REGISTER;;FEB 19, 2003
 ;
EN ;
 W:$D(IOF) @IOF
 W !!,$$CTR^BATU("*** Print ASTHMA ACTION PLAN FORM ***"),!!
 W "This option will produce an Asthma Action Plan form that",!,"can be given to the patient.",!!
PG ;
 K BATDFN
 S DIR(0)="S^P:Print Patient's Name on Form;G:Generic Form",DIR("A")="Do you want to include the patient's name or print a generic form",DIR("B")="P" KILL DA D ^DIR KILL DIR
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
 S XBRP="PRINT^BATAAP",XBRC="",XBRX="EXIT^BATAAP",XBNS="BAT"
 D ^XBDBQUE
 D EXIT
 Q
BROWSE ;
 S XBRP="VIEWR^XBLM(""PRINT^BATAAP"")"
 S XBRC="",XBRX="EXIT^BATAAP",XBIOP=0 D ^XBDBQUE
 Q
PRINT ;EP
 S BATAAP=$O(^BATAF("B","ASTHMA ACTION PLAN",0))
 S BATPG=1 K BATQ
 W:$D(IOF) @IOF
 W $$CTR("ASTHMA ACTION PLAN",80),!
 W !,"NAME:   "_$S($G(BATDFN):$P(^DPT(BATDFN,0),U),1:"____________________________________"),?55,"DATE: ",$$FMTE^XLFDT(DT),!
 S BATX=0 F  S BATX=$O(^BATAF(BATAAP,11,BATX)) Q:BATX'=+BATX  D
 .I $Y>(IOSL-1) D HEADER Q:$D(BATQ)
 .W !,^BATAF(BATAAP,11,BATX,0)
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
