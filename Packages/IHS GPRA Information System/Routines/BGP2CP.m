BGP2CP ; IHS/CMI/LAB - IHS gpra print 02 Jul 2010 9:06 AM ;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
 ;
PRINT ;
 K ^TMP($J)
 S BGPIOSL=$S($G(BGPGUI):55,1:IOSL)
 S BGPGPG=0
 S BGPQUIT=""
 D HEADER
 I BGPQUIT G END
 D PRINT1
END ;
 K ^XTMP("BGP2C1",BGPJ,BGPH)
 K ^TMP($J)
 D EXIT
 Q
 ;
PRINT1 ;EP
 S BGPIND=0 F  S BGPIND=$O(BGPPLSTL(BGPIND)) Q:BGPIND'=+BGPIND!(BGPQUIT)  D
 .S BGPPLSTL=0 F  S BGPPLSTL=$O(BGPPLSTL(BGPIND,BGPPLSTL))  Q:BGPPLSTL'=+BGPPLSTL!(BGPQUIT)  D
 ..S BGPL1P1=1
 ..D HDR
 ..Q:BGPQUIT
 ..D HDR1
 ..Q:BGPQUIT
 ..S BGPL1P1=0
 ..D LIST1
 Q
HDR1 ;
 Q:'BGPTEXD
 S BGPX=0 F  S BGPX=$O(^BGPCMSMB(BGPPLSTL,21,BGPX)) Q:BGPX'=+BGPX!(BGPQUIT)  D
 .I $Y>(BGPIOSL-3) D HDR Q:BGPQUIT
 .W !,^BGPCMSMB(BGPPLSTL,21,BGPX,0)
 Q
LIST1 ;DISPLAY LIST 1
 K BGPL2
 I $O(^BGPCMSMB(BGPPLSTL,73,0)) D:BGPTEXD HDR D  ;if there is a first page header
 .S BGPX=0 F  S BGPX=$O(^BGPCMSMB(BGPPLSTL,73,BGPX)) Q:BGPX'=+BGPX!(BGPQUIT)  D
 ..I $Y>(BGPIOSL-3) D HDR Q:BGPQUIT
 ..W !,^BGPCMSMB(BGPPLSTL,73,BGPX,0)
 I $O(^BGPCMSMB(BGPPLSTL,73,0)) W !,$TR($J("",80)," ","-")
 Q:BGPQUIT
 D L1H
 Q:BGPQUIT
 S BGPAST=0
 I '$D(^XTMP("BGP2C1",BGPJ,BGPH,"LIST",BGPIND,BGPPLSTL)) W !!,"No Visits to report" Q
 S BGPNAME="" F  S BGPNAME=$O(^XTMP("BGP2C1",BGPJ,BGPH,"LIST",BGPIND,BGPPLSTL,BGPNAME)) Q:BGPNAME=""!(BGPQUIT)  D
 .S DFN=0 F  S DFN=$O(^XTMP("BGP2C1",BGPJ,BGPH,"LIST",BGPIND,BGPPLSTL,BGPNAME,DFN)) Q:DFN'=+DFN!(BGPQUIT)  D
 ..S BGPVSIT=0 F  S BGPVSIT=$O(^XTMP("BGP2C1",BGPJ,BGPH,"LIST",BGPIND,BGPPLSTL,BGPNAME,DFN,BGPVSIT)) Q:BGPVSIT'=+BGPVSIT!(BGPQUIT)  D
 ...S BGPVSIT0=$G(^AUPNVSIT(BGPVSIT,0))
 ...S BGPVINP=$O(^AUPNVINP("AD",BGPVSIT,0))
 ...I $Y>(BGPIOSL-4) D HDR Q:BGPQUIT  D L1H
 ...W !!
 ...S BGPPEX=^XTMP("BGP2C1",BGPJ,BGPH,"LIST",BGPIND,BGPPLSTL,BGPNAME,DFN,BGPVSIT)
 ...I BGPPEX]"" W "*" S BGPEXCP(BGPIND,BGPPLSTL)=$G(BGPEXCP(BGPIND,BGPPLSTL))+1
 ...W $E(BGPNAME,1,25),?27,$$HRN^AUPNPAT(DFN,DUZ(2)),?35,$P(^DPT(DFN,0),U,2),?38,$$AGE^AUPNPAT(DFN,$P($P(BGPVSIT0,U),"."))
 ...I '$P(^BGPCMSMB(BGPPLSTL,0),U,6) D
 ....W ?42,$$DATE^BGP2UTL($P($P(BGPVSIT0,U),"."))_"-"_$$DATE^BGP2UTL($$DSCH^BGP2CU(BGPVINP)) I BGPIND=1!(BGPIND=3) W $S(BGPPEX[2!(BGPPEX[1):"*",1:"")
 ....W ?62,$E($$VAL^XBDIQ1(9000010.02,BGPVINP,.07),1,18)
 ...I $P(^BGPCMSMB(BGPPLSTL,0),U,6) D
 ....W ?42,$E($$VAL^XBDIQ1(9000001,DFN,1111),1,19)
 ....W ?62,$$DATE^BGP2UTL($P($P(BGPVSIT0,U),"."))_"-"_$$DATE^BGP2UTL($$DSCH^BGP2CU(BGPVINP))
 ...S BGPCOUNT(BGPIND,BGPPLSTL)=$G(BGPCOUNT(BGPIND,BGPPLSTL))+1
 ...X ^BGPCMSMB(BGPPLSTL,1)
 Q:BGPQUIT
 I $Y>(BGPIOSL-4) D HDR Q:BGPQUIT  D L1H
 W !!,"TOTAL VISITS: ",+$G(BGPCOUNT(BGPIND,BGPPLSTL))
 Q:'$P(^BGPCMSMB(BGPPLSTL,0),U,5)
 W !!,"TOTAL VISITS THAT WOULD BE EXCLUDED: ",+$G(BGPEXCP(BGPIND,BGPPLSTL))
 Q
L1H ;EP - list one header
 I $Y>(BGPIOSL-3) D HDR Q:BGPQUIT
 ;W !,$TR($J("",80)," ","-")
 I '$P(^BGPCMSMB(BGPPLSTL,0),U,6) W !,"PATIENT NAME",?27,"HRN",?34,"SEX",?38,"AGE",?42,"HOSP DATES",?62,"ADMISSION TYPE"
 I $P(^BGPCMSMB(BGPPLSTL,0),U,6) W !,"PATIENT NAME",?27,"HRN",?34,"SEX",?38,"AGE",?42,"CLASS/BENEFICIARY",?64,"HOSP DATES"
 W !,$TR($J("",80)," ","-")
 ;I $G(BGPEXCL)=1 Q
 I '$P(^BGPCMSMB(BGPPLSTL,0),U,5) Q
 W !,"*Indicates CRS would have excluded this patient based on this data if RPMS"
 W !,"exclusion logic had been applied.",!
 Q
HDR ;EP
 NEW X,Y,Z
 G:'BGPGPG HEADER1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BGPQUIT=1 Q
HEADER1 ;
 W:$D(IOF) @IOF S BGPGPG=BGPGPG+1
 I $G(BGPGUI) W "ZZZZZZZ",!  ;maw
 W $P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BGPGPG,!
 W $$CTR("*** IHS 2012 CMS Hospital Quality Reporting Initiative ***",80)
 W !,$$CTR($$RPTVER^BGP2BAN,80)
 W !,$$CTR("Hospital: "_$P(^DIC(4,BGPHOSP,0),U),80)
 S X="Report Period:  "_$$FMTE^XLFDT(BGPBD)_" to "_$$FMTE^XLFDT(BGPED) W !,$$CTR(X,80)
 I $G(BGPIND) S X="Topic:  "_$P(^BGPCMSIB(BGPIND,0),U,3) W !,$$CTR(X,80)
 I $G(BGPPLSTL),$P($G(^BGPCMSMB(BGPPLSTL,71)),U,2)]"" S X="Performance Measure: "_$P(^BGPCMSMB(BGPPLSTL,71),U,2) W !,$$CTR(X,80)
 I $G(BGPPLSTL) S X="Patient List:  "_$P(^BGPCMSMB(BGPPLSTL,0),U,4) W !,$$CTR(X,80)
 W !,$TR($J("",80)," ","-")
 ;I $G(BGPPLSTL) W !,$P($G(^BGPCMSMB(BGPPLSTL,71)),U) D
 ;.I $P($G(^BGPCMSMB(BGPPLSTL,71)),U,3)]"" W !,$P($G(^BGPCMSMB(BGPPLSTL,71)),U,3)
 ;.W $S(BGPL1P1=0:" (cont'd)",1:""),!
 S BGPL1P1=0
 Q
EXIT ;
 I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO",DIR("A")="End of report.  Press ENTER" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q
C(X,X2,X3) ;
 D COMMA^%DTC
 Q X
HEADER ;
 Q:'BGPTEXD
 ;W:$D(IOF) @IOF
 W $$CTR("Cover Page",80)
 W !,$$CTR("*** IHS 2012 CMS Hospital Quality Reporting Initiative ***",80)
 W !,$$CTR($$RPTVER^BGP2BAN,80)
 W !,$$CTR("Date Report Run: "_$$FMTE^XLFDT(DT),80)
 W !,$$CTR("Hospital: "_$P(^DIC(4,BGPHOSP,0),U),80)
 W !,$$CTR("Report Generated by: "_$$USR,80)
 S X="Report Period:  "_$$FMTE^XLFDT(BGPBD)_" to "_$$FMTE^XLFDT(BGPED) W !,$$CTR(X,80)
 D ENDTIME
 W !
 S BGPX=$O(^BGPCTRL("B",2012,0))
 S BGPY=0 F  S BGPY=$O(^BGPCTRL(BGPX,21,BGPY)) Q:BGPY'=+BGPY!(BGPQUIT)  D
 .I $Y>(BGPIOSL-1) D HDR Q:$D(BGPQUIT)
 .W !,^BGPCTRL(BGPX,21,BGPY,0)
 .Q
 K BGPX
 Q
ENDTIME ;
 I $D(BGPET) S BGPTS=(86400*($P(BGPET,",")-$P(BGPBT,",")))+($P(BGPET,",",2)-$P(BGPBT,",",2)),BGPHR=$P(BGPTS/3600,".") S:BGPHR="" BGPHR=0 D
 .S BGPTS=BGPTS-(BGPHR*3600),BGPM=$P(BGPTS/60,".") S:BGPM="" BGPM=0 S BGPTS=BGPTS-(BGPM*60),BGPS=BGPTS S X="RUN TIME (H.M.S): "_BGPHR_"."_BGPM_"."_BGPS W !,$$CTR(X,80)
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:80)-$L(X)\2)_X
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
