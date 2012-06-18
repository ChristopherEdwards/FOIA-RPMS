BHLDG1 ; cmi/sitka/maw - BHL GIS DG1 Supplement ;
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;;
 ;this routine will supplement GIS DG1 segments
 ;
INDA ;-- setup the INDA array
 Q:'$O(^AUPNVPOV("AD",BHL("VIEN"),0))
 S BHLCNT=0
 S BHLDA=0 F  S BHLDA=$O(^AUPNVPOV("AD",BHL("VIEN"),BHLDA)) Q:'BHLDA  D
 . S BHLCNT=BHLCNT+1
 . S INDA(9000010.07,BHLCNT)=BHLDA
 Q
 ;
