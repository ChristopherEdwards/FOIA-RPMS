BHLZP4I ; cmi/sitka/maw - BHL File Inbound ZP4 Segment ;
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;
 ;this routine will file the inbound ZP4 Segment
 ;
MAIN ;-- this is the main routine driver
 D PROCESS,EOJ
 Q
 ;
PROCESS ;-- process the data in the segment
 S BHLDA=0 F  S BHLDA=$O(@BHLTMP@(BHLDA)) Q:BHLDA=""  D
 . S BHLPC=$P($G(@BHLTMP@(BHLDA,1)),CS,2)
 . S BHLDM=$G(@BHLTMP@(BHLDA,2))
 . S BHLDAF=$G(@BHLTMP@(BHLDA,3))
 . S DIE="^AUPNPAT(",DA=BHLPAT,DR="5101///"_BHLDM
 . S DR(2,9000001.51)=".02///"_BHLDAF
 . D ^DIE
 . I $D(Y) S BHLERCD="NOUP51" X BHLERR Q
 . S BHLFL="^AUPNPAT("_BHLPAT_",51,",BHLFL2="9000001.51",BHLX=BHLPAT
 . S BHLVAL=BHLDM
 . S BHLFLD=.03,BHLVAL2=BHLPC X BHLDIEM
 Q
 ;
EOJ ;-- kill variables and quit 
 K @BHLTMP
 K BHLDA,BHLPC,BHLDM,BHLDAF,BHLFL,BHLFLD,BHLVAL,BHLFL2,BHLFLD2,BHLVAL2
 K BHLX
 Q
 ;
