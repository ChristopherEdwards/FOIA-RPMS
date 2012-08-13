INTSEND ;JD; 13 May 96 12:19; "Generic" socket transceiver
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 ;This is an interactive transmitter routine. It first sends a message,
 ;then waits for an ack, then sends another msg, etc.
 ;The counterpart routine is INTSREC, which receives first, then
 ;sends an ack, etc.
 ;
 ;This runs similar to INHVTAPT
EN(INEXPAND,INDA,DIE) ;Entry point
 ; Input:
 ;   INEXPAND - 0 display to screen, 1 don't display to screen
 ;   INDA - ien of criteria
 ;   DIE - Criteria File
 N INPOP,INBPN,INIP,CLISRV,INXDST,INDEST,INCHNL,INMEM,ING,INDATA
 K ^UTILITY("INTHU",DUZ)
 ;update messages
 D UPDTSND^INTSUT3(INDA)
 ;clear channel, set background process ien
 S INCHNL="",INBPN=+$$VAL^DWRA(4001.1,20,2,DIE,INDA)
 S INPOP=1
 ;initialize parameters
 D INIT1^INTSUT(INDA,.INBPN,.INIP,.CLISRV,.INXDST,.INDEST,.INPOP)
 Q:'INPOP
 I CLISRV,INIP("ADDR")'="" S INIP("ADDR")="" D DISPLAY^INTSUT1("IP Address not needed for a Server")
 I 'CLISRV,INIP("ADDR")="" D DISPLAY^INTSUT1("No IP Address designated for client") Q
 ;open socket
 D OPEN^INTSUT(CLISRV,.INIP,.INMEM,.INCHNL,.INPOP)
 I INPOP D
 .;client init string
 .I $L(INIP("INIT"))+$L(INIP("ACK")) D
 ..;if client initialize as client
 ..I 'CLISRV D CLINIT^INTSUT(.INIP,.INCHNL,.INMEM,.INPOP) Q:'INPOP
 ..;if server initialize as server
 ..I CLISRV D SRVINIT^INTSUT(.INIP,.INCHNL,.INMEM,.INPOP) Q:'INPOP
 .I INPOP D DISPLAY^INTSUT1("Socket ready to start send/receive.")
 .;Loop until a transaction exists on the destination queue
 .I INPOP D LOOP(.INCHNL,.INIP,.INDEST,.INXDST,INEXPAND,.INPOP,INDA)
 D EXIT^INTSUT(.INCHNL,INBPN,.INIP,CLISRV)
 Q
LOOP(INCHNL,INIP,INDEST,INXDST,INEXPAND,INPOP,INDA) ;Loop /send and receive messages
 ; Input:
 ;  INCHNL - port channel
 ;  INIP - TCP/IP paramters
 ;  INDEST - array of destinations
 ;  INPOP - 0 stop, 1 continue
 ;  INDA - ien of Criteria
 N INSND,OUT,RCVE,INARY,INEXTN,INEXTUIF,INLASTN,INUPDAT,INOPT
 S (INSND,OUT,RCVE,INLASTN,INUPDAT)=0
 F  D  Q:OUT!'INPOP
 .K INARY,INEXTUIF
 .S (INEXTN,INLASTN)=$O(^UTILITY("INTHU",DUZ,$J,INLASTN))
 .I INEXTN S INEXTUIF=$O(^UTILITY("INTHU",DUZ,$J,INEXTN,""))
 .;Pre process
 .I $G(INIP("PRE"))'="" D PRE^INTSUT2(INDA,INIP("PRE"),.INEXTUIF,.INARY)
 .Q:'$$POSTPRE^INTSUT2(INDA,.INARY,.INEXTUIF,.INLASTN,.INPOP,.INUPDAT)
 .;last entry in utility and nothing updated in post process so QUIT
 .I 'INLASTN S OUT=1 Q
 .I '$D(^INTHU(+$G(INEXTUIF),0)) D DISPLAY^INTSUT1("Invalid or missing Universal Interface entry "_$G(INEXTUIF)) S INPOP=0 Q
 .N INERR,INDATA,ING,ER,INOUT
 .S INOUT=0
 .D DISPLAY^INTSUT1("Ready to send")
 .;loop until done
 .F INSND=1:1:INIP("STRY") D  Q:'INPOP!INOUT
 ..D DISPLAY^INTSUT1("Sending message  "_$P($G(^INTHU(INEXTUIF,0)),U),0,INEXTUIF)
 ..;Expanded display
 ..I 'INEXPAND D EXPNDIS^INTSUT1(INEXTUIF)
 ..F  S ER=$$SEND^INHUVUT(INEXTUIF,INCHNL,.INIP) Q:'ER
 ..D RECEIVE^INTSREC(.INIP,.INCHNL,.INXDST,.INDEST,INEXPAND,.INPOP,INDA,1,.INOUT)
 .I INSND>INIP("STRY") D DISPLAY^INTSUT1("Send retries ("_$G(INIP("STRY"))_") exceeded.")
 .;set message to complete
 .D ULOG^INHU(INEXTUIF,"C")
 ;save criteria tests if they were updated in the pre or post
 I INUPDAT D
 .N INOPT
 .S INOPT("TYPE")="TEST",INOPT("NONINTER")=1
 .S X=$$SAVE^INHUTC1(.INOPT,INDA,"U")
 Q
