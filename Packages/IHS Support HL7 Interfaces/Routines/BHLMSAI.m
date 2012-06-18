BHLMSAI ;cmi/sitka/maw - BHL Process Inbound MSA Segment 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;
 ;
 ;this routine will process the MSA segment and file a bulletin
 ;if the MSA came back with an Error
 ;
FILE ;-- file the MSA segment for V03 Query
 Q:$E(BHLET)'="V03"
 Q:$G(INV("MSA1"))="AA"
 Q:$G(INV("MSA1"))="CA"
 D MSA^BHLV02I,QRD^BHLV02I,QRF^BHLV02I,BUL^BHLV02I
 S BHLERCD="RECACKERR" X BHLERR
 Q:$D(BHLERR("FATAL"))
 Q
 ;
