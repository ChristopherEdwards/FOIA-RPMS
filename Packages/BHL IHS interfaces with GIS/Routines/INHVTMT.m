INHVTMT ; DGH, CHEM, KAC ; 02 Nov 1999 17:52 ; Multi-threaded socket transceiver 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 Q
 ;
EN N INA,INDA,INDEST,INDSTR,INUSEQ,INSEND,INSND,INERR,INUIF,INLOOP,OUT,RCVE,OK,UIF,X,ER,INCHNL,INIP,INMEM,INQPRI,INQTIME,INNORSP,SYSTEM,RUN,MSG,CLISRV,INBPNM,INMSASTA,INSTOP
 N H,INDISCNT,INDISCON,INDONE,INDT,INERRMT,INHBSENT,INHBTRY,INHBWAIT,INITROU,INIVLEN,INLIN,INLOGMSG,INMLTHRD,INMSG,INNORESP,INPEND,INRECV,INRECVD,INRUNMT,INSENT,INSEQNUM,INSTATE,INSTD,INSYNC,INTM,INTMDUE,INTMSENT,INXDST,RC
 S INSTD="PDTS" ; set via FFCR in future - flags project-specific coding
 S X="ERR^INHVTMT5",@^%ZOSF("TRAP")
 S SYSTEM="SC",INBPNM=$P($G(^INTHPC(INBPN,0)),U),INSTATE="OPEN",INMLTHRD=1,INHBTRY=20,(INHBSENT,INDISCNT)=0,INIVLEN=12
 D DEBUG^INHVCRA1()  ; turn on debug
 ;Start GIS Background process audit if flag is set in Site Parms File
 D AUDCHK^XUSAUD D:$D(XUAUDIT) ITIME^XUSAUD(INBPNM)
 D:'$$RUN^INHOTM  ; ck shutdown status
 . D:$G(INDEBUG) LOG^INHVCRA1("Shutdown transceiver "_INBPNM,"E")
 . D SHUTDWN^INHVTMT5(INBPN)
 L +^INRHB("RUN",INBPN):5 E  D  Q
 . D:$G(INDEBUG) LOG^INHVCRA1("Cannot get exclusive lock for: ^INRHB(""RUN"","_INBPN_")","E")
 . D SHUTDWN^INHVTMT5(INBPN)
 ; Get INTERFACE DESTINATION IEN & Destination Determination Code
 S INDSTR=+$P(^INTHPC(INBPN,0),U,7),INXDST=$G(^(8))
 I 'INDSTR D  Q
 . D:$G(INDEBUG) LOG^INHVCRA1("No destination designated for background process "_INBPNM,"E")
 . D SHUTDWN^INHVTMT5(INBPN)
 I '$L($G(INXDST)) D  Q
 . D:$G(INDEBUG) LOG^INHVCRA1("Missing code to determine inbound message destination for background process "_INBPNM,"E")
 . D SHUTDWN^INHVTMT5(INBPN)
 ; Initialize variables from background process file
 D:$G(INDEBUG) LOG^INHVCRA1("Initializing variables for background process file "_INBPNM,9)
 D INIT^INHUVUT(INBPN,.INIP) ; get parms from BPC file
 I $L($G(INSTD)) D  ; project-specific init
 . F X=1:1:9 S INITROU="INIT"_INSTD_"^INHVTMT"_X D:$L($T(@INITROU)) @INITROU
 ; if Encryption is flagged on, start C process
 I $G(INIP("CRYPT")),'$L(INIP("DESKEY")) D  Q
 . D:$G(INDEBUG) LOG^INHVCRA1("Encrypt is set but no DES Key specified "_INBPNM,5)
 . D SHUTDWN^INHVTMT5(INBPN)
 I $G(INIP("CRYPT")) S X=$$CRYPON^INCRYPT(INIP("DESKEY"))
 ;Determine if process will be client (default,0) or server (1)
 S CLISRV=+$P(^INTHPC(INBPN,0),U,8)
 ; sync up INPEND with current state of pend que
 S INSYNC=$$PENDSYNC^INHVTMT4(.INPEND)
 ;
 ; Main program loop
 F  D  Q:'$G(INRUNMT)
 .; Update background process audit
 . D:$D(XUAUDIT) ITIME^XUSAUD(INBPNM)
 .;
 .; Select port & open TCP/IP connection
 . I INSTATE="OPEN" D  Q:'INRUNMT
 .. D CLOSE^INHVTMT5
 .. D:$G(INDEBUG) LOG^INHVCRA1("OPEN: Transceiver "_INBPNM,1)
 .. S INRUNMT=$$OPEN^INHVTAPU(INBPN,CLISRV,.INIP,INDEBUG,.INCHNL,.INMEM)
 .. S:INRUNMT INSTATE="HB",INHBWAIT=0
 .;
 .; Heartbeat/dummy msg sent to target system for known, pervasive
 .; problems til target sends msg indicating that msgs can flow again
 . I INSTATE="HB" D  Q:'INRUNMT
 .. Q:'$L($G(INIP("INIT")))  ; hb not used (e.g. receipt ack precludes)
 .. D:$G(INDEBUG) LOG^INHVCRA1("HB: Transceiver "_INBPNM,1)
 .. I (INHBTRY'>INHBSENT) S INSTATE="OPEN",INHBSENT=0 Q  ; close/reopen
 .. S INRUNMT=$$HB^INHVTMT5(.INHBSENT,INHBWAIT)  ; send heartbeat msg
 .. S:INRUNMT INHBWAIT=1
 .;
 . I INSTATE="SEND" D  Q:'INRUNMT  S:INSTATE="SEND" INSTATE="RECV"
 .. D:$G(INDEBUG) LOG^INHVCRA1("SEND: Transceiver "_INBPNM,1)
 .. S INSEND=INIP("SMAX")-INPEND ; # msgs to send
 .. S INSENT=0  ; # msgs sent
 ..; Send up to max transactions
 .. F  Q:(INSEND'>INSENT)  D  Q:(INSTATE'="SEND")!'INRUNMT
 ...; Get next transaction from destination queue
 ... S INUIF=""
 ... F  D  Q:INUIF!(INSTATE'="SEND")!'INRUNMT
 .... D:$G(INDEBUG) LOG^INHVCRA1("Socket ready to start send/receive.",7)
 .... S INRUNMT=$$INRHB^INHUVUT1(INBPN,"Idle") Q:'INRUNMT
 .... D:$G(INDEBUG) LOG^INHVCRA1("Getting next transaction on "_INDSTR_" destination queue.",7)
 .... S INUIF=$$NEXT^INHUVUT3(INDSTR,.INQPRI,.INQTIME,.INPEND)
 .... I 'INUIF D  Q
 ..... S INSTATE="RECV" ; nothing to send
 ..... D:$G(INDEBUG) LOG^INHVCRA1("No transactions on destination queue.",5)
 ...;
 ... Q:(INSTATE'="SEND")!'INRUNMT
 ...;
 ...; Ck for presence of msg content
 ... D:$G(INDEBUG) LOG^INHVCRA1("Checking for presence of message",7)
 ... I '$O(^INTHU(INUIF,3,0)) D  Q
 .... D ENR^INHE(INBPN,"Missing message "_INUIF_" for destination "_$P($G(^INRHD(INDSTR,0)),U))
 .... D PQKILL^INHVTMT4(INDSTR,INSEQNUM,INUIF,.INPEND)
 ...;
 ...; Selective Routing (send/no send)
 ... S UIF=$G(^INTHU(INUIF,0)),INA="^INTHU("_INUIF_",7)",INDA="^INTHU("_INUIF_",6)"
 ... I $$SUPPRESS^INHUT6("XMT",$P(UIF,U,11),$P(UIF,U,2),INBPN,.INA,.INDA,INUIF) D  Q
 .... D PQKILL^INHVTMT4(INDSTR,INSEQNUM,INUIF,.INPEND)
 ...;
 ...; Send msg
 ...; Start transaction audit
 ... D:$D(XUAUDIT) TTSTRT^XUSAUD(INUIF,"",INBPNM,"","TRANSMIT")
 ... D:$G(INDEBUG) LOG^INHVCRA1("Sending outgoing message on "_INBPNM,7)
 ... S INRUNMT=$$INRHB^INHUVUT1(INBPN,"Sending UIF= "_INUIF) Q:'INRUNMT
 ... F  S INERRMT=$$SEND^INHVTMT1(INUIF,INCHNL,.INIP) Q:'INERRMT!'INRUNMT
 ...; Post-send activities
 ... D ULOG^INHU(INUIF,"S") ; log activity in UIF - sent
 ... S INSENT=INSENT+1
 ... S $P(^INLHDEST(INDSTR,"PEND",INBPN,INSEQNUM,INUIF),U)=$H_U_1
 ... D:$D(XUAUDIT) TTSTP^XUSAUD(0)  ;stop transaction audit
 .;
 . I "^RECV^HB^"[(U_INSTATE_U) D  Q:'INRUNMT  S:INSTATE="RECV" INSTATE="TIMEOUT"
 .. D:$G(INDEBUG) LOG^INHVCRA1("RECV: Transceiver "_INBPNM,1)
 .. S (INRECV,INDONE,INDISCON,INNORESP)=0
 ..; Receive til disconnect, no response after retries, stop transceiver
 ..; or done reading (e.g. INPEND=0)
 .. F  D  Q:INDONE!INDISCON!INNORESP!'INRUNMT
 ... S INMSG="Waiting for response"
 ... D:$G(INDEBUG) LOG^INHVCRA1(INMSG_" on "_INBPNM,7)
 ... S INRUNMT=$$INRHB^INHUVUT1(INBPN,INMSG) Q:'INRUNMT
 ... S INERRMT=$$RECEIVE^INHVTMT2(.INCHNL,.INIP,.INERR,.INMEM)
 ... Q:'INRUNMT
 ... S INDISCON=(INERRMT=3),INDONE=(INERRMT=0)
 ...;
 ... I INDISCON D  Q  ; disconnect
 .... D REROUTE^INHVTMT4(INDSTR,.INPEND)
 .... S INSTATE="OPEN"
 .... D ENR^INHE(INBPN,INERR)
 .... D:$G(INDEBUG) LOG^INHVCRA1(INERR,5) K INERR
 .... D:'CLISRV
 .....; clients pause before close/reopen; srvrs expect disconnects
 ..... S INLOGMSG="Waiting "_INIP("DHNG")_" seconds for open retry following disconnect on "_INBPNM_". Attempt "_INDISCNT
 ..... D:$G(INDEBUG) LOG^INHVCRA1(INLOGMSG,7)
 ..... D WAIT^INHUVUT2(INBPN,INIP("DHNG"),INLOGMSG,.INRUNMT)
 ..... S INRUNMT='INRUNMT  ; wait rtns opposite
 ...;
 ... Q:INDONE  ; finished reading available data
 ...;
 ...; No response (1) or error (2), try reading up to read-try max
 ... D:$G(INDEBUG) LOG^INHVCRA1(INERR,5) K INERR
 ... S INRECV=INRECV+1,INNORESP=$S(INIP("RTRY")'>INRECV:1,1:0)
 ...; If read retries exceeded
 ... I INNORESP D  Q  ; max read tries exceeded - no response (1) or error (2)
 .... D:$G(INDEBUG) LOG^INHVCRA1("Maximum receive retries,"_INIP("RTRY")_" exceeded.",7)
 ...; Read retry - max retries NOT exceeded
 ... D:$G(INDEBUG) LOG^INHVCRA1("Waiting "_INIP("RHNG")_" seconds for read retry.",7)
 ... H INIP("RHNG")
 .;
 .; Ck all entries on "pending response" que for no-response timeout 
 . I "^TIMEOUT^HB^"[(U_INSTATE_U) D  Q:'INRUNMT  S:INSTATE="TIMEOUT" INSTATE="SEND"
 .. D:$G(INDEBUG) LOG^INHVCRA1("TIMEOUT: Transceiver "_INBPNM,1)
 .. S:INSYNC INSYNC=0 ; ensured FIFO on startup (TIMEOUT before SEND state)
 ..; Quit if no items in pending queue
 .. I '$D(^INLHDEST(INDSTR,"PEND",INBPN)) S INPEND=0 Q
 .. S INRUNMT=$$INRHB^INHUVUT1(INBPN,"Cking for no-response timeout") Q:'INRUNMT
 .. S INSEQNUM=""
 .. F  S INSEQNUM=$O(^INLHDEST(INDSTR,"PEND",INBPN,INSEQNUM)) Q:(INSEQNUM="")  D  Q:'INRUNMT
 ... S INUIF=""
 ... F  S INUIF=$O(^INLHDEST(INDSTR,"PEND",INBPN,INSEQNUM,INUIF)) Q:'INUIF  D  Q:'INRUNMT
 .... S INTMSENT=$P(^INLHDEST(INDSTR,"PEND",INBPN,INSEQNUM,INUIF),U)
 .... S X=$P(INTMSENT,",",2)+INIP("STO")
 ....; ck for crossing day boundary
 .... S INTMDUE=$S(86400'>X:($P(INTMSENT,",")+1)_","_$TR($J(X-86400,5)," ",0),1:$P(INTMSENT,",")_","_X)
 .... S H=$H,INDT=$P(H,","),INTM=$P(H,",",2)
 ....; If past due date or today's date, but past due time
 .... I ($P(INTMDUE,",")<INDT)!(($P(INTMDUE,",")=INDT)&($P(INTMDUE,",",2)'>INTM)) D
 .....; If no-response timeout
 ..... I INIP("STRY")'>$P(^INLHDEST(INDSTR,"PEND",INBPN,INSEQNUM,INUIF),U,2) D  Q
 ......; send tries exceeded, reroute msg to another xceiver
 ...... S INERR="No-response timeout: Rerouting UIF="_INUIF_" for background process "_INBPNM_$S(INSTATE="TIMEOUT":". Close/reopen socket. Transceiver entering heartbeat state.",1:"")
 ...... D:$G(INDEBUG) LOG^INHVCRA1(INERR,9)
 ...... D ENR^INHE(INBPN,INERR) K INERR
 ...... S INERRMT=$$GETPEND^INHVTMT4(INDSTR,INSEQNUM,INUIF,.INPEND)
 ...... S INSTATE="OPEN"
 .....; else, send retries NOT exceeded
 ..... D:$G(INDEBUG) LOG^INHVCRA1("No-response timeout: Resending UIF="_INUIF,9)
 ..... D RESEND^INHVTMT4(INDSTR,INUIF,INSEQNUM)
 ;
 ;
 ; Shutdown transceiver (close socket, cleanup)
 D SHUTDWN^INHVTMT5(INBPN,$G(INCHNL))
 Q
 ;
 ;
