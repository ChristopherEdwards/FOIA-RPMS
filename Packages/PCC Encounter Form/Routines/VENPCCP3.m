VENPCCP3 ; IHS/OIT/GIS - PRINT DEAMON - MANAGE ERRORS, MISC. ASMU OPTIONS ; 
 ;;2.6;PCC+;**1,3**;APR 03, 2012;Build 24
 ;
 ; DEAD CODE IN 2.5
 ;
CLEAN ; EP-CLEAN OUT OLD Z FILES FROM THE PRINT DIRECTORY
 I $G(CFIGIEN),$L($G(PATH)),$G(DT)
 E  Q
 I $P($G(^VEN(7.5,CFIGIEN,0)),U,22)=DT Q  ; CLEANUP ALREADY COMPLETED
 N TMP,FILE,EIEN,%,DA,DR,DIE
 S TMP="^TMP(""VEN Z CLEAN"","""_$J_""")"
 D FILES^VENPCCP2(PATH,TMP)
 S FILE="z" F  S FILE=$O(@TMP@(FILE)) Q:'$L(FILE)  D
 . I $E(FILE)'="z" Q
 . S EIEN=$O(^VEN(7.7,"F",FILE,0))
 . I 'EIEN D DEL^VENPCCP1(PATH,FILE) Q  ; DELETE ALL Z FILES NOT ENERTERED IN ERROR LOG
 . S %=$P($G(^VEN(7.7,EIEN,0)),U)
 . I %'=DT D DEL^VENPCCP1(PATH,FILE) ; DELETE OLD Z FILES
 . Q
 K @TMP
 S DIE="^VEN(7.5,",DA=CFIGIEN,DR=".22////"_DT L +^VEN(7.5,DA):0 I $T D ^DIE L -^VEN(7.5,DA)
 D ^XBFMK
 Q
 ; 
PATCH ; EP-PATCH VENPCCP & VENPCC TO INCLUDE NEW ERROR MANAGEMENT UTILITIES
 W !,"Patch option has been disabled.  Request terminated..." Q
 Q
 ; 
UNPATCH ; EP-REMOVE ERROR MANAGEMENT PATCHES FROM VENPCCP AND VENPCC 
 W !,"Un-patch option has been disabled.  Request terminated..." Q
 Q
 ; 
ELOG ; EP-PRINT ERROR LOG
 N BY,FR,TO,FLDS,DIC,POP
 S BY="+PRINT GROUP,@TIMESTAMP",(TO,FR)=",?",FLDS="[VENE ERROR LIST",DIC="^VEN(7.7,"
 D EN1^DIP
 Q
 ; 
BLOCK(TYPE) ; EP-BLOCK A CLINIC FOR REPAIRS
 I '$L(TYPE) Q
 N DIC,X,Y,DIE,DA,DR
 S DIC("A")=$S(TYPE=1:"Stop",1:"Resume")_" printing PCC+ forms at what clinic: "
 S DIC="^VEN(7.95,",DIC(0)="AEQ" D ^DIC I Y=-1 Q
 S DIE=DIC,DA=+Y,DR="2.15////"_TYPE
 L +^VEN(7.95,DA):0 I $T D ^DIE L -^VEN(7.95,DA)
 D ^XBFMK
 W !,"PCC+ forms will "_$S(TYPE:"not",1:"now")_" be printed at this clinic",!!
 Q
 ;
MAX ; EP-SET THE MAXIMUM NUMBER OF "z" FILES FOR A CLINIC
 N DIC,X,Y,DIE,DA,DR,MAX,A,B
 S DIC("A")="Clinic name: "
 S DIC="^VEN(7.95,",DIC(0)="AEQ" D ^DIC I Y=-1 Q
 S DA=+Y,B=$P($G(^VEN(7.95,DA,2)),U,14) I B="" S B=20
 S A="Maximum number of 'z' files allowed for this clinic"
 S MAX=$$DIR^XBDIR("N^0:999:0",A,B)
 I MAX?1."^" D ^XBFMK Q
 S DIE=DIC,DR="2.14////^S X=MAX"
 L +^VEN(7.95,DA):0 I $T D ^DIE L -^VEN(7.95,DA)
 D ^XBFMK
 W !,"For this clinic, A maximum of ",MAX," 'z' files will be allowed in the print folder.",!!
 Q
 ;
CLN(TYPE) ; EP-TURN AUTO-CLEANUP ON/OFF
 N DIE,DA,DR,X,Y,%
 W !,"Want to turn ",$S(TYPE:"on",1:"off")," the auto cleanup feature for the PRINT folder"
 S %="" D YN^DICN I %'=1 Q
 S DA=$$CFG^VENPCCU I 'DA Q
 S DIE="^VEN(7.5,",DR=".21////^S X=TYPE" L +^VEN(7.5,DA):0 I $T D ^DIE L -^VEN(7.5,DA)
 D ^XBFMK
 Q
 ; 
CLNYES ; EP-TURN ON AUTO CLEANUP
 D CLN(1) Q
 ; 
CLNNO ; EP-TURN OFF AUTO CLEANUP
 D CLN(0) Q
 ;
DV ; EP - DELETE A TEST VISIT, ASSOCIATED TEST V FILE ENTRIES, AND ASSOCIATED VEN QUEUE ENTRY
 D GETPAT^APCDVDEL
 I APCDPAT="" W !!,"No PATIENT selected!" D EOJ Q
 D GETVISIT^APCDVDEL
 I APCDVSIT="" W !!,"No VISIT selected!" D EOJ Q
 D DSPLY^APCDVDEL
 D DELETE^APCDVDEL
 N DA,DIK S DA=$O(^VEN(7.2,"AV",APCDVSIT,0))
 I DA S DIK="^VEN(7.2," D ^DIK ; CLEAN UP QUEUE FILE
EOJ D EOJ^APCDVDEL
 Q
 ;
BLOCKON ; EP-BLOCK PCC+ DOCUMENT GENERATION FOR A SPECIFIC CLINIC
 D BLOCK(1) Q
 ;
BLOCKOFF ; EP-DON'T BLOCK PCC+ DOCUMENT GENERATION FOR A SPECIFIC CLINIC
 D BLOCK(0) Q
 ; 
HE ; EP-ERROR HELPER
 N DIC,X,Y
 S DIC="^VEN(7.71,",DIC(0)="AEQM",DIC("A")="Enter error name or number: " D ^DIC I Y=-1 Q
 S BY="ERROR NUMBER="_+Y,FLDS="[VENE ERROR HELPER",DHD="W ""PCC+ ERROR RESOLUTION"",!,""---------------------------""" D EN1^DIP
 Q
 ; 
IP ; EP - RESET IP ADDRESSSES FOR THE PRINT SERVERS
 N CFIGIEN,DIC,DIE,DA,DR,X,Y,IP1,IP2,IP4,IP5
 S DA=$$CFG^VENPCCU,X=$G(^VEN(7.5,+DA,11))
 S IP1=$P(X,U) I '$L(X) Q
 S IP2=$P(X,U,2) I '$L(IP2) S IP2=IP1
 S IP4=$P(X,U,4),IP5=$P(X,U,5)
 I IP1=IP2,'$L(IP4) W !,"Both Print Servers already have the same IP address!  Request denied..." H 3 Q
 I IP1=IP2 W !,"Want to reactivate both print servers" S %=1 D YN^DICN Q:%'=1  S DR="11.1////"_IP4_";11.2////"_IP5_";11.4///@;11.5///@" D IPDIE Q
 S DIR(0)="SX^1:Shut down Print Server #1;2:Shut down Print Server #2;3:Quit"
 S DIR("A")="Select an action:"
 D ^DIR K DIR
 I Y=1 S DR="11.1////"_IP2_";11.4////"_IP1_";11.5////"_IP2 D IPDIE Q
 I Y=2 S DR="11.2////"_IP1_";11.4////"_IP1_";11.5////"_IP2 D IPDIE Q
 Q
 ;
IPDIE S DIE=19707.5
 L +^VEN(7.5,DA):0 I $T D ^DIE L -^VEN(7.5,DA)
 D KILLTASK^VENPCCP
 W !,"Resetting the Print Server IP addresses.  Please wait..." H 5
 I $$MSG^VENPCCMX(0)
 D ^XBFMK
 Q
 ; 
