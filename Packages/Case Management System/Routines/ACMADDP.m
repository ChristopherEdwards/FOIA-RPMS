ACMADDP ; IHS/TUCSON/TMJ - ADD PRE-DIABETES REGISTER ; [ 11/01/05  3:21 PM ]
 ;;2.0;ACM CASE MANAGEMENT SYSTEM;*6*;JAN 10, 1996
 ;EP CALLED FROM AN OPTION
 ;IHS/CMI/TMJ PATCH #6 - INSTALL NEW PRE-DIABETES REGISTER
 ;This Driver routine allows the user to convert an existing
 ;Pre-Diabetes Register, or add the IHS National Pre-Diabetes Register
 ;to the Case Management Package
 ;DRIVER ROUTINE:  ACMADDP
 ;CALLED ROUTINES: ACMRGA02 - ACMADDM2
 ;
 ;
 W:$D(IOF) @IOF
 I $D(^ACM(41.1,"B","IHS PRE-DIABETES")) W !,"You already have a register called 'IHS PRE-DIABETES'",!,"This option cannot be run!" D INFORM Q
 S DIR("A",1)="      IHS National Pre-Diabetes Register Installation"
 S DIR("A",2)="  "
 S DIR("A",3)="This option will quide you through the following:"
 S DIR("A",4)="  1 = Installing the IHS National Pre-Diabetes Register"
 S DIR("A",5)="      if you curently are not using a Pre-Diabetes Register."
 S DIR("A",6)="  2 = Converting an existing Case Management-based register to the"
 S DIR("A",7)="      IHS Pre-Diabetes Register, renaming your register and adding "
 S DIR("A",8)="      diagnoses and complications included in the IHS standard."
 S DIR("A",9)="  "
 S DIR("A",10)="Answer NO if you have an existing Pre-Diabetes Register."
 S DIR("A",11)="Answer YES if want the IHS National Pre-Diabetes Register installed."
 S DIR("A",12)="  "
 S DIR(0)="YO",DIR("A")="Shall I install the IHS National Pre-Diabetes Register",DIR("B")="NO"
 W !
 S ACMQ=0 D ^DIR K DIR
 S:Y["^" ACMQ=1 Q:ACMQ  I Y=1 D ADDR
 D:ACMQ END Q:ACMQ  D CHGR
 Q
ADDR ;ADDS IHS PRE-DIABETES REGISTER
 S DIR(0)="YO",DIR("A")="Are you sure you want me to install the IHS National Pre-Diabetes Register",DIR("B")="YES"
 W !
 D ^DIR K DIR
 Q:Y=""!(Y["^")  I Y=1 D REG^ACMRGA02 S ACMQ=1
 Q
 ;
CHGR ;CHANGES EXISTING REGISTER AND ADDS ELEMENTS,DIAG,COMP,RISK,DXCRIT
 W:$D(IOF) @IOF
 W !!!,"   Converting existing register to IHS National Pre-Diabetes Register",!
 W !,"This option will quide you through the following:"
 W !,"  1 = Renaming your local register to the IHS National Pre-Diabetes Register"
 W !,"  2 = Adding elements, diagnoses, complications, Diagnostic Criteria, and Risk Factors included",!,"      in the IHS standard to your converted register."
 W !!,"Enter the name of your existing local register you want converted:  ",! S DIC(0)="AQEM" D RGTPX^ACMGTP
 S ACMRG=$G(DA)
 I ACMRG="" W !,"No Register Selected" Q
 ;
 ;Q:+Y<1  S ACMRG=+Y,ACMRGNA=$P(Y,U,2),ACMQ=0
 S ACMRGNA=$P(^ACM(41.1,ACMRG,0),U,1)
 W ACMRGNA
 S DIR(0)="YO",DIR("A")="Shall I rename "_ACMRGNA_" to IHS PRE-DIABETES Register",DIR("B")="NO"
 W !
 D ^DIR K DIR
 S:Y["^" ACMQ=1 Q:ACMQ  I Y=1 D CHGN
 D CHGE
 Q:ACMQ  D CHGD
 Q:ACMQ  D CHGC
 Q:ACMQ  D CHGRF
 Q:ACMQ  D CHGDC
 Q:ACMQ  D CDIAG^ACMADDM2
 Q:ACMQ  D CCOMP^ACMADDM2
 Q:ACMQ  D CRISK^ACMADDM2
 Q:ACMQ  D CDXCR^ACMADDM2
 W !,"Finished.." D END Q
 ;
CHGN ;RENAME REGISTER
 S DIE="^ACM(41.1,",DA=ACMRG,ACMRGNA=$P(^ACM(41.1,DA,0),U,1),DR=".01///IHS PRE-DIABETES" D ^DIE K DA,DR
 F ACMI=42,43,44,45,46,47,48,51,53,54 S ACMGREF="^ACM("_ACMI_")" S DA=0 F  S DA=$O(@ACMGREF@("F",ACMRGNA,DA)) Q:'DA  W "." S DIE="^ACM("_ACMI_",",DR=".05///^S X=""IHS PRE-DIABETES""" D ^DIE
 K DIE,DIC,DA S ACMRGNA="IHS PRE-DIABETES"
 S DIE="^ACM(41,",DR=".05///^S X=ACMRGNA",ACMX=0 F  S ACMX=$O(^ACM(41,"B",ACMRG,ACMX)) Q:+ACMX=0  S DA=ACMX D ^DIE W "."
 W !,"The register has been renamed to IHS PRE-DIABETES.." Q
 ;
CHGE S DIR(0)="YO",DIR("A")="Shall I check/add the proper elements to the register",DIR("B")="YES"
 W ! D ^DIR K DIR S:Y["^" ACMQ=1 Q:Y=0!(Y["^")  I Y=1 D SETE^ACMRGA02
 Q
 ;
CHGD S DIR(0)="YO",DIR("A")="Shall I check/add the proper diagnoses to the register",DIR("B")="YES"
 W ! D ^DIR K DIR S:Y["^" ACMQ=1 Q:Y=0!(Y["^")  I Y=1 D SETD^ACMRGA02
 Q
 ;
CHGC S DIR(0)="YO",DIR("A")="Shall I check/add the proper complications to the register",DIR("B")="YES"
 W ! D ^DIR K DIR S:Y["^" ACMQ=1 Q:Y=0!(Y["^")  I Y=1 D SETC^ACMRGA02
 Q
CHGRF S DIR(0)="YO",DIR("A")="Shall I check/add the proper Risk Factors to the register",DIR("B")="YES"
 W ! D ^DIR K DIR S:Y["^" ACMQ=1 Q:Y=0!(Y["^")  I Y=1 D SETR^ACMRGA02
 Q
 ;
CHGDC S DIR(0)="YO",DIR("A")="Shall I check/add the proper Diagnostic Criteria to the register",DIR("B")="YES"
 W ! D ^DIR K DIR S:Y["^" ACMQ=1 Q:Y=0!(Y["^")  I Y=1 D SETDC^ACMRGA02
 Q
 ;
INFORM ;Install Information Text
 ;
 W !!,"You must first re-name your existing Register called IHS PRE-DIABETES to",!
 W "OLD IHS PRE-DIABETES and then run the Install and convert the OLD Register",!
 W "to the new Register.  Be sure to add any new Users to the new Register.",!
 Q
END ;CLEANUP
 K ACMRG,ACMRGNA,DA,DIC,DIE,DIR,DR
 Q
 ;
