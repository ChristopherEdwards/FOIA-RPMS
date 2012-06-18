ABSPOSBX ; IHS/FCS/DRS - Billing - FSI/ILC A/R v1,2;      
 ;;1.0;PHARMACY POINT OF SALE;;JUN 21, 2001
 Q
ENABLED() Q 1
EN ; Taskman routine begins here
 ; with KEY15=visit/insurer/time sched for
 ; Does posting for just this one visit and insurer
 ;
 ; ^ABSPTL("AR",KEY15,IEN57)="" is defined for one or more IEN57's
 ;  These are all charges.
 ;  None are reversals - the reversals were dealt with in ABSPOSBW.
 ;  But some of these charges may already have reversals outstanding!
 ;
 N PCNDFN
 ;
 ; Same interlock as other billing
 ; Unlock happens implicitly when Taskman job stops
 ;
 I '$$LOCK^ABSPOSBD D RESCHED(5*60) Q  ; 5 minutes later
 D INIT^ABSPOSL(DT+.2,1) ; same log file
 ;
 ; If posting is turned off, then reschedule this to run much later.
 ;
 I '$$ENABLED D RESCHED(3*60*60) Q  ; 3 hours later
 ;
 ; Gather all the IEN57's with the same visit/insurer as KEY15 has
 ; Put them into CHGLIST(IEN57)=""
 ; But for those which were reversed, put them into REVLIST(IEN57) 
 ;
 N CHGLIST,REVLIST D
 . N X S X=$P(KEY15,"/",1,2)
 . F  S X=$O(^ABSPTL("AR",X)) Q:$P(X,"/",1,2)'=$P(KEY15,"/",1,2)  D
 . . N IEN57 S IEN57=0
 . . F  S IEN57=$O(^ABSPTL("AR",X,IEN57)) Q:'IEN57  D
 . . . S @$$LIST57@(IEN57)=""
 ;
 ; If charges for the visit/insurer are still coming in,
 ;  then reschedule this to run later.
 ; (DT test is to facilitate testing on the date shown)
 ;
 I DT>3010327,'$$SETTLED D  Q
 . D RESCHED($$DELAY2^ABSPOSBW)
 . D LOG(KEY15_" still busy; billing rescheduled for later")
 ;
 ; Post everything in CHGLIST(IEN57)=""
 ; except those which have been reversed
 ;
 I $D(CHGLIST) D
 . S PCNDFN=$$CHGLIST^ABSPOSBM ; 03/26/2001
 ;
 ; If any of these charges had been posted before,
 ; adjust off the old charges.  (Should not happen any more, since
 ; we enforce a reverse-first-then-resubmit policy, even for paper.)
 ;
 D REBILLED
 ;
 ; Clear the KEY15 values (thus removing these charges
 ;  from the ^ABSPTL("AR",key15,ien57) index)
 ; and Mark each of these as having been posted to ILC A/R.
 ;
 D
 . I '$G(PCNDFN) N PCNDFN S PCNDFN="not posted"
 . N FDA,MSG
 . S IEN57=0 F  S IEN57=$O(CHGLIST(IEN57)) Q:'IEN57  D
 . . S FDA(9002313.57,IEN57_",",2)=PCNDFN
 . . S FDA(9002313.57,IEN57_",",.15)=PCNDFN
 . S IEN57=0 F  S IEN57=$O(REVLIST(IEN57)) Q:'IEN57  D
 . . S FDA(9002313.57,IEN57_",",.15)=PCNDFN
 . . D LOG^ABSPOSL("Transaction "_IEN57_" was already reversed; we did not post it.")
F . I $D(FDA) D FILE^DIE("","FDA","MSG")
 . I $D(MSG) D  G F:$$IMPOSS^ABSPOSUE("FM","TRI","FILE^DIE failed",.MSG,,$T(+0))
 . . D LOG^ABSPOSL("Failed - trying to store in fields .15 and 2")
 . . D LOGARRAY^ABSPOSL("FDA")
 . . D LOGARRAY^ABSPOSL("MSG")
 ;
 ;
 D DONE^ABSPOSL ; done with log file
 D UNLOCK^ABSPOSBD ; release billing interlock
 Q
LIST57() ; given IEN57 ; return "CHGLIST" or "REVLIST"
 ; "CHGLIST" - this is a charge which should be posted to a/r
 ; "REVLIST" - this charge was subsequently reversed; do not post it
 N X S X=$P(^ABSPTL(IEN57,0),U) ; RXIRXR
 I '$O(^ABSPTL("B",X,IEN57)) Q "CHGLIST" ; no subsequent transactions
 N NXT57 S NXT57=$O(^ABSPTL("B",X,IEN57))
 S X=$$GET1^DIQ(9002313.57,NXT57_",","RESULT WITH REVERSAL")
 I X="E REVERSAL ACCEPTED" Q "REVLIST"
 E  I X="PAPER REVERSAL" Q "REVLIST"
 E  Q "CHGLIST"
REBILLED ; if anything in CHGLIST() was previously posted to A/R,
 ; write off the old charges and make comments on both old and new bills
 S IEN57=0 F  S IEN57=$O(CHGLIST(IEN57)) Q:'IEN57  D
 . N OLD57,OLDPCNI,OLDPCNE,OLDAMT ; internal, external id's of the old bill
 . S OLD57=$$PREVIOUS^ABSPOS57(IEN57) Q:'OLD57
 . S OLDPCNI=$P(^ABSPTL(OLD57,0),U,3) Q:'OLDPCNI
 . S OLDAMT=$P(^ABSPTL(OLD57,5),U,5)
 . S OLDPCNE=$P(^ABSBITMS(9002302,OLDPCNI,0),U)
 . ; comment on old bill to say "rebilled"
 . N NEWPCNI,NEWPCNE
 . N DRUG S DRUG=$$DRGNAME^ABSPOS57
 . S NEWPCNI=PCNDFN,NEWPCNE=$P(^ABSBITMS(9002302,NEWPCNI,0),U)
 . D ADJUST(OLDPCNI,OLDAMT,"Rebilled "_DRUG_" on "_NEWPCNE)
 . D COMMENT^ABSPOSBF(NEWPCNI,"Rebilling of "_DRUG_" from "_OLDPCNE)
 Q
ADJUST(PCNDFN,AMTOLD,REASON) ; EP - used by reversals handling in ABSPOSBW
 N BATCH S BATCH=$$ADJBATCH
 ; Do we need to release this batch?
 I $$NEEDREL D:BATCH'=0  ; batch old enough to need to be released
 . ;No, don't actually release the batch here.
 . ;Let someone do it from the A/R Menu.
 . S BATCH=0 ; force a new one to be created
 ; Do we need a new batch?
AB I 'BATCH D
 . S BATCH=$$NEWBATCH^ABSPOSP(0)
 . D LOG^ABSPOSL("Opened new adjustments batch "_BATCH)
 . D SET235(5,BATCH)
 I 'BATCH G AB:$$IMPOSS^ABSPOSUE("P,DB,FM,L","TRI","Failed to obtain a new batch",,"ADJUST",$T(+0))
 D ADJUST^ABSPOSP(PCNDFN,BATCH,AMTOLD,REASON)
 D LOG^ABSPOSL("Adjustment recorded in payments batch "_BATCH)
 D SET235(6,DT) ; record the date we last used this batch
 Q
NEEDREL() Q:'BATCH 0 ; no batch on record
 I $P(^ABSBPMNT(BATCH,0),U,5)'="A" Q 0 ; prev. batch no longer active
 N X1,X2,X,%Y S X1=DT,X2=$$BLASTDT D ^%DTC
 Q X>$$BLIFE ; 1 if it's older than that, 0 if not older
ADJBATCH() N B S B=$P($$GET235,U,5) Q:'B B ; batch # of last adjustments batch
 Q $S($P($G(^ABSBPMNT(B,0)),U,5)="A":B,1:"") ; but only if Active batch
BLASTDT() Q $P($$GET235,U,6) ; date we last made an entry in it
BLIFE() Q $P($$GET235,U,7) ; how many days a batch is good for
GET235() Q $G(^ABSP(9002313.99,1,"BILLING - NEW"))
SET235(PIECE,VALUE) S $P(^ABSP(9002313.99,1,"BILLING - NEW"),U,PIECE)=VALUE Q
SETTLED() ; has the flow of new charges for this KEY15 settled?
 ; yes, if all of them are at least $$DELAY2^ABSPOSBW seconds old
 N RET S RET=1 ; assume yes
 N IEN57 S IEN57=0
 F  S IEN57=$O(^ABSPTL("AR",KEY15,IEN57)) Q:'IEN57  D  Q:'RET
 . N T1 S T1=$P(^ABSPTL(IEN57,0),U,8) ; LAST UPDATE
 . N DIF S DIF=$$TIMEDIFI^ABSPOSUD(T1,$$NOW^ABSPOS) ; how old?
 . I DIF<$$DELAY2^ABSPOSBW S RET=0
 Q RET
RESCHED(DELTA) ;
 N ZTDTH,ZTIO,ZTSAVE,ZTRTN
 S ZTDTH=$$TADDNOWS^ABSPOSUD(DELTA)
 S ZTIO="",ZTSAVE("KEY15")=""
 S ZTRTN="EN^ABSPOSBX"
 D ^%ZTLOAD
 Q
LOG(X) D LOG^ABSPOSL(X) Q
LOGCLAIM(X) D LOG59^ABSPOS57(X) Q
