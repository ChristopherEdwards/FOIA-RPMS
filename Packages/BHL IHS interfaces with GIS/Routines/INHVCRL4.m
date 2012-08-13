INHVCRL4 ;JKB,KAC ; 20 Oct 1999 18:38 ; Logon Server (LoS) - Determine destination for inbound msg
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 Q
DEST2 ;Entry point From Background Message
 ;Anyone can log in flag
 N INSEND
 S INANYONE=1
 S INSEND=$P(INMSH,INDELIM,3)
 S $P(INSEND,"\")="CIW",$P(INMSH,INDELIM,3)=INSEND
 D DEST
 Q
DEST3 ;Entry point From Background Message
 ;Anyone can log in flag
 N INSEND
 S INANYONE=1
 S INSEND=$P(INMSH,INDELIM,3)
 S $P(INSEND,"\")="BCC",$P(INMSH,INDELIM,3)=INSEND
 D DEST
 Q
DEST ; Determine destination for an inbound logon message.
 ;
 ; Called by:
 ;   -  eXec'd from IN^INHUSEN where the context includes the input vars 
 ;      & expects the output vars documented below.  The code that is
 ;      eXec'd is set in the Logon Server (LoS), INHVCRL (file #4004, 
 ;      node #8).
 ;
 ; Input: 
 ;   ING      - (req) var name for inbound data array
 ;   INTYP    - (req) msg type
 ;   INEVN    - (req) event type
 ;   INMSH    - (req) MSH segment
 ;   INDELIM  - (req) segment delimiter
 ;
 ; Variables:
 ;   X        - scratch
 ;   INBLDST  - entry reference to build array of valid LoS inbound
 ;              destinations based on sending application
 ;   INMESSID - message control ID (MSH:10)
 ;   INRECV   - receiving app (MSH:5) - Not currently used.
 ;   INSEND   - sending app (MSH:3)
 ;
 ; Output:
 ;   INDST    - INTERFACE DESTINATION name
 ;   INDSTP   - INTERFACE DESTINATION ptr
 ;              Undefined if destination determination fails.
 ;   INDEST   - array containing valid LoS inbound destinations based 
 ;              on sending application
 ;              Format: INDEST(msg-type_event-type)=
 ;                      INTERFACE DESTINATION name for inbound msg
 ;   INERR    - array containing error msg used to log an error
 ;              Unaltered if destination determination succeeds.
 ;
 K INDSTP
 N INBLDST,INMESSID,INRECV,INSEND,X
 S INSEND=$P(INMSH,INDELIM,3),INRECV=$P(INMSH,INDELIM,5),INMESSID=$P(INMSH,INDELIM,10)
 ;
 ; Build INDEST array
 S INBLDST=$P(INSEND,"\")_"BLD"
 I '$L($TEXT(@INBLDST)) S INERR="Message "_INMESSID_" contains unsupported sending application: '"_INSEND_"'" Q
 S:INSEND["DDSA" INANYONE=1   ; DDSA
 D @INBLDST
 ;
 S X=$G(INTYP)_$G(INEVN)
 I $D(INDEST(X)) S INDST=INDEST(X) I $D(^INRHD("B",INDST)) S INDSTP=$O(^(INDST,0))
 Q
 ;
DDSABLD ;DDSA
PWSBLD ; Build array containing valid inbound PWS destinations for LoS.
 ;
 ; Output:
 ;   INDEST   - array containing valid PWS inbound destinations for LoS
 ;              Format: INDEST(msg-type_event-type)=
 ;                      INTERFACE DESTINATION name for inbound msg
 ;
 Q:$G(INDEST)="PWS"  ; array already exists?
 K INDEST
 S INDEST="PWS"
 S INDEST("ZILZ01")="HL PWS LOGON REQUEST FROM REMOTE SYSTEM"
 Q
CIWBLD ; Build array containing valid inbound PWS destinations for LoS.
 ;
 ; Output:
 ;   INDEST   - array containing valid CIW inbound destinations for LoS
 ;              Format: INDEST(msg-type_event-type)=
 ;                      INTERFACE DESTINATION name for inbound msg
 ;
 Q:$G(INDEST)="CIW"  ; array already exists?
 K INDEST
 S INDEST="CIW"
 S INDEST("ZILZ01")="HL CIW LOGON REQUEST FROM REMOTE SYSTEM"
 Q
 ;
BCCBLD ; Build array containing valid inbound BCC destinations for LoS.
 ;
 ; Output:
 ;   INDEST   - array containing valid PWS inbound destinations for LoS
 ;              Format: INDEST(msg-type_event-type)=
 ;                      INTERFACE DESTINATION name for inbound msg
 ;
 Q:$G(INDEST)="BCC"  ; array already exists?
 K INDEST
 S INDEST="BCC"
 S INDEST("ZILZ01")="HL BCC LOGON REQUEST FROM REMOTE SYSTEM"
 Q
