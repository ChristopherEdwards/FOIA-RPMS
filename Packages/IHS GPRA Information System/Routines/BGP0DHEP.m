BGP0DHEP ; IHS/CMI/LAB - IHS HEDIS print ;
 ;;10.0;IHS CLINICAL REPORTING;;JUN 18, 2010
 ;
 ;
PRINT ;
 K ^TMP($J)
 S BGPIOSL=$S($G(BGPGUI):55,1:IOSL)
 I BGPROT="D" G DEL
 S BGPPTYPE="P"
 D ^BGP0HEH
 S BGPGPG=0
 S BGPQUIT=""
 D PRINT1
 K ^TMP($J)
 I BGPROT="P" K ^XTMP("BGP0D",BGPJ,BGPH),^TMP($J) Q
 ;
DEL ;create delimited output file
 S BGPPTYPE="D"
 I '$D(BGPGUI) D ^%ZISC ;close printer device
 K ^TMP($J)
 D ^BGP0HEL ;create ^tmp of delimited report
 K ^XTMP("BGP0D",BGPJ,BGPH)
 K ^TMP($J)
 Q
WP ;
 K ^UTILITY($J,"W")
 S BGPZ=0,BGPLCNT=0
 S DIWL=1,DIWR=80,DIWF="",BGPZ=0 F  S BGPZ=$O(^BGPHEIT(BGPIC,BGPNODE,BGPY,1,BGPZ)) Q:BGPZ'=+BGPZ  D
 .S BGPLCNT=BGPLCNT+1
 .S X=^BGPHEIT(BGPIC,BGPNODE,BGPY,1,BGPZ,0) S:BGPLCNT=1 X=" - "_X D ^DIWP
 .Q
WPS ;
 S Z=0 F  S Z=$O(^UTILITY($J,"W",DIWL,Z)) Q:Z'=+Z  D
 .I $Y>(BGPIOSL-3) D HEADER^BGP0DPH Q:BGPQUIT
 .W !,^UTILITY($J,"W",DIWL,Z,0)
 K DIWL,DIWR,DIWF,Z
 K ^UTILITY($J,"W"),X
 Q
 ;
PRINT1 ;EP
 S BGPIC=0 F  S BGPIC=$O(BGPIND(BGPIC)) Q:BGPIC=""!(BGPQUIT)  D
 .D HEADER^BGP0DPH ;header for all measures
 .I $Y>(BGPIOSL-3) D HEADER^BGP0DPH Q:BGPQUIT
 .W !,$P(^BGPHEIT(BGPIC,0),U,3),!
 .I $Y>(BGPIOSL-3) D HEADER^BGP0DPH Q:BGPQUIT
 .W !,"Denominator(s):"
 .S BGPNODE=61
 .S BGPX=0 F  S BGPX=$O(^BGPHEIT(BGPIC,61,"B",BGPX)) Q:BGPX'=+BGPX!(BGPQUIT)  D
 ..S BGPY=0 F  S BGPY=$O(^BGPHEIT(BGPIC,61,"B",BGPX,BGPY)) Q:BGPY'=+BGPY!(BGPQUIT)  D
 ...I $P(^BGPHEIT(BGPIC,61,BGPY,0),U,2)'[BGPRTYPE Q  ;not a denom def for this report
 ...D WP
 .I $Y>(BGPIOSL-3) D HEADER^BGP0DPH Q:BGPQUIT
 .W !!,"Numerator(s):"
 .S BGPNODE=62
 .S BGPX=0 F  S BGPX=$O(^BGPHEIT(BGPIC,62,"B",BGPX)) Q:BGPX'=+BGPX!(BGPQUIT)  D
 ..S BGPY=0 F  S BGPY=$O(^BGPHEIT(BGPIC,62,"B",BGPX,BGPY)) Q:BGPY'=+BGPY!(BGPQUIT)  D
 ...I $P(^BGPHEIT(BGPIC,62,BGPY,0),U,2)'[BGPRTYPE Q  ;not a denom def for this report
 ...D WP
 .I $O(^BGPHEIT(BGPIC,11,0)) W !!,"Logic:" S BGPX=0 F  S BGPX=$O(^BGPHEIT(BGPIC,11,BGPX)) Q:BGPX'=+BGPX  D
 ..I $Y>(BGPIOSL-3) D HEADER^BGP0DPH Q:BGPQUIT
 ..W !,^BGPHEIT(BGPIC,11,BGPX,0)
 .I $O(^BGPHEIT(BGPIC,51,0)) W !!,"Performance Measure Description:" S BGPX=0 F  S BGPX=$O(^BGPHEIT(BGPIC,51,BGPX)) Q:BGPX'=+BGPX  D
 ..I $Y>(BGPIOSL-3) D HEADER^BGP0DPH Q:BGPQUIT
 ..W !,^BGPHEIT(BGPIC,51,BGPX,0)
 .W !!,"HEDIS Rates:"
 .I '$O(^BGPHEIT(BGPIC,52,0)) W !,"Not Reported." I 1
 .E  S BGPX=0 F  S BGPX=$O(^BGPHEIT(BGPIC,52,BGPX)) Q:BGPX'=+BGPX  D
 ..I $Y>(BGPIOSL-3) D HEADER^BGP0DPH Q:BGPQUIT
 ..W !,^BGPHEIT(BGPIC,52,BGPX,0)
 .X ^BGPHEIT(BGPIC,3)
 ;
 ;D ^BGP0DSP
 Q:BGPQUIT
 D ^BGP0HES
 D EXIT
 Q
EXIT ;
 I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO",DIR("A")="End of report.  Press ENTER" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q
C(X,X2,X3) ;
 D COMMA^%DTC
 Q X