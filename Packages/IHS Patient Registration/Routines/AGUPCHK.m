AGUPCHK ; IHS/ASDS/EFG - Merge Insurer Data ; 
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 ;
 S U="^"
 D HD
 W !!,"This routine will loop the old or unverified Insurers allowing you to check",!,"for a potential duplicate."
 W !!," - If you indicate that an insurer is duplicate that the data for the  ",!,"   duplicate insurer will be merged into the old insurer (previous address",!,"   information will be transfered to the billing address fields)."
 W !! K DIR S DIR(0)="Y",DIR("A")="Do you wish to run this program",DIR("B")="Y" D ^DIR K DIR I Y'=1 G XIT
 S AG("MODE")="AUTO"
TEMP S (AG("Y"),AG("XIT"))=0 F AGZ("I")=1:1 S AG("Y")=$O(^AUTNINS(AG("Y"))) Q:'+AG("Y")  I $P($G(^AUTNINS(AG("Y"),1)),U,7)=""!($P($G(^(1)),U,7)=3) S AG("X0")=^(0) D CHK Q:AG("XIT")
 G XIT
SEL D HD W !
 S AG("MODE")="SEL"
 S AG("XIT")=0,DIC="^AUTNINS(",DIC(0)="QEAM",DIC("A")="Select INSURER (to Search against): " S DIC("S")="I $P($G(^(1)),U,7)'=0,""DR""'[$P($G(^(2)),U)"
 D ^DIC
 I X="" G XIT
 I +Y<1 G SEL
 S AG("Y")=+Y,AG("X0")=^AUTNINS(+Y,0)
 D CHK
 G XIT:AG("XIT"),SEL
CHK W !!,"Dup-Check for: ",$P(AG("X0"),U),!?15,$P(AG("X0"),U,2)
 I $P(AG("X0"),U,3)]"",$P(AG("X0"),U,4)]"" W !?15,$P(AG("X0"),U,3),", "
 I  W $P(^DIC(5,$P(AG("X0"),U,4),0),U,2)," ",$P(AG("X0"),U,5)
 W !,"================================================"
 S DIC="^AUTNINS(",DIC(0)="QEAM",DIC("S")="I Y'=AG(""Y""),$P($G(^(1)),U,7)'=0,""DR""'[$P($G(^(2)),U)",DIC("A")="Select (SEARCH) for Duplicate INSURER: " D ^DIC
 I +Y<1 G CONT
 S AG=+Y,AG("Y0")=^AUTNINS(+Y,0)
 W !,"_______________________________________________________________________________"
 W !,"[1]  ",$P(AG("X0"),U),?39,"| [2]  ",$P(Y,U,2)
 W !,"     ",$P(AG("X0"),U,2),?39,"|      ",$P(AG("Y0"),U,2)
 W ! I $P(AG("X0"),U,3)]"",$P(AG("X0"),U,4)]"" W "     ",$P(AG("X0"),U,3),", "
 I  W $P(^DIC(5,$P(AG("X0"),U,4),0),U,2)," ",$P(AG("X0"),U,5)
 W ?39,"|      " I $P(AG("Y0"),U,3)]"",$P(^(0),U,4)]"" W $P(^(0),U,3),", ",$P(^DIC(5,$P(^(0),U,4),0),U,2)," ",$P(^AUTNINS(+Y,0),U,5)
 W !,"-------------------------------------------------------------------------------"
 W ! K DIR S DIR(0)="Y",DIR("A")="     Are the two Insurers duplicates (Y/N)" D ^DIR K DIR I Y'=1 G CONT
 W !,"OK, MERGING.."
 D MOVE G VERF
CONT W !! K DIR S DIR(0)="Y",DIR("A")="Do you want to dup-check "_$P(AG("X0"),U)_" any more",DIR("B")="Y" D ^DIR K DIR I Y=1 G CHK
VERF S DIE="^AUTNINS(",DA=AG("Y"),DR=".17//1;.41//"_$P(AG("Y0"),U) D ^DIE
 W !! K DIR S DIR(0)="Y",DIR("A")="Do you wish to continue running this program",DIR("B")="Y" D ^DIR K DIR I Y'=1 S AG("XIT")=1
 Q
MOVE K AG("ADD")
 I $D(^AUTNINS(AG("Y"),1)),$P(^(1),U)]"",$P(^(1),U,2)]"",$P(^(1),U,3)]"",$P(^(1),U,4)]"",$P(^(1),U,5)]"" G MV1
 I $P(^AUTNINS(AG("Y"),0),U,2)]"",$P(^(0),U,3)]"",$P(^(0),U,4)]"",$P(^(0),U,5)]"" F AG("I")=1:1:5 S AG("ADD",AG("I"))=$P(^(0),U,AG("I"))
MV1 S AG("B")="^AUTNINS("_AG("Y")_","
 S AG("A")="^AUTNINS("_AG,AG("A1")=AG("A")_")"
 F AGZ("I")=1:1 S AG("A1")=$Q(@AG("A1")) Q:AG("A1")'[AG("A")  S AG("Z")=AG("B")_$P($P(AG("A1"),"(",2),",",2,99) D
 .S AG("C")=$P($P(AG("A1"),"(",2),",",2,99)
 .S @AG("Z")=@AG("A1")
 I $D(AG("ADD")) F AG("I")=1:1:5 Q:'$D(AG("ADD",AG("I")))  S $P(^AUTNINS(AG("Y"),1),U,AG("I"))=AG("ADD",AG("I"))
 S DA=AG("Y"),DIK="^AUTNINS(" D IX1^DIK
 S DIK="^AUTNINS(",DA=AG D ^DIK
 W !!,"Re-directing Pointers..."
 S DA(1)="" F AGZ("I")=1:1 S DA(1)=$O(^AUPNPRVT("I",AG,DA(1))) Q:'+DA(1)  D
 .S DA="" F AGZ("I")=1:1 S DA=$O(^AUPNPRVT("I",AG,DA(1),DA)) Q:'+DA  S DIE="^AUPNPRVT("_DA(1)_",11,",DR=".01///"_AG("Y") D ^DIE
 S DA="" F AGZ("I")=1:1 S DA=$O(^AUPN3PPH("E",AG,DA)) Q:'+DA  S DIE="^AUPN3PPH(",DR=".03////"_AG("Y") D ^DIE
 S DA="" F AGZ("I")=1:1 S DA=$O(^AUTTPIC("C",AG,DA)) Q:'+DA  S DIE="^AUTTPIC(",DR=".02////"_AG("Y") D ^DIE
 Q
HD W $$S^AGVDF("IOF")
 W !?15,"*******************************************"
 W !?15,"*       INSURER DUPLICATE CHECKER         *"
 W !?15,"*******************************************"
 Q
XIT K AG
 Q
