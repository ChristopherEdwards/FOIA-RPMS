INHVTAPT ; DGH, CHEM ; 07 Oct 1999 15:24 ; "Generic" socket transceiver 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;CHCS TOOLS_460; GEN 7; 6-OCT-1997
 ;COPYRIGHT 1994 SAIC
 ;
 ;This is an interactive transmitter routine. It first sends a message,
 ;then waits for an ack, then sends another msg, etc.
 ;The counterpart routine is INHVTAPR, which receives first, then
 ;sends an ack, etc.
 ;
EN ;Entry point
 N INA,INDA,INDEST,ING,INDSTR,INUSEQ,INSEND,INSND,INERR,INUIF,INLOOP,OUT,RCVE,OK,UIF,X,ER,INCHNL,INIP,INMEM,INQP,INQT,INNORSP,SYSTEM,RUN,MSG,CLISRV,TIMCHK,INBPNM,INMSASTA,INSTOP,RC,INTRNSNT,INDISCNT
 S X="ERR^INHVTAPT",@^%ZOSF("TRAP"),(INSTOP,INDISCNT)=0
 D PARM^INHVTAPU
 G:INSTOP EXIT
OPEN ;Open the TCP/IP connection
 ;Check destination queue when running in client transient mode
 I 'CLISRV&INTRNSNT S RUN=0 F  D  Q:RUN!INSTOP
 .I $D(^INLHDEST(INDSTR)) S RUN=1 Q
 .D WAIT^INHUVUT2(INBPN,INIP("THNG"),"Waiting to check queue",.INSTOP)
 G:INSTOP EXIT
 S OK=$$OPEN^INHVTAPU(INBPN,CLISRV,.INIP,INDEBUG,.INCHNL,.INMEM) G:'OK EXIT
 ;If initialization parameters are specified, run handshaking log
 I $L(INIP("INIT"))+$L(INIP("ACK")) S OK=$$INIT^INHVTAPU G:'OK EXIT
 ;
RUN ;With port open, start send/receive. This is main loop of routine.
 D:$G(INDEBUG) LOG^INHVCRA1("Socket ready to start send/receive.",7)
 S RUN=$$INRHB^INHUVUT1(INBPN,"Idle") G:'RUN EXIT
 ;Update background process audit
 D:$D(XUAUDIT) ITIME^XUSAUD(INBPNM)
 ;Loop until a transaction exists on the destination queue
 ;If re-trying a message, it will still be at top of queue
 D:$G(INDEBUG) LOG^INHVCRA1("Waiting for next transaction on "_INDSTR_" destination queue.",7)
 S INUIF=$$NEXT^INHUVUT3(INDSTR,.INQP,.INQT)
 ;Read socket to determine if other side dropped. $$RECEIVE will return 2
 I 'INUIF D  G:$G(INSTOP) EXIT G:ER<3 RUN G OPEN
 .;Only read 60 sec. from later of 1) last check OR 2) last transmission
 .S ER=0
 .I 'CLISRV&INTRNSNT D WAIT^INHUVUT2(INBPN,INIP("THNG"),"Waiting to check queue",.INSTOP) Q:$D(^INLHDEST(INDSTR))  D CLOSE^INHVTAPU D:$G(INDEBUG) LOG^INHVCRA1("Close socket in transient mode",7) S ER=3 Q
 .I $P($H,",",2)<$G(TIMCHK) D WAIT^INHUVUT2(INBPN,INIP("THNG"),"Waiting to check queue",.INSTOP) Q
 .S TIMCHK=$P($H,",",2)+60 S:TIMCHK'<86400 TIMCHK=0
 .S ING="INDATA" K @ING
 .D:$G(INDEBUG) LOG^INHVCRA1("Reading from socket to determine status",8)
 .S ER=$$RECEIVE^INHUVUT(.ING,.INCHNL,.INIP,.INERR,.INMEM)
 .Q:ER<3
 .S RUN=$$INRHB^INHUVUT1(INBPN,"Remote disconnect",2)
 .D:$G(INDEBUG) LOG^INHVCRA1("Remote disconnect on "_INBPNM,6)
 .;If client, close--if server, don't. Will re-synch handshake for both
 .I 'CLISRV D CKDISCNT^INHVTAPU Q:INSTOP  D CLOSE^INHVTAPU D:$G(INDEBUG) LOG^INHVCRA1("Waiting "_INIP("DHNG")_" seconds for open retry following disconnect on "_INBPNM_". Attempt "_INDISCNT,7) H INIP("DHNG")
 ;Check for presence of message
 D:$G(INDEBUG) LOG^INHVCRA1("Checking for presence of message",7)
 I '$O(^INTHU(INUIF,3,0)) D ENR^INHE(INBPN,"Missing message "_INUIF_" for destination "_$P($G(^INRHD(INDSTR,0)),U)),QKILL G RUN
 S TIMCHK=$P($H,",",2)+60 S:TIMCHK'<86400 TIMCHK=0
 ;
 ; Screen msg (send/no send)
 S UIF=$G(^INTHU(INUIF,0)),INA="^INTHU("_INUIF_",7)",INDA="^INTHU("_INUIF_",6)"
 I $$SUPPRESS^INHUT6("XMT",$P(UIF,U,11),$P(UIF,U,2),INBPN,.INA,.INDA,INUIF) D QKILL G RUN
 ;
 S (INNORSP,INSND)=0
 ;Start transaction audit here to include all retries in log
 D:$D(XUAUDIT) TTSTRT^XUSAUD(INUIF,"",INBPNM,"","TRANSMIT")
SEND ;Send outgoing message. Retry until
 ;1-INSND is NAKed STRY times, then delete INUIF from queue, send next
 ;2-NO RESPonce 20 times. Then close socket and go to OPEN
 D:$G(INDEBUG) LOG^INHVCRA1("Sending outgoing message.",7)
 I INNORSP>20 D ENR^INHE(INBPN,"No response after 20 re-tries on "_INBPNM_", shutting down socket"),CLOSE^INHVTAPU H:'CLISRV INIP("OHNG") G OPEN
 ;If send retries exceeded, update logs, kill from queue, send next msg.
 S INSND=INSND+1 I INSND>INIP("STRY") D  G RUN
 .D:$G(INDEBUG) LOG^INHVCRA1("Send retries ("_$G(INSND)_") exceeded.",6)
 .S INERR="MAXIMUM NUMBER OF RETRIES, "_$G(INSND)_" exceeded",ER=2
 .D ENR^INHE(INBPN,INERR),LOG K INERR
 .D QKILL
 S MSG="Transmitting" S:INNORSP>1 MSG=MSG_": Failure "_INNORSP
 D:$G(INDEBUG) LOG^INHVCRA1(MSG_" on "_INBPNM,7)
 S RUN=$$INRHB^INHUVUT1(INBPN,MSG) G:'RUN EXIT
 S OUT=0 F  S ER=$$SEND^INHUVUT(INUIF,INCHNL,.INIP) S:'ER OUT=1 Q:'$D(^INRHB("RUN",INBPN))!OUT
 ;Currently ER will always be returned as 0, but INHUVUT may get smarter
 ;
RECEIVE ;Receive incoming response. If no response, go back and SEND again
 D:$G(INDEBUG) LOG^INHVCRA1("Receiving incoming response.",7)
 S ING="INDATA" K @ING
 S (RCVE,OUT)=0 F  D  Q:'RUN!OUT
 .S MSG="Waiting for commit ack" S:INNORSP>1 MSG=MSG_", attempt "_INNORSP
 .D:$G(INDEBUG) LOG^INHVCRA1(MSG_" on "_INBPNM,7)
 .S RUN=$$INRHB^INHUVUT1(INBPN,MSG)
 .S ER=$$RECEIVE^INHUVUT(.ING,.INCHNL,.INIP,.INERR,.INMEM)
 .S OUT=$S('ER:1,ER=3:1,1:OUT) Q:OUT  ; I 'ER!(ER=3) S OUT=1 Q
 .;If ER, some error or timeout has occurred
 .S RCVE=RCVE+1,OUT=$S(RCVE>INIP("RTRY"):1,1:OUT) Q:OUT
 .D:$G(INDEBUG) LOG^INHVCRA1("Waiting "_INIP("RHNG")_" seconds for retry.",7)
 .H INIP("RHNG")
 ;
 ;Error conditions from receive
 ;If ER=3, the other side has dropped the connection. Close and reopen
 I ER=3 D  G:INSTOP EXIT G OPEN
 .D ENR^INHE(INBPN,INERR)
 .D:$G(INDEBUG) LOG^INHVCRA1(INERR,5) K INERR
 .;Stop transaction audit if other side drops.
 .D:$D(XUAUDIT) TTSTP^XUSAUD(1)
 .I 'CLISRV D CKDISCNT^INHVTAPU Q:INSTOP  D CLOSE^INHVTAPU D:$G(INDEBUG) LOG^INHVCRA1("Waiting "_INIP("DHNG")_" seconds for open retry following disconnect on "_INBPNM_". Attempt "_INDISCNT,7) H INIP("DHNG")
 I ER=1!'$D(@ING) S INNORSP=INNORSP+1,INSND=0 G SEND
 I ER>1 S INNORSP=INNORSP+1,INSND=0 G SEND ; SHOULD NOT HAPPEN
 ;If max RCVE retries exceeded go back to send
 I RCVE>INIP("RTRY") D:$G(INDEBUG) LOG^INHVCRA1("Max Receive retries exceeded.",7) S INSND=0 G SEND
 ;Stop transaction audit. TRANSMIT is complete when ack is received.
 D:$D(XUAUDIT) TTSTP^XUSAUD(0)
 ;
EVAL ;Evaluate incoming response (ie ack status=CA).
 D:$G(INDEBUG) LOG^INHVCRA1("Evaluating commit acknowledgement.",8)
 S RUN=$$INRHB^INHUVUT1(INBPN,"Evaluating commit acknowledgement.")
 ;If error, increment LOOP to STRY, go back and send again
 K INACKID,INMSASTA,INERR
 ;Start transaction audit for receipt of ack. T Type not known.
 ;Stop point is in INHUSEN
 D:$D(XUAUDIT) TTSTRT^XUSAUD("","",INBPNM,"","RECEIVE")
 S ER=$$IN^INHUSEN(ING,.INDEST,INDSTR,0,.INSEND,.INERR,.INXDST,"","",.INMSASTA,1) D:$G(INDEBUG)
 .I ER D LOG^INHVCRA1("Error evaluating acknowledgement.",6) Q
 .D LOG^INHVCRA1("Acknowlegement accepted",9)
 ;If all is in synch, kill sent entry from queue and update status
 ;ER=3 means out of synch, stop tranceiver (NOT checking for this tcvr)
 ;ER=2 is fatal error
 ;ER=1 is non-fatal error. Log it, but move on to next transmission
 ;ER=0 is no error
 S:ER<2 INDISCNT=0
 ;Log error array
 I ER,$D(INERR) D ENR^INHE(INBPN,.INERR) K INERR
 ;If non-fatal, kill from queue and loop. Also kill incoming array/gbl
 ;Resend for CE or AE (or ?E).  If rejected, (CR or AR) NEVER resend.
 K @ING I (ER<2&($E($G(INMSASTA),2)'="E"))!($E($G(INMSASTA),2)="R") D  G RUN
 .N INMSG
 .I $E($G(INMSASTA),2)="R" S (INHERR,INMSG)="Transmission rejected",ER=2
 .E  S INMSG="Transmission Complete"
 .D QKILL,LOG
 .S RUN=$$INRHB^INHUVUT1(INBPN,INMSG,1)
 .D:$G(INDEBUG) LOG^INHVCRA1(INMSG_" for "_INBPNM,8)
 ;Otherwise, if fatal, hang and try again
 D:$G(INDEBUG) LOG^INHVCRA1("Waiting to re-transmit",7)
 S RUN=$$INRHB^INHUVUT1(INBPN,"Waiting to re-transmit")
 H INIP("SHNG")
 ;Errored message (AE or CE) should increment INSND counter
 ;Other errors should reset INSND to avoid message deletion from queue
 S INSND=$S($E($G(INMSASTA),2)="E":INSND,1:0) G SEND
 ;
LOG ;Log status of original message
 ;INHOS needs UIF and ER=0,1,or 2
 N UIF S UIF=INUIF
 D DONE^INHOS
 Q
 ;
QKILL K ^INLHDEST(INDSTR,INQP,INQT,INUIF)
 D QULOCK
 Q
 ;
QULOCK L:$G(INUIF) -^INLHDEST(INDSTR,INQP,INQT,INUIF)
 Q
 ;
ERR ;Error module
 D QULOCK
 ;Handle known non-fatal error conditions
 I $$ETYPE^%ZTFE("O") D  G EN
 .S X="ERR^INHVTAPT",@^%ZOSF("TRAP") D:$D(INCHNL) CLOSE^%INET(INCHNL)
 .D:$G(INDEBUG) LOG^INHVCRA1("Non-fatal error encountered in "_INBPNM,6)
 ;If unanticipated error is encounterd close port and quit transmitter
 D ERR^INHVTAPU
 Q
 ;
EXIT ;Main exit module
 D QULOCK
 D:$G(INDEBUG) LOG^INHVCRA1("Exiting TCP socket transmitter for "_INBPNM,5)
 D EXIT1^INHVTAPU
 Q
