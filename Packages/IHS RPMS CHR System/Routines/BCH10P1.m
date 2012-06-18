BCH10P1 ; IHS/TUCSON/LAB - patch 1 to bch for icd update ;
 ;;1.0;IHS RPMS CHR SYSTEM;**1**;OCT 28, 1996
 ;
 ;update 1 code in ICD crosswalk for 97 updates
 I '$D(^BCHTPROB) W !,"CHR Package NOT installed.",! Q
 S DA=$O(^BCHTPROB("B","OBESITY",""))
 I 'DA W !,"Obesity Entry not found in CHR HEALTH PROBLEM CODE FILE.  NOTIFY PROGRAMMER." Q
 S DIE="^BCHTPROB(",DR=".04///278.00" D ^DIE
 I $D(Y) W !,$C(7),$C(7),"Updating of Obesity Code failed!! Notify programmer.",!
 W !,"ICD update of CHR - ICD crosswalk complete.",!
 K DA,DIE,DR
 Q
