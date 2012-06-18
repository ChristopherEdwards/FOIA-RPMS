BHLV02I ; cmi/sitka/maw - BHL Process Inbound V02 Event ;  
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;
 ;
 ;this routine will process the inbound V02 message and send a bulletin
 ;regarding the query failure
 ;
MAIN ;-- file the inbound V02 message
 D ^BHLSETI
 D MSA,QRD,QRF,BUL
 D EOJ^BHLSETI
 Q
 ;
MSA ;EP - get MSA info     
 S BHLQID=$G(INV("MSA2"))
 S BHLQERR=$G(INV("MSA3"))
 Q
 ;
QRD ;EP - get QRD info
 S BHLQDTM=$G(INV("QRD1"))
 S BHLQID=$G(INV("QRD4"))
 S BHLNR=$G(INV("QRD7"))
 S BHLWHO=$G(INV("QRD8"))
 S BHLQRD2=$G(INV("QRD2"))
 S BHLQRD3=$G(INV("QRD3"))
 S BHLQRD9=$G(INV("QRD9"))
 S BHLQRD12=$G(INV("QRD12"))
 D OQRD^BHLV01I
 Q
 ;
QRF ;EP - get QRF info
 S BHLSDT=$G(INV("QRF2"))
 S BHLEDT=$G(INV("QRF3"))
 S BHLWHOM=$G(INV("QRF5"))
 S BHLQRF1=$G(INV("QRF1"))
 S BHLQRF6=$G(INV("QRF6"))
 S BHLQRF7=$G(INV("QRF7"))
 S BHLQRF8=$G(INV("QRF8"))
 D OQRF^BHLV01I
 Q
 ;
BUL ;EP - send bulletin for query failure
 S BHLQHR=$E($P(BHLWHO,U),7,12)
 S BHLQFAC=$E($P(BHLWHO,U),1,6)
 S BHLQPNM=$P(BHLWHO,U,2)
 S XMB="BHL QUERY FAIL",XMB(1)=$G(BHLQID),XMB(2)=$G(BHLQDTM)
 S XMB(3)=$G(BHLQPNM),XMB(4)=$G(BHLQHR),XMB(5)=$G(BHLQERR)
 D ^XMB
 Q
 ;
