APSPDUED ; IHS/DSD/ENM - DELETE DUE CRITERIA NAME FROM DRUG FILE ;  [ 09/03/97   1:30 PM ]
 ;;6.0;IHS PHARMACY MODIFICATIONS;;09/03/97
 ;
 ; This routine will delete all entries in the Drug File DUE multiple
 ; for a selected DUE Criteria Name.  It will ask the user if they
 ; want to continue after selection before deletion. It is called from
 ; APSPDUE
 ;
 ; Local Variables: APSPDUED array,I,DIK,%
 ; Input variables: APSPDUE
 ; Global Variables: ^PSDRUG(
 ; External Calls: DIC,DIK,YN^DICN
 ;
 ;--------------------------------------------------------------------
START ;   
 S:$D(APSPDUE("NAME"))#2 APSPDUED("NAME")=APSPDUE("NAME")
 D:'$D(APSPDUED("NAME"))#2 DUE ; Select DUE Criteria Name
 D:$D(APSPDUED("NAME"))#2 ASK ; Ask if they want to continue
 D:$D(APSPDUED("DEL"))#2 DELETE ; Delete from Drug File DUE multiple
END D EOJ ; Clean up variables
 Q
 ;
 ;--------------------------------------------------------------------
DUE ; Do lookup of DUE Criteria name
 S DIC(0)="QEMA",DIC="^APSPDUE(32.1,"
 S DIC("A")="Select DUE Criteria Name : "
 D ^DIC
 I Y="-1" G:X=""!(X="^") DUEX G DUE
 S APSPDUED("NAME")=+Y
 W !
DUEX ; Exit point from DUE subroutine
 K DIC,DA K:X="^" APSPDUED("NAME") K X,Y
 Q
 ;
ASK ;
 W !!,"This will remove all entries in your Drug file for the"
 W !,"above DUE criteria name, do you want me to continue : "
 S %=2 D YN^DICN
 I %=0 W !!,"This will unmark the drugs in your drug file as being",!,"part of a DUE study for the particular DUE you have chosen." G ASK
 S:%=1 APSPDUED("DEL")=""
 Q
 ;
DELETE ;EP - Delete from Drug File DUR multiple
 G:'$D(^PSDRUG("APSPCN",APSPDUED("NAME")))#2 DELETEX
 S APSPDUED("DRUG")=""
 F I=0:0 S APSPDUED("DRUG")=$O(^PSDRUG("APSPCN",APSPDUED("NAME"),APSPDUED("DRUG"))) Q:APSPDUED("DRUG")'=+APSPDUED("DRUG")  D
 . S DA(1)=APSPDUED("DRUG")
 . S DIK="^PSDRUG(DA(1),999999911,",DA=APSPDUED("NAME")
 . D ^DIK K DIK,DA,DIC
 . W:'$D(APSP("LOG DEL FLG")) "."
 W "Done"
 K APSPDUED("DRUG")
DELETEX ; Exit point from Delete subroutine
 Q
 ;
EOJ ; Clean up variables
 W:$D(APSPDUED("DRUG")) " All finished ..."
 K APSPDUED,DIK,I,DA,%,Y,X,DIC
 Q
