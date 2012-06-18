ABMDTGMR ; IHS/ASDST/DMJ - MERGE GROUP INSURANCE PLAN DATA ;
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 S U="^"
SEL W !
 K DUOUT,DTOUT
 K DIC S ABM("MODE")="SEL"
 S ABM("XIT")=0,DIC="^AUTNEGRP(",DIC(0)="QEAM",DIC("A")="Select GROUP PLAN (to Search against): " D ^DIC K DIC
 G XIT:X=""!$D(DUOUT)!$D(DTOUT)
 I +Y<1 G SEL
 I '$D(^AUTNEGRP(+Y,0)) W *7 K ^AUTNEGRP("B",$P(Y,U,2),+Y) G SEL
 S ABM("X")=+Y,ABM("X0")=^AUTNEGRP(+Y,0)
 D CHK
 G XIT:ABM("XIT"),SEL
 ;
CHK W !!,"Dup-Check for: ",$P(ABM("X0"),U),!?15,$P(ABM("X0"),U,2)
 W !,"================================================"
 S DIC="^AUTNEGRP(",DIC(0)="QEAM",DIC("S")="I Y'=ABM(""X"")",DIC("A")="Select (SEARCH) for Duplicate GROUP PLAN: " D ^DIC K DIC
 I +Y<1 G CONT
 S ABM("Y")=+Y,ABM("Y0")=^AUTNEGRP(+Y,0)
 W !,"_______________________________________________________________________________"
 W !,"[1]  ",$P(ABM("X0"),U),?39,"| [2]  ",$P(ABM("Y0"),U)
 W !,"     ",$P(ABM("X0"),U,2),?39,"|      ",$P(ABM("Y0"),U,2)
 W !,"-------------------------------------------------------------------------------"
 K DUOUT,DTOUT
 W ! K DIR S DIR(0)="Y",DIR("A")="     Are the two GROUP PLANS duplicates (Y/N)" D ^DIR K DIR I Y'=1 G CONT
 W ! K DIR S DIR(0)="SO^1:"_$P(ABM("X0"),U)_";2:"_$P(ABM("Y0"),U),DIR("A")="     Which of the two is most accurate" D ^DIR K DIR I Y=1!(Y=2) G MOVE
 ;
CONT Q:$D(DUOUT)!$D(DTOUT)
 W !! K DIR S DIR(0)="Y",DIR("A")="Do you want to dup-check "_$P(ABM("X0"),U)_" any more",DIR("B")="Y" D ^DIR K DIR I Y=1 G CHK
 Q:$D(DUOUT)!$D(DTOUT)
 ;
VERF W !! K DIR S DIR(0)="Y",DIR("A")="Do you wish to continue running this program",DIR("B")="Y" D ^DIR K DIR I Y'=1 S ABM("XIT")=1
 Q
 ;
 ;
MOVE ;W !,"OK, MERGING.." ;X TO Y
 I Y=1 S ABM=ABM("X"),ABM("X")=ABM("Y"),ABM("Y")=ABM
 D MV2 G VERF
 ;
MV1 ;merge
 M ^AUTNEGRP(ABM("Y"))=^AUTNEGRP(ABM("X"))
 S DA=ABM("Y"),DIK="^AUTNEGRP(" D IX1^DIK
 ;
MV2 S DIK="^AUTNEGRP(",DA=ABM("X") D ^DIK
 W !!,"Re-directing Pointers..."
 S DA="" F ABMZ("I")=1:1 S DA=$O(^AUPN3PPH("AG",ABM("X"),DA)) Q:'DA  S DIE="^AUPN3PPH(",DR=".06////"_ABM("Y") D ^ABMDDIE K DR
 S DA="" F ABMZ("I")=1:1 S DA=$O(^AUTNEMPL("AG",ABM("X"),DA)) Q:'DA  S DIE="^AUTNEMPL(",DR=".09////"_ABM("Y") D ^ABMDDIE K DR
 Q
 ;
XIT K ABM
 Q
