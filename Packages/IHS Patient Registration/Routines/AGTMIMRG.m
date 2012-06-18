AGTMIMRG ; IHS/ASDS/EFG - MERGE INSURERS ; 
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 ;
SEL W !
 S AG("MODE")="SEL"
 S AG("XIT")=0,DIC="^AUTNINS(",DIC(0)="QEAM",DIC("A")="Select INSURER (to Search against): " S DIC("S")="I $D(^(1)),$P(^(1),U,7)'=0,$D(^(2)),""DRN""'[$P(^(2),U)"
 D ^DIC
 I X="" G XIT
 I +Y<1 G SEL
 S AG("X")=+Y,AG("X0")=^AUTNINS(+Y,0)
 D CHK
 G XIT:AG("XIT"),SEL
CHK W !!,"Dup-Check for: ",$P(AG("X0"),U),!?15,$P(AG("X0"),U,2)
 I $P(AG("X0"),U,3)]"",$P(AG("X0"),U,4)]"" W !?15,$P(AG("X0"),U,3),", "
 I  W $P(^DIC(5,$P(AG("X0"),U,4),0),U,2)," ",$P(AG("X0"),U,5)
 W !,"================================================"
 S DIC="^AUTNINS(",DIC(0)="QEAM",DIC("S")="I Y'=AG(""X""),$D(^(1)),$P(^(1),U,7)'=0,$D(^(2)),""DNR""'[$P(^(2),U)",DIC("A")="Select (SEARCH) for Duplicate INSURER: " D ^DIC
 I +Y<1 G CONT
 S AG("Y")=+Y,AG("Y0")=^AUTNINS(+Y,0)
 W !,"_______________________________________________________________________________"
 W !,"[1]  ",$P(AG("X0"),U),?39,"| [2]  ",$P(AG("Y0"),U)
 W !,"     ",$P(AG("X0"),U,2),?39,"|      ",$P(AG("Y0"),U,2)
 W ! I $P(AG("X0"),U,3)]"",$P(AG("X0"),U,4)]"" W "     ",$P(AG("X0"),U,3),", "
 I  W $P(^DIC(5,$P(AG("X0"),U,4),0),U,2)," ",$P(AG("X0"),U,5)
 W ?39,"|      " I $P(AG("Y0"),U,3)]"",$P(AG("Y0"),U,4)]"" W $P(AG("Y0"),U,3),", ",$P(^DIC(5,$P(AG("Y0"),U,4),0),U,2)," ",$P(AG("Y0"),U,5)
 W !,"-------------------------------------------------------------------------------"
 W ! K DIR S DIR(0)="Y",DIR("A")="     Are the two Insurers duplicates (Y/N)" D ^DIR K DIR I Y'=1 G CONT
 W ! K DIR S DIR(0)="SO^1:"_$P(AG("X0"),U)_";2:"_$P(AG("Y0"),U),DIR("A")="     Which of the two is most accurate" D ^DIR K DIR
 I Y=1!(Y=2) G MOVE
CONT W !! K DIR S DIR(0)="Y",DIR("A")="Do you want to dup-check "_$P(AG("X0"),U)_" any more",DIR("B")="Y" D ^DIR K DIR I Y=1 S AG("XIT")=0 Q
VERF W !! K DIR S DIR(0)="Y",DIR("A")="Do you wish to continue running this program",DIR("B")="Y" D ^DIR K DIR I Y'=1 S AG("XIT")=1
 Q
MOVE K AG("ADD")
 I Y=1 S AG=AG("X"),AG("X")=AG("Y"),AG("Y")=AG
 W !,"OK, MERGING.." D PTR G VERF ;X TO Y
 I $D(^AUTNINS(AG("X"),1)),$P(^(1),U)]"",$P(^(1),U,2)]"",$P(^(1),U,3)]"",$P(^(1),U,4)]"",$P(^(1),U,5)]"" G MV1
 I $P(^AUTNINS(AG("X"),0),U,2)]"",$P(^(0),U,3)]"",$P(^(0),U,4)]"",$P(^(0),U,5)]"" F AG("I")=1:1:5 S AG("ADD",AG("I"))=$P(^(0),U,AG("I"))
MV1 S %X="^AUTNINS("_AG("X")_","
 S %Y="^AUTNINS("_AG("Y")_"," D %XY^%RCR
 I $D(AG("ADD")) F AG("I")=1:1:5 Q:'$D(AG("ADD",AG("I")))  S $P(^AUTNINS(AG("Y"),1),U,AG("I"))=AG("ADD",AG("I"))
 S DA=AG("X"),DIK="^AUTNINS(" D IX1^DIK
PTR S DIE="^AUTNINS(",DA=AG("X"),DR=".17////0;.27////"_AG("Y")_";.41////MERGED TO IEN: "_AG("Y") D ^DIE K DR
 W !!,"Re-directing Pointers..."
 S DA(1)="" F AGZ("I")=1:1 S DA(1)=$O(^AUPNPRVT("I",AG("X"),DA(1))) Q:'+DA(1)  D
 .S DA="" F AGZ("I")=1:1 S DA=$O(^AUPNPRVT("I",AG("X"),DA(1),DA)) Q:'+DA  S DIE="^AUPNPRVT("_DA(1)_",11,",DR=".01///"_AG("Y") D ^DIE K DR
 S DA="" F AGZ("I")=1:1 S DA=$O(^AUPN3PPH("E",AG("X"),DA)) Q:'+DA  S DIE="^AUPN3PPH(",DR=".03////"_AG("Y") D ^DIE K DR
 S DA="" F  S DA=$O(^ABMDBILL("AJ",AG("X"),DA)) Q:'DA  S DIE="^ABMDBILL(",DR=".08////"_AG("Y") D ^DIE K DR
 S DA="" F  S DA=$O(^AUTNEMPL("AI",AG("X"),DA)) Q:'DA  S DIE="^AUTNEMPL(",DR=".08////"_AG("Y") D ^DIE K DR
 S DA="" F AGZ("I")=1:1 S DA=$O(^AUTTPIC("C",AG("X"),DA)) Q:'+DA  S DIE="^AUTTPIC(",DR=".02////"_AG("Y") D ^DIE K DR
 S DA="" F AGZ("I")=1:1 S DA=$O(^ABPVFAC("I",AG("X"),DA)) Q:'+DA  S DIE="^ABPVFAC(",DR="7////"_AG("Y") D ^DIE K DR
 S DA(1)="" F AGZ("I")=1:1 S DA(1)=$O(^ABMDERR("AB",AG("X"),DA(1))) Q:'+DA(1)  D
 .S (DIC,DIK)="^ABMDERR("_DA(1)_",11,",DA=AG("X") D ^DIK
 .S (DINUM,X)=AG("Y"),DIC(0)="L" K DD,D0 D FILE^DICN
 Q
XIT K AG
 Q
