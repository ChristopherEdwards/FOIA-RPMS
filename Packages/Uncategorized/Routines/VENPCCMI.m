VENPCCMI ; IHS/OIT/GIS - INSTALLATION UTILITIES FOR ENCOUNTER FORMS AND PRINTER GROUPS ;
 ;;2.6;PCC+;;NOV 12, 2007
 ;
 ;
 ; 
PG ; EP-PRINTER GROUP ENTRY ; EP FROM OPTION FILE
 N CFLG
 D ^XBCLS,PGL
 W !!,"Enter the name of a new Print Group in the format LOCATION_DEPARTMENT",!,"Examples: GIMC_PEDIATRICS, CROW_DENTAL, etc.",!
 N DIC,DIE,DA,DR,D,D0,DIG,DIH,X,Y,%,DUOUT,DTOUT
 S (DIC,DIE)="^VEN(7.4,",DLAYGO=19707.4,DIC(0)="AEQL",DIC("A")="Print group: "
 D ^DIC I Y=-1 Q
 S DA=+Y,DR=".02T//NO;1"
 L +^VEN(7.4,DA):0 I $T D ^DIE L -^VEN(7.4,DA)
 D PG^VENPCCMC(.CFLG) ; CHECK ALL PRINT GROUPS
 Q
 ; 
PGL ; EP-PRINTER GROUP LISTER ; EP FROM OPTION FILE
 N DIC,X,Y,%,BY,FR,TO,DHD,L,IOP
 S DIC="^VEN(7.4,",L=0,BY=.01,FR="",TO="",FLDS="[VEN MASTER PRINTER LIST]",DHD="PCC+ PRINT GROUPS",IOP="HOME"
 D EN1^DIP
 Q
 ;
EFL ; EP-ENCOUNTER FORM LIST ; EP FROM OPTION FILE
 N DIC,X,Y,%,BY,FR,TO,DHD,L,IOP
 S DIC="^VEN(7.41,",L=0,BY=.01,FR="",TO="",FLDS="[VEN EF TEMPLATES LIST]",DHD="PCC+ ENCOUNTER FORMS",IOP="HOME"
 D EN1^DIP
 Q
 ;
EF ; EP-ENTER AN ENCOUNTER FORM ; EP FROM OPTION FILE
 D ^XBCLS,EFL
 N DIC,DIE,DA,DR,D,D0,DIG,DIH,X,Y,%,DUOUT,DTOUT,DIR,%Y,X,Y,%,NAME,HMN,TMN,DIK,C,DI,DQ,DTO,J,TIEN
NAME W !!,"Enter the name of a Print Group in the format: Location Department",!,"Examples: GIMC PEDIATRICS, CROW WALK-IN",!
N1 S (DIC,DIE)="^VEN(7.41,",DLAYGO=19707.41,DIC(0)="AEQL",DIC("A")="Encounter form: "
 D ^DIC I Y=-1 Q
 I $P(Y,U,3),$P(Y,U,2)'[" " W *7,!,"Name not in the recommended format.  ENTRY DELETED.  Try again..." W ! S DIK=DIC,DA=+Y D ^DIK K DA,DIK G N1
 S NAME=$P(Y,U,2),DA=+Y,DIE=DIC,TIEN=DA
 S X=$G(^VEN(7.41,DA,0)),HMN=$P(X,U,2),TMN=$P(X,U,3)
HMN I HMN="ef" G TMN
 I HMN="" D  G TMN
 . S DR=".02////ef"
 . L +^VEN(7.41,DA):0 I $T D ^DIE L -^VEN(7.41,DA)
 . Q
 W !,"The current header mnemonic is '",HMN,"'.  Want to change it to 'EF'"
 S %=1 D YN^DICN I %=-1 Q
 I %=1 S DR=".02////ef" L +^VEN(7.41,DA):0 I $T D ^DIE L -^VEN(7.41,DA)
TMN ; TEMPLATE MNEMONIC
 I $L(TMN) S DIR("B")=TMN
 S DIR(0)="F^1:10",DIR("A")="Template menmonic",DIR("?")="Must be a unique mnemonic, 1-10 lowercase characters" KILL DA D ^DIR KILL DIR
 I $D(DTOUT)!(Y?1."^") K DIRUT,DTOUT,%Y Q
 I Y'?1.10L W !,"Must be 1-10 lowercase characters!  Try again...",! G TMN
 S X=0
 F  S X=$O(^VEN(7.41,X)) Q:'X  I X'=TIEN,$P($G(^VEN(7.41,X,0)),U,3)=Y W !,"This mnemonic has already been used in template: ",$P($G(^VEN(7.41,X,0)),U),!,"Try entering another one...",! G TMN
 S TMN=Y,DA=TIEN,DR=".03////^S X=TMN" L +^VEN(7.41,DA):0 I $T D ^DIE L -^VEN(7.41,DA)
BAR ; FIELD .04: BARCODE CHARACTER NO LONGER REQUIRED IN 2.2
 S DR=".05:3" L +^VEN(7.41,DA):0 I $T D ^DIE L -^VEN(7.41,DA)
 D EF^VENPCCMC ; CHECK ALL ENCOUNTER FORMS
NOTES W !!!,"If any corrections have been suggested, please make them now."
 W !!,"You are now ready to place a new encounter form template on the Print Server."
 W !?5,"1) The name of the template should be "_TMN_"_template.doc"
 W !?5,"3) Make sure that the template is in the proper state.  The document should be UNMERGED with the fields names showing."
 W !?5,"2) Place the template in c:\program files\ilc\ilc forms print service\templates\"
 Q
 ; 
CLL ; EP-LIST CLINICS
 N DIC,X,Y,%,BY,FR,TO,DHD,L,IOP
 S DIC="^VEN(7.95,",L=0,BY=.01,FR="",TO="",FLDS="[VEN CLINICS]",DHD="PCC+ CLINICS",IOP="HOME"
 D EN1^DIP
 Q
 ;
CL ; EP-ENTER A CLINIC
 D ^XBCLS,CLL
 W !!,"Enter the name of a new Clinic in the format LOCATION - CLINIC",!,"Examples: GIMC - PEDIATRICS, CROW - DENTAL, etc.",!
 N DIC,DIE,DA,DR,D,D0,DIG,DIH,X,Y,%,DUOUT,DTOUT,DIR
CL1 S DIC="^VEN(7.95,",DLAYGO=19707.95,DIC(0)="AEQL",DIC("A")="Clinic: " D ^DIC
 I Y=-1 Q
 I $P(Y,U,3),$P(Y,U,2)'?1.AN1" - "1.AN W !,"Format error.  Entry cancelled",!?5,"Should be in the format 'LOCATION - CLINIC' e.g., 'GIMC - DENTAL'" S DA=+Y,DIK=DIC D ^DIK G CL1
 S DIE=DIC,DA=+Y,DR=".04Clinic Stop;2.01;2.02;2.05;2.06;2.07STATUS//ACTIVE DESTINATION;2.04//"_$P($G(^DIC(4,+$G(DUZ(2)),0)),U)_";2.03IS THE TRIAGE MODULE USED IN THIS CLINIC//NO"
 L +^VEN(7.95,DA):0 I $T D ^DIE L -^VEN(7.95,DA)
 D CL^VENPCCMC
 Q
 ; 
CFG ; EP-EDIT THE CONFIG FILE
 D ^XBCLS
 W !?10,"*****  EDIT PARAMETERS FOR THE DEFAULT PCC+ CONFIGURATION  *****",!!!
 N DIC,DIE,DA,DR,D,D0,DIG,DIH,X,Y,%,DUOUT,DTOUT,DIR,CFG
 S DA=$$CFG^VENPCCU I 'DA Q
 S DIE="^VEN(7.5,",DR=".06UNIQUE CLINIC ('NULL' UNLESS ONLY 1 CLINIC USES PCC+)"
 S X=0 F %=0:1 S X=$O(^VEN(7.95,X)) Q:'X  Q:%>1
 I %=1 S %=$O(^VEN(7.95,0)),X=$P($G(^VEN(7.95,%,0)),U) I $L(X) S DR=DR_"//"_X
 S DR=DR_";.08EDIT DEMOGRAPHICS DURING CHECK-IN;.09ASK TO PRINT OUTGUIDE AND PULL CHART;.1ALWAYS PRINT HEALTH SUMMARY IN MED REC DEPT"
 I $O(^PSDRUG(0)) S DR=DR_";.16DISPLAY CHRONIC MEDS ONLY"
 S DR=DR_";11.1;11.2"
 L +^VEN(7.5,DA):0 I $T D ^DIE L -^VEN(7.5,DA)
 Q
 ; 
