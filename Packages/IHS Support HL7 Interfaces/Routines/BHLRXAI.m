BHLRXAI ; cmi/sitka/maw - BHL File Inbound RXA Segment ; 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;
 ;this routine will file the inbound RXA segment it is called from
 ;VIMM^BHLORCI
 ;
 Q
 ;
VIMM ;EP - v immunization
 N BHLR
 S BHLR="RXA"
 S BHLIMM=$P($G(@BHLTMP@(BHLDA,5)),CS,2)
 Q:BHLIMM=""
 S BHLIMMI=$O(^AUTTIMM("B",BHLIMM,0))
 K BHLMTCH
 S BHLIDA=0 F  S BHLIDA=$O(^AUPNVIMM("AD",BHLVSIT,BHLIDA)) Q:BHLIDA=""!($D(BHLIMME))  D
 . I $P(^AUPNVIMM(BHLIDA,0),U)=BHLIMMI S BHLMTCH=1 Q
 Q:$D(BHLMTCH)
 S BHLLOT=$G(@BHLTMP@(BHLDA,15))
 S APCDALVR("APCDTIMM")=BHLIMM
 S APCDALVR("APCDTLOT")=BHLLOT
 Q
 ;
