BDWEPRN ; IHS/CMI/LAB - Display TX ERRORS AUGUST 14, 1992 ;
 ;;1.0;IHS DATA WAREHOUSE;;JAN 23, 2006
 ;
LOG ;get log entry
 W !!,"Data Warehouse Transmission Error Listing",!
 S DIC="^BDWXLOG(",DIC(0)="AEMQ" D ^DIC K DIC I Y=-1 W !!,"Goodbye" G XIT
 S BDWLOG=+Y S BDWD=BDWLOG
 I '$D(^BDWXLOG(BDWLOG,51)) W !!,"No TX errors generated on that run." G LOG
LOC ;
 K BDWLOCT
 S DIR(0)="S^A:ALL Locations/Facilities;S:One SERVICE UNIT'S Locations/Facilities;O:ONE Location/Facility",DIR("A")="Include Visits to Which Location/Facilities",DIR("B")="A"
 S DIR("A")="Enter a code indicating what LOCATIONS/FACILITIES are of interest",DIR("B")="O" K DA D ^DIR K DIR,DA
 G:$D(DIRUT) LOG
 S BDWLOCT=Y
 I BDWLOCT="A" K BDWLOCT G ZIS
 D @BDWLOCT
 G:$D(BDWQ) LOC
ZIS ;call xbdbque
 S XBRC="DRIVER^BDWEPRN",XBRP="PRINT^BDWEPRN",XBRX="XIT^BDWEPRN",XBNS="BDW"
 D ^XBDBQUE
 D XIT
 Q
DRIVER ;EP entry point for taskman
 S BDWH=$H,BDWJ=$J
 K ^XTMP("BDWEPRN",BDWJ,BDWH)
 S BDWE=0 F  S BDWE=$O(^BDWXLOG(BDWLOG,51,BDWE)) Q:BDWE'=+BDWE  D
 .S BDWERR=$P(^BDWXLOG(BDWLOG,51,BDWE,0),U,3)
 .S BDWV=$P(^BDWXLOG(BDWLOG,51,BDWE,0),U,1)
 .Q:BDWV=""
 .Q:'$D(^AUPNVSIT(BDWV,0))
 .I $P(^AUPNVSIT(BDWV,0),U,6),$D(BDWLOCT),'$D(BDWLOCT($P(^AUPNVSIT(BDWV,0),U,6))) Q
 .I $E(BDWERR,1,6)="100-DE" S BDWDVNS=$G(BDWDVNS)+1 Q
 .S ^XTMP("BDWEPRN",BDWJ,BDWH,"ERRORS",+$P(^AUPNVSIT(BDWV,0),U,6),$P(^AUPNVSIT(BDWV,0),U,1),BDWE)=BDWV_U_BDWERR
 Q
PRINT ;EP
 S BDWPG=0,BDWQ=""
 D HEAD
 W !,"There were ",$G(BDWDVNS)," deleted visits that were never sent to the Data Warehouse.",!,"These visits are those that were added and then merged to another visit,",!,"thus they would not have been passed to the Warehouse.",!
 S BDWL=0 F  S BDWL=$O(^XTMP("BDWEPRN",BDWJ,BDWH,"ERRORS",BDWL)) Q:BDWL'=+BDWL!(BDWQ)  D
 .S BDWD="" F  S BDWD=$O(^XTMP("BDWEPRN",BDWJ,BDWH,"ERRORS",BDWL,BDWD)) Q:BDWD=""!(BDWQ)  D
 ..S BDWE=0 F  S BDWE=$O(^XTMP("BDWEPRN",BDWJ,BDWH,"ERRORS",BDWL,BDWD,BDWE)) Q:BDWE'=+BDWE!(BDWQ)  D
 ...S BDWV=$P(^XTMP("BDWEPRN",BDWJ,BDWH,"ERRORS",BDWL,BDWD,BDWE),U),BDWERR=$P(^(BDWE),U,2),BDWDFN=$P(^AUPNVSIT(BDWV,0),U,5)
 ...I $Y>(IOSL-5) D HEAD Q:BDWQ
 ...W !,$E($$VAL^XBDIQ1(9000010,BDWV,.05),1,20)
 ...S BDWHRN=$$HRN^AUPNPAT(BDWDFN,BDWL)
 ...I BDWHRN="" S BDWHRN=$$CHART^BDWUTIL1(BDWV)
 ...I BDWHRN="" S BDWHRN="?????"
 ...W ?22,BDWHRN,?29,$$FMTE^XLFDT(BDWD,5),?45,$S(BDWL:$E($P($G(^DIC(4,BDWL,0)),U,1),1,10),1:"??"),?57,$E(BDWERR,1,22)
 K ^XTMP("BDWEPRN",BDWJ,BDWH)
 Q
XIT ;EP
 D EN^XBVK("BDW")
 D ^XBFMK
 Q
O ;one community
 S DIC="^AUTTLOC(",DIC(0)="AEMQ",DIC("A")="Which LOCATION: " D ^DIC K DIC
 I Y=-1 S BDWQ="" Q
 S BDWLOCT(+Y)=""
 Q
S ;all communities within BDWSU su
 S DIC="^AUTTSU(",DIC("B")=$$VAL^XBDIQ1(9999999.06,DUZ(2),.05),DIC(0)="AEMQ",DIC("A")="Which SERVICE UNIT: " D ^DIC K DIC
 I Y=-1 S BDWQ="" Q
 W !!,"Gathering up ",$P(^AUTTSU(+Y,0),U),"'s Facilities.."
 S X=0 F  S X=$O(^AUTTLOC(X)) Q:X'=+X  I $P(^AUTTLOC(X,0),U,5)=+Y S BDWLOCT(X)=""
 Q
 ;
HEAD ;EP
 G:'BDWPG HEAD1
 K DIR I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BDWQ=1 Q
HEAD1 ;
 W:$D(IOF) @IOF S BDWPG=BDWPG+1
 W !?35,$$FMTE^XLFDT(DT),?70,"Page ",BDWPG
 S X="***** DATA WAREHOUSE EXPORT ERROR LISTING *****" W !,?((80-$L(X))/2),X
 S X="Log Entry: "_BDWLOG_"  Dates: "_$$FMTE^XLFDT($P(^BDWXLOG(BDWLOG,0),U,1))_" to "_$$FMTE^XLFDT($P(^BDWXLOG(BDWLOG,0),U,2)) W !,$$CTR(X,80),!
 I '$D(BDWLOCT) S X="ALL Locations/Facilities Included" W $$CTR(X,80),!
 I $D(BDWLOCT) S X="Selected Facilities/Locations Included" W $$CTR(X,80),!
 W !,"Name",?22,"HRN",?29,"Visit Date/Time",?45,"Location",?57,"ERROR"
 W !,$TR($J("",80)," ","-")
 Q
LBLK(V,L) ;left blank fill
 NEW %,I
 S %=$L(V),Z=L-% F I=1:1:Z S V=" "_V
 Q V
RBLK(V,L) ;EP right blank fill
 NEW %,I
 S %=$L(V),Z=L-% F I=1:1:Z S V=V_" "
 Q V
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
