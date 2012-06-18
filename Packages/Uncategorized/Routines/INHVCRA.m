INHVCRA ;KAC,JKB ; 7 Mar 96 14:02; Application Server (ApS)
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 Q  ;no top entry
 ;
 ; The Application Server (ApS) accepts service requests from remote
 ; systems in the form of HL7 messages.  If the request maps to an
 ; active inbound Transaction Type, the message is processed.  An 
 ; acknowledgement message is then transmitted to the remote system.
 ; If signalled to stop, the ApS will complete any transaction in 
 ; progress and then terminate.
 ;
 ; The ApS has been originally designed and tested to initiate as a
 ; client in the TCP client/server model.  However, the code should be
 ; able to allow the ApS to open as a server merely by not passing in an
 ; IP address (INADDR at EN).
 ;
 ; The ApS is intended to be generic with the specifics for a particular
 ; interface to be held in tables.  The related BACKGROUND PROCESS entry
 ; is "PWS APP SERVER" with a corresponding INTERFACE DESTINATION of
 ; "HL PWS APP SERVER".  For PWS, the PWS specific code is in ^INHVCRAP.
 ;
EN(INBPN,INHSRVR,INADDR,INPORT,INTICK,INDUZ) ;
 ;
 ; Input    : all required
 ; INBPN    = BACKGROUND PROCESS CONTROL ptr for ApS
 ; INHSRVR  = server number for this particular ApS
 ; INADDR   = IP address of remote server to connect to as a TCP client,
 ;            or null to open as a TCP server
 ; INPORT   = IP port to open (client or server)
 ; INTICK   = security ticket
 ; INDUZ    = USER ptr
 ;
 ; Output   : void
 ;
 ; Internal :
 ; ERR      = scratch error holder
 ; INACKUIF = UNIVERSAL INTERFACE IEN of outbound Ack
 ; INCHNL   = TCP channel assigned to ApS
 ; INDATA   = array containing msg received from remote system
 ; INDEST   = array of valid inbound destinations
 ; INDST    = INTERFACE DESTINATION Name for an inbound msg
 ; INDSTOFF = INTERFACE DESTINATION Name for the ApS login msg
 ; INDSTON  = INTERFACE DESTINATION Name for the ApS logoff msg
 ; INDSTP   = INTERFACE DESTINATION ptr for an inbound msg
 ; INDSTR   = INTERFACE DESTINATION ptr for the ApS receiver
 ; INERR    = error string used to log an error
 ; ING      = indirected variable containing array, INDATA
 ; INIP     = array of init parms from BACKGROUND PROCESS
 ; INLOGON  = boolean flag denoting ApS has processed the logon msg
 ; INMEM    = memory var used ultimately by %INET
 ; INMSGP   = inbound message parameter array (see $$INPARMS^INHVCRL2)
 ; INOA     = msg array output from inbound msg script for use in ack
 ; INODA    = same as INOA, but for file pointers
 ; INPNAME  = name for this BACKGROUND PROCESS
 ; INUIF    = UNIVERSAL INTERFACE ptr of inbound msg
 ; INUSEQ   = Sequence Number Protocol flag (0=off,1=on)
 ; INXDST   = Executable code used by ^INHUSEN to determine INTERFACE
 ;            DESTINATION for an inbound msg
 ;
 ; init ApS
 N ERR,INACKUIF,INCHNL,INDATA,INDEST,INDST,INDSTON,INDSTOFF,INDSTP,INDSTR,INERR,ING,INIP,INLOGON,INMEM,INMSGP,INOA,INODA,INPNAME,INUIF,INUSEQ,INV,INXDST,X
 S U="^",ERR=0,X="ERR^INHVCRA",@^%ZOSF("TRAP"),INPNAME=$P(^INTHPC(INBPN,0),U)
 ; determine whether debugging and/or instrumentation is on
 D DEBUG^INHVCRA1(),AUDCHK^XUSAUD
 ; start GIS background process audit if instrumentation on
 D:$D(XUAUDIT) ITIME^XUSAUD(INPNAME,INHSRVR)
 L +^INRHB("RUN","SRVR",INBPN,INHSRVR):10 E  D LOG^INHVCRA1("can't lock run node for ApS"_INHSRVR,"E") S ERR=1 G SHUTDWN
 D LOG^INHVCRA1("initing Aps for user "_INDUZ,1)
 S ERR=$$SETENV^INHULOG(INDUZ) I ERR D LOG^INHVCRA1("bad init for ApS"_INHSRVR_": "_$P(ERR,U,2),"E") G SHUTDWN
 ; get BACKGROUND PROCESS CONTROL params for the ApS
 D INIT^INHUVUT1(INBPN,.INIP)
 S INDSTR=$P($G(^INTHPC(INBPN,0)),U,7),INXDST=$G(^(8))
 I 'INDSTR D LOG^INHVCRA1("no Destination designated for Background Process","E") S ERR=1 G SHUTDWN
 ; get INTERFACE DESTINATION params for the ApS
 S INUSEQ=$P($G(^INRHD(INDSTR,0)),U,9)
 ; get logon/logoff msg destinations (these could be table based)
 I '$$LOGONDS(.INDSTON) D LOG^INHVCRA1("no logon messsage destination for ApS","E") S ERR=1 G SHUTDWN
 I '$$LOGOFFDS(.INDSTOFF) D LOG^INHVCRA1("no logoff messsage destination for ApS","E") S ERR=1 G SHUTDWN
 D LOG^INHVCRA1("Aps configured for user "_DUZ,1)
 ; check shutdown status
 I '$$RUN^INHOTM G SHUTDWN
 ; open connection
 D LOG^INHVCRA1("connecting to "_INADDR_"/"_INPORT)
 D OPEN^INHVCRA1(.INCHNL,.INMEM,.INADDR,INPORT,.INIP)
 I 'INCHNL D LOG^INHVCRA1(INCHNL,"E") S ERR=1 G SHUTDWN
 D LOG^INHVCRA1("connected")
 ;
 ; Main Message Loop
 S INLOGON="" F  D  Q:INLOGON=0!'$$RUN^INHOTM
 .; update background process audit
 .D:$D(XUAUDIT) ITIME^XUSAUD(INPNAME,INHSRVR)
 .; receive message
 .D LOG^INHVCRA1("listening for user "_DUZ)
 .K INACKUIF,INDST,INDSTP,INERR,INOA,INODA,INUIF
 .S ING="INDATA",ERR=$$RECEIVE^INHVCRA1(.ING,INCHNL,.INIP,.INERR,.INMEM)
 .I ERR D LOG^INHVCRA1(.INERR,"E") S INLOGON=0 Q
 .; verify and store message
 .D LOG^INHVCRA1("processing inbound message")
 .; start transaction audit, trans type not known (stop is in INHUSEN)
 .D:$D(XUAUDIT) TTSTRT^XUSAUD("","",INPNAME,INHSRVR,"RECEIVE")
 .S ERR=$$IN^INHUSEN(ING,.INDEST,INDSTR,INUSEQ,.INACKUIF,.INERR,INXDST,.INUIF,1)
 .; if message not stored, build error array to include input array
 .I $G(INUIF)<1 D
 ..N I,J,X
 ..I $D(INERR)=1 S X=INERR K INERR I $L(X) S INERR(1)=X
 ..S I=$O(INERR(""),-1)+1,J=""
 ..S INERR(I)="msg not stored - input buffer "_ING_" follows:"
 ..F  S J=$O(@ING@(J)) Q:J=""  S I=I+1,INERR(I)=J_U_@ING@(J)
 .K @ING
 .I ERR D REJECT(.INERR) Q
 .; get message params for inbound destination
 .S ERR=$$INPARMS^INHVCRL2(.INDSTP,.INMSGP,.INERR,INUIF)
 .I ERR D REJECT(.INERR) Q
 .; if no error and ack built, must be a commit ack
 .I $G(INACKUIF)>0 S INOA("INSTAT")="CA" D SENDACK
 .S INDST=INMSGP(INDSTP,"DSIN01")
 .; check for receipt of a 2nd logon msg
 .I INLOGON,INDST=INDSTON D REJECT("unexpected 2nd logon message") Q
 .; check whether logon is first msg received
 .I 'INLOGON S INLOGON=INDST=INDSTON I 'INLOGON D REJECT("first message not a logon") Q  ; shutdown ApS
 .; set flag if logoff msg has been received
 .I INDST=INDSTOFF S INLOGON=0
 .; execute the inbound script for transaction
 .D LOG^INHVCRA1("executing for destination "_INDST,1)
 .; start transaction audit
 .D:$D(XUAUDIT) TTSTRT^XUSAUD(INUIF,"",INPNAME,INHSRVR,"SCRIPT")
 .S ERR=$$RUNIN^INHVCRL3(INUIF,.INMSGP,INDSTP,.INOA,.INODA,.INERR)
 .; stop transaction audit
 .D:$D(XUAUDIT) TTSTP^XUSAUD(ERR)
 .I ERR D REJECT(.INERR) S:INDST=INDSTON INLOGON=0 Q  ; shutdown ApS if logon failed
 .; send Ack
 .S INOA("INSTAT")="AA" D SENDACK
 .I ERR S:INDST=INDSTON INLOGON=0 Q  ; shutdown ApS if logon Ack failed
 ;
SHUTDWN ; shutdown ApS
 D:$G(INCHNL) CLOSE^%INET(INCHNL)
 K ^UTILITY("INREC",$J),^UTILITY("INV",$J)
 K ^INRHB("RUN","SRVR",INBPN,INHSRVR)
 L -^INRHB("RUN","SRVR",INBPN,INHSRVR)
 D LOG^INHVCRA1("shutdown",1),DEBUG^INHVCRA1(0)
 ; stop background process audit
 D:$D(XUAUDIT) AUDSTP^XUSAUD
 Q
 ;
ERR ; error trap vector
 ; reset trap
 S ERR=1,X="SHUTDWN^INHVCRA",@^%ZOSF("TRAP")
 ; log error
 D ERRLOG^%ZTOS,LOG^INHVCRA1($$ERRMSG^INHU1,"E")
 G SHUTDWN
 ;
REJECT(INERR) ; reject inbound message
 ; Input :  INERR (req) = error msg
 ; Output:  void
 ; log error
 D LOG^INHVCRA1(.INERR,"E")
 S INOA("INSTAT")="AR"
SENDACK ; send acknowledgement
 ; Input :  INACKUIF,INBPN,INCHNL,INERR,INIP(),INOA,INUIF,INMSGP()
 ; Output:  void
 ;          ERR,INACKUIF
 I '$D(INOA("INSTAT")) D LOG^INHVCRA1("unknown ack status","E") S INOA("INSTAT")="AE"
 I $G(INACKUIF)<1 D  Q:$G(INACKUIF)<1
 .I $G(INUIF)<1 D LOG^INHVCRA1("msg unavailable to ack","E") S ERR=1 Q
 .D LOG^INHVCRA1("creating ack for "_INUIF)
 .D ACK^INHOS(INMSGP(INDSTP,"TTIN"),"",INUIF,.INERR,.INOA,.INODA,1,.INACKUIF) K:$L($G(INV)) @INV
 .I $G(INACKUIF)<1 D LOG^INHVCRA1("error in ack creation","E") S ERR=1 Q
 D LOG^INHVCRA1("sending "_INOA("INSTAT")_" ack "_INACKUIF)
 ; start transaction audit
 D:$D(XUAUDIT) TTSTRT^XUSAUD(INACKUIF,"",INPNAME,INHSRVR,"TRANSMIT")
 S ERR=$$SEND^INHUVUT(INACKUIF,INCHNL,.INIP)
 ; stop transaction audit
 D:$D(XUAUDIT) TTSTP^XUSAUD(ERR)
 I ERR D LOG^INHVCRA1("error in ack transmission","E") S ERR=1 Q
 D LOG^INHVCRA1("ack sent","S",$E(INOA("INSTAT"),2)="A")
 Q
 ;
LOGONDS(X) ; get the logon message destination
 ; Input : X (opt) = var for logon msg INTERFACE DESTINATION Name (pbr)
 ; Output: boolean; returns true if logon dest found; else false
 S X="HL INH APPLICATION SERVER LOGON"
 Q $D(^INRHD("B",X))>9
 ;
LOGOFFDS(X) ; get the logoff message destination
 ; Input : X (opt) = var for logoff msg INTERFACE DESTINATION Name (pbr)
 ; Output: boolean; returns true if logoff dest found; else false
 S X="HL INH APPLICATION SERVER LOGOFF"
 Q $D(^INRHD("B",X))>9
