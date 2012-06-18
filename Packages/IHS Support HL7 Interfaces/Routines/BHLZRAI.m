BHLZRAI ; cmi/sitka/maw - BHL File Inbound ZRA Segment ; 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;
 ;this routine files the inbound IHS specific ZRA segment
 ;
 Q
 ;
VIMM ;EP - v immunization
 N BHLR
 S BHLR="ZRA"
 S BHLSER=$P($G(@BHLTMP@(BHLDA,1)),CS,2)
 S BHLREA=$P($G(@BHLTMP@(BHLDA,2)),CS,2)
 S BHLCON=$P($G(@BHLTMP@(BHLDA,3)),CS,2)
 S APCDALVR("APCDTSER")=BHLSER
 S APCDALVR("APCDTREC")=BHLREA
 S APCDALVR("APCDTCON")=BHLCON
 Q
 ;
