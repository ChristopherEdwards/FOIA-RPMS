BHLZDXI ; cmi/sitka/maw - BHL File Inbound ZDX segment ; 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;
 ;this routine will file the IHS Specific ZDX segment, it is called
 ;from BHLDG1I
 ;
 Q
 ;
FILE ;EP - get the data and file it    
 N BHLR
 S BHLR="ZDX"
 S BHLPVN=$G(@BHLTMP@(BHLDA,1))
 S BHLSTG=$G(@BHLTMP@(BHLDA,2))
 S BHLMOD=$P($G(@BHLTMP@(BHLDA,3)),CS)
 S BHLCAU=$P($G(@BHLTMP@(BHLDA,4)),CS)
 S BHLFR=$P($G(@BHLTMP@(BHLDA,5)),CS)
 S BHLCOI=$P($G(@BHLTMP@(BHLDA,6)),CS)
 Q
 ;
