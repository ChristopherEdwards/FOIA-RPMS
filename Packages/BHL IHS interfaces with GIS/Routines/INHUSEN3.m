INHUSEN3 ;DGH ; 26 Jun 96 14:33;More enhanced functions 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
ACK(%TT,%S,INUIF,INHERR,INA,INDA,INQUE,ACKUIF) ;Create application ack
 ;Modified version of ACK^INHOS.
 ; Variables
 ;  %TT = (REQ) Transaction Type entry # of incoming message
 ; %S  = (0 = NAK, 1 = ACK) for backward compatibility
 ;  %S is optional if INA("INSTAT") is set in INA array
 ; INUIF = (REQ) Incoming message being acknowledged
 ; INHERR = (PBR) Used to pass in an error message which
 ;  will be part of the MSA segment.
 ;  It is reset as the ack script is run to return
 ;  the success/failure of the script.
 ; INA = (PBR) Variable array to pass into script
 ; INDA = (PBR) Array to pass into script. If the inbound script
 ;  triggers an acknowledge message that extracts
 ;  data (ie inbound is a query, ack is a patreg)
 ;  INDA or an INDA array is used by the outbound script.
 ;  If INDA is null, a -1 is passed into the ack script.
 ; INQUE = If set to 1, will pass parameter into script
 ;  signalling that ack is not to be queued into
 ;  output controller, INLHSCH
 ; ACKUIF = (PBR) If INQUE=1 and calling transceiver routine will
 ;  be sending ack, ACKUIF is the UIF of the created ack.
 N TRT,X,CND,UIF,DA,DIE,DR,DIC,SCR,DEST,Z,CREATE
 Q:'$G(%TT)
 ;CND is the conditions under which application ack is generated.
 ;It will be MSH-16, unless over-ride exists in ^INRHT, piece 18
 S CND=$P($G(^INRHT(%TT,0)),U,18)
 I '$L(CND) Q:$$APPACK^INHUSEN3(INUIF,.CND,.INERR)
 ;No need to ack if MSH INDICATES NEVER
 Q:CND="NE"
 ;Quit if no ack TRT is specified in the incoming TT
 Q:'$D(^INRHT(%TT))  S TRT=$P(^INRHT(%TT,0),U,9) Q:'TRT
 ;If calling routine has set status in INA array, it will override
 ;the following.
 I '$D(INA("INSTAT")) D
 .S %S=+$G(%S)
 .I %S S INA("INSTAT")="AA" Q
 .S INA("INSTAT")="AE"
 ;Determine if ack is needed based on condition
 S CREATE=0 D
 .;If CND is null, assume original ack rules. As long as the TRT pointer
 .;was found above, create an ack. Also create ack if condition=AL
 .I CND=""!(CND="AL") S CREATE=1 Q
 .;Otherwise use enhanced processing rules and examine CND
 .;If stat is successful, and condition is SU or AL, create an ack
 .;If stat is unsuccessful, and condition is AL or ER, create an ACK
 .S CREATE=$S($E(INA("INSTAT"),2)="A"&(CND="SU"):1,("R,E"[$E(INA("INSTAT"),2)!'%S)&(CND="ER"):1,1:0)
 Q:'CREATE
 ;If origid is passed in, don't go to disk to look it up
 S:'$D(INA("INORIGID")) INA("INORIGID")=$P($G(^INTHU(INUIF,2)),U)
 ;Set ack error message, then kill error message for later reset
 I $D(INHERR),'$D(INA("INACKERR")) S INA("INACKERR")=$E(INHERR,1,100) K INHERR
 S SCR=$P(^INRHT(TRT,0),U,3),DEST=+$P(^INRHT(TRT,0),U,2),INTNAME=$P(^INRHT(TRT,0),U)
 S:'$L($G(INDA)) INDA=-1
 Q:'SCR!'DEST  Q:'$D(^INRHS(SCR))!'$D(^INRHD(DEST))
 ;Start transaction audit
 D:$D(XUAUDIT) TTSTRT^XUSAUD(INTNAME,"",$P($G(^INTHPC(INBPN,0)),U),$G(INHSRVR),"SCRIPT")
 S Z="S X=$$^IS"_$E(SCR#100000+100000,2,6)_"("_TRT_",.INDA,.INA,"_DEST_","_+$G(INQUE)_")"
 X Z S ACKUIF=$S($G(UIF)>0:UIF,1:"")
 ;Stop transaction audit
 D:$D(XUAUDIT) TTSTP^XUSAUD(0)
 D:ACKUIF
 .;Set pointer in original message to the app ack
 .S $P(^INTHU(ACKUIF,0),U,7)=INUIF
 .;Set pointer in ack to original message
 .S $P(^INTHU(INUIF,0),U,6)=ACKUIF
 .;If ack did not go on queue, set ack status to "complete"
 .D:$G(INQUE) ULOG^INHU(ACKUIF,"C")
 Q
 ;
APPACK(GBL,APPL,INERR) ;Returns type of application acknowledgment required
 ;INPUT
 ;--GBL = global being checked, usually will be ^INTHU
 ;--------If numeric, assumed to be IEN for ^INTHU
 ;--------If non-numeric, assumed to be global reference
 ;--APPL = variable to contain type
 ;--INERR=Variable to contain error array
 ;RETURN
 ;0=success 2=fatal error
 N LCT,MSH
 I +GBL S LCT=0 D GETLINE^INHOU(GBL,.LCT,.MSH)
 I 'GBL S MSH=$G(@GBL@(1))
 I $G(MSH)'["MSH" D ERRADD^INHUSEN3(.INERR,"Message does not have the MSH segment in the correct location") Q 2
 S INDELIM=$E(MSH,4)
 S APPL=$P(MSH,INDELIM,16)
 Q 0
 ;
DSTQUE(INUIF,INERR) ;Builds queues by destination
 ;This function is called from any output controller routine
 ;to build queus by destination. Messages will be "moved" from
 ;^INLHSCH(prior,time,uif) to ^INLHSCH("BP",dest,sequence,prior,time,uif)
 ;It is a generic version of INHVTSQ
 ;INPUT:
 ;  INUIF - ien in Universal Interface file
 ;OUTPUT:
 ;  INERR - array containing any error messages
 ;  function value - success or failure
 ;        [  0 - success ;  1 - failure ]
 ;
 N H,P,D,Z,SEQ
 S Z=$G(^INTHU(+$G(INUIF),0))
 I '$L(Z) S INERR="Nonexistent Message "_INUIF Q 1
 ;Get message priority
 S P=+$P(Z,U,16)
 ;Get time to process - NOW
 S H=$H,$P(H,",",2)=$E(100000+$P(H,",",2),2,6)
 ;Get destination
 S D=+$P(Z,U,2) I 'D S INERR="No destination for message "_INUIF Q 1
 ;Get sequence number (default=0)
 S SEQ=+$P(Z,U,17)
 ;L +^INLHDEST(D):5
 ;E  S INERR="Unable to lock message queue ^INLHDEST("_$P(^INRHD(D,0),U)_") " Q 1
 S ^INLHDEST(D,P,H,INUIF)=""
 ;L -^INLHDEST(D)
 Q 0
 ;
ERRADD(INERR,INMSG) ;Build/concatenate error messages to error array
 ;INPUT:
 ;--INERR=The existing error array (Pass by ref)
 ;--INMSG=The line or lines of errors to be added to the array (PBR)
 ;
 Q:'$D(INMSG)
 N ERRNO,MSGNO,I
 S ERRNO=$O(INERR(""),-1)+1
 ;If new message is contained in top level
 I $L($G(INMSG)) S INERR(ERRNO)=INMSG,ERRNO=ERRNO+1
 ;Pick up all subscripted messages, if any
 S MSGNO="" F  S MSGNO=$O(INMSG(MSGNO)) Q:'MSGNO  D
 .S:$L(INMSG(MSGNO)) INERR(ERRNO)=INMSG(MSGNO),ERRNO=ERRNO+1
 ;kill additional lines before exiting, only return "real" array.
 K INMSG
 Q
 ;
