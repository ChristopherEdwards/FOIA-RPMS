INHVCRLD ;KAC,DP ; 4 Apr 96 15:16; Logon Server (LoS) Background Controller Test Transmitter
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 ;This is a modify copy of ^INHVCRLT
 ;It send back the IEN of the ack logon message. 
 Q
 ;
EN ; The Test Transmitter sends PWS logon requests for access to a CHCS
 ; Logon Server.  These requests are in the form of HL7 messages.  An 
 ; acknowledgement message is received in response to this logon
 ; request.
 ;
 ; Assumptions:
 ;
 ;The Test Transmitter function as a client in the TCP client/server model.
 ;
 ; Input:
 ;   INBPN    - BACKGROUND PROCESS CONTROL IEN for Test Transmitter
 ;
 ;
 ; Variables:
 ;   INACKUIF - UNIVERSAL INTERFACE IEN for outbound Ack
 ;   INCHNL   - TCP channel assigned to this Test Transmitter when 
 ;              connection is opened
 ;   INDATA   - array containing inbound msg received from remote system
 ;              WARNING: Size of inbound data may require that INDATA
 ;              be replaced with ^UTILITY("INREC",$J).  As a result, do 
 ;              NOT new this variable - must be killed (see INMSGTST).
 ;   INDEST   - array containing valid destinations for Test Transmitter
 ;              Format: INDEST(msg-type_event-type)=
 ;                      INTERFACE DESTINATION name for inbound msg
 ;   INDSTR   - INTERFACE DESTINATION IEN for Test Transmitter from
 ;              BACKGROUND PROCESS CONTROL file
 ;   INERR    - array containing error msg used to log an error
 ;   INERRTST - error information returned by function
 ;   INMSGTST - indirected variable containing location of inbound msg
 ;              1) local array = INDATA  2) global = ^UTILITY("INREC",$J)
 ;              WARNING: Size of inbound data may require that the local
 ;              array be replaced with global storage.
 ;   INIP     - array containing initialization parameters from
 ;              BACKGROUND PROCESS CONTROL file
 ;   INMEM    - memory variable used by %INET
 ;   INRUNTST - flag - 0 = Test Transmitter should shutdown
 ;                     1 = Test Transmitter should continue running
 ;   INUIF    - UNIVERSAL INTERFACE IEN for inbound msg
 ;   INUSEQ   - flag - Sequence Number Protocol - 0=off, 1=on
 ;   X,Y,Z    - scratch
 ;
 ; Output:
 ;   None.
 ;
 ; Initialization
 S INQKILL=1 ; kill entry after sending - yes/no
 S:'$D(INDEBUG) INDEBUG=0
 I INDEBUG D  Q:POP
 .S %ZIS="QM" D ^%ZIS Q:POP
 .U IO W !!,$$CDATASC^%ZTFDT($H,2,2)_" Entering Test Transmitter"
 ;
 N INCHNL,INDEST,INDSTR,INERRTST,INMSGTST,INIP,INRUNTST,INUSEQ,X,Y,Z
 S X="ERR^INHVCRLD",@^%ZOSF("TRAP")
 Q:'$$RUN^INHOTM  ; ck shutdown status
 ;
 S POP=0 F INSER=1:1 D  Q:POP
 .L +^INRHB("RUN","SRVR",INBPN,INSER):5 S POP=1
 .;D SHUTDWN(INBPN)
 ;
 ; Get Test Transmitter INTERFACE DESTINATION IEN
 S INDSTR=+$P($G(^INTHPC(INBPN,0)),U,7)
 I 'INDSTR D  Q
 .D ENR^INHE(INBPN,"No destination designated for background process "_INBPN)
 .D SHUTDWN(INBPN)
 ;
 ; Get Test Transmitter parameters from BACKGROUND PROCESS CONTROL file
 D INIT^INHUVUT(INBPN,.INIP)
 ;
 ; Set array of valid inbound INTERFACE DESTINATION names
 F X=1:1 S Y=$T(DEST+X) Q:Y'[";;"  S Z=$TR($P(Y,";;")," ",""),INDEST(Z)=$P(Y,";;",2)
 ;
 S INUSEQ=+$P($G(^INRHD(INDSTR,0)),U,9) ; use sequence number protocol?
 ;
 ;;;;;; Main program loop
 N INACKUIF,INERR,INMEM,INMSGTST
 ; Error trap positioned to allow for continuation following 
 ; "non-fatal" error
 S X="ERR^INHVCRLD",@^%ZOSF("TRAP")
 S INMSGTST="INDATA" ; reset local array in which to receive data
 ;
 ; Select port, open connection
 W:INDEBUG !!?5,$$CDATASC^%ZTFDT($H,2,2)_" Opening socket"
 F  D  Q:INERRTST!'INRUNTST  D WAIT^INHUVUT(INBPN,INIP("OHNG"))
 . S INRUNTST=$$INRHB^INHUVUT1(INBPN,"Attempting to open socket") Q:'INRUNTST
 .S INERRTST=$$OPEN^INHUVUT(INBPN,.INCHNL,.INERR,.INMEM)
 S INRUNTST=$$INRHB^INHUVUT1(INBPN,"Socket opened") Q:'INRUNTST
 ;
 ;Logon message
 S INUIF=$O(^UTILITY("INTHU",DUZ,TESTNUM,.5,""))
 ;
 Q:'INRUNTST
 ;
 ; Send data to CHCS system
 W:INDEBUG !!?10,$$CDATASC^%ZTFDT($H,2,2)_" Sending data to CHCS system on channel: "_$G(INCHNL)
 F  D  Q:'INERRTST!'INRUNTST  D WAIT^INHUVUT(INBPN,INIP("SHNG"))
 .S INRUNTST=$$INRHB^INHUVUT1(INBPN,"Sending data to CHCS system")
 .Q:'INRUNTST
 .S INERRTST=$$SEND^INHUVUT(INUIF,INCHNL,.INIP)
 Q:'INRUNTST
 ;
 ; Receive data from remote system
 W:INDEBUG !!?10,$$CDATASC^%ZTFDT($H,2,2)_" Waiting to receive Ack from CHCS"
 S INRUNTST=$$INRHB^INHUVUT1(INBPN,"Waiting to receive Ack from CHCS")
 Q:'INRUNTST
 S INERRTST=$$RECEIVE^INHUVUT(.INMSGTST,INCHNL,.INIP,.INERR,.INMEM)
 I INERRTST D  Q
 .D ENR^INHE(INBPN,"Error during receive of Ack from CHCS= "_$G(INERR))
 .D SHUTDWN(INBPN)
 .W:INDEBUG !!?10,$$CDATASC^%ZTFDT($H,2,2)_" Error during receive of Ack from CHCS - closing socket"
 ;
 W:INDEBUG !!?10,$$CDATASC^%ZTFDT($H,2,2)_" Processing inbound message"
 S INRUNTST=$$INRHB^INHUVUT1(INBPN,"Processing inbound message")
 S INERRTST=$$IN^INHUSEN(INMSGTST,.INDEST,INDSTR,INUSEQ,.INACKUIF,.INERR,"",.INUIF,1)
 I INERRTST D  Q
 .D ENR^INHE(INBPN,"Error during processing of Ack= "_$G(INERR))
 .D SHUTDWN(INBPN)
 .W:INDEBUG !!?10,$$CDATASC^%ZTFDT($H,2,2)_" Error during processing of Ack from CHCS - closing socket"
 ;
 ; Close Test Transmitter port and re-open to send another message
 D:INDEBUG
 .W:INDEBUG !!?10,$$CDATASC^%ZTFDT($H,2,2)_" Closing socket"
 .W:INDEBUG !!?15,"Inbound msg UIF = "_$G(INUIF)
 S INRUNTST=$$INRHB^INHUVUT1(INBPN,"Closing Socket") Q:'INRUNTST
 D SHUTDWN(INBPN)
 S INRUNTST=$$INRHB^INHUVUT1(INBPN,"Idle",1) Q:'INRUNTST
 ;
 D SHUTDWN(INBPN)
 Q
 ;
SHUTDWN(INBPN) ; Shutdown Test Transmitter
 N X
 S X=$$INRHB^INHUVUT1(INBPN,"Shutting down",2)
 I $G(INCHNL) D
 .N X D CLOSE^%INET(INCHNL)
 .S X=$$INRHB^INHUVUT1(INBPN,"Socket closed")
 Q
 ;
ERR ; Error handler
 S X="HALT^INHVCRLD",@^%ZOSF("TRAP")
 X $G(^INTHOS(1,3))  ; log error in trap
 D:INDEBUG
 . U IO ; error trap uses another file
 . W !!,$$CDATASC^%ZTFDT($H,2,2)_" System error: "_$$ERRMSG^INHU1
 D ENR^INHE(INBPN,$$ERRMSG^INHU1)
 D SHUTDWN(INBPN)
 Q:$G(INCHNL)  ; return to main loop and reopen connection
 ;
HALT ; Halt process
 D:INDEBUG
 .X $G(^INTHOS(1,3))  ; log error in trap
 .U IO
 .W !!,$$CDATASC^%ZTFDT($H,2,2)_" ***** HALTING - FATAL ERROR *****"
 .W !!,"Symbol table upon exit:"
 ;
 K ^UTILITY("INREC",$J),^UTILITY("INV",$J)
 H
 ;
DEST ; The following tags identify valid message destinations.
ACKACK ;;TEST INTERACTIVE
 ;
PARSE ; PWS Test Transmitter Lookup Routine
 Q
 ;
