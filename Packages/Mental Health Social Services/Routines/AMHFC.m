AMHFC ; IHS/CMI/LAB - COUNT FORMS REPORT ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
START ; 
 S AMHSITE="" S:$D(DUZ(2)) AMHSITE=DUZ(2)
 I '$D(DUZ(2)) W $C(7),$C(7),!!,"SITE NOT SET IN DUZ(2) - NOTIFY SITE MANAGER!!",!! K AMHSITE Q
 I 'DUZ(2) W $C(7),$C(7),!!,"SITE NOT SET IN DUZ(2) - NOTIFY SITE MANAGER",!! K AMHSITE Q
 D INFORM
GETDATES ;
BD ;get beginning date
 W ! S DIR(0)="D^:DT:EP",DIR("A")="Enter beginning Posting Date" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G XIT
 S AMHBD=Y
ED ;get ending date
 W ! S DIR(0)="D^"_AMHBD_":DT:EP",DIR("A")="Enter ending Posting Date" S Y=AMHBD D DD^%DT D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 S AMHED=Y
 S X1=AMHBD,X2=-1 D C^%DTC S AMHSD=X
 ;
DEC ;
 S DIR(0)="Y",DIR("B")="Y",DIR("A")="Report on ALL Operators",DIR("?")="If you wish to include visits entered by ALL Operators answer Yes.  If you wish to tabulate for only one operator enter NO." D ^DIR K DIR
 G:$D(DIRUT) BD
 I Y=1 S AMHDEC="ALL" G ZIS
DEC1 ;enter location
 S DIC("A")="Which Operator: ",DIC="^VA(200,",DIC(0)="AEMQ" D ^DIC K DIC,DA G:Y<0 DEC
 S AMHDEC=+Y
ZIS ;
DEMO ;
 D DEMOCHK^AMHUTIL1(.AMHDEMO)
 I AMHDEMO=-1 G DEC
 W !! S %ZIS="PQM" D ^%ZIS
 I POP G XIT
 I $D(IO("Q")) G TSKMN
DRIVER ; entry point for taskman
 S AMHBT=$H
 S U="^"
 K ^XTMP("AMHFC",$J)
ZTSK ;
 D ^AMHFC1
 S AMHDT=$$FMTE^XLFDT(DT)
 S AMHET=$H
 U IO
 D ^AMHFCP
 S:$D(ZTQUEUED) ZTREQ="@"
 D XIT
 Q
ERR W $C(7),$C(7),!,"Must be a valid date and be Today or earlier. Time not allowed!" Q
TSKMN ;
 S ZTIO=$S($D(ION):ION,1:IO) I $D(IOST)#2,IOST]"" S ZTIO=ZTIO_";"_IOST
 I $G(IO("DOC"))]"" S ZTIO=ZTIO_";"_$G(IO("DOC"))
 I $D(IOM)#2,IOM S ZTIO=ZTIO_";"_IOM I $D(IOSL)#2,IOSL S ZTIO=ZTIO_";"_IOSL
 K ZTSAVE F %="AMHBD","AMHED","AMHSD","AMHBDD","AMHDEC","AMHSITE","AMHSRT","AMHPROC" S ZTSAVE(%)=""
 S ZTCPU=$G(IOCPU),ZTRTN="DRIVER^AMHFC",ZTDTH="",ZTDESC="PCC DE/QA COUNTS" D ^%ZTLOAD D XIT Q
 ;
XIT ;
 D ^%ZISC
 K ^XTMP("AMHFC",$J)
 K DIC,%DT,IO("Q"),X,Y,POP,DIRUT,ZTSK,AMHH,AMHM,AMHS,AMHTS,ZTIO,%ZIS,%,DTOUT,DUOUT,X1,X2
 K AMH1,AMH2,AMH80S,AMHAP,AMHBD,AMHBDD,AMHBT,AMHDATE,AMHDEC,AMHDT,AMHED,AMHEDD,AMHET,AMHGOT,AMHFC,AMHVDES,AMHTDES,AMHDESU,AMHX
 K AMHLENG,AMHODAT,AMHPG,AMHPROC,AMHPROV,AMHSD,AMHSITE,AMHSORT,AMHSRT,AMHSUB,AMHTOT,AMHVSIT,AMHVREC,AMHWDAT,AMHY,AMHC,AMHDFN,AMHAVG,AMHDEC
 Q
 ;
INFORM ;
 W:$D(IOF) @IOF
 W !,"This report will generate a count of forms entered by a particular data entry",!,"operator or for ALL data entry operators for a date range that you specify.",!
 Q
 ;
