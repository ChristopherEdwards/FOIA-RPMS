INHUSEN8 ; DGH ; 11 Nov 1999 16:44 ; X12 activity log and acking logic
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 Q
CACKLOG(INCAACK,INLINK,INSTAT,INCANAKM) ;Log an X12 communication ack
 ;Modified version of CACKLOG^INHUSEN2. Stores status in originating
 ;message of "A"=Accept ack received, "C"=Complete, or "E"=Error
 ;INCAACK   (reqd) = UIF entry # of current message
 ;INLINK  (reqd) = Link identfier back to original outgoing message.
 ;     (note that CACK^INHUSEN3 logic uses the message id)
 ;INSTAT  (reqd) = ack status (A,E or R)
 ;
 Q:'$D(^INTHU(+$G(INCAACK)))
 N AMID,MESS,STAT,DIE,DR,DA
 ;Mark the accept ack complete before updating original message
 S DIE="^INTHU(",DA=INCAACK,DR=".03///C;.09////"_$$NOW^UTDT D
 .;Temporary stack to be sure variable integrety later on
 .N INCAACK,INCAORIG,INSTAT,INCANAKM D ^DIE
 I '$L($G(INLINK)) D ERRADD^INHUSEN3(.INERR,"FA/TA1 message "_ORIGID_" does not identify an orginating message") Q
 I '$D(^INTHU("ASEQ",INDSTR,INLINK)) D ERRADD^INHUSEN3(.INERR,"Acknowledged message "_INLINK_" can not be found for FA/TA1 "_ORIGID) Q
 S AMID=$O(^INTHU("ASEQ",INDSTR,INLINK,""))
 ;update pointer in this ack to original message
 S $P(^INTHU(INCAACK,0),U,7)=AMID
 ;update original message with pointer to ack and with status info.
 S MESS(1)="FA/TA1 received with "_INSTAT_" status."
 ;X12 uses E to indicate there were errors, but message was accepted.
 ;A status of R is a reject code which the GIS will file as an "error".
 S $P(^INTHU(AMID,0),U,18)=INCAACK,STAT=$S(INSTAT="R":"E",1:"A")
 ;If originating message does not require application ack, upgrade
 ;successful status to C
 I STAT="A",'$P(^INTHU(AMID,0),U,4) S STAT="C"
 S DIE="^INTHU(",DA=AMID,DR=".03///"_STAT D ^DIE
 S:$G(INCANAKM)]"" MESS(2)=INCANAKM
 S MESS(1)=MESS(1)_" in transaction with ID="_$P(^INTHU(INCAACK,0),U,5)
 D ULOG^INHU(AMID,STAT,.MESS)
 ;;Check, isn't this redundant?
 ;;D ULOG^INHU(INCAACK,"C")
 Q
 ;
UPDATE(INCAACK,INLINK) ;Update activity log multiple of outgoing msg
 ;This tag should only be called under two conditions.
 ;1) The incoming message is received on a receiver, not a transmitter.
 ;2) The variable INLINK has value.
 ;An incoming message such as a 271 may be in response to an
 ;outgoing message such as a 270. This stores the ien of the response
 ;in the "application acknowledge" field. The GIS does not appear to
 ;be doing this for HL7 application acks, though it probably should.
 ;INCAACK   (reqd) = UIF entry # of current message
 ;INLINK  (reqd) = Link identfier back to original outgoing message.
 ;
 Q:'$D(^INTHU(+$G(INCAACK)))
 Q:'$L($G(INLINK))
 N AMID,MESS,STAT,DIE,DR,DA
 I '$D(^INTHU("ASEQ",INDSTR,INLINK)) D ERRADD^INHUSEN3(.INERR,"Acknowledged message "_INLINK_" can not be found for message "_ORIGID) Q
 S AMID=$O(^INTHU("ASEQ",INDSTR,INLINK,""))
 ;update pointer in this response to original query message
 S $P(^INTHU(INCAACK,0),U,7)=AMID
 ;update pointer in original query to this response
 S $P(^INTHU(AMID,0),U,6)=INCAACK
 ;Set status of query message to "ack received" and log message.
 S MESS(1)="Response received in transaction with ID="_$P(^INTHU(INCAACK,0),U,5)
 D ULOG^INHU(AMID,"C",.MESS)
 Q
 ;
TACK(INDSTR,INTA,ORIGID,INSEND,INQUE) ;Send Interchange Acknowledgement
 ; This returns a TA1 (Interchange Acknowledgment) or 997. The
 ; Ack does not go through output processor. The pointer to the 
 ; Interchange Ack TT is in the Interface Destination File and is 
 ; independent of the originating message TT.
 ;
 ; Parameters:
 ; Input:
 ;   INDSTR   = (REQ) Receiver dest pointer -- $P(^INTHPC(INBPN,0),U)
 ;   INTA     = (REQ) Array contains values for TA1 or 997
 ;   ORIGID   = (REQ) Message id defined in IN^INHUSEC
 ;   INQUE    = (OPT) If set to 1 (default) interchange ack will not be 
 ;     queued into ^INLHSCH. This is normal for a interchange ack 
 ;     because the tranceiver will usually send back to other system.
 ;     If set to 0, the Ack will be entered into INLHSCH.
 ; Output:
 ;   INSEND   = (PBR) UIF of the ack created in this function.
 ;
 ; Return:
 ;   0=success
 ;   1= non-fatal. Inability to return Ack is non-fatal to msg.
 ;
 ; Note: It is assumed that the Ack script is responsible for
 ;       constructing ISA, and IEA.  For example, the Ack script will
 ;       set date/time(ISA09,ISA10), sender id(ISA06), control number
 ;      (ISA13), version number (ISA12).
 ;
 ;       This tag will provide the following information: 
 ;       - Interchange Receiver ID (ISA08)
 ;       - All the TA1 elements
 ;
 N INA,TRT,UIF,DA,DIE,DR,DIC,SCR,DEST,Z,INTNAME
 I '$D(^INRHD(INDSTR)) D ENR^INHE(INBPN,"Invalid destination in message "_ORIGID) Q 1
 S TRT=$P(^INRHD(INDSTR,0),U,10) I 'TRT D ENR^INHE(INBPN,"No Transaction Type designated for Interchange Ack for destination "_$P(^INRHD(INDSTR,0),U)) Q 1
 ;The value for Interchange Ack (TA1) are passed in via array INTA.  The Ack script
 ;will use these value to construct TA1 acknowledgment
 ;Following code copied from ACK^INHF and modified.
 D
 .S SCR=$P(^INRHT(TRT,0),U,3),DEST=+$P(^INRHT(TRT,0),U,2),INTNAME=$P(^INRHT(TRT,0),U)
 .Q:'SCR!'DEST  Q:'$D(^INRHS(SCR))!'$D(^INRHD(DEST))
 .;Determine if this should go into output queue. Normally not,
 .S INQUE=$S('$D(INQUE):1,INQUE=0:0,1:1)
 .;Set INDA array. Normally, Ack message has value of -1.
 .S INDA=$S('$D(INDA):-1,INDA="":-1,1:INDA)
 .;Start transaction audit
 .D:$D(XUAUDIT) TTSTRT^XUSAUD($G(INTNAME),"",$P($G(^INTHPC(INBPN,0)),U),$G(INHSRVR),"SCRIPT")
 .S Z="S ER=$$^IS"_$E(SCR#100000+100000,2,6)_"("_TRT_",.INDA,.INTA,"_DEST_","_INQUE_")"
 .X Z
 .;Stop transaction audit with one of the following
 .D:$D(XUAUDIT) TTSTP^XUSAUD(0)
 ;
 ;The script leaves UIF variable after execution
 I '$D(UIF) D ENR^INHE(INBPN,"Unable to create ack message for "_ORIGID) Q 1
 ;Unless ack went on queue (unlikely), set ack status to "complete"
 I INQUE,UIF>0 D ULOG^INHU(UIF,"C")
 S INSEND=$S(UIF>0:UIF,1:"")
 Q 0
 ;
 ;
