INHQRIN1 ;KAC ; 9 Jul 99 16:24; GIS Query/Response - Supporting Utilities
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 Q
 ;
DEST ; Determine destination for an inbound query response messages
 ;
 ; Called by:
 ;   -  eXec'd from IN^INHUSEN where the context includes the input vars 
 ;      & expects the output vars documented below - called by
 ;      querying system receiver
 ; Input: 
 ;   ING      - (req) var name for inbound data array
 ;   INTYP    - (req) msg type
 ;   INEVN    - (req) event type
 ;   INMSH    - (req) MSH segment
 ;   INDELIM  - (req) segment delimiter
 ;
 ; Variables:
 ;   CPX        - scratch
 ;   INBLDST  - entry reference to build array of valid inbound
 ;              destinations based on sending application
 ;   INMESSID - message control ID (MSH:10)
 ;   INRECV   - receiving app (MSH:5) - Not currently used.
 ;   INSEND   - sending app (MSH:3)
 ;
 ; Output:
 ;   INDST    - INTERFACE DESTINATION name
 ;   INDSTP   - INTERFACE DESTINATION ptr
 ;              Undefined if destination determination fails.
 ;   INDEST   - array containing valid inbound destinations based 
 ;              on sending application
 ;              Format: INDEST(msg-type_event-type)=
 ;                      INTERFACE DESTINATION name for inbound msg
 ;   INERR    - array containing error msg used to log an error
 ;              unaltered if destination determination succeeds.
 ;
 K INDSTP
 N INBLDST,INMESSID,INRECV,INSEND,CPX
 S INSEND=$P(INMSH,INDELIM,3),INRECV=$P(INMSH,INDELIM,5),INMESSID=$P(INMSH,INDELIM,10)
 ;
 ; Build INDEST array
 D QR
 ;
 S CPX=$G(INTYP)_$G(INEVN)
 I $D(INDEST(CPX)) S INDST=INDEST(CPX) I $D(^INRHD("B",INDST)) S INDSTP=$O(^(INDST,0))
 Q
 ;
QR ; Build array containing valid inbound GIS QR destinations.
 ; Output:
 ;   INDEST   - array containing valid inbound destinations
 ;              Format: INDEST(msg-type_event-type) = INTERFACE DESTINATION name for inbound msg
 Q:$G(INDEST)="QR"  ; array already exists
 K INDEST
 S INDEST="QR"
 ;network
 S INDEST("QRYQ02")="HL GIS QUERY IN"
 S INDEST("ACKACK")="INCOMING ACK"
 Q
 ;
 ;
