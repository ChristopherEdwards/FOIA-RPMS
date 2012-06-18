ABSPOSQJ ; IHS/FCS/DRS - subroutines of ABSPOSQ2 ;  
 ;;1.0;PHARMACY POINT OF SALE;;JUN 21, 2001
 Q
SETSTAT(ABSBRXI,STAT)        D SETSTAT^ABSPOSU(STAT) Q
TSTAMP(DA)         N DIE,DR,X S DIE=9002313.59,DR="7///NOW" D ^DIE Q
NOW() N %,%H,%I,X D NOW^%DTC Q %
 ; Query whether there are formatted claim packets ready
 ; to send, or formatted response packets ready to be processed.
 ; Call them without DIALOUT (or with DIALOUT=0) to check all DIALOUTs
 ; Call with a specific DIALOUT to check only that DIALOUT
 ; 
ANY2SEND(DIALOUT) ;EP - from ABSPOS2D,ABSPOSQ3
 ; are there any claims waiting to be sent?
 ; also called from POKE^ABSPOSUD
 ; I called with an DIALOUT, look for just that DIALOUT
 ; Return TRUE (=DIALOUT) if there are, FALSE if there aren't
 ; Also:  Return false if this DIALOUT is currently in an ERROR WAIT
 ; state.
 ;
 ; If called without a DIALOUT:  scan all DIALOUTs and return the
 ;   first one that has some waiting to send.  FALSE if none nowhere.
 ;
 N RET
 I '$G(DIALOUT) G ANY2SA
 I '$O(^ABSPECX("POS",DIALOUT,"C","")) Q 0 ; none waiting to be sent
 ; Yes, there are some to be set for this DIALOUT
 I '$$EWAIT55(DIALOUT,"FLAGGED") Q DIALOUT ; no error condition
 I $$EWAIT55(DIALOUT,"EXPIRED") D  Q DIALOUT ; okay, it's time to retry
 . D LOG^ABSPOSL($T(+0)_" - ERROR WAIT expired, time to retry on dial out #"_DIALOUT)
 ; Yes, some to be sent, but we're in error wait retry.
 ; Make sure the individual claims are marked.  (this is to catch any
 ;  newly arrived claims destined for the DIALOUT with prior comms 
 ;  problems)
 D MARKWAIT(DIALOUT)
 Q 0
 ;
ANY2SA ; DIALOUT not given, so look for any DIALOUTs that need work
 N SET,RET S (SET,RET)=0
 F  S SET=$O(^ABSP(9002313.55,SET)) Q:'SET  I $$ANY2SEND(SET) S RET=SET Q
 Q RET
 ;
 ; EWAIT55  manages ERROR WAIT condition on a DIALOUT
EWAIT55(DEST,OPER) ;EP - ABSPOSQ3
 L +^ABSP(9002313.55,DEST):300
 I $Q N RET S RET=$$EWAIT55A
 E  D EWAIT55A()
 L -^ABSP(9002313.55,DEST)
 Q:$Q RET Q
EWAIT55A() ; given DEST, OPER
 N X S X=$G(^ABSP(9002313.55,DEST,"ERROR WAIT"))
 ;
 ; $$EWAIT55(DEST,"FLAGGED")
 ;       returns TRUE (=expiration time) if it's in ERROR WAIT state
 ;       returns FALSE (=0) if it's not
 I OPER="FLAGGED" Q $P(X,U) ; is it flagged?
 ;
 ; $$EWAIT55(DEST,"EXPIRED") returns TRUE if the ERROR WAIT state
 ;   has expired (or if it's not even flagged)
 I OPER="EXPIRED" Q $$NOW'<$P(X,U) ; has it expired?
 ;
 ; $$EWAIT55(DEST,"INCREMENT") bumps ERROR WAIT to next increment
 ; $$EWAIT55(DEST,"RESET") resets it to its first increment
 I OPER="INCREMENT"!(OPER="RESET") D  Q
 . L +^ABSP(9002313.55,DEST):300
 . N FIRST S FIRST=('$P(X,U))!(OPER="RESET") ; the first time through?
 . I 'FIRST,$$NOW<$P(X,U) Q  ;hasn't reached the time yet - do not incr.
 . I '$P(X,U,2) S $P(X,U,2)=30 ; base time
 . I '$P(X,U,3) S $P(X,U,3)=1.2 ; multiplier
 . I '$P(X,U,4) S $P(X,U,4)=30*60 ; max wait time
 . I '$P(X,U,5)!FIRST S $P(X,U,5)=$P(X,U,2) ; current wait time (either init
 . E  S $P(X,U,5)=$P(X,U,5)*$P(X,U,3) ;      or multiply)
 . S $P(X,U,5)=$P(X,U,5)\1
 . S:$P(X,U,5)>$P(X,U,4) $P(X,U,5)=$P(X,U,4) ; apply max if needed
 . S $P(X,U)=$$TADDNOWS^ABSPOSUD($P(X,U,5)) ; set retry time
 . S ^ABSP(9002313.55,DEST,"ERROR WAIT")=X ; store updated data
 . L -^ABSP(9002313.55,DEST)
 . I FIRST,OPER'="INCREMENT" D
 . . D MARKWAIT(DEST) ; change claims' status from 50 to 51
 . E  D
 . . D INCRWAIT(DEST) ; stamp claims with new time of retry
 . N DIALOUT S DIALOUT=DEST ; variable needed by TASKAT^ABSPOSQ2
 . D TASKAT^ABSPOSQ2($P(^ABSP(9002313.55,DIALOUT,"ERROR WAIT"),U)) ; program will run again upon expiry
 ;
 ; $$EWAIT55(DEST,"CLEAR") clears the error wait condition
 I OPER="CLEAR" D  Q
 . S $P(X,U)="",$P(X,U,5)="" ; clear retry time, current wait time
 . S ^ABSP(9002313.55,DEST,"ERROR WAIT")=X
 . ; claims are okay in state 51; don't need to requeue them
 ;
 D IMPOSS^ABSPOSUE("P","TI","Bad arg OPER="_OPER,,"EWAIT55A",$T(+0))
 Q
 ;
 ; When an err condition is first established:  DO MARKWAIT
 ;     It takes the affected claims from code 50 and resets to 51
 ;     This is done in two places:
 ;     1. When an err condition is first detected.
 ;     2. When a new claim packet comes along and discovers
 ;        a pre-existing error condition.
 ;
 ; When an err condition persists and a retry is scheduled: DO INCRWAIT
 ;     This marks all the affected claims with the retry time.
 ;
 ;      
MARKWAIT(DEST)     ; Put status 50 claims into wait state because of this DEST
 ; having comms problems.
 ; The packets are in @ROOT@(PACKET), PACKET is pointer to 9002313.02
 ; The claims are in ^ABSPT("AE",PACKET,*)
 ; The claims are in ^ABSPT("AD",50,*), too
 ; You want to check ONLY the code 50's!  I you do it by going 
 ; through the "AE" index, and it's a long delay, and you have
 ; hundreds of claims backed up, this gets to be too expensive.
 N TIME S TIME=$P(^ABSP(9002313.55,DEST,"ERROR WAIT"),U)
 N IEN59 S IEN59=""
 F  S IEN59=$O(^ABSPT("AD",50,IEN59)) Q:'IEN59  D
 . N PACKET S PACKET=$P(^ABSPT(IEN59,0),U,4)
 . I $D(^ABSPECX("POS",DEST,"C",PACKET)) D
 . . D SETSTAT(IEN59,51) ; takes care of LOCK, last update, etc.!
 . . ; and mark the claim with useful data for the Listmanager screen
 . . S $P(^ABSPT(IEN59,8),U,1,2)=TIME_U_DEST
 Q
INCRWAIT(DEST)  ; Stamp all the waiting claims for this DIALOUT (DEST)
 ; with the scheduled retry time.
 ; This will induce the Listman display to update its display, too,
 ; when the Listman job sees that the LAST UPDATE time in .59 
 ; has changed.
 N TIME S TIME=$P(^ABSP(9002313.55,DEST,"ERROR WAIT"),U)
 N PACKET S PACKET=""
 F  S PACKET=$O(^ABSPECX("POS",DEST,"C",PACKET)) Q:PACKET=""  D
 . N IEN59 S IEN59=""
 . F  S IEN59=$O(^ABSPT("AE",PACKET,IEN59)) Q:IEN59=""  D
 . . S $P(^ABSPT(IEN59,8),U,1,2)=TIME_U_DEST
 . . D TSTAMP(IEN59)
 . F  S IEN59=$O(^ABSPT("AER",PACKET,IEN59)) Q:IEN59=""  D
 . . S $P(^ABSPT(IEN59,8),U,1,2)=TIME_U_DEST
 . . D TSTAMP(IEN59)
 Q
