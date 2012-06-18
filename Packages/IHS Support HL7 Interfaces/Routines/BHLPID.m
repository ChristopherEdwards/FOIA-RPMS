BHLPID ; cmi/flag/maw - BHL IHS PID Supplement ; [ 06/10/2002  6:51 AM ]
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;
 ;this routine will contain code to supplement particular fields in the
 ;IHS PID segment
 ;
PID3 ;-- this will generate the IHS PID-3 field
 S BHLRN=$$LZERO($$HRN^AUPNPAT(INDA,DUZ(2)),6)
 S BHLASU=$$VAL^XBDIQ1(9999999.06,DUZ(2),.12)
 S BHLLOC=$$VAL^XBDIQ1(9999999.06,DUZ(2),.01)
 S INA("PID3",1)=BHLASU_BHLRN  ;_CS_CS_CS_CS_BHLLOC_".DOMAIN.NAME"_CS_"DNS" 
 S BHL("SSN")=$$VAL^XBDIQ1(2,INDA,.09)
 ;
PID4 ;-- this will generate the IHS PID-4 field
 S BHLCNT=0
 S BHLDA=0 F  S BHLDA=$O(^AUPNPAT(INDA,41,BHLDA)) Q:'BHLDA  D
 . Q:BHLDA=DUZ(2)
 . S BHLRN=$$LZERO($$HRN^AUPNPAT(INDA,BHLDA),6)
 . S BHLASU=$$VAL^XBDIQ1(9999999.06,BHLDA,.12)
 . S BHLLOC=$$VAL^XBDIQ1(9999999.06,BHLDA,.01)
 . S BHLCNT=BHLCNT+1
 . S $P(INA("PID4",1),RS,BHLCNT)=BHLASU_BHLRN  ;_CS_CS_CS_CS_BHLLOC_".DOMAIN.NAME"_CS_"DNS"  ;left in for backward compatability version 2.3.1 or earlier
 S INA("PID3",1)=INA("PID3",1)_$S($G(INA("PID4",1)):RS,1:"")_$G(INA("PID4",1))_$S($G(BHL("SSN")):RS,1:"")_$G(BHL("SSN"))  ;version 2.4 of the standard has all identifiers in PID3
 S INA("PID3")=INA("PID3",1)  ;_$S($G(INA("PID4",1)):RS,1:"")_$G(INA("PID4",1))_$S($G(BHL("SSN")):RS,1:"")_$G(BHL("SSN"))  ;version 2.4 of the standard has all identifiers in PID3
 Q
 ;
LZERO(V,L) ;EP - left zero fill
 NEW %,I
 S %=$L(V),Z=L-% F I=1:1:Z S V="0"_V
 Q V
 ;
QRY ;EP - setup the V02 PID segment
 S BHLCNT=0
 S INDA=$G(BHLPAT(1))
 S BHLDA=1 F  S BHLDA=$O(BHLPAT(BHLDA)) Q:'BHLDA  D
 . S BHLCNT=BHLCNT+1
 . S INDA(2,BHLCNT)=$G(BHLPAT(BHLDA))
 Q
 ;
