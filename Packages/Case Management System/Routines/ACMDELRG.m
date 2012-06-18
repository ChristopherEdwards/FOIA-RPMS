ACMDELRG ; IHS/TUCSON/TMJ - DELETE AN ENTIRE REGISTER ; [ 12/19/05  11:36 AM ]
 ;;2.0;ACM CASE MANAGEMENT SYSTEM;**2,6**;JAN 10, 1996
 ;;Routine added for Patch 2
 ;PATCH #6 IDENTIFIES THE REGISTER DEVELOPER NAME WHEN DELETING A REGISTER
 ;;EP;ENTRY POINT
EN D DELREG
EXIT K ACMRGTP,ACMRG,ACMRGNA,ACMI,ACMGREF,ACMCTRL,ACMCTRLE,ACMCTRLP,ACMCTRLS,ACMCTRLX,ACMDELRG
 Q
DELREG W:$D(IOF) @IOF
 W !,"WARNING  WARNING  WARNING  WARNING  WARNING  WARNING  WARNING  WARNING  WARNING",*7,*7,*7,!!,"The next procedure will allow you to COMPLETELY delete an entire register from"
 W !,"the Case Management System.  The register, including all patients and all",!,"information on all patients will be deleted WITH NO POSSIBILITY of recovering"
 W !,"any of the data.  Be absolutely certain this is what you want before proceding."
 S DIR(0)="YO",DIR("A")="Delete an entire register",DIR("B")="NO"
 W !
 D ^DIR K DIR
 Q:Y'=1
 S (ACMRGTP,ACMDELRG)="" D ^ACMGTP
DELREG2 ;SECOND SECURITY LEVEL FOR REGISTER DELETION
 I '$D(ACMRG) W !!,"NO ACTION TAKEN",*7,*7 H 2 Q
 S ACMRDEV=$P($G(^ACM(41.1,ACMRG,4)),U) ;IHS/CMI/TMJ PATCH #6
 I ACMRDEV'="" S ACMRDEV=$P($G(^VA(200,ACMRDEV,0)),U)
 I DUZ'=$P($G(^ACM(41.1,ACMRG,4)),U) W !!,$C(7),$C(7),?20,"You are NOT the Creator of this Register",!,?19,"Therefore, you cannot Delete this Register!",!!
 I DUZ'=$P($G(^ACM(41.1,ACMRG,4)),U) W !,"Contact the Register Developer- "_ACMRDEV_" -for more information.",!! H 5 Q
 W !!,"Are you certain you want to delete"
 S DIR(0)="YO",DIR("A")="the entire "_ACMRGNA_" register",DIR("B")="NO"
 D ^DIR K DIR
 Q:Y'=1
 W !!,"...DELETING ALL PATIENT RELATED DATA..."
 F ACMI=42,43,44,45,46,47,48,51,53,54 S ACMGREF="^ACM("_ACMI_")" S DA=0 F  S DA=$O(@ACMGREF@("F",ACMRGNA,DA)) Q:'DA  W "." S DIK="^ACM("_ACMI_"," D ^DIK
 K DIK,DIC,DA
 W !!,"...DELETING ALL REGISTER RELATED LIST ENTRIES..."
 F ACMI=42.1,43.1,44.1,45.1,47.1,48,50,51.1,53.1,54.1 S ACMGREF="^ACM("_ACMI_")" S DA(1)=0 F  S DA(1)=$O(@ACMGREF@("RG",ACMRG,DA(1))) Q:'DA(1)  D
 .S DA=0
 .F  S DA=$O(@ACMGREF@("RG",ACMRG,DA(1),DA)) Q:'DA  W "." S DIK="^ACM("_ACMI_","_DA(1)_",""RG""," D ^DIK
 K DIK,DIC,DA
 W !!,"...DELETING ALL PATIENTS FROM THE REGISTER..."
 S DIK="^ACM(41,",DA=0
 F  S DA=$O(^ACM(41,"B",ACMRG,DA)) Q:'DA  W "." D ^DIK
 K DIK,DIC,DA
 W !!,"...DELETING THE REGISTER..."
 S DIK="^ACM(41.1,",DA=ACMRG D ^DIK
 K DIK,DIC,DA
 W !!,"The ",ACMRGNA," and all related data have been deleted." H 3
 Q
