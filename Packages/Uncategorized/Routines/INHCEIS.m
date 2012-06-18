INHCEIS ;DGH; 4 Jun 98 13:46;Multiple CEIS selective routing
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;CHCS TOOLS_460; GEN 1; 15-JUN-1998
 ;COPYRIGHT 1997 SAIC
 ;
 ;Contains tag SRMC with selective routing logic.
 Q
 ;
SRMC(CEISDATA) ;Selective routing entry point
 ;INPUT:
 ; CEISDATA must be passed by reference as INSRDATA
 ;
 ;If there is only one entry in the MHCMIS SITE PARAMETER FILE,
 ;set flag to broadcast (no subordinate destinations should be defined).
 S X=0,X=$O(^XXDBE(30203,X)) I '$O(^XXDBE(30203,X)) S CEISDATA=0 Q
 ;Default if no array exists is to broadcast
 I '$D(@INA@("DMISID","CEIS")) S CEISDATA=0 Q
 N I,J
 ;Build INSRDATA array
 S I="" F  S I=$O(@INA@("DMISID","CEIS",I)) Q:'I  S CEISDATA(I)=""
 Q
 ;
