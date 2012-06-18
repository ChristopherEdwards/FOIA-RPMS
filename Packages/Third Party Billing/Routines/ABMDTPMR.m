ABMDTPMR ; IHS/ASDST/DMJ - MERGE POLICY HOLDER DATA ;
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 S U="^"
SEL W !
 K DIC S ABM("MODE")="SEL"
 S ABM("XIT")=0,DIC="^AUPN3PPH(",DIC(0)="QEAM",DIC("A")="Select POLICY HOLDER (to Search against): " D ^DIC K DIC
 G XIT:X=""
 I +Y<1 G SEL
 I '$D(^AUPN3PPH(+Y,0)) W *7 K ^AUPN3PPH("B",$P(Y,U,2),+Y) G SEL
 S ABM("X")=+Y,ABM("X0")=^AUPN3PPH(+Y,0)
 D CHK
 G XIT:ABM("XIT"),SEL
 ;
CHK W !!,"Dup-Check for: ",$P(ABM("X0"),U),!?15,$P(ABM("X0"),U,2),!?15,$P(ABM("X0"),U,3)
 W !,"================================================"
 S DIC="^AUPN3PPH(",DIC(0)="QEAM",DIC("S")="I Y'=ABM(""X""),$P(^(0),U,3)=$P(ABM(""X0""),U,3)",DIC("A")="Select (SEARCH) for Duplicate POLICY HOLDER: " D ^DIC K DIC
 I +Y<1 G CONT
 S ABM("Y")=+Y,ABM("Y0")=^AUPN3PPH(+Y,0)
 W !,"_______________________________________________________________________________"
 W !,"[1]  ",$P(ABM("X0"),U),?39,"| [2]  ",$P(ABM("Y0"),U)
 W !,"     ",$P(ABM("X0"),U,2),?39,"|      ",$P(ABM("Y0"),U,2)
 W !,"     ",$P(ABM("X0"),U,3),?39,"|      ",$P(ABM("Y0"),U,3)
 W !,"-------------------------------------------------------------------------------"
 W ! K DIR S DIR(0)="Y",DIR("A")="     Are the two POLICY HOLDERS duplicates (Y/N)" D ^DIR K DIR I Y'=1 G CONT
 W ! K DIR S DIR(0)="SO^1:"_$P(ABM("X0"),U)_";2:"_$P(ABM("Y0"),U),DIR("A")="     Which of the two is most accurate" D ^DIR K DIR I Y=1!(Y=2) G MOVE
 ;
CONT W !! K DIR S DIR(0)="Y",DIR("A")="Do you want to dup-check "_$P(ABM("X0"),U)_" any more",DIR("B")="Y" D ^DIR K DIR I Y=1 G CHK
 ;
VERF W !! K DIR S DIR(0)="Y",DIR("A")="Do you wish to continue running this program",DIR("B")="Y" D ^DIR K DIR I Y'=1 S ABM("XIT")=1
 Q
 ;
 ;
MOVE I Y=1 S ABM=ABM("X"),ABM("X")=ABM("Y"),ABM("Y")=ABM
 D MV2 G VERF
 ;
MV1 ;merge
 M ^AUPN3PPH(ABM("Y"))=^AUPN3PPH(ABM("X"))
 S DA=ABM("Y"),DIK="^AUPN3PPH(" D IX1^DIK
 ;
MV2 S DIK="^AUPN3PPH(",DA=ABM("X") D ^DIK
 W !!,"Re-directing Pointers..."
 S DA(1)="" F ABMZ("I")=1:1 S DA(1)=$O(^AUPNPRVT("C",ABM("X"),DA(1))) Q:'DA(1)  D
 .S DA="" F ABMZ("I")=1:1 S DA=$O(^AUPNPRVT("C",ABM("X"),DA(1),DA)) Q:'DA  S DIE="^AUPNPRVT("_DA(1)_",11,",DR=".08////"_ABM("Y") D ^ABMDDIE K DR
 Q
 ;
XIT K ABM
 Q
