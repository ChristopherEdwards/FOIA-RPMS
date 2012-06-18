ACMDALLR ; IHS/TUCSON/TMJ - DELETE ALL REGISTERS & LIST DATA ;
 ;;2.0;ACM CASE MANAGEMENT SYSTEM;;JAN 10, 1996
 ;;WRITTEN FOR DEMO AND TRAINING OHPRD TUCSON
 ;;THIS ROUTINE WILL DELETE ++ALL++ REGISTERS FOR TRG PURPOSES
EN D DELREG
EXIT K ACMRGTP,ACMRG,ACMRGNA,ACMI,ACMGREF,ACMCTRL,ACMCTRLE,ACMCTRLP,ACMCTRLS,ACMCTRLX,ACMDELRG,ACMCTR,ACMCTR2,ACZ
 Q
DELREG W:$D(IOF) @IOF
 W !,"WARNING  WARNING  WARNING  WARNING  WARNING  WARNING  WARNING  WARNING  WARNING",*7,*7,*7,!!,"The next procedure will allow you to COMPLETELY delete ALL Registers from"
 W !,"the Case Management System.  The register, including all patients and all",!,"information on all patients will be deleted WITH NO POSSIBILITY of recovering"
 W !,"any of the data.  Be absolutely certain this is what you want before proceding."
 S DIR(0)="YO",DIR("A")="Shall I make you an authorized user for all registers",DIR("B")="NO"
 W !
 D ^DIR K DIR
 Q:Y=""!(Y["^")  I Y=1 S Y=DUZ D SUSR0
 D SAVE Q:$D(ACMQ)
 S DIR(0)="YO",DIR("A")="Delete all other registers and data",DIR("B")="NO"
 W !
 D ^DIR K DIR
 Q:Y'=1
 W !!,"First I will remove unreferenced pointers..." D FRESH
 W !,"...Finished...Starting Deletions..."
 S ACMCTR=0 F  S ACMCTR=$O(^ACM(41.1,"B",ACMCTR)) Q:ACMCTR=""  D DELETE
 W !!,"...Deleting all REGISTERS completed",!
 Q
DELETE ;
 S ACMRG=0,ACMRG=$O(^ACM(41.1,"B",ACMCTR,ACMRG)),ACMRGNA=$P(^ACM(41.1,ACMRG,0),U,1)
 I $D(^TMP("ACM",$J,ACMRGNA)) W !!,"...Saving Register:  ",ACMRGNA,!! Q
 W !!,"...Deleting all PATIENT related data...for register:  ",ACMRGNA
 F ACMI=42,43,44,45,46,47,48,51,53,54 S ACMGREF="^ACM("_ACMI_")" S DA=0 F  S DA=$O(@ACMGREF@("F",ACMRGNA,DA)) Q:'DA  W "." S DIK="^ACM("_ACMI_"," D ^DIK
 K DIK,DIC,DA
 W !,"...Deleting all REGISTER related list entries...for register:  ",ACMRGNA
 F ACMI=42.1,43.1,44.1,45.1,47.1,48,50,51.1,53.1,54.1 S ACMGREF="^ACM("_ACMI_")" S DA(1)=0 F  S DA(1)=$O(@ACMGREF@("RG",ACMRG,DA(1))) Q:'DA(1)  D
 .S DA=0
 .F  S DA=$O(@ACMGREF@("RG",ACMRG,DA(1),DA)) Q:'DA  W "." S DIK="^ACM("_ACMI_","_DA(1)_",""RG""," D ^DIK D DELLST
 K DIK,DIC,DA
 W !,"...Deleting all PATIENTS from the register...",ACMRGNA
 S DIK="^ACM(41,",DA=0
 F  S DA=$O(^ACM(41,"B",ACMRG,DA)) Q:'DA  W "." D ^DIK
 K DIK,DIC,DA
 W !,"...Deleting the register...",ACMRGNA
 S DIK="^ACM(41.1,",DA=ACMRG D ^DIK
 K DIK,DIC,DA
 W !,"The ",ACMRGNA," and all related data have been deleted.",!! H 3
 Q
DELLST S DA=DA(1) S ACMCTR2=0,ACMCTR2=$O(@ACMGREF@(DA,"RG",ACMCTR2)) Q:ACMCTR2'=""  W "." S DIK="^ACM("_ACMI_"," D ^DIK
 Q
FRESH F ACMI=42.1,43.1,44.1,45.1,47.1,48,50,51.1,53.1,54.1 D FRESH1
 Q
FRESH1 ;
 S ACZ=0 F  S ACZ=$O(^ACM(ACMI,ACZ)) Q:+ACZ=0  D FRESH2
 Q
FRESH2 ;
 S X=0,X=$O(^ACM(ACMI,ACZ,"RG",X)) Q:X'=""
 S DIK="^ACM("_ACMI_",",DA=ACZ D ^DIK W "."
 Q
SAVE ;ALLOWS USER TO SAVE EXISTING REGISTERS FROM DELETION
 K ACMQ,^TMP("ACM",$J)
 S DIR(0)="YO",DIR("A")="Save an existing register(s)",DIR("B")="NO"
 W !
 D ^DIR K DIR
 S:Y["^" ACMQ=1 Q:Y'=1
SAVE1 S (ACMRGTP,ACMDELRG)="" D RGTPX^ACMGTPZ
 I '$D(ACMRG) W !,"FINISHED..." D DSPSAV H 2 Q
 S ACMRGNA=$P(^ACM(41.1,ACMRG,0),U,1) S ^TMP("ACM",$J,ACMRGNA)="" W !,"Saving ",ACMRGNA G SAVE1
 ;
DSPSAV ;DISPLAYS SAVED REGISTERS
 W !!!,"Saved Registers include:  " S X=0 F  S X=$O(^TMP("ACM",$J,X)) Q:X=""  W !,"Register:  ",X
 W !! Q
SUSR S DIC="^VA(200,",DIC(0)="AQEM" D ^DIC Q:+Y<1
SUSR0 S ACMX=0,ACMY=+Y F  S ACMX=$O(^ACM(41.1,ACMX)) Q:+ACMX=0  D SUSR1
 W !,"User is now authorized for ALL registers...",!!
 Q
SUSR1 ;
 I '$D(^ACM(41.1,ACMX,"AU",0)) S ^ACM(41.1,ACMX,"UA",0)="^9002241.12P^0^0"
 S DIE="^ACM(41.1,ACMX,""AU"",",DA(1)=ACMX,DA=ACMY,DR=".01///^S X=DA",DIC(0)="LX" D ^DIE  Q
