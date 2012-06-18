BHLPV1 ; cmi/flag/maw - BHL PV1 Supplement ;
 ;;3.01;BHL IHS Interfaces with GIS;**1**;JUN 01, 2002
 ;;
 ;
 ;this routine will supplement GIS PV1 segments
 ;
DEA(VIEN)          ;-- get the primary providers dea #
 S BHLP=$$PRIMPROV^APCLV(VIEN,"I")
 I BHLP="" S DEA="" Q DEA
 S DEA=$$PROV^BHLPRV(BHLP,"H")
 Q DEA
 ;
SDEA(VIEN)         ;-- get the secondary providers dea #
 S BHLP=$$SECPROV^APCLV(VIEN,"I",1)
 I BHLP="" S DEA="" Q DEA
 S DEA=$$PROV^BHLPRV(BHLP,"H")
 Q DEA
 ;
INA ;-- setup the v hosp PV1 nodes
 S BHLDA=$O(^AUPNVINP("AD",+BHL("VIEN"),0))
 Q:'BHLDA
 S INA("PV14",1)=$$VAL^XBDIQ1(9000010.02,BHLDA,.07)
 S INA("PV136",1)=$$VAL^XBDIQ1(9000010.02,BHLDA,.06)
 S INA("PV137",1)=$$VAL^XBDIQ1(9000010.02,BHLDA,.09)
 S INA("PV145",1)=$$VAL^XBDIQ1(9000010.02,BHLDA,.01)
 Q
 ;
