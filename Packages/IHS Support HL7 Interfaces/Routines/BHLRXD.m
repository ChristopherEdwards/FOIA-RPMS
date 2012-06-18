BHLRXD ; cmi/sitka/maw - GIS Supplement for RXD segment ; 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;
 ;
 ;this routine will populate data necessary for the RXD segment
 ;
MAIN ;-- this is the main driver
 S BHL("SIG")=$$VAL^XBDIQ1(9000010.14,INDA,.05)
 S BHL("QTY")=$$VALI^XBDIQ1(9000010.14,INDA,.06)
 S BHL("DP")=$$VALI^XBDIQ1(9000010.14,INDA,.07)
 S BHL("ORCTQ")=BHL("SIG")_CS_BHL("QTY")_CS_BHL("DP")
 Q
 ;
