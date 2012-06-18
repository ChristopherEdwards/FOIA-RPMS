BHLQRD ; cmi/sitka/maw - BHL Outbound QRD Segment Supplement ; 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;
 ;this routine will supplement an outbound QRD segment based on the
 ;information obtained from user input (BHLIQUI)
 ;
MAIN ;-- setup the variables for the QRD segment
 D NOW^%DTC S BHLQNOW=%
 S INA("INQDTM")=BHLQNOW
 S INA("INQPRI")="I"
 S INA("INQTAG")=$G(INA("MESSID"))
 S INA("INQWHAT")="VXI"
 S INA("INQTY")=$G(INA("QTY"))
 D WHO
 Q
 ;
WHO ;-- get the necessary information to build a who string (QRD-9)
 ;support for multiples built in
 S BHLQCNT=0
 S BHLQDA=0 F  S BHLQDA=$O(INA("QNM",BHLQDA)) Q:'BHLQDA  D
 . S BHLQCNT=BHLQCNT+1
 . S BHLQNM=$G(INA("QNM",BHLQDA))
 . S BHLQNM=$$PN^INHUT(BHLQNM)
 . S BHLQRN=$$HRN^AUPNPAT(BHLQDA,DUZ(2))
 . S BHLQASU=$$VAL^XBDIQ1(9999999.06,DUZ(2),.12)
 . S $P(INA("INQWHO"),RS,BHLQCNT)=BHLQASU_BHLQRN_CS_BHLQNM
 Q
 ;
