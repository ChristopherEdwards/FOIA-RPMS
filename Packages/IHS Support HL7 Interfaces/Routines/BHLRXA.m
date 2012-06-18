BHLRXA ; cmi/sitka/maw - BHL IHS GIS RXA Segment Supplement ;
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;
 ;
 ;this routine will supplement the IHS GIS segments
 ;
INDA ;-- setup the INDA array for the RXA segment
 Q:'$G(BHL("VIEN"))
 Q:'$O(^AUPNVIMM("AD",BHL("VIEN"),0))
 S BHLCNT=0
 S BHLDA=0 F  S BHLDA=$O(^AUPNVIMM("AD",BHL("VIEN"),BHLDA)) Q:'BHLDA  D
 . S BHLCNT=BHLCNT+1
 . S INDA(9000010.11,BHLCNT)=BHLDA
 Q
 ;
