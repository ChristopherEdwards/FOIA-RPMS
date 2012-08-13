INHVDBSS ;JKB,KAC,DJL ; 20 Feb 96 16:11; DBSS Receiver - Determine destination for inbound msg
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 Q
 ;
DEST ; Determine destination for an inbound DBSS messages.
 ;
 ; Called by:
 ;   -  eXec'd from IN^INHUSEN where the context includes the input vars 
 ;      & expects the output vars documented below.
 ;
 ; Input: 
 ;   INTYP    - (req) msg type
 ;   INEVN    - (req) event type
 ;
 ; Variables:
 ;   X        - scratch
 ;
 ; Output:
 ;   INDST    - INTERFACE DESTINATION name
 ;   INDSTP   - INTERFACE DESTINATION ptr
 ;              Undefined if destination determination fails.
 ;   INDEST   - array containing valid DBSS inbound destinations based 
 ;              on sending application
 ;              Format: INDEST(msg-type_event-type)=
 ;                      INTERFACE DESTINATION name for inbound msg
 ;
 K INDSTP
 N X
 ;
 ; Build INDEST array
 D DBSSND
 ;
 S X=$G(INTYP)_$G(INEVN)
 I $D(INDEST(X)) S INDST=INDEST(X) I $D(^INRHD("B",INDST)) S INDSTP=$O(^(INDST,0))
 Q
 ;
DBSSND ; Build array containing valid inbound DBSS destinations.
 ;
 ; Output:
 ;   INDEST   - array containing valid DBSS inbound destinations
 ;              Format: INDEST(msg-type_event-type)=
 ;                      INTERFACE DESTINATION name for inbound msg
 ;
 Q:$G(INDEST)="DBSS"  ; array already exists?
 K INDEST
 S INDEST="DBSS"
 S INDEST("ADTA08")="HL DBSS UPDATE PATIENT -IN"
 S INDEST("ADTA18")="HL DBSS MERGE PATIENT -IN"
 S INDEST("ORUR01")="HL LAB DBSS RESULT -IN"
 S INDEST("ORRO02")="INCOMING ACK"
 Q
 ;
