AGPOSTP4 ; IHS/ASDS/EFG - AGMENU EXIT ACTION MODIFICATION  
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 ;
EN ;EP -- Update AGMENU exit action to include call to HL7 routine
 ;Get DA of AGMENU option from "B" xref on OPTION file
 ;
 S DA="" F  S DA=$O(^DIC(19,"B","AGMENU",DA)) Q:DA=""  D
 .S J=^DIC(19,DA,15)
 .D EDIT
 Q
EDIT ;Edit the AGMENU option's exit action to add call to HL7 routine
 S AGXACT="D ^AGHL7,PHDR^AG,KILL^AG I $D(AGSADUZ2) S DUZ(2)=AGSADUZ2 K AGSADUZ2"
 S DIE="^DIC(19,"
 S DR="15///^S X=AGXACT"
 D ^DIE
 Q
