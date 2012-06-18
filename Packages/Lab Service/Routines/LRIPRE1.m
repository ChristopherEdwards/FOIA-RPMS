LRIPRE1 ;SLC/AM/DALISC/FHS - WKLD (CAP) CODE LIST REPORT PRE INSTALL/INIT 5.2 ;1/16/91 15:34 ;
 ;;5.2;LR;;NOV 01, 1997
 ;
 ;;5.2;LAB SERVICE;;Sep 27, 1994
EN ;
 Q:'$D(DIFQ)
 G:$G(LRVR)>5.11 CLEAN
 I $G(^LAB(60,"PREINIT")) W !?10," I see you already have a list of CAP codes ",!,"from LABORATORY TEST file. ",!!,"Would you like another" S %=2 D YN^DICN G PRE:%=2,PRE:%<0 I %=0 D HLP G EN
 W !!?5,"I will produce a list of CAP codes in your file LABORATORY TEST (#60) "
 K %ZIS,^XTMP($J,"CAP") S %ZIS="",%ZIS("A")="Printer Name " D ^%ZIS G:POP PRE U IO
QUE ;
 S (LRNAM,LRTS,LRHED,LRPG)=0 F  S LRNAM=$O(^LAB(60,"B",LRNAM)) Q:LRNAM=""  F LRTS=0:0 S LRTS=$O(^LAB(60,"B",LRNAM,LRTS)) Q:LRTS<.5  D PRNT
 S I=$O(^XTMP($J,"CAP",0)) I $L(I) W @IOF,!!?10,"Alphabetical Listing of All CAP [WKLD] Codes In Use",! S DIC="^LAM(",DR=0,I="" F  S I=$O(^XTMP($J,"CAP",I)) Q:I=""  S DA=^(I) D EN^DIQ
 K ^XTMP($J,"CAP")
 G:'$G(LRVR) CLEAN
 W:IOST["P-" @IOF D ^%ZISC I $D(ZTQUEUED) S ZTREQ="@" Q
PRE G:'$D(LRVR) CLEAN I $G(LRVR)>5.11 G CLEAN
LRO ;
 N LRDD
 W !!?10,"Purging Obsolete CAP CODES from ^LAB(60)",!
 W !?10,"Also checking for broken pointers to ^DD(63.04, ",!
 W ! F I=0:0 S I=$O(^LAB(60,I)) Q:I<1  D
 .  I $D(^LAB(60,I,0))#2,$P(^(0),U,3)="" S $P(^(0),U,3)="N"
 .  K ^LAB(60,I,9),^LAB(60,I,9.1) W:'I#100 "." S LRDD=+$G(^(.2)) I LRDD D
 . .  I '$D(^DD(63.04,LRDD,0))#2 K ^LAB(60,"C","CH;"_LRDD_";1"),^LAB(60,I,.2) I $D(^LAB(60,I,0))#2  W !,"Removing bad Data Name pointer for lab test ",$P(^(0),U) F A=5,12 S $P(^(0),U,A)=""
 . . F J=0:0 S J=$O(^LAB(60,I,3,J)) Q:J<1  S:$D(^(J,0))#2 $P(^(0),U,3)="" K ^LAB(60,I,3,J,9)
LAM W !?10,"Purging the CAP CODE file:",!
 S LRSAVE=$P($G(^LAM(0)),U,1,2),I=0 F  S I=$O(^LAM(I)) Q:I=""  K ^LAM(I) W:'I#100 "."
 S:$L(LRSAVE) ^LAM(0)=LRSAVE I $D(^DD(64,0))#2 S DIU="^LAM(",DIU(0)="T" K LRSAVE D EN^DIU2 K DIU
 W !?25,"^LAM( HAS BEEN PURGED ",!!
 Q
PRNT ;
 I '($D(^LAB(60,LRTS,0))#2) Q
 Q:$P(^LAB(60,LRTS,0),U,3)="N"
 I 'LRHED S LRPG=LRPG+1 W @IOF,!!!,?23,"LIST OF CAP [WKLD] CODES",?65,"Pg ",LRPG,!!,"TEST",?15,"CAP Code",?50,"Cap Number",! S LRHED=1
 S LRJ=$O(^LAB(60,LRTS,9,0)) Q:LRJ=""
 W !,$P(^LAB(60,LRTS,0),U),!
 D:$D(^LAB(60,LRTS,9,LRJ,0))#2 PCC F LRK=0:0 S LRJ=$O(^LAB(60,LRTS,9,LRJ)) Q:LRJ<1  D:$D(^LAB(60,LRTS,9,LRJ,0))#2 PCC
 Q
PCC ;
 S LRX=^LAB(60,LRTS,9,LRJ,0),LRCC=+LRX G ERR:'$D(^LAM(LRCC,0)) S ^XTMP($J,"CAP",$P(^(0),U))=LRCC
 W ?10,$S($D(^LAM(LRCC,0))#2:$P(^LAM(LRCC,0),U,1),1:""),?50,$P(LRX,U,2),?73,$S($P(LRX,U,3)=1:"DEF",1:""),! I $Y>(IOSL-6) S LRHED=0
 Q
HLP W !!,"During the installation process of V5.2, your CAP entries in the Laboratory Test file will be deleted.",!," A record maybe useful when setting up the files for V 5.2 " Q
ERR W !?10,$C(7)," Error in CAP Code pointer "_LRCC,! Q
CLEAN ;I $G(LRVR)>5.11 D ^LRIPRE2
 D ^%ZISC K ^XTMP($J,"CAP"),%ZIS,I,LRCC,LRHED,LRI,LRJ,LRK,LRTS,LRX,ZTSK,%,DIC,DA,DR Q
