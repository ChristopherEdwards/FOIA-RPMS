APCLBMIR ; IHS/CMI/LAB - print BMI reference table ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;
 W:$D(IOF) @IOF
 W !!,"BMI Standard Reference Table Print",!
ZIS ;
 S DIR(0)="S^P:PRINT Output;B:BROWSE Output on Screen",DIR("A")="Do you wish to ",DIR("B")="P" K DA D ^DIR K DIR
 I $D(DIRUT) G XIT
 I $G(Y)="B" D BROWSE,XIT Q
 S XBRC="",XBRP="PRINT^APCLBMIR",XBNS="APCL",XBRX="XIT^APCLBMIR"
 D ^XBDBQUE
XIT ;
 D EN^XBVK("APCL"),^XBFMK
 Q
 ;
BROWSE ;
 S XBRP="VIEWR^XBLM(""PRINT^APCLBMIR"")"
 S XBNS="APCL",XBRC="",XBRX="XIT^APCLBMIR",XBIOP=0 D ^XBDBQUE
 Q
 ;
HEADER ;EP
 G:'APCLPG HEADER1
 K DIR I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCLQUIT=1 Q
HEADER1 ;
 W:$D(IOF) @IOF S APCLPG=APCLPG+1
 W !,"BMI Standard Reference Data",?50,$$FMTE^XLFDT(DT),?70,"Page ",APCLPG,!
 W !?33,"BMI",?44,"BMI",!?5,"Low-High",?34,">=",?45,">=",?54,"DATA CHECK LIMITS",!?5,"Ages",?18,"SEX",?31,"(OVERWT)",?43,"(OBESE)",?55,"BMI >",?65,"BMI <"
 W !,$TR($J("",80)," ","-")
 Q
PRINT ;EP - called from xbdbque
 S (APCLPG,APCLQUIT)=0 D HEADER
 S APCLX=0 F  S APCLX=$O(^APCLBMI("B",APCLX)) Q:APCLX'=+APCLX!(APCLQUIT)  D
 .S (APCLY,APCLC)=0 F  S APCLY=$O(^APCLBMI("B",APCLX,APCLY)) Q:APCLY'=+APCLY!(APCLQUIT)  S APCLC=APCLC+1 D
 ..I $Y>(IOSL-4) D HEADER Q:APCLQUIT
 ..W !
 ..W:APCLC=1 !?5,$P(^APCLBMI(APCLY,0),U),"-",$P(^APCLBMI(APCLY,0),U,2)
 ..W ?18,$$VAL^XBDIQ1(9001003.9,APCLY,.03)
 ..W ?32,$J($P(^APCLBMI(APCLY,0),U,4),4,1),?44,$J($P(^APCLBMI(APCLY,0),U,5),4,1),?57,$J($P(^APCLBMI(APCLY,0),U,7),4,1),?66,$J($P(^APCLBMI(APCLY,0),U,6),4,1)
 ..;W ?32,$$VAL^XBDIQ1(9001003.9,APCLY,.04),?43,$$VAL^XBDIQ1(9001003.9,APCLY,.05),?57,$$VAL^XBDIQ1(9001003.9,APCLY,.07),?66,$$VAL^XBDIQ1(9001003.9,APCLY,.06)
 ..Q
 .Q
 Q:APCLQUIT
 I $Y>(IOSL-15) D HEADER Q:APCLQUIT
 W !!,"NOTE:  To make sure data is accurate and to eliminate data entry error, table",!,"excludes patient records whose BMI falls above or below the ","""","Data Check Limits","""",!,"specified above."
 W !!,"Ages 2-10:  'At Risk for Overweight' is defined as BMI >=85th% but <95th%",!?12,"'Overweight' is defined as BMI >= 95th%"
 W !,"(per National Center for Health Statistics in collaboration with the National",!,"Center for Chronic Disease Prevention and Health Promotion (2000)."
 W !!,"Ages 20-74:  'Overweight' is defined as BMI >=25.0 but <30.0.",!?13,"'Obese' is defined as BMI >=30.0"
 W !,"(per Clinical Guidelines on the Identification, Evaluation",!,"and Treatment of Overweight and Obesity in Adults.  Bethesda, Md: NHLBI, 1998)"
EOP ;EP - End of page.
 Q:$E(IOST)'="C"
 Q:$D(ZTQUEUED)!'(IOT="TRM")!$D(IO("S"))
 NEW DIR
 K DIRUT,DFOUT,DLOUT,DTOUT,DUOUT
 S DIR("A")="End of report.  Press Enter",DIR(0)="E" D ^DIR
 Q
 ;----------
 Q
