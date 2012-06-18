ACMADDM ; IHS/TUCSON/TMJ - ADD DIABETES REGISTER ; 05 Feb 2006  11:39 AM
 ;;2.0;ACM CASE MANAGEMENT SYSTEM;**6**;JAN 10, 1996
 ;EP CALLED FROM AN OPTION
 ;This routine allows the user to convert an existing
 ;Diabetes Register, or add the IHS National Diabetes Register
 ;to the Case Management Package
 ;
 W:$D(IOF) @IOF
 I $D(^ACM(41.1,"B","IHS DIABETES")) W !,"You already have a register called 'IHS DIABETES'",!,"This option cannot be run!" Q
 S DIR("A",1)="      IHS National Diabetes Register Installation"
 S DIR("A",2)="  "
 S DIR("A",3)="This option will quide you through the following:"
 S DIR("A",4)="  1 = Installing the IHS National Diabetes Register"
 S DIR("A",5)="      if you curently are not using a Diabetes Register."
 S DIR("A",6)="  2 = Converting an existing Case Management-based register to the"
 S DIR("A",7)="      IHS Diabetes Register, renaming your register and adding "
 S DIR("A",8)="      diagnoses and complications included in the IHS standard."
 S DIR("A",9)="  "
 S DIR("A",10)="Answer NO if you have an existing Diabetes Register."
 S DIR("A",11)="Answer YES if want the IHS National Diabetes Register installed."
 S DIR("A",12)="  "
 S DIR(0)="YO",DIR("A")="Shall I install the IHS National Register",DIR("B")="NO"
 W !
 S ACMQ=0 D ^DIR K DIR
 S:Y["^" ACMQ=1 Q:ACMQ  I Y=1 D ADDR
 D:ACMQ END Q:ACMQ  D CHGR
 Q
ADDR ;ADDS IHS DIABETES REGISTER
 S DIR(0)="YO",DIR("A")="Are you sure you want me to install the IHS National Register",DIR("B")="YES"
 W !
 D ^DIR K DIR
 Q:Y=""!(Y["^")  I Y=1 D REG^ACMRGA01 S ACMQ=1
 Q
 ;
CHGR ;CHANGES EXISTING REGISTER AND ADDS ELEMENTS,DIAG,COMP
 W:$D(IOF) @IOF
 W !!!,"   Converting existing register to IHS National Diabetes Register",!
 W !,"This option will quide you through the following:"
 W !,"  1 = Renaming your local register to the IHS National Diabetes Register"
 W !,"  2 = Adding elements, diagnoses, and complications included",!,"      in the IHS standard to your converted register."
 W !!,"Enter the name of your existing local register you want converted:  ",! S DIC(0)="AQEM" D RGTPX^ACMGTP
 Q:+Y<1  S ACMRG=+Y,ACMRGNA=$P(Y,U,2),ACMQ=0
 S DIR(0)="YO",DIR("A")="Shall I rename "_ACMRGNA_" to IHS DIABETES Register",DIR("B")="NO"
 W !
 D ^DIR K DIR
 S:Y["^" ACMQ=1 Q:ACMQ  I Y=1 D CHGN
 D CHGE
 Q:ACMQ  D CHGD
 Q:ACMQ  D CHGC
 Q:ACMQ  D CDIAG^ACMADDM1
 Q:ACMQ  D CCOMP^ACMADDM1
 W !,"Finished.." D END Q
 ;
CHGN ;RENAME REGISTER
 S DIE="^ACM(41.1,",DA=ACMRG,ACMRGNA=$P(^ACM(41.1,DA,0),U,1),DR=".01///IHS DIABETES" D ^DIE K DA,DR
 F ACMI=42,43,44,45,46,47,48,51,53,54 S ACMGREF="^ACM("_ACMI_")" S DA=0 F  S DA=$O(@ACMGREF@("F",ACMRGNA,DA)) Q:'DA  W "." S DIE="^ACM("_ACMI_",",DR=".05///^S X=""IHS DIABETES""" D ^DIE
 K DIE,DIC,DA S ACMRGNA="IHS DIABETES"
 S DIE="^ACM(41,",DR=".05///^S X=ACMRGNA",ACMX=0 F  S ACMX=$O(^ACM(41,"B",ACMRG,ACMX)) Q:+ACMX=0  S DA=ACMX D ^DIE W "."
 W !,"The register has been renamed to IHS DIABETES.." Q
 ;
CHGE S DIR(0)="YO",DIR("A")="Shall I check/add the proper elements to the register",DIR("B")="YES"
 W ! D ^DIR K DIR S:Y["^" ACMQ=1 Q:Y=0!(Y["^")  I Y=1 D SETE^ACMRGA01
 Q
 ;
CHGD S DIR(0)="YO",DIR("A")="Shall I check/add the proper diagnoses to the register",DIR("B")="YES"
 W ! D ^DIR K DIR S:Y["^" ACMQ=1 Q:Y=0!(Y["^")  I Y=1 D SETD^ACMRGA01
 Q
 ;
CHGC S DIR(0)="YO",DIR("A")="Shall I check/add the proper complications to the register",DIR("B")="YES"
 W ! D ^DIR K DIR S:Y["^" ACMQ=1 Q:Y=0!(Y["^")  I Y=1 D SETC^ACMRGA01
 Q
 ;
END ;CLEANUP
 K ACMRG,ACMRGNA,DA,DIC,DIE,DIR,DR
 Q
 ;
XDX ;EP;TO ELIMINATE DUPLICATE DM DIAGNOSES.
 N X,Y,DA,DIE,DR,DIK,ACMXX,ACMPDA,ACMPRIM
 F ACMXX="TYPE 1","TYPE 2","GESTATIONAL DM","IMPAIRED GLUCOSE TOLERANCE" D XDX1
 Q
XDX1 S ACMPRIM=0
 S ACMPDA=0
 F  S ACMPDA=$O(^ACM(44.1,"B",ACMXX,ACMPDA)) Q:'ACMPDA  D
 .I $D(^ACM(44,"B",ACMPDA)),'$G(ACMPRIM) S ACMPRIM=ACMPDA Q
 Q:'ACMPRIM
 S ACMPDA=0
 F  S ACMPDA=$O(^ACM(44.1,"B",ACMXX,ACMPDA)) Q:'ACMPDA  D
 .W !!,"ACMXX: ",ACMXX," IEN: ",ACMPDA
 .Q:ACMPDA=ACMPRIM
 .S DA=0
 .F  S DA=$O(^ACM(44.3,"B",ACMPDA,DA)) Q:'DA  D
 ..S DR=".01////"_ACMPRIM
 ..S DIE="^ACM(44.3,"
 ..D ^DIE
 ..W !,"Patient DX Intervention entry ",DA," Changed from ",ACMXX," IEN: ",ACMPDA," to ",ACMXX," IEN: ",ACMPRIM
 .S DA=0
 .F  S DA=$O(^ACM(44,"B",ACMPDA,DA)) Q:'DA  D
 ..S DR=".01////"_ACMPRIM
 ..S DIE="^ACM(44,"
 ..D ^DIE
 ..W !,"Patient DX entry ",DA," Changed from ",ACMXX," IEN: ",ACMPDA," to ",ACMXX," IEN: ",ACMPRIM
 .S DA=ACMPDA
 .S DIK="^ACM(44.1,"
 .D ^DIK
 .W !,"Diagnosis list entry for ",ACMXX,", IEN: ",DA," deleted."
 Q
