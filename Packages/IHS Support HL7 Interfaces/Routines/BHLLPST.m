BHLLPST ; cmi/flag/maw - BHL LOINC POST INIT ; 
 ;;3.01;BHL IHS Interfaces with GIS;**4**;OCT 15, 2002
 ;
 ;
 ;
 ;this routine will set up the loinc post install questions
 ;
MAIN ;PEP - this is the main routine driver
 D EDIT
 D MPORT^BHLU
 D COMPILE
 D EOJ
 Q
 ;
EDIT ;-- ask which reference lab and then stuff the file
 X ^%ZOSF("EON")  ;turn echo on for questions
 W !!,"I Will now walk you through setting your Loinc Parameters",!!
 S DIC(0)="AEMQZ",DIC="^BLRSITE("
 S DIC("A")="Setup Loinc files for which Lab Site: "
 D ^DIC
 Q:Y<0
 S BHLLSITE=+Y
 S DIE=DIC,DA=BHLLSITE,DR="500:505"
 D ^DIE
 K DIC,DIE,DR,DA
 S DIR(0)="Y",DIR("A")="Setup Another Loinc Site "
 D ^DIR
 K DIR
 Q:'Y
 G EDIT
 Q
 ;
COMPILE ;-- compile the ref lab scripts
 W !!,"I will now generate scripts and compile the messages...",!
 W !!,"Press return when asked to compile scripts",!
 S BHLMSI=$O(^INTHL7M("B","HL IHS LOINC R01",0))
 Q:'BHLMSI
 D COMPILE^BHLU(BHLMSI)
 Q
 ;
EOJ ;-- kill variables and quit
 D EN^XBVK("BHL")
 Q
 ;
