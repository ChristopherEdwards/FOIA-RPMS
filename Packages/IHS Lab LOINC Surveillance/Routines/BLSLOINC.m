BLSLOINC ; IHS/CMI/LAB - USED TO ADD LOINC CODES TO MASTER FILE ; [ 11/18/2002  1:59 PM ]
 ;;5.2;LR;**1015**;NOV 18, 2002
 ;
 ;
 Q
ML ;assign loinc codes to master.
 I '$D(DUZ) W !!,"Log into Kernel first using XUP." Q
 W:$D(IOF) @IOF
 W !!,"Hi Dorothy!  Have fun Loincing!!!",!!!!
 S BLSQUIT=0
 S BLSN="" F  S BLSN=$O(^BLSLMAST("B",BLSN)) Q:BLSN=""!(BLSQUIT)  D
 .S BLSY=0 F  S BLSY=$O(^BLSLMAST("B",BLSN,BLSY)) Q:BLSY'=+BLSY!(BLSQUIT)  D ML1
 W !!,"So long for now..................."
 K BLSN,BLSQUIT D ^XBFMK
 Q
ML1 ;
 Q:$P(^BLSLMAST(BLSY,0),U,4)  ;already loinc
 Q:$P(^BLSLMAST(BLSY,0),U,6)  ;no loincing
 W !!!,"Test Name:     ",BLSN
 I $P(^BLSLMAST(BLSY,0),U,7)]"" W !,"               ",$P(^BLSLMAST(BLSY,0),U,7)
 I $P($G(^BLSLMAST(BLSY,11)),U)]"" W !,"               ",$P($G(^BLSLMAST(BLSY,11)),U)
 W !,"Site/Specimen: ",$P(^BLSLMAST(BLSY,0),U,2)
 W !,"Units:         ",$P(^BLSLMAST(BLSY,0),U,3)
 W ! S DIR(0)="S^1:Assign a Loinc;2:Skip this one for now;3:Mark as Un-Loincable;4:Quit Loinc-ing",DIR("A")="Select Action",DIR("B")="1" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) S BLSQUIT=1 Q
 I Y=4 S BLSQUIT=1 Q
 I Y=2 Q
 I Y=3 S $P(^BLSLMAST(BLSY,0),U,6)=1 W "   marked as not Loinc-able.." Q
 S DA=BLSY,DR=.04,DIE="^BLSLMAST(" D ^DIE K DIE,DA,DR D ^XBFMK
 Q
