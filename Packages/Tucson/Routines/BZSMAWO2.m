BZSMAWO2 ; IHS/TAO/EDE - WRITE OFF OLD BILLS [ 05/23/2003  7:42 PM ]
 ;;1.0;TUCSON AREA OFFICE W/O;;MAR 14, 2003
 ;
 ; This routine does the actual write off of bills based on
 ; the criteria setup by the calling routine.
 ;
START ; WRITE OFF BILLS
 S BZSDDSV=^DD(9002274.4,3,0) ;          save payment mult dd entry
 S ^DD(9002274.4,3,0)="PAYMENT^9002274.403DA^^3;0" ;set to don't ask
 D LOOPDUZ
 S ^DD(9002274.4,3,0)=BZSDDSV ;          restore to orig
 D EN^XBVK("BAR"),EN^XBVK("AMB")
 Q
 ;
 ;--------------------
LOOPDUZ ; LOOP THRU A/R BILLS BY DUZ(2)
 S BZSDUZ=0
 F  S BZSDUZ=$O(^BARBL(BZSDUZ)) Q:'+BZSDUZ  D LOOPDT
 Q
 ;
 ;--------------------
LOOPDT ; LOOP THRU A/R BILLS BY DATE OF SERVICE
 S BZSVISIT=0
 F  S BZSVISIT=$O(^BARBL(BZSDUZ,"E",BZSVISIT)) Q:'+BZSVISIT  D
 .  Q:BZSVISIT>BZSEDOS  ;               skip dos after end of tf
 .  Q:BZSVISIT<BZSBDOS  ;               skip dos before beginning of tf
 .  D LOOPBIL
 .  Q
 Q
 ;
 ;--------------------
LOOPBIL ; LOOP THRU A/R BILLS FOR SINGLE DATE OF SERVICE
 S BZSBL2=0
 F  S BZSBL2=$O(^BARBL(BZSDUZ,"E",BZSVISIT,BZSBL2)) Q:'+BZSBL2  D WRITEOFF
 Q
 ;
 ;--------------------
WRITEOFF ; WRITE OFF BILLS THAT MEET CRITERIA
 Q:'$D(^BARBL(BZSDUZ,BZSBL2))           ; No bill data
 S BZS(0)=$G(^BARBL(BZSDUZ,BZSBL2,0))   ; A/R Bill 0 node
 S BZS(1)=$G(^BARBL(BZSDUZ,BZSBL2,1))   ; A/R Bill 0 node
 S BZSBAL=$P(BZS(0),U,15)               ; Bill Balance
 S BZSAMT=$P(BZS(0),U,13)               ; Billed Amount
 S BZSVSTL=$P(BZS(1),U,8)               ; Visit location
 ; Q if A/R account is not on bill
 Q:$P(BZS(0),U,3)=""
 ; Q if visit location not in list
 ;I $D(BZS("LOC")),'$D(BZS("LOC",BZSVSTL)) Q
 ; Q if A/R account not in list
 I $D(BZS("ACCT")),'$D(BZS("ACCT",$P(BZS(0),U,3))) Q
 S BZSACT=$P(BZS(0),U,3)                ;A/R Account
 S BZSITYP=$$GET1^DIQ(90050.02,BZSACT,1.08)
 I BZSBAL'>0 D  Q                       ; Don't want 0 or credit bal
 . S ^BZSTMP("BZSAWO",BZSDUZ,DT,DUZ,"CREDIT",BZSBL2)=""
 I BZSAMT>20000 D  Q                    ; May only write-off $20,000
 . S ^BZSTMP("BZSAWO",BZSDUZ,DT,DUZ,"TOO HIGH",BZSBL2)=""
 S DUZ(2)=BZSDUZ
 S BZSTRIEN=$$NEW^BARTR                 ; Create new transaction
 S DA=BZSTRIEN
 S DIE=90050.03
 S DR="2////^S X=BZSBAL"                ; Credit ($$$)
 S DR=DR_";4////^S X=BZSBL2"            ; A/R Bill
 S DR=DR_";5////^S X=$P(BZS(1),U)"      ; A/R Patient
 S DR=DR_";6////^S X=$P(BZS(0),U,3)"    ; A/R Account
 S DR=DR_";8////^S X=DUZ(2)"            ; Parent Location
 S DR=DR_";9////^S X=DUZ(2)"            ; Parent ASUFAC
 S DR=DR_";10////^S X=BZSSECT"          ; A/R Section
 S DR=DR_";11////^S X=$P(BZS(1),U,8)"   ; Visit location
 S DR=DR_";12////^S X=DT"               ; Date
 S DR=DR_";13////^S X=DUZ"              ; A/R Entry by
 S DR=DR_";101////43"                   ; Transaction type (Adj)
 S DR=DR_";102////3"                    ; Adj Category (Write off)
 S DR=DR_";103////1003"                 ; Adj Type (Auto write off)
 S DIDEL=90050
 D ^DIE                                 ; Populate transaction file
 K DIDEL,DIE,DA,DR
 D TR^BARTDO(BZSTRIEN)                  ; Post from Trans to files
 K BZSBL
 S BZSCNT=BZSCNT+1
 W !,$P(BZS(0),U),?25," for ",$J($FN(BZSBAL,",",2),10)," written off."
 S ^BZSTMP("BZSAWO",DT,DUZ,"DONE",BZSBL2)=$P(BZS(0),U)_U_BZSBAL
 D ROLLBILL                             ; Roll info to 3PB
 Q
 ;
 ;--------------------
ROLLBILL ; UPDATE PAYMENT MULTIPLE IN 3P, MARK COMPLETE AND ROLLED
 ; For bills written off, update Payment multiple in 3P and mark bill
 ; complete in 3PB.  Also mark bill as rolled in A/R
 S BARBLDA=BZSBL2
 K BARBL
 D SETVAR^BARROLL                       ; Set A/R vars to roll to 3PB
 D ROLL
 D SETBLRL^BARROLL                      ; Mark bill as rolled
 Q
 ;
 ;--------------------
ROLL ; ROLL A/R VARS TO 3PB
 K DIE,DA,DR
 S BZS3PNM=BARBL(.01)
 S:(BZS3PNM["-") BZS3PNM=$P(BZS3PNM,"-")
 S BZS3PDA=BARBL(17)
 Q:BZS3PDA'>0
 S Y=+BZS3PDA
 S DIC=$$DIC^XBDIQ1(9002274.4)
 S DUZO2=DUZ(2)
 I DIC["DUZ(2)" S DUZ(2)=$P($G(^BARBL(DUZO2,BARBLDA,1)),U,8)
 S:'$D(^ABMDBILL(DUZ(2),"B",BZS3PNM)) DUZ(2)=$P($G(^BARBL(DUZO2,BARBLDA,1)),U,8)
 S Y=Y_"^"_DUZ(2)
 S BZSGBL=DIC_+Y_")"
 I $D(@BZSGBL) D ROLLTPB                ; Roll to 3PB
 S DUZ(2)=DUZO2
 Q
 ;
 ;--------------------
ROLLTPB ; FILE A/R DATA IN PAYMENT MULTIPLE OF 3PB
 M ABM=BARSUM
 S X=Y
 S ABMP("BDFN")=+X                      ; IEN to 3PB BILL
 S ABMP("BILL")=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),"^",1)  ; Bill #
 I ABMP("BILL")'=BZS3PNM D LKUP^ABMAROLL
 I 'ABMP("BDFN") Q
 ; File A/R data in payment multiple of 3P BILL and complete bill
 D FILE^ABMAROLL
 Q
