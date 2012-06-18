AMHPL2 ; IHS/CMI/LAB - NO DESCRIPTION PROVIDED ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
NO1 ;EP
 W:$D(IOF) @IOF
 W !!,"Adding a Note to the following problem on ",$P($P(^DPT(DFN,0),U),",",2)," ",$P($P(^(0),U),","),"'s Problem List.",!
 S (X,D)=0 F  S X=$O(^TMP($J,"AMHPL","IDX",X)) Q:X'=+X!D  S Y=$O(^TMP($J,"AMHPL","IDX",X,0)) S:Y>AMHPIEN D=1 I ^TMP($J,"AMHPL","IDX",X,Y)=AMHPIEN W !,^TMP($J,"AMHPL",X,0)
 I $O(^AUPNPROB(AMHPIEN,11,0)) D
 .W !!?6,IORVON,"Problem Notes:  ",IORVOFF S L=0 F  S L=$O(^AUPNPROB(AMHPIEN,11,L)) Q:L'=+L  I $O(^AUPNPROB(AMHPIEN,11,L,11,0)) W !?6,$P(^DIC(4,$P(^AUPNPROB(AMHPIEN,11,L,0),U),0),U) D
 ..S X=0 F  S X=$O(^AUPNPROB(AMHPIEN,11,L,11,X)) Q:X'=+X  W !?8,"Note#",$P(^AUPNPROB(AMHPIEN,11,L,11,X,0),U)," ",$$FMTE^XLFDT($P(^(0),U,5),5),?30,$P(^AUPNPROB(AMHPIEN,11,L,11,X,0),U,3)
 W ! S DIR(0)="Y",DIR("A")="Add a new Problem Note for this Problem",DIR("B")="Y" K DA D ^DIR K DIR
 G:$D(DIRUT) NOX
 G:Y=0 NOX
NUM ;
 ;add location multiple if necessary, otherwise get ien in multiple
 S AMHNIEN=$O(^AUPNPROB(AMHPIEN,11,"B",$S($G(AMHLOC):AMHLOC,1:DUZ(2)),0))
 I AMHNIEN="" S DIADD=9000011.11,X="`"_$S($G(AMHLOC):AMHLOC,1:DUZ(2)),DIC="^AUPNPROB("_AMHPIEN_",11,",DA(1)=AMHPIEN,DIC(0)="L",DIC("P")=$P(^DD(9000011,1101,0),U,2) D
 .D ^DIC K DIC,DA,DR,Y,DIADD,X S AMHNIEN=$O(^AUPNPROB(AMHPIEN,11,"B",$S($G(AMHLOC):AMHLOC,1:DUZ(2)),0))
 I AMHNIEN="" W $C(7),$C(7),"ERROR UPDATING NOTE LOCATION MULTIPLE" G NOX
 S (Y,X)=0 F  S Y=$O(^AUPNPROB(AMHPIEN,11,AMHNIEN,11,"B",Y)) S:Y X=Y I 'Y S X=X+1 K Y Q
 S AMHNUM=X
 W !!,"Adding Note #",X
 K DIC S X=AMHNUM,DA(1)=AMHNIEN,DA(2)=AMHPIEN,DIC="^AUPNPROB("_AMHPIEN_",11,"_AMHNIEN_",11,",DIC("P")=$P(^DD(9000011.11,1101,0),U,2),DIC(0)="L" D ^DIC K DA,DR,DIADD,DLAYGO,DD,DO,D0
 I Y=-1 W !!,$C(7),$C(7),"ERROR when updating note number multiple",! G NOX
 S DIE=DIC K DIC W ?8 S DA=+Y,DR=".03;.05////"_$S($G(AMHDATE)]"":$P(AMHDATE,"."),1:DT) D ^DIE K DIE,DR,DA,Y W !!
 D ^XBFMK
 K DIADD
 G NO1
NOX ;
 K Y,AMHPIEN,X,L,AMHNUM,AMHL,DIC,DA,DD,AMHC,AMHN,AMHNIEN,DR,DIADD
 Q
RNO1 ;EP - called from AMHPL1 - remove a note
 W:$D(IOF) @IOF
 K AMHN,AMHL,AMHX,AMHC
 W !!,"Removing a Note from the following problem on ",$P($P(^DPT(DFN,0),U),",",2)," ",$P($P(^(0),U),","),"'s Problem List.",!
 S (X,D)=0 F  S X=$O(^TMP($J,"AMHPL","IDX",X)) Q:X'=+X!D  S Y=$O(^TMP($J,"AMHPL","IDX",X,0)) S:Y>AMHPIEN D=1 I ^TMP($J,"AMHPL","IDX",X,Y)=AMHPIEN W !,^TMP($J,"AMHPL",X,0)
 S AMHC=0 I $O(^AUPNPROB(AMHPIEN,11,0)) D
 .W !!?6,IORVON,"Problem Notes:  ",IORVOFF S (AMHC,AMHL)=0 F  S AMHL=$O(^AUPNPROB(AMHPIEN,11,AMHL)) Q:AMHL'=+AMHL  I $O(^AUPNPROB(AMHPIEN,11,AMHL,11,0)) W !?6,$P(^DIC(4,$P(^AUPNPROB(AMHPIEN,11,AMHL,0),U),0),U) D
 ..S AMHX=0 F  S AMHX=$O(^AUPNPROB(AMHPIEN,11,AMHL,11,AMHX)) Q:AMHX'=+AMHX  D
  ...S AMHC=AMHC+1,AMHN(AMHC)=AMHL_U_AMHX W !?8,AMHC,")  Note#",$P(^AUPNPROB(AMHPIEN,11,AMHL,11,AMHX,0),U)," ",$$FMTE^XLFDT($P(^(0),U,5),5),?30,$P(^AUPNPROB(AMHPIEN,11,AMHL,11,AMHX,0),U,3)
 I AMHC=0 W !?8,"No note on file for this problem" G RNO1X
 W ! K DIR S DIR(0)="N^1:"_AMHC_":",DIR("A")="Remove which one" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) W !,"Okay, bye." G RNO1X
 I 'Y W !,"No Note selected"  G RNO1X
 S AMHY=+Y
RSURE ;
 W !! S DIR(0)="Y",DIR("A")="Are you sure you want to delete this NOTE",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) W !,"okay, not deleted." G RNO1X
 I 'Y W !,"Okay, not deleted." G RNO1X
 S DA(1)=$P(AMHN(AMHY),U),DA(2)=AMHPIEN,DIE="^AUPNPROB("_AMHPIEN_",11,"_$P(AMHN(AMHY),U)_",11,",DIC("P")=$P(^DD(9000011.11,1101,0),U,2)
 S DA=$P(AMHN(AMHY),U,2),DR=".01///@" D ^DIE K DIE,DR,DA,Y W !!
RNO1X ;xit
 K AMHPIEN,AMHL,AMHX,AMHN,AMHY
 Q
MN1 ;EP - called to modify a note
 W:$D(IOF) @IOF
 K AMHN,AMHL,AMHX,AMHC
 W !!,"Editing a Note on the following problem on ",$P($P(^DPT(DFN,0),U),",",2)," ",$P($P(^(0),U),","),"'s Problem List.",!
 S (X,D)=0 F  S X=$O(^TMP($J,"AMHPL","IDX",X)) Q:X'=+X!D  S Y=$O(^TMP($J,"AMHPL","IDX",X,0)) S:Y>AMHPIEN D=1 I ^TMP($J,"AMHPL","IDX",X,Y)=AMHPIEN W !,^TMP($J,"AMHPL",X,0)
 S AMHC=0 I $O(^AUPNPROB(AMHPIEN,11,0)) D
 .W !!?6,IORVON,"Problem Notes:  ",IORVOFF S (AMHC,AMHL)=0 F  S AMHL=$O(^AUPNPROB(AMHPIEN,11,AMHL)) Q:AMHL'=+AMHL  I $O(^AUPNPROB(AMHPIEN,11,AMHL,11,0)) W !?6,$P(^DIC(4,$P(^AUPNPROB(AMHPIEN,11,AMHL,0),U),0),U) D
 ..S AMHX=0 F  S AMHX=$O(^AUPNPROB(AMHPIEN,11,AMHL,11,AMHX)) Q:AMHX'=+AMHX  D
  ...S AMHC=AMHC+1,AMHN(AMHC)=AMHL_U_AMHX W !?8,AMHC,")  Note#",$P(^AUPNPROB(AMHPIEN,11,AMHL,11,AMHX,0),U)," ",$$FMTE^XLFDT($P(^(0),U,5),5),?30,$P(^AUPNPROB(AMHPIEN,11,AMHL,11,AMHX,0),U,3)
 I AMHC=0 W !?8,"No notes on file for this problem" G RNO1X
 W ! K DIR S DIR(0)="N^1:"_AMHC_":",DIR("A")="Edit which one" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) W !,"Okay, bye." G RNO1X
 I 'Y W !,"No Note selected"  G RNO1X
 S AMHY=+Y
MSURE ;
 S DA(1)=$P(AMHN(AMHY),U),DA(2)=AMHPIEN,DIE="^AUPNPROB("_AMHPIEN_",11,"_$P(AMHN(AMHY),U)_",11,",DIC("P")=$P(^DD(9000011.11,1101,0),U,2)
 S DA=$P(AMHN(AMHY),U,2),DR=".01;.03" D ^DIE K DIE,DR,DA,Y W !!
MNO1X ;
 K AMHPIEN,AMHL,AMHX,AMHN,AMHY
 Q
