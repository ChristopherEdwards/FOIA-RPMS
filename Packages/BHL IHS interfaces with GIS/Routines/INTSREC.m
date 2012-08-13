INTSREC ;JPD ; 13 May 98 12:09; Generic receiver, enhanced functions
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 ;This is an interactive transmitter/receiver routine supporting
 ;enhanced functionality.
 ;It receives a message, sends an ack, receives a message, etc.
 ;The process can function as either a server or a client, depending
 ;on the parameters. See notes below.
 ;
 ;This runs similar to INHVTAPR
 Q
EN(INEXPAND,INDA,DIE) ;
 ;Input:
 ;  INEXPAND - 0 - don't expand, 1 - expand
 ;  INDA - ien of 4001.1 file
 ;  DIE - 4001.1
 N INBPN,INIP,CLISRV,INXDST,INDEST,INPOP,INDEBUG,J,INTT,MS
 ;Background process
 S INBPN=+$$VAL^DWRA(4001.1,20,2,DIE,INDA)
 ;Initialize variables
 D INIT1^INTSUT(INDA,.INBPN,.INIP,.CLISRV,.INXDST,.INDEST,.INPOP)
 Q:'INPOP
 I INIP("PORT")="" D DISPLAY^INTSUT1("No port Designated") Q
 ;open socket
 D OPEN^INTSUT(CLISRV,.INIP,.INMEM,.INCHNL,.INPOP)
 I INPOP,$L(INIP("INIT")) D
 .;If opening as a Client Send Init String
 .I 'CLISRV D CLINIT^INTSUT(.INIP,.INCHNL,.INMEM,.INPOP)
 .;If opening as server
 .I CLISRV D SRVINIT^INTSUT(.INIP,.INCHNL,.INMEM,.INPOP)
 ;receiver data
 I INPOP D RECEIVE(.INIP,.INCHNL,.INXDST,.INDEST,INEXPAND,.INPOP,INDA)
 ;close socket
 D EXIT^INTSUT(.INCHNL,INBPN,.INIP,CLISRV)
 Q
RECEIVE(INIP,INCHNL,INXDST,INDEST,INEXPAND,INPOP,INDA,INRONLY,INOUT) ;
 ;Input:
 ; INIP - Parameters
 ; INCHNL - port channel
 ; INXDST - Destination Determination xeq
 ; INDEST - destinations
 ; INEXPAND - 0 - don't expand, 1 - expand
 ; INPOP - 0 stop 1 continue
 ; INDA - ien of Criteria
 ; INRONLY - 1 Receive only and send no ack, 0 receive then send ack
 ;Output:
 ; (opt) INOUT - out of loop
 ;
 N INERR,ER,INMEM,ING,INDATA,INLP,RUN,X,Y,Z,ACKUIF,INUPDAT,INRCVE
 S INRONLY=+$G(INRONLY),INOUT=$G(INOUT),(INUPDAT,INRCVE)=0
 F X=1:1 S Y=$T(DEST+X) Q:Y'[";;"  S Z=$TR($P(Y,";;")," ",""),INDEST(Z)=$P(Y,";;",2)
 F INLP=1:1:INIP("RTRY") D  Q:'INPOP!INOUT  D DSPHNG Q:'INPOP
 .I 'INRONLY,$G(INIP("PRE"))'="" D PRE^INTSUT2(INDA,INIP("PRE"),"",.INARY) Q:'$$POSTPRE^INTSUT2(INDA,.INARY,.INEXTUIF,.INLASTN,.INPOP,.INUPDAT)
 .S ING="INDATA" K @ING,INERR
 .S ER=$$RECEIVE^INHUVUT(.ING,.INCHNL,.INIP,.INERR,.INMEM)
 .K INMS,MS
 .I ER,$$ERROR^INTSUT(ER,.INERR,.INRCVE,.INPOP) Q
 .Q:'INPOP
 .;evaluate data
 .D EVAL^INTSUT(.INIP,.ING,.INDEST,.ACKUIF,.INERR,.INXDST,ER,.INMSG,INRONLY) Q:'INPOP
 .D DISPLAY^INTSUT1("Received Successfully "_$P($G(^INTHU(+$G(INMSG),0)),U),0,+$G(INMSG))
 .;if we saved incoming message/UIF ien exists
 .I $G(INMSG)>0 D
 ..;mark the message complete
 ..D ULOG^INHU(INMSG,"C")
 ..;expand message
 ..I 'INEXPAND D EXPNDIS^INTSUT1(INMSG)
 .;receive only
 .I INRONLY S INOUT=1
 .;if not receive only evaluate and send ack
 .I 'INRONLY D
 ..I $G(INIP("POST"))'="" D POST^INTSUT2(INDA,.ACKUIF,.INARY)
 ..Q:'$$POSTPRE^INTSUT2(INDA,.INARY,.ACKUIF,.INLASTN,.INPOP,.INUPDAT)
 ..D SEND(ACKUIF,INCHNL,.INIP,.INLOOP,INEXPAND)
 ..S INLP=1
 ;not recieve only and updated tests in prepost
 I 'INRONLY,INUPDAT D
 .N INOPT
 .S INOPT("TYPE")="TEST",INOPT("NONINTER")=1
 .D SAVE^INHUTC1(.INOPT,INDA,"U")
 Q
DSPHNG ;hang then display
 D DISPLAY^INTSUT1("Waiting to receive. Hanging "_INIP("RHNG")_" seconds")
 H INIP("RHNG")
 Q
SEND(ACKUIF,INCHNL,INIP,INLOOP,INEXPAND) ;Send outgoing ack.
 ; Input:
 ;  ACKUIF - Universal Interface file ien for ack
 ;  INCHNL - tcp/ip channel
 ;  INIP - Parameters
 ;  INLOOP - Receive retry count
 ;  INEXPAND - 0 expand 1 don't expand
 I 'ACKUIF D DISPLAY^INTSUT1("ACK not sent")
 I ACKUIF D
 .D DISPLAY^INTSUT1("Transmitting commit acknowledgement")
 .I 'INEXPAND D EXPNDIS^INTSUT1(ACKUIF)
 .S ER=$$SEND^INHUVUT(.ACKUIF,INCHNL,.INIP)
 .I 'ER D DISPLAY^INTSUT1("Ack sent - Successful transmission")
 .S INLOOP=0
 Q
RECSTR(INV,INCHNL,INIP) ;
 ; Input:
 ;  INV - gets set in PARSE^INHUVUT1
 ;  INV(1) if line terminated by $c(13), or is first line of many in seg
 ;  INV(1,1), INV(1,2)... for overflow nodes until terminated
 ;  INCHNL - tcp/ip channel
 ;  INIP - Parameters
 N APDONE,APREC,AP,NULLREAD,NORESP,INSMIN
 S (APDONE,APREC,AP)="",(NULLREAD,NORESP)=0,INREC="REC"
 S INSMIN=$S($P($G(^INRHSITE(1,0)),U,14):$P(^(0),U,14),1:2500)
 F  D  Q:APDONE!NORESP
 .D RECV^%INET(.APREC,.INCHNL,INIP("RTO"),1)
 .I $G(APREC(0))["Remote end disconnect" D  Q
 ..D DISPLAY^INTSUT1(APREC(0))
 ..S INPOP=0,APDONE=1
 .I APREC=""!(APREC[$C(28)) S APDONE=1
 .S APREC=$TR(APREC,$C(11))
 .I '$L(APREC) D  Q
 ..S NULLREAD=NULLREAD+1 S:NULLREAD>INIP("RTRY") NORESP=1
 .I $S<INSMIN,INREC'["^" D
 ..K ^UTILITY("INREC",$J)
 ..M ^UTILITY("INREC",$J)=@INREC K @INREC S INREC="^UTILITY(""INREC"","_$J_")"
 .S AP=AP+1,@INREC@(AP)=APREC
 Q:'$D(APREC)
 D PARSE^INHUVUT1
 K @INREC
 Q
DEST ; get valid destinations
ORMO01 ;;TEST INTERACTIVE
 ;
