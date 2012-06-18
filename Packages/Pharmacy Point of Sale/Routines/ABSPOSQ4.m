ABSPOSQ4 ; IHS/FCS/DRS - Process responses ;       [ 10/07/2002  10:36 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3,6,31**;JUN 21, 2001
 ; Called from ABSPOSQ3 at RESPONSE()
 ;
 ; What's here:  the main LOOP and several miscellaneous subroutines,
 ;  many of which are called from outside.
 ;
 ;  The meat of the response packet processing is in RESPONSE^ABSPOSQL
 ;   and its subroutines, ONE, ONE1, RESP1
 ;
 ;---------------------------------------------------------
 ;IHS/SD/lwj 10/07/02  NCPDP 5.1 changes
 ; The responses are exactly the same between 5.1 and 3.2 - we needed
 ; to add new logic to RESP1000 and RESPMSG to capture the newer
 ; information
 ;
 ;----------------------------------------------------------
 ;IHS/SD/lwj 6/10/03 Patch 6 - insurer sleep override
 ; Usually a rejection code of 99 on a claim indicates that
 ; the insurer/processor is not able to accept or process
 ; claims at this time.  POS puts the insurer in a sleep state
 ; and probes the insurer for response.  This was done to cut
 ; cost and traffic from sending claims when the insurer is down.
 ; Unfortunately, some insurers send the 99 to reflect that the
 ; patient simply isn't on their plan - this was causing the insurer
 ; to stay in a permanent sleep state.  Changes were made to REJSLEEP
 ; to check a new flag in the insurer file (101.07 99 REJECT SLEEP
 ; OVERRIDE) - when set, we will not put the insurer to sleep,
 ; even when we get a rejection of 99.
 ;---------------------------------------------------------
 Q
EN ; the task from ABSPOSQ3 starts here
 ; for a specific DIALOUT         
 ; Q4WAIT might be defined, too
 I '$G(Q4WAIT),'$O(^ABSPECX("POS",DIALOUT,"R",0)) Q  ; not waiting; nothing ready
 N A,B,BLIMIT,ODIALOUT,GOTLOCK ; "O" as in "Original"
 S ODIALOUT=DIALOUT,BLIMIT=$G(Q4WAIT,10)
 D INIT^ABSPOSL(.11)
 D LOG($T(+0)_" - Job "_$J_" processing POS responses.")
LOOP ;
 ; The task may have been started before the responses were ready yet.
 ; For example, it may have been started before dialing - figure up
 ; to a minute before something might be available.
 S B=0 F A=5:5:BLIMIT D  Q:B
 . S B=$O(^ABSPECX("POS",DIALOUT,"R","")) Q:B
 . HANG 2+$R(6) ; averages out to 5 seconds between checking 
 I 'B G LOOP7  ; no responses ready for this DIALOUT
LOOP1 ;
 D LOG($T(+0)_" - Processing responses for DIALOUT="_DIALOUT)
 L +^TMP("ABSPOSQ4",DIALOUT):5 ; only one job per DIALOUT (overcautious)
 S GOTLOCK=$T
 I GOTLOCK D
 . D RESPONSE^ABSPOSQL(DIALOUT) ; process all responses for this DIALOUT
 . L -^TMP("ABSPOSQ4",DIALOUT)
 . D LOG($T(+0)_" - Done for DIALOUT="_DIALOUT)
 E  D  G LOOP9
 . D LOG($T(+0)_" - couldn't get LOCK?  Another one already running?")
 . D TASKAT^ABSPOSQ3($$TADDNOW^ABSPOSUD(.0002)) ; try again in 2 mins.
LOOP7 S DIALOUT=$$ANYRESPS(0) ; any others for anybody else we can do now?
 I DIALOUT G LOOP1
 I B S DIALOUT=ODIALOUT,BLIMIT=10 G LOOP ; worth looping back to check original
LOOP9 D LOG($T(+0)_" - Job "_$J_" completed.")
 D RELSLOT^ABSPOSL
 ; If there are any Status 19's, rev up a processor to rescue them
 I $D(^ABSPT("AD",19)) D TASK^ABSPOSIZ ; ABSPOSQ1
 Q
LOG(X) D LOG^ABSPOSL(X) Q
ANYRESPS(DIALOUT) ;EP - ABSPOS2D ;
 ; are there any responses waiting to be processed?
 ; Also called from POKE^ABSPOSUD
 I $G(DIALOUT) Q $S($O(^ABSPECX("POS",DIALOUT,"R","")):DIALOUT,1:0)
 ; DIALOUT not given, so look for any DIALOUTs that need work
 ; If any waiting, return DIALOUT where there are
 ; Else return ""
 N SET,RET S (SET,RET)=0
 F  S SET=$O(^ABSP(9002313.55,SET)) Q:'SET  I $$ANYRESPS(SET) S RET=SET Q
 Q RET
 ; 
 ; The following are separate little utilities called from elsewhere.
 ;
PAID(IEN59) ;EP - ABSPOSQS ;quick query to see if it's paid
 N TMP D RESPINFO(IEN59,.TMP) Q:'$D(TMP("RSP")) 0
 N X S X=TMP("RSP")
 I X="Payable" Q 1
 ;I X="Captured" Q .5 ; should we?
 Q 0
RESPINFO(RXI,DST) ;EP - ABSPOS6B,ABSPOSNC,ABSPOSUA
 ; quick way to get all the response info for a given RXI
 ; IMPORTANT!!  D not change spelling, case, wording, or spacing!!!
 ; Callers such as ABSPOSNC are depending on the exact DST("RSP")
 ; If a reversal was attempted, it complicates things.
 ;  fills DST array as follows:
 ; DST("HDR")=Response Status (header)
 ; DST("RSP")=Response Status (prescription)
 ;   This could be:  "Payable"  "Rejected"  "Captured"  "Duplicate" 
 ;   or  "Accepted reversal"  or  "Rejected reversal"
 ;   or  "null"   or "null reversal"  (no response or corrupt response
 ;    or maybe someone without insurance, so no request was sent)
 ; DST("REJ",0)=count of reject codes
 ; DST("REJ",n)=each reject code
 ; DST("MSG")=message with the response
 ; All of these are defined, even if originals were '$D.
 ; The external forms are returned.
 N REVERSAL S REVERSAL=$G(^ABSPT(RXI,4))>0
 N RESP
 I 'REVERSAL S RESP=$P(^ABSPT(RXI,0),U,5)
 E  S RESP=$P(^ABSPT(RXI,4),U,2)
 Q:'RESP
 N POS S POS=$P(^ABSPT(RXI,0),U,9) Q:'POS
 N FMT S FMT="E"
 S DST("HDR")=$$RESP500(RESP,FMT)
 S DST("RSP")=$$RESP1000(RESP,POS,FMT)
 S DST("REJ",0)=$$REJCOUNT(RESP,POS,FMT)
 I DST("REJ",0) D
 .N I F I=1:1:DST("REJ",0) S DST("REJ",I)=$$REJCODE(RESP,POS,I,FMT)
 S DST("MSG")=$$RESPMSG(RESP,POS,FMT)
 ; Dealing with oddities of PCS (and others'?) response to reversals
 I REVERSAL,DST("RSP")["null" D
 .I DST("RSP")["null" S DST("RSP")=DST("HDR")_" reversal"
 Q
 ; In the following quickies:
 ; RESP = RESPIEN, pointer to 9002313.03
 ; FMT = "I" for internal, "E" for external, defaults to internal
RESP500(RESP,FMT) ;EP - ABSPOS57,ABSPOSP2,ABSPOSUC
 ; returns the response header status
 N X S X=$P($G(^ABSPR(RESP,500)),U)
 I $G(FMT)'="E" Q X
 I X="" S X="null"
 S X=$S(X="A":"Accepted",X="R":"Rejected",1:"?"_X)
 Q X
RESP1000(RESP,POS,FMT) ;EP - ABSPOSP2,ABSPOSUC
 ; returns the prescription response status
 ; Note!  Could be DP or DC for duplicates
 N X S X=$P($G(^ABSPR(RESP,1000,POS,500)),U)
 I $G(FMT)'="E" Q X
 I X="" S X="null"
 ;
 ;IHS/SD/lwj 10/07/02 NCPDP 5.1 changes - they will send an "A" back
 ; now on the transaction level to indicate that it has been accepted
 ; Next code line remarked out - following added
 ;
 ;S X=$S(X="P":"Payable",X="R":"Rejected",X="C":"Captured",X="D"!(X="DP")!(X="DC"):"Duplicate",1:"?"_X)
 S X=$S(X="A":"Accepted",X="P":"Payable",X="R":"Rejected",X="C":"Captured",X="D"!(X="DP")!(X="DC"):"Duplicate",1:"?"_X)
 Q X
REJCOUNT(RESP,POS,FMT) ; returns rejection count
 Q +$P($G(^ABSPR(RESP,1000,POS,511,0)),U,3)
REJCODE(RESP,POS,N,FMT)          ; returns Nth rejection code
 ; if FMT="E", returns code:text
 N CODE S CODE=$P($G(^ABSPR(RESP,1000,POS,511,N,0)),U)
 I CODE="" S CODE="null"
 I FMT'="E" Q CODE
 N X S X=$O(^ABSPF(9002313.93,"B",CODE,0))
 I X]"" S CODE=CODE_":"_$P($G(^ABSPF(9002313.93,X,0)),U,2)
 E  S CODE="?"_CODE
 Q CODE
 ;
 ;IHS/SD/lwj 10/07/02 NCPDP 5.1 changes - message may not come
 ; back in 504 - may come back in 526 instead
 ;
RESPMSG(RESP,POS,FMT)  ; response message - additional text from insurer
 ;
 N MSG
 S MSG=""
 S MSG=$G(^ABSPR(RESP,1000,POS,504))
 S:MSG="" MSG=$G(^ABSPR(RESP,1000,POS,526))
 ;Q $G(^ABSPR(RESP,1000,POS,504)) 
 Q MSG
 ;
 ;IHS/SD/lwj 10/07/02 end of NCPDP 5.1 changes to RESPMSG
 ;
NOW() N %,%H,%I,X D NOW^%DTC Q %
 ;
 ;  The xxxSLEEP functions are called from ABSPOSQL
 ;
CLRSLEEP(INS,WHY) ;EP - ABSPOSQL
 ; clear insurer sleeping condition
 ; also called from CANCEL^ABSPOSUD
 ; WHY = 1 - we know for sure they're awake now
 Q:$G(INS)=""  ;IHS/OIT/SCR 05/07/09 avoid undefined patch 31
 N X S X=$G(^ABSPEI(INS,101)) Q:'X  ; not asleep
 S $P(X,U)="",$P(X,U,5)="",$P(X,U,6)="",^ABSPEI(INS,101)=X
 I $D(^ABSPT("AD",31)) D
 . D TASK^ABSPOSQ1 ; awaken any other 31s waiting for this insurer
 Q
REJSLEEP(RESP,POS) ;EP - ABSPOSQL
 ; return TRUE if this claim was rejected because the
 ; insurer is sleeping
 ; Reject codes we look for depend on which switch.
 ; Envoy's:
 I $G(^ABSPR(RESP,1000,POS,504))?1"EV16-".E Q 1
 I $G(^ABSPR(RESP,1000,POS,504))?1"EV38-".E Q 1
 I $G(^ABSPR(RESP,1000,POS,504))?1"EV32-".E Q 1
 I $G(^ABSPR(RESP,1000,POS,504))?1"EV25-".E Q 1 ; ABSP*1.0T7*4
 ; NDC's, and theoretically, Envoy too, though they seem to do EV- msgs
 I $O(^ABSPR(RESP,1000,POS,511,"B",90))="" Q 0 ; cheap check
 ; But for a PCS case we see, Code 99 + some code < 90 ; ABSP*1.0T7*2
 ; isn't "asleep" - 99 is something PCS threw in       ; ABSP*1.0T7*2
 ; so require 99 to be accompanied by something <99 too ; ABSP*1.0T7*2
 N RET S RET=0 N I F I=92,93,99 D  Q:RET
 . I $D(^ABSPR(RESP,1000,POS,511,"B",I)) S RET=1
 . Q:I'=99  Q:'RET  ; ABSP*1.0T7*2
 . I I=99,$O(^ABSPR(RESP,1000,POS,511,"B",0))<90 S RET=0 ; ABSP*1.0T7*2
 ;
 ;IHS/SD/lwj 06/10/03 Patch 6 Version 1.0
 ;Check for sleep override - some insurers naturally return a
 ;rejection of 99 - it doesn't mean they're asleep, and we need
 ;to bypass putting them in a sleep state
 ;
 I RET=1 D
 . N ABSPCID,ABSPIID,ABSPSLP
 . S (ABSPCID,ABSPIID,ABSPSLP)=""
 . S ABSPCID=$P($G(^ABSPR(RESP,0)),U)   ;pointer to claim file
 . Q:ABSPCID=""
 . S ABSPIID=$P($G(^ABSPC(ABSPCID,0)),U,2) ;pntr to insurer file
 . Q:ABSPIID=""
 . S ABSPSLP=$P($G(^ABSPEI(ABSPIID,101)),U,7) ;99 rej slp ovr
 . S:ABSPSLP RET=0   ;don't go to sleep
 ;
 ;IHS/SD/lwj 6/10/03 end of changes
 ;
 Q RET
INCSLEEP(INS) ;EP - ABSPOSQL
 ; Increment sleep time for this insurer, if necessary.
 ; Return the scheduled retry time
 N X S X=$G(^ABSPEI(INSURER,101))
 I $P(X,U)<$$NOW D  ; previous retry expired, let's retry:
 . I '$P(X,U,2) S $P(X,U,2)=600 ; base time = 10 minutes
 . I '$P(X,U,3) S $P(X,U,3)=3 ; multiplier
 . I '$P(X,U,4) S $P(X,U,4)=2.5*60*60 ; max wait time ; 2.5 hrs
 . I '$P(X,U,5) S $P(X,U,5)=$P(X,U,2) ; current wait time (either init
 . E  S $P(X,U,5)=$P(X,U,5)*$P(X,U,3) ;      or multiply)
 . S $P(X,U,5)=$P(X,U,5)\1
 . S:$P(X,U,5)>$P(X,U,4) $P(X,U,5)=$P(X,U,4) ; apply max if needed
 . S $P(X,U)=$$TADDNOWS^ABSPOSUD($P(X,U,5)) ; set retry time
 . S ^ABSPEI(INSURER,101)=X
 . D TASKAT^ABSPOSQ1($P(X,U)) ; ABSPOSQ2 will run again upon expiry
 . D TASK^ABSPOSQ1 ; and run it again right away, too, to stamp new times on the others in status 31
 Q $P(X,U)
