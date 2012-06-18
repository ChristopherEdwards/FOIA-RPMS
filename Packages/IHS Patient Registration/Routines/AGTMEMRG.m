AGTMEMRG ; IHS/ASDS/EFG - MERGE EMPLOYER DATA ; 
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 ;
 S U="^"
SEL W !
 K DIC S AG("MODE")="SEL"
 S AG("XIT")=0,DIC="^AUTNEMPL(",DIC(0)="QEAM",DIC("A")="Select EMPLOYER (to Search against): " D ^DIC K DIC
 G XIT:X=""
 I +Y<1 G SEL
 I '$D(^AUTNEMPL(+Y,0)) W *7 K ^AUTNEMPL("B",$P(Y,U,2),+Y) G SEL
 S AG("X")=+Y,AG("X0")=^AUTNEMPL(+Y,0)
 D CHK
 G XIT:AG("XIT"),SEL
CHK W !!,"Dup-Check for: ",$P(AG("X0"),U),!?15,$P(AG("X0"),U,2)
 I $P(AG("X0"),U,3)]"",$P(AG("X0"),U,4)]"" W !?15,$P(AG("X0"),U,3),", "
 I  W $P(^DIC(5,$P(AG("X0"),U,4),0),U,2)," ",$P(AG("X0"),U,5)
 W !,"================================================"
 S DIC="^AUTNEMPL(",DIC(0)="QEAM",DIC("S")="I Y'=AG(""X"")",DIC("A")="Select (SEARCH) for Duplicate EMPLOYER: " D ^DIC K DIC
 I +Y<1 G CONT
 S AG("Y")=+Y,AG("Y0")=^AUTNEMPL(+Y,0)
 W !,"_______________________________________________________________________________"
 W !,"[1]  ",$P(AG("X0"),U),?39,"| [2]  ",$P(AG("Y0"),U)
 W !,"     ",$P(AG("X0"),U,2),?39,"|      ",$P(AG("Y0"),U,2)
 W ! I $P(AG("X0"),U,3)]"",$P(AG("X0"),U,4)]"" W "     ",$P(AG("X0"),U,3),", "
 I  W $P(^DIC(5,$P(AG("X0"),U,4),0),U,2)," ",$P(AG("X0"),U,5)
 W ?39,"|      " I $P(AG("Y0"),U,3)]"",$P(AG("Y0"),U,4)]"" W $P(AG("Y0"),U,3),", ",$P(^DIC(5,$P(AG("Y0"),U,4),0),U,2)," ",$P(AG("Y0"),U,5)
 W !,"-------------------------------------------------------------------------------"
 W ! K DIR S DIR(0)="Y",DIR("A")="     Are the two Employers duplicates (Y/N)" D ^DIR K DIR I Y'=1 G CONT
 W ! K DIR S DIR(0)="SO^1:"_$P(AG("X0"),U)_";2:"_$P(AG("Y0"),U),DIR("A")="     Which of the two is most accurate" D ^DIR K DIR I Y=1!(Y=2) G MOVE
CONT W !! K DIR S DIR(0)="Y",DIR("A")="Do you want to dup-check "_$P(AG("X0"),U)_" any more",DIR("B")="Y" D ^DIR K DIR I Y=1 G CHK
VERF W !! K DIR S DIR(0)="Y",DIR("A")="Do you wish to continue running this program",DIR("B")="Y" D ^DIR K DIR I Y'=1 S AG("XIT")=1
 Q
MOVE W !,"OK, MERGING.." ;X TO Y
 I Y=1 S AG=AG("X"),AG("X")=AG("Y"),AG("Y")=AG
 D MV2 G VERF
MV1 S %X="^AUTNEMPL("_AG("X")_","
 S %Y="^AUTNEMPL("_AG("Y")_","
 D %XY^%RCR
 S DA=AG("Y"),DIK="^AUTNEMPL(" D IX1^DIK
MV2 S DIK="^AUTNEMPL(",DA=AG("X") D ^DIK
 W !!,"Re-directing Pointers..."
 S DA="" F AGZ("I")=1:1 S DA=$O(^AUPNPAT("AF",AG("X"),DA)) Q:'+DA  S DIE="^AUPNPAT(",DR=".19////"_AG("Y") D ^DIE K DR
 S DA="" F AGZ("I")=1:1 S DA=$O(^AUPNPAT("AG",AG("X"),DA)) Q:'+DA  S DIE="^AUPNPAT(",DR=".22////"_AG("Y") D ^DIE K DR
 S DA="" F AGZ("I")=1:1 S DA=$O(^AUPN3PPH("AE",AG("X"),DA)) Q:'+DA  S DIE="^AUPNPAT(",DR=".16////"_AG("Y") D ^DIE K DR
 Q
XIT K AG
 Q
