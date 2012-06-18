BLSRLC ; IHS/CMI/LAB - wipe out all loinc codes ; [ 11/19/2002  8:26 AM ]
 ;;5.2;LR;**1015**;NOV 18, 2002
 ;
 W !!,"This routine will remove all loinc codes from file 60.",!
 S DIR(0)="Y",DIR("A")="Do you want to continue",DIR("B")="N" KILL DA D ^DIR KILL DIR
 Q:$D(DIRUT)
 Q:'Y
 S BLSX=0 F  S BLSX=$O(^LAB(60,BLSX)) Q:BLSX'=+BLSX  D
 .S BLSS=0 F  S BLSS=$O(^LAB(60,BLSX,1,BLSS)) Q:BLSS'=+BLSS  D
 ..I '$D(^LAB(60,BLSX,1,BLSS,95.3)) Q  ;no loinc code
 ..W ".",BLSX
 ..S DA(1)=BLSX,DA=BLSS,DIE="^LAB(60,"_BLSX_",1,",DR="95.3///@" D ^DIE
 ..I $D(Y) Q
 ..Q
 .Q
 W !!,"Loinc codes have been removed from file 60."
 Q
