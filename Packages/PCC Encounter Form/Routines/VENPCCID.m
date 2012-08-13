VENPCCID ; IHS/OIT/GIS - INSTALLATION TOOLS: ADD A NEW TEMPLATE FOR VER 2.5 ENTER/EDIT PCC+ CONFIG FILE ;
 ;;2.6;PCC+;;NOV 12, 2007
 ;
 ; 
 ;
 N DIC,DIE,X,Y,Z,%,CIEN,FLD,DA,DR,CNM,SEP,RXFLAG
 S SEP="-------------------"
 S RXFLAG=0
 S X=$O(^PSRX("AD",9999999),-1) I X,$$FMDIFF^XLFDT(DT,X)<7 S RXFLAG=1 ; PHARMACY PKG IS IN ACTIVE USE
 S %=$O(^VEN(7.5,"AC",1,0)) I % S CIEN=%,CNM=$P($G(^VEN(7.5,CIEN,0)),U) W !!,"Editing the ",CNM," configuration...",!! G SYS
 S DIC("B")="PRIMARY" S DIC("A")="Enter the name of the primary configuration set for PCC+: "
 S DIC="^VEN(7.5,",DIC(0)="AEQL",DLAYGO=19707.5
 D ^DIC I Y=-1 Q
 S CIEN=+Y S CNM=$P(Y,U,2) W !!
SYS ; SYSTEM PROPERTIES
 W SEP,"  SYSTEM PROPERTIES  ",SEP,!!
 S DIE="^VEN(7.5,",DA=CIEN
 S DR=".07////1;.04RPMS Server OS (Winows or Unix);.05MUMPS OS (Cache or MSM);"
 S DR=DR_".03Facility type (IHS or TRIBAL or 638);"
 S DR=DR_"13.01Print Service (VER 2.2 or VER 2.5);.23Get allergies from ART Package;.19Always use expanded sigs;"
 I RXFLAG S DR=DR_".16Apply chronic med filter to all templates;"
 S DR=DR_".21Automatically clean out inactive data files"
 D DIE
DEF ; DEFAULT PATIENT AND PROVIDER
 K DIC
 W !!,SEP,"  DEFAULT PATIENT AND PROIVIDER  ",SEP
 W !!,"Enter the name of the system-wide default provider.  When all else fails,"
 W !,"this provider's ICD preferences will be used to populate the template.",!
 S DIE="^VEN(7.5,",DA=CIEN
 I $P($G(^VEN(7.5,CIEN,0)),U,13) S DR=".13Default provider" D DIE G DEF1
 S DIC="^VA(200,",DIC(0)="AEQL",DLAYGO=200,DIC("DR")=""
 D ^DIC I Y=-1 G DEF1
 S DIE="^VEN(7.5,",DA=CIEN,DR=".13////"_+Y
 D DIE
DEF1 W !!,"Enter the name of the system-wide default patient.  This patient is used"
 W !,"to test the features of PCC+ without creating a new visit.  The demo patient"
 W !,"must have at least one visit in the system.",!
 K DIC
 I $P($G(^VEN(7.5,CIEN,0)),U,14) S DR=".14Default patient" D DIE G CKIN
 E  S Z=$O(^DPT("B","DEMO,PATIENT",0))
 I Z,$D(^AUPNVSIT("AC",Z)) S DIC("B")="DEMO,PATIENT"
 S DIC="^DPT(",DIC(0)="AEQM"
 D ^DIC I Y=-1 G CKIN
 I '$D(^AUPNVSIT("AC",+Y)) W !,"Can't use this patient!  No visits in the system..." G DEF1
 S DIE="^VEN(7.5,",DA=CIEN,DR=".14////"_+Y
 D DIE
CKIN ; CHECKIN PREFERENCES
 W !!,SEP,"  PCC+ CHECK-IN PREFERENCES  ",SEP
 W !!,"The following preferences are used to configure PCC+'s",!,"native check-in process...",!!
 S DIE="^VEN(7.5,",DA=CIEN
 S DR=".08Enable check in clerk to edit demographics;.09Ask about generating an outguide;"
 S DR=DR_".1Always print health summary in Medical Records;4Enter site managers contact info"
 D DIE
PATH ; ENTER PATHS IP/SOCKET INFO
 W !!,SEP,"  PATHS TO PCC+ FOLDERS AND IP/SOCKET PREFERENCES  ","-----"
 W !!,"In Unix systems, the paths should look something like '/usr/pccplus/print/'"
 W !,"In Windows systems, the paths should look something like 'c:\pccplus\print\'"
 W !,"The default socket for PCC+ is 5143.",!,"Use this socket unless there is a good reason not to",!
 S DIE="^VEN(7.5,",DA=CIEN
 S DR="1Path to print folder;3Path to 'temp' folder;11.1IP address of Print Server 1;"
 S DR=DR_"11.2IP address of print server 2;11.3Print Service socket"
 D DIE
 W !!,SEP,!!,"The primary configuration parameters have been successfully updated..."
FIN D ^XBFMK
 Q
 ;
DIE L +^VEN(7.5,DA):0 I $T D ^DIE L -^VEN(7.5,DA)
 Q
 ; 
