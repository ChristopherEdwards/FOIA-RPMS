INHVTAPU ;DGH ; 06 Oct 1999 19:32 ; "Generic" socket transmitter utils 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 ;This contains the overflow from INHVTAPT, the socket transmitter.
 ;As of 1/26/96, the initialization logic is moved from INHVTAPT to
 ;INHVTAPU. Ultimately, we may want to call this to from both
 ;INHVTAPT and INHVTAPR.
 ;Also, some logic from the ERR and EN tags has been moved.
 ;
OPEN(INBPN,CLISRV,INIP,INDEBUG,INCHNL,INMEM) ;Try OTRY times to open connection.
 ; Hang OHNG seconds between tries.
 ;
 ; Returns:  0 - failed open or process signalled to quit
 ;           1 - good open and process NOT signalled to quit
 N INLOOP,INOPENOK,INSTOP
 S (INOPENOK,INSTOP)=0,INBPNM=$P($G(^INTHPC(INBPN,0)),U)
 D:$G(INDEBUG) LOG^INHVCRA1("Attempting to open "_$S(CLISRV:"server",1:"client")_" process "_INBPNM,7)
 F INLOOP=1:1:INIP("OTRY") D  Q:INOPENOK!INSTOP
 .S MSG="Attempt "_INLOOP_" to open socket"
 .D:$G(INDEBUG) LOG^INHVCRA1(MSG_" for "_INBPNM,7)
 .S INSTOP='$$INRHB^INHUVUT1(INBPN,MSG,2) Q:INSTOP
 .S INOPENOK=$$OPEN^INHUVUT(INBPN,.INCHNL,.INERR,.INMEM) Q:INOPENOK
 .D:$G(INDEBUG) LOG^INHVCRA1("Waiting "_INIP("OHNG")_" seconds for open retry on "_INBPNM,7)
 .D WAIT^INHUVUT2(INBPN,INIP("OHNG"),MSG,.INSTOP)
 I INSTOP D:$G(INDEBUG) LOG^INHVCRA1("Run node not present for "_INBPNM,7) Q 0
 I 'INOPENOK D  Q 0
 .N MSG S MSG="Unable to open socket for background process "_INBPNM_" "_$G(INERR)
 .D:$G(INDEBUG) LOG^INHVCRA1(MSG,7)
 .D ENR^INHE(INBPN,MSG)
 D:$G(INDEBUG) LOG^INHVCRA1("Socket opened for "_INBPNM,7)
 Q $$INRHB^INHUVUT1(INBPN,"Socket opened")
 ;
INIT() ;initialization/handshaking between two systems
 ;INPUT -- all values must be initialized in calling routine
 ;--INBPN  background process number
 ;--INBPNM background process name
 ;--INDEBUG debug flag
 ;--INIP  array of socket parameters
 ;--CLISRV client/server flag
 ;--INCHNL channel opened by calling routine
 ;OUTPUT
 ;--Value of 0 = unsuccessful initialization
 ;--Value of 1 = successful initialization
 ;
 ;--If open as a client, send initialization string
 S OK=1 D:'CLISRV  G:'OK EXIT
 .D:$L(INIP("INIT"))
 ..D SENDSTR^INHUVUT(INIP("INIT"),INCHNL)
 ..D:$G(INDEBUG) LOG^INHVCRA1("Opened as client; sent initilization string",7)
 .;Receive initialization response, if specified
 .Q:'$L(INIP("ACK"))
 .D:$G(INDEBUG) LOG^INHVCRA1("Receive initialization response.",7)
 .S ING="INDATA" K @ING
 .F I=1:1:INIP("RTRY") D:$G(INDEBUG)  S ER=$$RCVSTR^INHUVUT1(.ING,INCHNL,.INIP,.INERR,.INMEM) Q:$D(@ING)  H:I<INIP("RTRY") INIP("RHNG")
 ..D LOG^INHVCRA1("Receiving initialization string on "_INCHNL,6)
 .I '$D(@ING) D  S OK=0 Q
 ..N MSG S MSG="No response received to intialization string "
 ..D ENR^INHE(INBPN,MSG_INBPN) D:$G(INDEBUG) LOG^INHVCRA1(MSG_INBPNM,6)
 .I INIP("ACK")'[@ING@(1) D  S OK=0 Q
 ..N MSG S MSG="Incorrect response "_@ING@(1)_" received to intialization string "
 ..D ENR^INHE(INBPN,MSG_INBPN) D:$G(INDEBUG) LOG^INHVCRA1(MSG_INBPNM,6)
 ;
 ;--If opening as server, receive initialization string
 S OK=1 D:CLISRV  G:'OK EXIT
 .;Receive initialization
 .Q:'$L(INIP("INIT"))
 .D:$G(INDEBUG) LOG^INHVCRA1("Opening as server, receive initialization string",7)
 .S ING="INDATA" K @ING
 .F I=1:1:INIP("RTRY") S ER=$$RCVSTR^INHUVUT1(.ING,INCHNL,.INIP,.INERR,.INMEM) Q:$D(@ING)  H:I<INIP("RTRY") INIP("RHNG")
 .I ER!'$D(@ING) D  S OK=0 Q
 ..D ENR^INHE(INBPN,"No initialization string received"_INBPN)
 ..D:$G(INDEBUG) LOG^INHVCRA1("No initialization string received"_INBPNM,6)
 .I INIP("INIT")'[@ING@(1) D  S OK=0 Q
 ..N MSG S MSG="Incorrect initialization string "_@ING@(1)_" received "
 ..D ENR^INHE(INBPN,MSG_INBPN) D:$G(INDEBUG) LOG^INHVCRA1(MSG_INBPNM,6)
 .;Send initialization response if specified
 .I $L(INIP("ACK")) D SENDSTR^INHUVUT(INIP("ACK"),INCHNL) D:$G(INDEBUG)
 ..D LOG^INHVCRA1("Sent initialization response",7)
EXIT Q OK
 ;
PARM ;Get parameters for INHVTAPT, INHVTAPR
 D DEBUG^INHVCRA1()
 S INBPNM=$P($G(^INTHPC(INBPN,0)),U)
 S SYSTEM="SC",INDSTR=+$P(^INTHPC(INBPN,0),U,7),INXDST=$G(^(8)) I 'INDSTR D  S INSTOP=1 Q
 .D ENR^INHE(INBPN,"No destination designated for background process "_INBPNM)
 .D:$G(INDEBUG) LOG^INHVCRA1("No destination designated for background process "_INBPNM,9)
 I '$D(^INRHB("RUN",INBPN)) D:$G(INDEBUG) LOG^INHVCRA1("Run node not present for "_INBPNM,9) S INSTOP=1 Q
 ; intialize variables from background process file
 D:$G(INDEBUG) LOG^INHVCRA1("Initializing variables for background process file "_INBPNM,9)
 D INIT^INHUVUT(INBPN,.INIP)
 I $G(INIP("CRYPT")),'$L(INIP("DESKEY")) D  S INSTOP=1 Q
 .D ENR^INHE(INBPN,"Encrypt is set but no DES Key specified "_INBPNM)
 .D:$G(INDEBUG) LOG^INHVCRA1("Encrypt is set but no DES Key specified "_INBPNM,5)
 ;Start GIS Background process audit if flag is set in Site Parms File
 D AUDCHK^XUSAUD D:$D(XUAUDIT) ITIME^XUSAUD(INBPNM)
 ;Determine if process will be client (default, with 0) or server (1)
 S CLISRV=+$P(^INTHPC(INBPN,0),U,8),INTRNSNT=+$P(^(0),U,9)
 ;If encryption is on, start C process
 I $G(INIP("CRYPT")) S RC=$$CRYPON^INCRYPT(INIP("DESKEY"))
 Q
 ;
CLOSE ;Close channel
 D:+$G(INCHNL) CLOSE^%INET(+INCHNL)
 D:$G(INDEBUG) LOG^INHVCRA1("Closing connection for "_INBPNM,6)
 Q
 ;
EXIT1 ;Exit module called by INHVTAPT, INHVTAPR
 D CLOSE
 I $G(INIP("CRYPT")) S RC=$$CRYPOFF^INCRYPT()
 K ^INRHB("RUN",INBPN)
 D DEBUG^INHVCRA1(0)
 ;Stop background process audit
 D:$D(XUAUDIT) AUDSTP^XUSAUD
 Q
 ;
ERR ;Error module
 D ENR^INHE(INBPN,"Fatal error encountered by TRANSCEIVER - "_$$GETERR^%ZTOS_" in background process "_INBPN)
 D:$G(INDEBUG) LOG^INHVCRA1("Fatal error encountered by TRANSCEIVER - "_$$GETERR^%ZTOS_" in background process "_INBPNM,5)
 X $G(^INTHOS(1,3))
 D EXIT1
 Q
 ;
CKDISCNT ;Check times of remote end disconnect
 N MSG
 S INDISCNT=INDISCNT+1
 Q:INDISCNT'>INIP("DTRY")
 S MSG="Disconnect retries exceeded for background process "_INBPNM
 D:$G(INDEBUG) LOG^INHVCRA1(MSG,7)
 D ENR^INHE(INBPN,MSG)
 S INSTOP=1
 Q
