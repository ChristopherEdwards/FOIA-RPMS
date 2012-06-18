ABSPOSP2 ; IHS/FCS/DRS - EOB to Payments Batch ;   [ 09/12/2002  10:17 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3**;JUN 21, 2001
 ; Payments & Adjustments - ScreenMan front-end to create batch
 ; with parameters to assemble what should match the EOB.
 I DUZ(0)="@" W "Going to the TEST entry point..." H 2 G TEST
 Q
 ;
MAIN ;EP - option ABSP EOB TO BATCH
 Q:$$MUSTILC^ABSPOSB
 N X D
 . N LOCKREF S LOCKREF="^ABSP(9002313.99,1,""EOB-SCREEN"")"
 . L +@LOCKREF:0 I '$T D  S X="" Q
 . . W "Someone else is using the EOB program.",!
 . S X=$$MYSCREEN
 . I X S X=$G(^ABSP(9002313.99,1,"EOB-SCREEN"))
 . E  S X=""
 . L -@LOCKREF
 I X="" W "Nothing done",! H 2 Q  ; didn't get <F1>E
 N PARAMS M PARAMS=^ABSP(9002313.99,1,"EOB-SCREEN")
 ;
 N ROU S ROU=$T(+0)
 ;
 ; Build ^TMP($J,ROU,1,pt9002313.02,pt9002313.03)=""
 ;
 W !,"Please wait... searching our records of POS payments...",!
 D SEARCH
 ;
 ; Build ^TMP($J,ROU,2,PATNAME,DATERECD,RXI,RXR,pt9002313.02,position)
 ;   = amount paid^pt9002313.03
 ; This is to mimic the order of the EOB.
 ; We may need to do different sort orders for different insurers.
 ;
 W !,"Now sorting the payment records...",!
 D SORT
 ;
 W "Creating a payments batch...",!
 N BATCH S BATCH=$$NEWBATCH^ABSPOSP(1)
 I 'BATCH W "Can't create a batch - Stopping",! Q
 W "The batch is payment batch #",BATCH,!
 N PATNAME,DATERECD,RXI,RXR,CLAIM,POSITN,DATA,AMT,RESP
 S PATNAME=""
 F  S PATNAME=$O(^TMP($J,ROU,2,PATNAME)) Q:PATNAME=""  D
 . S DATERECD=""
 . F  S DATERECD=$O(^TMP($J,ROU,2,PATNAME,DATERECD)) Q:DATERECD=""  D
 . . S RXI=""
 . . F  S RXI=$O(^TMP($J,ROU,2,PATNAME,DATERECD,RXI)) Q:RXI=""  D
 . . . S RXR=""
 . . . F  S RXR=$O(^TMP($J,ROU,2,PATNAME,DATERECD,RXI,RXR)) Q:RXR=""  D
 . . . . S CLAIM=""
 . . . . F  S CLAIM=$O(^TMP($J,ROU,2,PATNAME,DATERECD,RXI,RXR,CLAIM)) Q:CLAIM=""  D
 . . . . . S POSITN=""
 . . . . . F  S POSITN=$O(^TMP($J,ROU,2,PATNAME,DATERECD,RXI,RXR,CLAIM,POSITN)) Q:POSITN=""  D
 . . . . . . S DATA=^TMP($J,ROU,2,PATNAME,DATERECD,RXI,RXR,CLAIM,POSITN)
 . . . . . . D ONEPMT
 I $P(PARAMS,U,5) D  ; control total
 . ; Note: do it here at the end - because individual transactions
 . ; each added to total (in ABSPOSP).  But if '$P(PARAMS,U,5),
 . ; then user must not have entered a control total - so just take
 . ; the total of transactions as ABSPOSP tallied them.
 . D SETAMT^ABSPOSP(BATCH,$P(PARAMS,U,5),.04)
 W "Done",!!
 W "Note:  the batch is still open; it is not automatically posted.",!
 W "You are responsible for making sure that you really want",!
 W "to post the batch and that the control total is correct.",!
 D PRESSANY^ABSPOSU5()
 Q
ONEPMT ;
 N PCNDFN S PCNDFN=$P(^ABSPC(CLAIM,0),U,3)
 N AMT S AMT=$P(DATA,U)
 N DEPDATE S DEPDATE=$P(PARAMS,U,4)
 N INSDFN S INSDFN=$P(PARAMS,U)
 I 'PCNDFN D  Q  ; no PCNDFN?!  Put it into unallocated cash
 . W "Unallocated Cash $",$J(AMT,0,2)," for ",PATNAME,!
 . W ?10,"See Claim ID ",$P(^ABSPC(CLAIM,0),U),!
 . S ^ABSTMP(BATCH,"UC")=$G(^ABSTMP(BATCH,"UC"))+AMT
 . ; and you want to put an entry in ^ABSBUC()
 D PAYMENT^ABSPOSP(PCNDFN,BATCH,AMT,INSDFN,DEPDATE)
 Q
SORT K ^TMP($J,ROU,2)
 N PATNAME,DATERECD,RXI,RXR,CLAIM,RESP
 S CLAIM=0
 F  S CLAIM=$O(^TMP($J,ROU,1,CLAIM)) Q:'CLAIM  D
 . I $$ISREVERS^ABSPOSU(CLAIM) Q  ; reversal - elsewhere
 . S RESP=0
 . F  S RESP=$O(^TMP($J,ROU,1,CLAIM,RESP)) Q:'RESP  D SORT1
 Q
SORT1 ;
 I $$RESP500^ABSPOSQ4(RESP,"I")'="A" Q  ; header not accepted
 S PATNAME=$P(^ABSPC(CLAIM,1),U)
 S DATERECD=$P(^ABSPR(RESP,0),U,2)
 S DATERECD=$P(DATERECD,".")
 N POSITN S POSITN=0
 F  S POSITN=$O(^ABSPR(RESP,1000,POSITN)) Q:'POSITN  D
 . I $$RESP1000^ABSPOSQ4(RESP,POSITN,"I")'="P" Q  ; only if Payable
 . ; RXI, RXR as fetched here:
 . ; * They should already be in the EOB's format
 . ; * The RXR does not necessarily correspond to the index into
 . ;   the multiple in ^PSRX(+RXI,1,...)
 . S RXI=$P(^ABSPC(CLAIM,400,POSITN,400),U,2)
 . S RXR=$P(^ABSPC(CLAIM,400,POSITN,400),U,3)
 . N X S X=^ABSPR(RESP,1000,POSITN,500)
 . N AMT S AMT("PATIENT")=$P(X,U,5)
 . S AMT("INGR")=$P(X,U,6),AMT("DISPFEE")=$P(X,U,7)
 . S AMT("TAX")=$P(X,U,8),AMT("TOT")=$P(X,U,9),AMT("COPAY")=$P(X,U,18)
 . S AMT("INCENT")=$P(X,U,21)
 . ; convert signed overpunch numeric mess
 . N X S X="" F  S X=$O(AMT(X)) Q:X=""  I AMT(X)]"",AMT(X)'?1N.N D
 . . S AMT(X)=$$DFF2EXT^ABSPECFM(AMT(X))
 . ; Assemble data value
 . ; we have lots of AMT(*) available; let's go with total amt. for now
 . N DATA S DATA=AMT("TOT")_U_RESP
 . ; Store it!
 . ; But not if the claim was reversed in this same time frame
 . I $$SUCCREV D  Q
 . . ;W "TEMP - ",CLAIM," was successfully reversed by ",$$SUCCREV,!
 . S ^TMP($J,ROU,2,PATNAME,DATERECD,RXI,RXR,CLAIM,POSITN)=DATA
 Q
SUCCREV()     ; was the CLAIM,POSITN in 9002313.02 successfully reversed, ever?
 ; return pointer to 9002313.02 reversal claim if it was
 N CLAIMID S CLAIMID=$P(^ABSPC(CLAIM,0),U)
 N REVID S REVID=CLAIMID_"R"_POSITN
 N REVCLAIM S REVCLAIM=0
 N RETVAL S RETVAL=0 ; assume No
 ; In most cases, this For loop body never runs,
 ; because reversals are relatively uncommon.  
 ; And when it does run, instances of multiple responses should
 ; never really happen, but if they do, just take latest response.
 ; Conceivable only if the reversal was attempted when the 
 ; host was down?
 F  S REVCLAIM=$O(^ABSPC("B",REVID,REVCLAIM)) Q:'REVCLAIM  D
 . ; In oddball case of multiple responses to this claim, take latest
 . N REVRESP S REVRESP=$O(^ABSPR("B",REVCLAIM,""),-1)
 . I 'REVRESP Q  ; got no response?  oh well
 . ; accepted reversal?  you tell by whether header was accepted.
 . I $$RESP500^ABSPOSQ4(REVRESP,"I")="A" S RETVAL=REVCLAIM
 Q RETVAL
SEARCH K ^TMP($J,ROU,1)
 N INSURER S INSURER=$P(PARAMS,U)
 N START S START=$P(PARAMS,U,2)
 N END S END=$P(PARAMS,U,3)
 I $P(END,".",2)="" S $P(END,".",2)="99999999" ; default to entire day
 N DATE S DATE=START
 F  D  S DATE=$O(^ABSPR("AE",DATE)) Q:DATE>END
 . N RESP S RESP=0
 . F  S RESP=$O(^ABSPR("AE",DATE,RESP)) Q:'RESP  D
 . . N CLAIM S CLAIM=$P(^ABSPR(RESP,0),U) Q:'CLAIM
 . . I $P(^ABSPC(CLAIM,0),U,2)'=INSURER Q
 . . ;
 . . ; Yes - the response is from this insurer for this date.
 . . ;
 . . S ^TMP($J,ROU,1,CLAIM,RESP)=""
 Q
MYSCREEN()       ; returns 1 if <F1>E (or the equivalent) was used
 ; if the user quits out (<F1>Q or the equivalent), returns 0
 N DDSFILE,DR,DDSPAGE,DDSPARM
 N DDSCHANG,DDSSAVE,DIMSG,DTOUT
 N DA
 S DDSFILE=9002313.99,DA=1
 S DR="[ABSP EOB TO BATCH]"
AA S DDSPARM="CS"
 D ^DDS
 Q:'$Q
 I $G(DDSSAVE) Q 1
 E  Q 0
TEST ;
 W "Just GOTO MAIN",! H 1
 G MAIN
 W "Outputs:",!
 D ZWRITE^ABSPOS("DDSCHANG","DDSSAVE","DIMSG","DTOUT")
 N X S X=$G(^ABSP(9002313.99,1,"EOB-SCREEN"))
 W "9002313.99,EOB-SCREEN node=",X,!
 Q
