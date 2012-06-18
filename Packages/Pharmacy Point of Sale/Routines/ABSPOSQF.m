ABSPOSQF ; IHS/FCS/DRS - Insurer asleep - status 31 ;
 ;;1.0;PHARMACY POINT OF SALE;;JUN 21, 2001
 Q
 ;
 ; Continuation of ABSPOSQ2
 ;
STATUS31 ;EP - ABSPOSQ2
 ; Situation:  you have 1 or 2 or maybe 200 claims in status 31,
 ; because we've determined that the insurer is asleep.
 ; change at most one claim per insurer to status 30, to let it
 ; go through and try again.  But if the insurer is awake for sure,
 ; let all of the claims for that insurer go on through.
 N STATUS30,IEN59,INSURER S STATUS30=31,IEN59=""
 K ^TMP("ABSPOSQF",$J) ; build ^TMP("ABSPOSQF",$J,INSURER,IEN59)=""
 Q:'$$LOCK59^ABSPOSQ2
 F  S IEN59=$$NEXT59^ABSPOSQ2(IEN59) Q:'IEN59  D
 . ; if $$NEXT59() returned us an IEN59, then the waiting time
 . ; has expired - or better yet, the insurer has awakened
 . S INSURER=$P(^ABSPT(IEN59,1),U,6)
 . ; If still in wait, but wait expired, just allow one claim thru.
 . ; But if wait has been canceled - that is, we had a successful
 . ; transmit, meaning the insurer has awakened - then let them all
 . ; go through to status 30.
 . N X S X=$G(^ABSPEI(INSURER,101))
 . N T,PROBER S T=$P(X,U),PROBER=$P(X,U,6)
 . ; if somehow the prober became complete, without clearing 101;6
 . ; (maybe this happens if cancellation takes place?)
 . I PROBER D
 . . N X S X=$P($G(^ABSPT(PROBER,0)),U,2)
 . . I X=99!(X="") S PROBER=""
 . I T,PROBER,PROBER'=IEN59 Q  ; only prober can go thru during wait
 . I T S $P(^ABSPEI(INSURER,101),U,6)=IEN59 ; you're the prober
 . S ^TMP("ABSPOSQF",$J,INSURER,IEN59)=""
 D UNLOCK59^ABSPOSQ2
 S INSURER="" F  S INSURER=$O(^TMP("ABSPOSQF",$J,INSURER)) Q:'INSURER  D
 . S IEN59="" F  S IEN59=$O(^TMP("ABSPOSQF",$J,INSURER,IEN59)) Q:'IEN59  D
 . . D SETSTAT^ABSPOSQ2(30) ; reset to status 30
 . . K ^ABSPT(IEN59,8) ; clear Listmanager wait info
 Q
