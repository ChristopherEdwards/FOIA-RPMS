BARFPST ; IHS/SD/LSL - FLAT RATE POSTING ; 07/08/2008
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**6,21**;OCT 26, 2005
 ;;
DOC ;
 ; LSL - 12/30/1999 - Created routine
 ;       First Flat Rate Posting Routine
 ;       Contains top level logic loop, Batch, Item, and Facility
 ;
 ; IHS/SD/LSL - 02/27/04 - V1.7 Patch 5
 ;      Mark FAC as entry point
 ;;
 Q
 ; *********************************************************************
EN ; EP
 ; EP - Electronic Signature test
 D ^BARVKL0                    ; kill namespace variables
 S BARESIG=""                  ; BAR electronic signature flag
 D SIG^XUSESIG Q:X1=""         ; elec sig test - Q if fail
 S BARESIG=1                   ; passed elec sig test
 I '$D(BARUSR) D INIT^BARUTL   ; Initialize BAR environment
 D FRPBATCH                    ; Look up Flat Rate Post entry
 I $D(BARNEW),'+BARNEW D EXIT Q  ; If not new entry, quit
 ; Ask A/R col batch if not existing FRP
 I '+$G(BARIEN) D BATCH I '+BARBATCH D EXIT Q
 ; -------------------------------
 ;
SELITEM ;
 ; return here if user never enters a facility when multiple 3P EOB
 D ITEM                        ; Select batch item
 I '+BARITEM D EXIT Q          ; Batch item failed
 ; I multiple 3P EOB
 I +$P(^BAR(90052.06,DUZ(2),DUZ(2),0),U,2) D
 . F  D FAC Q:'+BARFAC  D
 . . S BAREOB=+Y               ; IEN to VISIT LOC multiple
 . . D PAYADJD^BARFPST1        ; Display current payment/adjustment
 . . F  D PAYADJ^BARFPST1 Q:BARPA="Q"   ; Ask for payments/adjustments
 . . Q:('$D(BARPAY)&('$D(BARADJ)))  ; No paymnt/adjustments entered
 . . D BARSAV^BARFPST2         ; Save data in FLAT RATE POST File
 . . Q:$D(BARNONE)             ; Entry to FRP file failed
 . . D DISP^BARFPST3           ; Display accum post/balance
 . . D FRPBILL^BARFPST3        ; A/R bill selection
 E  D
 . S BAREOB=DUZ(2)             ; Parent facility
 . D PAYADJD^BARFPST1          ; Display current payment/adjustment
 .;IHS/SD/TPF BAR*1.8*21 8/3/2011 HEAT20490
 .I $$NOTOPEN^BARUFUT(.DUZ,$G(UFMSESID)) Q  ;IS SESSION STILL OPEN
 . F  D PAYADJ^BARFPST1 Q:BARPA="Q"     ; Ask for payments/adjustments
 . Q:('$D(BARPAY)&('$D(BARADJ)))  ; No paymnt/adjustments entered
 . D BARSAV^BARFPST2           ; Save data in FLAT RATE POST File
 . Q:$D(BARNONE)               ; Entry to FRP file failed
 . D DISP^BARFPST3             ; Display accum post/balance
 .;IHS/SD/TPF BAR*1.8*21 8/3/2011 HEAT20490
 .I $$NOTOPEN^BARUFUT(.DUZ,$G(UFMSESID)) Q  ;IS SESSION STILL OPEN
 . D FRPBILL^BARFPST3          ; A/R bill selection
 ;IHS/SD/TPF BAR*1.8*21 8/3/2011 HEAT20490
 I $$NOTOPEN^BARUFUT(.DUZ,$G(UFMSESID)) D EXIT Q  ;IS SESSION STILL OPEN
 ; Q if facility not asked and no payments or adjustments
 I '$D(BARFAC),('$D(BARPAY)&('$D(BARADJ))) D EXIT Q
 I '$D(BARFIEN) G SELITEM
 D ACTION^BARFPST5             ; Posting and reviewing bills.
 D EXIT
 Q
 ; *********************************************************************
 ;
FRPBATCH ;
 ; Look up Flate Rate Posting entry
 K DIC
 S DIC="^BARFRP(DUZ(2),"
 S DIC(0)="AEMQZ"
 S DIC("A")="Select previously opened FRP batch: "
 ; Screen for FRP batches not already posted.
 S DIC("S")="I $P(^(0),U,13)'=""P"""
 D ^DIC
 ; If look up fails, ask if user is creating a new entry
 I Y<1 D NEWFRP Q
 S BARCOL=$P(Y(0),U,4)         ; IEN to A/R COLLECTION BATCH
 I '$$CKDATE^BARPST(BARCOL,1,"SELECT A/R COLLECTION BATCH") D NEWFRP Q  ; OLD BATCH BAR*1.8*6 DD 4.2.4
 S BARIEN=+Y                   ; IEN to A/R FLAT RATE POSTING
 S BARITM=$P(Y(0),U,5)         ; IEN to ITEM Mult of A/R COLLECT BATCH
 S BARNAME=Y(0,0)              ; Name of FRP batch
 S BARBNM=$$VAL^XBDIQ1(90054.01,BARIEN,.04)  ; Collection batch name
 Q
 ; *********************************************************************
 ;
NEWFRP ;
 ; Ask if user wants to create a new Flat Rate Posting entry
 K DIR
 S DIR(0)="Y"
 S DIR("A")="Create new entry"
 S DIR("B")="Yes"
 D ^DIR
 I Y'=1 S BARNEW=0 Q
 S BARNEW=1                    ; Flag for new FRP entry
 Q
 ; *********************************************************************
 ;
BATCH ; EP 
 ; EP - Select Collection Batch
 W !
 K DIC
 S BARBATCH=1                  ; Batch loop flag
 S DIC="^BARCOL(DUZ(2),"
 S DIC(0)="AEZQM"
 S DIC("A")="Select Batch: "
 ; Screen for only postable batches where service/section of user
 ; equals that of batch.
 S DIC("S")="I $P(^(0),U,3)=""P""&($G(BARUSR(29,""I""))=$P(^(0),U,10))"
 ; Write site location next to each selection
 S DIC("W")="D BATW^BARPST"
 D ^DIC
 K DIC
 I Y'>0 S BARBATCH=0 Q         ; Batch loop flag
 S BARCOL=+Y                   ; IEN to A/R COLLECTION BATCH
 I '$$CKDATE^BARPST(BARCOL,1,"SELECT A/R COLLECTION BATCH") S BARBATCH=0 Q  ;MRS:BAR*1.8*6 DD 4.2.4
 S BARBNM=$P(Y(0),U)           ; Collection batch name
 D BBAL^BARPST(BARCOL)         ; Display batch balance and posting total
 Q
 ; *********************************************************************
 ;
ITEM ; EP
 ; EP - Select Batch Item Number
 W !
 S BARITEM=1                   ; Item loop flag
 S DA(1)=BARCOL
 S DIC="^BARCOL(DUZ(2),"_DA(1)_",1,"
 S DIC(0)="AEMQZ"
 S DIC("W")="D DICW^BARPST"    ; Help dislpay
 S DIC("A")="Select Batch Item: "
 S:$D(BARITM) DIC("B")=$$VAL^XBDIQ1(90051.1101,"BARCOL,BARITM",.01)
 ; Screen for all ITEMS not Cancelled or Rolled up
 S DIC("S")="I $P(^(0),U,17)'=""C""&($P(^(0),U,17)'=""R"")"
 D ^DIC
 K DIC
 I +Y<1 S BARITEM=0 Q          ; Item loop flag
 S BARITM=+Y                   ; IEN to ITEM Mult of A/R COLLECT BATCH
 S BARINM=$P(Y(0),U,11)        ; Check number
 D IBAL^BARPST(BARITM)         ; Display item balance and posting total
 Q
 ; *********************************************************************
 ;
FAC ; EP
 ; Select visit location only if Multiple 3P EOB site parameter
 ; is set to yes.
 K BAREOB
 W !
 S BARFAC=1                    ; Facility loop flag
 S DA(2)=+BARCOL               ; IEN to A/R COLLECTION
 S DA(1)=+BARITM               ; IEN to ITEM multiple
 D ^XBSFGBL(90051.1101601,.BARGL)  ; Format global structure
 S DIC=$P(BARGL,"DA,",1)
 S DIC(0)="AEMQZ"
 S DIC("W")="W ?20,$J($P(^(0),U,2),8,2)"
 S DIC("A")="Select Visit Location: "
 D ^DIC
 K DIC
 I +Y<1 S BARFAC=0             ; Facility loop flag
 Q
 ; *********************************************************************
 ;
EXIT ; EP
 ; EP - Exit, kill local variables
 D ^BARVKL0                    ; kill namespace variables
 Q
