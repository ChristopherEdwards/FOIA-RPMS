AG1 ; IHS/ASDS/EFG - ENTER HEALTH RECORD NUMBER ; MAR 19, 2010
 ;;7.1;PATIENT REGISTRATION;**7,9**;AUG 25, 2005
 ;
 I $D(AGDOG) D ^AGCHTMP Q:$D(DUOUT)!$D(DTOUT)!$D(DFOUT)!'$D(AG("TEMP CHART"))  S AG("CH")=AG("TEMP CHART") G L3
 Q:'$D(DFN)
 S DIE="^AUPNPAT("
 S DA=DFN
 K:'$D(^AUPNPAT(DFN,41,DUZ(2),0)) AG("EDIT")
L1 ;
 W !!,"Enter the CHART NUMBER: "
 I $D(^AUPNPAT(DFN,41,DUZ(2),0)) D
 . S (AG("CH"),AG("OCH"))=$P(^AUPNPAT(DFN,41,DUZ(2),0),U,2)
 . W AG("CH"),"//  "
 . S AG("EDIT")=""
 E  S (AG("CH"),AG("OCH"))=""
 ; fill in missing first piece if gone
 I $D(^AUPNPAT(DFN,41,DUZ(2),0)),$P(^AUPNPAT(DFN,41,DUZ(2),0),U)="" D
 . S $P(^AUPNPAT(DFN,41,DUZ(2),0),U)=DUZ(2)
 D READ^AG
 G K:$D(DFOUT)!$D(DTOUT)
 G SSN:($D(DLOUT)&$D(AG("EDIT")))
 Q:$D(DUOUT)
 I $D(DQOUT)!(Y'?1N.N)!($L(Y)>6)!(+Y<1) D  G L1
 . W !!,"Enter the 1 to 6-digit IHS CHART NUMBER."
 ;HL7 INTERFACE -- PUT PATIENT DFN INTO TEMP ARRAY FOR HL7 CALL
 S ^XTMP("AGHL7",DUZ(2),DFN)=DA  ;AG*7.1*9 - Added DUZ(2) subscript
 S ^XTMP("AGHL7AG",DUZ(2),DFN,"UPDATE")=""  ;AG*7.1*9 - Added DUZ(2) subscript
 ;
 S AG("CH")=+Y
 S AG("CH1")=AG("CH")-1
 S AG("CH1")=$O(^AUPNPAT("D",AG("CH1")))
 G L3:AG("CH")'=AG("CH1")!(AG("CH1")="")
 S AG("D")=0
 I Y="" W *7 G L1
L2 ;
 S AG("D")=$O(^AUPNPAT("D",AG("CH1"),AG("D")))
 G L3:AG("D")=""
 S AG("DD")=0
TPGL2HLF ;
 S AG("DD")=$O(^AUPNPAT("D",AG("CH1"),AG("D"),AG("DD")))
 G L2:AG("DD")=""
 G TPGL2HLF:AG("DD")'=DUZ(2)
 W !!,*7,AG("CH")," is already assigned to ",$S($P($G(^DPT(AG("D"),0)),U)'="":$P($G(^DPT(AG("D"),0)),U),1:"UNDEFINED RECORD")
 I $P($G(^DPT(AG("D"),0)),U)="" D  G L1
 .W !,"There is a dangling ""D"" cross reference in the PATIENT file."
 .W !,"The HRN ",AG("CH")_" is in use by this cross reference."
 .W !,"Please report this to the help desk"
 .H 3
 G L1
L3 ;
 S DIE="^AUPNPAT("
 S DA=DFN
 S DR="4101///"_"`"_DUZ(2)
 S DR(2,9000001.41)=".02///"_AG("CH")
 D ^DIE
 K DIE,DA,DR
 S AG("K")=""
 G SSN
 S:'$D(^AUPNPAT(DFN,41,0)) ^AUPNPAT(DFN,41,0)="^9000001.41IP^^"
 K DIC,DR
 S X=$P(^DIC(4,DUZ(2),0),U)
 S DIC="^AUPNPAT("_DFN_",41,"
 S DA(1)=DFN
 S DIC(0)="ML"
 D ^DIC
 S DIE="^AUPNPAT("_DFN_",41,"
 S DA=DUZ(2)
 S DA(1)=DFN
 S DR=".02///"_AG("CH")
 D ^DIE
 K DA,DIE,DR
K S AG("K")=""
SSN ;
 D NOSSN^AG3A:$P(^DPT(DFN,0),U,9)=""
 I $D(DUOUT) K DUOUT G AG1
 Q
