BHLRDXM ; cmi/flag/maw - BHL Reindex Message File upon install ; [ 06/07/2002  11:02 AM ]
 ;;3.01;BHL IHS Interfaces with GIS;**1**;JUN 01, 2002
 ;
 ;
 ;this routine will clean up the message file upon installation
 ;it appears the "AS" and "ASP" cross reference do not get killed
 ;upon kids install
 ;
MAIN ;-- this is the main routine driver
 D KILL,IDX
 D FLD
 D CUSER
 D ADDO
 D EOJ
 Q
 ;
KILL ;-- kill off the existing "AS" and "ASP" index
 S BHLDA=0 F  S BHLDA=$O(^INTHL7M(BHLDA)) Q:'BHLDA  D
 . K ^INTHL7M(BHLDA,1,"AS")
 . K ^INTHL7M(BHLDA,1,"ASP")
 Q
 ;
IDX ;-- reindex the file
 S DIK="^INTHL7M(" D IXALL^DIK
 Q
 ;
CUSER ;-- create a gis user for the interface
 W !,"Now creating GIS,USER for filing data..."
 Q:$O(^VA(200,"B","GIS,USER",0))
 K DD,DO
 S DIC="^VA(200,",DIC(0)="L",X="GIS,USER"
 S DIC("DR")="1///GIS"
 D FILE^DICN
 Q
 ;
FLD ;-- reindex the field file
 S DIK="^INTHL7F(",DIK(1)=".01^B" D ENALL^DIK
 Q
 ;
ADDO ;-- add option to menu item    
 S BHLX=$$ADD^XPDMENU("BHL IHS GIS USER MENU","BHL SETUP 3M WS","3M")
 I 'BHLX W !,"Attempt to add 3M Workstation Setup option failed.." H 2
 Q
 ;
EOJ ;-- end of job
 K BHLDA
 Q
 ;
