AGTMPMRG ; IHS/ASDS/EFG - MERGE POLICY HOLDERS ;  
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 ;
 S U="^"
SEL W !
 K DTOUT,DUOUT
 K DIC S AG("MODE")="SEL"
 S AG("XIT")=0,DIC="^AUPN3PPH(",DIC(0)="QEA",DIC("A")="Select POLICY HOLDER (to Search against): ",D="B^C^D" D MIX^DIC1 K DIC
 G XIT:X=""!$D(DTOUT)!$D(DUOUT)
 I +Y<1 G SEL
 I '$D(^AUPN3PPH(+Y,0)) W *7 K ^AUPN3PPH("B",$P(Y,U,2),+Y) G SEL
 S AG("X")=+Y,AG("X0")=^AUPN3PPH(+Y,0)
 D CHK
 G XIT:AG("XIT"),SEL
CHK W !!,"Dup-Check for: ",$P(AG("X0"),U),!?15
 S AG("PDFN")=$P(AG("X0"),U,2) D HRN
 W !?15,$P($G(^AUTNINS($P(AG("X0"),U,3),0)),U)
 W !,"================================================"
 S DIC="^AUPN3PPH(",DIC(0)="QEAM",DIC("S")="I Y'=AG(""X""),$P(^(0),U,3)=$P(AG(""X0""),U,3)",DIC("A")="Select (SEARCH) for Duplicate POLICY HOLDER: " D ^DIC K DIC
 I $D(DTOUT)!$D(DUOUT) S AG("XIT")=1 Q
 I +Y<1 W *7,!,"No other Policy Holders having the same insurer found.",! G CONT
 S AG("Y")=+Y,AG("Y0")=^AUPN3PPH(+Y,0)
DISP W !,"_______________________________________________________________________________"
 W !,"[1]  ",$P(AG("X0"),U),?39,"| [2]  ",$P(AG("Y0"),U)
 W !,"     " S AG("PDFN")=$P(AG("X0"),U,2) D HRN
 W ?39,"|      " S AG("PDFN")=$P(AG("Y0"),U,2) D HRN
 W !,"-------------------------------------------------------------------------------"
 W !!,"The  CRT Screen will display each of the Policy Holders in turn ",!,"until you enter an ""^""  to end the displays.",!
 S DIR(0)="E" D ^DIR
 G:($G(DUOUT)!$G(DTOUT)!$G(DIROUT)) CONT
 K DTOUT,DUOUT,DROUT,DIROUT
 F  D  Q:($G(DUOUT)!$G(DTOUT)!$G(DIROUT))
 .S AGELP("PH")=AG("X"),AGELP("INS")=$P(AG("X0"),U,3) D ^AGELA
 .W !!!,"Above Information for [1]  ",$P(AG("X0"),U),"     ",$P(AG("X0"),U,4),!!
 .S DIR(0)="E" D ^DIR
 .Q:($G(DUOUT)!$G(DTOUT)!$G(DIROUT))
 .S AGELP("PH")=AG("Y"),AGELP("INS")=$P(AG("Y0"),U,3) D ^AGELA
 .Q:($G(DUOUT)!$G(DTOUT)!$G(DIROUT))
 .W !!!,"Above Information for [2]  ",$P(AG("Y0"),U),"     ",$P(AG("Y0"),U,4),!!
 .S DIR(0)="E" D ^DIR
 K AGELP
 W ! K DIR S DIR(0)="Y",DIR("A")="     Are the two POLICY HOLDERS duplicates (Y/N)" D ^DIR K DIR I Y'=1 G CONT
 W ! K DIR S DIR(0)="SO^1:"_$P(AG("X0"),U)_"  "_$P(AG("X0"),U,4)_";2:"_$P(AG("Y0"),U)_"  "_$P(AG("Y0"),U,4),DIR("A")="     Which of the two is most accurate" D ^DIR K DIR I Y=1!(Y=2) G MOVE
CONT W !! K DIR S DIR(0)="Y",DIR("A")="Do you want to dup-check "_$P(AG("X0"),U)_" any more",DIR("B")="Y" D ^DIR K DIR I Y=1 G CHK
VERF W !! K DIR S DIR(0)="Y",DIR("A")="Do you wish to continue running this program",DIR("B")="Y" D ^DIR K DIR I Y'=1 S AG("XIT")=1
 Q
MOVE ;
 I Y=1 S AG=AG("X"),AG("X")=AG("Y"),AG("Y")=AG
 D MV2 G VERF
MV1 S %X="^AUPN3PPH("_AG("X")_","
 S %Y="^AUPN3PPH("_AG("Y")_","
 D %XY^%RCR
 S DA=AG("Y"),DIK="^AUPN3PPH(" D IX1^DIK
MV2 S DIK="^AUPN3PPH(",DA=AG("X") D ^DIK
 W !!,"Re-directing Pointers..."
 S DA(1)=0 F  S DA(1)=$O(^AUPNPRVT("C",AG("X"),DA(1))) Q:'DA(1)  D
 .S DA=0 F  S DA=$O(^AUPNPRVT("C",AG("X"),DA(1),DA)) Q:'DA  D
 ..S DIE="^AUPNPRVT("_DA(1)_",11,"
 ..I $D(^AUPNPRVT("C",AG("Y"),DA(1))) S DIK=DIE D ^DIK Q
 ..S DR=".08////"_AG("Y") D ^DIE K DR
 Q
HRN W "(HRN: ",$S('$G(AG("PDFN")):"not Registered",'$G(DUZ(2)):"DUZ(2) undefined",$P($G(^AUPNPAT(AG("PDFN"),41,DUZ(2),0)),U,2):$P(^(0),U,2),1:"no HRN at "_$P(^AUTTLOC(DUZ(2),0),U,2)),")"
 Q
XIT K AG
 Q
