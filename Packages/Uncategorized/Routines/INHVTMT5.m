INHVTMT5 ; KAC ; 06 Aug 1999 15:34:58; Multi-threaded TCP/IP socket utilities
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 Q
 ;
HB(INHBSENT,INHBWAIT) ; Function:
 ; Heartbeat/dummy msg sent to indicate when transceiver can start
 ; sending msgs from UNIVERSAL INTERFACE file.  Adds SOM and EOM
 ; to start/end of msg.
 ;
 ; Called by: INHVTMT
 ;
 ;Input:
 ; INHBWAIT      (req) flag - 1 = wait before sending hb, 0 = send now
 ; INBPN         background process number
 ; INBPNM        background process name
 ; INDEBUG       debug flag
 ; INIP          array of socket parameters
 ;                 INIP("INIT") = msg to send (w/out SOM/EOM)
 ; CLISRV        client/server flag
 ; INCHNL        channel opened by calling routine
 ;
 ;Output:
 ; INHBSENT      (pbr) # of hb's sent since last hb response
 ;
 ; Returns:
 ;   1 - successful
 ;   0 - unsuccessful (shutdown transceiver)
 ;
 N INMSG,INMSGHDR,INMSGRTN
 ;
 ; Pace heartbeats
 I $G(INHBWAIT) D  Q:'INRUNMT 0  ; quit if shutdown signalled
 . D:$G(INDEBUG) LOG^INHVCRA1("Waiting "_INIP("THNG")_" seconds to send heartbeat message",7)
 . D WAIT^INHUVUT2(INBPN,INIP("THNG"),"Waiting "_INIP("THNG")_" seconds to send heartbeat message",.INRUNMT)
 . S INRUNMT='INRUNMT  ; wait rtns opposite
 ;
 ; Start transaction audit
 D:$D(XUAUDIT) TTSTRT^XUSAUD("","",INBPNM,"","DUMMYTRX TRANSMIT")
 ;
 S INMSG=INIP("INIT")
 I INIP("CRYPT") D
 . I INSTD="PDTS" D  ; do not encrypt 1st hdr
 .. S INMSGHDR=$P(INIP("INIT"),INIP("SOD")) ; save ENP hdr
 .. S INMSG=$P(INIP("INIT"),INIP("SOD"),2,99999) ; msg to encrypt
 . D ENCRYPT^INCRYPT(.INMSG,.INMSGRTN,$L(INMSG),1,1)
 . S INMSG=INMSGRTN
 . I (INSTD="PDTS") D
 .. S INMSG=INMSGHDR_INIP("SOD")_INMSGRTN
 .. S $E(INMSG,21,24)=$TR($J($L(INMSGRTN),4)," ","0") ; encrypted length
 ;
 S INMSG=INIP("SOM")_INMSG_INIP("EOM")
 ;
 S INRUNMT=$$INRHB^INHUVUT1(INBPN,"Sending heartbeat/dummy trx") Q:'INRUNMT 0
 D SEND^%INET(INMSG,INCHNL,1)
 ;
 ; Post-send activities
 S INHBSENT=INHBSENT+1
 D:$G(INDEBUG) LOG^INHVCRA1("Sent heartbeat message",7)
 D:$D(XUAUDIT) TTSTP^XUSAUD(0)  ;stop transaction audit
 Q 1
 ;
 ;
SHUTDWN(INBPN,INCHNL) ; Shutdown LoS
 ;
 ; Called by: INHVTMT
 ;
 ; Input:
 ;   INBPN    - (req) BACKGROUND PROCESS CONTROL IEN for LoS
 ;   INCHNL   - (opt) TCP channel assigned to this server when connection
 ;                    is opened
 ; Output:
 ;   None.
 ;
 D:$G(INDEBUG) LOG^INHVCRA1("SHUTDWN: Transceiver "_INBPNM,1)
 D:$G(INDEBUG) LOG^INHVCRA1("Shutting down TCP socket transceiver for "_INBPNM,5)
 ; Reroute to the destination que all "pending response" que msgs
 ; Allow another transceiver to send these msgs while this transceiver
 ; is down.
 D REROUTE^INHVTMT4(INDSTR,.INPEND)
 D CLOSE
 D:$G(INDEBUG) LOG^INHVCRA1("TCP socket transceiver is shutdown for "_INBPNM,5)
 D DEBUG^INHVCRA1(0) ; turn debugging off
 I $G(INIP("CRYPT")) S X=$$CRYPOFF^INCRYPT()
 K ^UTILITY("INREC",$J),^UTILITY("INV",$J)
 K ^INRHB("RUN",INBPN)
 L -^INRHB("RUN",INBPN)
 ;Stop background process audit
 D:$D(XUAUDIT) AUDSTP^XUSAUD
 Q
 ;
CLOSE ; Close channel
 ;
 ; Called by: INHVTMT, SHUTDWN^INHVTMT5, ERR^INHVTMT5
 ;
 ; Input:
 ;   INBPN    - (req) BACKGROUND PROCESS CONTROL IEN for LoS
 ;   INCHNL   - (req) TCP channel assigned to this server when connection
 ;                    is opened
 ; Output:
 ;   None.
 I $G(INCHNL) D
 . D:$G(INDEBUG) LOG^INHVCRA1("Closing connection for "_INBPNM,6)
 . D CLOSE^%INET(INCHNL)
 Q
 ;
ERR ;Error module
 ;
 ; Called by: Error Trap set at start of INHVTMT
 ;
 N INREERR S INREERR=$$GETERR^%ZTOS
 ;Handle known non-fatal error conditions
 I $$ETYPE^%ZTFE("O") D  G EN^INHVTMT
 .S X="ERR^INHVTMT5",@^%ZOSF("TRAP") D:$D(INCHNL) CLOSE^%INET(INCHNL)
 .D:$G(INDEBUG) LOG^INHVCRA1("Non-fatal error encountered in "_INBPNM,6)
 ;If unanticipated error is encounterd close port and quit receiver
 S:'$D(INBPNM) INBPNM=$P($G(^INTHPC(INBPN,0)),U) ; THIS SHOULD NOT HAPPEN
 D ENR^INHE(INBPN,"Fatal error encountered by TRANSCEIVER  - "_INREERR_" in background process "_INBPNM)
 D:$G(INDEBUG) LOG^INHVCRA1("Fatal error encountered by TRANSCEIVER  - "_INREERR_" in background process "_INBPNM,4)
 I $D(INCHNL) D CLOSE^%INET(INCHNL)
 I $G(INIP("CRYPT")) S X=$$CRYPOFF^INCRYPT()
 D REROUTE^INHVTMT4(INDSTR,.INPEND)
 K ^UTILITY("INREC",$J),^UTILITY("INV",$J)
 K ^INRHB("RUN",INBPN)
 L -^INRHB("RUN",INBPN)
 ;Stop background process audit
 D:$D(XUAUDIT) AUDSTP^XUSAUD
 X $G(^INTHOS(1,3))
 D DEBUG^INHVCRA1(0)
 Q
 ;
 ;
