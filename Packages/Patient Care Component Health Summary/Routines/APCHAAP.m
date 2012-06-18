APCHAAP ; IHS/CMI/LAB - ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
EN ;
 W:$D(IOF) @IOF
 W !!,$$CTR("*** Print ASTHMA ACTION PLAN FORM ***"),!!
 W "This option will produce an Asthma Action Plan form that",!,"can be given to the patient.",!!
PG ;
 K APCHDFN
 S DIR(0)="S^P:Print Patient's Name on Form;G:Generic Form",DIR("A")="Do you want to include the patient's name or print a generic form",DIR("B")="P" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D EXIT Q
 I Y'="P" G ZIS
 S DIC="^AUPNPAT(",DIC(0)="AEMQ" D ^DIC
 I Y=-1 D EXIT Q
 S APCHDFN=+Y
 W !
ZIS ;
 W ! S DIR(0)="S^P:PRINT Output;B:BROWSE Output on Screen",DIR("A")="Do you wish to",DIR("B")="P" K DA D ^DIR K DIR
 I $D(DIRUT) D EXIT Q
 S APCHOPT=Y
 I Y="B" D BROWSE,EXIT Q
 S XBRP="PRINT^APCHAAP",XBRC="",XBRX="EXIT^APCHAAP",XBNS="APCH"
 D ^XBDBQUE
 D EXIT
 Q
BROWSE ;
 S XBRP="VIEWR^XBLM(""PRINT^APCHAAP"")"
 S XBRC="",XBRX="EXIT^APCHAAP",XBIOP=0 D ^XBDBQUE
 Q
PRINT ;EP
 S APCHAAP=$O(^APCHAF("B","ASTHMA ACTION PLAN",0))
 S APCHPG=1 K APCHQ
 W:$D(IOF) @IOF
 W $$CTR("ASTHMA ACTION PLAN",80),!
 W !,"NAME:   "_$S($G(APCHDFN):$P(^DPT(APCHDFN,0),U),1:"____________________________________"),?55,"DATE: ",$$FMTE^XLFDT(DT),!
 S APCHX=0 F  S APCHX=$O(^APCHAF(APCHAAP,11,APCHX)) Q:APCHX'=+APCHX  D
 .I $Y>(IOSL-1) D HEADER Q:$D(APCHQ)
 .W !,^APCHAF(APCHAAP,11,APCHX,0)
 Q
HEADER ;
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCHQ="" Q
HEAD1 ;
 W:$D(IOF) @IOF
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
EXIT ;
 D EN^XBVK("APCH")
 D ^XBFMK
 Q
