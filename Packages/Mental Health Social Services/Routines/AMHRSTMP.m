AMHRSTMP ; IHS/CMI/LAB - CREATE SEARCH TEMPLATE FOR REPORTS ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
EN ;EP - ENTRY POINT
 D EN1
EXIT K AMHRSDIC,AMHRSNAM,AMHRSTN,DHD
 Q
EN1 ;EP Help
 K AMHRQUIT
 W !
 W ?10,"*** You may enter an existing Template Name ***",! W ?30,"OR",! W ?12,"*** Save results in a  New Template ***",! W ?30,"OR",! W ?25,"'^' to Exit",!!
EN2 K DIC,DLAYGO S DLAYGO=.401,DIC="^DIBT(",DIC(0)="AELMQZ",DIC("A")="Patient Search Template: ",DIC("S")="I $P(^(0),U,4)=9000001&($P(^(0),U,5)=DUZ)"
 W !
 D ^DIC K DIC,DLAYGO
 I +Y<1 W !!,"No Search Template selected." H 2 S AMHRQUIT=1 Q
 S AMHRSTMP=+Y,AMHRSNAM=$P(^DIBT(AMHRSTMP,0),U)
DUP I '$P(Y,U,3) D  I Q K AMHRSTMP,Y G EN2
 .S Q=""
 .W !!,$C(7),$C(7)
 .S DIR(0)="Y",DIR("A")="That template already exists!!  Do you want to overwrite it",DIR("B")="N" K DA D ^DIR K DIR
 .I $D(DIRUT) S Q=1 Q
 .I 'Y S Q=1 Q
 .L +^DIBT(AMHRSTMP):10
 .S AMHRSTN=$P(^DIBT(AMHRSTMP,0),U) S DA=AMHRSTMP,DIK="^DIBT(" D ^DIK
 .S ^DIBT(AMHRSTMP,0)=AMHRSNAM,DA=AMHRSTMP,DIK="^DIBT(" D IX1^DIK
 .L -^DIBT(AMHRSTMP)
 .Q
 I AMHRSTMP,$D(^DIBT(AMHRSTMP)) D
 .W !!,?5,"An unduplicated PATIENT list resulting from this report",!,?5,"will be stored in the.........>",!!?18,"**  ",AMHRSNAM,"  ** Search Template."
 .K ^DIBT(AMHRSTMP,1)
 .S DHIT="S ^DIBT("_AMHRSTMP_",1,DFN)="""""
 .S DIE="^DIBT(",DA=AMHRSTMP,DR="2////"_DT_";3////M;4////9000001;5////"_DUZ_";6////M"
 .D ^DIE
 .K DIE,DA,DR
 Q
