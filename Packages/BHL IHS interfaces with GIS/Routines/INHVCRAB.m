INHVCRAB ;JKB ; 8 Jul 95 15:57; BCC-specific ApS Code
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 Q  ;no top entry
 ;
 ; This routine contains Application Server (ApS) code specific for the
 ; BCC application interface.
 ;
DEST ; determine destination for an inbound BCC message
 ; Note  : this code is eXec'd from IN^INHUSEN where the context
 ;         includes the input vars & expects the output vars doc'd below
 ; Input : ING     (req) = var name for inbound data array
 ;         INTYP   (req) = msg type
 ;         INEVN   (req) = event type
 ;         INMSH   (req) = MSH segment
 ;         INDELIM (req) = segment delimeter
 ; Output: void
 ;         INDST   = INTERFACE DESTINATION Name
 ;         INDSTP  = INTERFACE DESTINATION ptr (undef if no destination)
 ;         INDEST  = array of valid inbound destinations
 ; Local : INORTYP = ORDER TYPE (ZOR:1)
 ;         INRECV  = receiving app (MSH:5)
 ;         INSEND  = sending app (MSH:3)
 K INDSTP
 N I,INORTYP,INRECV,INSEND,X
 S INSEND=$P(INMSH,INDELIM,3),INRECV=$P(INMSH,INDELIM,5),INORTYP=""
 ; build INDEST() if not done so for BCC
 I $G(INDEST)'="BCC" S INDEST="BCC" F I=1:1 S X=$P($T(DESTTXT+I),";;",2) Q:'$L(X)  S INDEST($TR($P(X,U,1,3),U,""))=$P(X,U,4)
 I INTYP="ORM" F I=1:1 S X=$G(@ING@(I)) Q:'$L(X)  I $P(X,INDELIM)="ZOR" S INORTYP=$P(X,INDELIM,2) Q
 S X=INTYP_$S(INTYP="ZPW":"*",1:INEVN)_INORTYP
 D LOG^INHVCRA1("msg type is "_X,5)
 I $D(INDEST(X)) S INDST=INDEST(X) I $D(^INRHD("B",INDST)) S INDSTP=$O(^(INDST,0))
 Q
 ;
DESTTXT ; the following lines are used by DEST to build INDEST() for BCC
 ;;ZIL^Z02^^HL INH APPLICATION SERVER LOGON
 ;;ZIL^Z03^^HL INH APPLICATION SERVER LOGOFF
 ;;ZPW^*^^HL ORPW PATIENT SELECT
 ;;ORM^O01^4^HL ORPW LAB ORDER IN
 ;;ORM^O01^5^HL ORPW RAD ORDER - IN
 ;;ORM^O01^9^HL ORPW RX ORDER - IN
 ;;QRY^A19^^HL ORPW PATIENT LOOKUP - IN
