INHVCRV ; JC Hrubovcak ; 22 Oct 1999 15:49 ; 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ; HL7/PWS logon utilities
 Q
 ;
VALID(INV,INUIF,INOA,INODA) ; subroutine, VALIDate LoS logon request
 ; Input:
 ; INV array  - (req) ZIL1=REQ, ZIL2=IP address, ZIL3=port, ZIL7=requested
 ;                    division, ZIL8=access code, ZIL9=verify code
 ; INUIF      - (req) UNIVERSAL INTERFACE IEN
 ;
 ; Output:
 ; INOA array  - (pbr) ZIL1=REQ, ZIL4=user, ZIL5=provider, ZIL6=timeout, 
 ;                     ZIL10=ticket/key.  These values are returned to
 ;                     the remote system.
 ; INODA array - (pbr) 1st subscript file#, 2nd subscript IEN.  Not used.
 ;
 N B,INBPNAPS,INDSTP,INERR
 ; Initialization
 D RTNINIT S INOA("ZIL1")="REQ"
 S B=$$INPARMS^INHVCRL2(.INDSTP,.INPARMS,.INERR,INUIF) I B D LOGERR(.INERR),NACK Q
 S INBPNAPS=+$P($G(^INRHT(INPARMS(INDSTP,"TTIN"),0)),U,17) I INBPNAPS'>0 D LOGERR("Missing Application Process pointer for INTERFACE TRANSACTION TYPE, '"_INPARMS(INDSTP,"TTIN01")_"'"),NACK Q
 ; validate IP address
 S B=$$VALIDIP^INHULOG(INBPNAPS,@INV@("ZIL2")) I B D LOGERR("Invalid remote IP address '"_@INV@("ZIL2")_"': "_$P(B,U,2)),NACK Q
 ; validate user
 S B=$$LOGON(.INV,.INOA,.INODA) I B'>0 D LOGERR("Invalid LOGON: "_$P(B,U,2)),NACK Q
 ; create Application server (ApS)
 S B=$$NEWSVR^INHVCRV1(INBPNAPS,.INV,.INOA) I B D LOGERR("'Application Server creation' failed: "_B),NACK Q
 ;
 ; any additional validation would follow here
 ;
 D ACCEPT,CLEANUP ; successful logon
 Q
 ;
REVALID(INV,INOA) ; subroutine, Validate ApS logon request
 ; Input:
 ; INV array  - (req) ZIL1=ON, ZIL2=IP address, ZIL3=port, ZIL7=requested
 ;                    division, ZIL8=access code, ZIL9=verify code,
 ;                    ZIL11=scrambled,seeded key/ticket from remote sys
 ;
 ; Input passed from ApS (all required):
 ; INADDR   = IP address of remote server to connect to as a TCP client,
 ;            or null to open as a TCP server
 ; INBPN    = BACKGROUND PROCESS CONTROL IEN for ApS
 ; INDUZ    = USER IEN
 ; INPORT   = IP port to open (client or server)
 ; INTICK   = security ticket
 ;
 ; Output:
 ; INOA array  - (pbr) No ZIL segment values are returned to the remote
 ;                     system (in the ApS Ack).
 ; INODA array - 1st subscript file#, 2nd subscript IEN.  Not used.
 ;
 N B,INUSER
 ; Initialization
 D RTNINIT
 S INOA("~NOZIL")=1 ; boolean flag, no ZIL segments returned
 ; validate scrambled,seeded key/ticket from remote system
 S INTICK=$G(INTICK) I '$L(INTICK) D LOGERR("Logon ticket missing") Q
 S B=$P($G(^INTHPC(INBPN,7)),U,4) I '$L(B) D LOGERR("Missing Key Frame") Q
 I $$FRHASH(INTICK,B)'=@INV@("ZIL11") D LOGERR("Invalid framed ticket sent by remote system") Q
 ; validate remote IP address/port against values received from LoS
 I $G(INADDR)'=@INV@("ZIL2") D LOGERR("Remote IP address does not match IP address validated by CHCS Logon Server") Q
 I $G(INPORT)'=@INV@("ZIL3") D LOGERR("Remote port does not match port validated by CHCS Logon Server") Q
 ; validate user
 S INUSER=$$LOGON(.INV,.INOA,.INODA) K INOA("~NOZIL") I INUSER'>0 D LOGERR("Invalid LOGON: "_$P(INUSER,U,2)) Q
 ; validate remote user against values received from LoS
 I $G(INDUZ)'=INUSER D LOGERR("Remote user does not match user validated by CHCS Logon Server") Q
 ;
 ; any additional validation would follow here
 ;
 D ACCEPT,CLEANUP,LGNLOG^INHULOG(INUSER) ; successful logon
 Q
 ;
LOGON(INV,INOA,INODA) ; $$function - Validate user, based on information sent
 ; by remote system (INV).  Get information to return to remote system
 ; (INOA).
 ;
 ; Input:
 ; INV array  - (req) ZIL7=requested division, ZIL8=access code, 
 ;                    ZIL9=verify code.  Note that validating a
 ;                    "requested" division is NOT currently implemented.
 ;
 ; Output:
 ; INOA array  - (pbr) ZIL4=user, ZIL5=provider, ZIL6=timeout, 
 ;                     ZIL10=ticket/key if LoS logon (not ApS logon).
 ; INODA array - (pbr) 1st subscript file#, 2nd subscript IEN.
 ;
 ; Function returns:  USER IEN = successful user validation
 ;                    "0^Error msg" = failure
 ;
 ; Symbol table Input: - INANYONE 1 - Anyone can access, 
 ;     0 - Provider access only
 ;
 N INH9,X,Y,Z,INHZERO
 D SETDT^UTDT
 ; access & verify code
 S INH9("AC")=$G(@INV@("ZIL8")),INH9("VC")=$G(@INV@("ZIL9"))
 ; requested divison
 S INH9("REQDIV")=$G(@INV@("ZIL7"))
 ; User's zero node is returned in Z
 S INH9("USER")=$$GETDUZ^INHULOG(INH9("AC"),INH9("VC"),.Z)
 ;
 I INH9("USER")'>0 Q "0^Invalid Access/Verify code"
 S X=$$DIVCHK^INHULOG(INH9("USER")) Q:'X "0^"_X  ; validate division
 ; Determine if user is an authorized HCP
 S INH9("HCP")=$P($G(^DIC(3,INH9("USER"),8000)),"^") ; get provider
 ;;Folloing logic is specific to CHCS. Must be revised if used for IHS
 ;I '$G(INANYONE) S X=$$PWSPRO^ORGISPRO(INH9("USER")) Q:X "0^User '"_INH9("USER")_"' is not an authorized HCP"
 ; get remote system timeout value (used to determine if remote has
 ; disconnected w/out notifying connected system)
 S INH9("DTIME")=$$DTIME^INHULOG(INH9("USER"),900)
 S INHZERO=$G(^DIC(3,INH9("USER"),0))
 S INH9("FMACC")=$P(INHZERO,"^",4)
 S INH9("DEFDIV")=$P(INHZERO,"^",16)
 S INH9("MSIGN")=$P($G(^DIC(3,INH9("USER"),200)),"^",4)
 S INODA(3,INH9("USER"))="" S:'$G(INANYONE) INODA(6,INH9("HCP"))=""
 ; ZIL segment is returned in LoS Ack (not in ApS Ack)
 S:'$G(INOA("~NOZIL")) INOA("ZIL4")=INH9("USER"),INOA("ZIL5")=INH9("HCP"),INOA("ZIL6")=INH9("DTIME"),INOA("ZIL10")=$$TICKET^INHULOG,INOA("ZIL12")=INH9("FMACC"),INOA("ZIL13")=INH9("DEFDIV"),INOA("ZIL14")=INH9("MSIGN")
 ;
 Q INH9("USER")  ; successful validation
 ;
LOGOFF(INV,INOA) ; Lookup/Store call for ApS logoff msg
 S INOA("INACKTXT")="CHCS Logoff Error",INOA("INSTAT")="AE"  ; in case of error
 ; note: logic derived from H^XUS, except no device calls are made
 S DUZ=+$G(DUZ) N A S A=$G(^ZUTL("XQ",$J,0)) I A,$D(^XUSEC(0,A,0)) L +^XUSEC(0,A,0):1 I  D SETDT^UTDT S %=$P($H,",",2),$P(^XUSEC(0,A,0),U,4)=DT_(%\60#60/100+(%\3600)+(%#60/10000)/100) L -^XUSEC(0,A,0)
 K:$L($G(DUZ)) ^XMB7(DUZ,100,$$DEVID^%ZTOS),^($I),^($P)   ; indicates where currently logged on
 D CLRSTOR^INHULOG    ; clear scratch storage
 ; the application cleanup (see APPERR^ZU) would go here, if needed
 D ACCEPT   ; Application Accept
 Q
 ;
RTNINIT ; init return values, INOA & INODA array, error message into INOA
 K INOA,INODA S INODA="",INOA("INSTAT")="AE",INOA("INACKTXT")="Invalid CHCS Logon Attempt",INOA("INORIGID")=@INV@("MSH10")
 Q
 ;
ACCEPT ; set "INSTAT" to Application Accept, KILL the error text
 K INOA("INACKTXT") S INOA("INSTAT")="AA"
 Q
 ;
CLEANUP ; Cleanup following "successful" validation of logon message.
 ; Input: INUIF=UIF IEN of inbound msg
 ; Output: None.
 ;
 ; Delete information from ZIL segment(s) in inbound msg (security).
 L +^INTHU(INUIF,0):0 I  D
 . N A,B,J M A=^INTHU(INUIF,3) S (B,J)=0 F  S J=$O(A(J)) Q:'J  I $E($G(A(J,0)),1,3)="ZIL" S A(J,0)="ZIL^<SEGMENT CLEARED>|CR|",B=1
 . I B K ^INTHU(INUIF,3) M ^INTHU(INUIF,3)=A
 . L -^INTHU(INUIF,0)
 Q
 ;
FRHASH(INTICKET,INFRAME) ; $$function - frame the ticket, encrypt, return
 N H,L,X S L=$L(INFRAME),H=L+1\2,X=$E(INFRAME,1,H)_INTICKET_$E(INFRAME,H+1,L)
 D ^XUSHSH Q X
 ;
NACK ; negative acknowledgement
 N % F %="ZIL4","ZIL5","ZIL6","ZIL10" S INOA(%)=""
 Q
 ;
LOGERR(E) ; log error message E
 S INSTERR=$G(INSTERR) D ERROR^INHS(E,2)
 Q
 ;
