INTST ;FRW, DGH, CHEM, DP ; 27 Sep 96 11:06; INTERACTIVE TESTING II 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 ;mod from VFA
 ;This is the transmitter part of the interactive testing
 ;This routine is based on ^INHVTAPT
 ;
APLOOP ;Send application messages to App Server
 ;INPUT:
 ;  INBPN - background process - ien
 ;  INBPNM - background process name
 ;  INIP - array of control parameter
 ;  INCHNL - TCP channel for communications
 ;  INMEM - memory location for TCP
 ;  INDEST - array of destinations
 ;  INDSTR - destiantion pointer for background process
 ;  TESTNUM - session to run
 ;  INIPPO - server (port) number
 ;
 ;OUTPUT:
 ;  INPROK - OK to proceed ( 1 - yes ; 0 - no )
 ;
 ;Set the error trap
 S X="ERR^INTST",@^%ZOSF("TRAP")
 N INL
 S INL=0,INPROK=1
 ;
 F  S INL=$O(^UTILITY("INTHU",DUZ,TESTNUM,INL)) Q:'INL!'INPROK  D
 .  S INT=0
 .  F  S INT=$O(^UTILITY("INTHU",DUZ,TESTNUM,INL,INT)) Q:'INT!'INPROK  D
 ..    D ONE(INT)
 ..    I '$D(^INRHB("RUN","SRVR",INBPN,INIPPO)) S INPROK=0
 ;
 Q
 ;
ONE(INUIF) ;Send a message and receive ack
 ;INPUT:
 ;  INUIF - Message to send (ien in INTHU)
 ;OUTPUT:
 ;  INPROK - exit simulation
 ;
 S MS="" D DEBUG
 Q:'$G(INUIF)
 N INL,INT,MS,INNORSP,INSND,MSG,OUT,ER,RCVE,ING,INDATA,RUN,INERR
 N INACKID,INMSASTA,INSEND,ERNO
 ;
 ;Check for presence of message
 I '$O(^INTHU(INUIF,3,0)) S MS="Missing message "_INUIF D DEBUG Q
 ;
 S (INNORSP,INSND)=0
 ;
 S MS="Sending outgoing message: "_$P(^INTHU(INUIF,0),U,5)_"   ("_INUIF_")" D DEBUG
 S MSG=0  F  S MSG=$O(^INTHU(INUIF,3,MSG)) Q:'MSG  D
 .  S MS=$G(^INTHU(INUIF,3,MSG,0)) D:$L(MS) DEBUG
 ;
SEND ;Send outgoing message. Retry until
 ;1-Message is NAKed too many times - INSND>INIP("STRY")
 ;2-No response. Then close socket and exit  - INNORSP>20
 ;
 I INNORSP>20 D  Q
 .  S INPROK=0
 .  S MS="No response after 20 retries, shutting down"
 .  D DEBUG,CLOSE
 ;
 ;If send retries exceeded then send next msg
 S INSND=INSND+1 I INSND>INIP("STRY") D  Q
 .  S MS="Send retries ("_$G(INIP("STRY"))_") exceeded." D DEBUG
 .  S ER=2
 ;
 I INNORSP>1 S MS="Retransmitting: failure "_INNORSP D DEBUG
 ;
 S OUT=0 F  S ER=$$SEND^INHUVUT(INUIF,INCHNL,.INIP) S:'ER OUT=1 Q:OUT
 ;Currently ER will always be returned as 0, but INHUVUT may get smarter
 ;
RECEIVE ;Receive incoming response. If no response, go back and SEND again
 ;
 ;Attempt to receive ack INIP("RTRY") times
 S (RCVE,OUT)=0 F  D  Q:OUT
 .  K ING S ING="INDATA" K @ING
 .  S MSG="Receiving acknowldgment"
 .  S:INNORSP>1 MSG=MSG_", attempt "_INNORSP
 .  S MS=MSG D DEBUG
 .  ;Read ack message
 .  S ER=$$RECEIVE^INHUVUT(.ING,.INCHNL,.INIP,.INERR,.INMEM)
 .  ;Diplay ack message
 .  W ! S O=""
 .  F  S O=$O(@ING@(O)) Q:O=""  S MS=@ING@(O) D DEBUG
 .  W !
 .  S OUT=$S('ER:1,ER=3:1,1:OUT) Q:OUT
 .  ;If ER, some error or timeout has occurred
 .  S RCVE=RCVE+1,OUT=$S(RCVE>INIP("RTRY"):1,1:OUT) Q:OUT
 .  H INIP("RHNG")
 ;
 ;Error conditions from receive
 ;If ER=3 then the other side has dropped the connection
 I ER=3 S INPROK=0 Q
 ;Check for no response
 I ER=1!'$D(@ING) S INNORSP=INNORSP+1 G SEND
 ;Check for unexpected conditions
 I ER>1 S INNORSP=INNORSP+1 G SEND ; SHOULD NOT HAPPEN
 ;If max RCVE retries exceeded go back to send
 I RCVE>INIP("RTRY") D  G SEND
 .  S MS="Max Receive retries exceeded." D DEBUG
 ;
EVAL ;Evaluate incoming response (ie ack status=CA).
 ;If error, increment LOOP to STRY, go back and send again
 K INACKID,INMSASTA,INERR
 ;Load ack message into file
 S ER=$$IN^INHUSEN(ING,.INDEST,INDSTR,0,.INSEND,.INERR,"",.INACKID,1,.INMSASTA)
 ;
 ;Check for errors
 ;ER=3 means out of synch, stop tranceiver (NOT checking for this tcvr)
 ;ER=2 is fatal error -> shut it down
 ;ER=1 is non-fatal error -> move on to next transaction
 ;ER=0 is no error
 S MS=$S('ER:"Acknowledgment accepted: ",1:"Error evaluating acknowledgment.")
 I $G(INACKID) S MS=MS_$P(^INTHU(INACKID,0),U,5)_"   ("_INACKID_")"
 D DEBUG
 ;Display error array
 I ER,$D(INERR) D  K INERR
 .  S ERNO=0 F  S ERNO=$O(INERR(ERNO)) Q:'ERNO  D
 ..    S MS=INERR(ERNO) D DEBUG
 ;
 K @ING
 Q
 ;
 ;If non-fatal, send again. Also kill incoming array/gbl
 ;Resend for CE or AE (or ?E).  If rejected, (CR or AR) NEVER resend.
 K @ING I ER<2,$E($G(INMSASTA),2)'="E" D  Q
 .  S RUN=$$INRHB^INHUVUT1(INBPN,"Transmission complete",1)
 .  S MS="Transmission complete for "_INBPNM
 ;Otherwise, if fatal, hang and try again
 S MS="Waiting to re-transmit" D DEBUG
 H INIP("SHNG") G SEND
 ;
ERR ;Error module
 N INREERR S INREERR=$$GETERR^%ZTOS
 ;close port and quit
 I $D(INCHNL) D CLOSE^%INET(INCHNL)
 S MS="Fatal error encountered by - "_INREERR
 D DEBUG
 Q
 ;
CLOSE ;Close channel
 S MS="Closing connection for "_INBPNM D DEBUG
 D:+$G(INCHNL) CLOSE^%INET(.INCHNL)
 Q
 ;
DEBUG ;Write interactive messages to the screen
 ;INPUT:
 ;  MS - message to display
 ;OUTPUT:
 ;  INPROK - exit simulator
 ;
 W !,$G(MS)
 Q:'$G(INIPPO)!'$G(INBPN)
 I '$D(^INRHB("RUN","SRVR",INBPN,INIPPO)) D  Q
 .  S INPROK=0
 .  W !,"Process signalled to terminate",!
 S ^INRHB("RUN","SRVR",INBPN,INIPPO)=$H_U_MS
 S %="" I '$G(INAUTO) R %#1:0
 I $L(%) S INPROK=0
 Q
 ;
