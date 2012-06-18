AMHRPPA ; IHS/CMI/LAB - TALLY PREVENTION ACTIVITIES ;
 ;;4.0;IHS BEHAVIORAL HEALTH;**1**;JUN 18, 2010;Build 8
 ;
START ;
 D XIT
 I '$D(IOF) D HOME^%ZIS
 W @(IOF),!!
 D INFORM
DATES K AMHED,AMHBD
 K DIR W ! S DIR(0)="DO^::EXP",DIR("A")="Enter Beginning Visit Date"
 D ^DIR G:Y<1 XIT S AMHBD=Y
 K DIR S DIR(0)="DO^:DT:EXP",DIR("A")="Enter Ending Visit Date"
 D ^DIR G:Y<1 XIT  S AMHED=Y
 ;
 I AMHED<AMHBD D  G DATES
 . W !!,$C(7),"Sorry, Ending Date MUST not be earlier than Beginning Date."
 S AMHSD=$$FMADD^XLFDT(AMHBD,-1)_".9999"
 ;
PROG ;
 S AMHPROG=""
 S DIR(0)="S^O:ONE Program;A:ALL Programs",DIR("A")="Run the Report for which PROGRAM",DIR("B")="A" KILL DA D ^DIR KILL DIR
 G:$D(DIRUT) DATES
 I Y="A" G PROV
 S DIR(0)="9002011,.02",DIR("A")="Which PROGRAM" KILL DA D ^DIR KILL DIR
 G:$D(DIRUT) PROG
 I X="" G PROG
 S AMHPROG=Y
PROV ;
 K AMHQ
 W !!,$G(IORVON)_"Please enter the Providers whose Prevention activities you want to tally."_$G(IORVOFF),!
 S AMHPRVT=""
 K AMHPRVS
 S DIR(0)="S^A:ALL Providers;S:Selected set or Taxonomy of Providers;O:ONE Provider",DIR("A")="Include Visits to Which Providers",DIR("B")="A"
 S DIR("A")="Enter a code indicating which providers are of interest",DIR("B")="A" K DA D ^DIR K DIR,DA
 G:$D(DIRUT) PROG
 S AMHPRVT=Y
 I AMHPRVT="A" G DEMO
 D @(AMHPRVT_"PRV")
 G:$D(AMHQ) PROV
DEMO ;
 D DEMOCHK^AMHUTIL1(.AMHDEMO)
 I AMHDEMO=-1 G PROV
ZIS ;call xbdbque
 S XBRC="DRIVER^AMHRPPA",XBRP="PRINT^AMHRPPA",XBRX="XIT^AMHRPPA",XBNS="AMH"
 D ^XBDBQUE
 D XIT
 Q
DRIVER ;EP entry point for taskman
 D PROCESS
 S AMHET=$H
 Q
XIT ;
 K DIR
 D EN^XBVK("AMH")  ;clean up AMH variables
 D ^XBFMK  ;clean up fileman variables
 Q
 ;
PROCESS ;
 D XTMP^AMHUTIL("AMHRPPA","BH - PREVENTION ACTIVITIES")
 S (AMHBT,AMHBTH)=$H,AMHJOB=$J
 S AMHSD=$P(AMHBD,".")-1,AMHSD=AMHSD_".9999"
 K AMHPRAT,AMHTARG S AMHGRTA=0,AMHGRTT=0,AMHGTPA=0
 S (AMHRCNT,AMHVIEN)=0 F  S AMHSD=$O(^AMHREC("B",AMHSD)) Q:AMHSD=""!($P(AMHSD,".")>$P(AMHED,"."))  D
 .S AMHVIEN=0 F  S AMHVIEN=$O(^AMHREC("B",AMHSD,AMHVIEN)) Q:AMHVIEN'=+AMHVIEN  D
 ..S AMHV0=$G(^AMHREC(AMHVIEN,0))
 ..Q:AMHV0=""
 ..Q:'$D(^AMHRPA("AD",AMHVIEN))  ;no prevention activities
 ..Q:'$$ALLOWVI^AMHUTIL(DUZ,AMHVIEN)
 ..I $P(AMHV0,U,8) Q:$$DEMO^AMHUTIL1($P(AMHV0,U,8),$G(AMHDEMO))
 ..I AMHPROG]"",$P(^AMHREC(AMHVIEN,0),U,2)'=AMHPROG Q  ;not correct program visit
 ..S AMHVPP=$$PPINT^AMHUTIL(AMHVIEN)
 ..I AMHVPP="",$D(AMHPRVS) Q  ;PRIM PROV blank and want certain PRIM PROVS
 ..I $D(AMHPRVS),'$D(AMHPRVS(AMHVPP)) Q  ;not a PRIM PROV we want
 ..S AMHTAR=$$VAL^XBDIQ1(9002011,AMHVIEN,1106)
 ..I AMHTAR]"" S AMHGRTT=AMHGRTT+1,AMHTARG(AMHTAR)=$G(AMHTARG(AMHTAR))+1
 ..I AMHTAR="" S AMHGRTT=AMHGRTT+1,AMHTARG("NOT RECORDED")=$G(AMHTARG("NOT RECORDED"))+1
 ..S AMHGRTA=AMHGRTA+1
 ..S AMHX=0 F  S AMHX=$O(^AMHRPA("AD",AMHVIEN,AMHX)) Q:AMHX'=+AMHX  D
 ...S X=$$VAL^XBDIQ1(9002011.09,AMHX,.01)
 ...I X="OTHER" S Y=$E($$UP^XLFSTR($$VAL^XBDIQ1(9002011.09,AMHX,.04)),1,40) S X=$S(Y]"":Y,1:"OTHER - NO DETAIL GIVEN")
 ...S AMHPRAT(X)=$G(AMHPRAT(X))+1
 ...I AMHTAR]"" S AMHPRAT(X,AMHTAR)=$G(AMHPRAT(X,AMHTAR))+1
 ...I AMHTAR="" S AMHPRAT(X,"NOT RECORDED")=$G(AMHPRAT(X,"NOT RECORDED"))+1
 ...S AMHGTPA=AMHGTPA+1
 ..Q
 .Q
 S AMHET=$H
 Q
 ;
PRINT ;EP - called from xbdbque
 S Y=AMHBD D DD^%DT S AMHBDD=Y S Y=AMHED D DD^%DT S AMHEDD=Y
 S AMHPG=0
 K AMHQUIT
 D PRINT1
DONE I $D(AMHET) S AMHDVTS=(86400*($P(AMHET,",")-$P(AMHBT,",")))+($P(AMHET,",",2)-$P(AMHBT,",",2)),AMHDVH=$P(AMHDVTS/3600,".") S:AMHDVH="" AMHDVH=0
 S AMHDVTS=AMHDVTS-(AMHDVH*3600),AMHDVM=$P(AMHDVTS/60,".") S:AMHDVM="" AMHDVM=0 S AMHDVTS=AMHDVTS-(AMHDVM*60),AMHDVS=AMHDVTS W !!,"RUN TIME (H.M.S): ",AMHDVH,".",AMHDVM,".",AMHDVS
 I $E(IOST)="C",IO=IO(0) S DIR(0)="E" D ^DIR K DIR
 W:$D(IOF) @IOF
 Q
PRINT1 ;
 D HEAD
 I '$D(AMHPRAT) W !!,"There are no visits with Prevention Activities Recorded." Q
 W !!,"Total # Visits w/Prevention Activity: ",?45,$$C(AMHGRTA,0)
 W !,"Total # of Prevention Activities recorded: ",?45,$$C(AMHGTPA,0)
 S AMHS="" F  S AMHS=$O(AMHPRAT(AMHS)) Q:AMHS=""!($D(AMHQUIT))  D
 .I $Y>(IOSL-3) D HEAD Q:$D(AMHQUIT)
 .S AMHX=AMHPRAT(AMHS)
 .W !!?1,AMHS,?45,$$C(AMHX,0),?60,$J(((AMHX/AMHGRTA)*100),5,1)
 .S AMHY="" F  S AMHY=$O(AMHPRAT(AMHS,AMHY)) Q:AMHY=""!($D(AMHQUIT))  D
 ..I $Y>(IOSL-3) D HEAD Q:$D(AMHQUIT)
 ..W !?4,AMHY
 ..S AMHZ=AMHPRAT(AMHS,AMHY)
 ..W ?20,$$C(AMHZ,0),?28,$J(((AMHZ/AMHX)*100),5,1)
 Q:$D(AMHQUIT)
 I $Y>(IOSL-3) D HEAD Q:$D(AMHQUIT)
 W !!,"TARGET TOTALS",!
 S AMHX="" F  S AMHX=$O(AMHTARG(AMHX)) Q:AMHX=""!($D(AMHQUIT))  D
 .I $Y>(IOSL-3) D HEAD Q:$D(AMHQUIT)
 .W !?4,AMHX,?20,$$C(AMHTARG(AMHX),0),?28,$J(((AMHTARG(AMHX)/AMHGRTT)*100),5,1)
 Q
PAGEHEAD ;
HEAD ;EP;HEADER
 I 'AMHPG G HEAD1
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S AMHQUIT="" Q
HEAD1 ;
 W:$D(IOF) @IOF S AMHPG=AMHPG+1
 W !,$$FMTE^XLFDT(DT),?70,"Page: ",AMHPG
 W !?29,"Behavioral Health"
 W !,$$CTR($$REPEAT^XLFSTR("*",36),80)
 W !,$$CTR("*   TALLY OF PREVENTION ACTIVITIES  *",80)
 W !,$$CTR($$REPEAT^XLFSTR("*",36),80)
 S X="VISIT Date Range: "_AMHBDD_" through "_AMHEDD W !,$$CTR(X,80)
 I AMHPROG]"" S X="Program: "_$$EXTSET^XBFUNC(9002011,.02,AMHPROG) W !,$$CTR(X,80),!
 W !?5,"PREVENTION ACTIVITY",?45,"# of visits",?60,"% of visits"
 W !,$$REPEAT^XLFSTR("-",80)
 Q
C(X,X2,X3) ;
 D COMMA^%DTC
 Q $$STRIP^XLFSTR(X," ")
D(D) ;
 I $G(D)="" Q ""
 Q $E(D,4,5)_"/"_$E(D,6,7)_"/"_$E(D,2,3)
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
EOP ;EP - End of page.
 Q:$E(IOST)'="C"
 Q:$D(ZTQUEUED)!'(IOT="TRM")!$D(IO("S"))
 NEW DIR
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
INFORM ;inform user what this report is all about
 W !,$$CTR($$LOC)
 W !!,$$CTR("BEHAVIORAL HEALTH PREVENTION ACTIVITIES")
 W !!,"This report will produce a count of all visits with a prevention"
 W !,"activity entered.  It will also produce a tally/count of those"
 W !,"prevention activities with Target Audience subtotals."
 W !
 D DBHUSR^AMHUTIL
 Q
OPRV ;one PROVIDER
 S DIC="^VA(200,",DIC(0)="AEMQ",DIC("A")="Which PROVIDER: " D ^DIC K DIC
 I Y=-1 S AMHQ="" Q
 S AMHPRVS(+Y)=""
 Q
SPRV ;taxonomy of PROVIDERS
 S X="PRIMARY PROVIDER",DIC="^AMQQ(5,",DIC(0)="FM",DIC("S")="I $P(^(0),U,14)" D ^DIC K DIC,DA I Y=-1 W "OOPS - QMAN NOT CURRENT - QUITTING" G XIT
 D PEP^AMQQGTX0(+Y,"AMHPRVS(")
 I '$D(AMHPRVS) S AMHQ="" Q
 I $D(AMHPRVS("*")) S AMHPRVT="A" K AMHPRVS W !!,"**** all PROVIDERS will be included ****",! Q
 Q
 ;
