INHVSTUB(UIF,ERROR) ; FRW ; 18 Apr 94 19:56; Stub Transceiver
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 ;Quit with successful status
 Q 0
 ;
 ;
 ;This routine can be used as a "stub" transceiver routine for
 ;destinations that do not have communications drivers yet.
 ;All messages for a destination with this transceiver routine will
 ;be marked as transmitted.
 ;
 ;*NOTE*  This does not emulate/support acknowledge messages, if
 ;a transaction type is expecting an ACKnowledge message
 ;back from the remote system it will never receive it.
 ;The message status will remain at "pending acknowledgement" and
 ;never go to "complete"
 ;
 ;*ENHANCEMENT* Try to build support for messages that require ACKs
 ;
 ;If transaction type requires ACK then generate ACK message
 ;through  $$ACK^INHF(trans type).
 ;   - need to set up:  
 ;       ACK transaction type
 ;       ACK script (through Script Generator)
 ;
QUIT Q
