ACMSTMP ; IHS/TUCSON/TMJ - CREATE SEARCH TEMPLATE FOR CMS REPORTS ;
 ;;2.0;ACM CASE MANAGEMENT SYSTEM;;JAN 10, 1996
 ;;Routine added for Patch 2
 ;EP;ENTRY POINT
EN D EN1
EXIT K ACMSDIC,ACMSNAM,ACMSTN,DHD
 Q
EN1 S DIR(0)="YO",DIR("A")="Store Report Result as Search Template",DIR("B")="NO"
 W !
 D ^DIR
 K DIR
 Q:Y'=1
EN2 S DIC="^DIBT(",DIC(0)="AELMQZ",DIC("A")="Search Template: ",DIC("S")="I $P(^(0),U,4)=9000001&($P(^(0),U,5)=DUZ)"
 W !
 D ^DIC
 I +Y<1 W !!,"No Search Template selected." H 2 Q
 S ACMSTMP=+Y,ACMSNAM=$P(^DIBT(ACMSTMP,0),U)
DUP I '$P(Y,U,3) D  I Q K ACMSTMP,Y G EN2
 .S Q=""
 .W !!,$C(7),$C(7)
 .S DIR(0)="Y",DIR("A")="That template already exists!!  Do you want to overwrite it",DIR("B")="N" K DA D ^DIR K DIR
 .I $D(DIRUT) S Q=1 Q
 .I 'Y S Q=1 Q
 .L +^DIBT(ACMSTMP):10
 .S ACMSTN=$P(^DIBT(ACMSTMP,0),U) S DA=ACMSTMP,DIK="^DIBT(" D ^DIK
 .S ^DIBT(ACMSTMP,0)=ACMSNAM,DA=ACMSTMP,DIK="^DIBT(" D IX1^DIK
 .L -^DIBT(ACMSTMP)
 .Q
 I ACMSTMP,$D(^DIBT(ACMSTMP)) D
 .W !!,?5,"An unduplicated patient list resulting from this report",!,?5,"will be stored in the.........>",!!?18,"**  ",ACMSNAM,"  ** Search Template."
 .K ^DIBT(ACMSTMP,1)
 .S DHIT="S ^DIBT("_ACMSTMP_",1,$P("_ACMDIC_"D0,0),U,2))="""""
 .S DIE="^DIBT(",DA=ACMSTMP,DR="2////"_DT_";3////M;4////9000001;5////"_DUZ_";6////M"
 .D ^DIE
 .K DIE,DA,DR
 ;Q
 ;Run Template in Background Mode
 ;
BACK ;
 S DHD="W ?0 D HDR^ACMSTMP",FLDS="!.01"
 W !!,"A brief report will be printed after the search template is complete.",!,"You must enter a device for this report OR you may queue at this time.",!
 Q
HDR ;
 W !!,?15,"***CASE MANAGEMENT SYSTEM, SEARCH TEMPLATE CREATION***"
 W !!,?1,"Template Created: ",$P(^DIBT(ACMSTMP,0),U)
 W !,?1,"Created by:  ",$P(^VA(200,DUZ,0),U)
 W !,"------------------------------------------------------------------------------",!
 Q
