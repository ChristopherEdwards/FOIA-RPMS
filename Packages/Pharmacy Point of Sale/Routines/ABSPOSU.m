ABSPOSU ; IHS/FCS/DRS - utilities ;     
 ;;1.0;PHARMACY POINT OF SALE;;JUN 21, 2001
 Q
 ; some common utilities called a lot.
 ;
 ; SETSTAT - set status field for ^ABSPT(ABSBRXI,
 ;
SETSTAT(STATUS) ;EP - from many places
 ; set ^ABSPT( status for ABSBRXI
 ;
 ; Timing problem:  if response got processed before the SETCSTAT
 ; was sent for "waiting to process response",  don't reset it now.
 I STATUS=80,$P(^ABSPT(ABSBRXI,0),U,2)>80 Q
 ;
 ; Perhaps other such detection would be a good idea here.
 ;
 ; LOCK the file - something is very wrong if you can't get the lock
 F  L +^ABSPT:300 Q:$T  Q:'$$IMPOSS^ABSPOSUE("L","RTI","LOCK +^ABSPT",,"SETSTAT",$T(+0))
 N DIE,DA,DR,X S DIE=9002313.59,DA=ABSBRXI,DR="1///"_STATUS_";7///NOW"
 I STATUS=0 S DR=DR_";15///NOW" ; START TIME, too.
 ;I STATUS=0 W "Before: ",$G(^ABSPT(ABSBRXI,0)),!
 D ^DIE
 ;I STATUS=0 W "After: ",$G(^ABSPT(ABSBRXI,0)),!
 ; Extra: make sure it's not in any index with any other status.
 ; We got one such corrupted index once and got infinite loop
 ; in a background job - it was a terrifying day.
 ; This consumes machine time but saves huge queue corruption headache.
 N X S X="" F  S X=$O(^ABSPT("AD",X)) Q:X=""  D
 .I X'=STATUS K ^ABSPT("AD",X,ABSBRXI)
 I STATUS=99 D STATUS99
 L -^ABSPT
 Q
STATUS99 ; special activity when a claim reaches status 99
 ; Transaction log in .57  (but not if it's a canceled transaction!)
 I $P($G(^ABSPT(ABSBRXI,3)),U,2) D
 .  ; canceled - shouldn't we restore old .57 into this .59?
 . D LOG^ABSPOSL($T(+0)_" - Cancellation succeeded.")
 E  D
 . N ABSP57 S ABSP57=$$NEW57(ABSBRXI)
 . D TRANSACT^ABSPOSBC(ABSP57) ; hand it to posting
 . D RECEIPT(ABSP57) ; automatic receipt printing
 ; Possible reverse-then-resubmit
 I $P(^ABSPT(ABSBRXI,1),U,12)=1 D
 . N OLDSLOT,SLOT S OLDSLOT=$$GETSLOT^ABSPOSL
 . S SLOT=ABSBRXI D SETSLOT^ABSPOSL(SLOT)
 . D LOG^ABSPOSL($T(+0)_" Reverse then Resubmit attempt:")
 . ; reverse, then resubmit
 . N X S X=$$CATEG^ABSPOSUC(ABSBRXI)
 . ; it must be a successful reversal
 . I X'="E REVERSAL ACCEPTED",X'="PAPER REVERSAL" D
 . . D LOG^ABSPOSL($T(+0)_" Cannot - reversal failed - "_X)
 . E  D
 . . S $P(^ABSPT(ABSBRXI,1),U,12)=0 ; clear the flag
 . . D LOG^ABSPOSL($T(+0)_" Now resubmit")
 . . D RESUB1^ABSPOS6D(ABSBRXI) ; resubmit it
 . . D TASK^ABSPOSIZ ; and start background processing
 . D RELSLOT^ABSPOSL
 . I OLDSLOT D SETSLOT^ABSPOSL(OLDSLOT)
 ; And at random times, winnow the log files 
 I $R(10000)=0 D
 . N ZTRTN,ZTIO,ZTSAVE,ZTDTH
 . ; I $R(10)=0 winnow everything? INCOMPLETE - future
 . S ZTRTN="SILENT^ABSPOSK(1)"
 . S ZTIO="",ZTDTH=$$TADD^ABSPOSUD(DT,1)_".0222" ; tomorrow early a.m.
 . D ^%ZTLOAD
 Q
 ;
NEW57(RXI) ;EP - copy this ^ABSPT(RXI) into ^ABSPTL(N)
 F  L +^ABSPTL:300 Q:$T  Q:'$$IMPOSS^ABSPOSUE("L","RTI","LOCK ^ABSPTL",,"NEW57",$T(+0))
NEW57A N N S N=$P(^ABSPTL(0),U,3)+1
 N C S C=$P(^ABSPTL(0),U,4)+1
 S $P(^ABSPTL(0),U,3,4)=N_U_C
 I $D(^ABSPTL(N)) G NEW57A ; should never happen
 L -^ABSPTL
 M ^ABSPTL(N)=^ABSPT(RXI)
 ;
 ; Indexing - First, fileman indexing
 D
 . N DIK,DA S DIK="^ABSPTL(",DA=N N N D IX1^DIK
 ;
 ; The NON-FILEMAN index on RXI,RXR
 D
 . N INDEX,A,B,TYPE S TYPE=$E(RXI,$L(RXI))
 . I TYPE=1!(TYPE=2) D
 . . S A=$P(^ABSPTL(N,1),U,11)
 . . S B=$P(^ABSPTL(N,1),U)
 . . S INDEX=$S(TYPE=1:"RXIRXR",TYPE=2:"POSTAGE")
 . E  I TYPE=3 D
 . . S A=$P(^ABSPTL(N,0),U,7)
 . . S B=$P(^ABSPTL(N,1),U,3) ; VCPT
 . . S B=$P(^ABSVCPT(9002301,B,0),U) ; CPT IEN
 . . S INDEX="OTHERS"
 . E  D IMPOSS^ABSPOSUE("DB,P","TI","Bad TYPE="_TYPE,"in RXI="_RXI,"NEW57",$T(+0))
 . S ^ABSPTL("NON-FILEMAN",INDEX,A,B,N)=""
 Q N
 ; $$PREV57(point to 57) returns pointer to previous transaction
 ; for the same RXI,RXR - returns "" if no such
PREV57(N57) ; EP -
 N RXI,RXR S RXI=$P(^ABSPTL(N57,1),U,11)
 S RXR=$P(^ABSPTL(N57,1),U)
 I RXI=""!(RXR="") Q ""
 Q $O(^ABSPTL("NON-FILEMAN","RXIRXR",RXI,RXR,N57),-1)
 ;
 ; SETCSTAT - set the status for every prescription associated with
 ; this claim
 ;
SETCSTAT(CLAIM,STATUS)       ;EP - ABSPOSAM
 N ABSBRXI
 I $$ISREVERS(CLAIM) D  Q  ; different for reversals
 .S ABSBRXI=$$RXI4REV(CLAIM) I ABSBRXI D SETSTAT(STATUS)
 S ABSBRXI=""
 F  S ABSBRXI=$O(^ABSPT("AE",CLAIM,ABSBRXI)) Q:ABSBRXI=""  D
 .D SETSTAT(STATUS)
 Q
ISREVERS(CLAIM) ;EP - ABSPOSP2
 ; is this a reversal claim?  $$ returns 1 or 0
 Q $P($G(^ABSPC(CLAIM,100)),"^",3)=11
RXI4REV(REVCLAIM)  ; given IEN of reversal claim $$this to get RXI
 ; The reversal claim must be associated with exactly one RXI.
 N RET,MBN ; MBN=Must Be Null
 S RET=$O(^ABSPT("AER",REVCLAIM,0)),MBN=$O(^(RET))
 ; Uncomment the next line when doing certification tests! (ABSPOSC*)
 ;Q RET
 I 'RET D IMPOSS^ABSPOSUE("DB,P","TI","REVCLAIM="_REVCLAIM_" and ""AER"" index",,"RXI4REV",$T(+0)) ; may not apply to certification testing!! SEE ABOVE.
 I MBN'="" D IMPOSS^ABSPOSUE("DB,P","TI","REVCLAIM="_REVCLAIM_" points back to multiple .59 entries",,"RXI4REV",$T(+0))
 Q RET
 ;
 ; SETCOMMS - for each prescription associated with this claim,
 ; point back to the log of the comms session wherein xmit/rcv happened
 ;
SETCOMMS(CLAIM,POINTER) ;EP - ABSPOSAM
 N ABSBRXI S ABSBRXI=""
 F  S ABSBRXI=$O(^ABSPT("AE",CLAIM,ABSBRXI)) Q:ABSBRXI=""  D
 .S $P(^ABSPT(ABSBRXI,0),"^",12)=POINTER
 Q
 ;
 ; SETRESU - Set Result  into ^ABSPT(ABSBRXI,2)
 ;
 ;    NOTE !!! NOTE !!! NOTE !!!  ABSBRXI must be set (not RXI) !!!
 ;
SETRESU(RESULT,TEXT)    ;EP - from many places
 S $P(^ABSPT(ABSBRXI,2),U)=RESULT
 I $G(TEXT)]"" D
 .N X,Y S X=^ABSPT(ABSBRXI,2)
 .S Y=$P(X,U),X=$P(X,U,2,$L(X,U))
 .I X="" S X=$E(TEXT,1,255-$L(Y)-1)
 .E  S X=$E(TEXT_X,1,255-$L(Y)-1)
 .S ^ABSPT(ABSBRXI,2)=Y_U_X
 I RESULT=0 Q  ; look at the associated RESPONSE in ^ABSPR(
 ;
 ; For other RESULT codes, put a textual explanation in 
 Q
 ;
 ; SETCRESU - set the result code for every prescription assoc'd with
 ; this claim
SETCRESU(CLAIM,RESULT,TEXT) ;
 N ABSBRXI S ABSBRXI=""
 F  S ABSBRXI=$O(^ABSPT("AE",CLAIM,ABSBRXI)) Q:ABSBRXI=""  D
 .D SETRESU(RESULT,$G(TEXT))
 Q
 ;
 ; STATI(X) gives a text version of what status code X means.
 ;
STATI(X) ;EP - from many places ; perhaps should be a Fileman file
 I X=99 Q "Done"
 I X=50 Q "Waiting for transmit"
 I X=30 Q "Waiting for packet build"
 I X=0 Q "Waiting to start"
 I X=10 Q "Gathering claim info"
 I X=40 Q "Packet being built"
 I X=60 Q "Transmitting"
 I X=70 Q "Receiving response"
 I X=80 Q "Waiting to process response"
 I X=90 Q "Processing response"
 I X=51 Q "Wait for retry (comms error)"
 I X=31 Q "Wait for retry (insurer asleep)"
 I X=19 Q "Special grouping"
 ; When you add new X=, account for these in FETSTAT^ABSPOS2
 Q "?"_X_"?"
 ;
 ; RESULTI(X) gives a text version of what result code X means
 ;
RESULTI(X)         ;
 I X=0 Q "See detail in ABSP RESPONSES file" ; say more
 Q "Result code "_X ; a catch-all default
 ;
RECEIPT(IEN57) ; This is where the receipt would go - taskman it to print in
 ; background, somewhere, somehow
 Q:'$$DORECEI
 ; Lookup printer for this pharmacy.
 ; If none, lookup printer for this system, in general.
 ; Also customizable:  routine for each pharmacy, each system.
 ; Otherwise, a default-default routine for general receipt.
 ; 
 ;S ZTIO=$P($G(^%ZIS(1,X,0)),U) Q:ZTIO=""
 ;S X="N",%DT="ST" D ^%DT S ZTDTH=Y
 ;S ZTRTN=""
 ;S ZTSAVE("ClaimIEN")=""
 ;D ^%ZTLOAD Q
 Q
DORECEI() ; Should we print a receipt? 
 ; Site-specific conditions needed.
 ; example:  electronic claims only;
 ;   only claims with co-pay;
 ;   etc.
 Q 0
