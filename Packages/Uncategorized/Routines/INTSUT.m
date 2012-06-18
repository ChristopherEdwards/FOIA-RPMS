INTSUT ;JPD; 1 Feb 96 09:26; Generic receiver, enhanced functions 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 Q
INIT1(INDA,INBPN,INIP,CLISRV,INXDST,INDEST,INPOP) ;Init
 ;Input:
 ; INDA - ien of Criteria
 ; INBPN = Background processor
 ;Output:
 ; INIP - Parameters
 ; CLISRV - 0 Client, 1 - Server
 ; INXDST - Destination Determination xeq
 ; INDEST - destinations
 ; INPOP - 0 stop processing, 1 continue processing
 ;
 N ING,INERR,INUIF,X,ER,INMEM,INQP,INQT,I,Y
 S X="ERR^INTSAPR",@^%ZOSF("TRAP"),INPOP=1
 ; initialize variables from background process file
 D INIT(INDA,.INIP)
 I INIP("PORT")="" D DISPLAY^INTSUT1("Port is not defined") S INPOP=0 Q
 ;Determine if process will be client (default, with 0) or server (1)
 S CLISRV=$$VAL^DWRA(4001.1,13.03,2,DIE,INDA)
 ;server only lock if server
 I CLISRV D  Q:'INPOP
 .L +^INRHB("RUN","SRVR",INBPN,INIP("PORT")):0 I '$T D
 ..S INPOP=0
 ..D DISPLAY^INTSUT1("Port locked by another user")
 I CLISRV S ^INRHB("RUN","SRVR",INBPN,INIP("PORT"))=$H
 ;Set destination determination code
 S INXDST=$$VAL^DWRA(4001.1,23.01,2,DIE,INDA)
 ;Set array of valid destinations
 D DISPLAY^INTSUT1("Setting valid destination(s)")
 F I=1:1 S X=$T(DEST+I^INHVTAPR) Q:X'[";;"  D
 .S Y=$TR($P(X,";;")," ",""),INDEST(Y)=$P(X,";;",2)
 D DISPLAY^INTSUT1("Initialized variables from background process file")
 Q
OPEN(CLISRV,INIP,INMEM,INCHNL,INPOP,INNM) ;Open connection
 ; Input:
 ;  CLISRV - 0 Client, 1 Server
 ;  INIP - Process parameters
 ;  INNM - Name of what is being opened
 ; Output:
 ;  INMEM - memory location
 ;  INCHNL - chanel of tcp/ip socket
 ;  INPOP - 0 stop 1 continue
 N INLOOP,OPENED,MSG,INX
 K INCHNL
 S INNM=$G(INNM) S:INNM="" INNM="Test Utility"
 S INX=$S(CLISRV:"server",1:"client"),(INDEBUG,INDONE)=0
 D DISPLAY^INTSUT1("Opening connection for "_INX_" process ") Q:'INPOP
 ;Open %INET
 F INLOOP=1:1:INIP("OTRY") D  Q:INCHNL!'INPOP  H INIP("OHNG")
 .S MSG="Attempt "_INLOOP_" to open socket"
 .D DISPLAY^INTSUT1(MSG)
 .;If background process is server open Test Utility as SERVER
 .I CLISRV D SRVOPN(.INIP,.INCHNL,.INMEM)
 .;If background process is client open Test Utility as CLIENT
 .I 'CLISRV D CLIOPN(.INIP,.INCHNL,.INMEM)
 .Q:+INCHNL
 .I $L(INCHNL) D DISPLAY^INTSUT1(INCHNL) S INCHNL=""
 .;Hang and retry
 .D DISPLAY^INTSUT1("Waiting "_INIP("OHNG")_" seconds for retry")
 ;
 I 'INCHNL D  Q
 .D DISPLAY^INTSUT1("Unable to connect to "_INNM_" at "_INIP("ADDR")_" /    "_INIP("PORT"))
 .S INPOP=0
 D DISPLAY^INTSUT1("Channel "_+INCHNL_" opened.")
 Q
SRVOPN(INIP,INCHNL,INMEM) ;Open Server
 ; Input:
 ;   INIP - Parameters
 ;   INCHNL - Port channel
 ;   INMEM - Memory location
 D DISPLAY^INTSUT1("Opening Server at port "_INIP("PORT"))
 D OPEN^%INET(.INCHNL,.INMEM,"",INIP("PORT"),1)
 Q
CLIOPN(INIP,INCHNL,INMEM) ;open client
 ; Input:
 ;   INIP - Parameters
 ;   INCHNL - Port channel
 ;   INMEM - Memory location
 D DISPLAY^INTSUT1("Opening Client at address "_INIP("ADDR")_" port "_INIP("PORT"))
 D OPEN^%INET(.INCHNL,.INMEM,INIP("ADDR"),INIP("PORT"),1)
 I 'INCHNL,INCHNL'="" D DISPLAY^INTSUT1(INCHNL_" "_INIP("ADDR")_" "_INIP("PORT"))
 Q
EXIT(INCHNL,INBPN,INIP,CLISRV) ;Main exit module
 ;Input:
 ; INCHNL - Port channel
 ; INBPN - background process pointer
 ; INIP - Array of tcp parameters
 ; CLISRV - 1 Server 0 client
 ;server
 I CLISRV D
 .L -^INRHB("RUN","SRVR",INBPN,INIP("PORT"))
 .D CLOSE(.INCHNL,"Server")
 .K ^INRHB("RUN","SRVR",INBPN,INIP("PORT"))
 ;client
 I 'CLISRV D
 .D CLOSE(.INCHNL,"Client")
 .L -^INRHB("RUN",INBPN,INIP("PORT"))
 .K ^INRHB("RUN",INBPN,INIP("PORT"))
 D DISPLAY^INTSUT1("Exiting TCP socket transmitter for the Test Utility")
 Q
 ;
CLOSE(INCHNL,INTP) ;Close channel
 ; Input:
 ;  INCHNL - Cannel of Socket
 ;  INTP - Client or Server
 D DISPLAY^INTSUT1("Closing "_INTP_" channel "_(+INCHNL)),CLOSE^%INET(.INCHNL)
 Q
CLINIT(INIP,INCHNL,INMEM,INPOP) ;Init as a client send init string
 ; Input:
 ;  INIP - Input paramters
 ;  INCHNL - TCP/IP socket channel
 ;  INMEM - MEMORY LOCATION FOR TCP/IP
 ;  INPOP - 0 Stop processing, 1 continue
 N J,MS,INMS,I,ER,ING,INDATA,APREC,INSMIN,INSND,INOUT
 D DISPLAY^INTSUT1("Opened as client")
 S INOUT=0
 I $L(INIP("INIT")) F INSND=1:1:INIP("STRY") D  Q:'INPOP!INOUT
 .D SENDSTR^INHUVUT(INIP("INIT"),INCHNL)
 .D DISPLAY^INTSUT1("Sent initilization string")
 .;Receive initialization response, if specified
 .I '$L(INIP("ACK")) S INOUT=1 Q
 .D DISPLAY^INTSUT1("waiting to receive initialization response.")
 .S INSMIN=$S($P($G(^INRHSITE(1,0)),U,14):$P(^(0),U,14),1:2500)
 .S ING="INDATA"
 .F I=1:1:INIP("RTRY") D  Q:$D(ING)  H:I<INIP("RTRY") INIP("RHNG")
 ..D RECSTR^INTSREC(.ING,.INCHNL,.INIP)
 .I '$D(@ING) D  Q
 ..D DISPLAY^INTSUT1("No response received to intialization string ")
 .S INOUT=1
 I '$D(@ING) S INPOP=0
 Q:'INPOP
 ;Diplay ack message
 D PARSEDCT^INHUT9(ING,"INMS",IOM,3,"",1)
 S J=0 F  S J=$O(INMS(J)) Q:'J  S MS=INMS(J) D:$L(MS) DISPLAY^INTSUT1(MS,INEXPAND)
 K INMS,MS
 ;response not same as what's in ACK
 I @ING@(1)'[INIP("ACK") D
 .S INPOP=0
 .D DISPLAY^INTSUT1("Incorrect response "_@ING@(1)_" received to intialization string ")
 Q
SRVINIT(INIP,INCHNL,INMEM,INPOP) ;--If opening as server, receive initialization string
 ; Input:
 ;  INIP - Input paramters
 ;  INCHNL - TCP/IP socket channel
 ;  INMEM - MEMORY LOCATION FOR TCP/IP
 ;  INPOP - 0 Stop processing, 1 continue
 ;Receive initialization
 N INLOOP
 Q:'$L(INIP("INIT"))
 D DISPLAY^INTSUT1("Waiting to receive initialization string")
 S ING="INDATA" K @ING
 F INLOOP=1:1:INIP("RTRY") D  Q:$D(@ING)  H:INLOOP<INIP("RTRY") INIP("RHNG")
 .D DISPLAY^INTSUT1("Waiting to receive initialization string")
 .D RECSTR^INTSREC(.ING,.INCHNL,.INIP)
 I '$D(@ING) D  Q
 .S INPOP=0
 .D DISPLAY^INTSUT1("No initialization string received")
 I @ING@(1)'[INIP("INIT") D  Q
 .S INPOP=0
 .D DISPLAY^INTSUT1("Incorrect intialization received: "_@ING@(1))
 ;received something while waiting for Init string
 D DISPLAY^INTSUT1("Received Initialization String")
 ;Diplay ack message
 D PARSEDCT^INHUT9(ING,"INMS",IOM,3,"",1)
 S J=0 F  S J=$O(INMS(J)) Q:'J  S MS=INMS(J) D:$L(MS) DISPLAY^INTSUT1(MS,INEXPAND)
 K INMS,MS
 ;Send initialization response if specified
 I $L(INIP("ACK")) D
 .D SENDSTR^INHUVUT(INIP("ACK"),INCHNL)
 .D DISPLAY^INTSUT1("Sent initialization response")
 Q
ERROR(ER,INERR,INRCVE,INPOP) ;receive error check
 ; Input:
 ;  ER - error
 ;  INERR - Error description
 ; Input/Output:
 ;  INRCVE - Receive count
 ;  INPOP - 0 stop 1 continue
 N RUN
 ;If ER, some error or timeout has occurred
 ;Log transceiver error if fatal, don't update message status
 I ER,$L($G(INERR)) D DISPLAY^INTSUT1(INERR)
 S INRCVE=+$G(INRCVE)+1 I INRCVE>INIP("RTRY") S INPOP=0 H INIP("RHNG")
 ;--Blank and/or error conditions from receive
 ;If ER=3, the other side has dropped the connection.
 I ER=3 D DISPLAY^INTSUT1("Remote end disconnect") S INPOP=0 Q 0
 Q 1
EVAL(INIP,ING,INDEST,ACKUIF,INERR,INXDST,ER,INMSG,INRONLY) ;Evaluate incoming msg
 ;Input:
 ; INIP - Parameters
 ; ING - variable set = to variable that holds message
 ; INDEST - destinations
 ; INRONLY - 1 Receive only send no ack, 0 receive then send ack
 ;Output:
 ; ACKUIF - ien of Ack message in UIF
 ; INERR - Error description
 ; INXDST - Destination Determination xeq
 ; ER - true or false
 N INACKID,ER
 ;get ack
 S ER=$$IN^INTSUSN(.INIP,ING,.INDEST,.ACKUIF,.INERR,.INXDST,.INMSG,.INMSASTA,INRONLY)
 ;ER=3 means out of synch, stop tranceiver (NOT checking for this tcvr)
 ;ER=2 is fatal error
 ;ER=1 is non-fatal error. Log it, but move on to next transmission
 ;ER=0 is no error
 ;Log error message
 I 'ER,'$D(INERR)
 I ER,$D(INERR) D  K INERR
 .S ERNO=0 F  S ERNO=$O(INERR(ERNO)) Q:'ERNO  D DISPLAY^INTSUT1(INERR(ERNO),+$G(ACKUIF))
 K @ING
 Q
INIT(INDA,INIP) ;Initialize IP variables
 ; Input: INDA - ien of test case
 ; Output: INIP - IP variables
 N STR,STR13,STR17
 S STR=$G(^DIZ(4001.1,INDA,16)),STR13=$G(^DIZ(4001.1,INDA,13)),STR17=$G(^DIZ(4001.1,INDA,17)),INIP("PRE")=$G(^DIZ(4001.1,INDA,21)),INIP("POST")=$G(^DIZ(4001.1,INDA,22))
 S INIP("AATT")=$P(STR13,U)
 S INIP("AAC")=$P(STR13,U,4)
 S INIP("OTRY")=$S($L($P(STR,U,4)):$P(STR,U,4),1:10)
 S INIP("OHNG")=$S($L($P(STR,U,3)):$P(STR,U,3),1:15)
 S INIP("RTO")=$S($L($P(STR,U,11)):$P(STR,U,11),1:15)
 S INIP("STO")=$S($L($P(STR,U,8)):$P(STR,U,8),1:60)
 S INIP("RTRY")=$S($L($P(STR,U,10)):$P(STR,U,10),1:5)
 S INIP("RHNG")=$S($L($P(STR,U,9)):$P(STR,U,9),1:10)
 S INIP("EOL")=$$ASCII^INHUVUT($S($L($P(STR,U,12)):$P(STR,U,12),1:13))
 S INIP("INIT")=$$ASCII^INHUVUT($P(STR17,U))
 S INIP("ACK")=$$ASCII^INHUVUT($P(STR17,U,2))
 S INIP("THNG")=$S($L($P(STR,U,5)):$P(STR,U,5),1:10)
 S INIP("STRY")=$S($L($P(STR,U,7)):$P(STR,U,7),1:10)
 S INIP("SHNG")=$S($L($P(STR,U,6)):$P(STR,U,6),1:10)
 S INIP("NOSOM")=1
 I $G(DUZ)>1 S INIP("TMAX")=$$DTIME^INHULOG(DUZ)
 S INIP("ADDR")=$P(STR,U)
 S INIP("PORT")=$P(STR,U,2)
 Q
