INHVCRL ;DGH,KAC ; 19 Mar 96 10:43; Logon Server (LoS) Background Controller
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 Q
 ;
EN ; The Logon Server (LoS) accepts requests for access from remote
 ; systems.  These requests are in the form of HL7 messages.  If the
 ; message meets HL7 specifications, the request is validated.  An
 ; acknowledgement message is then transmitted to the remote system.
 ;
 ; GIS INTERFACE TRANSACTION TYPEs supported by the LoS:
 ;   HL XXX LOGON REQUEST FROM REMOTE SYSTEM
 ;   HL XXX LOGON REQUEST FROM REMOTE SYSTEM - ACK
 ;   where: XXX = PWS
 ;
 ;
 ; Assumptions:
 ; - HL7 Original Acknowledgement Mode is used. (MSH-15/16="")
 ; - The LoS functions as a server in the TCP client/server model.
 ; - If the LoS has been signalled to stop, it will complete any 
 ;   transaction in progress and then terminate.
 ;
 ;
 ; Input:
 ;   INBPN    - BACKGROUND PROCESS CONTROL IEN for LoS
 ;
 ;
 ; Variables:
 ;   INACKUIF - UNIVERSAL INTERFACE IEN for outbound Ack
 ;   INCHNL   - TCP channel assigned to the LoS when connection is opened
 ;   INDATA   - array containing inbound msg received from remote system
 ;              WARNING: Size of inbound data may require that INDATA
 ;              be replaced with ^UTILITY("INREC",$J).  As a result, do 
 ;              NOT new this variable - must be killed (see INMSGLOS).
 ;   INDEST   - array containing valid inbound destinations for LoS
 ;              Format: INDEST(msg-type_event-type)=
 ;                      INTERFACE DESTINATION name for inbound msg
 ;   INDSTP   - INTERFACE DESTINATION IEN for inbound msg from 
 ;              UNIVERSAL INTERFACE file
 ;   INDSTR   - INTERFACE DESTINATION IEN for LoS from BACKGROUND PROCESS
 ;              CONTROL file
 ;   INERR    - array containing error msg used to log an error
 ;   INERRLOS - error information returned by function
 ;   INIP     - array containing initialization parameters from
 ;              BACKGROUND PROCESS CONTROL file
 ;   INMSGLOS - indirected variable containing location of inbound msg
 ;              1) local array = INDATA  2) global = ^UTILITY("INREC",$J)
 ;              WARNING: Size of inbound data may require that the local
 ;              array be replaced with global storage.
 ;   INMEM    - memory variable used by %INET
 ;   INOA     - array containing Ack msg data to be returned to remote system
 ;   INODA    - array containing information to be sent to an outbound
 ;              destination
 ;                INODA = IEN in base file used by outbound script
 ;                Subscripts may hold subfile IENs in the format:
 ;                  INODA(subfile #,DA)=""
 ;              If NOT needed, set to -1 prior to running outbound script.
 ;   INPARMS  - inbound msg parameter array
 ;              Format: INPARMS(INDSTP,"param")=value
 ;   INRUNLOS - flag - 0 = LoS should shutdown
 ;                     1 = LoS should continue running
 ;   INUIF    - UNIVERSAL INTERFACE IEN for inbound msg
 ;   INUSEQ   - flag - Sequence Number Protocol - 0=off, 1=on
 ;   INXDST   - executable code used by IN^INHUSEN to determine INTERFACE
 ;              DESTINATION for an inbound msg
 ;   X        - scratch
 ;
 ; Output:
 ;   None.
 ;
 ; Initialization
 N INACKUIF,INCHNL,INDEST,INDSTP,INDSTR,INERR,INERRLOS,INIP,INMSGLOS,INMEM,INOA,INODA,INPARMS,INRUNLOS,INUIF,INUSEQ,INXDST,X
 S X="ERR^INHVCRL",@^%ZOSF("TRAP")
 D DEBUG^INHVCRA1() ; turn debug on
 Q:'$$RUN^INHOTM  ; ck shutdown status
 ;Start GIS Background process audit if flag is set in Site Parms File
 N INPNAME S INPNAME=$P(^INTHPC(INBPN,0),U) D AUDCHK^XUSAUD D:$D(XUAUDIT) ITIME^XUSAUD(INPNAME)
 L +^INRHB("RUN",INBPN):5 E  D
 . D LOG^INHVCRA1("Cannot get exclusive lock for: ^INRHB(""RUN"","_INBPN_")","E")
 . D SHUTDWN(INBPN)
 ;
 ; Get LoS INTERFACE DESTINATION IEN & Destination Determination Code
 S INDSTR=$P($G(^INTHPC(INBPN,0)),U,7),INXDST=$G(^(8))
 I 'INDSTR D  Q
 . D LOG^INHVCRA1("No destination designated for background process "_INBPN,"E")
 . D SHUTDWN(INBPN)
 ;
 I '$L($G(INXDST)) D  Q
 . D LOG^INHVCRA1("Missing code to determine inbound message destination for background process "_INBPN,"E")
 . D SHUTDWN(INBPN)
 ;
 ; Verify designation of LoS port(s)
 I '$O(^INTHPC(INBPN,5,0)) D  Q
 . D LOG^INHVCRA1("No ports designated for background process "_INBPN,"E")
 . D SHUTDWN(INBPN)
 ;
 ; Get LoS parameters from BACKGROUND PROCESS CONTROL file
 D INIT^INHUVUT1(INBPN,.INIP)
 ;
 S INUSEQ=+$P($G(^INRHD(INDSTR,0)),U,9) ; use sequence number protocol?
 ;
 ; Main program loop
 F  D  K @INMSGLOS Q:'$G(INRUNLOS)
 .;Update background process audit
 .D:$D(XUAUDIT) ITIME^XUSAUD(INPNAME)
 .; Kill variables that are modified with each incoming/outgoing msg
 . K INACKUIF,INDSTP,INERR,INMEM,INOA,INODA,INUIF
 .; Error trap positioned to allow for continuation following "non-fatal" error
 . S X="ERR^INHVCRL",@^%ZOSF("TRAP")
 . S INMSGLOS="INDATA" ; reset local array in which to receive data
 .;
 .; Select port, open connection & wait for transmissions
 . S INRUNLOS=$$RUN^INHOTM Q:'INRUNLOS
 . D LOG^INHVCRA1("Listening for connection")
 . S INERRLOS=$$OPEN^INHUVUT(INBPN,.INCHNL,.INERR,.INMEM)
 . I 'INERRLOS D  Q  ; open failed - retry
 .. D LOG^INHVCRA1(.INERR,"E")
 .. D WAIT^INHUVUT(INBPN,INIP("OHNG"),"Waiting to retry open",.INRUNLOS)
 .. S INRUNLOS='INRUNLOS
 . S INRUNLOS=$$RUN^INHOTM Q:'INRUNLOS
 . D LOG^INHVCRA1("Connected")
 .;
 .; Receive data from remote system
 . S INRUNLOS=$$RUN^INHOTM Q:'INRUNLOS
 . D LOG^INHVCRA1("Receiving data on channel: "_INCHNL)
 . S INERRLOS=$$RECEIVE^INHUVUT(.INMSGLOS,INCHNL,.INIP,.INERR,.INMEM)
 . I INERRLOS D RESET^INHVCRL1(INBPN,INCHNL,.INERR) Q
 .;
 .; Process inbound msg
 . S INRUNLOS=$$RUN^INHOTM
 . D LOG^INHVCRA1("Processing inbound message")
 .;Start transaction audit
 . D:$D(XUAUDIT) TTSTRT^XUSAUD("","",$P(^INTHPC(INBPN,0),U),$G(INHSRVR),"RECEIVE")
 . S INERRLOS=$$IN^INHUSEN(INMSGLOS,.INDEST,INDSTR,INUSEQ,.INACKUIF,.INERR,INXDST,.INUIF,1)
 . ;Stop transaction audit. Pass in UIF entry if it exists.
 . D:$D(XUAUDIT) TTSTP^XUSAUD(0,$G(INUIF))
 . I INERRLOS D RESET^INHVCRL1(INBPN,INCHNL,.INERR,$S($G(INACKUIF):INACKUIF,1:"AR"),.INIP,$G(INUIF),.INPARMS) Q
 .;
 .; Get parameters associated with inbound msg (INUIF)
 . S INRUNLOS=INRUNLOS&$$RUN^INHOTM
 . S INERRLOS=$$INPARMS^INHVCRL2(.INDSTP,.INPARMS,.INERR,INUIF)
 . I INERRLOS D RESET^INHVCRL1(INBPN,INCHNL,.INERR) Q
 .;
 .; Execute inbound script generated for this transaction/destination
 . S INRUNLOS=INRUNLOS&$$RUN^INHOTM
 . D LOG^INHVCRA1("Executing inbound script for UIF entry = "_INUIF)
 .;Start transaction audit
 . D:$D(XUAUDIT) TTSTRT^XUSAUD(INUIF,"",$P(^INTHPC(INBPN,0),U),$G(INHSRVR),"SCRIPT")
 . S INERRLOS=$$RUNIN^INHVCRL3(INUIF,.INPARMS,INDSTP,.INOA,.INODA,.INERR)
 . ;Stop transaction audit.
 . D:$D(XUAUDIT) TTSTP^XUSAUD(INERRLOS)
 . I INERRLOS D  Q
 .. S:'$D(INOA) INOA="AR"
 .. D RESET^INHVCRL1(INBPN,INCHNL,.INERR,.INOA,.INIP,INUIF,.INPARMS)
 .;
 .; Send Ack to remote system.  INOA array returned by inbound script 
 .; contains Ack data.
 . S INRUNLOS=INRUNLOS&$$RUN^INHOTM
 . D LOG^INHVCRA1("Transmitting positive acknowledgement")
 . S INERRLOS=$$SNDAACK^INHVCRL2(INBPN,INCHNL,.INIP,.INOA,.INODA,INUIF,.INPARMS,1,.INERR)
 . I INERRLOS D RESET^INHVCRL1(INBPN,INCHNL,.INERR) Q
 . D LOG^INHVCRA1("Successful transmission","S",1)
 .;
 .; Close LoS port and wait for another system to connect
 . S INRUNLOS=INRUNLOS&$$RUN^INHOTM Q:'INRUNLOS
 . D LOG^INHVCRA1("Closing connection")
 . D CLOSE(INBPN,INCHNL)
 ;
 ;
 D SHUTDWN(INBPN,$G(INCHNL))
 Q
 ;
 ;
SHUTDWN(INBPN,INCHNL) ; Shutdown LoS
 ; Input:
 ;   INBPN    - (req) BACKGROUND PROCESS CONTROL IEN for LoS
 ;   INCHNL   - (opt) TCP channel assigned to this server when connection
 ;                    is opened
 ; Output:
 ;   None.
 ;
 D LOG^INHVCRA1("Shutting down")
 D CLOSE(INBPN,$G(INCHNL))
 D LOG^INHVCRA1("Shutdown")
 D DEBUG^INHVCRA1(0) ; turn debugging off
 K ^UTILITY("INREC",$J),^UTILITY("INV",$J)
 K ^INRHB("RUN",INBPN)
 L -^INRHB("RUN",INBPN)
 ;Stop background process audit
 D:$D(XUAUDIT) AUDSTP^XUSAUD
 ;
 Q
 ;
CLOSE(INBPN,INCHNL) ; Close channel
 ; Input:
 ;   INBPN    - (req) BACKGROUND PROCESS CONTROL IEN for LoS
 ;   INCHNL   - (req) TCP channel assigned to this server when connection
 ;                    is opened
 ; Output:
 ;   None.
 ;
 I $G(INCHNL) D
 . D CLOSE^%INET(INCHNL)
 . D LOG^INHVCRA1("Connection closed")
 Q
 ;
ERR ; Error handler
 S X="HALT^INHVCRL",@^%ZOSF("TRAP")
 X $G(^INTHOS(1,3))  ; log error in trap
 D RESET^INHVCRL1(INBPN,$G(INCHNL),$$ERRMSG^INHU1,"AR",.INIP,$G(INUIF),.INPARMS)
 Q:$G(INCHNL)  ; return to main loop and reopen connection
 ;
HALT ; Halt process
 D LOG^INHVCRA1("** HALTING - FATAL ERROR **","E")
 D SHUTDWN(INBPN,$G(INCHNL))
 H
 ;
PARSE ; Debug Only - Lookup/Store Routine in Message Definition for LoS
 S INOA("INSTAT")="AA"
 S INOA("ZIL1")="REQ"
 S INOA("ZIL4")=373
 S INOA("ZIL5")=$P(^DIC(3,373,8000),"^")
 S INOA("ZIL6")=$P(^DIC(3,373,200),"^",10)
 S INOA("ZIL10")="KERBEROS KEY"
 Q
