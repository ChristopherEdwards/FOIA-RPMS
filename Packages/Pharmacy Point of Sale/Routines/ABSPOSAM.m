ABSPOSAM ; IHS/FCS/DRS - JWS ;      [ 06/10/2002  7:19 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**2**;JUN 21, 2001
 ;
 ;  ABSPOSAM is the main program for send/receive communications
 ;  with the Envoy or NDC switches.  Or certain insurance company
 ;  systems, such as the PCS test system.
 ;
 ;  Sets up these variables:
 ;     ABSPECT2 = count of successful xmit/recv transactions
 ;            (without regard to rejected claims, merely that the
 ;             xmit/recv sequence completed with apparent success)
 ;
 ;  Subroutines are in ABSPOSAN, ABSPOSAO, ABSPOSAP, ABSPOSAQ
 ;
 ; Future:  List of claims to be sent is handled by an index in
 ; file 9002313.02; list of responses to be processed is handled by
 ; an index in file 9002313.03.  Make sure Fileman Database Server
 ; calls really do handle the locking you need.
 ;
 ; IHS/SD/lwj  06/10/02  change made to the S12 subroutine - checking
 ; of the value in IO changed from a numeric assumption to an
 ; alpha/numeric check.  This was done as a result of the Cache changes.
 ; For Cache, the device is now an alpha/numeric value as opposed to the
 ; numerice value (56) used in MSM.
 ;
 ;
 Q
SEND(DIALOUT) ;EP - from ABSPOSQ3
 S ABSPECT2=0
 ;
 N CLAIMNXT,I,RESPLRC,RESPMSG
 N HMSG,LRCOK,SENDMSG,SENDMSGP,GETMSG,CLAIMIEN,LRC,RET
 N TRANSBEG,TRANSEND,TRANSTIM ; transaction begin,end,time
 N SEG S SEG=245 ; length of string segments storing long string in gbl
 ;
 N ACK,ENQ,EOT,ETX,NAK,STX,ETB
 S ACK=$C(6),ENQ=$C(5),EOT=$C(4),ETX=$C(3)
 S NAK=$C(21),STX=$C(2),ETB=$C(23)
 ;
S12 ; 
 ;IHS/SD/lwj  06/10/02  nxt line remarkd out- following line added
 ; this change was done as a result of the Cache changes - IO will no
 ; longer just be a number (56) - for Cache, it will be a "|TCP|"
 ; coupled with the port number
 ;
 ;N IO S IO=$$IO^ABSPOSA(DIALOUT) I 'IO G S12:$$IMPOSS^ABSPOSUE("DB","TRI","IO field missing in DIALOUT="_DIALOUT,,"S12",$T(+0))
 N IO S IO=$$IO^ABSPOSA(DIALOUT) I IO="" G S12:$$IMPOSS^ABSPOSUE("DB","TRI","IO field missing in DIALOUT="_DIALOUT,,"S12",$T(+0))
 ; IHS/SD/lwj 06/10/02 - end of Cache changes
 ;
 N T1LINE S T1LINE=$$T1DIRECT^ABSPOSA(DIALOUT)
 ;
 I $$SHUTDOWN Q 0
 I '$$GETNEXT^ABSPOSAP Q 0
 ; Dial the phone and connect to Envoy
 S RET=$$CONNECT^ABSPOSAQ(DIALOUT)
 I RET D PUTBACK^ABSPOSAP Q RET ; error? put back claim before quitting
 ;
START ;Main message loop ; we have SENDMSG and SENDMSGP and CLAIMIEN
 ; If anything goes wrong, be sure to DO PUTBACK before quitting!
 ;
 D CLAIMBEG ; write to our own log file - beginning for this claim
 D SETCOMMS^ABSPOSU(CLAIMIEN,$$GETPLACE^ABSPOSL) ; mark start in .59
 ;
LOOP0 ; Wait for host to send ENQ
 ;
 I 'T1LINE D  I RET Q RET
 . S RET=$$INITIATE^ABSPOSAO I RET D  ; wait for host to send ENQ
 . . D PUTBACK^ABSPOSAP,CLAIMEND ; and if you didn't get it...
 ;
 ;Send message to host:   STX, message, ETX, LRC
 ;
 D SETCSTAT^ABSPOSU(CLAIMIEN,60) ; set prescrs' status = "Transmitting"
LOOP1A D LOG("2 - Sending message #"_CLAIMIEN)
 ; NDC and test mode, "HN." instead of "HN*" ?  Ancient code.
 ; I don't know if it makes a shred of difference
 I $E(SENDMSG,1,3)="HN." D
 . D LOG("2 - Sending message in TEST mode")
 S TRANSBEG=$P($H,",",2) ; beginning time (for timing transaction)
 D SENDREQ^ABSPOSAS(DIALOUT,.SENDMSG)
 D  ; stats - figure out which piece the transaction code increments
 .N % S %=$P($G(^ABSPC(CLAIMIEN,100)),U,3)
 .S %=$S(%>0&(%<5):%,%=11:5,1:19)
 .D ADDSTAT^ABSPOSUD("C",2,1,"C",3,$L(SENDMSG)+3,"C",%,1)
 ;
 ;Wait for response from host
 ; Envoy sends an ACK at this point.
 ; Apparently NDC does not?  Or maybe NDC sends ACK then STX
 ; Also: make the timeout 60 seconds.  "The Envoy host typically allows 
 ; an end processor up to 55 seconds to respond."
 ;
LOOP1B I T1LINE S HMSG="ACK" G LOOP1C
 D LOG("2 - Waiting for ACK or NAK")
 S HMSG=$$WAITCHAR(ACK_NAK_STX_ENQ,60)
 I HMSG="ACK" D
 . ; we got what we expected; do nothing else here
 E  I HMSG="STX" D
 . D LOG("2 - Missing ACK but got STX; must be start of response?")
 E  I HMSG="NAK" D  G LOOP1A
 . D LOG("2 - Host sent NAK - we will resend")
 E  I HMSG="ENQ" D  G LOOP1A ; Envoy 4.1, p. 12
 . D LOG("2 - Host sent another ENQ - we will resend")
 E  D  Q RET
 . D LOG("2 - But received "_HMSG_" instead.")
 . D PUTBACK^ABSPOSAP,CLAIMEND ; put message back for later transmission
 . I HMSG'="+++" D HANGUP
 . S RET=$S(HMSG="+++":31101,HMSG="":31102,1:31103)
 ;
 ; The response message is preceded by STX
 ; If we just got an ACK, then wait for the STX
 ;
LOOP1C I HMSG="ACK" D
 . I T1LINE S HMSG="STX" Q
 . S HMSG=$$WAITCHAR(STX,60)
 . D LOG("2 - "_HMSG_" received from host")
 E  I HMSG="STX" D
 . ; do nothing; fall through with STX still here
 E  D  Q 30239
 . D LOG("Internal error at LOOP1C")
 ;
 I HMSG="STX" D
 . ; nothing, got what we expected
 E  D  Q RET
 . D LOG("2 - Expected STX but got "_HMSG_" instead")
 . D PUTBACK^ABSPOSAP,CLAIMEND
 . S RET=$S(HMSG="+++":30251,HMSG="":30252,1:30253)
 ;I HMSG'="STX" D INCSTAT^ABSPOSUD("CR",$S(HMSG="ENQ":2,HMSG="NAK":3,HMSG="+++":4,HMSG="":5,1:9))
 ;
 ;   The host sends us the response message
 ;
LOOP3 S (GETMSG,LRC)=""
 D SETCSTAT^ABSPOSU(CLAIMIEN,70) ; status = "Receiving response"
 D LOG("3 - Gathering response from host")
 S HMSG=$$GETMSG^ABSPOSAR(DIALOUT,.RESPMSG,.RESPLRC,60)
 ;
 ;         HMSG="ETX" or "EOT" or "" (if timed out)
 ;
 I HMSG="ETX" D
 . D LOG("3 - Received "_$L(RESPMSG)_" bytes; LRC "_$A(RESPLRC))
 . D ADDSTAT^ABSPOSUD("C",4,1,"C",5,$L(RESPMSG)+3)
 E  D  Q RET
 . D INCSTAT^ABSPOSUD("CR2",1,"CR2",$S(HMSG="EOT":2,HMSG="":3,HMSG="+++":4,1:9))
 . D LOG("3 - Error while gathering response: HMSG="_HMSG)
 . D PUTBACK^ABSPOSAP
 . D CLAIMEND
 . I HMSG'="+++" D HANGUP
 . S RET=$S(HMSG="+++":30261,HMSG="":30262,1:30263)
 ;
 ; Test LRC character.  If we agree, we send ACK.  If not, we NAK.
 ; And if we send ACK, get the next message to send, if any.
 ;
 I T1LINE S LRCOK=1 ; G PASTLRC ; if  T1 connection, LRC is n/a
 E  I $L(RESPMSG)<9 S LRCOK=0 ; we have seen 1-byte response msg!
 E  S LRCOK=$$TESTLRC^ABSPOSAD(RESPMSG,RESPLRC)
 ;
 S CLAIMNXT=0 ; assume no claims to send after this one
 I LRCOK D
 . N CLAIMIEN ; protect CLAIMIEN - $$GETNEXT will reset it
 . I '$$SHUTDOWN S CLAIMNXT=$$GETNEXT^ABSPOSAP ; remember next CLAIMIEN
 . I CLAIMNXT,$P($G(^ABSP(9002313.55,DIALOUT,"PROTOCOL")),U) D
 . . Q:T1LINE
 . . D LOG("6 - Send ETB to host")
 . . D SENDETB^ABSPOSAS(DIALOUT)
 . E  D
 . . Q:T1LINE
 . . D LOG("6 - Send ACK to host")
 . . D SENDACK^ABSPOSAS(DIALOUT)
 . S ABSPECT2=ABSPECT2+1 ; count our successes (and blessings)
 . ;
 . ; ABSPOSQ3 will start up processing of responses 
 . ; But here, if we have heavy volume, we need to get it going
 . ; right now, every so often.
 . ;
 . I ABSPECT2>10,ABSPECT2#5=0 D TASK^ABSPOSQ3()
 E  D
 . D LOG("6 - Send NAK to host because of LRC disagreement")
 . D SENDNAK^ABSPOSAS(DIALOUT)
 ;
PASTLRC ;
 S TRANSEND=$P($H,",",2) ; timing - when transaction completed
 S TRANSTIM=TRANSEND-TRANSBEG S:TRANSTIM<0 TRANSTIM=TRANSTIM+86400
 ; Statistics:  Comms - Transaction Time Comms
 ;              Comms - Send ACK      Comms - Send NAK
 D ADDSTAT^ABSPOSUD("CT",1,TRANSTIM,"C",7+'LRCOK,1)
 ;
 I 'LRCOK D  G LOOP1C
 . S HMSG="ACK" ; fake it out so it drops into the WAITCHAR(STX) code
 ;
 D CLAIMEND
 ;
 ;  At this happy point, we have received a response and ACK'ed it.
 ;  NOTE!! SENDMSG is the _next_ message to send, not the one just sent!
 ;
 ;File response message in temporary global
 ;
LR L +^ABSPECX("POS",DIALOUT,"R",CLAIMIEN):300 ; lock the response
 I '$T G LR:$$IMPOSS^ABSPOSUE("L","RIT","LOCK response",,"LR",$T(+0))
 K ^ABSPECX("POS",DIALOUT,"R",CLAIMIEN) ; kill anything that's there
 F I=1:SEG:$L(RESPMSG) D
 .S ^ABSPECX("POS",DIALOUT,"R",CLAIMIEN,I\SEG+1)=$E(RESPMSG,I,I+SEG-1)
 .S ^ABSPECX("POS",DIALOUT,"R",CLAIMIEN,0)=I\SEG+1
 L -^ABSPECX("POS",DIALOUT,"R",CLAIMIEN) ; unlock the response
 D SETCSTAT^ABSPOSU(CLAIMIEN,80) ; Waiting to process response.
 ;
 ; Now we're ready to go again.
 I CLAIMNXT S CLAIMIEN=CLAIMNXT G START
 ;
 ; No more to send.
 ; We expect EOT from Envoy.  NDC might send ENQ here?
 I T1LINE Q 0
 S HMSG=$$WAITCHAR(EOT_ENQ,3)
 I HMSG'="+++",HMSG'="ENQ" D
 . D LOG("9 - No more to send; expect EOT, got "_HMSG)
 I HMSG'="+++" D HANGUP
 Q 0
 ; ----- end of main part of routine -----
 ;
LOG(X) D LOG^ABSPOSL($T(+0)_" - "_X) Q
 ;
 ; READCHAR not used? READCHAR(TIMEOUT)  N X U IO R *X:TIMEOUT Q X
 ;
 ; WAITCHAR:  Envoy 4.1, page 16
 ;   If during one of the wait stages of the transmission, the
 ; pharmacy system should receive unexpected characters, they should
 ; be ignored unless they are transmitted as a part of the response
 ; (beginning with the STX and concluding with the ETX).  At that
 ; point, they should be considered a part of a message.  The ENVOY
 ; system will react in the same manner after returning a response.
 ; After the issuance of the ENQ, however, if the host receives
 ; unexpected characters without receiving the STX and/or the ETX,
 ; it will issue an EOT.
 ;
 ; In plain English:  WAITCHAR^ABSPOSAW ignores unexpected characters.
 ; Except for EOT - it catches that, as well as the watched-for
 ; characters.
 ;
WAITCHAR(CHARS,TIMEOUT) ;EP -
 N RET S RET=$$WAITCHAR^ABSPOSAW(DIALOUT,CHARS,TIMEOUT)
 I RET="+++" D LOG("WAITCHAR tells us that modem is disconnected.")
 Q RET
 ;
SHUTDOWN()         N RET S RET=$$SHUTDOWN^ABSPOSQ3
 I RET D LOG("The transmit/receive shutdown flag is set.")
 Q RET
HANGUP D HANGUP^ABSPOSAB(DIALOUT) Q
 ;  NOTE!!!  Print of log for one claim depends on finding
 ;  the exact texts shown below!
CLAIMBEG D LOG("CLAIM - BEGIN - #"_CLAIMIEN_$$CLAIM01) Q
CLAIMEND D LOG("CLAIM - END - #"_CLAIMIEN_$$CLAIM01) Q
CLAIM01() Q " ("_$P(^ABSPC(CLAIMIEN,0),U)_")"
