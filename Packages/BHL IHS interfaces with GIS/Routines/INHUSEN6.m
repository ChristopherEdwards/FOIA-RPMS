INHUSEN6 ;KN,DGH; 11 Nov 1999 16:52 ;Main X12 processing logic 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;CHCS ; INT_460; GEN 1;26-SEP-1996
 ;COPYRIGHT 1998 SAIC
 ;
 ;
 Q
X12IN(ING,INDEST,INDSTR,INSEND,INERR,INXDST,INMSG,INLHSCH,INSTAT,INNOACK) ;X12
 ; DESCRIPTION:
 ; This is the primary entry function to process all incoming 
 ; transmissions.  The main functions for this entry are:
 ;  1.  Verify all needed headers are present (see VERIF^ 
 ;      INHUSEN7) and determine type of incoming transmission.
 ;       2.  Based on types of incoming transmission.
 ;     - Incoming transmission is an Interchange Ack (TA1 or FA)
 ;       Evaluate the result, store the Ack, and update the 
 ;       original transmission status.
 ;     - Incoming transmission is response to query.
 ;       (The Transaction Set may contain a Response (271) or 
 ;       an Unsolicited message) - Determine destination and file 
 ;             into Output Controller for further processing.  If 
 ;       Interchange Ack (TA1 or 997) is required, create and send.
 ; Parameters:
 ; Input: 
 ;   ING = (REQ) Variable array/global containing lines from transmission
 ;   INDEST = Array of valid destinations in format INDEST(type) = .01
 ;      field of Transaction Type.  This is not required if 
 ;      processing incoming ACKS.
 ;   INDSTR = (REQ) Receiver dest. pointer -- $P(^INTHPC(INBPN,0),U,7)
 ;   INXDST = (OPT) EXecutable code to identify the destination for 
 ;      msgs which won't be uniquely identified.  The 
 ;       executable must return the ien in the variable INDSTP.
 ;   INLHSCH = (OPT) Set to 1 if the incoming msg should not be 
 ;       placed on the output controller queue, ^INLHSCH. If 
 ;          not specified, this routine will determine the 
 ;       conditions under which a msg is queued.
 ;
 ; Output:
 ;   INSEND = (OPT) Variable which will contain the UIF entry(ies) 
 ;       of msg which needs to be sent by tranceiver back to 
 ;      other system. This may be a functional ack (PBR)
 ;   INERR  = (OPT) Variable to return error msg. (PBR)
 ;   INMSG  = (OPT) Variable to return UIF of inbound transaction (PBR)
 ;   INSTAT = (OPT) If incoming is an ack, this variable contains the
        ;            the status of the original message. (PBR)
 ;            Note: transmitter retry logic is based on HL7 values of
 ;            CA, CR, CE, so the X12 status values of A,E,R are
 ;            transformed into their HL7 equivalents in this function.
 ;
 ; Return:
 ;   0 = Success
 ;   1 = Non-fatal error ( no resend required )
 ;   2 = Fatal error
 ;
 N INDELIM,INLINK,INSUBDEL,INTA
 ;First verify and evaluate the X12 transmission, quit if fatal error
 D:$G(INDEBUG) LOG^INHVCRA1("Entering X12 INHUSEN verification",9)
 S INVL=$$VERIF^INHUSEN7(ING,.INTYP,.INTA,.ORIGID,.INLINK,.INSTAT,.INERR)
 ;Convert X12 status to HL7 equivalent for transmitter logic
 I $L($G(INSTAT)) S INSTAT=$S(INSTAT="A":"CA",INSTAT="R":"CR",1:"CA")
 I INVL=2 Q INVL
 D:$G(INDEBUG) LOG^INHVCRA1("Verification completed: INVL="_INVL_" INTYP="_INTYP,5)
 S MESSID=ORIGID
 ;--- Communication acknowledgment processing --
 ;If incoming is a commit-type ack, FA or TA1, store it, update
 ;the original message, and quit
 I ",FA,TA1,"[(","_INTYP_",") D  Q INVL
 . ;Use generic destination (required to STORE). Don't queue.
 . S INDST="INCOMING ACK",INDSTP=$O(^INRHD("B",INDST,"")),INLHSCH=1
 . D STORE,CACKLOG^INHUSEN8(INMSG,INLINK,INSTAT)
 ;--All other messages must have a "real" destination to allow STOREage.
 D  Q:INVL=2 INVL
 .;Tranceiver must specify INXDST, execute it.
 .I '$L($G(INXDST)) D ERRADD^INHUSEN3(.INERR,"No destination determination code specified for recevier") S INVL=2 Q
 .D:$G(INDEBUG) LOG^INHVCRA1("Executing Destination Determination Code"_INXDST,9)
 .X INXDST
 .I '$D(INDSTP) S INVL=2,MSG(1)="Message "_ORIGID_" has no destination" D ERRADD^INHUSEN3(.INERR,.MSG) Q
 .;pointer needed for most functions, NAME needed for NEW^INHD.
 .S:'$D(INDST) INDST=$P(^INRHD(INDSTP,0),U)
 .;Store msg
 .D STORE
 ;--If incoming is a response, update query. INLINK should have value.
 ;If VERIF did not set INLINK, assume this is an unsolicited message
 ;not a response to a query so there's no original message to update.
 I $L($G(INMSG)),$G(INLINK) D UPDATE^INHUSEN8(INMSG,INLINK)
 ;
 ;---If incoming message requires FA or TA1 to be returned
ACK ;Process Interchange Ack and quit back to transceiver routine.
 D:$G(INDEBUG) LOG^INHVCRA1("Creating commit ack",5)
 D
 .;INNOACK parameter over-rides all others.
 .I $G(INNOACK) Q
 .;Interface Destination File may have over-ride value.
 .S:$L($P(^INRHD(INDSTR,0),U,11)) CND=$P(^INRHD(INDSTR,0),U,11)
 ;Stop Transaction Type Audit
 D:$D(XUAUDIT) TTSTP^XUSAUD("",$G(INMSG))
 ;Create Interchange Ack
 S CERR=$$TACK^INHUSEN8(INDSTR,.INTA,ORIGID,.INSEND)
 Q $S($G(CERR)>INVL:CERR,1:INVL)
 ;
STORE ;Store incoming xmission in the Universal Interface file
 ;Use same STORE as for HL7.
 ;INMSH variable used for selective routing of inbound HL7 messages
 ;based on sending/receiving facility. If needed for X12 different
 ;variables need to be passed to STORE and selective routing
 ;logic needs to be changed.
 S INMSH=""
 D STORE^INHUSEN4
 Q
 ;
 ;
 ;
