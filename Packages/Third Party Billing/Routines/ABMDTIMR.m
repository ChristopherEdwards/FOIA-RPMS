ABMDTIMR ; IHS/ASDST/DMJ - INSURER MERGE ; 
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; IHS/SD/SDR - v2.5 p9 - IM17864
 ;   Remove merge changes to 3P Bill file
 ;
SEL W !
 S ABM("MODE")="SEL"
 S ABM("XIT")=0,DIC="^AUTNINS(",DIC(0)="QEAM",DIC("A")="Select INSURER (to Search against): " S DIC("S")="I $D(^(1)),$P(^(1),U,7)'=0,$D(^(2)),""DRN""'[$P(^(2),U)"
 D ^DIC
 I X="" G XIT
 I +Y<1 G SEL
 S ABM("X")=+Y,ABM("X0")=^AUTNINS(+Y,0)
 D CHK
 G XIT:ABM("XIT"),SEL
 ;
CHK W !!,"Dup-Check for: ",$P(ABM("X0"),U),!?15,$P(ABM("X0"),U,2)
 I $P(ABM("X0"),U,3)]"",$P(ABM("X0"),U,4)]"" W !?15,$P(ABM("X0"),U,3),", "
 I  W $P(^DIC(5,$P(ABM("X0"),U,4),0),U,2)," ",$P(ABM("X0"),U,5)
 W !,"================================================"
 S DIC="^AUTNINS(",DIC(0)="QEAM",DIC("S")="I Y'=ABM(""X""),$D(^(1)),$P(^(1),U,7)'=0,$D(^(2)),""DNR""'[$P(^(2),U)",DIC("A")="Select (SEARCH) for Duplicate INSURER: " D ^DIC
 I +Y<1 G CONT
 S ABM("Y")=+Y,ABM("Y0")=^AUTNINS(+Y,0)
 W !,"_______________________________________________________________________________"
 W !,"[1]  ",$P(ABM("X0"),U),?39,"| [2]  ",$P(ABM("Y0"),U)
 W !,"     ",$P(ABM("X0"),U,2),?39,"|      ",$P(ABM("Y0"),U,2)
 W ! I $P(ABM("X0"),U,3)]"",$P(ABM("X0"),U,4)]"" W "     ",$P(ABM("X0"),U,3),", "
 I  W $P(^DIC(5,$P(ABM("X0"),U,4),0),U,2)," ",$P(ABM("X0"),U,5)
 W ?39,"|      " I $P(ABM("Y0"),U,3)]"",$P(ABM("Y0"),U,4)]"" W $P(ABM("Y0"),U,3),", ",$P(^DIC(5,$P(ABM("Y0"),U,4),0),U,2)," ",$P(ABM("Y0"),U,5)
 W !,"-------------------------------------------------------------------------------"
 W ! K DIR S DIR(0)="Y",DIR("A")="     Are the two Insurers duplicates (Y/N)" D ^DIR K DIR I Y'=1 G CONT
 W ! K DIR S DIR(0)="SO^1:"_$P(ABM("X0"),U)_";2:"_$P(ABM("Y0"),U),DIR("A")="     Which of the two is most accurate" D ^DIR K DIR
 I Y=1!(Y=2) G MOVE
 ;
CONT W !! K DIR S DIR(0)="Y",DIR("A")="Do you want to dup-check "_$P(ABM("X0"),U)_" any more",DIR("B")="Y" D ^DIR K DIR I Y=1 S ABM("XIT")=0 Q
 ;
VERF W !! K DIR S DIR(0)="Y",DIR("A")="Do you wish to continue running this program",DIR("B")="Y" D ^DIR K DIR I Y'=1 S ABM("XIT")=1
 Q
 ;
MOVE K ABM("ADD")
 I Y=1 S ABM=ABM("X"),ABM("X")=ABM("Y"),ABM("Y")=ABM
 W !,"OK, MERGING.." D PTR G VERF ;X TO Y
 ;
 I $D(^AUTNINS(ABM("X"),1)),$P(^(1),U)]"",$P(^(1),U,2)]"",$P(^(1),U,3)]"",$P(^(1),U,4)]"",$P(^(1),U,5)]"" G MV1
 I $P(^AUTNINS(ABM("X"),0),U,2)]"",$P(^(0),U,3)]"",$P(^(0),U,4)]"",$P(^(0),U,5)]"" F ABM("I")=1:1:5 S ABM("ADD",ABM("I"))=$P(^(0),U,ABM("I"))
 ;
MV1 ;merge
 M ^AUTNINS(ABM("Y"))=^AUTNINS(ABM("X"))
 I $D(ABM("ADD")) F ABM("I")=1:1:5 Q:'$D(ABM("ADD",ABM("I")))  S $P(^AUTNINS(ABM("Y"),1),U,ABM("I"))=ABM("ADD",ABM("I"))
 S DA=ABM("X"),DIK="^AUTNINS(" D IX1^DIK
 ;
PTR S DIE="^AUTNINS(",DA=ABM("X"),DR=".17////0;.27////"_ABM("Y")_";.41////MERGED TO DFN"_ABM("Y") D ^ABMDDIE K DR
 W !!,"Re-directing Pointers..."
 S DA(1)="" F  S DA(1)=$O(^AUPNPRVT("I",ABM("X"),DA(1))) Q:'DA(1)  D
 .S DA="" F  S DA=$O(^AUPNPRVT("I",ABM("X"),DA(1),DA)) Q:'DA  S DIE="^AUPNPRVT("_DA(1)_",11,",DR=".01///"_ABM("Y") D ^ABMDDIE K DR
 S DA="" F  S DA=$O(^AUPN3PPH("E",ABM("X"),DA)) Q:'DA  S DIE="^AUPN3PPH(",DR=".03////"_ABM("Y") D ^ABMDDIE K DR
 S DA="" F  S DA=$O(^AUTTPIC("C",ABM("X"),DA)) Q:'DA  S DIE="^AUTTPIC(",DR=".02////"_ABM("Y") D ^ABMDDIE K DR
 S DA="" F  S DA=$O(^AUTNEMPL("AI",ABM("X"),DA)) Q:'DA  S DIE="^AUTNEMPL(",DR=".08////"_ABM("Y") D ^ABMDDIE K DR
 S DA="" F  S DA=$O(^ABPVFAC("I",ABM("X"),DA)) Q:'DA  S DIE="^ABPVFAC(",DR="7////"_ABM("Y") D ^ABMDDIE K DR
 S DA(1)="" F  S DA(1)=$O(^ABMDERR("AB",ABM("X"),DA(1))) Q:'DA(1)  D
 .S (DIC,DIK)="^ABMDERR("_DA(1)_",11,",DA=ABM("X") D ^DIK
 .S (DINUM,X)=ABM("Y"),DIC(0)="LE" K DD,D0 D FILE^DICN
 Q
 ;
XIT K ABM
 Q
