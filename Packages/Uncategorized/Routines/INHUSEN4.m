INHUSEN4 ; DGH ; 9 Jun 97 17:52; Enhanced processing functions and utilities 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
STORE ;Store incoming xmission in the Universal Interface file
 ;INPUT:
 ;-INLHSCH = (OPT) 0 will queue entry, = 1 won't
 ;---Appl acks will go in queue. O/P CTLR will update
 ;---status of originating msg as processing by queue.
 ;---Commit acks won't go in queue. CACKLOG^INHUSEN2 will update status.
 ;---Msgs will go in queue.
 ;-INDST = string name of entry in Int. Dest. File
 ;-ING = array to be stored
 ;-INMSASTA = MSA-1 - Ack Status
 ;OUTPUT:
 ;-INMSG = UIF of new msg, or -1 if creation failed.
 N SOURCE,DIE,DR
 S INLHSCH=$S($L($G(INLHSCH)):INLHSCH,INTYP["ACK"&($E($G(INMSASTA))="C"):1,1:0)
 ;Create a unique INCOMING MESSAGE ID for field 2.1 of the UIF
 ;in format "ORIGID-XX-NN" where XX is 1st two letters from background
 ;process file and NN increments from 1.
 ;Set PN to piece # of the # (If ORIGID already has "-"
 ;embedded, need to place XX-NN further than pieces 2 and 3)
 S ORIGID2=ORIGID_"-"_$E(^INTHPC(INBPN,0),1,2)_"-1" D:$D(^INTHU("C",ORIGID2))
 . N USED,PN S PN=$L(ORIGID,"-")+2
 . F USED=2:1 S $P(ORIGID2,"-",PN)=USED Q:'$D(^INTHU("C",ORIGID2))
 S SOURCE=$E("Incoming message from transceiver "_$P(^INTHPC(INBPN,0),U),1,60)
 ;Create msg in UIF using modified originating messid
 S INMSG=$$NEW^INHD(ORIGID2,INDST,SOURCE,ING,0,"I",1)
 ;If the input driver returns a -1 then the transaction was rejected
 I INMSG<0 S INERR="Message "_MESSID_" was rejected by the GIS",INVL=2 Q
 ;store original message id (will also be in "D" x-ref)
 S DA=+INMSG,DIE="^INTHU(",DR="2.1///"_ORIGID_";2.02///`"_INDSTR D ^DIE
 ; Determine if msg should be queued
 I 'INLHSCH D  ; if request to queue msg
 . I INTYP'["ACK",$$SUPPRESS^INHUT6("RCV",$P(^INRHD(INDSTP,0),U,2),$P($G(^INTHPC(INBPN,0)),U,7),INBPN,"","",INMSG,INMSH) Q  ; suppress inbound msg
 . ; que msg to o/p ctlr
 . S DA=+INMSG,DIE="^INTHU(",DR=".2///0" D ^DIE  ; update que flag
 . N DEST,TIME,TT S DEST=INDSTP D TIME^INHD,SET^INHD(TIME,DEST,INMSG)
 Q
 ;
VERIF(INGBL,INMSH,INTYP,INEVN,INERR) ;Determine HL7 message type and event
 ;INPUT
 ;--INGBL = global being checked, can be ^INTHU
 ;--------If numeric, assumed to be IEN for ^INTHU
 ;--------If non-numeric, assumed to be global reference
 ;--INMSH = variable for MSH segment (Pass by reference)
 ;--INTYP = Message type in format (PBR)
 ;--INEVN = Trigger event (PBR)
 ;--INERR = error message array (PBR)
 ;RETURN
 ;0=success 1=failure  2=fatal error
 N LCT,EVN,TYPE
 I +INGBL S LCT=0 D GETLINE^INHOU(INGBL,.LCT,.INMSH)
 I 'INGBL S INMSH=$G(@INGBL@(1))
 I $E(INMSH,1,3)'="MSH" S MSG(1)="Message from receiver "_$P(^INTHPC(INBPN,0),U)_" does not have the MSH segment in the correct location",MSG(2)=$E(INMSH,1,250) D ERRADD^INHUSEN3(.INERR,.MSG) Q 2
 S INDELIM=$E(INMSH,4),INSUBDEL=$E(INMSH,5)
 D
 . ;First get message type from MSH-9. Trigger Event may be
 . ;second component of type.
 . S TYPE=$P(INMSH,INDELIM,9) S INEVN=$P(TYPE,INSUBDEL,2),INTYP=$P(TYPE,INSUBDEL) Q:$L(INEVN)
 . ;If no EVENT, check for EVN segment in next 5 lines
 . I INGBL F I=1:1:5 D  Q:$L(INEVN)
 .. D GETLINE^INHOU(INGBL,.LCT,.EVN)
 .. S:$P(EVN,INDELIM)="EVN" INEVN=$P(EVN,INDELIM,2)
 . I 'INGBL F I=2:1:5 D  Q:$L(INEVN)
 .. S EVN=$G(@INGBL@(I))
 .. S:$P(EVN,INDELIM)="EVN" INEVN=$P(EVN,INDELIM,2)
 Q 0
 ;
DEST ;Find destination for incoming message (not incoming ack?).
 ;INPUT:
 ;--INDEST(INTYP_INEVN)=INDST is array of destinations where INDST
 ;--is a string value of a valid entry in Int. Dest. File
 ;--INTYP can be 3-character of 6-character
 ;--INEVN will be treated as null if '$D(INEVN)
 ;OUTPUT:
 ;--INDSTR = pointer equilivant of INDST
 ;
 S:'$D(INEVN) INEVN=""
 I '$D(INDEST) S MSG(1)="No known destination in message "_MESSID,MSG(2)=$E($G(INMSH),1,250),INVL=2 D ERRADD^INHUSEN3(.INERR,.MSG) Q
 I '$D(INDEST(INTYP_INEVN)) S MSG(1)="No known destination for event type "_INTYP_" in message "_MESSID,MSG(2)=$E($G(INMSH),1,250),INVL=2 D ERRADD^INHUSEN3(.INERR,.MSG) Q
 S INDST=INDEST(INTYP_INEVN)
 I '$D(^INRHD("B",INDST)) D ERRADD^INHUSEN3(.INERR,"No entry in Destination file for "_INDST_" in message "_MESSID) S INVL=2 Q
 S INDSTP=$O(^INRHD("B",INDST,""))
 Q
 ;
