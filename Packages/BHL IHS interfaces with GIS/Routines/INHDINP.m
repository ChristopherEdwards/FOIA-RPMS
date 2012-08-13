INHDINP ;DGH; 27 Oct 98 14:27;DINPACS selective routing
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 ;Contains tag SRMC with selective routing logic.
 Q
 ;
SRMC(DINPDATA) ;Selective routing entry point
 ;INPUT:
 ; DINPDATA must be passed by reference as INSRDATA
 ;
 ;Default if no array exists is to broadcast
 I '$D(@INA@("DMISID","DINP")) S DINPDATA=0 Q
 N I,J
 ;Build INSRDATA array
 S I="" F  S I=$O(@INA@("DMISID","DINP",I)) Q:'$L(I)  S DINPDATA(I)=""
 Q
 ;
