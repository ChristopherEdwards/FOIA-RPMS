ACMDELPT ; IHS/TUCSON/TMJ - DELETE PATIENTS FROM AN ENTIRE REGISTER ;
 ;;2.0;ACM CASE MANAGEMENT SYSTEM;;JAN 10, 1996
 ;;ALLOWS USER TO DELETE ONLY PATIENTS FROM REG
EN D DELREG
EXIT K ACMRGTP,ACMRG,ACMRGNA,ACMI,ACMGREF,ACMCTRL,ACMCTRLE,ACMCTRLP,ACMCTRLS,ACMCTRLX,ACMDELRG
 Q
DELREG W:$D(IOF) @IOF
 W !,"WARNING  WARNING  WARNING  WARNING  WARNING  WARNING  WARNING  WARNING  WARNING",*7,*7,*7,!!,"The next procedure will allow you to COMPLETELY delete ALL PATIENTS from"
 W !,"the Case Management System.  The register, including all patients and all",!,"information on all patients will be deleted WITH NO POSSIBILITY of recovering"
 W !,"any of the data.  Be absolutely certain this is what you want before proceding."
 S DIR(0)="YO",DIR("A")="Delete an entire register",DIR("B")="NO"
 W !
 D ^DIR K DIR
 Q:Y'=1
 S (ACMRGTP,ACMDELRG)="" D ^ACMGTP
 I '$D(ACMRG) W !!,"NO ACTION TAKEN",*7,*7 H 2 Q
 W !!,"Are you certain you want to delete"
 S DIR(0)="YO",DIR("A")="the entire "_ACMRGNA_" PATIENTS",DIR("B")="NO"
 D ^DIR K DIR
 Q:Y'=1
 W !!,"...DELETING ALL PATIENTS FROM THE REGISTER..."
 S DIK="^ACM(41,",DA=0
 F  S DA=$O(^ACM(41,"B",ACMRG,DA)) Q:'DA  W "." D ^DIK
 K DIK,DIC,DA
 W !!,"The ",ACMRGNA," PATIENTS have been deleted." H 3
 Q
