AGTMGMRG ; IHS/ASDS/EFG - MERGE GROUP INSURANCE PLAN DATA ; 
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 ;
 S U="^"
SEL W !
 K DIC S AG("MODE")="SEL"
 S AG("XIT")=0,DIC="^AUTNEGRP(",DIC(0)="QEAM",DIC("A")="Select GROUP PLAN (to Search against): " D ^DIC K DIC
 G XIT:X=""
 I +Y<1 G SEL
 I '$D(^AUTNEGRP(+Y,0)) W *7 K ^AUTNEGRP("B",$P(Y,U,2),+Y) G SEL
 S AG("X")=+Y,AG("X0")=^AUTNEGRP(+Y,0)
 D CHK
 G XIT:AG("XIT"),SEL
CHK W !!,"Dup-Check for: ",$P(AG("X0"),U),!?15,$P(AG("X0"),U,2)
 W !,"================================================"
 S DIC="^AUTNEGRP(",DIC(0)="QEAM",DIC("S")="I Y'=AG(""X"")",DIC("A")="Select (SEARCH) for Duplicate GROUP PLAN: " D ^DIC K DIC
 I +Y<1 G CONT
 S AG("Y")=+Y,AG("Y0")=^AUTNEGRP(+Y,0)
 W !,"_______________________________________________________________________________"
 W !,"[1]  ",$P(AG("X0"),U),?39,"| [2]  ",$P(AG("Y0"),U)
 W !,"     ",$P(AG("X0"),U,2),?39,"|      ",$P(AG("Y0"),U,2)
 W !,"-------------------------------------------------------------------------------"
 W ! K DIR S DIR(0)="Y",DIR("A")="     Are the two GROUP PLANS duplicates (Y/N)" D ^DIR K DIR I Y'=1 G CONT
 W ! K DIR S DIR(0)="SO^1:"_$P(AG("X0"),U)_";2:"_$P(AG("Y0"),U),DIR("A")="     Which of the two is most accurate" D ^DIR K DIR I Y=1!(Y=2) G MOVE
CONT W !! K DIR S DIR(0)="Y",DIR("A")="Do you want to dup-check "_$P(AG("X0"),U)_" any more",DIR("B")="Y" D ^DIR K DIR I Y=1 G CHK
VERF W !! K DIR S DIR(0)="Y",DIR("A")="Do you wish to continue running this program",DIR("B")="Y" D ^DIR K DIR I Y'=1 S AG("XIT")=1
 Q
MOVE ;
 I Y=1 S AG=AG("X"),AG("X")=AG("Y"),AG("Y")=AG
 D MV2 G VERF
MV1 S %X="^AUTNEGRP("_AG("X")_","
 S %Y="^AUTNEGRP("_AG("Y")_","
 D %XY^%RCR
 S DA=AG("Y"),DIK="^AUTNEGRP(" D IX1^DIK
MV2 S DIK="^AUTNEGRP(",DA=AG("X") D ^DIK
 W !!,"Re-directing Pointers..."
 S DA="" F AGZ("I")=1:1 S DA=$O(^AUPN3PPH("AG",AG("X"),DA)) Q:'+DA  S DIE="^AUPN3PPH(",DR=".06////"_AG("Y") D ^DIE K DR
 Q
XIT K AG
 Q
