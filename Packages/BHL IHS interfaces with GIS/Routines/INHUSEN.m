INHUSEN ; DGH ; 05 Nov 1999 12:57 ; Enhanced processing functions and utilities 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;CHCS TOOLS_460; GEN 5; 21-MAY-1997
 ;COPYRIGHT 1994 SAIC
 ;
IN(ING,INDEST,INDSTR,INUSEQ,INSEND,INERR,INXDST,INMSG,INLHSCH,INMSASTA,INNOACK,INSTD) ;Process incoming
 ;--1) Verify all needed data is present
 ;--2) Store xmission (if verified but not if it is for housekeeping)
 ;--3) Determines if seq. # protocol is in effect, and processes
 ;--4) Create receipt ack as specified in MSH.
 ;INPUT:
 ;--ING = (REQ) Variable array/global containing lines from msg.
 ;--INDEST = Array of valid destinations in format
 ;           INDEST(type) =  .01 field of Tran Type.  This is not
 ;           required if processing incoming ACKS, but will generate
 ;           an error if processing incoming msg with no destination.
 ;--INDSTR = (REQ) Receiver dest. pointer -- $P(^INTHPC(INBPN,0),U,7)
 ;--INUSEQ = (OPT) Use seq. # protocol? 0=no (default) 1=yes
 ;--INSEND = (OPT) Variable which will contain the UIF entry(ies) of
 ;---msg which needs to be sent by tranceiver back to other system.
 ;---This may be an accept ack, or it may be a msg which must be
 ;---resent under sequence number protocol. (Pass By Reference)
 ;--INERR = (OPT) Variable to return error msg. (PBR)
 ;--INXDST = (OPT) EXecutable code to identify the destination for
 ;---msgs which won't be uniquely identified by INTYP_INEVN.
 ;---The executable must return the ien in the variable INDSTP.
 ;--INMSG = (OPT) Variable to return UIF of inbound msg (PBR)
 ;--INLHSCH = (OPT) Set to 1 if the incoming msg should not
 ;            be placed on the output controller queue, ^INLHSCH.
 ;            If not specified, this routine will determine the
 ;            conditions under which a msg is queued.
 ;--INBPN = background process internal number. (Will be set in recvr)
 ;--INMSASTA = (OPT) Variable to return MSA-1 ack status (PBR)
 ;--INNOACK = (OPT) =1 to uppress commit ack. Used for transmitters,
 ;            which should not create a commit ack to a commit ack.
 ;--INSTD = (OPT) Namespace/interface standard. Values such as
 ;          NC (NCPDP) or X1 (X12) will branch to appropriate logic.
 ;RETURN:
 ;0 = success, 1 = non-fatal error, 2 = fatal error
 N ORIGID,ORIGID2,MESSID,INVL,CND,SEQ,STAT,EXPCT,INDST,INDSTP,INMSH,INTYP,INEVN,LOOP,Z,ACKMSG,MSG
 ;Note: INDST and INDSTP are variables for the Dest. file for the
 ;incoming msg. This may differ from the destination of the
 ;background process.
 ;--Branch to support MEDE America implementation of NCPDP
 I $G(INSTD)="PDTS" S ERR=$$INNC^INHUSEN5(ING,.INUSEQ,.INXDST,.INERR) Q ERR
 ;--Identify interface standard
 S INSTD=$$GETSTD(ING)
 ;---X12 branch
 I $G(INSTD)="X12" S ERR=$$X12IN^INHUSEN6(ING,.INDEST,INDSTR,.INSEND,.INERR,.INXDST,.INMSG,$G(INLHSCH),.INMSASTA,$G(INNOACK)) Q ERR
 ;INUSEQ and INSTD not carred forward from IN
 ;---
 S (EXPCT,INSEND)="" S:'$D(INUSEQ) INUSEQ=0
 ;First verify MSH, get msg type and event type. If invalid, quit
 S INVL=$$VERIF(ING,.INMSH,.INTYP,.INEVN,.INERR) I INVL Q 2
 ;Determine accept acknowledge conditions
 S CND=$P(INMSH,INDELIM,15)
 S (MESSID,ORIGID)=$P(INMSH,INDELIM,10) I MESSID="" S MSG(1)="Message does not have a message ID",MSG(2)=$E(INMSH,1,250) D ERRADD^INHUSEN3(.INERR,.MSG) Q 2
 I INTYP="" S INVL=2,MSG(1)="Unable to determine message type",MSG(2)=$E(INMSH,1,250) D ERRADD^INHUSEN3(.INERR,.MSG) G ACK
 ;If ack, get status (and other data as needed based on MSA).
 ;If application ack, will store and determine if commit ack is needed.
 I INTYP["ACK" D  I $E($G(INMSASTA))="A"!INVL G ACK
 . S INVL=$$ACKIN^INHUSEN2(ING,.INMSASTA,.EXPCT,.INDST,.INDSTP,.ACKMSG,.INERR) Q:INVL
 . ;destination only needed for App. ack.
 . Q:$E($G(INMSASTA))="C"
 . I '$G(INDSTP) S MSG(1)="Ack "_MESSID_" has no destination",MSG(2)=$E(INMSH,1,250),INVL=2 D ERRADD^INHUSEN3(.INERR,.MSG) Q
 . S STAT=0 D STORE
 ;--If incoming is a msg not an ack, must determine tran. type.
 I INTYP'["ACK" D  G:INVL ACK
 .;If tranceiver passed INXDST, execute it. Otherwise do DEST.
 .S Z=$S($L($G(INXDST)):INXDST,1:"D DEST") X Z
 .I '$D(INDSTP) S INVL=2,MSG(1)="Message "_MESSID_" has no destination",MSG(2)=$E(INMSH,1,250) D ERRADD^INHUSEN3(.INERR,.MSG) Q
 .;pointer needed for most functions, NAME needed for NEW^INHD.
 .S:'$D(INDST) INDST=$P(^INRHD(INDSTP,0),U)
 ;
 ;--Handle sequence number protocol if applicable. Will not store
 ;--msg if link is out of synch or if msg is for re-synch only.
 I INUSEQ D  G:INVL ACK
 .;If commit ack (application ack won't get this far in routine)
 .I INTYP["ACK" S INVL=$$ACKINSEQ^INHUSEQ(INMSASTA,INDSTR,EXPCT,.INSEND,.INERR) Q
 .;If msg, verify sequence number
 .S SEQ=$P(INMSH,INDELIM,13)
 .S INVL=$$SEQIN^INHUSEQ(INDSTR,.SEQ,.STAT,.INERR,.EXPCT)
 .;If invalid, must return ack no matter what CND
 .S:INVL CND="ER"
 ;
 ;Store msg
 D STORE
 ;If inbound is an application ack, see if commit ack needed
 I INTYP["ACK",$E(INMSASTA)["A" G ACK
 ;Update parent for commit acks
 I INTYP["ACK",INMSG>0 D CACKLOG^INHUSEN2(INMSG,ACKMSG,INMSASTA,.INERR)
 ;Under sequence number protocol, update LAST RECEIVED, but only after
 ;msg is successfully filed
 I INUSEQ N LTRY S LOOP=0 F LTRY=1:1:5 D  Q:LOOP
 .L +^INRHD(INDSTR,3):3
 .I $T S:'$D(^INRHB("RUN",INBPN)) LOOP=1 Q
 .S $P(^INRHD(INDSTR,3),U)=SEQ,LOOP=1 L -^INRHD(INDSTR,3)
 .I '$T D ERRADD^INHUSEN3(.INERR,"Lock failed on ^INRHD("_INDSTR_" for message "_MESSID) Q 2
 ;Flow through to tag ACK. Routine may also jump to ACK from above.
ACK ;Process commit ack and quit back to transceiver routine.
 ;CND originally set from MSH.
 D
 .;INNOACK parameter over-rides all others.
 .I $G(INNOACK) S CND="NE" Q
 .;Interface Destination File may have over-ride value.
 .S:$L($P(^INRHD(INDSTR,0),U,11)) CND=$P(^INRHD(INDSTR,0),U,11)
 ;Stop Transaction Type Audit
 D:$D(XUAUDIT) TTSTP^XUSAUD("",$G(INMSG))
 N STAT,CERR D
 . Q:CND="NE"
 . ;If CND has value, msg is in enhanced HL7 mode
 . I $L(CND) D  Q
 .. I 'INVL,"SU,AL"[CND S CERR=$$CACK^INHUSEN2(INDSTR,"CA",ORIGID,.INERR,EXPCT) Q
 .. I INVL,"AL,ER"[CND S CERR=$$CACK^INHUSEN2(INDSTR,"CR",ORIGID,.INERR,EXPCT) Q
 . ;CND will be null if msg is in original mode.
 . ;If msg can't be filed, let CACK function create reject ack.
 . ;(Transceiver routine will have to send the commit type ack)
 . ;If msg was filed, do nothing. Application will ack.
 . I INVL>1,'$L($P($G(INMSH),U,16)) S CERR=$$CACK^INHUSEN2(INDSTR,"AR",ORIGID,.INERR,EXPCT)
 Q $S($G(CERR)>INVL:CERR,1:INVL)
 ;
STORE ;Store incoming xmission in the Universal Interface file
 ;IHS needs DT
 D SETDT^UTDT
 D STORE^INHUSEN4
 Q
 ;
VERIF(INGBL,INMSH,INTYP,INEVN,INERR) ;Determine HL7 message type and event
 Q $$VERIF^INHUSEN4(INGBL,.INMSH,.INTYP,.INEVN,.INERR)
 ;
DEST ;Find destination for incoming message (not incoming ack?).
 D DEST^INHUSEN4
 Q
 ;
GETSTD(INGBL) ;Identify the standard of the incoming message.
 ;This function looks at the first part of the first segment of
 ;the incoming message to distinguish between X12 and HL7 messages.
 ;INPUT
 ; INGBL passed from receiver
 ;RETURN
 ; Interface Standard such as X12 or HL7
 ; -1 if standard is unknown or first segment is unrecognizable.
 N LINE,LCT
 I +INGBL S LCT=0 D GETLINE^INHOU(INGBL,.LCT,.LINE)
 I 'INGBL S LINE=$G(@INGBL@(1))
 I $E(LINE,1,3)="MSH" Q "HL7"
 I $E(LINE,1,3)="ISA" Q "X12"
 ;If none of the above, error
 S MSG(1)="Message from receiver "_$P(^INTHPC(INBPN,0),U)_" does not have a known header segment",MSG(2)=$E(LINE,1,250) D ERRADD^INHUSEN3(.INERR,.MSG)
 Q -1
 ;
