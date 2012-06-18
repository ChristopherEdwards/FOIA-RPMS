APCDDVL1 ; IHS/CMI/LAB - report on checked in visits with no pov ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;
START ;
 D EOJ
 D INFORM
GETDATES ;
BD ;get beginning date
 W ! S DIR(0)="D^:DT:EP",DIR("A")="Enter beginning Visit Date" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G EOJ
 S APCDBD=Y
ED ;get ending date
 W ! S DIR(0)="DA^"_APCDBD_":DT:EP",DIR("A")="Enter ending Visit Date:  " S Y=APCDBD D DD^%DT S Y="" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 S APCDED=Y
 ;
WHICH ;
 K APCDHLOC
 K DIR
 S DIR(0)="S^A:ALL Visits;H:Visits to Selected Hospital Locations (Scheduling Clinics)"
 S DIR("A")="Which Visits do you want to display",DIR("B")="A" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G BD
 I Y="A" K APCDHLOC G SORT
HLOC ;
 S DIC="^SC(",DIC(0)="AEMQ",DIC("A")="Which HOSPITAL LOCATION: " D ^DIC K DIC
 I X="" W:'$D(APCDHLOC) !!,"No Hospital Locations selected, all will be included." G SORT
 I Y=-1 W:'$D(APCDHLOC) !!,"No Hospital Locations selected, all will be included." G SORT
 S APCDHLOC(+Y)=""
 G HLOC
SORT ;
 S APCDCSRT=""
 W !!,"*** NOTE:  If you pick Visit date order the report will be sorted by Visit date",!,"and sub-sorted by clinic code.  All others will be sub-sorted by visit date."
 S DIR(0)="S^T:Terminal Digit Order;H:Health Record Number Order;D:Visit Date Order;C:Clinic Code Order",DIR("A")="Sort the report by",DIR("B")="T" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 S APCDCSRT=Y
DEMO ;
 D DEMOCHK^APCLUTL(.APCDDEMO)
 I APCDDEMO=-1 G BD
ZIS ;call to XBDBQUE
 S XBRP="PRINT^APCDDVL1",XBRC="PROCESS^APCDDVL1",XBRX="EOJ^APCDDVL1",XBNS="APCD"
 D ^XBDBQUE
 D EOJ
 Q
 ;
EOJ ;
 D EN^XBVK("APCD")
 Q
PROCESS ;EP - called from XBDBQUE
 S ^XTMP("APCDDVL1",0)=$$FMADD^XLFDT(DT,14)_"^"_DT_"^"_"APCD - CHECKED IN VISIT REPORT"
 S APCDJ=$J,APCDBT=$H,APCDTOT=0
 ;go through all visits (B index) check for option used to create
 ;and check for no POV 
 ;print name, hrn, date/time, clinic, primary prov, and any other visits on that day
 ;
 S APCDT=APCDBD-.0001,APCDEND=APCDED+.2400
 F  S APCDT=$O(^AUPNVSIT("B",APCDT)) Q:'APCDT!(APCDT>APCDEND)  D
 . S APCDV=0
 . F  S APCDV=$O(^AUPNVSIT("B",APCDT,APCDV)) Q:'APCDV  D
 .. I $$VAL^XBDIQ1(9000010,APCDV,.24)'="SD IHS PCC LINK" Q  ;not created by check in
 .. Q:$$DEMO^APCLUTL($P(^AUPNVSIT(APCDV,0),U,5),APCDDEMO)
 .. I $P(^AUPNVSIT(APCDV,0),U,6)'=DUZ(2) Q  ;another facilities visit
 .. Q:$D(^AUPNVPOV("AD",APCDV))  ;already been coded
 .. Q:$P(^AUPNVSIT(APCDV,0),U,11)  ;deleted
 .. I $D(APCDHLOC) S X=$P(^AUPNVSIT(APCDV,0),U,22) Q:X=""  Q:'$D(APCDHLOC(X))
 .. S APCDSORT="" D GETSORT I APCDSORT="" S APCDSORT="??"
 .. S ^XTMP("APCDDVL1",APCDJ,APCDBT,"VISITS",APCDSORT,APCDSSRT,APCDV)="",APCDTOT=APCDTOT+1
 .. Q
 . Q
 Q
GETSORT ;get sort value
 I APCDCSRT="D" S APCDSORT=$P($P(^AUPNVSIT(APCDV,0),U),"."),APCDSSRT=$$CLINIC^APCLV(APCDV,"C") S:APCDSSRT="" APCDSSRT="??" Q
 I APCDCSRT="C" S APCDSORT=$$CLINIC^APCLV(APCDV,"C"),APCDSSRT=$P($P(^AUPNVSIT(APCDV,0),U),".") Q  ;clinic code
 ;hrn sort values
 S APCDSORT=$$HRN^AUPNPAT($P(^AUPNVSIT(APCDV,0),U,5),DUZ(2)),APCDSSRT=$P($P(^AUPNVSIT(APCDV,0),U),".") S:APCDSORT="" APCDSORT="?????"
 Q:APCDSORT="?????"
 Q:APCDCSRT'="T"
 S APCDSORT=APCDSORT+10000000,APCDSORT=$E(APCDSORT,7,8)_"-"_+$E(APCDSORT,2,8)
 Q
PRINT ;EP - called from XBDBQUE
 S APCDQUIT="",APCDPG=0 D HDR
 I '$D(^XTMP("APCDDVL1",APCDJ,APCDBT)) W !!,"NO DATA TO REPORT",! G DONE
 S APCDSORT="" F  S APCDSORT=$O(^XTMP("APCDDVL1",APCDJ,APCDBT,"VISITS",APCDSORT)) Q:APCDSORT=""!(APCDQUIT)  D
 .S APCDSSRT="" F  S APCDSSRT=$O(^XTMP("APCDDVL1",APCDJ,APCDBT,"VISITS",APCDSORT,APCDSSRT)) Q:APCDSSRT=""!(APCDQUIT)  D
 .. S APCDV=0 F  S APCDV=$O(^XTMP("APCDDVL1",APCDJ,APCDBT,"VISITS",APCDSORT,APCDSSRT,APCDV)) Q:APCDV'=+APCDV!(APCDQUIT)  D
 ... I $Y>(IOSL-4) D HDR Q:APCDQUIT
 ... S APCDVR=^AUPNVSIT(APCDV,0)
 ... W !,$E($P(^DPT($P(APCDVR,U,5),0),U),1,15),?16,$$HRN^AUPNPAT($P(APCDVR,U,5),DUZ(2)),?23,$$FMTE^XLFDT($P(APCDVR,U)),?42,$P(APCDVR,U,7),?45,$$CLINIC^APCLV(APCDV,"C")
 ... W ?48,$E($$VAL^XBDIQ1(9000010,APCDV,.22),1,15),?64,$$PRIMPROV^APCLV(APCDV,"P")
 ... S C=$$VCNT(APCDV) W ?72,$P(C,U),"  ",$P(C,U,2)
 ... Q
 .. Q
 . Q
 G:APCDQUIT DONE
 I $Y>(IOSL-3) D HDR G:APCDQUIT DONE
 W !!,"Total Number of Visits:  ",APCDTOT
DONE ;
 K ^XTMP("APCDDVL1",APCDJ,APCDBT),APCDJ,APCDBT
 I $E(IOST)="C",IO=IO(0) S DIR(0)="EO",DIR("A")="End of report.  HIT RETURN" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 W:$D(IOF) @IOF
 Q
VCNT(V) ;return number of other visits on this date
 I '$G(V) Q 0
 I '$D(^AUPNVSIT(V)) Q 0
 NEW D,X,Y,C,DATE,END,P
 S P=$P(^AUPNVSIT(V,0),U,5)
 S D=$P($P(^AUPNVSIT(V,0),U),".")
 S (C,C1)=0,DATE=(9999999-D)-.0001,END=(9999999-D)+.9999999
 F  S DATE=$O(^AUPNVSIT("AA",P,DATE)) Q:'DATE!(DATE>END)  D
 . S X=0 F  S X=$O(^AUPNVSIT("AA",P,DATE,X)) Q:X'=+X  I X'=V,'$P(^AUPNVSIT(X,0),U,11) S C=C+1 I $D(^AUPNVPOV("AD",X)),$D(^AUPNVPRV("AD",X)) S C1=C1+1
 Q C_U_C1
 ;
HDR ;header for report
 I 'APCDPG G HDR1
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCDQUIT=1 Q
HDR1 ;
 W:$D(IOF) @IOF S APCDPG=APCDPG+1
 W $P(^VA(200,DUZ,0),U,2),$$CTR($$FMTE^XLFDT(DT)),?71,"Page ",APCDPG,!
 W $$CTR($$LOC),!
 W $$CTR("CHECKED IN VISITS WITH NO POV (NOT YET CODED)"),!
 NEW % S %="Visit dates: "_$$FMTE^XLFDT(APCDBD)_" to "_$$FMTE^XLFDT(APCDED) W $$CTR(%),! ;CMI/TUCSON added 11/3/98
 W "** Last column is the number of other visits on the same day and the",!," # of those visits that are complete",!!
 W ?3,"PATIENT NAME",?17," HRN",?23,"VISIT DATE&TIME",?42,"SC",?45,"CL",?48,"HOSPITAL LOC",?64,"PROV",?72,"# visits",!
 W $TR($J(" ",80)," ","-"),!
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
INFORM ;let user know what is gong on
 W:$D(IOF) @IOF
 W !!,$$CTR($$LOC,80)
 W !,$$CTR($$USR,80),!!
 F I=1:1 S X=$P($T(INTRO+I),";;",2) Q:X="END"  W !,X
 K I,X
 Q
INTRO ;;
 ;;This report will list all PCC Visits that were created by the
 ;;Scheduling Check-In process that do not yet have a Purpose of Visit.
 ;;This report will be used to determine if PCC forms have been submitted
 ;;for these visits or if an additional visit has been created for this scheduled 
 ;;visit.
 ;;END
