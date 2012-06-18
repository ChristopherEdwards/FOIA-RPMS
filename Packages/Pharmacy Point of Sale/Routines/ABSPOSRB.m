ABSPOSRB ; IHS/FCS/DRS - background from ABSPOSRX ;      
 ;;1.0;PHARMACY POINT OF SALE;**31,32,40,41**;JUN 21, 2001
 Q
BACKGR ;
 ;I '$$LOCKNOW^ABSPOSRX("BACKGROUND") Q
 ;IHS/OIT/PIERAN/RAN Patch 40 10/13/2010 checking locks is not a good way to verify something isn't running! Added next two lines
 I $P(+$G(^ABSP(9002313.99,1,"ABSPOSRX")),"^") Q  ; it is running; dont start another
 S ^ABSP(9002313.99,1,"ABSPOSRX")=1_U_$H   ;Note that it is running so no other processes try to run it till we're done
 N BACKSLOT S BACKSLOT=DT+.4
 D INIT^ABSPOSL(BACKSLOT,1,-1)
 N LIST,TYPE,RXI,RXR S LIST="ABSPOSRX"
 I '$$LOCK^ABSPOSRX("BACKGROUND") D  G FAIL
 . D LOG^ABSPOSL("Failed to $$LOCK^ABSPOSRX(""BACKGROUND"")")
 F TYPE="CLAIM","UNCLAIM" D
 . S RXI="" F  S RXI=$O(^ABSPECP(LIST,TYPE,RXI)) Q:RXI=""  D
 . . S RXR="" F  S RXR=$O(^ABSPECP(LIST,TYPE,RXI,RXR)) Q:RXR=""  D
 . . . N X S X=$$STATUS(RXI,RXR)
 . . . I $P(X,U)="IN PROGRESS" D  Q
 . . . . D LOG^ABSPOSL(RXI_","_RXR_" in progress; wait")
 . . . N TIME,MOREDATA
 . . . S TIME=^ABSPECP(LIST,TYPE,RXI,RXR) ; time requested
 . . . I '$$LOCK^ABSPOSRX("SUBMIT") D  Q
 . . . . D LOG^ABSPOSL("Failed to $$LOCK^ABSPOSRX(""SUBMIT"") for RXI="_RXI_",RXR="_RXR)
 . . . I $D(^ABSPECP(LIST,TYPE,RXI,RXR,"MOREDATA")) M MOREDATA=^("MOREDATA")
 . . . E  S MOREDATA=0
 . . . K ^ABSPECP(LIST,TYPE,RXI,RXR)
 . . . D BACKGR1(TYPE,RXI,RXR,TIME,.MOREDATA)
 . . . D UNLOCK^ABSPOSRX("SUBMIT")
 . . . ;IHS/OIT/PIERAN/RAN Patch 40 10/15/2010 This hang is completely unnecessary and is the reason it stays locked so long
 . . . ;D HANG
FAIL D RELSLOT^ABSPOSL
 D UNLOCK^ABSPOSRX("BACKGROUND")
 ;IHS/OIT/PIERAN/RAN Patch 40 10/20/2010 checking locks is not a good way to verify something isn't running! Added next line
 S ^ABSP(9002313.99,1,"ABSPOSRX")=0_U_$H   ;Note that it is no longer running so other processes can access
 Q
STARTTIM(RXI,RXR)  Q $P($G(^ABSPT($$IEN59(RXI,RXR),0)),U,11)
BACKGLOG(X) ;
 N MSG S MSG=RXI_","_RXR_" "_$S(TYPE="CLAIM":"",1:TYPE)_" "_X
 D LOG2SLOT^ABSPOSL(MSG,BACKSLOT)
 Q
BACKGR1(TYPE,RXI,RXR,TIME,MOREDATA)        ;
 ; Resolve multiple requests
 N SKIP S SKIP=0 ; skip if you already got desired result
 N SKIPREAS
 N RESULT S RESULT=$$STATUS(RXI,RXR),RESULT=$P(RESULT,U)
 N STARTTIM S STARTTIM=$$STARTTIM(RXI,RXR)
 I TYPE="CLAIM" D
 . I $$RXDEL^ABSPOS(RXI,RXR) D  Q
 . . S SKIP=1,SKIPREAS="is marked as DELETED or CANCELLED"
 . ; If it's never been through POS before, good.
 . I RESULT="" Q
 . ; There's already a complete transaction for this RXI,RXR
 . ; (We screened out "IN PROGRESS" earlier)
 . ; The program to poll indexes would have set DO NOT RESUBMIT.
 . ; Calls from pharm pkg to POS have '$D(MOREDATA("DO NOT RESUBMIT"))
 . I $D(MOREDATA("DO NOT RESUBMIT")) D
 . . S SKIP=1
 . . S SKIPREAS="MOREDATA(""DO NOT RESUBMIT"") is set"
 . E  I TIME<STARTTIM D  ; our request was made before trans. began
 . . ; submit claim but only if the prev result was successful reversal
 . . I RESULT="PAPER REVERSAL" Q
 . . I RESULT="E REVERSAL ACCEPTED" Q
 . . S SKIP=1
 . . S SKIPREAS="prev result "_RESULT_"; claim started "_STARTTIM_"<"_TIME_" submitted"
 . E  D  ; our request was made after it began
 . . ; So we will make a reversal if necessary,
 . . ; and then the claim will be resubmitted.
 . . ;IHS/OIT/CASSEVERN/RAN - 02/07/2011 - Patch 41 - Add "E CAPTURED" to types to be reversed.
 . . ;I RESULT="PAPER"!(RESULT="E PAYABLE") D
 . . I RESULT="PAPER"!(RESULT="E PAYABLE")!(RESULT="E CAPTURED") D
 . . . S MOREDATA("REVERSE THEN RESUBMIT")=1
 E  I TYPE="UNCLAIM" D
 . ; It must have gone through POS with a payable result
 . ;IHS/OIT/CASSEVERN/RAN - 02/07/2011 - Patch 41 - Add "E CAPTURED" to types to be reversed.
 . ;I RESULT="PAPER"!(RESULT="E PAYABLE") Q
 . I RESULT="PAPER"!(RESULT="E PAYABLE")!(RESULT="E CAPTURED") Q
 . S SKIP=1
 . S SKIPREAS="cannot reverse - previous result was "_RESULT
 E  D IMPOSS^ABSPOSUE("P","TI","bad arg TYPE="_TYPE,,"BACKGR1",$T(+0))
 I SKIP D  Q
 . D BACKGLOG("SKIP:"_SKIPREAS)
 I TYPE="UNCLAIM"!$G(MOREDATA("REVERSE THEN RESUBMIT")) G BACKGRUN
 N ABSBRXI,ABSBRXR,ABSBNDC
 S (ABSBRXI,ABSBRXI(1))=RXI,(ABSBRXR,ABSBRXR(1))=RXR
 S ABSBNDC(1)=$$DEFNDC^ABSPOSIV
 ;
 ; Caller should have MOREDATA("ORIGIN") set.
 ; except if CLAIM^ABSPOSRX() was called by RPMS pharmacy,
 ; in which case MOREDATA("ORIGIN") is undefined - give it a "1" here.
 I '$D(MOREDATA("ORIGIN")) S MOREDATA("ORIGIN")=1
 D FILING^ABSPOSIV(0,MOREDATA("ORIGIN"))
 D BACKGLOG("initiated")
 Q
BACKGRUN ; reverse RXI,RXR ; (reached by a GOTO from a few lines above)
 N IEN59 S IEN59=$$IEN59(RXI,RXR)
 N M S M="reversal initiated"
 I $G(MOREDATA("REVERSE THEN RESUBMIT")) D
 . ; set flag to say "After reversal is done, resubmit the claim."
 . S $P(^ABSPT(IEN59,1),U,12)=1
 . S M=M_" and after that, claim will be resubmitted"
 ;IHS/OIT/SCR 04/17/09 patch 31 - save MOREDATA("RXREASON") if it exists
 S $P(^ABSPT(IEN59,4),U,4)=$G(MOREDATA("RXREASON"))
 D REVERS59^ABSPOS6D(IEN59,1)
 D BACKGLOG(M)
 Q
LASTLOG ; tool for test - find and print most recent log file
 N X S X=999999999999
 F  S X=$O(^ABSPECP("LOG",X),-1) Q:'X  Q:X#1=.4
 I 'X W "No log file found",! Q
 D PRINTLOG^ABSPOSL(X)
 Q
HANG ; how long to hang before submitting the next claim?
 ; usually not at all (0 secs)
 ; but if there are an extraordinary # of claims in processing,
 ; then wait up a bit before letting anything else through
 ;
 ; FUTURE:  Have to make this smarter - make it aware of how many 
 ; claims have been requested in, say, the past 1 minute as well.
 ; This would be to keep the backbilling from flooding taskman
 ; with excessive ABSPOSQ1 and ABSPOSQ2 jobs which have nothing to
 ; do.  That way, the ABSPOSQ3 jobs would activate more quickly.
 ;
 ; I $H<some date H $R(10) ; put in this line if doing massive backbill
 I $R(50) Q  ; for efficiency - check only once every 50 claims
 N LOCK,MYDEST
HANGA ;
 K MYDEST S LOCK=0 D FETSTAT^ABSPOS2("MYDEST")
 N T,S S T=0 F S=0:10:90 S T=T+$G(MYDEST(S))
 I T<20 Q  ; not too many; that's fine
 H 30 ; wait 30 secs and try again until things have settled down
 G HANGA
IEN59(RXI,RXR)     Q $$IEN59^ABSPOSRX(RXI,RXR)
STATUS(RXI,RXR)    Q $$STATUS^ABSPOSRX(RXI,RXR)
