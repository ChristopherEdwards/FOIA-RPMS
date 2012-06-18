APSPVIEW ; IHS/DSD/ENM - VIEW APSP ENTRIES ;  [ 09/03/97   1:30 PM ]
 ;;6.0;IHS PHARMACY MODIFICATIONS;;09/03/97
 ;
 ; This routine will display entries in certain files
 ; in a captioned format.  It calls EN^DIQ
 ;
 ; Input Variables: APSPVIEW("DIC") The global root for DIC
 ; External Calls: ^DIC,EN^DIQ
 ;--------------------------------------------------------------
START ;
 K APSPVIEW("DA'S")
 D SELECT ; Select Entries To View
 G:'$D(APSPVIEW("DA'S")) END
 D DISP ; Display enties
 G START
END D EOJ ; Clean up variables
 Q
 ;---------------------------------------------------------------
SELECT ; Select Entries to View
 S DIC=APSPVIEW("DIC")
 S DIC(0)="AEQM"
 D ^DIC K DIC,DR
 I Y>0 S APSPVIEW("DA'S",+Y)="",DIC("A")="ANOTHER ONE: " G SELECT
 K:$D(DTOUT)!($D(DUOUT)) APSPVIEW("DA'S")
 Q
DISP ; Calls EN^DIQ to display entries in captioned form
 ;
 F APSPVIEW("DA")=0:0 S DIC=APSPVIEW("DIC"),APSPVIEW("DA")=$O(APSPVIEW("DA'S",APSPVIEW("DA"))) Q:'APSPVIEW("DA")  S DA=APSPVIEW("DA") D EN^DIQ K DIC,DR,DA
 Q
EOJ ; Clean up variables
 K APSPVIEW,X,Y,DIC,DTOUT,DUOUT
 Q
