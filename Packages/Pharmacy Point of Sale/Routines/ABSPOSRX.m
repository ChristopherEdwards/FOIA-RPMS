ABSPOSRX ; IHS/FCS/DRS - callable from RPMS pharm ;     [ 01/21/2003  8:40 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3,4,5,31,40**;JUN 21, 2001
 Q
 ;
 ; Also used by other ABSPOSR* routines to find transactions
 ; that need to be submitted to Point of Sale.
 ;
 ;------------------------------------------------------
 ; IHS/SD/lwj 11/25/02  change in the task subroutine
 ; There was a strange problem at Benewah only where the
 ; tasking to task man from "claim" was not functioning properly.
 ; The claim would task, but nothing would happen, and the task
 ; would disappear from taskman.  If the same site deleted or
 ; editted the prescription, the same task code would work 
 ; perfect.  No other site has ever reported this problem and
 ; the biggest difference is ILC software running under the
 ; same name space at Benewah.  To get around the problem
 ; we altered TASK to new everything.  This worked, so we are
 ; keeping the fix in the package.  This fix was generated
 ; by Patrick Cox of Oklahoma.
 ;
 ;-------
 ;IHS/SD/lwj 1/9/03 the new we added in November caused our
 ; "other" sites (i.e. not Benewah) problems with their posting.
 ; It turns out that the DUZ wasn't always being submitted with the
 ; task.  The DUZ is required for the posting to 3rd party, so when
 ; it wasn't there, it didn't post correctly.  Altered the new to do
 ; everything BUT the DUZ.
 ;------------------------------------------------------------
 ;
 ;-------
 ;IHS/OIT/SCR 4/17/09 patch 31
 ; MOREDATA("RXREASON") is defined and set in Outpatient Pharmacy 7.0
 ; when an prescription has been reversed and provides one of three
 ; possible reason for the reversal:
 ; 
 ;    Prescription logically deleted
 ;    Returned to stock.
 ;    Reversal caused by edit.
 ;
 ; MOREDATA("RXREASON") is only defined for 'UNCLAIM' transaction types
 ; 
DOCU N I,X F I=0:1 S X=$T(DOCU1+I) Q:X["END OF DOCUMENTATION"  D
 . W $P(X,";",2,99),!
 Q
DOCU1 ; There are only four callable entry points!
 ; $$CLAIM^ABSPOSRX     Submit a claim to Point of Sale
 ; $$UNCLAIM^ABSPOSRX   Reverse a previously submitted claim.   
 ; $$STATUS^ABSPOSRX    Inquire about a claim's status
 ; SHOWQ^ABSPOSRX    Display queue of claims to be processed
 ;
 ;  All of these routines may be called in either $$ or DO forms,
 ;  even though the individual descriptions speak only of $$ form,
 ;  The RXI argument is required - a pointer to ^PSRX(*
 ;  The RXR argument is optional - a pointer to ^PSRX(RXI,1,*
 ;     If RXR is omitted, the first fill is assumed.
 ;  Should have MOREDATA("ORIGIN")
 ;     = undefined - if caller is RPMS Pharmacy package
 ;     = some assigned value - for all other callers
 ;
 ; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
 ; $$CLAIM^ABSPOSRX - submit a claim to Point of Sale
 ;
 ;    $$CLAIM^ABSPOSRX(RXI,RXR,.MOREDATA)
 ;    Submit a claim to point of sale
 ;    Use, for example, when a prescription is released.
 ;    All this does is to put it on a list and start a background job.
 ;    Return values:
 ;       1 = accepted for processing
 ;       0^reason = failure (should never happen)
 ;
 ;    Note:  If the claim has already been processed, and it's 
 ;       resubmitted, then a reversal will be done first,
 ;       and then the resubmit will be done.   Intervening calls
 ;       to $$STATUS may show progress of the reversal before
 ;       the resubmitted claim is processed.
 ; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
 ; $$UNCLAIM^ABSPOSRX   Reverse a previously submitted claim.   
 ;     Use, for example, if a prescription has been canceled.
 ;
 ;    $$UNCLAIM^ABSPOSRX(RXI,RXR,.MOREDATA)
 ;     Return value = 1 = will submit request for reversal
 ;                  = 0^reason = failure (should never happen)
 ;
 ;     Note:  The reversal will actually be done ONLY if the
 ;     most recent processing of the claim resulted in something
 ;     reversible, namely  E PAYABLE or PAPER
 ; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
 ; $$STATUS^ABSPOSRX    inquire about a claim's status
 ;
 ;    $$STATUS^ABSPOSRX(RXI,RXR)
 ;    Returns     result^time^description
 ;    Returns null  if there's no POS record of this RXI,RXR.
 ;
 ;    result is IN PROGRESS, or if the claim is complete,
 ;    result is one of the following:
 ;    E PAYABLE, E REJECTED, E CAPTURED, E DUPLICATE
 ;    E REVERSAL ACCEPTED,  E REVERSAL REJECTED
 ;    E OTHER
 ;    PAPER, PAPER REVERSAL
 ;        (PAPER categories include uninsured patients,
 ;         even beneficiaries, as well as non-electronic insurances)
 ;
 ;    "time" is the Fileman date and time of the last update
 ;     in the status of this claim.
 ;
 ; = = = = = = = = END OF DOCUMENTATION = = = = = = = = =
 ; = = = Everything below this line is for internal use only
 ; = = = and subject to sudden unannounced changes!
 ; = = = Please don't call any of it directly, nor depend on
 ; = = = any of the techniques used.
 ; = = = = = = = = = = = = = = = = = = = = = = = = = = = =
CLAIM(RXI,RXR,MOREDATA)     ;EP - ABSPOSR1
 N RETVAL,STAT,TYPE S TYPE="CLAIM"
 I '$D(RXR) S RXR=0
 I '$$LOCK("SUBMIT") Q 0
 K ^ABSPECP($T(+0),TYPE,RXI,RXR)
 S ^ABSPECP($T(+0),TYPE,RXI,RXR)=$$NOW
 I $D(MOREDATA) M ^ABSPECP($T(+0),TYPE,RXI,RXR,"MOREDATA")=MOREDATA
 D UNLOCK("SUBMIT")
 D RUNNING()
 S RETVAL=1
 Q:$Q RETVAL Q
 ;
UNCLAIM(RXI,RXR,MOREDATA) ;EP - ABSPOSR1 
 N RETVAL,STAT,RESULT,TYPE S TYPE="UNCLAIM"
 I '$D(RXR) S RXR=0
 I '$$LOCK("SUBMIT") Q 0
 K ^ABSPECP($T(+0),TYPE,RXI,RXR)
 S ^ABSPECP($T(+0),TYPE,RXI,RXR)=$$NOW
 I $D(MOREDATA) M ^ABSPECP($T(+0),TYPE,RXI,RXR,"MOREDATA")=MOREDATA
 D UNLOCK("SUBMIT")
 D RUNNING()
 S RETVAL=1
 Q:$Q RETVAL Q
 ;
STATUS(RXI,RXR,MOREDATA) ;EP - ABSPOSRB
 ; 
 N RETVAL
 I '$D(RXR) S RXR=0
 ; Loop: get data, quit if times match (i.e., no change during gather)
 ; Theoretically, though, something could cycle and be missed
 ;  (e.g., from status 50 to status 50 in <1 sec.) in unimaginable
 ; extreme conditions
 N IEN59
 S IEN59=$$IEN59(RXI,RXR)
 I '$D(^ABSPT(IEN59)) Q ""  ; no POS record of this
 N A,C,T1,T2,S1,S2 F  D  I T1=T2,S1=S2 Q
 . S T1=$$LASTUP59(RXI,RXR)
 . S S1=$$STATUS59(RXI,RXR)
 . I S1=99 D  ; completed
 . . S A=$$RESULT59(RXI,RXR)
 . . S C=$$RESTXT59(RXI,RXR)
 . E  D
 . . S A="IN PROGRESS"
 . . S C=$$STATI^ABSPOSU(S1)
 . S T2=$$LASTUP59(RXI,RXR)
 . S S2=$$STATUS59(RXI,RXR)
 Q A_U_T1_U_$E(C,1,255-$L(A)-$L(T1)-2)
SHOWQ G SHOWQ^ABSPOSR2
 ;
 ;    $$EDCLAIM(RXI,RXR,MOREDATA)
 ;    Invoke the point of sale data input screen for this
 ;    prescription and fill.  Use this if you want the opportunity
 ;    to edit the claim data - for example, pre-authorization numbers,
 ;    price overrides, insurance order of billing, etc. 
 ;    The data entry screen is invoked.  The claim can be submitted
 ;    or not, at the user's option, by using Screenman <PF1>E or <PF1>Q
 ;
EDCLAIM(RXI,RXR,MOREDATA)    ;
 I 1 D IMPOSS^ABSPOSUE("P","TI","entry point not available in this release",$P($T(+2),";",3),"EDCLAIM",$T(+0)) Q
 ; for devel & testing, change above to I 0 and add to code below
 N RETVAL S RETVAL=1
 D LOCK
 D UNLOCK
 Q:$Q RETVAL Q
 ;    
NOW() N %,%H,%I,X D NOW^%DTC Q %
 ; $$RESULT59 returns result of a finished claim in .59
 ; Can send RXI and have RXR defaulted
 ;  PAPER or E PAYABLE or E REJECTED or E CAPTURED or E DUPLICATE
 ;  or E OTHER (should never happen)
 ;  or PAPER REVERSAL or E REVERSAL ACCEPTED or E REVERSAL REJECTED
RESULT59(RXI,RXR) ;EP - ABSPOS6D ;  result as defined in CATEG^ABSPOSUC
 N IEN59 I RXI["." S IEN59=RXI
 E  S:'$D(RXR) RXR=$$RXRDEF(RXI) S IEN59=$$IEN59(RXI,RXR)
 Q $$CATEG^ABSPOSUC(IEN59)
RESTXT59(RXI,RXR)  ; result text
 N IEN59 I RXI["." S IEN59=RXI
 E  S:'$D(RXR) RXR=$$RXRDEF(RXI) S IEN59=$$IEN59(RXI,RXR)
 Q $P($G(^ABSPT(IEN59,2)),U,2)
LASTUP59(RXI,RXR) ;EP - ABSPOSR1;  time of last update
 N IEN59 I RXI["." S IEN59=RXI
 E  S:'$D(RXR) RXR=$$RXRDEF(RXI) S IEN59=$$IEN59(RXI,RXR)
 Q $P(^ABSPT(IEN59,0),U,8)
 ;
RXRDEF(RXI) ;EP - ABSPOSNC
 Q +$P($G(^PSRX(RXI,1,0)),U,3) ; highest refill #
 ;
 ;
 ; Utilties
 ;
 ;  LOCKING:  Just one user of this routine at a time.
 ;  X = "SUBMIT" to interlock the claim submission
 ;  X = "BACKGROUND" to interlock the background job
LOCK(X) ;EP - ABSPOSRB
 ;L +^ABSPECP($T(+0),X):300 Q $T
 ;IHS/OIT/PIERAN/RAN 10/12/2010 PATCH 40 no reason for 5 minute timeout on this lock, or use of incremental locking...causing deadlocks at Toiyabe
 L ^ABSPECP($T(+0),X):10 Q $T
LOCKNOW(X) ;EP - ABSPOSRB
 ;L +^ABSPECP($T(+0),X):0 Q $T
 ;IHS/OIT/PIERAN/RAN 10/12/2010 PATCH 40 no reason for use of incremental locking...causing deadlocks at Toiyabe
 L ^ABSPECP($T(+0),X):0 Q $T
UNLOCK(X) ;EP - ABSPOSRB
 L -^ABSPECP($T(+0),X) Q
LOCK59() L +^ABSPT:10 Q $T
UNLOCK59 L -^ABSPT Q
 ;
RUNNING()          ;
 ;I '$$LOCKNOW("BACKGROUND") Q  ; it is running; don't start another
 ;D UNLOCK("BACKGROUND") ; it's not running; release our probing lock
 ;IHS/OIT/PIERAN/RAN Patch 40...checking locks is not a good way to verify something isn't running
 I $P(+$G(^ABSP(9002313.99,1,"ABSPOSRX")),"^") Q  ; it is running; don't start another
 D TASK
 H 1 ; wait a second after starting a task - so you don't clog task
 ; manager with too many of these (especially from back billing)
 ; it's possible for extras to start during this window of time
 ; that's okay, they'll die right away when they can't get the lock
 Q
IEN59(RXI,RXR) ;EP - from ABSPOS,ABSPOSNC,ABSPOSRB
 Q RXI_"."_$TR($J(RXR,4)," ","0")_"1"
 ; 
 ; $$STATUS59 returns processing status from .59 record
 ; "" if there's no such claim    note: 99 means complete
 ;
STATUS59(RXI,RXR)  N IEN59,STAT
 I RXI["." S IEN59=RXI
 E  S:'$D(RXR) RXR=$$RXRDEF(RXI) S IEN59=$$IEN59(RXI,RXR)
 N LOCKED59 S LOCKED59=$$LOCK59
 N STAT S STAT=$P($G(^ABSPT(IEN59,0)),U,2)
 I LOCKED59 D UNLOCK59
 Q STAT
 ; 
 ; The background job
 ;
 ;IHS/SD/lwj 11/25/02  details in top of program - N command
 ; added on next line.
 ;IHS/SD/lwj 1/9/03 the "N" on the next line was remarked out
 ; following line was added to replace it.
TASK ;N    ;IHS/SD/lwj 11/25/02 newing everything
 N (DUZ)    ;IHS/SD/lwj 1/9/03 newing everything except the DUZ
 N X,Y,%DT S X="N",%DT="ST" D ^%DT D TASKAT(Y) Q
TASKAT(ZTDTH)      ;N (DUZ,ZTDTH) ; Exclusive NEW verboten
 N ZTIO S ZTIO="" ; no device
 N ZTRTN S ZTRTN="BACKGR^ABSPOSRB" D ^%ZTLOAD Q
LASTLOG ; tool for test - find and print most recent log file
 N X S X=999999999999
 F  S X=$O(^ABSPECP("LOG",X),-1) Q:'X  Q:X#1=.4
 I 'X W "No log file found",! Q
 D PRINTLOG^ABSPOSL(X)
 Q
