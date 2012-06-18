BHLZP3I ; cmi/sitka/maw - BHL File Inbound ZP3 Segment ;
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;
 ;this routine will file the inbound ZP3 Segment
 ;
MAIN ;-- this is the main routine driver
 D PROCESS,EOJ
 Q
 ;
PROCESS ;-- process the data in the segment
 S BHLDA=0 F  S BHLDA=$O(@BHLTMP@(BHLDA)) Q:BHLDA=""  D
 . S BHLOT=$P($G(@BHLTMP@(BHLDA,1)),CS,2)
 . S BHLOTQ=$G(@BHLTMP@(BHLDA,2))
 . S DIE="^AUPNPAT(",DA=BHLPAT,DR="4301///"_BHLOT
 . S DR(2,9000001.43)=".02///"_BHLOTQ
 . D ^DIE
 . I $D(Y) S BHLERCD="NOUP43" X BHLERR Q
 Q
 ;
EOJ ;-- kill variables and quit 
 K @BHLTMP
 K BHLDA,BHLOT,BHLOTQ,BHLFL,BHLFLD,BHLVAL,BHLFL2,BHLFLD2,BHLVAL2,BHLX
 Q
 ;
