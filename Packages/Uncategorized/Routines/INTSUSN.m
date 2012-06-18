INTSUSN ; DGH JPD; 3 Jun 96 09:54; Enhanced functions and utilities 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
IN(INIP,ING,INDEST,INSEND,INERR,INXDST,INMSG,INMSASTA,INRONLY) ;Process incoming
 ;Copied from INHUSEN
 ;Verify all needed data is present
 ;Store xmission (if verified but not if it is for housekeeping)
 ;Create receipt ack as specified in MSH.
 ;
 ;Input:
 ; INIP - array of parameters
 ; ING = (REQ) Variable array/global containing lines from msg.
 ; INDEST = Array of valid destinations in format
 ;          INDEST(type) =  .01 field of destination.  This is not
 ;          required if processing incoming ACKS, but will generate
 ;          an error if processing incoming msg with no destination.
 ; INSEND = (OPT) UIF entry(ies) of msg which needs to be sent by 
 ;          tranceiver back to other system.
 ;          This may be an accept ack
 ; INERR = (OPT) Variable to return error msg. (PBR)
 ; INXDST = (OPT) EXecutable code to identify the destination for
 ; msgs which won't be uniquely identified by INTYP_INEVN.
 ;  The executable must return the ien in the variable INDSTP.
 ;  INMSG = (OPT) Variable to return UIF of inbound msg (PBR)
 ;  INMSASTA = (OPT) Variable to return MSA-1 ack status (PBR)
 ;  INRONLY - 1 Receive only send no ack, 0 receive then send ack
 ;
 ;Returns:
 ;  0 = success, 1 = non-fatal error, 2 = fatal error
 ;
 N ORIGID,ORIGID2,MESSID,INVL,STAT,EXPCT,INDST,INDSTP,INMSH,INTYP
 N INEVN,Z,ACKMSG
 ;Note: INDST and INDSTP are variables for the Dest. file for the
 ;incoming msg. This may differ from the destination of the
 ;background process.
 S (EXPCT,INSEND,INERR)=""
 ;First verify MSH, get msg type and event type. If invalid, quit
 I $$VERIF^INTSUSN1(ING,.INMSH,.INTYP,.INEVN,.INERR) Q 2
 S (MESSID,ORIGID)=$P(INMSH,INDELIM,10)
 ;
 ;is message ID valid
 I MESSID="" S MSG(1)="Message does not have a message ID",MSG(2)=$E(INMSH,1,250) D ERRADD^INHUSEN3(.INERR,.MSG) Q 2
 ;
 ;is message type invalid
 I INTYP="" D  Q $$ACK(.INIP,2,.INSEND,INRONLY)
 .S MSG(1)="Unable to determine message type",MSG(2)=$E(INMSH,1,250)
 .D ERRADD^INHUSEN3(.INERR,.MSG)
 ;
 S INVL=""
 ;  If ack,destination only needed for App. ack.
 I INTYP["ACK" D TYPEACK(ING,.INVL,.INMSG)
 ;  If incoming is a msg not an ack, must determine tran. type.
 I INTYP'["ACK" D TYPNOTAK(ING,.INXDST,.INDSTP,.INDST,.INVL,.INMSG)
 Q $$ACK(.INIP,.INVL,.INSEND,INRONLY)
 ;
TYPEACK(ING,INVL,INMSG) ;Type was ack
 ;Input:
 ; ING = Variable array/global containing lines from msg.
 ;Output:
 ; INVL - True - invalid, "" no error
 ; INMSG = (OPT) Variable to return UIF of inbound msg (PBR)
 ;Local
 ; INMSGSTAT - 
 ;  AA - Application Accept or No MSA segment Accept
 ;  AE - Application Error
 ;  AR - Application Reject
 ;  CA - Commit Accept Ack
 ;  CE - Commit Error
 ;  CR - Commit Reject
 ;               
 N INMSASTA,EXPCT,INDST,INDSTP,ACKMSG
 S INVL=$$ACKIN^INHUSEN2(ING,.INMSASTA,.EXPCT,.INDST,.INDSTP,.ACKMSG,.INERR)
 ;quit if invalid
 Q:INVL
 ;If application ack and no destination
 I $E($G(INMSASTA))="A",'$G(INDSTP) D  Q
 .S MSG(1)="Ack "_MESSID_" has no destination",MSG(2)=$E(INMSH,1,250)
 .D ERRADD^INHUSEN3(.INERR,.MSG)
 .S INVL=2
 D STORE(INDST,ING,.INMSG)
 ;Update parent for commit acks
 I $E($G(INMSASTA))="C",INMSG>0 D CACKLOG(INMSG,ACKMSG,INMSASTA,.INERR)
 Q
TYPNOTAK(ING,INXDST,INDSTP,INDST,INVL,INMSG) ;Type was not an ack
 ;Input:
 ; ING = Variable array/global containing lines from msg.
 ; INXDST = eXecutable code to identify the destination
 ; INDSTP - Destination pointer
 ; INDST - Destination pointer
 ; INVL - True - invalid, "" no error
 ; INMSG = (OPT) Variable to return UIF of inbound msg (PBR)
 ;If tranceiver passed INXDST, execute it. Otherwise do DEST.
 X $S($L($G(INXDST)):INXDST,1:"D DEST")
 I '$G(INDSTP) D  Q
 .S MSG(1)="Message "_MESSID_" has no destination",MSG(2)=$E(INMSH,1,250)
 .D ERRADD^INHUSEN3(.INERR,.MSG)
 .S INVL=2
 ;pointer needed for most functions, NAME needed for NEW^INHD.
 S:'$D(INDST) INDST=$P(^INRHD(INDSTP,0),U)
 D STORE(INDST,ING,.INMSG)
 Q
ACK(INIP,INVL,INSEND,INRONLY) ;Process commit ack and quit back to transceiver routine.
 ;Input:
 ; INIP - Array of parameters from gallery
 ; INVL - True - invalid, "" no error
 ; INSEND - ien of UIF
 ; INRONLY - 1 Receive only send no ack, 0 receive then send ack
 N CND
 ;If receive only then we don't want to send ack
 Q:INRONLY +$G(INVL)
 S CND=$P(INMSH,INDELIM,15)
 ;Overide accept ack condition
 I INIP("AAC")'="" S CND=INIP("AAC")
 N STAT,CERR
 I CND'="NE" D
 .;If CND has value, msg is in enhanced HL7 mode
 .I $L(CND) D  Q
 ..I 'INVL,"SU,AL"[CND S CERR=$$CACK(.INSEND,"CA",ORIGID,.INERR,EXPCT) Q
 ..I INVL,"AL,ER"[CND S CERR=$$CACK(.INSEND,"CR",ORIGID,.INERR,EXPCT) Q
 .I INVL>1,'$L($P($G(INMSH),U,16)) S CERR=$$CACK(.INSEND,"AR",ORIGID,.INERR,EXPCT)
 Q $S($G(CERR)>INVL:CERR,1:INVL)
 ;
CACK(INSEND,STAT,ORIGID,TXT,EXPCT,DELAY,INERR,INA,INDA) ;Send accept (commit) acknowledgement
 ; STAT  = ack status (commit ack: CA, CR, CE)   MSA-1
 ; ORIGID = (REQ) MESSID of Incoming message being acknowledged    MSA-2
 ; TXT = Text message    MSA-3
 ; EXPCT = Expected sequence number    MSA-4
 ; DELAY = Delayed Ack type    MSA-5
 ; INERR = Error condition    MSA-6
 ; INA = (OPT) The INA variable array.
 ; INDA = (OPT) The INDA array of ien entry numbers.
 ;  NOTE: INDA and INA are not normally needed for commit acks, but
 ;        may be used is specialized situations.
 ;
 ; Output:
 ; INSEND = ien of accept ack in ^INTHU.
 ;
 ; Returns:
 ;  0=success, 1= non-fatal. Inability to return ack is non-fatal to msg.
 ;
 N INA,TRT,UIF,DA,DIE,DR,DIC,SCR,DEST,Z
 I '$D(ORIGID) D DISPLAY^INTSUT1("Unable to determine originating message ID") Q 1
 ;Get transaction type
 S TRT=INIP("AATT") I 'TRT D DISPLAY^INTSUT1("No Transaction Type designated for commit ack.") Q 1
 S INA("INSTAT")=STAT,INA("INORIGID")=ORIGID
 S:$D(EXPCT) INA("INEXPSEQ")=EXPCT
 S:$D(TXT) INA("INACKTXT")=$S($L($G(TXT)):TXT,$L($Q(TXT)):@$Q(TXT),1:"")
 S:$D(DELAY) INA("INDELAY")=DELAY
 ;INERR may be top level, or it may be an array. Take top if it exists.
 I $D(INERR) S INA("INACKERR")=$S($L($G(INERR)):INERR,$L($Q(INERR)):@$Q(INERR),1:"")
 ;Following code copied from ACK^INHF and modified.
 S SCR=$P(^INRHT(TRT,0),U,3),DEST=+$P(^INRHT(TRT,0),U,2)
 I $D(^INRHS(+SCR)),$D(^INRHD(+DEST)) D
 .;Set INDA array. Normally, Ack message has value of -1.
 .S INDA=$S('$D(INDA):-1,INDA="":-1,1:INDA)
 .X "S ER=$$^IS"_$E(SCR#100000+100000,2,6)_"("_TRT_",.INDA,.INA,"_DEST_","_0_")"
 ;The script leaves UIF variable after execution
 I '$D(UIF) D DISPLAY^INTSUT1("Unable to create ack message for "_ORIGID) Q 1
 ;Unless ack went on queue (unlikely), set ack status to "complete"
 I UIF>0 D ULOG^INHU(UIF,"C")
 S INSEND=$S(UIF>0:UIF,1:"")
 Q 0
CACKLOG(INCAACK,INCAORIG,INCASTAT,INCANAKM) ;Log an accept (commit) acknowledgement to a message
 ;INCAACK   (reqd) = UIF entry # of current message
 ;INCAORIG  (reqd) = ID of message to acknowledge
 ;INCASTAT  (reqd) = ack status (CA,CE or CR)
 ;INCANAKM  (opt)  = message to store if NAK
 ;
 N AMID,MESS,STAT,DIE,DR,DA
 ;Mark the accept ack complete before updating original message
 S DIE="^INTHU(",DA=INCAACK,DR=".03///C;.09////"_$$NOW^UTDT D
 .;Temporary stack to be sure variable integrety later on
 .N INCAACK,INCAORIG,INCASTAT,INCANAKM D ^DIE
 Q:'$L($G(INCAORIG))
 ;find original message
 S AMID=$O(^INTHU("C",INCAORIG,0)) Q:'AMID
 S $P(^INTHU(INCAACK,0),U,7)=AMID
 S $P(^INTHU(AMID,0),U,18)=INCAACK,STAT=$S(INCASTAT="CA":"A",1:"E")
 I STAT="A" S MESS(1)="Commit Acknowledge received with CA status"
 ;If originating message does not require application ack, upgrade
 ;successful status to C
 I STAT="A",'$P(^INTHU(AMID,0),U,4) S STAT="C"
 S DIE="^INTHU(",DA=AMID,DR=".03///"_STAT D ^DIE
 I STAT="E" S MESS(1)="Negative Commit Acknowledge received" S:$G(INCANAKM)]"" MESS(2)=INCANAKM
 S MESS(1)=MESS(1)_" in transaction with ID="_$P(^INTHU(INCAACK,0),U,5)
 D ULOG^INHU(AMID,STAT,.MESS)
 D ULOG^INHU(INCAACK,"C",.MESS)
 Q
STORE(INDST,ING,INMSG) ;Store incoming xmission in the Universal Interface file
 ;Input:
 ; INDST = string name of entry in Int. Dest. File
 ; ING = array to be stored
 ;
 ;Output:
 ; INMSG = UIF of new msg, or -1 if creation failed.
 ;
 N SOURCE,DIE,DR
 ;Create a unique INCOMING MESSAGE ID for field 2.1 of the UIF
 ;in format "ORIGID-XX-NN" where XX is 1st two letters from background
 ;process file and NN increments from 1.
 ;Set PN to piece # of the # (If ORIGID already has "-"
 ;embedded, need to place XX-NN further than pieces 2 and 3)
 S ORIGID2=ORIGID_"-TU-1" D:$D(^INTHU("C",ORIGID2))
 . N USED,PN S PN=$L(ORIGID,"-")+2
 . F USED=2:1 S $P(ORIGID2,"-",PN)=USED Q:'$D(^INTHU("C",ORIGID2))
 S SOURCE="Incoming message from transceiver the Test Utility"
 ;Create msg in UIF using modified originating messid
 S INMSG=$$NEW^INHD(ORIGID2,INDST,SOURCE,ING,0,"I",1)
 ;If the input driver returns a -1 then the transaction was rejected
 I INMSG<0 S INERR="Message "_MESSID_" was rejected by the GIS",INVL=2 Q
 ;store original message id (will also be in "D" x-ref)
 S DA=+INMSG,DIE="^INTHU(",DR="2.1///"_ORIGID D ^DIE
 Q
DEST ;Find destination for incoming message (not incoming ack?).
 ;INPUT:
 ;OUTPUT:
 ;--INDSTP - Pointer to destination file
 ;
 I '$D(^INRHD("B","TEST UTILITY DEST STUB - IN")) D DISPLAY^INTSUT1("TEST UTILITY DEST STUB - IN missing, destination not set")
 S INDSTP=$O(^INRHD("B","TEST UTILITY DEST STUB - IN",""))
 Q
