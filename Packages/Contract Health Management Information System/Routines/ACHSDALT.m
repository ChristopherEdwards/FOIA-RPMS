ACHSDALT ;IHS/OIT/FCJ - ADD ALT REC INFO
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**6**;JUNE 11, 2001
 ;;ACHS*3.1*18 New Routine
 ;
ALTTYP ;Add Alt Resource type
 ;
 W !!
 Q:'$D(^ACHSDENS("B","Alternate Resource Available"))
 S DA(1)=0
 S DA(1)=$O(^ACHSDENS("B","Alternate Resource Available",0))
 S (DIC,DIE)="^ACHSDENS("_DA(1)_",30,"
 S DIC(0)="AQEML"
 D ^DIC
 Q:Y<1
 S DA=+Y
 W !,"New Alternate Resource Type Added:  ",X
 D ^XBFMK
 Q
