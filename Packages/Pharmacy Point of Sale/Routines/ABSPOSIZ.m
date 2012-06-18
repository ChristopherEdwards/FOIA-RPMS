ABSPOSIZ ; IHS/FCS/DRS - Filing with .51,.59 ;    [ 11/04/2002  2:01 PM ]
 ;;1.0;PHARMACY POINT OF SALE;**3,6,23,34**;JUN 01, 2001
 Q
 ; Locking:
 ; 1. Locking this routine's code.
 ;    Done during FILE1
 ;    May be delays due to question-and-answer I/O!!!
 ; 2. Locking 9002313.59 - when obtaining a new entry and filing data.
 ;    No intervening delays as that would hold up all POS activity
 ;---
 ; IHS/SD/lwj 11/03/02  
 ; In Oklahoma, POS will go into a run away mode if there has been
 ; any type of stranded claim for Oklahoma Medicaid.  This is due in
 ; to the "special" logic that is in place for the Oklahoma Medicaid
 ; claims.  Basically, it continues to task itself again and again
 ; trying to clear the claims - this overflows task man.  To try and
 ; "slow" this some, we are going to add some logic to this program
 ; that will slow the tasking a little bit.  This will effect
 ; everything, not just Oklahoma, but we don't think the slow down
 ; won't harm anything at all.  The changes were originate by 
 ; Patrick Cox, and have been in test with Talequah since early
 ; 2002.
 ;---
 ;IHS/SD/lwj 7/17/03
 ; Need to add a clean up routine for the 5.1 DUR segment
 ;---
 ;IHS/SD/RLT - 06/21/07 - 10/18/07 - Patch 23
 ; Added cleanup routine for DIAGNOSIS CODE in CLINICAL segment
 ;---
LOCK() L +^TMP("ABSPOSIZ"):300 Q $T
UNLOCK L -^TMP("ABSPOSIZ") Q
LOCK59() L +^ABSPT:300 Q $T
UNLOCK59 L -^ABSPT Q
FILE(IEN,ECHO) ;EP - from ABSPOSI, ABSPOSIV
 ; <PF1> E was hit - so we make these claims official
 ; ^ABSP(9002313.51,IEN,...) -> 9002313.59 or wherever
 I '$D(ECHO) S ECHO=1
 N ENTRY S ENTRY=0
 N ABSPOSQ1 S ABSPOSQ1=0 ; set to nonzero if you need background job
 D DELEMPTY ; delete empty entries from the multiple
 I '$P($G(^ABSP(9002313.51,IEN,2,0)),U,4) D  G FZ
 . I ECHO W "Nothing entered..."
 I ECHO W "Submitting claims...",!
 F  S ENTRY=$O(^ABSP(9002313.51,IEN,2,ENTRY)) Q:'ENTRY  D
 . I ECHO D QUICK51(IEN,ENTRY)
 . F  Q:$$LOCK  Q:'$$IMPOSS^ABSPOSUE("L","RTI","Single-thread filing through ABSPOSIZ",,"FILE",$T(+0))
 . D INSUR(IEN,ENTRY,ECHO)
 . D CLNDUR^ABSPOSIH(IEN,ENTRY)   ;IHS/SD/lwj 7/17/03 patch 6
 . D CLNDIAG^ABSPOSII(IEN,ENTRY)  ;IHS/SD/RLT - 06/21/07 - 10/18/07 - Patch 23
 . D FILE1(IEN,ENTRY,ECHO)
 . D UNLOCK
 ; start background job if necessary
 I ABSPOSQ1 D TASK
FZ I ECHO W "...done.",! H 2
 Q
TASK ;EP - from ABSPOS2D,ABSPOS6D,ABSPOSQ1,ABSPOSQ4,ABSPOSU
 ;
 ;IHS/SD/lwj 11/03/02 on behalf of IHS/OKCAO/POC 1/25/2002
 ; This is where we are going to slow the tasking down a little. We will
 ; attempt to wait 2 second in between tasking the job again.  This 
 ; doesn't sound like much, but when it's run away, this will cut the 
 ; submittals by over half if not more.
 ;
 ; begin changes
 N ABSPQQQT
 S ABSPQQQT=0
 D
 . N CHECK
 . S CHECK=$G(^ABSPECP("CHECKTIM"))  ;last submittal time
 . S:$$FMDIFF^XLFDT($$NOW^XLFDT,CHECK,2)'>2 ABSPQQQT=1
 Q:ABSPQQQT
 S ^ABSPECP("CHECKTIM")=$$NOW^XLFDT
 ;
 ;IHS/SD/lwj 11/03/02  end changes
 ;
 N X,Y,%DT
 S X="N",%DT="ST" D ^%DT
 D TASKAT(Y)
 Q
TASKAT(ZTDTH)         ;EP - from above and from ABSPOSQS
 ; ZTDTH = time when you want COMMS^ABSPOSQ3 to run
 ; called from TASK, above, normally
 ; no??: called here from ABSPOSQ3 when it's requeueing itself for 
 ; retry after a dial-out error condition
 ;   ABSPOSQ3 requeues itself via TASK^ABSPOSQ2, not here
 ;N (DUZ,TIME,ZTDTH)
 N ZTRTN,ZTIO
 S ZTRTN="LOOP^ABSPOSQ1",ZTIO=""
 D ^%ZTLOAD
 Q
 ; KScratch ;Kill scratch globals
 ;K ^ABSPECX($J,"R")
DELEMPTY ; the multiple probably has some empty entries - delete them
 ; IEN is inherited from caller
 N FDA,MSG,FN,ENTRY S FN=9002313.512,ENTRY=0
 F  S ENTRY=$O(^ABSP(9002313.51,IEN,2,ENTRY)) Q:'ENTRY  D
 . N X,Y S X=^ABSP(9002313.51,IEN,2,ENTRY,0),Y=$G(^(1))
 . I X?1N.N."^",Y?."^" D  ; see Note 1, below
 . . S FDA(FN,ENTRY_","_IEN_",",.01)=""
 Q:'$D(FDA)  ; nothing to delete
D5 D FILE^DIE("","FDA","MSG")
 Q:'$D(MSG)  ; success
 D ZWRITE^ABSPOS("FDA","MSG")
 G D5:$$IMPOSS^ABSPOSUE("FM","TRI","FILE^DIE failed",,"DELEMPTY",$T(+0))
 Q
 ; Note 1.  In DELEMPTY, the test for an empty node:
 ;  piece 1 is the entry number, uneditable, ?1N.N
 ;  pieces 2ff may be present but null - apparently, just visiting
 ;   a field (e.g., pressing down arrow from NDC number)
 ; And also need to test for no fields in the ^(1) node ; 09/21/2000
 ;   could lead to filling in some empty values)
INSUR(IEN,ENTRY,ECHO)        ; ^ABSP(9002313.51,IEN,2,ENTRY,"I",*)
 ; need to move it into ^ABSP(9002313.51,IEN,2,ENTRY,6)=PINS data
 ; and ^ABSP(9002313.51,IEN,2,ENTRY,7)=insurer IENs
 N N S N=0 F  S N=$O(^ABSP(9002313.51,IEN,2,ENTRY,"I",N)) Q:'N  D
 . N X S X=^ABSP(9002313.51,IEN,2,ENTRY,"I",N,0)
 . I $P(X,U,2) D  ; ORDER is given
 . . N ORDER S ORDER=$P(X,U,2)
 . . S $P(^ABSP(9002313.51,IEN,2,ENTRY,6),U,ORDER)=$P(X,U,4) ; PINS
 . . S $P(^ABSP(9002313.51,IEN,2,ENTRY,7),U,ORDER)=$P(X,U,3) ;ins ien
 ; Delete the entire INS SEL SCRATCH field - it's no longer needed
 K ^ABSP(9002313.51,IEN,2,ENTRY,"I")
 ; the following fails because the field is a multiple
 ;N FDA,MSG,FN
 ;S FDA(9002313.512,ENTRY_","_IEN_",",100)=""
 ;D FILE^DIE("","FDA","MSG")
 ;I $D(MSG) W "at INSUR^",$T(+0),! ZW MSG IMPOSS^ABSPOSUE call, too
 Q
FILE1(IEN,ENTRY,ECHO)   ; ^ABSP(9002313.51,IEN,2,ENTRY,...)
 N INPUT M INPUT=^ABSP(9002313.51,IEN,2,ENTRY) ; convenience
 N ORIGIN S ORIGIN=$P(^ABSP(9002313.51,IEN,0),U,3)
 N ABSPUSR S ABSPUSR=$P(^ABSP(9002313.51,IEN,0),U,2) ;IHS/OIT/SCR 082709 patch 34
 N X S X=$P(INPUT(0),U,2)
 ; X can be any of the following:
 ;   `#     # points to ^PSRX(#,
 ;  (still have to work out the visit file details)
 D REMAP
 D FILERX
 Q
REMAP ; do any needed adjusing of INPUT(*) to handle postage, supplies, etc.
 Q
ISRX() ; return pointer to ^PSRX if true, else return ""
 N X S X=$P(INPUT(1),U) I 'X Q ""
 I $P(INPUT(0),U,3)?1"POSTAGE".E Q ""
 Q X
ISPOST() ; return pointer to ^PSRX if true, else return ""
 N X S X=$P(INPUT(1),U) I 'X Q ""
 I $P(INPUT(0),U,3)?1"POSTAGE".E Q X
 Q ""
ISVISIT() ; return pointer to visit if true, else return ""
 ; (this is for non-prescription items)
 N X S X=$P(INPUT(1),U) I X Q "" ; has ^PSRX pointer, so ret false
 Q $P(INPUT(1),U,6)
FILERX ; EVERYTHING is filed here: postage, supplies, as well as RX's
 ;
 ;  If it's being actively processed now, do not allow it to be
 ;  submitted again here.
 ;
 N DEBUG S DEBUG=0 ;(DUZ=120&(DUZ(2)=1859))
 N IEN59 S IEN59=$$IEN59^ABSPOSIY
 ;I DEBUG W ?10,"IEN59=",IEN59,!
RXA I $$ACTIVE59(IEN59) Q:'$$ACTIVEWT^ABSPOSIY(IEN59,IEN,ENTRY)  D  G RXA
 . D UNLOCK H 30
 . F  Q:$$LOCK  Q:'$$IMPOSS^ABSPOSUE("L","RTI","LOCK transaction record for IEN59="_IEN59,,"RXA",$T(+0))
 N X
 ;
 ;  If it's been deleted...
 ;  Let it through for now.
 ;  We're catching deleted ones in ABSPOSRB, so anything marked for
 ;  deletion that reaches here was input manually.
 ;S X=$$RXDEL^ABSPOS(RXI,RXR) I X D  I X=1 Q
 ;
 ;  If it's been submitted in the past, 
 ;    mention that fact and look at what happened to it.
 ;  case 1:   Payable    or   Duplicate of a paid claim   or  Paper
 ;     Invite a reversal
 ;
 ;   NOTE  for the indefinite interim:
 ;       We don't yet have it set up to invite an easy reversal here.
 ;       We are letting paper claims go through and be resubmitted.
 ;
 ;  case 2:   Not paid
 ;     Allow it to be submitted again here.
 ;
 S X=$$RXPAID^ABSPOSIY(IEN,ENTRY) I X D  I X=1!(X=3) Q
 . I '$G(ECHO) Q  ; not interactive, so just skip it
 . W ?5,"This claim has already been submitted.",!
 . I X=1!(X=3) D
 . . W ?5,"It was an electronic claim and it was "
 . . W $S(X=1:"paid",X=3:"captured."),!
 . I X=2 D
 . . W ?5,"It was flagged to be sent on a paper claim.",!
 . . W ?5,"It will be processed again, as if it had been reversed.",!
 . I X=1 D
 . . W ?5,"You must first reverse the original claim,",!
 . . W ?5,"and then resubmit it.  RES will do it all for you.",!
 . D PRESSANY^ABSPOSU5() ; $$WANTREV^ABSPOSIY not yet implemented
 ;
 ; Not active, not submitted in the past - SUBMIT IT NOW
 ; Create a .59 entry, fill in the pieces
 ;
L59A I '$$LOCK59 G L59A:$$IMPOSS^ABSPOSUE("L","RTI","LOCK transaction for IEN59="_IEN59,,"L59A",$T(+0))
 I $$EXIST59(IEN59) D
 . D CLEAR59(IEN59)
 E  D
L59N . I $$NEW59(IEN59)'=IEN59 G L59N:$$IMPOSS^ABSPOSUE("FM,DB,P","RTI","init new transaction record for IEN59="_IEN59,,"L59N",$T(+0))
 ;I $$SETUP59^ABSPOSIY(IEN59,ORIGIN) S ABSPOSQ1=ABSPOSQ1+1
 I $$SETUP59^ABSPOSIY(IEN59,ORIGIN,ABSPUSR) S ABSPOSQ1=ABSPOSQ1+1 ;IHS/OIT/SCR 081709 patch 34
 D UNLOCK59
 Q
EXIST59(N)         ;
 N X
 S X=$$FIND1^DIC(9002313.59,,"QX","`"_N)
 Q $S(X>0:X,X=0:0)
NEW59(N) ; send N = desired IEN in file 9002313.59
 N FLAGS,FDA,IEN,MSG,X,FN
 S FLAGS="" ; internal values
 N X S X="+1,"
 S FN=9002313.59
 S (IEN(1),FDA(FN,X,.01))=N
 D UPDATE^DIE(FLAGS,"FDA","IEN","MSG")
 I $D(MSG) Q 0
 Q IEN(1)
CLEAR59(N)         ;
 ; deletes all values except the value in the .01 field
 N FN,X,FLAGS,FDA,MSG,FIELD
 S FN=9002313.59,X=N_",",FLAGS=""
 S FIELD=.01 ; $O will skip past this field
 F  S FIELD=$O(^DD(FN,FIELD)) Q:'FIELD  D
 . ; Erase every field except RESULT TEXT, RESUBMIT AFTER REVERSAL
 . I FIELD=202!(FIELD=1.12) D
 . . ;S FDA(FN,X,FIELD)=$E("[Previously: "_$$GET1^DIQ(FN,X,FIELD)_"]",1,200)
 . E  S FDA(FN,X,FIELD)="" ; delete
 D FILE^DIE(FLAGS,"FDA","MSG")
 D PREVISLY(N) ; for result text field 202
 Q
PREVISLY(IEN59)    ;EP ; Bracket result text with [Previously: ], if not null
 ; Called by REVERSE^ABSPOS6D, too
 N X S X=$$GET1^DIQ(9002313.59,IEN59,202)
 Q:X=""
 S X=$E("[Previously: "_X_"]",1,200)
 N FN,FDA,MSG S FDA(9002313.59,IEN59_",",202)=X
PR5 D FILE^DIE("","FDA","MSG") Q:'$D(MSG)
 D ZWRITE^ABSPOS("FDA","MSG","IEN59","X")
 G PR5:$$IMPOSS^ABSPOSUE("FM","TRI","FILE^DIE failed",,"PREVISLY",$T(+0))
 Q
ACTIVE59(N)        ; is ^ABSPT(N) active now?
 F  Q:$$LOCK59  Q:'$$IMPOSS^ABSPOSUE("L","RTI","LOCK of transaction for IEN59="_IEN59,,"ACTIVE59",$T(+0))
 N Z S Z=$G(^ABSPT(N,0))
 D UNLOCK59
 I Z="" Q 0 ; easy - there's no such record
 I $P(Z,U,2)=99 Q 0 ; status = complete
 I $$TIMEDIFI^ABSPOSUD($P(Z,U,8),$$NOW)>604800 Q 0  ; Must have been stranded over a week?  Let it through.
 Q 1 ; status not complete
NOW() N %,%H,%I,X D NOW^%DTC Q %
QUICK51(IEN,ENTRY)          ; ^ABSP(9002313.51,IEN,2,ENTRY,...)
 N X
 S X=^ABSP(9002313.51,IEN,2,ENTRY,0)
 W $P(X,U,4)," ",$P(X,U,2)," ",$P(X,U,5)," ",$P(X,U,7),!
 W !
 Q
