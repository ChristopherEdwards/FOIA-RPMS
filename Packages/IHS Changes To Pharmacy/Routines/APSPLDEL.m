APSPLDEL ; IHS/DSD/ENM - DELETE DRIVER FOR APSP LOGS ;  [ 09/03/97   1:30 PM ]
 ;;6.0;IHS PHARMACY MODIFICATIONS;;09/03/97
 ;
 ; This routine is called by the options that delete entries in
 ; the APSP Prepack Log, APSP Due Review, APSP Due Study, APSP
 ; Intervention files.  These options are locked with the PSZMGR
 ; key.
 ; 
 ; Input variables : APSP("LOG DEL FLG") which is set by the option
 ; External Calls : ^DIE,^DIC,^DIR
 ;-----------------------------------------------------------------
START ;
 K DIC,DR,DIE,DA
 D @APSP("LOG DEL FLG") ; Sets up DIC and DIE calls for files
END D EOJ ; Cleans up variables
 Q
 ;------------------------------------------------------------------
STUDY ; Deletes entries from APSP DUE STUDY file
 S APSPLDEL("QFLG")=0
 F APSPLDEL=0:0 S DIC(0)="QEAMD",(APSPLDEL("DIC"),DIC)="^APSPDUE(32.1," Q:APSPLDEL("QFLG")  D DEL I $D(APSPLDEL("DA")),'$D(^APSPDUE(32.1,APSPLDEL("DA"))) S APSPDUED("NAME")=APSPLDEL("DA") D CRIT,DELETE^APSPDUED K APSPDUED("NAME")
 Q
PREPACK ; Deletes entries from APSP PREPACK LOG file
 S APSPLDEL("QFLG")=0
 F APSPLDEL=0:0 S DIC(0)="QEAMD",(APSPLDEL("DIC"),DIC)="^APSPP(31,",DIC("S")="I DT=$P(^(0),U,2)" Q:APSPLDEL("QFLG")  D DEL
 Q
DUE ; Deletes entries from APSP DUE REVIEW file
 S APSPLDEL("QFLG")=0
 F APSPLDEL=0:0 S DIC(0)="QEAMD",(APSPLDEL("DIC"),DIC)="^APSPDUE(32,",DIC("S")="I DT=$P(^(0),U,1)" Q:APSPLDEL("QFLG")  D DEL
 Q
INTERV ; Deletes entries from APSP INTERVENTION file
 S APSPLDEL("QFLG")=0
 F APSPLDEL=0:0 S DIC(0)="QEAMD",(APSPLDEL("DIC"),DIC)="^APSPQA(32.4,",DIC("S")="I DT=$P(^(0),U,1)" Q:APSPLDEL("QFLG")  D DEL
 Q
PCV ; Deletes entries from APSP PRIMARY CARE VISIT file
 S APSPLDEL("QFLG")=0
 F APSPLDEL=0:0 S DIC(0)="QEAMD",(APSPLDEL("DIC"),DIC)="^APSPQA(32.6,",DIC("S")="I DT=$P(^(0),U,1)" Q:APSPLDEL("QFLG")  D DEL
 Q
DEL ; Does actual lookup and deletion of entries
 K APSPLDEL("DA")
 D ^DIC K DIC,DA,DR
 I Y=-1 S APSPLDEL("QFLG")=1 G DELX
 S APSPLDEL("DA")=+Y
 S DIR(0)="Y",Y=0,DIR("A")="SURE YOU WANT TO DELETE THE ENTIRE ENTRY"
 D ^DIR K DIR
 G:$D(DIRUT)!('Y) DELX
 S DIK=APSPLDEL("DIC"),DA=APSPLDEL("DA")
 D ^DIK K DIK,DA
DELX ; Exit point from DEL
 K DIC,DIR,DA,X,Y,APSPLDEL("DIC")
 Q
CRIT ; Deletes associated entries from APSP DUE CRITERIA File
 F APSPLDEL("CRIT")=0:0 S APSPLDEL("CRIT")=$O(^APSPDUE(32.2,"AC",APSPLDEL("DA"),APSPLDEL("CRIT"))) Q:'APSPLDEL("CRIT")  S DIK="^APSPDUE(32.2,",DA=APSPLDEL("CRIT") D ^DIK K DIK,DA
 K APSPLDEL("CRIT")
 Q
EOJ ; Clean up variables
 K APSPLDEL,APSP("LOG DEL FLG"),X,Y,DIRUT,DTOUT,DUOUT
 K DIC,DIK,DA,DR
 Q
