BHLIN1MR ; cmi/sitka/maw - BHL IN1 Segment Medicare ;
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;;
 ;
 ;this routine will go through the medicare eligible file for a
 ;patient and get the necessary IN1 segments
 ;
INDA ;-- setup the INDA array    
 S INDA(9000003,1)=INDA
 S (BHLCNT,BHLDA)=0 F  S BHLDA=$O(^AUPNMCR(INDA,11,BHLDA)) Q:'BHLDA  D
 . S BHLCNT=BHLCNT+1
 . S INDA(9000003.11,BHLCNT)=BHLDA
 Q
 ;
