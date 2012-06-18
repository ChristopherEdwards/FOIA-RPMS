ABSPOSBB ; IHS/FCS/DRS - POS billing - new ;        [ 03/14/2003  11:18 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**6,7,11,14,19,22,28,31,36,37,38,39**;JUN 21, 2001
 ;
 ; When a transaction completes, POSTING^ABSPOSBB is called
 ; (the transaction completion happens in ^ABSPOSU)
 ;  [Indirectly - via background job (ABSPOSBD).
 ;   Transaction completion merely sets flag (ABSPOSBC)]
 ;
 ; You get ABSP57, pointer into ^ABSPTL(ABSP57,
 ; from whence comes all the transaction details.
 ;
 ; Your posting routine is called by $$.
 ; The result is stuffed into Field .15, POSTED TO A/R.
 ; It's a free text field.  Use it in any way your interface desires.
 ;
 Q
POSTING ; EP - for _all_ billing interfaces - with ABSP57
 ; Based on the billing interface, call the right routine.
 N X S X=$$ARSYSTEM^ABSPOSB
 N RESULT
 I X=0 D
 . S RESULT=$$POST^ABSPOSBW ; FSI/ILC A/R Versions 1 and 2
 E  I X=1 D
 . S RESULT="" ; none
 E  I X=2 D
 . S RESULT=$$POST^ABSPOSBT ; ANMC nightly checker
 E  I X=3 D
 . S RESULT=$$THIRD ; IHS Third Party Billing
 E  I X=4 D
 . S RESULT=$$POST^ABSPOSBP ; PAC Patient Accounts Component (BBM*)
 E  I X=99 D
 . S RESULT=$$POST^ABSPOSBQ ; other A/R (needs to fill in ABSPOSBQ)
 E  D
 . S RESULT=""
 . ; not a supported billing system interface
 ; Flag the 9002313.57 entry as having been processed by billing.
 I RESULT]"" D
 . N FDA,IEN,MSG
 . S FDA(9002313.57,ABSP57_",",.15)=RESULT
 . D FILE^DIE(,"FDA","MSG")
 Q
 ; *********************************************************************
THIRD()  ; IHS Third Party Billing ; ABSP*1.0T7*6  entire paragraph is new
 N TX
 S TX=ABSP57
 N INSDFN,AMT,PATDFN,RXI,PRV,VDATE,CLINIC,LOC,ACCT,DISP,UNIT,QTY
 N DRUG,NDC,RXR,CAT,INSNAM,VSTDFN,DA
 N VMEDDFN
 N ABSPOST ;IHS/OIT/SCR 011210 patch 36
 N ABSPQUIT,ABSPRJCT ;IHS/OIT/SCR 020110 patch 37
 N ABSPARAM   ;IHS/OIT/CNI/SCR 052610 patch 39 - PARAMETER added to keep rejects from going to 3PB
 S ABSPARAM=$$GET1^DIQ(9002313.99,1,170.02,"I")      ; 
 S VSTDFN=$P($G(^ABSPTL(TX,0)),U,7)         ; IEN to Visit file
 Q:'VSTDFN ""                             ; No visit on this transaction
 S RXR=$$GET1^DIQ(9002313.57,TX,9,"I")      ; IEN refill Mult of RX file
 S RXI=$$GET1^DIQ(9002313.57,TX,1.11,"I")   ; IEN Prescription (RX) file
 S INSDFN=$$GET1^DIQ(9002313.57,TX,1.06,"I")  ; IEN to Insurer file
 I 'INSDFN QUIT ""                          ; No ins on this transaction
 ;Get VMEDDFN
 I RXR D
 . S VMEDDFN=$P($G(^PSRX(RXI,1,RXR,999999911)),U)    ;refill
 E  D
 . S VMEDDFN=$P($G(^PSRX(RXI,999999911)),U)          ;first fill
 ; CAT Should get value of E PAYABLE, E CAPTURED, E REJECTED
 ; Non-electronic ones will usually return as PAPER
 S CAT=$$CATEG^ABSPOSUC(TX,1)               ; Transaction category
 ; Posting of paper claims, next couple of lines
 ; Special only for assistance in setting up Training curriculum
 ; though it could be turned on for any site which so wishes.
 ; The "-22" in the next line is a memorial to 
 ; the Great File Number Fiasco of Two Thousand Aught One
 ; I paper claims and posting of paper claims allowed, G POSTIT,
 ; else quit
 ;I CAT="PAPER" G POSTIT:$$GET1^DIQ(9002335.99-22,"1,",235.04,"I") Q ""
 I CAT="PAPER" D POSTIT:$$GET1^DIQ(9002335.99-22,"1,",235.04,"I") Q ""
 ; I paper claims and posting of paper claims allowed, D REVERSIT
 I CAT="PAPER REVERSAL" D  Q DA
 . S DA=""
 . I $$GET1^DIQ(9002313.99,"1,",235.04,"I") D REVERSIT
 I CAT'?1"E ".E Q ""                        ; Not electronic claims
 ;I CAT["REJECTED" Q ""                     ; Rejected claim
 ;IHS/OIT/SCR 020110 patch 37 START send additional REJECTED information to 3PB
 ;I CAT["REJECTED" D  Q ""
 S ABSPQUIT=0
 I CAT["REJECTED" D
 . ;I CAT="E REJECTED" D VMEDSTAT(VMEDDFN,2)   ; 2 = POS Rejected
 . D VMEDSTAT(VMEDDFN,2)   ; 2 = POS Rejected
 . I ABSPARAM'="Y" S ABSPQUIT=1 Q   ;IHS/OIT/CNI/SCR patch 39 if the paramater is not 'Y' DON'T SEND
 . S ABSPQUIT=1 Q   ;IHS/OIT/CNI/SCR 072310 patch 39 don't send ANY reject info to 3PB until ok'd by federal lead - THEN remove this line  
 . I ABSPARAM="Y" D
 . .N ABSPRSP,ABSPPOS,ABSPREJS,ABSPCNT
 . .S ABSPRSP=$P($G(^ABSPTL(TX,0)),U,5)
 . .S ABSPPOS=$P($G(^ABSPTL(TX,0)),U,9)
 . .D REJTEXT^ABSPOS03(ABSPRSP,ABSPPOS,.ABSPREJS)
 . .;This populates ABSPREJS(n) with code:text format of each rejection for this position in this response
 . .S ABSPRJCT("RJCTIME")=$P($G(^ABSPR(ABSPRSP,0)),"^",2)
 . .S ABSPCNT=0
 . .F  S ABSPCNT=$O(ABSPREJS(ABSPCNT)) Q:(ABSPCNT=""!ABSPQUIT)  D
 . . .S ABSPRJCT(ABSPCNT,"CODE")=$P(ABSPREJS(ABSPCNT),":",1)
 . . .I ABSPRJCT(ABSPCNT,"CODE")="85" S ABSPQUIT=1 ;85 Claim Not Processed
 . . .I ABSPRJCT(ABSPCNT,"CODE")="95" S ABSPQUIT=1 ;95 Time Out
 . . .I ABSPRJCT(ABSPCNT,"CODE")="96" S ABSPQUIT=1 ;96 Scheduled Downtime
 . . .I ABSPRJCT(ABSPCNT,"CODE")="97" S ABSPQUIT=1 ;97 Payer Unavailable
 . . .I ABSPRJCT(ABSPCNT,"CODE")="98" S ABSPQUIT=1 ;98 Connection to Payer is Down
 . . .I ABSPRJCT(ABSPCNT,"CODE")="R8" S ABSPQUIT=1 ;R8 Syntax Error
 . . .S ABSPRJCT(ABSPCNT,"REASON")=$P(ABSPREJS(ABSPCNT),":",2)
 Q:ABSPQUIT 0  ;DON'T SEND UN-PROCESSED REJECTIONS TO 3PB - return used update free-text .14 field in ABSPT
 ;IHS/OIT/SCR 020110 patch 37 END  send additional REJECTED information to 3PB
 I CAT["DUPLICATE" D  Q:'$$TIMEOUT ""
 . I CAT="E DUPLICATE" D VMEDSTAT(VMEDDFN,1)  ; 1 = POS Billed
 I CAT["REVERSAL ACCEPTED" D REVERSIT Q DA  ; Post reversal to A/R
 I CAT="E CAPTURED" D VMEDSTAT(VMEDDFN,2)     ; 2 = POS Rejected
 I CAT="E PAYABLE" D VMEDSTAT(VMEDDFN,1)      ; 1 = POS Billed
 ;IHS/OIT/SCR 011210 patch 36 start changes                                 ; Create 3PB Bill
 S ABSPOST=$$POSTIT(.ABSPRJCT)
 Q ABSPOST
 ;IHS/OIT/SCR 011210 patch 36 end changes
REVERSIT  ; sets DA on its way out ; ABSP*1.0T7*6 ; entire paragraph is new
 N PRVTX,DIE,DR
 S PRVTX=$$PREVIOUS(TX)                     ; Prev trans for RX & refill
 I 'PRVTX S DA="" Q                         ; No previous transaction
 S DA=$P($G(^ABSPTL(PRVTX,0)),U,15)         ; A/R bill  [DUZ(2),IEN]
 Q:'DA                                      ; A/R bill not specified
 S RXI=$P(^ABSPTL(PRVTX,1),U,11)            ; IEN to Prescripton file
 S ABSPRX=$$GET1^DIQ(52,RXI,.01)            ; RX #
 Q:'ABSPRX                                  ; No RX
 ; if posted ABSPWOFF will be DUZ(2),IEN  (DA) of A/R bill; else null
 S ABSP("CREDIT")=$$GET1^DIQ(9002313.57,PRVTX,505)  ; $$ to reverse
 S ABSP("ARLOC")=DA                         ; A/R Bill location
 S ABSP("TRAN TYPE")=43                     ; Adjustment
 S ABSP("ADJ CAT")=3                        ; Write off
 S ABSP("ADJ TYPE")=135                     ; Billed in error
 S ABSP("USER")=$$GET1^DIQ(9002313.57,PRVTX,13)  ; User who entered tran
 N LOC,VISDT
 S LOC=$$GET1^DIQ(9000010,VSTDFN,.06,"I")   ; Location of Encounter
 S VISDT=$P($P(^AUPNVSIT(VSTDFN,0),U,1),".",1)  ; Visit Date
 D LOG^ABSPOSL("Reversing transaction "_ABSP57_".")
 ;RLT - 11/20/07 - Patch 23 - remove call to A/R
 ;S ABSPWOFF=$$EN^BARPSAPI(.ABSP)            ; Call published A/R API
 ;S ABSCAN=$$CAN^ABMPSAPI(ABSPWOFF)          ; Cancel bill in 3PB ABSP*1.0T7*11
 ;IHS/OIT/SCR 4/17/08 Patch 31 START changes to pass RXREASON for cancellation
 N ABSPRXRN
 S ABSPRXRN=$$GET1^DIQ(9002313.57,TX,404)  ; RXREASON in ABSP LOG OF TRANSACTION file
 ;S ABSCAN=$$CAN^ABMPSAPI(ABSP("ARLOC"))  ;commented out and replaced by line below        
 ;Cancel bill in 3PB  - ABSP*1.0T7*11 
 S ABSCAN=$$CAN^ABMPSAPI(ABSP("ARLOC"),ABSPRXRN)
 ;Cancel bill in 3PB and pass 'reason' from Pharmacy 7.0
 ;IHS/OIT/SCR 4/17/08 Patch 31 END changes
 D SETFLAG^ABSPOSBC(ABSP57,0) ; clear the "needs billing" flag
 ;S DA=ABSPWOFF
 S DA=ABSP("ARLOC")
 Q
POSTIT(ABSPRJCT)  ; ABSP*1.0T7*6 ; entire paragraph is new
 N ABSPOST ;IHS/OIT/SCR 011210 patch 36
 N ABSPCNT ;IHS/OIT/SCR 020210 patch 37
 S ABSP(.21)=$$GET1^DIQ(9002313.57,TX,505)       ; Total price
 S ABSP(.23)=ABSP(.21)
 S ABSP(.05)=$$GET1^DIQ(9002313.57,TX,5,"I")     ; IEN to Patient file
 S ABSP(.71)=$P($P(^AUPNVSIT(VSTDFN,0),U,1),".",1)  ; Visit Date
 S ABSP(.72)=ABSP(.71)
 S ABSP(.1)=$$GET1^DIQ(9000010,VSTDFN,.08,"I")   ; IEN to Clinic Stop
 S ABSP(.03)=$$GET1^DIQ(9000010,VSTDFN,.06,"I")  ; Location of Encounter
 I ABSP(.03)="" D  Q ""  ;IHS/OIT/SCR 122809 patch 36 - if no location of Encounter, don't pass to 3PB
 .D SETFLAG^ABSPOSBC(ABSP57,0) ; clear the "needs billing" flag'
 .Q
 S ABSP(.08)=INSDFN
 S ABSP(.58)=$$GET1^DIQ(9002313.57,TX,1.09)     ; Prior Authorization
 S ABSP(.14)=$$GET1^DIQ(9002313.57,TX,13,"I")   ; User
 S ABSP(11,.01)=VSTDFN  ; VISIT IEN IHS/OIT/SCR 020210 send patch 37
 S ABSP(41,.01)=$S(RXI:$$GET1^DIQ(52,RXI,4,"I"),1:"") ; Provider
 S ABSP(23,.01)=$$GET1^DIQ(9002313.57,TX,"1.11:DRUG","I") ; IEN to Drug File
 S ABSP(23,.03)=$$GET1^DIQ(9002313.57,TX,501)   ; Quantity
 S ABSP(23,.04)=$$GET1^DIQ(9002313.57,TX,502)   ; Unit Price
 S ABSP(23,.05)=$$GET1^DIQ(9002313.57,TX,504)   ; Dispensing Fee
 S ABSP(23,.07)=$$GET1^DIQ(9002313.57,TX,507)   ; Incentive Amount
 S ABSP(23,19)=$$GET1^DIQ(9002313.57,TX,10403)  ; New/Refill code
 S RXI=$$GET1^DIQ(9002313.57,TX,1.11,"I")
 S ABSP(23,.06)=$$GET1^DIQ(52,RXI,.01)          ; Prescription
 S ABSP(23,14)=$$GET1^DIQ(9002313.57,TX,10401)  ; Date filled
 S ABSP(23,20)=$$GET1^DIQ(9002313.57,TX,10405)  ; Days supply
 ;IHS/OIT/SCR 020210 patch 37 send reject information
 I $G(ABSPRJCT("RJCTIME")) D
 .S ABSPCNT=0
 .S ABSP(73,"REJDATE")=$G(ABSPRJCT("RJCTIME"))
 .F  S ABSPCNT=$O(ABSPRJCT(ABSPCNT)) Q:ABSPCNT="RJCTIME"  D
 .. S ABSP(73,ABSPCNT,"CODE")=ABSPRJCT(ABSPCNT,"CODE")
 .. S ABSP(73,ABSPCNT,"REASON")=ABSPRJCT(ABSPCNT,"REASON")
 .. Q
 .Q
 ;IHS/OIT/CNI/SCR patch 39 072310 START next four lines support for COB payer indicator field
 N ABSP59,ABSPPTYP
 S ABSP59=$$GET1^DIQ(9002313.57,TX,.01)
 S ABSPPTYP=$E($P(ABSP59,".",2),1,1)
 S ABSP(99,0)=$S(ABSPPTYP=2:"S",ABSPPTYP=3:"T",1:"")    ; COB payer indicator - NULL for primary, S for secondary, T for tertiary 
 ;IHS/SD/lwj 08/31/05 patch 14 nxt ln remkd out, following 3 added
 ;S ABSP("OTHIDENT")="0"_RXI  ;can't assume we need to add a 0
 S ABSP("OTHIDENT")=RXI
 S:$L(RXI)>7 ABSP("OTHIDENT")=$E(RXI,$L(RXI)-6,$L(RXI))
 S ABSP("OTHIDENT")=$$NFF^ABSPECFM($G(ABSP("OTHIDENT")),7)
 ;IHS/SD/lwj 08/31/05 end changes
 D LOG^ABSPOSL("Posting transaction "_ABSP57_".")
 S ABSPOST=$$EN^ABMPSAPI(.ABSP) ; Call published 3PB API
 D SETFLAG^ABSPOSBC(ABSP57,0) ; clear the "needs billing" flag
 S DA=ABSPOST
UPDT ;
 Q DA
ZW(%) D ZW^ABSPOSB(%)
 Q
PREVIOUS(N57) ;EP -
 ; Get Previous transaction for this RX and Refill
 ; N57 = TX = IEN to Log of Transactions file (A/R Posting)
 N RXI,RXR
 S RXI=$P(^ABSPTL(N57,1),U,11)          ; IEN to Prescripton file
 S RXR=$P(^ABSPTL(N57,1),U)             ; IEN Refill mult of RX file
 I RXI=""!(RXR="") Q ""                 ; if either value is blank Q
 Q $O(^ABSPTL("NON-FILEMAN","RXIRXR",RXI,RXR,N57),-1)
LAST57(RXI,RXR) ;EP -
 Q $O(^ABSPTL("NON-FILEMAN","RXIRXR",RXI,RXR,""),-1)
TIMEOUT()          ;IHS/SD/lwj 3/14/03 Timed out payable claims?
 ; Following the conversion to 5.1, EDS/OK Medicaid had problems
 ; with their connection timing out with WebMD.  EDS/OK Medicaid 
 ; would process the claim, BUT, POS would get the time out
 ; response from WebMD (EV-16).  When the claim is resubmitted in
 ; POS, if it was payable, OK Medicaid would respond with duplicate.
 ; Duplicates don't normally pass to 3rd party/ A/R, so we had to 
 ; add extra code to look for this unique condition.
 ;
 ; Here's what we check when the response is duplicate:
 ;   *  We check to make sure the previous claim did not post to A/R
 ;   *  We check to make sure the previous claim was not reversed
 ;   *  We make sure the previous claim timed out with a EV-16
 ;   *  We check the version for 5.1
 ;   *  IHS/SD/lwj 7/7/04 patch 11 we now check for processor timeout
 ; If all this checks out, we want to post it to 3rd Party and A/R
 N ABSPENT,ABSPREC,ABSPRC,ABSPRP,ABSPMSG
 N PRCTO    ;IHS/SD/lwj 7/7/04 patch 11 processor timeout
 S ABSPENT=$P($G(^ABSPTL(TX,0)),U)   ;entry # to use in b x-ref
 S ABSPREC=$O(^ABSPTL("B",ABSPENT,TX),-1)   ;get the previous trans
 ;IHS/SD/lwj 09/29/03 patch 7 line added below
 Q:ABSPREC="" ""  ;we don't have record of the dup claim - quit
 Q:$P($G(^ABSPTL(ABSPREC,0)),U,15)'="" ""   ;already posted
 Q:$P($G(^ABSPTL(ABSPREC,4)),U)'="" ""      ;prev one reversed
 S ABSPRC=$P($G(^ABSPTL(TX,0)),U,5)         ;current trans
 Q:$P($G(^ABSPR(ABSPRC,100)),U,2)'[5 ""     ;not a 5.1 trans
 S ABSPRP=$P($G(^ABSPTL(ABSPREC,0)),U,5)    ;prev response
 ;IHS/SD/lwj 09/29/03 patch 7 line added below
 Q:ABSPRP="" ""  ;no prev response - quit
 Q:$P($G(^ABSPR(ABSPRP,100)),U,2)'[5 ""     ;not a 5.1 trans
 S ABSPMSG=$P($G(^ABSPR(ABSPRP,504)),U)      ;message
 ;IHS/SD/lwj 7/7/04 next 2 lines added for patch 11
 S PRCTO=0
 S PRCTO=$$PROCTMOT(ABSPRP,ABSPREC)    ;processor time out?
 ;IHS/SD/lwj 7/7/04 patch 11 nxt ln rmkd out, following added
 ;Q:$G(ABSPMSG)'["EV16" ""                   ;not a time out
 Q:(($G(ABSPMSG)'["EV16")&('PRCTO)) ""       ;not a time out
 ; from this point, looks like a time out that needs posting
 Q 1
PROCTMOT(ABSPRP,ABSPREC) ;IHS/SD/lwj 7/7/04 need to check to see if the
 ; processor timed out - this is a different response from
 ; the switch time out
 ;       ABSPPIC - rx order within response
 ;       ABSPRXR - rej codes per rx
 ;       ABSPTIMO - time out ind for resp
 ;       ABSPRP - prev resp IEN (passed in)
 ;       ABSPREC - prev log of tran IEN
 N ABSPTIMO,ABSPRXR,ABSPPIC
 Q:(ABSPRP="")!(ABSPREC="")  ;must have to process
 S (ABSPTIMO,ABSPRXR)=0     ;assume no tm out/init loop to 0
 S ABSPPIC=$$GET1^DIQ(9002313.57,ABSPREC,14,"I")  ;pos in prv clm/resp
 I ABSPPIC="" Q ABSPTIMO  ;IHS/OIT/SCR 05/07/09 avoid undefined error
 F  S ABSPRXR=$O(^ABSPR(ABSPRP,1000,ABSPPIC,511,ABSPRXR)) Q:'+ABSPRXR  D
 . S:$P($G(^ABSPR(ABSPRP,1000,ABSPPIC,511,ABSPRXR,0)),U)=95 ABSPTIMO=1
 Q ABSPTIMO
VMEDSTAT(VMEDDFN,STAT) ;
 ;Populates POINT OF SALE BILLING STATUS (#1106) field in the 
 ;V MEDICATION file (#9000010.14).
 ;NULL = NOT POS Billed
 ;1 = POS Billed
 ;2 = POS Rejected
 Q:VMEDDFN=""                  ;quit if no pointer to the vmed file
 Q:'$D(^DD(9000010.14,1106))   ;quit if no field 1106 in vmed file
 S DIE=9000010.14,DA=VMEDDFN,DR="1106///^S X=STAT"
 D ^DIE
 Q
