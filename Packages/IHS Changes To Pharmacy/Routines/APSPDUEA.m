APSPDUEA ; IHS/DSD/ENM - ADDS ENTRIES TO APSP DUE REVIEW FILE ;  [ 09/03/97   1:30 PM ]
 ;;6.0;IHS PHARMACY MODIFICATIONS;;09/03/97
 ;
 ;--------------------------------------------------------------
START ;
 D ADD ; Create entry in APSP DUE REVIEW FILE
 D EDIT ; Uses Input templates to stuff values
 D CRITERIA ; Creates entries in Criteria multiple
 ;
END D EOJ ; Clean up variables
 Q
 ;--------------------------------------------------------------
ADD ;
 S DIC(0)="QML",X=DT,(DIC,DIE)="^APSPDUE(32," D FILE^DICN S DA=+Y
 S DR=".02///`"_1 D ^DIE
 Q
EDIT ;
 S DIE="^APSPDUE(32,",APSPDUEA("STOP")=0,APSPDUEA("X")=0,APSPDUEA("DA")=$P(^APSPDUE(32,DA,0),U,2) F  S APSPDUEA("X")=$O(^APSPDUE(32.1,APSPDUEA("DA"),11,APSPDUEA("X"))) Q:APSPDUEA("X")'=+APSPDUEA("X")!(APSPDUEA("STOP"))  D
 . S DR="1100///`"_APSPDUEA("X")
 . S APSPDUEA("NULL")=""
 . S DR(2,9009032.011)=".02////"_APSPDUEA("NULL")
 . D ^DIE I $D(Y) S APSPDUEA("STOP")=1
 Q
CRITERIA ;
 S APSPDUEA("STOP")=0,APSPDUEA("X")=0,APSPDUEA("DA")=DA,DIC(0)="ENF",(DIC,DIE)="^APSPDUE(32,APSPDUEA(""DA""),11," F  S APSPDUEA("X")=$O(^APSPDUE(32,APSPDUEA("DA"),11,APSPDUEA("X"))) Q:APSPDUEA("X")'=+APSPDUEA("X")!(APSPDUEA("STOP"))  W !! D
 . S X=APSPDUEA("X") D ^DIC
 . S DR=".02",DA(1)=1,DA=APSPDUEA("X") D ^DIE I $D(Y) S APSPDUEA("STOP")=1
 Q
EOJ ;
 K APSPDUEA,DIC,DIE,X,Y,DA,DR
 Q
