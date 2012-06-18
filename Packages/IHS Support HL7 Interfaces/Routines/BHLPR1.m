BHLPR1 ; cmi/sitka/maw - BHL GIS PR1 Segment Supplement ;
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;
 ;
 ;this routine will supplement the GIS PR1 segments
 ;
INDA ;-- setup the INDA arrays for PR1
 Q:'$O(^AUPNVPRC("AD",BHL("VIEN"),0))
 S BHLCNT=0
 S BHLDA=0 F  S BHLDA=$O(^AUPNVPRC("AD",BHL("VIEN"),BHLDA)) Q:'BHLDA  D
 . S BHLCNT=BHLCNT+1
 . S INDA(9000010.08,BHLCNT)=BHLDA
 Q
 ;
