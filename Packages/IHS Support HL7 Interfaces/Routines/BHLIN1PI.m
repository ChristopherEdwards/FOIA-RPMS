BHLIN1PI ; cmi/sitka/maw - BHL GIS IN1 Private Insurance Supplement ;  
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;
 ;
 ;this routine will supplement the GIS IN1 Private Insurance Segments
 ;
INDA ;EP -- setup the INDA arrays
 Q:'$$PI^AUPNPAT(INDA,BHL("VDT"))
 S BHLCNT=0
 S BHLDA=0 F  S BHLDA=$O(^AUPNPRVT(INDA,11,BHLDA)) Q:'BHLDA  D
 . S BHLPH=$P($G(^AUPNPRVT(INDA,11,BHLDA,0)),U,8)
 . Q:'BHLPH
 . S BHLEFD=$P($G(^AUPNPRVT(INDA,11,BHLDA,0)),U,6)
 . S BHLEXD=$P($G(^AUPNPRVT(INDA,11,BHLDA,0)),U,7)
 . I BHLEXD="" S BHLEXD=9999999
 . Q:BHLEFD>BHL("VDT")
 . Q:BHLEXD<BHL("VDT")
 . S BHLCNT=BHLCNT+1
 . S INDA(9000003.1,BHLCNT)=BHLPH
 Q
 ;
