APCDRDEM ; IHS/CMI/LAB - report of visits re-linked ;
 ;;2.0;IHS PCC SUITE;**5**;MAY 14, 2009
 ;
 ;
START ;EP - called from option
 D XIT
 W:$D(IOF) @IOF
 W !!,"This option will print a list of visits that were merged into another visit,"
 W !,"or that were deleted.  If a reason for the deletion/merge can be determined "
 W !,"it will be displayed.",!
 ;
TYPE ;
 S APCDTYPE=""
 S DIR(0)="S^1:Deleted/Merged Visits by Visit Date Range;2:Deleted/Merged Visits by Date Visit Deleted/Merged",DIR("A")="Which set of Visits",DIR("B")="1" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D XIT Q
 S APCDTYPE=$E(Y)
GETDATES ;
 W !!,"Please enter the range of dates on which the deletion/merge occurred."
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
 W !! S XBRP="PRINT^APCDRDEM",XBRC="PROC^APCDRDEM",XBNS="APCD*",XBRX="XIT^APCDRDEM"
 D ^XBDBQUE
 D XIT
 Q
BROWSE ;
 S XBRP="VIEWR^XBLM(""PRINT^APCDRDEM"")"
 S XBNS="APCD",XBRC="PROC^APCDRDEM",XBRX="XIT^APCDRDEM",XBIOP=0 D ^XBDBQUE
 Q
 ;
PROC ;EP - called from xbdbque
 ;loop through all visits in date range and look for problem 8-8.9 or visit type of N
 S APCDJOB=$J,APCDTOT=0,APCDBT=$H
 S APCDXREF=$S(APCDTYPE=1:"AD",1:"AC")
 D XTMP("APCDRDEM","VISIT MERGE/DELETION LIST")
 S X1=APCDBD,X2=-1 D C^%DTC S APCDSD=X
 S APCDODAT=APCDSD_".9999" F  S APCDODAT=$O(^APCDVDEL(APCDXREF,APCDODAT)) Q:APCDODAT=""!((APCDODAT\1)>APCDED)  D
 .S APCDR=0 F  S APCDR=$O(^APCDVDEL(APCDXREF,APCDODAT,APCDR)) Q:APCDR'=+APCDR  D
 ..S F=$P(^APCDVDEL(APCDR,0),U) Q:$$DEMO^APCLUTL($P(^AUPNVSIT(F,0),U,5),APCDDEMO)
 ..S ^XTMP("APCDRDEM",APCDJOB,APCDBT,"VISITS",APCDODAT,APCDR)="",APCDTOT=APCDTOT+1
 Q
PRINT ;EP - called from xbdbque
 K APCDQ S APCDPG=0
 I '$D(^XTMP("APCDRDEM",APCDJOB,APCDBT,"VISITS")) D HEADER W !!,"There are no visits in the Visit Delete/Merge Log for that time period.",! Q
 D HEADER
 S APCDD=0 F  S APCDD=$O(^XTMP("APCDRDEM",APCDJOB,APCDBT,"VISITS",APCDD)) Q:APCDD=""!($D(APCDQ))  D
 .;I $Y>(IOSL-5) D HEADER Q:$D(APCDQ)
 .;W !!,"Date Deleted/Merged: ",$$FMTE^XLFDT(APCDD)
 .S APCDR=0 F  S APCDR=$O(^XTMP("APCDRDEM",APCDJOB,APCDBT,"VISITS",APCDD,APCDR)) Q:APCDR'=+APCDR!($D(APCDQ))  D
 ..I $Y>(IOSL-4) D HEADER Q:$D(APCDQ)
 ..S APCDN=^APCDVDEL(APCDR,0)
 ..S APCDFV=$P(APCDN,U)
 ..S APCDTV=$P(APCDN,U,4)
 ..S DFN=$P($G(^AUPNVSIT(APCDFV,0)),U,5)
 ..W !!,$$HRN^AUPNPAT(DFN,DUZ(2)),?7,$E($P(^DPT(DFN,0),U),1,18),?25,$$FMTE^XLFDT($P(^AUPNVSIT(APCDFV,0),U),2)," (",APCDFV,")" I APCDTV W ?53,$$FMTE^XLFDT($P(^AUPNVSIT(APCDTV,0),U),2)," (",APCDTV,")"
 ..W !?3,"User who Updated: ",$E($$VAL^XBDIQ1(9001003.92,APCDR,.05),1,18),"  Date/Time Deleted: ",$$FMTE^XLFDT($P(^APCDVDEL(APCDR,0),U,2))
 ..W !?3,"Reason for deletion/merge: ",$P($G(^AUPNVSIT(APCDFV,22)),U,1)
 W !!,"Total # of Visits: ",APCDTOT,!
 K ^XTMP("APCDRDEM",APCDJOB,APCDBT)
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
 S APCDTEXT="DELETED/MERGED VISITS"
 W !?(80-$L(APCDTEXT)/2),APCDTEXT,!
 S APCDTEXT="Deletion/Merge Dates:  "_APCDBDD_" and "_APCDEDD
 W ?(80-$L(APCDTEXT)/2),APCDTEXT,!
 W $TR($J(" ",80)," ","-")
 W !,?25,"DELETED/MERGED VISIT",?53,"MERGED TO VISIT"
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
 W !!,"Purge Data from Visit Delete/Merge Log!"
 S APCDCNT=0
 K APCDQUIT
 Q
 ;
GETDATE ;
 S Y=DT X ^DD("DD") S APCDDTP=Y
 S %DT("A")="Purge data up to and including what DELETE/MERGE DATE?  ",%DT="AEPX" W ! D ^%DT
 I Y=-1 S APCDQUIT="" Q
 S APCDPGE=Y X ^DD("DD") S APCDPGEY=Y
 Q
 ;
PURGE ;
 S APCDX=0 F  S APCDX=$O(^APCDVDEL("AC",APCDX)) Q:APCDX=""!($P(APCDX,".")>APCDPGE)  D
 .S APCDY=0 F  S APCDY=$O(^APCDVDEL("AC",APCDX,APCDY)) Q:APCDY'=+APCDY  D
 ..S DA=APCDY,DIK="^APCDVDEL(" D ^DIK S APCDCNT=APCDCNT+1
 Q
 ;
 ;
TSKMN ;
 K ZTSAVE F %="APCDPGE","APCDCNT" S ZTSAVE(%)=""
 S ZTIO=ION,ZTCPU=$G(IOCPU),ZTRTN="DRIVER^APCDRDEM",ZTDTH="",ZTDESC="PURGE VISIT DELETE/MERGE FILE" D ^%ZTLOAD
 Q
EOJ ;
 K APCDCNT,APCDPGE,X,Y,DIC,DA,DIE,DR,%DT,D,D0,D1,DQ,APCDDTP,APCDPGEY,POP,APCDX,APCDDUZ,APCDY
 I $D(ZTQUEUED) S ZTREQ="@" K ZTSK
 D ^%ZISC
 Q
