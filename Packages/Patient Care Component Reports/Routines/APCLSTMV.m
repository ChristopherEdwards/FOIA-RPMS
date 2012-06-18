APCLSTMV ; IHS/CMI/LAB - CREATE SEARCH TEMPLATE FOR VGEN (VISITS) REPORTS ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
EN ;EP - ENTRY POINT
 D EN1
EXIT K APCLSDIC,APCLSNAM,APCLSTN,DHD
 Q
EN1 ;EP Help Text
 K APCLQUIT
 W !
 W ?10,"*** You may enter an existing Template Name ***",! W ?30,"OR",! W ?12,"*** Save results in a  New Template ***",! W ?30,"OR",! W ?25,"'^' to Exit",!!
 ;
EN2 K DIC,DLAYGO S DLAYGO=.401,DIC="^DIBT(",DIC(0)="AELMQZ",DIC("A")="Visit Search Template: ",DIC("S")="I $P(^(0),U,4)=9000010&($P(^(0),U,5)=DUZ)"
 W !
 D ^DIC K DLAYGO,DIC
 I +Y<1 W !!,"No Search Template selected." H 2 S APCLQUIT=1 Q
 S APCLSTMP=+Y,APCLSNAM=$P(^DIBT(APCLSTMP,0),U)
DUP I '$P(Y,U,3) D  I Q K APCLSTMP,Y G EN2
 .S Q=""
 .W !!,$C(7),$C(7)
 .S DIR(0)="Y",DIR("A")="That template already exists!!  Do you want to overwrite it",DIR("B")="N" K DA D ^DIR K DIR
 .I $D(DIRUT) S Q=1 Q
 .I 'Y S Q=1 Q
 .L +^DIBT(APCLSTMP):10
 .S APCLSTN=$P(^DIBT(APCLSTMP,0),U) S DA=APCLSTMP,DIK="^DIBT(" D ^DIK
 .S ^DIBT(APCLSTMP,0)=APCLSNAM,DA=APCLSTMP,DIK="^DIBT(" D IX1^DIK
 .L -^DIBT(APCLSTMP)
 .Q
 I APCLSTMP,$D(^DIBT(APCLSTMP)) D
 .W !!,?5,"A VISIT list resulting from this report",!,?5,"will be stored in the.........>",!!?18,"**  ",APCLSNAM,"  ** Search Template."
 .K ^DIBT(APCLSTMP,1)
 .S DHIT="S ^DIBT("_APCLSTMP_",1,DFN)="""""
 .S DIE="^DIBT(",DA=APCLSTMP,DR="2////"_DT_";3////M;4////9000010;5////"_DUZ_";6////M"
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
 S APCLSRTV=""
 F  S APCLSRTV=$O(^XTMP("APCLVL",APCLJOB,APCLBTH,"DATA HITS",APCLSRTV)) Q:APCLSRTV=""  D NEXT
 Q
 ;
NEXT ;2ND $ORDER
 S APCLVDFN=0 F  S APCLVDFN=$O(^XTMP("APCLVL",APCLJOB,APCLBTH,"DATA HITS",APCLSRTV,APCLVDFN)) Q:APCLVDFN'=+APCLVDFN  D
 .S ^DIBT(APCLSTMP,1,APCLVDFN)=""""
 .Q
 Q
