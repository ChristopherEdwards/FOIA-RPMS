BGP9DPAW ; IHS/CMI/LAB - COMP NATIONAL GPRA FOR PTS W/APPT 01 Oct 2007 1:20 PM 13 Aug 2008 11:32 AM ; 
 ;;9.0;IHS CLINICAL REPORTING;**1**;JUL 01, 2009
 ;
DONE ;
 K DIR
 I $E(IOST)="C",IO=IO(0) S DIR(0)="EO",DIR("A")="End of report.  PRESS ENTER" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 ;W:$D(IOF) @IOF
 K BGPTS,BGPS,BGPM,BGPET,BGPX,BGPGPYR
 K ^XTMP("BGP9DPA",BGPGPRAJ,BGPGPRAH)
 Q
 ;
PRINT ;EP - called from xbdbque
 S BGPIOSL=$S($G(BGPGUI):55,1:IOSL)
 I $G(BGPGUI) S IOSL=55  ;cmi/maw added 1/14/2008
 K BGPQ S BGPPG=0,BGPNOD=0
 I BGPRT1="P" D PPRINT,DONE Q
 I BGPRT1="C" D CPRINT,DONE Q
 I BGPRT1="A" D APRINT,DONE Q
 I BGPRT1="D" D DPRINT,DONE Q
 Q
CPRINT ;
 I '$D(^XTMP("BGP9DPA",BGPGPRAJ,BGPGPRAH,"APPTS")) D HEADER S BGPNOD=1 D
 .I '$O(BGPCLN(0)) W !!,"There were either no appointments found or there were no patients due for any",!,"GPRA measure for any clinic during the specified  timeframe of ",!,$$FMTE^XLFDT(BGPABD)," to ",$$FMTE^XLFDT(BGPAED),".",! Q
 .W !!,"There were either no appointments found or there were no patients due for any",!,"GPRA measure for any of the clinics selected during the specified timeframe",!,"of ",$$FMTE^XLFDT(BGPABD)," to ",$$FMTE^XLFDT(BGPAED),"."
 .W !,"The following clinics were selected:"
 .S X=0 F  S X=$O(BGPCLN(X)) Q:X'=+X  W !?10,$P(^SC(X,0),U)
 ;I '$D(^XTMP("BGP9DPA",BGPGPRAJ,BGPGPRAH,"APPTS")) D HEADER S BGPNOD=1 W !!,"NO GPRA MEASURES DUE",! Q
 S BGPCLN="" F  S BGPCLN=$O(^XTMP("BGP9DPA",BGPGPRAJ,BGPGPRAH,"APPTS",BGPCLN)) Q:BGPCLN=""!($D(BGPQ))  D
 .S BGPD=0 F  S BGPD=$O(^XTMP("BGP9DPA",BGPGPRAJ,BGPGPRAH,"APPTS",BGPCLN,BGPD)) Q:BGPD'=+BGPD!($D(BGPQ))  D
 ..S BGPADT=0 F  S BGPADT=$O(^XTMP("BGP9DPA",BGPGPRAJ,BGPGPRAH,"APPTS",BGPCLN,BGPD,BGPADT)) Q:BGPADT'=+BGPADT!($D(BGPQ))  D
 ...S BGPNAME="" F  S BGPNAME=$O(^XTMP("BGP9DPA",BGPGPRAJ,BGPGPRAH,"APPTS",BGPCLN,BGPD,BGPADT,BGPNAME)) Q:BGPNAME=""!($D(BGPQ))  D
 ....S DFN=0 F  S DFN=$O(^XTMP("BGP9DPA",BGPGPRAJ,BGPGPRAH,"APPTS",BGPCLN,BGPD,BGPADT,BGPNAME,DFN)) Q:DFN'=+DFN!($D(BGPQ))  D
 .....D HEADER Q:$D(BGPQ)
 .....D SUB
 .....S BGPIC=0 F  S BGPIC=$O(^XTMP("BGP9DPA",BGPGPRAJ,BGPGPRAH,"APPTS",BGPCLN,BGPD,BGPADT,BGPNAME,DFN,BGPIC)) Q:BGPIC'=+BGPIC!($D(BGPQ))  D
 ......S BGPI=0 F  S BGPI=$O(^XTMP("BGP9DPA",BGPGPRAJ,BGPGPRAH,"APPTS",BGPCLN,BGPD,BGPADT,BGPNAME,DFN,BGPIC,BGPI)) Q:BGPI'=+BGPI!($D(BGPQ))  D
 .......I $Y>(IOSL-3) D HEADER Q:$D(BGPQ)  D SUB
 .......S Y=^XTMP("BGP9DPA",BGPGPRAJ,BGPGPRAH,"APPTS",BGPCLN,BGPD,BGPADT,BGPNAME,DFN,BGPIC,BGPI)
 .......D WRITE
 .......;S BGPX=$P(Y,U,2)
 .......;S BGPT=$P(Y,U,1),BGPT1=$P(Y,U,4)
 .......;W !,BGPT
 .......;F X=1:1 S Y=$P(BGPX,"|",X) Q:Y=""  W:X'=1 ! W ?27,Y
 .......;I $Y>(IOSL-4) D HEADER Q:$D(BGPQ)  D SUB
 .......;D WP
 ......Q
 .....Q
 ....Q
 ...Q
 ..Q
 .Q
 Q
DPRINT ;
 I '$D(^XTMP("BGP9DPA",BGPGPRAJ,BGPGPRAH,"APPTS")) D HEADER S BGPNOD=1 D  Q
 .W !!,"There were either no appointments found for this division or there were no " D
 ..W !,"patients due for any GPRA measure for any clinic during the specified ",!,"timeframe of ",$$FMTE^XLFDT(BGPABD)," to ",$$FMTE^XLFDT(BGPAED),".",! Q
 .;W !!,"There either no appointments found or there were no patients due for any GPRA",!,"measure for any of the clinics selected during the specified timeframe",!,"of ",$$FMTE^XLFDT(BGPABD)," to ",$$FMTE^XLFDT(BGPAED),"."
 .I $O(BGPCLN(0)) W !,"The following clinics were selected:" D
 ..S X=0 F  S X=$O(BGPCLN(X)) Q:X'=+X  W !?10,$P(^SC(X,0),U)
 S BGPDIVI=0 F  S BGPDIVI=$O(^XTMP("BGP9DPA",BGPGPRAJ,BGPGPRAH,"APPTS",BGPDIVI)) Q:BGPDIVI'=+BGPDIVI!($D(BGPQ))  D DPRINT1
 Q
DPRINT1 ;
 S BGPCLN="" F  S BGPCLN=$O(^XTMP("BGP9DPA",BGPGPRAJ,BGPGPRAH,"APPTS",BGPDIVI,BGPCLN)) Q:BGPCLN=""!($D(BGPQ))  D
 .S BGPD=0 F  S BGPD=$O(^XTMP("BGP9DPA",BGPGPRAJ,BGPGPRAH,"APPTS",BGPDIVI,BGPCLN,BGPD)) Q:BGPD'=+BGPD!($D(BGPQ))  D
 ..S BGPADT=0 F  S BGPADT=$O(^XTMP("BGP9DPA",BGPGPRAJ,BGPGPRAH,"APPTS",BGPDIVI,BGPCLN,BGPD,BGPADT)) Q:BGPADT'=+BGPADT!($D(BGPQ))  D
 ...S BGPNAME="" F  S BGPNAME=$O(^XTMP("BGP9DPA",BGPGPRAJ,BGPGPRAH,"APPTS",BGPDIVI,BGPCLN,BGPD,BGPADT,BGPNAME)) Q:BGPNAME=""!($D(BGPQ))  D
 ....S DFN=0 F  S DFN=$O(^XTMP("BGP9DPA",BGPGPRAJ,BGPGPRAH,"APPTS",BGPDIVI,BGPCLN,BGPD,BGPADT,BGPNAME,DFN)) Q:DFN'=+DFN!($D(BGPQ))  D
 .....D HEADER Q:$D(BGPQ)
 .....D SUB
 .....S BGPIC=0 F  S BGPIC=$O(^XTMP("BGP9DPA",BGPGPRAJ,BGPGPRAH,"APPTS",BGPDIVI,BGPCLN,BGPD,BGPADT,BGPNAME,DFN,BGPIC)) Q:BGPIC'=+BGPIC!($D(BGPQ))  D
 ......S BGPI=0 F  S BGPI=$O(^XTMP("BGP9DPA",BGPGPRAJ,BGPGPRAH,"APPTS",BGPDIVI,BGPCLN,BGPD,BGPADT,BGPNAME,DFN,BGPIC,BGPI)) Q:BGPI'=+BGPI!($D(BGPQ))  D
 .......I $Y>(IOSL-3) D HEADER Q:$D(BGPQ)  D SUB
 .......S Y=^XTMP("BGP9DPA",BGPGPRAJ,BGPGPRAH,"APPTS",BGPDIVI,BGPCLN,BGPD,BGPADT,BGPNAME,DFN,BGPIC,BGPI)
 .......D WRITE
 .......;
 .......;S BGPX=$P(Y,U,2)
 .......;S BGPT=$P(Y,U,1),BGPT1=$P(Y,U,4)
 .......;W !,BGPT
 .......;F X=1:1 S Y=$P(BGPX,"|",X) Q:Y=""  W:X'=1 ! W ?27,Y
 .......;I $Y>(IOSL-4) D HEADER Q:$D(BGPQ)  D SUB
 .......;D WP
 ......Q
 .....Q
 ....Q
 ...Q
 ..Q
 .Q
 Q
PPRINT ;
 I '$D(^XTMP("BGP9DPA",BGPGPRAJ,BGPGPRAH,"PATS")) D HEADER S BGPNOD=1 D  Q
 .W !!,"There were either no appointments found for " S X=$O(BGPPATS(0)) W $P(^DPT(X,0),U),!,"during the specified timeframe of ",$$FMTE^XLFDT(BGPABD)," to ",$$FMTE^XLFDT(BGPAED)," or",!,"this patient was not due for any GPRA measure." Q
 S BGPNAME="" F  S BGPNAME=$O(^XTMP("BGP9DPA",BGPGPRAJ,BGPGPRAH,"PATS",BGPNAME)) Q:BGPNAME=""!($D(BGPQ))  D
 .S DFN=0 F  S DFN=$O(^XTMP("BGP9DPA",BGPGPRAJ,BGPGPRAH,"PATS",BGPNAME,DFN)) Q:DFN'=+DFN!($D(BGPQ))  D
 ..S BGPD=0 F  S BGPD=$O(^XTMP("BGP9DPA",BGPGPRAJ,BGPGPRAH,"PATS",BGPNAME,DFN,BGPD)) Q:BGPD'=+BGPD!($D(BGPQ))  D
 ...S BGPCLN="" F  S BGPCLN=$O(^XTMP("BGP9DPA",BGPGPRAJ,BGPGPRAH,"PATS",BGPNAME,DFN,BGPD,BGPCLN)) Q:BGPCLN=""!($D(BGPQ))  D
 ....S BGPADT=0 F  S BGPADT=$O(^XTMP("BGP9DPA",BGPGPRAJ,BGPGPRAH,"PATS",BGPNAME,DFN,BGPD,BGPCLN,BGPADT)) Q:BGPADT=""!($D(BGPQ))  D
 .....D HEADER Q:$D(BGPQ)
 .....D SUB
 .....S BGPIC=0 F  S BGPIC=$O(^XTMP("BGP9DPA",BGPGPRAJ,BGPGPRAH,"PATS",BGPNAME,DFN,BGPD,BGPCLN,BGPADT,BGPIC)) Q:BGPIC'=+BGPIC!($D(BGPQ))  D
 ......S BGPI=0 F  S BGPI=$O(^XTMP("BGP9DPA",BGPGPRAJ,BGPGPRAH,"PATS",BGPNAME,DFN,BGPD,BGPCLN,BGPADT,BGPIC,BGPI)) Q:BGPI'=+BGPI!($D(BGPQ))  D
 .......I $Y>(IOSL-3) D HEADER Q:$D(BGPQ)  D SUB
 .......S Y=^XTMP("BGP9DPA",BGPGPRAJ,BGPGPRAH,"PATS",BGPNAME,DFN,BGPD,BGPCLN,BGPADT,BGPIC,BGPI)
 .......D WRITE
 .......;
 .......;S BGPT=$P(Y,U,1),BGPT1=$P(Y,U,4)
 .......;W !,BGPT
 .......;F X=1:1 S Y=$P(BGPX,"|",X) Q:Y=""  W:X'=1 ! W ?27,Y
 .......;I $Y>(IOSL-4) D HEADER Q:$D(BGPQ)  D SUB
 .......;D WP
 ......Q
 .....Q
 ....Q
 ...Q
 ..Q
 .Q
 Q
WRITE ;
 S BGPNOBAN=""
 S BGPX=$P(Y,U,2)
 S BGPT=$P(Y,U,1),BGPT1=$P(Y,U,4)
 W !,BGPT
 W ?27,$P(BGPX,"|",1)
 W !,BGPT1
 I $P(BGPX,"|",2)="" S BGPNOBAN=1
 F X=2:1 S Y=$P(BGPX,"|",X) Q:Y=""  W:X'=2 ! W ?27,Y
 I $Y>(IOSL-4) D HEADER Q:$D(BGPQ)  D SUB
 D WP
 Q
WP ;
 K ^UTILITY($J,"W")
 S BGPZ=0
 S DIWL=28,DIWR=78,DIWF="" F  S BGPZ=$O(^BGPINDNC(BGPI,$S($G(BGPNGR09):1601,1:16),BGPZ)) Q:BGPZ'=+BGPZ  D
 .S X=^BGPINDNC(BGPI,$S($G(BGPNGR09):1601,1:16),BGPZ,0) D ^DIWP
 .Q
WPS ;
 S Z=0 F  S Z=$O(^UTILITY($J,"W",DIWL,Z)) Q:Z'=+Z  D
 .I Z=1,'BGPNOBAN W !
 .W ?27,^UTILITY($J,"W",DIWL,Z,0),!
 K DIWL,DIWR,DIWF,Z
 K ^UTILITY($J,"W"),X
 Q
APRINT ;
 I '$D(^XTMP("BGP9DPA",BGPGPRAJ,BGPGPRAH,"ANY")) D HEADER S BGPNOD=1 D  Q
 .W !!,"There were no GPRA Measures due for any patient selected."
 S BGPNAME="" F  S BGPNAME=$O(^XTMP("BGP9DPA",BGPGPRAJ,BGPGPRAH,"ANY",BGPNAME)) Q:BGPNAME=""!($D(BGPQ))  D
 .S DFN=0 F  S DFN=$O(^XTMP("BGP9DPA",BGPGPRAJ,BGPGPRAH,"ANY",BGPNAME,DFN)) Q:DFN'=+DFN!($D(BGPQ))  D
 ..D HEADER Q:$D(BGPQ)
 ..D SUB
 ..S BGPIC=0 F  S BGPIC=$O(^XTMP("BGP9DPA",BGPGPRAJ,BGPGPRAH,"ANY",BGPNAME,DFN,BGPIC)) Q:BGPIC'=+BGPIC!($D(BGPQ))  D
 ...S BGPI=0 F  S BGPI=$O(^XTMP("BGP9DPA",BGPGPRAJ,BGPGPRAH,"ANY",BGPNAME,DFN,BGPIC,BGPI)) Q:BGPI'=+BGPI!($D(BGPQ))  D
 ....I $Y>(IOSL-3) D HEADER Q:$D(BGPQ)  D SUB
 ....S Y=^XTMP("BGP9DPA",BGPGPRAJ,BGPGPRAH,"ANY",BGPNAME,DFN,BGPIC,BGPI)
 ....D WRITE
 ....;S BGPX=$P(Y,U,2)
 ....;S BGPT=$P(Y,U,1),BGPT1=$P(Y,U,4)
 ....;W !,BGPT
 ....;F X=1:1 S Y=$P(BGPX,"|",X) Q:Y=""  W:X'=1 ! W ?27,Y
 ....;I $Y>(IOSL-4) D HEADER Q:$D(BGPQ)  D SUB
 ....;D WP
 ...Q
 ..Q
 .Q
 Q
SUB ;
 S T=$S(BGPRT1="A":0,1:11)
 I BGPRT1'="A" W !,$P($$FMTE^XLFDT(BGPADT,"P")," ",4,99)
 I BGPRT1="A" W !
 W ?T,$E($P(^DPT(DFN,0),U),1,25),?38,$$HRN^AUPNPAT(DFN,DUZ(2)),?46,$$SEX^AUPNPAT(DFN),?50,$$DATE^BGP9UTL($$DOB^AUPNPAT(DFN)),?60,$E($$COMMRES^AUPNPAT(DFN,"E"),1,20),!
 Q
HEADER ;EP
 G:'BGPPG HEADER1
 K DIR I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BGPQ="" Q
HEADER1 ;
 I BGPPG W:$D(IOF) @IOF
 S BGPPG=BGPPG+1
 I $G(BGPGUI),BGPPG'=1 W !,"ZZZZZZZ"
 W !,$P(^VA(200,DUZ,0),U,2),?5,"***CONFIDENTIAL PATIENT INFORMATION-COVERED BY THE PRIVACY ACT***",?70,"Page ",BGPPG
 I '$G(BGPNGR09) W !,$$CTR("GPRA & PART Forecast Patient List",80)
 I $G(BGPNGR09) W !,$$CTR("GPRA & PART Forecast Patient List, Run Using 2009 Logic")
 W !,$$CTR("GPRA Measures Not Met or Due During "_$$FMTE^XLFDT(BGPBD)_"-"_$$FMTE^XLFDT(BGPED),80)
 W !,$$CTR($$RPTVER^BGP9BAN,80)
 I BGPRT1'="A",BGPCLN]"" W !,$$CTR("Patients with an Appointment in "_BGPCLN_$S($G(BGPD):" on "_$$FMTE^XLFDT(BGPD),1:""),80)
 W !,$$CTR("Date Report Run: "_$$FMTE^XLFDT(DT),80)
 W !,$$CTR("Site where Run: "_$P(^DIC(4,DUZ(2),0),U),80)
 W !,$$CTR("Report Generated by: "_$P(^VA(200,DUZ,0),U),80)
 W !,$TR($J("",80)," ","-")
 I BGPRT1'="A" W !,"Appt Time",?11,"Patient Name"
 I BGPRT1="A" W !,"Patient Name"
 W ?38,"HRN",?46,"Sex",?50,"DOB",?60,"Community"
 W !,"GPRA Measure Not Met",?27,"Date of Last Screening and Next Due Date"
 W !?27,"Tests Counted for GPRA Measure"
 W !,$TR($J("",80)," ","-")
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
EOP ;EP - End of page.
 Q:$E(IOST)'="C"
 Q:$D(ZTQUEUED)!'(IOT="TRM")!$D(IO("S"))
 K DIR
 K DIRUT,DFOUT,DLOUT,DTOUT,DUOUT
 S DIR("A")="End of report.  Press Enter",DIR(0)="E" D ^DIR
 Q
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
