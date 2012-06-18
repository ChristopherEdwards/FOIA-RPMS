LRDOWN ;SLC/DG - TOP LEVEL OF DOWNLOAD OPTIONS ;4/4/89  21:37 ;
 ;;V~5.0~;LAB;;02/27/90 17:09
BUILD ;Build a download file for an Instrument
 D INIT G QUIT:Y'>0 S %=($P(LRAUTO(9),"^",5)["N")+1
BU2 ;W !,"Send TRAY/CUP locations" D YN^DICN G QUIT:%<0 I %=0 W !,"If optional for this instrument, should I send the tray,cup locations." G BU2
 S LRFORCE=1,%=$P(LRAUTO(9),"^",6)["N"+1 W !,"QUEUE WORK" D YN^DICN G QUIT:%<0 W ! I %<1 W "Answer YES or NO" G BU2
 I %=1 S ZTRTN="DQB^LRDOWN",ZTIO="",ZTSAVE("LR*")="" D ^%ZTLOAD G QUIT
DQB D BUILD^LRDOWN1 ;Now ready to build file.
 S LRTRAY=LRTRAY1 D @$P(LRAUTO(9),U,3,4) ;Routine from auto instrument file.
 G SE2:'$D(LREND),LAST ;Go send the records
QUIT ;CLEAN UP
 K ^UTILITY($J),LRLL,LRINST,LRAUTO,LRFILE,LRI,LRTRAY,LRCUP,LRAA,LRAD,LRAN,LRTEST,LRECORD,LRFLUID,LRFORCE,LRL,LRPNM,F,I,J,X,X5,LRRTN
 Q
INIT K DIC,ZTSK,LREND S DIC="^LAB(62.4,",DIC(0)="AMEQZ",DIC("S")="I Y<99" D ^DIC K DIC I Y'>0 W !,"TRY LATER" Q
 S LRINST=+Y,LRAUTO=Y(0),LRAUTO(9)=$S($D(^LAB(62.4,LRINST,9)):^(9),1:"") I LRAUTO(9)="" S Y=0 W !,"Sorry I don't know how to build for this Instrument"
 S LRLL=$P(LRAUTO,"^",4) W !,"Working on the download file for instrument ",$P(LRAUTO,"^",1)," from Load list ",$P(^LRO(68.2,LRLL,0),"^",1)
IN2 S X=1 ;W !,"Starting Tray number: 1//" R X:DTIME Q:X["^"  I X["?" W !," Enter a tray to start the build and sending at." G IN2
 S LRTRAY1=$S(X="":1,1:+X)
 Q
PURGE ;Remove the download records from the Load List file, Should be removed when sent.
 D INIT G QUIT:Y'>0 S %=2 W !,"Is this OK" D YN^DICN G QUIT:%'=1
 F T=0:0 S T=$O(^LRO(68.2,LRLL,1,T)) Q:T'>0  F C=0:0 S C=$O(^LRO(68.2,LRLL,1,T,1,C)) Q:C'>0  K ^LRO(68.2,LRLL,1,T,1,C,2)
 K T,C W !,"DONE" G QUIT
 ;
SEND D INIT G QUIT:Y'>0
SE2 K LRFILE W:'$D(ZTSK) !,"Now setting up to send."
 S TSK=LRINST,LRRTN=$P(LRAUTO(9),"^",1,2),LRFILE=$P(^LRO(68.2,LRLL,0),"^",1),T=TSK D SET^LAB
 D @("START^"_$P(LRRTN,"^",2)) ;Set-up call
 F LRTRAY=LRTRAY1:0 D:$D(^LRO(68.2,LRLL,1,LRTRAY)) TRAY S LRTRAY=$O(^LRO(68.2,LRLL,1,LRTRAY)) Q:LRTRAY'>0
SE3 D @("END^"_$P(LRRTN,"^",2)) ;Clean-up call
LAST W:'$D(ZTSK) !,"DONE. Data should start moving now" G QUIT
NEW ;Start a new file for each tray.
 D @("NEXT^"_$P(LRRTN,"^",2)) Q
TRAY S LRNEW=1 Q:LRTRAY'>0  F LRCUP=0:0 S LRCUP=$O(^LRO(68.2,LRLL,1,LRTRAY,1,LRCUP)) Q:LRCUP'>0  D NEW:LRNEW S LRNEW=0 I $D(^LRO(68.2,LRLL,1,LRTRAY,1,LRCUP,2)) S X=^(2) D @LRRTN
