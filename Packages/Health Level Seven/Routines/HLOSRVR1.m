HLOSRVR1 ;IRMFO-ALB/CJM - Reading messages, sending acks;03/24/2004  14:43 ;09/13/2006
 ;;1.6;HEALTH LEVEL SEVEN;**126,130,131,133**;Oct 13, 1995;Build 13
 ;Per VHA Directive 2004-038, this routine should not be modified.
 ;
READMSG(HLCSTATE,HLMSTATE) ;
 ;This function uses the services provided by the transport layer to receive a message.  The header is parsed. Does these checks:
 ; 1) Duplicate?
 ; 2) Wrong Receiving Facility?
 ; 3) Can the Receiving App accept this message, based message type & event?
 ; 4) Processing ID must match the receiving system
 ; 5) Must have an ID
 ; 6) Header must be BHS or MSH
 ;
 ;Output:
 ;  Function returns 1 if the message was read fully, 0 otherwise
 ;  HLMSTATE (pass by reference) the message.  It will include the fields for the return ack in HLMSTATE("MSA")
 ;
 N ACK,SEG,STORE,I
 ;
 S STORE=1
 Q:'$$READHDR^HLOT(.HLCSTATE,.SEG) 0
 D SPLITHDR(.SEG)
 ;
 ;parse the header, stop if unsuccessful because the server cannot know what to do next
 I '$$PARSEHDR^HLOPRS(.SEG) D  Q 0
 .S HLCSTATE("MESSAGE ENDED")=0
 .D CLOSE^HLOT(.HLCSTATE)
 D NEWMSG^HLOSRVR2(.HLCSTATE,.HLMSTATE,.SEG)
 I HLMSTATE("ID")="" D
 .S STORE=0
 .I HLMSTATE("HDR","ACCEPT ACK TYPE")="AL" S HLMSTATE("MSA",1)="CE",HLMSTATE("MSA",3)="CONTROL ID MISSING"
 I STORE,$$DUP(.HLMSTATE) S STORE=0
 ;
 ;if the message is not to be stored, just read it and discard the segments
 I 'STORE D
 .F  Q:'$$READSEG^HLOT(.HLCSTATE,.SEG)
 ;
 ;else the message is to be stored
 E  D
 .N FS
 .S FS=HLMSTATE("HDR","FIELD SEPARATOR")
 .F  Q:'$$READSEG^HLOT(.HLCSTATE,.SEG)  D
 ..N MSA,SEGTYPE,OLDMSGID,CODE,IEN,NEWMSGID
 ..S SEGTYPE=$E($E(SEG(1),1,3)_$E($G(SEG(2)),1,2),1,3)
 ..I SEGTYPE="MSA" D
 ...S MSA=SEG(1)_$G(SEG(2))_$G(SEG(3))
 ...S OLDMSGID=$P(MSA,FS,3),CODE=$P(MSA,FS,2)
 ...I $E(CODE,1)'="A" S SEGTYPE="" Q
 ...S:$P(OLDMSGID,"-")]"" IEN=$O(^HLB("B",$P(OLDMSGID,"-"),0))
 ...S:$G(IEN) IEN=IEN_"^"_$P(OLDMSGID,"-",2)
 ..I 'HLMSTATE("BATCH") D
 ...D:SEGTYPE="MSA"
 ....S HLMSTATE("ACK TO")=OLDMSGID
 ....S HLMSTATE("ACK TO","ACK BY")=HLMSTATE("ID")
 ....S HLMSTATE("ACK TO","STATUS")=$S(CODE="AA":"SU",1:"AE")
 ....S:$D(IEN) HLMSTATE("ACK TO","IEN")=IEN
 ...D ADDSEG^HLOMSG(.HLMSTATE,.SEG)
 ..E  D  ;batch
 ...I SEGTYPE="MSH" D
 ....D SPLITHDR(.SEG)
 ....S NEWMSGID=$P(SEG(2),FS,5)
 ....D ADDMSG2^HLOMSG(.HLMSTATE,.SEG)
 ...E  D  ;not MSH
 ....D:SEGTYPE="MSA"
 .....N SUBIEN S SUBIEN=HLMSTATE("BATCH","CURRENT MESSAGE")
 .....S HLMSTATE("BATCH","ACK TO",SUBIEN)=OLDMSGID
 .....S HLMSTATE("BATCH","ACK TO",SUBIEN,"ACK BY")=NEWMSGID
 .....S HLMSTATE("BATCH","ACK TO",SUBIEN,"STATUS")=$S(CODE="AA":"SU",1:"AE")
 .....S:$D(IEN) HLMSTATE("BATCH","ACK TO",SUBIEN,"IEN")=IEN
 ....D ADDSEG^HLOMSG(.HLMSTATE,.SEG)
 .I HLMSTATE("UNSTORED LINES"),HLCSTATE("MESSAGE ENDED"),$$SAVEMSG^HLOF778(.HLMSTATE)
 ;
 I STORE,'HLCSTATE("MESSAGE ENDED") D
 .;reading failed before the end, there is no need to keep anything
 .D:HLMSTATE("IEN") DEL778(HLMSTATE("IEN")) D:HLMSTATE("BODY") DEL777(HLMSTATE("BODY"))
 .S HLMSTATE("IEN")="",HLMSTATE("BODY")=""
 E  D:STORE
 .D CHECKMSG(.HLMSTATE)
 .D ADDAC(.HLMSTATE) ;so that future duplicates can be detected
 .D COUNT^HLOSTAT(.HLCSTATE,HLMSTATE("HDR","RECEIVING APPLICATION"),HLMSTATE("HDR","SENDING APPLICATION"),$S(HLMSTATE("BATCH"):"BATCH",1:HLMSTATE("HDR","MESSAGE TYPE")_"~"_HLMSTATE("HDR","EVENT")))
 ;
 D:'HLCSTATE("MESSAGE ENDED") CLOSE^HLOT(.HLCSTATE)
 Q HLCSTATE("MESSAGE ENDED")
 ;
ADDAC(HLMSTATE) ;adds the AC xref for the message that was just received
 ;The AC xref allows duplicates to be detected.
 ;
 N FROM
 S FROM=$S(HLMSTATE("HDR","SENDING FACILITY",2)]"":HLMSTATE("HDR","SENDING FACILITY",2),1:HLMSTATE("HDR","SENDING FACILITY",1))
 S ^HLB("AC",FROM_HLMSTATE("HDR","SENDING APPLICATION")_HLMSTATE("ID"),HLMSTATE("IEN"))=""
 Q
 ;
DUP(HLMSTATE) ;
 ;Function returns 1 if the message is a duplicate and its ack (if requested) is found, 0 otherwise
 ;Input:
 ; HLMSTATE (pass by reference) the message being read
 ;Output:
 ;  Function returns 1 if the message is a duplicate, 0 otherwise
 ;  HLMSTATE (pass by reference) IF the message is a duplicate:
 ;     returns the prior MSA segment in HLMSTATE("MSA")
 ;!!!! put back if original mode implemented
 ;     If original mode returns the ien of the app ack in HLMSTATE("ACK BY IEN")
 ;
 N IEN,FROM,DUP
 S (IEN,DUP)=0
 ;
 ;no way to determine!  Bad header will be rejected
 Q:(HLMSTATE("ID")="") 0
 ;
 S FROM=$S(HLMSTATE("HDR","SENDING FACILITY",2)]"":HLMSTATE("HDR","SENDING FACILITY",2),1:HLMSTATE("HDR","SENDING FACILITY",1))
 F  S IEN=$O(^HLB("AC",FROM_HLMSTATE("HDR","SENDING APPLICATION")_HLMSTATE("ID"),IEN)) Q:'IEN  D  Q:DUP
 .I HLMSTATE("HDR","ACCEPT ACK TYPE")="NE" S DUP=1 Q
 .;need the MSA to return
 .D  Q
 ..N NODE
 ..S NODE=$P($G(^HLB(IEN,4)),"^",3,10)
 ..S HLMSTATE("MSA",1)=$P(NODE,"|",2)
 ..Q:$L(HLMSTATE("MSA",1))'=2
 ..S HLMSTATE("MSA",2)=$P(NODE,"|",3)
 ..S HLMSTATE("MSA",3)=$P(NODE,"|",4,10)
 ..S DUP=1
 ;
 Q DUP
 ;
CHECKMSG(HLMSTATE) ;
 ;Checks the header & MSA segment, sets HLMSTATE("STATUS","ACTION") if the message needs to be passed, determines if completion status should be set
 ;Input:
 ;  HLMSTATE("HDR") - the parsed header segment
 ;Output:
 ;  HLMSTATE("STATUS")="SE" if an error is detected
 ;  HLMSTATE("STATUS","QUEUE") queue to put the message on
 ;  HLMSTATE("STATUS","ACTION")  <tag^rtn> that is the processing routine for the receiving application
 ;  HLMSTATE("MSA") - MSA(1)=accept code to be returned, MSA(3)= error txt
 ;
 N WANTACK,PASS,ACTION,QUEUE
 M HDR=HLMSTATE("HDR")
 I HDR("ACCEPT ACK TYPE")="NE",'HLMSTATE("ORIGINAL MODE") D
 .S WANTACK=0
 E  D
 .S WANTACK=1
 I HLMSTATE("ORIGINAL MODE") S HLMSTATE("MSA",1)="AE",HLMSTATE("MSA",3)="THIS INTERFACE DOES NOT IMPLEMENT ORIGINAL MODE APPLICATION ACKOWLEDGMENTS",HLMSTATE("STATUS")="SE" Q
 I '$$ACTION^HLOAPP(.HDR,.ACTION,.QUEUE),$G(HLMSTATE("ACK TO"))="" S:WANTACK HLMSTATE("MSA",1)="CR" S HLMSTATE("MSA",3)="RECEIVING APPLICATION NOT DEFINED",HLMSTATE("STATUS")="SE" Q
 S HLMSTATE("STATUS","ACTION")=$G(ACTION),HLMSTATE("STATUS","QUEUE")=$G(QUEUE)
 ;
 ;If this is an application ack, does the original message exist?
 I $G(HLMSTATE("ACK TO"))]"" D  Q:HLMSTATE("STATUS")="SE"
 .N NODE
 .S:+$G(HLMSTATE("ACK TO","IEN")) NODE=$G(^HLB(+HLMSTATE("ACK TO","IEN"),0))
 .I $G(NODE)="" S HLMSTATE("STATUS")="SE",HLMSTATE("ACK TO","IEN")=""  S:WANTACK HLMSTATE("MSA",1)="CE" S HLMSTATE("MSA",3)="INITIAL MESSAGE TO APPLICATION ACKNOWLEDGMENT NOT FOUND" Q
 .I ($P(NODE,"^",11)]"") S HLMSTATE("STATUS","ACTION")=$P(NODE,"^",10,11),HLMSTATE("STATUS","QUEUE")=$S($P(NODE,"^",6)]"":$P(NODE,"^",6),1:"DEFAULT")
 ;
 I HDR("PROCESSING ID")'=HLCSTATE("SYSTEM","PROCESSING ID") S:WANTACK HLMSTATE("MSA",1)="CR" S HLMSTATE("STATUS")="SE",HLMSTATE("MSA",3)="SYSTEM PROCESSING ID="_HLCSTATE("SYSTEM","PROCESSING ID") Q
 ;
 ;
 ;wrong receiving facility?  This is hard to check if the sender is not VistA, because the HL7 standard permits different coding systems to be used. This check is only for DNS or station number.
 S PASS=0
 D
 .;if its an ack to an existing message, don't check the receiving facility
 .I $G(HLMSTATE("ACK TO"))]"" S PASS=1 Q
 .I HDR("RECEIVING FACILITY",1)=HLCSTATE("SYSTEM","STATION") S PASS=1 Q
 .I HDR("RECEIVING FACILITY",3)'="DNS" S PASS=1 Q
 .I HDR("RECEIVING FACILITY",2)="" S PASS=1 Q
 .I $P(HDR("RECEIVING FACILITY",2),":")[HLCSTATE("SYSTEM","DOMAIN") S PASS=1 Q
 .I HLCSTATE("SYSTEM","DOMAIN")[$P(HDR("RECEIVING FACILITY",2),":") S PASS=1 Q
 I 'PASS S HLMSTATE("STATUS")="SE",HLMSTATE("MSA",3)="RECEIVING FACILITY IS "_HLCSTATE("SYSTEM","DOMAIN") S:WANTACK HLMSTATE("MSA",1)="CE"
 I PASS,WANTACK S HLMSTATE("MSA",1)="CA"
 Q
 ;
DEL777(IEN777) ;delete a record from file 777 where the read did not complete
 ;
 K ^HLA(IEN777,0)
 Q
DEL778(IEN778) ;delete a record from file 778 where the read did not complete
 ;
 K ^HLB(IEN778,0)
 Q
 ;
SPLITHDR(HDR) ;
 ;splits hdr segment into two lines, first being just components 1-6
 ;
 N TEMP,FS
 D SQUISH(.HDR)
 S FS=$E($G(HDR(1)),4)
 S TEMP(1)=$P($G(HDR(1)),FS,1,6)
 S TEMP(2)=""
 I $L(TEMP(1))<$L($G(HDR(1))) S TEMP(2)=FS_$P($G(HDR(1)),FS,7,20)
 S HDR(2)=TEMP(2)_$G(HDR(2))
 S HDR(1)=TEMP(1)
 Q
 ;
SQUISH(SEG) ;
 ;reformat the segment array into full lines
 ;
 ;nothing to do if less than 2 lines
 Q:'$O(SEG(1))
 ;
 N A,I,J,K,MAX,COUNT,LEN
 S MAX=$S($G(HLCSTATE("SYSTEM","MAXSTRING"))>256:HLCSTATE("SYSTEM","MAXSTRING"),1:256)
 S (COUNT,I)=0,J=1
 F  S I=$O(SEG(I)) Q:'I  D
 .S LEN=$L(SEG(I))
 .F K=1:1:LEN D
 ..S A(J)=$G(A(J))_$E(SEG(I),K)
 ..S COUNT=COUNT+1
 ..I (COUNT>(MAX-1)) S COUNT=0,J=J+1
 K SEG
 M SEG=A
 Q
 ;
ERROR ;error trap
 S $ETRAP="D UNWIND^%ZTER"
 D END^HLOSRVR
 ;
 ;while debugging quit on all errors
 I $G(^HLTMP("LOG ALL ERRORS")) D ^%ZTER QUIT
 ;
 ;don't log these common errors
 I ($ECODE["READ")!($ECODE["NOTOPEN")!($ECODE["DEVNOTOPN")!($ECODE["WRITE")!($ECODE["OPENERR") D
 .;
 E  D
 .D ^%ZTER
 ;
 ;concurrent server connections (multi-listener) should stop execution, only a single server may continue
 Q:$P($G(HLCSTATE("LINK","SERVER")),"^",2)'="S"
 ;
 ;a lot of errors of the same time may indicate an endless loop, so keep a count
 S ^TMP("HL7 ERRORS",$J,$ECODE)=$G(^TMP("HL7 ERRORS",$J,$ECODE))+1
 ;
 I ($G(^TMP("HL7 ERRORS",$J,$ECODE))>100) K ^TMP("HL7 ERRORS",$J) QUIT
 ;
 ;resume execution for the single listener
 D UNWIND^%ZTER
 Q
