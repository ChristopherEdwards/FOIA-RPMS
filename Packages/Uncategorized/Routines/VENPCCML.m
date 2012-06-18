VENPCCML ; IHS/OIT/GIS - CLONE AND DELETE PREFERENCES ;
 ;;2.6;PCC+;;NOV 12, 2007
 ;
 ;
 ; 
ICD ; EP-CLONE USER ICD PREFERENCES
NEW N SOURCE,TARGET,LAST,DIC,X,Y,%,DUOUT,DTOUT,DA,DIK,PIEN,D0,DDH,DG,DICR,DIU,TOT,CNT,POP,%Y,PIEN
 W !!!
FROM S DIC("A")="Copy preferences from: "
 S DIC=200,DIC(0)="AEQI"
 D ^DIC K DIC I Y=-1 Q
 I '$D(^VEN(7.1,"B",+Y)) W !,"This provider has no preferences on file!",!,"Please select another provider or enter '^' to exit...",! G FROM
 S SOURCE=+Y
TO S DIC("A")="Copy preference to: "
 S DIC=200,DIC(0)="AEQI"
 D ^DIC K DIC I Y=-1 Q
 I +Y=SOURCE W !,"You can not clone preferences from a provider to him/herself.",!,"Select another provider or enter '^' to exit...",! G TO
 I $D(^VEN(7.1,"B",+Y)) W !,"This provider already has preferences on file!" W !,"Want to completely replace the old set of preferences" S %=2 D YN^DICN Q:$G(%Y)?1."^"  I %=2 Q
 S TARGET=+Y
 S %=1 W !,"Are you sure" D YN^DICN I %'=1 Q
 D WAIT^DICD
 I $D(^VEN(7.1,"B",+Y)) W !,"Deleting the old preferences..." S DIK="^VEN(7.1,",DA=0 F  S DA=$O(^VEN(7.1,"B",TARGET,DA)) Q:'DA  D ^DIK ; DELETE OLD PREFERENCES BEFORE REPLACING THEM
 W !,"Cloning preferences..."
 S LAST=$O(^VEN(7.1,999999999),-1) I 'LAST Q
MERGE S DIK="^VEN(7.1,",TOT=0 ; RE-INDEX REFERENCE THE FILE
 S PIEN=0 F  S PIEN=$O(^VEN(7.1,"B",SOURCE,PIEN)) Q:'PIEN  D
 . S %=$G(^VEN(7.1,PIEN,0)) I '$L(%) Q
 . S $P(%,U)=TARGET
 . S $P(%,U,5)=""
 . S TOT=TOT+1,DA=TOT+LAST
 . S ^VEN(7.1,DA,0)=%
 . D IX1^DIK ; CREATE INDICES FOR THIS NEW ENTRY
 W !!,"DONE!",! H 2
 D ^XBFMK
 Q
 ; 
ICDD ; EP-DELETE A SET OF ICD PREFERENCES
 N X,Y,%,PIEN,DIC,DA,DIK,USER,POP
 W !!!
 S DIC("A")="Delete preferences from: "
 S DIC=200,DIC(0)="AEQI",DIC("S")="I $D(^VEN(7.1,""B"",Y))"
 D ^DIC K DIC I Y=-1 Q
 S USER=+Y
 S %=1 W !,"Are you sure" D YN^DICN I %'=1 Q
 D WAIT^DICD
 S DIK="^VEN(7.1,",DA=0 F  S DA=$O(^VEN(7.1,"B",USER,DA)) Q:'DA  D ^DIK
 W !!,"DONE!" H 2
 D ^XBFMK
 Q
 ; 
CORD ;EP-CLONE CPT SETS
 N %,DIC,OLD,NEW,LAST,DIK,MMF,IEN,DA,TOT
 D CLEAN
 I '$O(^VEN(7.93,"AS",0))!('$O(^VEN(7.92,0))) S %=$$INIT Q:'%  S OLD=% G C1
 S DIC("A")="Enter the name of the Orderable Set to copy from: "
 S DIC(0)="AEQ",DIC="^VEN(7.92," D ^DIC I Y=-1 Q
 S OLD=+Y
C1 S DIC("A")="Enter the name of the new Set of Orderables: "
 S DLAYGO=19707.92,DIC(0)="AEQL",DIC="^VEN(7.92," D ^DIC I Y=-1!('$P(Y,U,3)) D ^XBFMK Q
 W !,"One moment please..."
 S NEW=+Y,LAST=$O(^VEN(7.93,999999999),-1),DIK="^VEN(7.93,",TOT=0,MMF=""
 F  S MMF=$O(^VEN(7.93,"AS",OLD,MMF)) Q:MMF=""  S IEN=0 F  S IEN=$O(^VEN(7.93,"AS",OLD,MMF,IEN)) Q:'IEN  D
 . S TOT=TOT+1
 . S DA=LAST+TOT I (DA#25)=0 W "."
 . M ^VEN(7.93,DA)=^VEN(7.93,IEN)
 . S $P(^VEN(7.93,DA,0),U,2)=NEW,$P(^VEN(7.93,DA,0),U,11)=""
 . D IX^DIK
 . Q
 W !,"The orderable set has been cloned!"
C2 S %=1 W !,"Want to link this new order set to a template" D YN^DICN I %=1 D LINK(NEW)
 D ^XBFMK
 Q
 ; 
DORD ; EP-DELETE AN ORDERABLE SET
 N X,Y,%,DIC,DIE,DR,DA,SET,DIK,MMF
 I '$O(^VEN(7.92,0)) W !,"No orderable sets have been defined!  Request cancelled..." Q
 D CLEAN
 S DIC("A")="Delete what order set: "
 S DIC(0)="AEQ",DIC="^VEN(7.92," D ^DIC I Y=-1 Q
 S SET=+Y
 S %=1 W !,"Are you sure you want to delete this orderable set" D YN^DICN I %'=1 Q
ONE S %=$O(^VEN(7.92,0)) I %,'$O(^VEN(7.92,%)) D  Q  ; RESTORE TO THE PRISTINE STATE IF THERE IS ONLY ONE ORDER SET
 . S DIE="^VEN(7.93,",DR=".02///@"
 . S DA=0 F  S DA=$O(^VEN(7.93,DA)) Q:'DA  L +^VEN(7.93,DA):0 I $T D ^DIE L -^VEN(7.93,DA)  ; REMOVE ALL ORDER SETS FROM ORDERABLES BUT DONT REMOVE ORDERABLES
 . S DIE="^VEN(7.41,",DR=".09///@"
 . S DA=0 F  S DA=$O(^VEN(7.41,DA)) Q:'DA  L +^VEN(7.41,DA):0 I $T D ^DIE L -^VEN(7.41,DA)  ; REMOVE ALL ORDER SETS FROM TEMPLATES BUT DOT REMOVE TEMPLATES
 . S DIK="^VEN(7.92,",DA=SET D ^DIK  ; DELETE THE ORDER SET
 . W !,"The only defined order set has been removed and ",!,"templates and orderabes are no longer associated with any order sets!"
 . D ^XBFMK
 . Q
D1 S MMF="",DIK="^VEN(7.93,"
 F  S MMF=$O(^VEN(7.93,"AS",SET,MMF)) Q:MMF=""  S DA=0 F  S DA=$O(^VEN(7.93,"AS",SET,MMF,DA)) Q:'DA  D ^DIK ; REMOVE ORDER SET FROM ALL ASSOCIATED ORDERABLES
 W !,"All orderables associated with this order set have been deleted!"
 W !,"The following templates are no longer linked to an order set:"
 S DIE="^VEN(7.41,",DR=".09///@"
 S DA=0 F  S DA=$O(^VEN(7.41,DA)) Q:'DA  S %=$P($G(^VEN(7.41,DA,0)),U,9) I %=SET D
 . W !?5,$P($G(^VEN(7.41,DA,0)),U)
 . L +^VEN(7.41,DA):0 I $T D ^DIE L -^VEN(7.41,DA) ; REMOVE ORDER SET FROM TEMPLATE
 . Q
 S DIK="^VEN(7.92,",DA=SET D ^DIK  ; DELETE THE ORDER SET
 W !,"Order set deleted!"
 D ^XBFMK
 Q
 ; 
INIT() ; EP-INITIALIZE THE PRIMARY ORDERABLE SET
 N DIC,Y,X,OSET,%,DA,DR,DIE,%Y
 I $O(^VEN(7.93,"AS",0)) Q 0
 W !,"No order sets have been created yet..."
 W !,"You must initialize the primary order set before it can be cloned."
 W !,"Want to initialize the primary order set"
 S %=1 D YN^DICN I %'=1 D ^XBFMK Q 0
 S DLAYGO=19707.92,DIC="^VEN(7.92,",DIC(0)="AEQL",DIC("A")="Name of primary orderable set: "
 I '$O(^VEN(7.92,0)) S DIC("B")="GENERIC ORDER SET"
 D ^DIC I Y=-1 D ^XBFMK Q 0
 S OSET=+Y
 W !!,"OK, all current orderables will be associated with ",$P(Y,U,2)
 W !,"All existing templates will be linked to this order set as well"
 W !,"In the future, all new templates must be linked to an order set"
 W !,"Are you sure you want to go on"
 S %=1 D YN^DICN I %'=1 D ^XBFMK Q 0
 W !,"One moment please..."
 S DIE="^VEN(7.93,",DR=".02////^S X=OSET"
 S DA=0 F  S DA=$O(^VEN(7.93,DA)) Q:'DA  L +^VEN(7.93,DA):0 I $T D ^DIE L -^VEN(7.93,DA) W:(DA#25)=0 "."
 S DIE="^VEN(7.41,",DR=".09////^S X=OSET"
 S DA=0 F  S DA=$O(^VEN(7.41,DA)) Q:'DA  L +^VEN(7.41,DA):0 I $T D ^DIE L -^VEN(7.41,DA)
 W !,"Done!"
 D ^XBFMK
 Q OSET
 ; 
LINK(NEW) ; EP-LINK AN ORDER SET TO A TEMPLATE
 N X,%,DA,DR,DIE,DIC
 S DIC("A")="Template: ",DIC="^VEN(7.41,",DIC(0)="AEQ"
 D ^DIC I Y=-1 Q
 S DIE=DIC,DA=+Y,DR=".09"
 I $G(NEW) S DR=DR_"////"_+NEW
 L +^VEN(7.41,DA):0 I $T D ^DIE L -^VEN(7.41,DA)
 D ^XBFMK
 W !,"Done!"
 Q
 ; 
CLEAN ; EP-CLEAN OUT ALL INCOMPLETE ENTRIES
 N DA,X,DIK
 S DA=0,DIK="^VEN(7.93,"
 F  S DA=$O(^VEN(7.93,DA)) Q:'DA  S X=$G(^(DA,0)) I $P(X,U,3)="" D ^DIK
 Q
 ; 
