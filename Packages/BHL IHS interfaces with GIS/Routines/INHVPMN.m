INHVPMN ;JKB,KAC,DJL,CHEM ; 17 Aug 1999 16:54:18; PMN Receiver - Determine destination for inbound msg
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;CHCS TOOLS_450; GEN 3; 26-SEP-1996
 ;COPYRIGHT 1995 SAIC
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
 D PMNDST
 ;
 S X=$G(INTYP)_$G(INEVN)
 I $D(INDEST(X)) S INDST=INDEST(X) I $D(^INRHD("B",INDST)) S INDSTP=$O(^(INDST,0))
 Q
 ;
PMNDST ; Build array containing valid inbound PMN destinations.
 ;
 ; Output:
 ;   INDEST   - array containing valid PMN inbound destinations
 ;              Format: INDEST(msg-type_event-type)=
 ;                      INTERFACE DESTINATION name for inbound msg
 ;
 Q:$G(INDEST)="PMN"  ; array already exists?
 K INDEST
 S INDEST="PMN"
 S INDEST("PMNA28")="HL DG ADD PERSON - IN (PMN)"
 Q
 ;
