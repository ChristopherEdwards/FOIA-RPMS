ABSPOSAP ; IHS/FCS/DRS - GETNEXT, PUTBACK ;      [ 09/12/2002  10:06 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3,37**;JUN 21, 2001
 Q
 ;
 ;  GETNEXT, PUTBACK - manage the list of packets to be sent
 ;    for this DIALOUT.
 ;
 ; Due to silly LOCK rule, it's a timed read and in the sorry event
 ; that we cannot obtain the lock, we will reschedule a transmit/
 ; receive job to run again.
 ;
LLIST() ; EP - from ABSPOSC4
 L +^ABSPECX("POS",DIALOUT,"C"):300 Q:$T 1
 D LOG("Unable to get exclusive access to the list of claims for DIALOUT="_DIALOUT)
 D TASK^ABSPOSQ2
 Q 0
ULLIST ; EP - from ABSPOSC4
 L -^ABSPECX("POS",DIALOUT,"C") Q
 ;
 ; Routines to get and unget messages
 ; Given DIALOUT
 ; optional parameter N says "first message after #N"
 ; Sets SENDMSG = the big string and kills message out of the global
 ;      SENDMSGP(n)=the message in segments as copied from global
 ;      CLAIMIEN=the message number
 ;           (this is for convenient restoring in case of comms error)
 ; Returns message number
 ; If no message ready to send, returns FALSE and $D(SENDMSG)=0
 ;   and $D(CLAIMIEN)=0
 ;
GETNEXT(N) ;EP -
 ; (any NEW commands go here)
GETNEXT1 ;
 I '$$LLIST S CLAIMIEN="" Q  ; lock the list for this DIALOUT
 I '$G(N) S N=0
 K SENDMSG,SENDMSGP,CLAIMIEN
 S N=$O(^ABSPECX("POS",DIALOUT,"C",0))
 I N D
 . M SENDMSGP=^ABSPECX("POS",DIALOUT,"C",N) ; SENDMSG(*) = message
 . ; Note: ABSPOSC4 also does a KILL of the claim packet
 . K ^ABSPECX("POS",DIALOUT,"C",N)
 . S SENDMSG=""
 . ;N I F I=1:1:SENDMSGP(0) S SENDMSG=SENDMSG_SENDMSGP(I)
 . N I F I=1:1:SENDMSGP(0) S SENDMSG=SENDMSG_$G(SENDMSGP(I))  ;IHS/OIT/SCR 012710 patch 37 to avoid undefined at Santa Rosa
 . S CLAIMIEN=N
 E  S CLAIMIEN=""
 D ULLIST ; unlock the list
 ;
 ;  If we got a claim packet to be sent, check to see if any of the
 ;  claims therein are marked for cancellation.  If so, then handle
 ;  the cancellation, which involves NOT sending this packet.
 ;  Then loop back and see if you can get another one, instead.
 I N,$$CANCEL^ABSPOSAN G GETNEXT1
 Q N
PUTBACK ;EP - puts message back, with given CLAIMIEN
 F  Q:$$LLIST  Q:'$$IMPOSS^ABSPOSUE("L,P","RIT","Lock list to put back message","DIALOUT="_DIALOUT,"PUTBACK",$T(+0))
 I $D(^ABSPECX("POS",DIALOUT,"C",CLAIMIEN)) D  G PB9 ; should never happen
 . D IMPOSS^ABSPOSUE("P,DB","TRI","Old slot is now occupied again?!",,"PUTBACK",$T(+0))
 M ^ABSPECX("POS",DIALOUT,"C",CLAIMIEN)=SENDMSGP
PB9 D ULLIST ; unlock the list
 Q
LOG(X) D LOG^ABSPOSL($T(+0)_" - "_X) Q
