APCDRLR ; IHS/CMI/LAB - report of visits re-linked ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;
START ;EP - called from option
 D XIT
 W:$D(IOF) @IOF
 W !!,"This option will print a list of visits on which a V File (ancillary"
 W !,"data item was 'moved' or 're-linked' from one visit to another during the"
 W !,"nightly visit re-linker process or during the post data entry visit re-linking"
 W !,"process.",!
 W !,"You will be asked to enter the date range on which the nightly"
 W !,"visit re-linker was run.",!
 ;
GETDATES ;
 W !!,"Please enter the range of dates on which the 're-linking' occurred."
BD ;get beginning date
 W ! S DIR(0)="D^:DT:EP",DIR("A")="Enter beginning Date" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G XIT
 S APCDBD=Y
ED ;get ending date
 W ! S DIR(0)="D^"_APCDBD_":DT:EP",DIR("A")="Enter ending Date" S Y=APCDBD D DD^%DT D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 S APCDED=Y
 S X1=APCDBD,X2=-1 D C^%DTC S APCDSD=X S Y=APCDBD D DD^%DT S APCDBDD=Y S Y=APCDED D DD^%DT S APCDEDD=Y
DEMO ;
 D DEMOCHK^APCLUTL(.APCDDEMO)
 I APCDDEMO=-1 G BD
ZIS ;
 S DIR(0)="S^P:PRINT Output;B:BROWSE Output on Screen",DIR("A")="Do you wish to ",DIR("B")="P" K DA D ^DIR K DIR
 I $D(DIRUT) G XIT
 I $G(Y)="B" D BROWSE,XIT Q
 W !! S XBRP="PRINT^APCDRLR",XBRC="PROC^APCDRLR",XBNS="APCD*",XBRX="XIT^APCDRLR"
 D ^XBDBQUE
 D XIT
 Q
BROWSE ;
 S XBRP="VIEWR^XBLM(""PRINT^APCDRLR"")"
 S XBNS="APCD",XBRC="PROC^APCDRLR",XBRX="XIT^APCDRLR",XBIOP=0 D ^XBDBQUE
 Q
 ;
PROC ;EP - called from xbdbque
 ;loop through all visits in date range and look for problem 8-8.9 or visit type of N
 S APCDJOB=$J,APCDTOT=0,APCDBT=$H
 D XTMP("APCDRLR","LIST FROM VISIT RELINKER")
 S X1=APCDBD,X2=-1 D C^%DTC S APCDSD=X
 S APCDODAT=APCDSD_".9999" F  S APCDODAT=$O(^APCDKLOG("B",APCDODAT)) Q:APCDODAT=""!((APCDODAT\1)>APCDED)  D
 .S APCDR=0 F  S APCDR=$O(^APCDKLOG("B",APCDODAT,APCDR)) Q:APCDR'=+APCDR  D
 ..S F=$P(^APCDKLOG(APCDR,0),U,5) I F,$D(^AUPNVSIT(F,0)) Q:$$DEMO^APCLUTL($P(^AUPNVSIT(F,0),U,5),APCDDEMO)
 ..S ^XTMP("APCDRLR",APCDJOB,APCDBT,"VISITS",APCDODAT,APCDR)="",APCDTOT=APCDTOT+1
 Q
PRINT ;EP - called from xbdbque
 K APCDQ S APCDPG=0
 I '$D(^XTMP("APCDRLR",APCDJOB,APCDBT,"VISITS")) D HEADER W !!,"There are no visits in the Visit Relinker Log for that time period.",! Q
 D HEADER
 S APCDD=0 F  S APCDD=$O(^XTMP("APCDRLR",APCDJOB,APCDBT,"VISITS",APCDD)) Q:APCDD=""!($D(APCDQ))  D
 .I $Y>(IOSL-5) D HEADER Q:$D(APCDQ)
 .W !!,"Date of Visit Relinker: ",$$FMTE^XLFDT(APCDD)
 .S APCDR=0 F  S APCDR=$O(^XTMP("APCDRLR",APCDJOB,APCDBT,"VISITS",APCDD,APCDR)) Q:APCDR'=+APCDR!($D(APCDQ))  D
 ..I $Y>(IOSL-5) D HEADER Q:$D(APCDQ)
 ..S APCDN=^APCDKLOG(APCDR,0)
 ..S APCDTV=$P(APCDN,U,5)
 ..S DFN=$P($G(^AUPNVSIT(APCDTV,0)),U,5)
 ..W !!,$$HRN^AUPNPAT(DFN,DUZ(2)),?7,$E($P(^DPT(DFN,0),U),1,18),?25,$$FMTE^XLFDT($P(^AUPNVSIT(APCDTV,0),U),2)," (",APCDTV,")",?53,$$FMTE^XLFDT($P(^AUPNVSIT($P(APCDN,U,4),0),U),2)," (",$P(APCDN,U,4),")"
 ..W !?1,"Providers-To Visit: "
 ..S APCDX=0,APCDP="" F  S APCDX=$O(^AUPNVPRV("AD",APCDTV,APCDX)) Q:APCDX'=+APCDX!($D(APCDQ))  D
 ...S APCDPRV=$P($G(^AUPNVPRV(APCDX,0)),U)
 ...I APCDPRV="" Q  ;no provider?
 ...S:APCDP]"" APCDP=APCDP_"; "
 ...S APCDP=APCDP_$E($P(^VA(200,APCDPRV,0),U,1),1,12)
 ..W APCDP
 ..W !?1,"Data re-linked: "
 ..K APCDA S APCDX=0 F  S APCDX=$O(^APCDKLOG(APCDR,11,APCDX)) Q:APCDX'=+APCDX  D
 ...S F=$P(^APCDKLOG(APCDR,11,APCDX,0),U),B=$P(^DIC(F,0),U)
 ...S I=$P(^APCDKLOG(APCDR,11,APCDX,0),U,2)
 ...S P=$$VAL^XBDIQ1(F,I,1202) I P="" S P="UNKNOWN OR MISSING"
 ...S APCDA(B,P)=$G(APCDA(B,P))+1
 ..S APCDX="",APCDC=0 F  S APCDX=$O(APCDA(APCDX)) Q:APCDX=""!($D(APCDQ))  D
 ...S APCDP="" F  S APCDP=$O(APCDA(APCDX,APCDP)) Q:APCDP=""!($D(APCDQ))  D
 ....I $Y>(IOSL-4) D HEADER Q:$D(APCDQ)
 ....W:APCDC>0 ! W ?17,$E(APCDX,1,12),?31,"Ordering Prv: ",$E(APCDP,1,25),?75,"# ",APCDA(APCDX,APCDP)
 ....S APCDC=APCDC+1
 W !!,"Total # of Visits: ",APCDTOT,!
 K ^XTMP("APCDRLR",APCDJOB,APCDBT)
XIT ;
 D EN^XBVK("APCD")
 D KILL^AUPNPAT
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
HEADER ;EP
 I 'APCDPG G HEADER1
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCDQ="" Q
HEADER1 ;
 W:$D(IOF) @IOF S APCDPG=APCDPG+1
 W !?13,"********** CONFIDENTIAL PATIENT INFORMATION **********"
 W !?(80-$L($P(^DIC(4,DUZ(2),0),U))/2),$P(^DIC(4,DUZ(2),0),U),?($S(80=132:120,1:72)),"Page ",APCDPG,!
 S APCDTEXT="Visits for which an Ancillary Data Item was 're-linked' to another visit"
 W !?(80-$L(APCDTEXT)/2),APCDTEXT,!
 S APCDTEXT="Relinking Dates:  "_APCDBDD_" and "_APCDEDD
 W ?(80-$L(APCDTEXT)/2),APCDTEXT,!
 W $TR($J(" ",80)," ","-")
 W !,?25,"TO VISIT",?53,"FROM VISIT"
 W !,"HRN",?7,"PATIENT",?25,"DATE/TIME (IEN)",?53,"DATE/TIME (IEN)"
 W !,$TR($J(" ",80)," ","-")
 Q
DATE(D) ;EP
 I D="" Q ""
 Q $E(D,4,5)_"/"_$E(D,6,7)_"/"_$E(D,2,3)
 ;
XTMP(N,D) ;EP - set xtmp 0 node
 Q:$G(N)=""
 S ^XTMP(N,0)=$$FMADD^XLFDT(DT,14)_"^"_DT_"^"_$G(D)
 Q
 ;
 ;
PURGERL ;EP - CALLED FROM OPTION
 D INIT
 D GETDATE
 I $D(APCDQUIT) D EOJ Q
ZIS1 W !! S %ZIS="PQ" D ^%ZIS
 I POP D EOJ Q
 I $D(IO("Q")) D TSKMN,EOJ Q
DRIVER ;
 D PURGE
 W !!,"A Total of ",APCDCNT," Entries Purged.",!
 D EOJ
 Q
 ;
INIT ;
 W !!,"Purge Data from Visit Relinker Log!"
 S APCDCNT=0
 K APCDQUIT
 Q
 ;
GETDATE ;
 S Y=DT X ^DD("DD") S APCDDTP=Y
 S %DT("A")="Purge data up to and including what RELINKER RUN DATE?  ",%DT="AEPX" W ! D ^%DT
 I Y=-1 S APCDQUIT="" Q
 S APCDPGE=Y X ^DD("DD") S APCDPGEY=Y
 Q
 ;
PURGE ;
 S APCDX=0 F  S APCDX=$O(^APCDKLOG("B",APCDX)) Q:APCDX=""!(APCDX>APCDPGE)  D
 .S APCDY=0 F  S APCDY=$O(^APCDKLOG("B",APCDX,APCDY)) Q:APCDY'=+APCDY  D
 ..S DA=APCDY,DIK="^APCDKLOG(" D ^DIK S APCDCNT=APCDCNT+1
 Q
 ;
 ;
TSKMN ;
 K ZTSAVE F %="APCDPGE","APCDCNT" S ZTSAVE(%)=""
 S ZTIO=ION,ZTCPU=$G(IOCPU),ZTRTN="DRIVER^APCDRLR",ZTDTH="",ZTDESC="PURGE DATA RELINKER LOG FILE" D ^%ZTLOAD
 Q
EOJ ;
 K APCDCNT,APCDPGE,X,Y,DIC,DA,DIE,DR,%DT,D,D0,D1,DQ,APCDDTP,APCDPGEY,POP,APCDX,APCDDUZ,APCDY
 I $D(ZTQUEUED) S ZTREQ="@" K ZTSK
 D ^%ZISC
 Q
