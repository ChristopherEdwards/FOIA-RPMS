ABSPOSBW ; IHS/FCS/DRS - Billing - FSI/ILC A/R v1,2;       
 ;;1.0;PHARMACY POINT OF SALE;;JUN 21, 2001
 Q
 ; Billing interface for FSI/ILC Accounts Receivable,
 ; Versions 1 and 2
 ;
 ; Called at tag POST from ABSPOSBB
 ; with the variable ABSP57 pointing to 9002313.57, the transaction
 ; You must return a value - that value is stuffed into field .15
 ; of the transaction record
 ; and indexed by ^ABSPTL("AR",value,IEN57)
 ;
 ; Many useful utilities are available in ABSPOS57
 ; need to write
 ;     DO LOG57^ABSPOS57(text) puts text into the claim's log file
 ; 
 ; Note about this billing interface and interlocks:
 ;    We have another background job to actually post charges.
 ;    A job is scheduled for each visit - to run ABSPOSBX.
 ;    That posting job uses the same interlock as the main
 ;    background billing.  So you can freely use the "AR" index
 ;    and everything else.
 ;
POST() ; EP - from ABSPOSBB
 N IEN57 S IEN57=ABSP57 ; now you can $$label^ABSPOS57
 N PREV57 D
 . S X=$P(^ABSPTL(IEN57,0),U) ; 1234567.000rt
 . S PREV57=$O(^ABSPTL("B",X,IEN57),-1)
 N RESULT,RETVAL S RETVAL=""
 S RESULT=$$GET1^DIQ(9002313.57,ABSP57_",","RESULT WITH REVERSAL")
 ;
 ; RESULT can by E PAYABLE, E REJECTED, E CAPTURED, PAPER
 ; or E REVERSAL ACCEPTED or PAPER REVERSAL
 ; or E REVERSAL REJECTED
 ;
 N VISITIEN S VISITIEN=$$VISITIEN^ABSPOS57
 ;
 ; We want to group all the claims for a single visit and
 ; then post them together on a single bill (well, more bills if
 ; some of the claims have different insurers.  One per insurer.)
 ;
 ; So for this phase, we simply schedule a billing job for the visit
 ; for some time from now (30 minutes?).  At that time, we check to
 ; see if all the collected charges for the visit are at least
 ; (15 minutes?) old.  If so, we post.  If not, we reschedule for later.
 ;
 ; But reversals, we handle those right now:
 ; The original charge might not yet be posted!  It could still be
 ;    in ^ABSPOS("AR",KEY15, waiting.
 ;
 I RESULT["REVERSAL" D
 . D REVERSAL ; IEN57 is a reversal
 E  D  ; it's a charge to be posted
 . S RETVAL=$$KEY15 ; make sure posting job is scheduled
 Q RETVAL  ; caller stuffs this into 9002313.57 field #.15 for us
 ;
 ;
 ;
 ; ^ABSPTL("AR",key,ien57)
 ; What to use for the key?
 ; For claims awaiting posting,
 ;   visitien/insien/time scheduled to post
 ; For claims already posted:
 ;   "" (so it disappears from the index)
 ;   or ?1N.N (another pointer to where it was posted
 ;
 ; So to get the vis/ins/time ones, 
 ;   $O(^ABSPTL("AR"," "))
 ;
KEY15() N X,Y S X=$$VISITIEN^ABSPOS57_"/"_$$INSIEN^ABSPOS57_"/"
 S Y=$O(^ABSPTL("AR",X))
 I $P(Y,"/",1,2)=$P(X,"/",1,2) D  ; posting already scheduled
 . S $P(X,"/",3)=$P(Y,"/",3) ; so take the same posting time
 E  D  ; posting not yet scheduled for this visit+insurer
 . S $P(X,"/",3)=$$TADDNOWS^ABSPOSUD($$DELAY1)
 . D SCHED(X)
 Q X
SCHED(KEY15) ; schedule posting job for transaction as directed by X
 ; X = format of $$KEY15, above
 S KEY15=$P(KEY15,"/",1,3)
 N ZTDTH,ZTSAVE,ZTIO
 S ZTDTH=$P(KEY15,"/",3)
 S ZTRTN="EN^ABSPOSBX",ZTIO="",ZTSAVE("KEY15")=""
 D ^%ZTLOAD
 Q
REVERSAL ; IEN57 is a reversal - handle it and set RETVAL
 S RETVAL="" ; until we say otherwise
 D LOG("Transaction "_IEN57_" is a reversal; previous transaction was "_PREV57_".")
 I 'PREV57 D  Q
 . D LOG("  ??No record of any previous charge.  Nothing done.")
 ;
 ; Find where the previous charge was posted.
 ;
 N PCNDFN S PCNDFN=$P(^ABSPTL(PREV57,0),U,3)
 ;
 ; Perhaps it wasn't posted yet.  This would be typical if the 
 ; reversal is made immediately after the original charge is posted.
 ; The original charge is probably in Taskman now waiting for other
 ; charges that might come along for the same visit.  At that time,
 ; the reversal will be detected and posting of charge will be skipped.
 ;
 I 'PCNDFN D  Q  ; it wasn't posted the first time around
 . D LOG^ABSPOSL("Original charge not posted; no adjustment needed.")
 ;
 ; The original charge was posted, to PCNDFN.
 ; Put an adjustment and make a comment on the account.
 ;
 N WHEN S WHEN=$$GET1^DIQ(9002313.57,IEN57_",",7,"I")_"0000"
 S WHEN=$E(WHEN,4,5)_"/"_$E(WHEN,6,7)_"/"_$E(WHEN,2,3)
 S WHEN=WHEN_"@"_$E(WHEN,9,10)_":"_$E(WHEN,11,12)
 ;
 ; if failed reversal, make a comment
 ;
 I RESULT'="E REVERSAL ACCEPTED",RESULT'="PAPER REVERSAL" D  Q
 . D COMMENT^ABSPOSBF(PCNDFN,"CLAIM REVERSED on "_WHEN)
 . D LOG^ABSPOSL("Comment made on `"_PCNDFN_" for "_RESULT)
 ;
 ; if successful reversal, write off the old charge
 ;
 N AMTOLD S AMTOLD=$P(^ABSPTL(PREV57,5),U,5) ; original charge amount
 N REASON S REASON=RESULT_" on "_WHEN
 D ADJUST^ABSPOSBX(PCNDFN,AMTOLD,REASON)
 N FDA,MSG ; mark transaction as having been posted to A/R.
 S FDA(9002313.57,IEN57_",",2)=PCNDFN
 S FDA(9002313.57,IEN57_",",.15)=PCNDFN
R88 D FILE^DIE(,"FDA","MSG")
 I $D(MSG) D  G R88:$$IMPOSS^ABSPOSUE("FM","TRI","FILE^DIE failed",.MSG,"REVERSAL",$T(+0))
 . D LOGARRAY^ABSPOSL("FDA")
 . D LOGARRAY^ABSPOSL("MSG")
 Q
 ;
 ;
DELAY1() Q 30*60 ; how many seconds to wait before posting
DELAY2() ;EP -
 Q $$DELAY1/2 ; how many seconds quiet time before it's safe to post
 ;  (that is, if any additional charges in the past xxx time,
 ;   reschedule the posting for later)
LOG(X) D LOG^ABSPOSL(X) Q
