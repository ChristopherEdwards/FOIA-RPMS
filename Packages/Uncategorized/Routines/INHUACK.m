INHUACK ; FRW ; 2 Jul 96 11:32; Handle Incoming ACK messages 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;;
 ;
ACK ;Deal with inbound ack messages
 ;INPUT:
 ;  UIF - ien of ack message in Universal Interface file
 ;OUTPUT:
 ;  INSTERR - if present indicates error occurred
 ;  INHERR - if present indicates error message
 ;
 N LCT,LINE,ACKSTAT,ACKEDMES,ERRMSG,INERMSG
 ;Start reading lines from the beginning of the message
 S LCT=0
 ;Get message header
 D GET^INHOU(UIF,0)
 I '$D(LINE) S INHERR="No message header (MSH) segment" G ERR
 S INDELIM=$E(LINE,4),INSUBDEL=$E(LINE,5)
 ;Get MSA segment
 D GET^INHOU(UIF,0)
 ;Check for errors
 I $P($G(LINE),INDELIM,1)'="MSA" S INHERR="No message acknowledgement (MSA) segment" G ERR
 ;Parse out segment
 ;Ack code
 S ACKSTAT=$P(LINE,INDELIM,2),ACKSTAT="^AA^CA^"[(U_ACKSTAT_U)
 ;ID of Acknowldeged message
 S ACKEDMES=$P(LINE,INDELIM,3)
 I '$L(ACKEDMES) S INHERR="No message identified to acknowledge" G ERR
 I '$D(^INTHU("C",ACKEDMES)) S INHERR="Acknowledge for unknown message ID - "_ACKEDMES G ERR
 ;Save any @INV@("MSA6") Error Messages (HL7 V2.3 format)
 S INERMSG=$P(LINE,INDELIM,7)
 ;Get the first ERR segment
 D GET^INHOU(UIF,0)
 S ERRMSG=$P($G(LINE),INDELIM,2)
 ;Give priority to ERR Segment Error Messages
 S:'$L(ERRMSG) ERRMSG=INERMSG
 ;Log acknowledge
 D ACKLOG^INHU(UIF,ACKEDMES,ACKSTAT,ERRMSG)
 ;
 Q
 ;
ERR ;Error module
 S INSTERR=2
 Q
 ;
NOTES ;Description:
 ;This program is called as part of the INCOMING ACK script
 ;
 ;Issues:
 ;Repeating ERR segments are not recognized
 ;
