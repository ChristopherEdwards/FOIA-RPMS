BARFPST5 ; IHS/SD/LSL - A/R FLAT RATE POSTING ; 12/22/2008
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**6,10,21,23**;OCT 26, 2005
 ;;
DOC ;
 ; LSL - 01/01/2000 - Created routine
 ;       Contains code for POSTING, EDITING, CANCELLING, or QUITING
 ;       Bills from A/R FLAT RATE POSTING
 ;
 ; IHS/ASDS/LSL - 06/29/00 - v1.3
 ;       Mark bills for rollback capabilities.  Set BARROLL array 
 ;       during posting process.  Call EN^BARROLL after posting 
 ;       complete.  BARRAYGO needs to be defined as well. (Currently,
 ;       it will be set to 0 as we don't allow "Roll over as you go".)
 ;
 ; IHS/ASDS/LSL - 06/29/00 - V1.3
 ;     Added tag ROLFIX to mark bills for rollback that were posted
 ;     before the above change.
 ;
 ; ITSC/SD/LSL - 10/21/02 - V1.7 - NOIS QAA-1200-130051
 ;     Added quit logic in PSTBIL if error getting A/R Transaction
 ;;
 Q
 ; *********************************************************************
ACTION ; EP
 ; EP - Posting and review bills section.
 ;IHS/SD/TPF BAR*1.8*21 8/3/2011 HEAT20490
 I $$NOTOPEN^BARUFUT(.DUZ,$G(UFMSESID)) D NOSESS Q  ;IS SESSION STILL OPEN
 I '+BARFLAG W !!,"You must Review the bills before posting."
 D SELCOM                                   ; Select command (P/R/E/C/Q)
 I '+BARCOMD W !!,"This is a required response.",! G ACTION
 I BARRECPQ="P" D                           ; Posting
 . D POST                                   ; Post FRP bills
 . I BARSTOP=1 S BARRECPQ="E" Q      ; HAS NEGATIVE BAL;MRS:BAR*1.8*6 DD 4.2.5
 . S BARRAYGO=0                      ; "Roll-over as you go flag" to no
 . D EN^BARROLL                             ; Mark bills for roll-over
 I BARRECPQ="R" D REVIEW^BARFPST4 G ACTION  ; Review FRP bills
 I BARRECPQ="E" D FRPBILL^BARFPST3 G ACTION  ; Edit FRP bills
 I BARRECPQ="C" D CANCEL G:'+BARCAN ACTION  ; Cancel FRP entry
 Q
 ; *********************************************************************
SELCOM ;  
 ; Select command (P/R/E/C/Q)
 S BARCOMD=1                   ; "Select Command (P/R/E/C/Q)" Entry Flag
 K DIR
 I '+BARFLAG D                 ; If not review flag, don't allow post
 . S DIR(0)="SAO^R:REVIEW;E:EDIT;C:CANCEL;Q:QUIT"
 . S DIR("A")="Select Command (R/E/C/Q): "
 E  D                          ; If review flag, allow post 
 . S DIR(0)="SAO^P:POST;R:REVIEW;E:EDIT;C:CANCEL;Q:QUIT"
 . S DIR("A")="Select Command (P/R/E/C/Q): "
 D ^DIR
 K DIR
 I $D(DUOUT)!(Y="") S BARCOMD=0  ; Select Command Entry Flag
 S BARRECPQ=$E($G(Y(0)))       ; Users answer to prompt
 Q
 ; *********************************************************************
POST ;    
 ; Post to A/R TRANSACTION/IHS File and bill's history
 S BARTMP=0                    ; Adjustment array flag
 S BARSTOP=""                  ; NEGATIVE BALANCE FLAG MRS:BAR*1.8*6 DD 4.2.5
 S BARSECT=$$VALI^XBDIQ1(200,DUZ,29)  ; Service/Section from NEW PERSON
 I $D(BARPAY) D                ; If payment entered
 . I BARPAY<0,$$IHS^BARUFUT(DUZ(2)) D STOP^BARFPST1 S BARSTOP=1 Q  ;MRS:BAR*1.8*10 D158-3
 . ;;;I BARPAY<0,$$IHSERA^BARUFUT(DUZ(2)) D STOP^BARFPST1 S BARSTOP=1 Q  ;MRS:BAR*1.8*10 D158-3 P.OTT
 . D CKBAL(BARIEN,BARPAY,BARCOL,BARITM) ;CHECK BALANCE;MRS:BAR*1.8*6 DD 4.2.5
 . Q:BARSTOP=1                           ;HAS NEGATIVE BALANCE;MRS:BAR*1.8*6 DD 4.2.5
 . D PSTBIL                    ; Post bills with this payment
 . W !,"Payment of "_$J(BARPAY,9,2)_" posted to "_BARCNT_" bills."
 Q:BARSTOP=1                   ; NEGATIVE BALANCE FLAG MRS:BAR*1.8*6 DD 4.2.5
 I $D(BARADJ) D                ; If Adjustments entered
 . S BARTMP=1                  ; Adjustment array flag  
 . S J=0
 . F  S J=$O(BARADJ(J)) Q:'+J  D  ; For each adjustment...
 . . D PSTBIL                  ; Post bills with this adjustment
 . . W !,"Adjustment category "_$P(BARADJ(J),U,3)_" Type "_$P(BARADJ(J),U,5)_" for "_$J($P(BARADJ(J),U),9,2)_" posted to "_BARCNT_" bills."
 W !,"Done Posting."
 ; Mark FRP Batch as POSTED in A/R FLAT RATE POSTING file
 K DA,DR,DIE
 S DIE="^BARFRP(DUZ(2),"
 S DA=BARIEN
 S DR=".13////P"
 D ^DIE
 I $D(BARNOT) D ERROR Q
 Q
 ; *********************************************************************
PSTBIL ;
 ; Post bills 
 K DA,DR,DIE
 S (BARFRPL,BARCNT)=0
 ; Loop through facilities in A/R FLAT RATE POSTING File
 F  S BARFRPL=$O(^BARFRP(DUZ(2),BARIEN,2,BARFRPL)) Q:'+BARFRPL  D
 . ; IEN to VISIT LOCATION multiple in A/R COLLECTION BATCH
 . S BAREOB=$$VALI^XBDIQ1(90054.0102,"BARIEN,BARFRPL",.01)
 . S K=0
 . ; Loop through bills (within facility) in A/R FLAT RATE POSTING File
 . F  S K=$O(^BARFRP(DUZ(2),BARIEN,2,BARFRPL,3,K)) Q:'+K  D
 . . S BARBLIEN=$P(^BARFRP(DUZ(2),BARIEN,2,BARFRPL,3,K,0),U) ; IEN to A/R BILL
 . . S BARBLPAT=$$VALI^XBDIQ1(90050.01,BARBLIEN,101)  ; A/R Patient IEN
 . . S BARBLAC=$$VALI^XBDIQ1(90050.01,BARBLIEN,3)     ; A/R Account
 . . S BARBLCR=$S(+BARTMP:$P(BARADJ(J),U),'+BARTMP:BARPAY,1:"") ; Credit
 . . S BARTRAN=$S(+BARTMP:43,'+BARTMP:40,1:"")        ; Transaction code
 . . S BARTRIEN=$$NEW^BARTR               ; Create Transaction
 . . ; Populate Transaction file
 . . S DA=BARTRIEN                        ; IEN to A/R TRANSACTION
 . . I BARTRIEN<1 S BARNOT(BARBLIEN,BARTRAN,$S(BARTRAN=43:$G(J),1:99999))="" Q
 . . S BARCNT=BARCNT+1         ; Bill counter
 . . S DIE=90050.03
 . . S DR="2////^S X=BARBLCR"             ; Credit
 . . S DR=DR_";4////^S X=BARBLIEN"        ; A/R Bill
 . . S DR=DR_";5////^S X=BARBLPAT"        ; A/R Patient
 . . S DR=DR_";6////^S X=BARBLAC"         ; A/R Account
 . . S DR=DR_";8////^S X=DUZ(2)"          ; Parent Location
 . . S DR=DR_";9////^S X=DUZ(2)"          ; Parent ASUFAC
 . . S DR=DR_";10////^S X=BARSECT"        ; A/R Section
 . . S DR=DR_";11////^S X=BAREOB"         ; Visit Location
 . . S DR=DR_";12////^S X=$P(BARDT,""."")"  ; Date
 . . S DR=DR_";13////^S X=DUZ"            ; Entry by
 . . S DR=DR_";14////^S X=BARCOL"         ; IEN to A/R COLLECTION BATCH
 . . S DR=DR_";15////^S X=BARITM"         ; IEN to ITEM mult in A/R COL
 . . S DR=DR_";101////^S X=BARTRAN"       ; Transaction Type
 . . I BARTRAN=43 D                       ; If Adjustment
 . . . S DR=DR_";102////^S X=$P(BARADJ(J),U,2)"  ; Adjustment Category
 . . . S DR=DR_";103////^S X=$P(BARADJ(J),U,4)"  ; Adjustment Type
 . . S DIDEL=90050
 . . D ^DIE
 . . K DIDEL,DIE,DA,DR
 . . ; Post from transaction file to related files
 . . D TR^BARTDO(BARTRIEN)
 . . S BARROLL(BARBLIEN)=""               ; Needed for rollback
 Q
 ; *********************************************************************
ERROR ;
 N L,T,A
 W !!!,$$EN^BARVDF("BLN")
 W $$CJ^XLFSTR("The system could not create at least 1 entry in the A/R Transaction File")
 W !,$$CJ^XLFSTR("Please verify postings for the following bills and repost if necessary")
 W $$EN^BARVDF("BLF")
 S L=0
 F  S L=$O(BARNOT(L)) Q:'+L  D
 . S T=0
 . F  S T=$O(BARNOT(L,T)) Q:'+T  D
 . . S A=0
 . . F  S A=$O(BARNOT(L,T,A)) Q:'+A  D
 . . . W !,$$GET1^DIQ(90050.01,L,.01)                     ; Bill
 . . . I T=40 W ?15,"PAYMENT OF ",$J(BARPAY,9,2)
 . . . E  W ?15,$P(BARADJ(A),U,3),", ",$P(BARADJ(A),U,5)," OF ",$J($P(BARADJ(A),U),9,2)
 Q
 ; *********************************************************************
CANCEL ;  
 ; Cancel Entries
 N BARSTAT
 S BARSTAT=$$VALI^XBDIQ1(90054.01,BARIEN,.13)
 I BARSTAT="P" D  Q
 . S BARCAN=0
 . W !,"This FRP Batch has already been posted.  It may not be cancelled"
 S DIR(0)="Y"
 S BARCAN=1
 S DIR("A",2)="Everything entered into the A/R FLAT RATE POSTING file"
 S DIR("A",3)="for Collection Batch "_BARBNM
 S DIR("A",4)="and ITEM "_BARINM_" will be deleted."
 S DIR("A")="Continue"
 S DIR("B")="No"
 D ^DIR
 K DIR
 I Y'=1 S BARCAN=0 Q
 ; Kill Visit Location multiple which will subsequently kill the 
 ; A/R Bill multiple.
NOSESS  ; EP IHS/SD/PKD 1.8*21 Heat20490 3/21/11
 ; Kill Flat Rate Batch if Session not open
 S BARCAN=1
 ; END 1.8*21
 S DA=BARIEN
 S DIK="^BARFRP(DUZ(2),"
 D ^DIK
 Q
 ; *********************************************************************
DELFRP ; EP
 ; EP - Called from MAN,FRD
 D DELFRPE                         ; Get Flat Rate Posting Entry
 I Y<1 D EXIT^BARFPST Q
 D DELFRPD
 Q
 ; *********************************************************************
DELFRPE ;
 ; Get Flat Rate Posting Entry
 W !
 K DIC
 S DIC="^BARFRP(DUZ(2),"
 S DIC(0)="AEMQZ"
 S DIC("A")="Select FRP Batch: "
 S DIC("S")="I $P(^(0),U,13)=""P"""    ; Only posted batches
 D ^DIC
 I Y<1 Q
 S BARIEN=+Y
 S BARNAME=Y(0,0)
 Q
 ; *********************************************************************
DELFRPD ;
 ; Delete FRP Batch
 K DIR
 S DIR(0)="Y"
 S DIR("A")="Delete "_BARNAME
 S DIR("B")="No"
 D ^DIR
 K DIR
 I Y'=1 W !,"Not Deleted." Q
 ; Kill batch
 S DA=BARIEN
 S DIK="^BARFRP(DUZ(2),"
 D ^DIK
 W !,"Deleted!"
 Q
 ; *********************************************************************
ROLFIX ;  
 ; Mark bills for rollback that were posted before the code was
 ; changed to accomodate 6/29/00
 D ^BARVKL0                               ; Kill namespace variables
 K DA,DR,DIE
 S (L,BARCNT,BARIEN,BARRAYGO)=0
 ; Loop through FRP batches (only posted)
 F  S BARIEN=$O(^BARFRP(DUZ(2),BARIEN)) Q:'+BARIEN  D
 . Q:$P($G(^BARFRP(DUZ(2),BARIEN,0)),U,13)'="P"
 . ; Loop through facilities in A/R FLAT RATE POSTING File
 . S L=0
 . F  S L=$O(^BARFRP(DUZ(2),BARIEN,2,L)) Q:'+L  D
 . . ; IEN to VISIT LOCATION multiple in A/R COLLECTION BATCH
 . . S BAREOB=$$VALI^XBDIQ1(90054.0102,"BARIEN,L",.01)
 . . S K=0
 . . ; Loop through bills (within facility) in A/R FLAT RATE POSTING File
 . . F  S K=$O(^BARFRP(DUZ(2),BARIEN,2,L,3,K)) Q:'+K  D
 . . . S BARBLIEN=$P(^BARFRP(DUZ(2),BARIEN,2,L,3,K,0),U) ; IEN to A/R BILL
 . . . Q:$P(^BARBL(DUZ(2),BARBLIEN,2),U,8)]""  ; Q if rollback populated
 . . . S BARROLL(BARBLIEN)=""               ; Needed for rollback
 . . . D EN^BARROLL
 . . . K BARROLL
 D ^BARVKL0
 K DA,DR,DIC,DIE,K,L
 Q
 ; *********************************************************************
CKBAL(BARA,BARPAY,BARCOL,BARITM) ;EP; CHECK IF TX'S WILL CREATE NEGATIVE BALANCE;BAR*1.8*6 DD 4.2.5
 ;ENTERS WITH BARA   = BATCH IEN
 ;            BARPAY = FLAT RATE PAY AMOUNT
 ;            BARCOL = COLLECTION BATCH
 ;            BARITM = COLLECTION BATCH ITEM
 ;
 Q:'$$IHS^BARUFUT(DUZ(2))           ;ONLY CHECK IHS SITES 
 ;;;Q:'$$IHSERA^BARUFUT(DUZ(2)) ;QUIT IF IHS SITE OR TRIBAL WITH RESTRICTED POSTING ;P.OTT
 N BAR,BARF,BARK,BARPTOT,BARMULT
 S BARMULT=+$P(^BAR(90052.06,DUZ(2),DUZ(2),0),U,2)       ;MULTIPLE 3P EOB FLAG
 S (BARF,BARCT,BARPTOT)=0
 ; Loop through facilities in A/R FLAT RATE POSTING File
 F  S BARF=$O(^BARFRP(DUZ(2),BARA,2,BARF)) Q:'+BARF  D
 .; IEN to VISIT LOCATION multiple in A/R COLLECTION BATCH
 .S BAR=$$VALI^XBDIQ1(90054.0102,"BARA,BARF",.01)
 .S BARK=0
 .F  S BARK=$O(^BARFRP(DUZ(2),BARA,2,BARF,3,BARK)) Q:'+BARK  D
 ..S BARCT=BARCT+1
 ..S:BARMULT BAR(BARF,BAR)=$G(BAR(BARF,BAR))+BARPAY
 S BARPTOT=BARCT*BARPAY
 I BARMULT N BAREOB
 D CKCOL^BARPSTU                    ;RETURNS BATCH TOTAL ARRAYS
 I (BARITV(19)-BARPTOT)<0 D STOP("COLLECTION ITEM",(BARITV(19)-BARPTOT))
 I (BARCLV(17)-BARPTOT)<0 D STOP("COLLECTION BATCH",(BARCLV(17)-BARPTOT))
 Q:'BARMULT
 S BARF=0
 F  S BARF=$O(BAR(BARF)) Q:'BARF  D
 .S BAREOB=0
 .F  S BAREOB=$O(BAR(BARF,BAREOB)) Q:'BAREOB  D
 ..D CKCOL^BARPSTU                    ;RETURNS BATCH TOTAL ARRAYS
 ..S BARPTOT=BAR(BARF,BAREOB)
 ..I +$G(BAREOB),(BAREOV(4)-BARPTOT)<0 D
 ...D STOP($P(^AUTTLOC(BAREOB,0),U,2)_" VISIT LOCATION",(BAREOV(4)-BARPTOT))
 Q
 ;
STOP(TYPE,BARDIF) ;EP; BAR*1.8*6 DD 4.2.5
 Q:'$$IHS^BARUFUT(DUZ(2))           ;ONLY CHECK IHS SITES
 ;;;Q:'$$IHSERA^BARUFUT(DUZ(2))           ;Q: IHS OR TRIBAL WITH RESTRICTION ; P.OTT
 W !!,"THE TRANSACTION(S) YOU ARE ATTEMPTING TO POST WILL PUT"
 W !,"THE ",TYPE," INTO A NEGATIVE BALANCE BY $"_-BARDIF
 W:TYPE="BILL" !,"Bill will not be included when posting"
 I TYPE'="BILL" D
 .W !?10,"PLEASE CANCEL, OR USE 'E' TO EDIT THE TRANSACTIONS"
 .W !?15,"TO PREVENT THE NEGATIVE BALANCE"
 S BARSTOP=1
 D EOP^BARUTL(1)
 Q
