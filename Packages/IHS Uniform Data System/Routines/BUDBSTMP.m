BUDBSTMP ; IHS/CMI/LAB - CREATE SEARCH TEMPLATE FOR PGEN (PATIENT) REPORTS ;
 ;;10.0;IHS/RPMS UNIFORM DATA SYSTEM;;FEB 04, 2016;Build 50
 ;
EN ;EP - ENTRY POINT
 D EN1
EXIT K BUDSDIC,BUDSNAM,BUDSTN,DHD
 Q
EN1 ;EP Help
 K BUDQUIT
 W !!,"* You may enter an existing Template Name or Save results in a New Template *"
EN2 K DIC,DLAYGO S DLAYGO=.401,DIC="^DIBT(",DIC(0)="AELMQZ",DIC("A")="Patient Search Template: ",DIC("S")="I $P(^(0),U,4)=9000001!($P(^(0),U,4)=2)&($P(^(0),U,5)=DUZ)"
 W !
 D ^DIC K DIC,DLAYGO
 I +Y<1 W !!,"No Search Template selected." H 2 S BUDQUIT=1 Q
 S BUDSTMP=+Y,BUDSNAM=$P(^DIBT(BUDSTMP,0),U)
DUP I '$P(Y,U,3) D  I Q K BUDSTMP,Y G EN2
 .S Q=""
 .W !!,$C(7),$C(7)
 .S DIR(0)="Y",DIR("A")="That template already exists!!  Do you want to overwrite it",DIR("B")="N" K DA D ^DIR K DIR
 .I $D(DIRUT) S Q=1 Q
 .I 'Y S Q=1 Q
 .L +^DIBT(BUDSTMP):10
 .S BUDSTN=$P(^DIBT(BUDSTMP,0),U) S DA=BUDSTMP,DIK="^DIBT(" D ^DIK
 .S ^DIBT(BUDSTMP,0)=BUDSNAM,DA=BUDSTMP,DIK="^DIBT(" D IX1^DIK
 .L -^DIBT(BUDSTMP)
 .Q
 I BUDSTMP,$D(^DIBT(BUDSTMP)) D
 .W !!,?5,"An unduplicated PATIENT list resulting from this report",!,?5,"will be stored in the ",BUDSNAM," Search Template."
 .K ^DIBT(BUDSTMP,1)
 .S DHIT="S ^DIBT("_BUDSTMP_",1,DFN)="""""
 .S DIE="^DIBT(",DA=BUDSTMP,DR="2////"_DT_";3////M;4////9000001;5////"_DUZ_";6////M"
 .D ^DIE
 .K DIE,DA,DR
 ;Q
 ;Run Template in Background Mode
 ;
 ;
 Q
 ;
SETRECS ;EP - Set Entries into Template
 ;
 S BUDDFN=0 F  S BUDDFN=$O(^XTMP("BUDVL",BUDJOB,BUDBTH,"PATIENTS",BUDDFN)) Q:BUDDFN'=+BUDDFN  D
 .I '$D(^XTMP("BUDVL",BUDJOB,BUDBTH)) W !!,"NO DATA TO REPORT.",! D PAUSE^BUDBUPVL W:$D(IOF) @IOF
 .S ^DIBT(BUDSTMP,1,BUDDFN)=""""
 Q
