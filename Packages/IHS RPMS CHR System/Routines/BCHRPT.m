BCHRPT ; IHS/TUCSON/LAB - APC visit counts by selected vars ;  [ 10/28/96  2:05 PM ]
 ;;1.0;IHS RPMS CHR SYSTEM;;OCT 28, 1996
 ;
START ; 
 D HOME^%ZIS
 K BCHQUIT
 I '$G(DUZ(2)) W $C(7),$C(7),!!,"SITE NOT SET IN DUZ(2) - NOTIFY SITE MANAGER!!",!! Q
 I $D(BCHRPTC) D
 .S BCHRPTI=$P(^BCHRCNT(BCHRPTC,0),U,2),BCHRPTPA=$P(^(0),U,3),BCHRPTP=$P(^(0),U,4),BCHRPTST=$P(^BCHRCNT(BCHRPTC,0),U,7) S:BCHRPTST]"" BCHRPTST=$TR(BCHRPTST,"~","^")
 .S BCHRPRCR=$P(^BCHRCNT(BCHRPTC,0),U,5) S:BCHRPRCR]"" BCHRPRCR=$TR(BCHRPRCR,"~","^")
 I BCHRPTI]"" S BCHRPTI=$TR(BCHRPTI,"~","^") D @(BCHRPTI) ;inform user what report will do
 G:$D(BCHQUIT) XIT
 S BCHTCW=0,BCHPCNT=0
 S BCHPTVS="V",BCHXREF=$S(BCHPTVS="V":"C",1:"PO")
GETDATES ;
BD ;get beginning date
 W ! S DIR(0)="D^:DT:EP",DIR("A")="Enter BEGINNING Date of Service for Report" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G XIT
 S BCHBD=Y
ED ;get ending date
 W ! S DIR(0)="D^"_BCHBD_":DT:EP",DIR("A")="Enter ENDING Date of Service for Report" S Y=BCHBD D DD^%DT S DIR("B")=Y,Y="" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 S BCHED=Y
 S X1=BCHBD,X2=-1 D C^%DTC S BCHSD=X S Y=BCHBD D DD^%DT S BCHBDD=Y S Y=BCHED D DD^%DT S BCHEDD=Y
 D ADD ;add report to temporary fileman report file
 I $D(BCHQUIT) W !!,"Unable to create report temporary file entry!!," G XIT
 ;
 D SHOW
SCREEN ;
 D SMENU^BCHRPT0
 S DIR(0)="LO^1:"_BCHHIGH,DIR("A")="Select records based on which of the above" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" D SHOW G PRINT
 I $D(DIRUT) D DEL G START
 ;process all items in Y
 D SELECT^BCHRPT1
 D SHOW
 W !! S DIR(0)="Y",DIR("A")="     Would you like to select additional RECORD criteria",DIR("B")="NO" D ^DIR S:$D(DUOUT) DIRUT=1 K DIR
 G:$D(DIRUT) START
 I Y=0 K ^BCHTRPT(BCHRPT,12) G PRINT
 G SCREEN
 ;
PRINT ;print portion of report
 I $G(BCHRPTP)]"" S BCHRPTPA=$TR(BCHRPTPA,"~","^"),BCHRPTP=$TR(BCHRPTP,"~","^") D:$G(BCHRPTPA)]"" @(BCHRPTPA) G:$D(BCHQUIT) START G SORT
 D PMENU^BCHRPT0
 S DIR(0)="LO^1:"_BCHHIGH,DIR("A")="Select print item(s)" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" G SORT
 I $D(DIRUT) D DEL G START
 W !!?15,"Total Report width (including column margins - 2 spaces):  ",BCHTCW
 D PSELECT^BCHRPT1
 D SHOWP
 W !! S DIR(0)="Y",DIR("A")="      Would you like to select additional PRINT items",DIR("B")="NO" D ^DIR K DIR
 S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) START
 I Y=0 G SORT
 G PRINT
SORT ;
 I '$D(^BCHTRPT(BCHRPT,12)),'$D(BCHRPTP) W !!,"NO PRINT FIELDS SELECTED!!",$C(7),$C(7) D DEL G START
 I '$P(^BCHRCNT(BCHRPTC,0),U,8) G ZIS
 S BCHSORT=""
 D SHOWR
 D RMENU^BCHRPT0
 W ! S DIR(0)="NO^1:"_BCHHIGH_":0",DIR("A")="Sort records by which of the above" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !!,"No sort criteria selected ... will sort by record date." S BCHSORT=19,BCHSORV="Date of Service" H 3 G ZIS
 I $D(DIRUT) D DEL G START
 S BCHSORT=BCHSEL(+Y),BCHSORV=$P(^BCHSORT(BCHSORT,0),U)
PAGE ;
 K BCHSPAG
 S DIR(0)="Y",DIR("A")="Do you want a separate page for each "_BCHSORV,DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G SORT
 S BCHSPAG=Y
ZIS ;call to XBDBQUE
 D KILLVARS
 S XBRP=BCHRPTP,XBRC=$S($G(BCHRPRCR)]"":BCHRPRCR,1:"^BCHRPT4"),XBRX="XIT^BCHRPT",XBNS="BCH"
 D ^XBDBQUE
 D XIT
 Q
SHOW ;
 W:$D(IOF) @IOF
 I $D(BCHDONE) S BCHLHDR="REPORT SUMMARY" W ?((80-$L(BCHLHDR))/2),BCHLHDR,!
 W !?6,"Record selection criteria:"
 W !,"Date of Service range:  ",BCHBDD," to ",BCHEDD,"."
 Q:'$D(^BCHTRPT(BCHRPT,11))
 S BCHI=0 F  S BCHI=$O(^BCHTRPT(BCHRPT,11,BCHI)) Q:BCHI'=+BCHI  D
 .I $Y>(IOSL-5) D PAUSE^BCHRPTU W @IOF
 .W !?12,$P(^BCHSORT(BCHI,0),U),":  "
 .K BCHQ S Y=0,C=0 F  S Y=$O(^BCHTRPT(BCHRPT,11,BCHI,11,"B",Y)) S C=C+1 W:C'=1&(Y'="") " ; " Q:Y=""!($D(BCHQ))  S X=Y X:$D(^BCHSORT(BCHI,2)) ^(2) D
 ..W X
 .K BCHQ
 K C
 Q
SHOWP ;
 I '$D(BCHDONE) W:$D(IOF) @IOF
 W !!?6,"PRINT Field(s) Selected:"
 ;Q:'$D(^BCHTRPT(BCHRPT,12))
 S (BCHI,BCHTCW)=0 F  S BCHI=$O(^BCHTRPT(BCHRPT,12,BCHI)) Q:BCHI'=+BCHI  S BCHCRIT=$P(^BCHTRPT(BCHRPT,12,BCHI,0),U) D
 .W !?12,$P(^BCHSORT(BCHCRIT,0),U)," - column width ",$P(^BCHTRPT(BCHRPT,12,BCHI,0),U,2) S BCHTCW=BCHTCW+$P(^(0),U,2)+2
 .I $Y>(IOSL-5) D PAUSE^BCHRPTU W:$D(IOF) @IOF
 W !!?12,"Total Report width (including column margins - 2 spaces):   ",BCHTCW
 Q
SHOWR ;
 I '$D(BCHDONE) W:$D(IOF) @IOF
 W !!?6,"Record SORTING Criteria"
 Q:'$G(BCHTRPT)
 W !!?12,"Records will be sorted by:  ",$P(^BCHSORT(BCHTRPT,0),U),!
 Q
DEL ;EP - delete entry in temp file
 I $G(BCHRPT) S DIK="^BCHTRPT(",DA=BCHRPT D ^DIK K DIK,DA,DIC
 Q
KILLVARS ;
 K BCHDISP,BCHSEL
 Q
XIT ;
 D KILL^BCHRPTX
 Q
ADD ;EP
 S %H=$H D YX^%DTC S X=$P(^VA(200,DUZ,0),U)_"-"_Y,DIC(0)="L",DIC="^BCHTRPT(",DLAYGO=90002.42,DIADD=1 D ^DIC K DIC,DA,DR,DIADD,DLAYGO I Y=-1 W !!,"UNABLE TO CREATE REPORT FILE ENTRY - NOTIFY SITE MANAGER!" S BCHQUIT=1 Q
 S BCHRPT=+Y
 K DIC,DIADD,DLAYGO,DR,DA,DD,X,Y,DINUM
 ;DELETE ALL 11 MULTIPLE HERE
 K ^BCHTRPT(BCHRPT,11)
 Q
