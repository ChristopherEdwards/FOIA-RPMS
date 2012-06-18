BARMAWO2 ; IHS/SD/LSL - Automatic Write-Off 2000 - Reversal ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;
 ; IHS/ASDS/LSL - 09/07/01 - Routine created
 ;     Reverse all transactions of transaction type 43 (Adjustment)
 ;     with Adjustment category 3 (Write-off)
 ;     with Adjustment type 501 (Auto Write-off 2000)
 ;
 ; *********************************************************************
 Q
 ;
EN ; EP
 D NOTE
 Q:'BARCONT
 D NOW^%DTC
 S BARNOW=%
 D LOOP
 W !!!,BARCNT," Bills with Auto Write off 2000 (501) reversed."
 D XIT
 Q
 ; *********************************************************************
 ;
NOTE ;
 S BARCONT=0
 W !!,$$EN^BARVDF("RVN"),"NOTE:",$$EN^BARVDF("RVF")
 W ?7,"All transactions (at all facilities) of transaction type 43 (Adjustment)"
 W !?7,"with Adjustment Category 3 (Write Off)"
 W !?7,"and Adjustment Type 501 (Auto Write-off 2000)"
 W !?7,"will be reversed by creating a new transaction of the same type,"
 W !?7,"but negative dollar amount."
 W !!?7,$$EN^BARVDF("RVN"),"ALSO,",$$EN^BARVDF("RVF")," the bill will be re-opened in 3PB with a balance due."
 ;
 D CHECK                          ; See if this has been run before
 Q:BARDONE
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
 S:Y=1 BARCONT=1
 Q
 ; *********************************************************************
 ;
CHECK ;
 ; Check to see if this option has already been run
 S BARDONE=0
 I $D(^BARTMP("AWO-REVERSE")) D  Q
 . S Y=^BARTMP("AWO-REVERSE")
 . D DD^%DT
 . S BARDONDT=Y
 . S BARDONE=1
 . S $P(BARDASH,"*",54)=""
 . W !!?14,BARDASH
 . W !?14,"* This option was already executed on ",BARDONDT,". *"
 . W !?14,"*",?24,"It may not be executed again.",?66,"*"
 . W !?14,BARDASH
 . D EOP^BARUTL(0)
 Q
 ; *********************************************************************
 ;
LOOP ;
 ; Loop all DUZ(2) in transaction file.
 S ^BARTMP("AWO-REVERSE")=DT
 S BARCNT=0
 S BARHOLD=DUZ(2)
 S DUZ(2)=0
 F  S DUZ(2)=$O(^BARTR(DUZ(2))) Q:'+DUZ(2)  D TRANS
 S DUZ(2)=BARHOLD
 Q
 ; *********************************************************************
 ;
TRANS ;
 ; Loop transactions after 12/18/2000 @ 7:00 for each DUZ(2)
 ; 12/18/2000 @ 7:00 used because this is when first AWO coding was
 ; completed. Code 501 did not exist before then.
 S BARDTTR=3001228.07
 F  S BARDTTR=$O(^BARTR(DUZ(2),BARDTTR)) Q:('+BARDTTR!(BARDTTR>BARNOW))  D ISITAWO
 Q
 ; *********************************************************************
 ;
ISITAWO ;
 ; Check to see if trans is AWO 2000
 S BARTR(0)=$G(^BARTR(DUZ(2),BARDTTR,0))    ; A/R Transaction 0 node
 S BARTR(1)=$G(^BARTR(DUZ(2),BARDTTR,1))    ; A/R Transaction 1 node
 I $P(BARTR(1),U)=43,$P(BARTR(1),U,2)=3,$P(BARTR(1),U,3)=501 D
 . D REVERSE
 . D ROLLBILL
 Q
 ; *********************************************************************
 ;
REVERSE ;
 S DIE=90050.03
 S DR="2////^S X=-$P(BARTR(0),U,2)"       ; Credit ($$$)
 S DR=DR_";4////^S X=$P(BARTR(0),U,4)"    ; A/R Bill
 S DR=DR_";5////^S X=$P(BARTR(0),U,5)"    ; A/R Patient
 S DR=DR_";6////^S X=$P(BARTR(0),U,6)"    ; A/R Account
 S DR=DR_";8////^S X=$P(BARTR(0),U,8)"    ; Parent Location
 S DR=DR_";9////^S X=$P(BARTR(0),U,9)"    ; Parent ASUFAC
 S DR=DR_";10////^S X=$P(BARTR(0),U,10)"  ; A/R Section
 S DR=DR_";11////^S X=$P(BARTR(0),U,11)"  ; Visit location
 S DR=DR_";12////^S X=DT"                 ; Date
 S DR=DR_";13////^S X=DUZ"                ; A/R Entry by
 S DR=DR_";101////43"                     ; Transaction type (Adj)
 S DR=DR_";102////3"                      ; Adj Category (Write off)
 S DR=DR_";103////501"                  ; Adj Type (Auto Write off 2000)
 S DIDEL=90050
 K DIDEL,DIE,DA,DR
 K BARBL
 S BARCNT=BARCNT+1
 S BARBILL=$$GET1^DIQ(90050.01,$P(BARTR(0),U,4),.01)
 W !,BARBILL,?25," for ",$J($FN(-$P(BARTR(0),U,2),",",2),10)," written off (reversed)."
 Q
 ; *********************************************************************
 ;
ROLLBILL ;
 Q
 ; *********************************************************************
 ;
BILLED ;
 ; Mark bill in 3PB Bill file as BILLED
 S DIE="^ABMDBILL(DUZ(2),"
 S DA=ABMP("BDFN")
 S DR=".04////B"
 D ^DIE
 K DR
 Q
 ; *********************************************************************
 ;
XIT ;
 D ^BARVKL0
 Q
