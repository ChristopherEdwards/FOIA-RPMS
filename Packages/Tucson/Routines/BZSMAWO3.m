BZSMAWO3 ; IHS/TAO/EDE - WRITE OFF OLD BILLS REVERSAL [ 04/06/2003  9:29 AM ]
 ;;1.0;TUCSON AREA OFFICE W/O;;MAR 14, 2003
 ;
 ;     Reverse all transactions of transaction type 43 (Adjustment)
 ;     with Adjustment category 3 (Write-off)
 ;     with Adjustment type 1003 (TAO Auto Write-off)
 ;
START ;
 D NOW^%DTC
 S BZSNOW=%
 D NOTE
 Q:'BZSCONT
 D LOOP
 W !!,BZSCNT," Bills with Auto Write off (1003) reversed."
 D EOJ
 Q
 ;
 ;--------------------
NOTE ; TELL USER WHAT IS GOING TO HAPPEN
 S BZSCONT=0
 W !!,$$EN^BARVDF("RVN"),"NOTE:",$$EN^BARVDF("RVF")
 W ?7,"All transactions (at all facilities) of transaction type 43 (Adjustment)"
 W !?7,"with Adjustment Category 3 (Write Off)"
 W !?7,"and Adjustment Type 1003 (Paid Denied Over Stat Limit)"
 W !?7,"will be reversed by creating a new transaction of the same type,"
 W !?7,"but negative dollar amount."
 W !!?7,$$EN^BARVDF("RVN"),"ALSO,",$$EN^BARVDF("RVF")," the bill will be re-opened in 3PB with a balance due."
 ;
 D CHECK                          ; See if this has been run before
 Q:BZSDONE
 ;
 W !!,"The bill number and amount written off will scroll by on the screen"
 W !,"if you wish to capture this information.",!
 ;
 K DIR
 S DIR(0)="Y"
 S DIR("A")="Continue"
 S DIR("B")="No"
 D ^DIR
 K DIR
 S:Y=1 BZSCONT=1
 Q
 ;
 ;--------------------
CHECK ;
 ; Check to see if this option has already been run
 S BZSDONE=0
 I $D(^BZSTMP("AWO-REVERSE")) D  Q
 . S Y=^BZSTMP("AWO-REVERSE")
 . D DD^%DT
 . S BZSDONDT=Y
 . S BZSDONE=1
 . S $P(BZSDASH,"*",54)=""
 . W !!?14,BZSDASH
 . W !?14,"* This routine was already executed on ",BZSDONDT,". *"
 . W !?14,"*",?24,"It may not be executed again.",?66,"*"
 . W !?14,BZSDASH
 . D EOP^BARUTL(0)
 Q
 ;
 ;--------------------
LOOP ; LOOP ALL DUZ(2) IN TRANSACTION FILE
 S BZSCNT=0
 S ^BZSTMP("AWO-REVERSE")=DT
 S BZSHOLD=DUZ(2)
 S DUZ(2)=0
 F  S DUZ(2)=$O(^BARTR(DUZ(2))) Q:'+DUZ(2)  D TRANS
 S DUZ(2)=BZSHOLD
 Q
 ;
 ;--------------------
TRANS ; LOOP TRANSACTIONS FOR EACH DUZ(2)
 ; Loop transactions after 03/01/2003 @ 7:00 for each DUZ(2). This
 ; date and time used because code 1003 did not exist before then.
 S BZSDTTR=3030301.07
 F  S BZSDTTR=$O(^BARTR(DUZ(2),BZSDTTR)) Q:('+BZSDTTR!(BZSDTTR>BZSNOW))  D ISITAWO
 Q
 ;
 ;--------------------
ISITAWO ; CHECK TO SEE IF TRANS IS TAO AWO 1003
 S BZSTR(0)=$G(^BARTR(DUZ(2),BZSDTTR,0))    ; A/R Transaction 0 node
 S BZSTR(1)=$G(^BARTR(DUZ(2),BZSDTTR,1))    ; A/R Transaction 1 node
 I $P(BZSTR(1),U)=43,$P(BZSTR(1),U,2)=3,$P(BZSTR(1),U,3)=1003 D
 . D REVERSE
 . D ROLLBILL
 Q
 ;
 ;--------------------
REVERSE ; REVERSE THE TAO 1003 WRITE OFF
 S BZSTRIEN=$$NEW^BARTR ;                   Create new transaction
 S DA=BZSTRIEN
 S DIE=90050.03
 S DR="2////^S X=-$P(BZSTR(0),U,2)"       ; Credit ($$$)
 S DR=DR_";4////^S X=$P(BZSTR(0),U,4)"    ; A/R Bill
 S DR=DR_";5////^S X=$P(BZSTR(0),U,5)"    ; A/R Patient
 S DR=DR_";6////^S X=$P(BZSTR(0),U,6)"    ; A/R Account
 S DR=DR_";8////^S X=$P(BZSTR(0),U,8)"    ; Parent Location
 S DR=DR_";9////^S X=$P(BZSTR(0),U,9)"    ; Parent ASUFAC
 S DR=DR_";10////^S X=$P(BZSTR(0),U,10)"  ; A/R Section
 S DR=DR_";11////^S X=$P(BZSTR(0),U,11)"  ; Visit location
 S DR=DR_";12////^S X=DT"                 ; Date
 S DR=DR_";13////^S X=DUZ"                ; A/R Entry by
 S DR=DR_";101////43"                     ; Transaction type (Adj)
 S DR=DR_";102////3"                      ; Adj Category (Write off)
 S DR=DR_";103////1003"                  ; Adj Type (TAO Auto Write off)
 S DIDEL=90050
 D ^BARDIE ;                                Populate transaction file
 K DIDEL,DIE,DA,DR
 D TR^BARTDO(BZSTRIEN) ;                    Post from trans to files
 K BARBL
 S BZSCNT=BZSCNT+1
 S BZSBILL=$$GET1^DIQ(90050.01,$P(BZSTR(0),U,4),.01)
 W !,BZSBILL,?25," for ",$J($FN(-$P(BZSTR(0),U,2),",",2),10)," written off (reversed)."
 Q
 ;
 ;--------------------
ROLLBILL ; UPDATE PAYMENT MULTIPLE IN 3PB, MARK AS BILLED IN 3PB
 ; For bills reversed, update the payment multiple in 3PB and mark the 
 ; bill as BILLED in 3PB Bill File.
 S BARBLDA=$P(BZSTR(0),U,4)
 D SETVAR^BARROLL                          ; Set A/R vars to roll to 3PB
 D ROLL^BZSMAWO2
 D BILLED
 Q
 ;
 ;--------------------
BILLED ; MARK BILL IN 3PB BILL FILE AS BILLED
 S DIE="^ABMDBILL(DUZ(2),"
 S DA=ABMP("BDFN")
 S DR=".04////B"
 D ^DIE
 K DR
 Q
 ;
 ;--------------------
EOJ ;
 ;D ^BARVKL0
 D EN^XBVK("BAR"),EN^XBVK("AMB")
 Q
