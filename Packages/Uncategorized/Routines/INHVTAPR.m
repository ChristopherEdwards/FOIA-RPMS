INHVTAPR ; DGH, CHEM ; 07 Oct 1999 18:23 ; Generic receiver, enhanced functions
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;CHCS TOOLS_460; GEN 3; 17-JUL-1997
 ;COPYRIGHT 1994 SAIC
 ;
 ;This is an interactive transmitter/receiver routine supporting
 ;enhanced functionality. It is the mirror of INHVTAPT.
 ;It receives a message, sends an ack, receives a message, etc.
 ;The process can function as either a server or a client, depending
 ;on the parameters. See notes below.
 ;INPUT:
 ; INBPN = Background processor
 ;
EN ;Main starting point
 N RC,INDEST,ING,INDSTR,INUSEQ,INSEND,INERR,INUIF,INLOOP,OUT,RCVE,OK,UIF,X,ER,INCHNL,INIP,INMEM,INQP,INQT,INNORSP,SYSTEM,RUN,I,Y,INXDST,CLISRV,INBPNM,INTRNSNT,INSTOP,INDISCNT ;CM
 S X="ERR^INHVTAPR",@^%ZOSF("TRAP"),(INSTOP,INDISCNT)=0
 D PARM^INHVTAPU
 G:INSTOP EXIT
 ;Set array of valid destinations
 D:$G(INDEBUG) LOG^INHVCRA1("Setting valid destination(s)",8) ;CM
 F I=1:1 S X=$T(DEST+I) Q:X'[";;"  S Y=$TR($P(X,";;")," ",""),INDEST(Y)=$P(X,";;",2) ;CM
 ;Set values for the destination of the receiver and whether this
 ;receiver should use sequence number protocol.
 S INDSTR=+$P(^INTHPC(INBPN,0),U,7),INUSEQ=$P(^INRHD(INDSTR,0),U,9)
OPEN ;Open the TCP/IP connection
 S OK=$$OPEN^INHVTAPU(INBPN,CLISRV,.INIP,INDEBUG,.INCHNL,.INMEM) G:'OK EXIT
 ;If initialization parameters are specified, run handshaking log
 I $L(INIP("INIT"))+$L(INIP("ACK")) S OK=$$INIT^INHVTAPU I 'OK D:CLISRV CLOSE^INHVTAPU G:CLISRV OPEN G EXIT
 ;
RUN ;With port open, start receive/send. This is main loop of routine.
 S RUN=$$INRHB^INHUVUT1(INBPN,"Idle") G:'RUN EXIT
 ;Update background process audit
 D:$D(XUAUDIT) ITIME^XUSAUD(INBPNM)
 ;Loop until a transaction is received
 S (INNORSP,INSEND)=0
RECEIVE ;Receive incoming message. If none, hang and go back to run
 S (RCVE,OUT)=0 F  D  Q:'$D(^INRHB("RUN",INBPN))!OUT
 .S ING="INDATA" K @ING
 .S RUN=$$INRHB^INHUVUT1(INBPN,"Waiting")
 .S ER=$$RECEIVE^INHUVUT(.ING,.INCHNL,.INIP,.INERR,.INMEM)
 .I 'ER S OUT=1 Q
 .;If ER, some error or timeout has occurred
 .;Log transceiver error if fatal, don't update message status
 .I ER>1 D ENR^INHE(INBPN,INERR) D:$G(INDEBUG) LOG^INHVCRA1(INERR_" "_INBPNM,7)
 .;if other system dropped connection, quit the receive loop
 .I ER=3 S OUT=1 Q
 .S RCVE=RCVE+1 I RCVE>INIP("RTRY") S OUT=1 H INIP("RHNG")
 ;--Blank and/or error conditions from receive
 ;If ER=3, the other side has dropped the connection. Close and reopen
 I ER=3 D  G:INSTOP EXIT G OPEN
 .S RUN=$$INRHB^INHUVUT1(INBPN,"Remote end disconnect")
 .D:$G(INDEBUG) LOG^INHVCRA1("Remote end disconnect on "_INBPNM,5)
 .Q:CLISRV
 .;if this is a client, must close socket then open
 .D CKDISCNT^INHVTAPU Q:INSTOP  D CLOSE^INHVTAPU K INCHNL,INMEM,INERR D:$G(INDEBUG) LOG^INHVCRA1("Waiting "_INIP("DHNG")_" seconds for open retry following disconnect on "_INBPNM_". Attempt "_INDISCNT,7) H INIP("DHNG")
 ;If nothing was received, loop back (this isn't an error)
 I '$D(@ING) H INIP("RHNG") G RUN
 G:ER=1 RUN
 ;Error condition 2 is unlikely unless INIP("RTRY") is set to 0
 ;If it occurs, go back to run.
 G:ER=2 RUN
 ;
 ;
EVAL ;Evaluate incoming message
 K INACKID,INERR,INSEND
 ;Start transaction audit, transaction type not known.
 ;Stop of audit is in INHUSEN
 D:$D(XUAUDIT) TTSTRT^XUSAUD("","",INBPNM,"","RECEIVE")
 S RUN=$$INRHB^INHUVUT1(INBPN,"Evaluating message")
 S ER=$$IN^INHUSEN(ING,.INDEST,INDSTR,0,.ACKUIF,.INERR,.INXDST)
 ;ER=3 means out of synch, stop tranceiver (NOT checking for this tcvr)
 ;ER=2 is fatal error
 ;ER=1 is non-fatal error. Log it, but move on to next transmission
 ;ER=0 is no error
 ;Log error message
 I $D(INERR) D ENR^INHE(INBPN,.INERR) D:$G(INDEBUG) LOG^INHVCRA1(.INERR,5)
 K @ING
 S:ER<2 INDISCNT=0
 ;
SEND ;Send outgoing ack. Try only once, then listen for next message
 I ACKUIF D
 .;Start transaction audit for transmission of ack.
 .D:$D(XUAUDIT) TTSTRT^XUSAUD(ACKUIF,"",INBPNM,"","TRANSMIT")
 .S RUN=$$INRHB^INHUVUT1(INBPN,"Transmitting commit acknowledgement")
 .D:$G(INDEBUG) LOG^INHVCRA1("Transmitting commit acknowledgement",7)
 .S ER=$$SEND^INHUVUT(ACKUIF,INCHNL,.INIP)
 ;Stop transaction audit
 D:$D(XUAUDIT) TTSTP^XUSAUD(ER)
 ;Currently ER will always be returned as 0, but INHUVUT may get smarter
 ;Loop back to run
 S RUN=$$INRHB^INHUVUT1(INBPN,"Successful transmission",2)
 D:$G(INDEBUG) LOG^INHVCRA1("Successful transmission on "_INBPNM,8)
 G:'RUN EXIT
 G RUN
 ;
ERR ;Error module
 ;Handle known non-fatal error conditions
 I $$ETYPE^%ZTFE("O") D  G EN
 .S X="ERR^INHVTAPR",@^%ZOSF("TRAP") D:$D(INCHNL) CLOSE^%INET(INCHNL)
 .D:$G(INDEBUG) LOG^INHVCRA1("Non-fatal error encountered in "_INBPNM,6)
 ;If unanticipated error is encounterd close port and quit receiver
 D ERR^INHVTAPU
 Q
 ;
EXIT ;Main exit module
 D:$G(INDEBUG) LOG^INHVCRA1("Receiver Exiting.",5)
 D EXIT1^INHVTAPU
 Q
 ;
DEST ;The following tags identify message destination.
TST ;;TEST CONTROL - VMS IN
ORUR01 ;;HL AP LOGIN/RESULT - IN
 ;
 ;Allowable formats for message destinations are as follows.
XXX ;;Name field in transaction type file
XXXYYY ;;Name field in transaction type file
 ;where XXX is the message type and YYY is the event type
 ;
 ;ORM;;HL CIW - IN
