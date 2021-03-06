HLCSTCP2 ;SFIRMFO/RSD - BI-DIRECTIONAL TCP ;09/13/2006
 ;;1.6;HEALTH LEVEL SEVEN;**19,43,49,57,63,64,66,67,76,77,87,109,133**;Oct 13,1995;Build 13
 ;Per VHA Directive 2004-038, this routine should not be modified.
 ;Sender 
 ;Request connection, send outbound message(s) delimited by MLLP
 ;Input : HLDP=Logical Link to use
 ; Set up error trap
 N $ETRAP,$ESTACK S $ETRAP="D ERROR^HLCSTCP2"
 N HLMSG,HLPORT,HLRETRY,HLRETMG,HLTCPO,POP
 ;HLRETRY=number of retranmission for this link,HLRETMG=alert sent
 S HLTCPO=HLDP,HLMSG="",(HLRETRY,HLRETMG)=0
 ;
 ;set IO(0) to the null device
 S IO(0)=$S(^%ZOSF("OS")["OpenM":$S($$OS^%ZOSV()["VMS":"_NLA0:",$$OS^%ZOSV()["UNIX":"/dev/null",1:$P),^%ZOSF("OS")["DSM":"_NLA0:",1:$P)
 O IO(0) U IO(0)
 ;
 ;persistent conection, open connection first, HLPORT=open port
 I $G(HLTCPLNK)["Y" F  Q:$$OPEN  G EXIT:$$STOP^HLCSTCP H 1
 F  D QUE Q:$$STOP^HLCSTCP  D:'HLMSG  Q:$G(HLCSOUT)
 . ;no messages to send
 . D MON^HLCSTCP("Idle") H 3
 . ;persistent connection, no retention
 . Q:$G(HLTCPLNK)["Y"
 . D MON^HLCSTCP("Retention")
 . N % I 0
 . ;if message comes in or ask to stop
 . F %=1:1:HLTCPRET H 1 I $$STOP^HLCSTCP!$O(^HLMA("AC","O",HLDP,0)) Q
 . E  S HLCSOUT=2 Q
 . Q:$$STOP^HLCSTCP
 . D MON^HLCSTCP("Idle")
 ;Close port
 I $D(HLPORT) D CLOSE^%ZISTCP K HLPORT
EXIT Q
 ;
QUE ; -- Check "OUT" queue for processing IF there is a message do it
 ; and then check the link if it open or not
 N HL,HLN,HLARR,HLHDR,HLI,HLJ,HLMSA,HLRESP,HLRESLT,HLRETRM,HLTCP,HLTCPI,X,Z,HLREREAD
 D MON^HLCSTCP("Check out")
 ;HLMSG=next msg, set at tag DONE
 I 'HLMSG S HLMSG=+$O(^HLMA("AC","O",HLDP,0)),HLRETRY=0 Q:'HLMSG
 ;
 ;**109**
 ;Temporarily lock ^HLMA to flush buffer and ensure edits are complete
 ;L +^HLMA(HLMSG):1 I '$T S HLMSG=0 Q
 ;L -^HLMA(HLMSG)
 ;
 S HLI=+$G(^HLMA(HLMSG,0)),HLJ=$O(^("MSH",0)),HLTCP=""
 ;don't have message text or MSH, kill x-ref and decrement 'to send'
 I 'HLI!'HLJ K ^HLMA("AC","O",HLDP,HLMSG) D LLCNT^HLCSTCP(HLDP,3,1) S HLMSG=0 Q
 ;update msg status to 'being transmitted'; if cancelled decrement link and quit
 I '$$CHKMSG(1.5) D LLCNT^HLCSTCP(HLDP,3,1) S HLMSG=0 Q
 ;number of retransmissions for message
 S HLRETRM=+$P(^HLMA(HLMSG,"P"),U,5)
 ;retries exceeded, HLRETRA:action i=ignore, r=restart, s=shutdown
 ;quit if restart or shutdown, link is going down
 I HLRETRY>HLDRETR D  Q:"I"'[HLRETRA
 . D MON^HLCSTCP("Error")
 . ;only 1 alert per link up time, don't send if restart
 . D:'HLRETMG&(HLRETRA'="R")
 .. ;send alert
 .. N XQA,XQAMSG,XQAOPT,XQAROU,XQAID,Z
 .. ;get mailgroup from file 869.3
 .. S HLRETMG=1,Z=$P($$PARAM^HLCS2,U,8) Q:Z=""
 .. S XQA("G."_Z)="",XQAMSG=$$HTE^XLFDT($H,2)_" HL7 LL "_$P(^HLCS(870,HLDP,0),U)_" exceeded retries. LL will "_$S(HLRETRA="S":"shutdown.",HLRETRA="R":"restart.",1:"keep trying.")
 .. D SETUP^XQALERT
 . ;quit if action is ignore
 . Q:"I"[HLRETRA
 . ;this will shutdown this link
 . S HLCSOUT=1
 . ;action is shutdown, set shutdown flag so LM won't restart
 . S:HLRETRA="S" $P(^HLCS(870,HLDP,0),U,15)=1
 . D STATUS^HLTF0(HLMSG,4,103,"LLP Exceeded Retry Param")
 I '$$OPEN Q
 D MON^HLCSTCP("Send")
 ; -- data passed in global array, success=1
 I $$WRITE(HLMSG)<0 Q
 S (HLTCP,HLTCPI)=HLMSG,HLRETRY=HLRETRY+1,HLRETRM=HLRETRM+1
 ;update status to awaiting response, decrement link if cancelled
 I '$$CHKMSG(1.7) D LLCNT^HLCSTCP(HLDP,3,1) S HLMSG=0 Q
 ;set transmission count, get ACKTIMEOUT override
 S $P(^HLMA(HLMSG,"P"),U,5)=HLRETRM I $P(^("P"),U,7) S HLN("ACKTIME")=+$P(^("P"),U,7)
 ;get header of message just sent
 K HLJ M HLJ=^HLMA(HLMSG,"MSH")
 ;first component of sending app.
 S HLN("ECH")=$$P^HLTPCK2(.HLJ,2),HLN("SAN")=$P($$P^HLTPCK2(.HLJ,3),$E(HLN("ECH")))
 ;msg type, msg. id, commit ack, and app. ack parameter
 S HLN("TYPE")=$$P^HLTPCK2(.HLJ,1),HLN("MID")=$$P^HLTPCK2(.HLJ,10),HLN("ACAT")=$$P^HLTPCK2(.HLJ,15),HLN("APAT")=$$P^HLTPCK2(.HLJ,16)
 ;MSA segment, message is a response, can't have an a. ack.
 S Z=$$MSA^HLTP3(+^HLMA(HLMSG,0)) I Z]"" S:HLN("ACAT")="" HLN("ACAT")="NE" S HLN("APAT")="NE"
 ;for batch/file with commit ack, reset c. ack and a. ack variables
 I "BHS,FHS"[HLN("TYPE") S Z=$E(HLJ(1,0),5),X=$$P^HLTPCK2(.HLJ,9),HLN("ACAT")=$P(X,Z,5),HLN("APAT")=$P(X,Z,6),HLN("MID")=$$P^HLTPCK2(.HLJ,11)
 ;get event protocol
 S HLN("EID")=+$P(^HLMA(HLMSG,0),U,8),X=$G(^ORD(101,HLN("EID"),770))
 ;set link counter to msg sent
 D LLCNT^HLCSTCP(HLDP,4)
 ;commit and app. ack is never, update status to complete and hang UNI-DIRECTIONAL WAIT
 I HLN("ACAT")="NE",HLN("APAT")="NE" D  Q
 .D DONE(3)
 .;
 .;
 .H $G(HLDWAIT)
 ;
 ;do structure is to stack error
 D
 . N $ETRAP,$ESTACK S $ETRAP="D RDERR^HLCSTCP2"
 . ;HL*1.6*87: Read acknowledgement.  
 . ;Loop to re-read from buffer when receiving incorrect ack.
 . F  D  Q:'+$G(HLREREAD)
 .. S HLREREAD=1
 .. ;override ack timeout
 .. I $G(HLN("ACKTIME")) N HLDBACK S HLDBACK=HLN("ACKTIME")
 .. ;check for response, quit if no-response, msg will be resent
 .. ;HLRESP=ien 773^ien 772 for response message
 .. S HLRESP=$$READ^HLCSTCP1()
 .. ;if no response, decrement counter and quit
 .. I 'HLRESP D  Q
 ...D LLCNT^HLCSTCP(HLDP,4,1)
 ...S HLREREAD="0^No Response"
 ...;check if the port needs to be closed and re-opened before the next re-transmission attempt
 ...I $G(HLDRETRY("CLOSE")) D CLOSE^%ZISTCP K HLPORT
 .. ;X 0=re-read msg, 1=commit ack, 3=app ack success, 4=error
 .. S X=$$RSP^HLTP31(HLRESP,.HLN)
 .. ;X=0, re-read msg. Incorrect ack (bad MSH,MSA,msg id,or sending app)
 .. Q:'X 
 .. ;commit ack - done
 .. I X=1 D  S HLREREAD="0^Commit Ack" Q
 ... ;don't need app. ack, set status to complete
 ... I "NE"[HLN("APAT") D  Q
 ....D DONE(3)
 ....;
 ... ;response is deferred, set status to awaiting ack
 ... D DONE(2)
 ...;
 .. ;Error, HLRESLT=error number^error message from HLTP3
 .. I X=4 D  Q
 ... D DONE(4,+$G(HLRESLT),$P($G(HLRESLT),U,2))
 ...;
 ... S HLREREAD="0^Error"
 .. ;app ack was successful
 .. D DONE(3) S HLREREAD="0^App Ack"
 ..;
 Q
 ;
DCSEND ;direct connect
 ; Set up error trap
 N $ETRAP,$ESTACK S $ETRAP="D ERROR^HLCSTCP2"
 ;override ack timeout
 I $G(HLP("ACKTIME")) N HLDBACK S HLDBACK=HLP("ACKTIME")
 I $$WRITE(HLMSG)<0 D:$G(HLERROR)]""  Q  ;HL*1.6*77
 .  D STATUS^HLTF0(HLMSG,4,$P(HLERROR,"^"),$P(HLERROR,"^",2),1) ;HL*1.6*77
 .  D LLCNT^HLCSTCP(HLDP,3,1)
 D LLCNT^HLCSTCP(HLDP,4)
 ;do structure is to stack error
 D
 . N $ETRAP,$ESTACK S $ETRAP="D RDERR^HLCSTCP2"
 . ;HLRESP=ien 773^ien 772 for response message
 . S HLRESP=$$READ^HLCSTCP1()
 ;
 D DONE(3):$G(HLRESP),DONE(4,108,$S($G(HLERROR)]"":$P(HLERROR,"^",2),1:"No response")):'$G(HLRESP)
 I $G(HLERROR)']"" D
 .D MON^HLCSTCP("Idle")
 .I '$G(HLRESP) S HLERROR="108^No response"
 ;Close port
 I $D(HLPORT) D CLOSE^%ZISTCP K HLPORT
 Q
 ;
DONE(ST,ERR,ERRMSG) ;set status to complete
 ;ST=status, ERR=error ien, ERRMSG=error msg
 D STATUS^HLTF0(HLMSG,ST,$G(ERR),$G(ERRMSG),1)
 ;
 ;**109**
 D DEQUE^HLCSREP(HLDP,"O",HLMSG)
 ;
 ;check for more msg.
 I $G(HLPRIO)'="I" S HLMSG=+$O(^HLMA("AC","O",HLDP,0)),HLRETRY=0
 Q
 ;
CHKMSG(HLI) ;check status of message and update if not cancelled
 ;input: HLI=new status, HLMSG=ien of msg in 773
 ;returns 1=msg was updated, 0=msg has been canceled
 N X
 ;
 ;**109**
 ;F  L +^HLMA(HLMSG,"P"):1 Q:$T  H 1
 ;
 ;
 ; New HL*1.6*77 code starting here...
 I '$D(^HLMA(HLMSG,"P")) D  Q 0
 .  S HLERROR="2^Missing status field"
 .  D STATUS^HLTF0(HLMSG,4,$P(HLERROR,U),$P(HLERROR,U,2),1)
 .;
 .;**109**
 . D DEQUE^HLCSREP(HLDP,"O",HLMSG)
 .;L -^HLMA(HLMSG,"P")
 ;**end 109**
 ;
 ; End of HL*1.6*77 modifications
 ;
 ;get status, quit if msg was cancelled
 ;
 ;**109**
 ;S X=+^HLMA(HLMSG,"P") I X=3 L -^HLMA(HLMSG,"P") Q 0
 S X=+^HLMA(HLMSG,"P") Q:X=3 0
 ;
 ;update status if it is different
 I $G(HLI),HLI'=X D STATUS^HLTF0(HLMSG,HLI)
 ;
 ;**109**
 ;L -^HLMA(HLMSG,"P")
 ;
 Q 1
 ;
WRITE(HLDA) ; write message in HL7 format
 ;  HLDA       - ien of message in 773
 ;             - start block $C(11)
 ;             - end block $C(28)
 ;             - record separator $C(13)
 ;Output(s): 1 - Successful
 ;           -1 - Unsuccessful
 ;
 N HLDA2,HLAR,HLI,LINENO,X
 ;set error trap, used when called from HLTP3
 ;
 ; New HL*1.6*77 code starts here...
 N $ETRAP,$ESTACK S $ETRAP="D ERROR^HLCSTCP2"
 I $G(^HLMA(HLDA,0))'>0 D  Q -1
 .  S HLERROR="2^Message Text pointer missing"
 S HLDA2=+$G(^HLMA(HLDA,0))
 ; End of HL*1.6*77 modifications...
 ;
 Q:'$G(^HLMA(HLDA,0)) -1 ;HL*1.6*77
 ; header is in ^HLMA(, message is in ^HL(772,
 S LINENO=1,HLI=0,HLAR="^HLMA(HLDA,""MSH"")"
 U IO
 D  W $C(13) S HLAR="^HL(772,HLDA2,""IN"")",HLI=0 D
 . F  S HLI=$O(@HLAR@(HLI)) Q:'HLI  S X=$G(^(HLI,0)) D
 .. ;first line, need start block char.
 .. S:LINENO=1 X=$C(11)_X
 .. I X]"" W X,!
 .. ;send CR for blank lines
 .. I X="" W $C(13)
 .. S LINENO=LINENO+1
 ; Sends end block for this message
 S X=$C(28)_$C(13)
 U IO W X,!
 I $G(IO(0))'="",$G(IO(0))'=IO U IO(0) ;switch to null device if opened to prevent 'leakage'
 Q 1
 ;
OPEN() ; -- Open TCP/IP device (Client)
 ;HLPORT=port, defined only if port is open
 ;HLPORTA=number of attempted opens
 I $D(HLPORT) S IO=HLPORT D  Q 1
 . U IO
 . I HLOS["OpenM" X "U IO:(::""-M"")" ;use packet mode on Cache'
 N HLDOM,HLI,HLIP,HLPORTA
 G OPENA^HLCSTCP3
 ;
RDERR D RDERR^HLCSTCP4 Q  ; Exceeded 10,000 bytes, so split on 12/2/03-LJA
ERROR D ERROR^HLCSTCP4 Q  ; Exceeded 10,000 bytes, so split on 12/2/03-LJA
 ;
CC(X) ;cleanup and close
 D MON^HLCSTCP(X)
 I $D(HLPORT) D CLOSE^%ZISTCP K HLPORT
 H 2
 Q
