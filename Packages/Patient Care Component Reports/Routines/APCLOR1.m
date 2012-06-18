APCLOR1 ; IHS/CMI/LAB - ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
START ;
 D XIT
 I '$D(IOF) D HOME^%ZIS
 W @(IOF),!!
 D INFORM
TYPE ;type of report
 S APCLRTYP=""
 S DIR(0)="S^L:LAB;P:PHARMACY;R:RADIOLOGY",DIR("A")="What type of ophan visits should be included" KILL DA D ^DIR KILL DIR
 G:$D(DIRUT) XIT
 S APCLRTYP=Y,APCLRTYE=Y(0)
DATES K APCLED,APCLBD
 K DIR W ! S DIR(0)="DO^::EXP",DIR("A")="Enter Beginning Visit Date"
 D ^DIR G:Y<1 TYPE S APCLBD=Y
 K DIR S DIR(0)="DO^:DT:EXP",DIR("A")="Enter Ending Visit Date"
 D ^DIR G:Y<1 TYPE  S APCLED=Y
 ;
 I APCLED<APCLBD D  G DATES
 . W !!,$C(7),"Sorry, Ending Date MUST not be earlier than Beginning Date."
 S APCLSD=$$FMADD^XLFDT(APCLBD,-1)_".9999"
 ;
FAC ;
 S APCLLOCT=""
 S DIR(0)="S^A:ALL Locations/Facilities;S:One SERVICE UNIT'S Locations/Facilities;O:ONE Location/Facility",DIR("A")="Include Visits to Which Location/Facilities",DIR("B")="A"
 S DIR("A")="Enter a code indicating what LOCATIONS/FACILITIES are of interest",DIR("B")="O" K DA D ^DIR K DIR,DA
 G:$D(DIRUT) DATES
 S APCLLOCT=Y
 I APCLLOCT="A" G ZIS
 D @APCLLOCT
 G:$D(APCLQ) FAC
ZIS ;
DEMO ;
 D DEMOCHK^APCLUTL(.APCLDEMO)
 I APCLDEMO=-1 G FAC
 S DIR(0)="S^P:PRINT Output;B:BROWSE Output on Screen",DIR("A")="Do you wish to ",DIR("B")="P" K DA D ^DIR K DIR
 I $D(DIRUT) G XIT
 I $G(Y)="B" D BROWSE,XIT Q
 S XBRC="PROC^APCLOR1",XBRP="PRINT^APCLOR1",XBNS="APCL",XBRX="XIT^APCLOR1"
 D ^XBDBQUE
XIT ;
 D EN^XBVK("APCL"),^XBFMK
 Q
 ;
BROWSE ;
 S XBRP="VIEWR^XBLM(""PRINT^APCLOR1"")"
 S XBNS="APCL",XBRC="PROC^APCLOR1",XBRX="XIT^APCLOR1",XBIOP=0 D ^XBDBQUE
 Q
 ;
PROC ;EP - called from xbdbque
 S ^XTMP("APCLOR1",0)=$$FMADD^XLFDT(DT,14)_"^"_DT_"^"_"ORPHANED VISIT REPORT"
 S APCLJ=$J,APCLH=$H,APCLCNT=0
 K ^XTMP("APCLOR1",APCLJ,APCLH)
 ;$O through all visits and set for patient once
 F  S APCLSD=$O(^AUPNVSIT("B",APCLSD)) Q:APCLSD=""!((APCLSD\1)>APCLED)  D
 .S APCLV=0 F  S APCLV=$O(^AUPNVSIT("B",APCLSD,APCLV)) Q:APCLV'=+APCLV  I $D(^AUPNVSIT(APCLV,0)),$P(^(0),U,9),'$P(^(0),U,11) D PROC1
 .Q
 Q
PROC1 ;
 I $P(^AUPNVSIT(APCLV,0),U,6)="" Q
 I $P(^AUPNVSIT(APCLV,0),U,5)="" Q
 Q:$$DEMO^APCLUTL($P(^AUPNVSIT(APCLV,0),U,5),$G(APCLDEMO))
 I $P(^AUPNVSIT(APCLV,0),U,7)="E" Q  ;exclude events
 I $D(^AUPNVPOV("AD",APCLV)),$D(^AUPNVPRV("AD",APCLV)) Q  ;coded, not orphaned
 I $P(^AUPNVSIT(APCLV,0),U,7)="I",$P(^AUPNVSIT(APCLV,0),U,12)]"" Q  ;PER VINA 10-20-04
 I APCLRTYP="L",'$D(^AUPNVLAB("AD",APCLV)) Q
 I APCLRTYP="R",'$D(^AUPNVRAD("AD",APCLV)) Q
 I APCLRTYP="P",'$D(^AUPNVMED("AD",APCLV)) Q
 I APCLLOCT="O",$P(^AUPNVSIT(APCLV,0),U,6)'=APCLLOCT("ONE") Q
 I APCLLOCT="S",$$VALI^XBDIQ1(9999999.06,$P(^AUPNVSIT(APCLV,0),U,6),.05)'=APCLLOCT("SU") Q
 S ^XTMP("APCLOR1",APCLJ,APCLH,"VISITS",APCLV)="",APCLCNT=APCLCNT+1
 Q
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
 W !!,"This report will list all visits that are 'orphan visits'.  You will be asked",!,"to select whether you want orpaned lab, pharmacy or radiology visits."
 W !,"If you select lab, you will get all visits with no primary provider or",!,"pov entered that have a lab entry attached to them.  The same is true for",!,"pharmacy or radiology.",!
 W !!,"If a visit has both a V LAB and a V RADIOLOGY the visit would be included",!,"in each report.",!!
 Q
O ;one location
 S DIC="^AUTTLOC(",DIC(0)="AEMQ",DIC("A")="Which LOCATION: " D ^DIC K DIC
 I Y=-1 S APCLQ="" Q
 S APCLLOCT("ONE")=+Y
 Q
S ;all communities within APCLSU su
 S DIC="^AUTTSU(",DIC("B")=$$VAL^XBDIQ1(9999999.06,DUZ(2),.05),DIC(0)="AEMQ",DIC("A")="Which SERVICE UNIT: " D ^DIC K DIC
 I Y=-1 S APCLQ="" Q
 S APCLLOCT("SU")=+Y
 Q
 ;
PRINT ;EP - called from xbdbque
 K APCLQ S APCLPG=0 D HEADER
 I '$D(^XTMP("APCLOR1",APCLJ,APCLH)) D HEADER W !!,"NO DATA TO REPORT",! G DONE
 W !!,"TOTAL NUMBER OF VISITS FOUND: ",APCLCNT,!!
 S APCLV=0 F  S APCLV=$O(^XTMP("APCLOR1",APCLJ,APCLH,"VISITS",APCLV)) Q:APCLV'=+APCLV!($D(APCLQ))  D
 .I $Y>(IOSL-3) D HEADER Q:$D(APCLQ)
 .S APCLVREC=^AUPNVSIT(APCLV,0)
 .W !,$$HRN^AUPNPAT($P(APCLVREC,U,5),DUZ(2),2),?12,$E($P(^DPT($P(APCLVREC,U,5),0),U),1,20),?35,$$FMTE^XLFDT($P($P(APCLVREC,U),"."))
 .W ?48,$P($$FMTE^XLFDT($P(APCLVREC,U),"2P")," ",2),?55,$P(APCLVREC,U,7),?59,$P(APCLVREC,U,3),?62,$P(^AUTTLOC($P(APCLVREC,U,6),0),U,7),?68,$$NLAB(APCLV),?73,$$NRX(APCLV),?77,$$NRAD(APCLV)
DONE ;
 I $E(IOST)="C",IO=IO(0) S DIR(0)="EO",DIR("A")="End of report.  PRESS ENTER" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 W:$D(IOF) @IOF
 K APCLTS,APCLS,APCLM,APCLET
 K ^XTMP("APCLOR1",APCLJ,APCLH),APCLJ,APCLH
 Q
 ;
NLAB(V) ;
 NEW X,C
 S (X,C)=0 F  S X=$O(^AUPNVLAB("AD",V,X)) Q:X'=+X  S C=C+1
 Q C
NRX(V) ;
 NEW X,C
 S (X,C)=0 F  S X=$O(^AUPNVMED("AD",V,X)) Q:X'=+X  S C=C+1
 Q C
NRAD(V) ;
 NEW X,C
 S (X,C)=0 F  S X=$O(^AUPNVRAD("AD",V,X)) Q:X'=+X  S C=C+1
 Q C
HEADER ;EP
 G:'APCLPG HEADER1
 K DIR I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCLQ="" Q
HEADER1 ;
 W:$D(IOF) @IOF S APCLPG=APCLPG+1
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",APCLPG,!
 W !,$$CTR("INCOMPLETE "_APCLRTYE_" VISITS",80),!
 S X="Visit Dates: "_$$FMTE^XLFDT(APCLBD)_" to "_$$FMTE^XLFDT(APCLED) W $$CTR(X,80),!
 W !?68,"#",?72,"#",?76,"#"
 W !,"HRN",?12,"PATIENT NAME",?37,"DATE",?48,"TIME",?54,"SC",?57,"TYPE",?62,"LOC",?67,"LAB",?71,"RX",?75,"RAD"
 W !,$TR($J("",80)," ","-")
 Q
