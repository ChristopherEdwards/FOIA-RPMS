INHUSEN2 ; DGH ; 10 Jul 97 17:29; More enhanced processing functions 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
ACKIN(GBL,MSASTAT,INEXPCT,INDST,INDSTP,ACKMSG,INERR) ;Returns variables for incoming acks
 ;INPUT
 ;--GBL = global being checked, can be ^INTHU
 ;--------If numeric, assumed to be IEN for ^INTHU
 ;--------If non-numeric, assumed to be global reference
 ;--MSASTAT = Status, MSA-2. (PASS BY REFERENCE)
 ;--INEXPCTP = Expected sequence #, MSA-5 (PBR)
 ;--INDST = Destination string (if application ack) (PBR)
 ;--INDSTP = Destination pointer (if application ack) (PBR)
 ;--ACKMSG = Originating message being acked (PBR)
 ;--INERR = error message array (PBR)
 ;-MESSID = message ID (is not a parameter, value set in INHUSEN)
 ;RETURN
 ;0=success 1=non-fatal error 2=fatal error
 N INMSA,LCT,X,UIF,INTT,ACKTT,I
 I GBL S LCT=1 F I=1:1:5 D  Q:$D(INMSA)
 . D GETLINE^INHOU(GBL,.LCT,.X) S:$P(X,INDELIM)="MSA" INMSA=X
 I 'GBL F I=2:1:5 D  Q:$D(INMSA)
 . S X=$G(@GBL@(I)) S:$P(X,INDELIM)="MSA" INMSA=X
 ;For following 3 errors, be sure MSASTAT, INDSTP and INDST are set so
 ;incoming ack is filed. Let output controller log error.
 I '$D(INMSA) D ERRADD^INHUSEN3(.INERR,"Ack message "_MESSID_" does not have an MSA segment") S MSASTAT="AA" D DEFAULT Q 0
 S MSASTAT=$P(INMSA,INDELIM,2),ACKMSG=$P(INMSA,INDELIM,3),INEXPCT=$P(INMSA,INDELIM,5)
 I ACKMSG="" D ERRADD^INHUSEN3(.INERR,"Ack message "_MESSID_" does not identify an orginating message"),DEFAULT Q 0
 I '$D(^INTHU("C",ACKMSG)) D ERRADD^INHUSEN3(.INERR,"Acknowledged message "_ACKMSG_" can not be found for ack "_ORIGID),DEFAULT Q 0
 ;If this is a commit ack, use generic destination (required to STORE).
 I $E(MSASTAT)="C" S INDST="INCOMING ACK" Q 0
 ;If application ack, destination must be passed in with tranceiver???
 ;If tranceiver passed INXDST, execute it. Otherwise call DEST.
 ;NOTE: For time being, APCOTS is sending AA instead of CA. Need
 ;to allow generic INDST="INCOMING ACK" to test
 ;***commented during  sir 25459
 X:$L($G(INXDST)) INXDST
 ;But don't log error (that's what the SIR was about). Instead
 ;fall through to default if there is no INDSTP
 I $L($G(INDSTP)) D  Q 0
 .;pointer needed for most functions, NAME needed for NEW^INHD.
 .S:'$L($G(INDST)) INDST=$P($G(^INRHD(INDSTP,0)),U)
 ;
 ;;;;or, should we use originating TT pointer to ack for incoming
 ;;;;as well as outgoing messages?
ALT ;If application ack, find destination based on originating message
 S UIF=$O(^INTHU("C",ACKMSG,"")),INTT=$P(^INTHU(UIF,0),U,11)
 ;If originating message does not designate an acknowledge script,
 ;use generic incoming ack.
 I 'INTT D ERRADD^INHUSEN3(.INERR,"Originating message has no Transaction Type") Q 1
 S ACKTT=$P(^INRHT(INTT,0),U,9) I 'ACKTT D DEFAULT Q 0
 S INDSTP=$P(^INRHT(ACKTT,0),U,2) I INDSTP="" D DEFAULT Q 0
 S INDST=$P($G(^INRHD(INDSTP,0)),U)
 Q 0
 ;
DEFAULT ;set default destination if incoming ack is missing needed information
 S INDST="INCOMING ACK",INDSTP=$O(^INRHD("B",INDST,""))
 Q
 ;
CACK(INDSTR,STAT,ORIGID,TXT,EXPCT,DELAY,INERR,INQUE,INA,INDA) ;Send accept (commit) acknowledgement
 ;Commit ack does not go through output processor. The pointer to the
 ;commit ack TT is in the Int. Destination File and is independent of
 ;the originating message TT.
 ;-INDSTR = (REQ) Receiver dest pointer -- $P(^INTHPC(INBPN,0),U)
 ;-ORIGID = (REQ) MESSID of Incoming message being acknowledged -- MSA-2
 ;-STAT  = ack status (commit ack: CA, CR, CE) --MSA-1
 ;-TXT = Text message -- MSA-3
 ;-EXPCT = Expected sequence number -- MSA-4
 ;-DELAY = Delayed Ack type -- MSA-5
 ;-INERR = Error condition -- MSA-6
 ;-INQUE = (OPT) If set to 1 (default) commit ack will not be queued
 ;         into ^INLHSCH. This is normal for a commit ack because
 ;         the tranceiver will usually send back to other system.
 ;         If set to 0, the ack will be entered into INLHSCH.
 ;-INDA = (OPT) The INDA array of ien entry numbers.
 ;-INA = (OPT) The INA variable array.
 ;--NOTE: INDA and INA are not normally needed for commit acks, but
 ;        may be used is specialized situations.
 ;RETURN
 ;-0=success, 1= non-fatal. Inability to return ack is non-fatal to msg.
 ;-INSEND = ien of accept ack in ^INTHU.
 N INA,TRT,UIF,DA,DIE,DR,DIC,SCR,DEST,Z,INTNAME
 I '$D(ORIGID) D ENR^INHE(INBPN,"Unable to determine originating message ID") Q 1
 I '$D(^INRHD(INDSTR)) D ENR^INHE(INBPN,"Invalid destination in message "_ORIGID) Q 1
 S TRT=$P(^INRHD(INDSTR,0),U,10) I 'TRT D ENR^INHE(INBPN,"No Transaction Type designated for commit ack for destination "_$P(^INRHD(INDSTR,0),U)) Q 1
 S INA("INSTAT")=STAT,INA("INORIGID")=ORIGID
 S:$D(EXPCT) INA("INEXPSEQ")=EXPCT
 S:$D(TXT) INA("INACKTXT")=$S($L($G(TXT)):TXT,$L($Q(TXT)):@$Q(TXT),1:"")
 S:$D(DELAY) INA("INDELAY")=DELAY
 ;INERR may be top level, or it may be an array. Take top if it exists.
 I $D(INERR) S INA("INACKERR")=$S($L($G(INERR)):INERR,$L($Q(INERR)):@$Q(INERR),1:"")
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
 .S Z="S ER=$$^IS"_$E(SCR#100000+100000,2,6)_"("_TRT_",.INDA,.INA,"_DEST_","_INQUE_")"
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
CACKLOG(INCAACK,INCAORIG,INCASTAT,INCANAKM) ;Log an accept (commit) acknowledgement to a message
 ;Modified version of ACKLOG^INHU. Will store status in originating
 ;message of "A"=Accept ack received or "E"=Error
 ;INCAACK   (reqd) = UIF entry # of current message
 ;INCAORIG  (reqd) = ID of message to acknowledge
 ;INCASTAT  (reqd) = ack status (CA,CE or CR)
 ;INCANAKM  (opt)  = message to store if NAK
 ;
 Q:'$D(^INTHU(+$G(INCAACK)))
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
 ;D ULOG^INHU(INCAACK,"C",.MESS)
 Q
 ;
 ;
 ;
 ;
