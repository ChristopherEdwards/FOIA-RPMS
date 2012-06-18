ACMOPTDM ; IHS/TUCSON/TMJ - CREATES OPTION FOR DIABETES REG INSTALL ;
 ;;2.0;ACM CASE MANAGEMENT SYSTEM;;JAN 10, 1996
 ;;CREATES THE NATIONAL IHS DIABETES INSTALL OPTION
 ;;ADDS THE OPTION TO THE ACMMENU OPTION
 ;
 W:$D(IOF) @IOF
 I '$D(DUZ) W !,"You MUST log in as an user before running this routine..." Q
 I '$D(^DIC(19,"B","ACMMENU")) W !,"You do not have an option called 'ACM MANAGER UTILITIES'",!,"This option cannot be installed!" Q
 I $D(^DIC(19,"B","ACM INSTALL IHS DIABETES REGIS")) W !,"You already have an option called 'ACM INSTALL IHS DIABETES REGISTER'",!,"This option cannot be installed!" Q
 S DIR("A",1)="      IHS National Diabetes Register Menu Installation"
 S DIR("A",2)="  "
 S DIR("A",3)="This option will install the following:"
 S DIR("A",4)="  1 = Install the Menu Option 'ACM INSTALL IHS DIABETES REGISTER'"
 S DIR("A",5)="  2 = Assign the 'ACMZ MANAGER' security key to the option."
 S DIR("A",6)="  3 = Add the option to the 'ACMMENU' option."
 S DIR("A",7)="  "
 S DIR("A",9)="Answer YES if want the ACM Menu Options installed."
 S DIR("A",10)="  "
 S DIR(0)="YO",DIR("A")="Shall I install the option",DIR("B")="NO"
 W ! D ^DIR K DIR I Y=1 D ADDOPT
 K ACMM,ACMRG,ACMY,ACMF,ACMX
 Q
ADDOPT ;ADDS IHS DIABETES REGISTER OPTION
 S ACMRG=$T(ACMOPT+1),ACMRG=$P(ACMRG,";;",3)
 W !!,"Option:  ",ACMRG," is being added...",!!
 S X=ACMRG,DIC="^DIC(19,",DIC(0)="LX" K DD,DA D FILE^DICN Q:+Y<1  S ACMRG=+Y K DIC,DA,DD
 F I=2:1 S ACMF=$T(ACMOPT+I) Q:ACMF["*"  S ACMF($P(ACMF,";;",2))=$P(ACMF,";;",3)
 S ACMX=0 F  S ACMX=$O(ACMF(ACMX)) Q:ACMX=""  S ACMY=0,ACMY=$O(^DD(19,"B",ACMX,ACMY)) I +ACMY S $P(ACMF(ACMX),U,2)=+ACMY
 S (DR,ACMX)="" F  S ACMX=$O(ACMF(ACMX)) Q:ACMX=""  S ACMY=ACMF(ACMX) I $L($P(ACMY,U,1))&(+$P(ACMY,U,2)) S DR=DR_$P(ACMY,U,2)_"///"_$P(ACMY,U,1)_";"
 I $L(DR) S DR=$E(DR,1,$L(DR)-1)
 S DA=ACMRG,DIE="^DIC(19," D ^DIE S $P(^ACM(41.1,ACMRG,0),U,12)=1 K DIC,DIE,DA,DR
 ;
ADDMENU ;ADDS IHS DIABETES REGISTER OPTION TO ACMMENU MENU
 S ACMM=ACMRG,ACMRG=$T(ACMMENU+1),ACMRG=$P(ACMRG,";;",3)
 W !!,"Option is being added to ",ACMRG,"...",!!
 S X=ACMRG,DIC="^DIC(19,",DIC(0)="L" D ^DIC Q:+Y<1  S ACMRG=+Y K DIC,DA,DD
 K DD,DO S X=ACMM,DIC="^DIC(19,"_ACMRG_",10,",DIC(0)="LX",DA(1)=ACMRG D FILE^DICN K DIC,DA,DD
 W !!,"Finished...",!!
END K ACMM,ACMRG,ACMY,ACMF,ACMX,ACMQ
 Q
ACMOPT ;;
 ;;NAME;;ACM INSTALL IHS DIABETES REGIS
 ;;MENU TEXT;;Install IHS Diabetes Register
 ;;LOCK;;ACMZ MANAGER
 ;;CREATOR;;POSTMASTER
 ;;TYPE;;R
 ;;PACKAGE;;ACM CASE MANAGEMENT SYSTEM
 ;;ROUTINE;;ACMADDM
 ;;*
ACMMENU ;;
 ;;NAME;;ACMMENU
 ;;*
