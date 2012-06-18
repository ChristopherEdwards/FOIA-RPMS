APSPDUE ; IHS/DSD/ENM - ENTER DUE'S IN DRUG FILE ;  [ 09/03/97   1:30 PM ]
 ;;6.0;IHS PHARMACY MODIFICATIONS;;09/03/97
 ;
 ; This routine will add DUE Criteria Names to the DUE Multiple
 ; of the Drug File.  It will only add it to those drugs that
 ; do not already contain an Criteria Name of the same name.
 ; It is also used to delete Criteria names from the Drug File
 ; by calling APSPDUED
 ;
 ; Local Variables: APSPDUE array,%,I
 ; Global Variables: ^PSDRUG(, ^TMP("APSPDUE",$J,
 ; External calls: DIC,DIE,YN^DICN,APSPDUED
 ;----------------------------------------------------------
START ;
 K ^TMP("APSPDUE",$J)
 D DUE ;Select Criteria Name
 D:$D(APSPDUE("NAME"))#2 ASK ;Ask whether the user wants to add or delete
 I $D(APSPDUE)#2 D:APSPDUE=2 ^APSPDUED ;Delete DUE entries from multiple
 I $D(APSPDUE)#2 D:APSPDUE=1 DRUG ;Select Drugs
 D:$D(APSPDUE("DRUGS"))#2 ADD ;Add to DUE Multiple of Drug File
END D EOJ ;Clean up variables     
 Q
 ;
 ;-------------------------------------------------------------
DUE ; Do lookup of DUE Criteria name
 S DIC(0)="QEMA",DIC="^APSPDUE(32.1,"
 S DIC("A")="Select DUE Criteria Name : "
 D ^DIC
 I Y="-1" G:X=""!(X="^") DUEX G DUE
 S APSPDUE("NAME")=+Y
 D DISP ; Displays Drugs that are already marked as part of the study
 W !
DUEX ; Exit point from DUE subroutine
 K DIC,DA K:X="^" APSPDUE("NAME") K X,Y
 Q
DISP ;
 G:'$D(^PSDRUG("APSPCN",APSPDUE("NAME"))) DISPX
 W !!,"The following drugs have been marked to be part of this study",!
 S APSPDUE("CNT")=0
 F APSPDUEI=0:0 S APSPDUEI=$O(^PSDRUG("APSPCN",APSPDUE("NAME"),APSPDUEI)) Q:'APSPDUEI  I $D(^PSDRUG(APSPDUEI,0)) W:'APSPDUE("CNT") ! W:APSPDUE("CNT") ?45 W $P(^(0),U,1) S APSPDUE("CNT")=(APSPDUE("CNT")+1) S:APSPDUE("CNT")=2 APSPDUE("CNT")=0
 W !
 K APSPDUEI
DISPX Q
 ;
ASK ; Ask if want to delete or add
 S DIR(0)="SO^1:Select Drugs to include in DUE;2:Delete DUE tags from all drugs"
 S DIR("B")="1"
 S DIR("?")=" "
 S DIR("?",1)="If you enter a '1' you will then be prompted to select drugs to include in your DUE "
 S DIR("?",2)="If you enter a '2' then all DUE tags for the selected DUE will be removed from your drug file"
 D ^DIR
 S:'$D(DTOUT)&('$D(DUOUT)) APSPDUE=$S(Y=1:"1",1:"2")
ASKX ; Exit point from ASK subroutine
 Q
 ;
DRUG ; Do lookup of DRUG names
 S DIC(0)="QEMA",DIC="^PSDRUG("
 S DIC("A")="Select the Drug you wish to include : "
 D ^DIC
 I Y="-1" G:X=""!(X="^") DRUGX G DRUG
 S %=2 W !,"Do you want to include all drugs beginning with this name "
 D YN^DICN
 I %=0 W !!,"If you enter Yes, all drugs in the drug file beginning with the first part of",!,"the drug name you selected will automatically be included.",!! G DRUG
 S APSPDUE("DRUGS")=$S(%=1&($D(^PSDRUG(+Y,0))#2):$P(^(0)," ",1),1:+Y)
 S:APSPDUE("DRUGS")]0 ^TMP("APSPDUE",$J,APSPDUE("DRUGS"))=""
 G DRUG
DRUGX ; Exit point from DRUG subroutine
 K DIC,DA K:X="^" APSPDUE("DRUGS") K Y,X
 Q
 ;
ADD ; Add to DUR multiple in Drug File
 S APSPDUE("DRUGS")=0
 F I=0:0 S APSPDUE("DRUGS")=$O(^TMP("APSPDUE",$J,APSPDUE("DRUGS"))) Q:APSPDUE("DRUGS")=""  D:APSPDUE("DRUGS")]"@" NAMES I "@"]APSPDUE("DRUGS") D
 . S DIE="^PSDRUG(",DA=APSPDUE("DRUGS")
 . S DR="9999999.11///"_"`"_APSPDUE("NAME")
 . D ^DIE K DO,DA,X,Y,DIE
 . W "."
 W "Done"
 Q
 ;
NAMES ; Add to DUR multiple in Drug File for Multiple Drug Entires
 S APSPDUE("DFN")=""
 S APSPDUE("CLASS")=APSPDUE("DRUGS")
 F I=0:0 S APSPDUE("CLASS")=$O(^PSDRUG("B",APSPDUE("CLASS"))) Q:APSPDUE("CLASS")'[APSPDUE("DRUGS")  S APSPDUE("DFN")=$O(^PSDRUG("B",APSPDUE("CLASS"),"")) D
 . I '$D(^PSDRUG("APSPCN",APSPDUE("NAME"),APSPDUE("DFN"))),$D(^PSDRUG(APSPDUE("DFN"),0))#2 D
 .. S DIE="^PSDRUG(",DR="9999999.11///"_"`"_APSPDUE("NAME")
 .. S DA=APSPDUE("DFN")
 .. D ^DIE K DA,DO,DR,X,Y,DIE
 .. W "."
 Q
 ;
EOJ ; Clean up local variables
 K DIC,DA,X,Y,APSPDUE,^TMP("APSPDUE",$J),%,I,DIR,DTOUT,DUOUT
 K APSPDUEI
 Q
