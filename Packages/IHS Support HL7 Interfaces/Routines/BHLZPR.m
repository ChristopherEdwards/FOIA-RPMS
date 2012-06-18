BHLZPR ; cmi/sitka/maw - BHL GIS ZPR Segment Supplement ;
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;
 ;
 ;this routine will supplement GIS ZPR segments
 ;
INDA ;-- setup the INDA for V Dental
 Q:'$O(^AUPNVDEN("AD",BHL("VIEN"),0))
 S BHLCNT=0
 S BHLDA=0 F  S BHLDA=$O(^AUPNVDEN("AD",BHL("VIEN"),BHLDA)) Q:'BHLDA  D
 . S BHLCNT=BHLCNT+1
 . S INDA(9000010.05,BHLCNT)=BHLDA
 . S INA("ZPR1",BHLCNT)=$$VAL^XBDIQ1(9000010.05,BHLDA,.04)
 . S INA("ZPR2",BHLCNT)=$$VAL^XBDIQ1
 ;
