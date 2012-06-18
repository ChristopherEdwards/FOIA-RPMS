ABMDTEMR ; IHS/ASDST/DMJ - MERGE EMPLOYER DATA ;
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 S U="^"
SEL W !
 K DUOUT,DTOUT
 K DIC S ABM("MODE")="SEL"
 S ABM("XIT")=0,DIC="^AUTNEMPL(",DIC(0)="QEAM",DIC("A")="Select EMPLOYER (to Search against): " D ^DIC K DIC
 G XIT:X=""!$D(DUOUT)!$D(DTOUT)
 I +Y<1 G SEL
 I '$D(^AUTNEMPL(+Y,0)) W *7 K ^AUTNEMPL("B",$P(Y,U,2),+Y) G SEL
 S ABM("X")=+Y,ABM("X0")=^AUTNEMPL(+Y,0)
 D CHK
 G XIT:ABM("XIT"),SEL
 ;
CHK W !!,"Dup-Check for: ",$P(ABM("X0"),U),!?15,$P(ABM("X0"),U,2)
 I $P(ABM("X0"),U,3)]"",$P(ABM("X0"),U,4)]"" W !?15,$P(ABM("X0"),U,3),", "
 I  W $P(^DIC(5,$P(ABM("X0"),U,4),0),U,2)," ",$P(ABM("X0"),U,5)
 W !,"================================================"
 S DIC="^AUTNEMPL(",DIC(0)="QEAM",DIC("S")="I Y'=ABM(""X"")",DIC("A")="Select (SEARCH) for Duplicate EMPLOYER: " D ^DIC K DIC
 Q:$D(DUOUT)!$D(DTOUT)
 I +Y<1 G CONT
 S ABM("Y")=+Y,ABM("Y0")=^AUTNEMPL(+Y,0)
 W !,"_______________________________________________________________________________"
 W !,"[1]  ",$P(ABM("X0"),U),?39,"| [2]  ",$P(ABM("Y0"),U)
 W !,"     ",$P(ABM("X0"),U,2),?39,"|      ",$P(ABM("Y0"),U,2)
 W ! I $P(ABM("X0"),U,3)]"",$P(ABM("X0"),U,4)]"" W "     ",$P(ABM("X0"),U,3),", "
 I  W $P(^DIC(5,$P(ABM("X0"),U,4),0),U,2)," ",$P(ABM("X0"),U,5)
 W ?39,"|      " I $P(ABM("Y0"),U,3)]"",$P(ABM("Y0"),U,4)]"" W $P(ABM("Y0"),U,3),", ",$P(^DIC(5,$P(ABM("Y0"),U,4),0),U,2)," ",$P(ABM("Y0"),U,5)
 W !,"-------------------------------------------------------------------------------"
 K DUOUT,DTOUT
 W ! K DIR S DIR(0)="Y",DIR("A")="     Are the two Employers duplicates (Y/N)" D ^DIR K DIR
 I $D(DUOUT) G VERF
 I $D(DTOUT) S ABM("XIT")=1 Q
 I Y'=1 G CONT
 W ! K DIR S DIR(0)="SO^1:"_$P(ABM("X0"),U)_";2:"_$P(ABM("Y0"),U),DIR("A")="     Which of the two is most accurate" D ^DIR K DIR
 I $D(DUOUT) G VERF
 I $D(DTOUT) S ABM("XIT")=1 Q
 I Y=1!(Y=2) G MOVE
 ;
CONT W !! K DIR S DIR(0)="Y",DIR("A")="Do you want to dup-check "_$P(ABM("X0"),U)_" any more",DIR("B")="Y" D ^DIR K DIR I Y=1 G CHK
 ;
VERF W !! K DIR S DIR(0)="Y",DIR("A")="Do you wish to continue running this program",DIR("B")="Y" D ^DIR K DIR I Y'=1 S ABM("XIT")=1
 Q
 ;
 ;
MOVE W !,"OK, MERGING.." ; X TO Y
 I Y=1 S ABM=ABM("X"),ABM("X")=ABM("Y"),ABM("Y")=ABM
 D MV2 G VERF
 ;
MV1 ;merge
 M ^AUTNEMPL(ABM("Y"))=^AUTNEMPL(ABM("X"))
 S DA=ABM("Y"),DIK="^AUTNEMPL(" D IX1^DIK
MV2 S DIK="^AUTNEMPL(",DA=ABM("X") D ^DIK
 W !!,"Re-directing Pointers..."
 S DA="" F ABMZ("I")=1:1 S DA=$O(^AUPNPAT("AF",ABM("X"),DA)) Q:'DA  S DIE="^AUPNPAT(",DR=".19////"_ABM("Y") D ^ABMDDIE K DR
 S DA="" F ABMZ("I")=1:1 S DA=$O(^AUPNPAT("AG",ABM("X"),DA)) Q:'DA  S DIE="^AUPNPAT(",DR=".22////"_ABM("Y") D ^ABMDDIE K DR
 S DA="" F ABMZ("I")=1:1 S DA=$O(^AUPN3PPH("AE",ABM("X"),DA)) Q:'DA  S DIE="^AUPNPAT(",DR=".16////"_ABM("Y") D ^ABMDDIE K DR
 Q
 ;
XIT K ABM
 Q
