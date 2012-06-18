BHLSITE ;cmi/sitka/maw - Edit HL7 Site Parameters  
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;
 ;
 ;this routine will allow the user to add/edit site parameters
 ;
MAIN ;-- this is the main routine driver
 D ASK Q:$D(DUOUT)!$D(DTOUT)
 D EOJ
 Q
 ;
ASK ;-- ask with site
 S DIC="^BHLSITE(",DIC(0)="AELMQZ",DLAYGO=90076.3
 S DINUM=DUZ(2)
 D ^DIC
 Q:Y<0
 S BHL("SITE")=+Y
 S DIE=DIC,DR="12:24",DA=BHL("SITE")
 D ^DIE
 ;
EOJ ;-- kill variables and quit
 K BHL("SITE")
 Q
 ;
