ABSPOSQ3 ; IHS/FCS/DRS - tasked from ABSPOSQ2 ;     [ 09/12/2002  10:18 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3,14**;JUN 01, 2001
 Q
 ; 
 ; Subroutines split away from ABSPOSQ3:
 ;   EWAIT55^ABSPOSQJ(DIALOUT,OPERATION) - manage ERROR WAIT condition
 ;   ANY2SEND^ABSPOSQJ(DIALOUT) - any claims waiting to be sent?
 ;
COMMS ; This is the entry point - usually by taskman call from ABSPOSQ2.
 ; Given DIALOUT = pointer into 9002313.55
 ; Transmit and receive as long as you have claims to be transmitted
 ; The task manager sets up DIALOUT in the call from ABSPOSQ2.
 ; When it's done with one DIALOUT, it looks around for others that
 ; are in need of transmit, so you could end up doing lots of
 ; transmissions in this one routine.
 ;
 ; Tell the world that we're up and running.
 ;
 ;BREAK
 L +^ABSPECX("ABSPOSQ3","JOB",$J):0 I '$T D  Q
 . D IMPOSS^ABSPOSUE("P","TI","can't obtain job-specific lock for $J="_$J_" ????",,"COMMS",$T(+0))
 ;
 ; Remark about ^ABSPECX("ABSPOSQ3","JOB",$J,...
 ;    $$JOBCOUNT uses LOCKs to decide if they're running.
 ;    If a job bombs, the global remains but the LOCK is gone.
 ;    And that way, $$JOBCOUNT knows when to kill off such entries.
 S ^ABSPECX("ABSPOSQ3","JOB",$J)=$H
 S ^ABSPECX("ABSPOSQ3","JOB",$J,"DIALOUT")=DIALOUT
 I $$JOBCOUNT>$$MAXJOBS H 2 I $$JOBCOUNT>$$MAXJOBS G ENDJOB99
 ;
 ; put in long delay here for testing stuff like cancel a claim
 ;Don't forget to uncomment this later
 ;I 0 H 300
 ;
 N ABSPECT2,ABSBPOSE
 ;
 ; You need a slot for logging
 D INIT^ABSPOSL(.1)
 D LOG^ABSPOSL("Sender/Receiver Job "_$J_" begins; DIALOUT="_DIALOUT)
 D REMEMLOG(DIALOUT,$$GETSLOT^ABSPOSL)
 ;
AGAIN ; Loop back to here ; DIALOUT may have been changed since first entry
 S ^ABSPECX("ABSPOSQ3","JOB",$J,"DIALOUT")=DIALOUT
 ;I $$JOBCOUNT>$$MAXJOBS D  G ENDJOB  ; already enough of these running
 ;. D LOG^ABSPOSL("Exceeded "_$$MAXJOBS_" sender/receiver jobs.")
 ;
 ;BREAK
 I $$ANY2SEND^ABSPOSQJ(DIALOUT) D
 . D TASK(60) ; start up proc. of responses right now, 
 . ; so something's ready - 60 = seconds for ABSPOSQ4 to wait around
 . ; for response packets to arrive
 . S ABSBPOSE=$$TRANSMIT(DIALOUT) ; transmit / receive
 E  S (ABSPECT2,ABSBPOSE)=0 ; none sent, no errors
 ;
 I ABSPECT2 D  ;if there were any complete transactions
 . ; and someone hasn't already processed the responses,
 . I $O(^ABSPECX("POS",DIALOUT,"R",0)) D TASK() ; start up resp. handl'g
 ; 
 ; I there were any errors returned by $$TRANSMIT
 ;   Check for the simple one-transaction-per-call case and loop back
 ;   if that's what happened.
 ;
 I ABSBPOSE=6999.30101,ABSPECT2>0 G AGAIN
 ;
 ; Else:
 ; 1 Mark the DIAL OUT as being in an error state.
 ; 2 Mark the POS WORKING claims as being in an error wait state (51)
 ; 3 Schedule this program to run again after the wait period expires.
 ;
 I ABSBPOSE D
 . ; one call to EWAIT55^ABSPOSQJ does it all
 . ; if ABSPECT2 (i.e., any successful transactions), then reset
 . ; to first increment - else bump up to next increment
 . D EWAIT55^ABSPOSQJ(DIALOUT,$S(ABSPECT2:"RESET",1:"INCREMENT"))
 . N X S X=$T(+0)_" - Increment ERROR WAIT on Dial Out `"_DIALOUT
 . S X=X_" to "_$P(^ABSP(9002313.55,DIALOUT,"ERROR WAIT"),U)
 . D LOG^ABSPOSL(X)
 E  I $P($G(^ABSP(9002313.55,DIALOUT,"ERROR WAIT")),U) D
 . ; No error, but should be clear the error on the dial-out?
 . ; Case 1:  Yes, clear it if we had a successful transmit-receive.
 . ; Case 2:  We had nothing to send, and there's no other active
 . ;   transmit-receive jobs on this same dial-out trying to work.
 . I ('$$OTHJOBS)!(ABSPECT2) D
 . . D LOG^ABSPOSL($T(+0)_" - Clear ERROR WAIT - Dial Out #"_DIALOUT)
 . . D EWAIT55^ABSPOSQJ(DIALOUT,"CLEAR")
 ;
 ; We finished with DIALOUT 
 K ^ABSPECX("ABSPOSQ3","JOB",$J,"DIALOUT")
 ; - any others to do, though?
 ; Give it 10 seconds; more efficient than task managering again
 H 10
TOLOOP ;
 ; Now that transmit is done for this DIALOUT, maybe there are others
 ; we can help out with?
 I '$$SHUTDOWN S DIALOUT=$$ANY2SEND^ABSPOSQJ I DIALOUT D  G AGAIN
 . D LOG^ABSPOSL($T(+0)_" - $$ANY2SEND^ABSPOSQJ(DIALOUT)="_DIALOUT_": loop back")
 ;
ENDJOB ;
 D LOG^ABSPOSL("Sender/Receiver Job "_$J_" ends")
 D DONE^ABSPOSL
ENDJOB99 ;EP
 I '$D(^ABSPECX("ABSPOSQ3","JOB",$J)) D  ; impossible
 . D IMPOSS^ABSPOSUE("P","TI","my job-defined locked node disappeared!!!  $J="_$J,,"ENDJOB99",$T(+0))
 K ^ABSPECX("ABSPOSQ3","JOB",$J)
 L -^ABSPECX("ABSPOSQ3","JOB",$J)
 ;
 Q
OTHJOBS() ; any other transmit-receive jobs using DIALOUT?  returns count of
 N A,R S (A,R)=0
 F  S A=$O(^ABSPECX("ABSPOSQ3","JOB",A)) Q:'A  D
 . I DIALOUT=$G(^ABSPECX("ABSPOSQ3","JOB",A,"DIALOUT")) S R=R+1
 Q R
TASK(Q4WAIT) ;EP - ABSPOS2D,ABSPOSQ4 ; start processing of responses
 N X,Y,%DT
 S X="N",%DT="ST" D ^%DT
 D TASKAT(Y,$G(Q4WAIT))
 Q
TASKAT(ZTDTH,Q4WAIT) ; EP -
 ;ZTDTH = time when you want EN^ABSPOSQ4 to run
 ; called from TASK, above, normally
 ; Q4WAIT true: it will wait that many seconds for responses to come in,
 ; polling every few seconds.
 ; Q4WAIT false: if there's none ready, it stops
 N ZTRTN,ZTIO,ZTSAVE
 S ZTRTN="EN^ABSPOSQ4",ZTIO=""
 S ZTSAVE("DIALOUT")="" ; which entry in 9002313.55
 I $G(Q4WAIT) S ZTSAVE("Q4WAIT")=""
 D ^%ZTLOAD
 Q
 ;
TRANSMIT(DIALOUT) ; returns 0 if success, nonzero error code if failure
 ; This does transmit/receive for ONLY the given DIALOUT
 N ECODE,ERROR S ERROR=0
 ; ERROR codes:   
 ;  3xx - in (to be completed - routine names changed)
 ; 69xx - in
 ; 80xx - in
 ;
 ; Dialing and $$CONNECT moved into $$SEND
 ; S ECODE=$$CONNECT(DIALOUT) ; connect to NDC (or other host)
 ;
TMIT1 S ECODE=$$SEND(DIALOUT) ; transmit and receive
 ; in case the OPEN failed, wait about one transaction xmit time or so
 I +ECODE=20999 H 10 H $R(5) G TMIT1 ; 
 ; sets ABSPECT2=count
 ;
 D CLOSE^ABSPOSAB(DIALOUT)
 D ADDSTAT^ABSPOSUD("D",1,1,"D",2,$G(ABSPECT2),"D",3,ECODE'=0)
 ;
 I ECODE=0 D  ; success
 . D EWAIT55^ABSPOSQJ(DIALOUT,"CLEAR") ; clear any error indicators
 E  D
 . D EWAIT55^ABSPOSQJ(DIALOUT,"INCREMENT") ; init or incr err indicator
 . N X S X="CLAIM - ERROR - "_ECODE_" - "
 . S X=X_$P($G(^ABSPF(9002313.89,ECODE,0)),U,2)
 . D LOG^ABSPOSL(X)
 ;
 Q $S(ECODE:6999_"."_ECODE,1:0)
 ;
NOW() N %,%H,%I,X D NOW^%DTC Q %
 ;
 ;
SEND(DEST)         ;
 S ABSPECT2=0
 N RET S RET=$$SEND^ABSPOSAM(DEST)
 I ABSPECT2 D
 . N X S X=$T(+0)_" - Complete transactions: "_ABSPECT2
 . D LOG^ABSPOSL(X)
 I RET D
 . I RET=20999 D  ; couldn't open device (not unusual)
 . . ;
 . E  D
 . . N X S X=$T(+0)_" - Error code "_RET_" returned from $$SEND^ABSPOSAM"
 . . D LOG^ABSPOSL(X)
 Q RET
ROOTREF(DEST)          Q "^ABSPECX(""POS"","_DEST_",""C"")"
SETSTAT(ABSBRXI,STAT)        D SETSTAT^ABSPOSU(STAT) Q
TSTAMP(DA)         N DIE,DR S DIE=9002313.59,DR="7///NOW" D ^DIE Q
REMEMLOG(N,SLOT)   ; ^("LOG FILE") remembers current and past several log files
 N X S X=$G(^ABSP(9002313.55,N,"LOG FILE"))
 S X=SLOT_U_$P(X,U,1,9)
 S ^ABSP(9002313.55,N,"LOG FILE")=X
 Q
 ;
 ; = = = = = = = = = = UTILITIES = = = = = = = = = =
 ; ^ABSPECX("ABSPOSQ3","JOB",$J) is set for each of these that's running
 ;   and the node is also LOCKed.
 ; ^TMP("ABSPOSQ3","SHUTDOWN") tells these to shut down.
 ;  $$SHUTDOWN() to query, $$SHUTDOWN(N) to set it.
 ;     >0 means shut down, =0 means enabled
 ; ^TMP("ABSPOSQ3","MAX JOBS")=maximum # of these you want running
 ;    May actually be greater than that, but excess ones will drop out.
 ; $$MAXJOBS() to query, $$MAXJOBS(n) to set it.
 ;
 ; JOBCOUNT  tells you how many of these are running right now
 ;
JOBMON ; temporary, for use by direct mode debugging
 F  W $$JOBCOUNT(1)," ",$P($H,",",2)," / " W:$X>60 ! H 1
 Q
JOBCOUNT(ECHO) ;EP
 N N,X S N=0
 S X="" F  S X=$O(^ABSPECX("ABSPOSQ3","JOB",X)) Q:X=""  D
 .L +^ABSPECX("ABSPOSQ3","JOB",X):0
 .I '$T S N=N+1 ; yes, it's really running
 .E  D
 ..I X=$J S N=N+1 ; it's us, we're that job, that's why LOCK succeeded
 ..E  D  ; we got the lock, and we must unlock
 ...I $G(ECHO) W "We're going to kill the entry for job ",X,!
 ...K ^ABSPECX("ABSPOSQ3","JOB",X) ; it's not running, must've bombed
 ..L -^ABSPECX("ABSPOSQ3","JOB",X)
 Q N
 ;
LOCK(X) L +^TMP("ABSPOSQ3",X):300 Q $T
UNLOCK(X) L -^TMP("ABSPOSQ3",X) Q
 ;
SHUTDOWN(N) ;EP - ABSPOS2A,ABSPOSAM
 N RET,ROU,X
 S ROU=$T(+0),X="SHUTDOWN"
 F  Q:$$LOCK(X)  Q:'$$IMPOSS^ABSPOSUE("L","RIT","LOCK of SHUTDOWN flag",,"SHUTDOWN",$T(+0))  H 30
 I $D(N) S ^TMP("ABSPOSQ3",$J,X)=N
 S RET=+$G(^TMP("ABSPOSQ3",$J,X))
 D UNLOCK(X)
 Q:$Q RET Q
 ;
MAXJOBS(N) ;EP - ABSPOS2A
 N RET,ROU,X S RET=0
 S ROU=$T(+0),X="MAX JOBS"
 I '$$LOCK(X) ;
 I $D(N) S ^TMP("ABSPOSQ3",X)=N
 S RET=$G(^TMP("ABSPOSQ3",X))
 I 'RET S (RET,^TMP("ABSPOSQ3",X))=1 ; an arbitrary default for first timers
 D UNLOCK(X)
 Q:$Q RET Q
