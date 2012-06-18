BARMAWO3 ; IHS/SD/LSL - Automatic Write-Off UFMS NON-BEN IN ERROR 2007 - Reversal ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**2**;MAY 7,2007
 ;
 ; THIS IS TO BE USE ONLY TO REVERSE THE WRITE OFFS ON NON-BEN ACCOUNTS
 ; WHEN PATCH 1 OF THE UFMS WRITE-OFF 2007 WERE MSITAKENLY MADE BECAUSE
 ; THE OLD CODE WAS USING THE 'STANDS FOR' AND NOT THE CODE FOR VP INSURER TYPE
 ; THE STRING HAD BEEN CHANGED BY THE AUPN DEVELOPER AND WAS NOT PUBLICIZED.
 ;
 ; THIS ROUTINE WAS COPIED AND MODIFIED FROM BARMAWO2
 ; *********************************************************************
 Q
 ;
EN ; EP
 D NOTE
 Q:'BARCONT
 D NOW^%DTC
 S BARNOW=%
 D LOOP
 W !!!,BARCNT," Bills with AUTO WRITE-OFF 2007 (916) reversed."
 D XIT
 Q
 ; *********************************************************************
 ;
NOTE ;
 S BARCONT=0
 W !!,$$EN^BARVDF("RVN"),"NOTE:",$$EN^BARVDF("RVF")
 W ?7,"All transactions (at all facilities) of transaction type 43 (Adjustment)"
 W !?7,"with Adjustment Category 3 (Write Off)"
 W !?7,"and Adjustment Type 916 (AUTO WRITE-OFF 2007)"
 W !?7,"will be reversed by creating a new transaction of the same type,"
 W !?7,"but negative dollar amount. Only the Non-Ben entries mistakenly written"
 W !?7,"off during the UFMS AUTO WRITE-OFF of 2007 in Patch 1 will be reversed"
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
 I $D(^BARTMP("AWO-NON-BEN-REVERSE")) D  Q
 . S Y=^BARTMP("AWO-NON-BEN-REVERSE")
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
 S ^BARTMP("AWO-NON-BEN-REVERSE")=DT
 S BARCNT=0
 S BARHOLD=DUZ(2)
 S DUZ(2)=0
 F  S DUZ(2)=$O(^BARTR(DUZ(2))) Q:'+DUZ(2)  D TRANS
 S DUZ(2)=BARHOLD
 Q
 ; *********************************************************************
 ;
TRANS ;
 ; Loop transactions after APR 12,2007 @ 7:00 for each DUZ(2)
 ; APR 12,2007 @ 7:00 used because this is just before the release (4/13)
 ; of UFMS AWO coding. Code 916 did not exist before then.
 S BARDTTR=3070412.07
 F  S BARDTTR=$O(^BARTR(DUZ(2),BARDTTR)) Q:('+BARDTTR!(BARDTTR>BARNOW))  D ISITAWO
 Q
 ; *********************************************************************
 ;
ISITAWO ;
 ; Check to see if trans is AUTO WRITE-OFF 2007
 S BARTR(0)=$G(^BARTR(DUZ(2),BARDTTR,0))    ; A/R Transaction 0 node
 S BARTR(1)=$G(^BARTR(DUZ(2),BARDTTR,1))    ; A/R Transaction 1 node
 ;BAR*1.8*2
 S BARBL=$P(BARTR(0),U,4)                            ;BILL IEN
 Q:BARBL=""
 S POSTTRAN=$O(^BARTR(DUZ(2),"AC",BARBL,BARDTTR))  ;GET NEXT TRANSACTION
 I POSTTRAN'="" D
 .S POSTAWO=$$GET1^DIQ(90050.03,POSTTRAN_",",103,"I")
 .S POSTDEB=$$GET1^DIQ(90050.03,POSTTRAN_",",3,"I")   ;GET DEBIT OF NEXT TRANS
 S PRETRAN=$O(^BARTR(DUZ(2),"AC",BARBL,BARDTTR),-1)  ;GET NEXT TRANSACTION
 I PRETRAN'="" D
 .S PREAWO=$$GET1^DIQ(90050.03,PRETRAN_",",103,"I")
 .S PRECRED=$$GET1^DIQ(90050.03,PRETRAN_",",2,"I")   ;GET DEBIT OF PREVIOUS TRANS
 ;GET ADJUSTMENT TYPE
 ;
 ;this is only for those non-ben accounts that were accidently written off
 S BARACT=$P(BARTR(0),U,6)
 Q:BARACT=""
 S D0=BARACT     ;BAR*1.8*2
 S BARITYP=$$VALI^BARVPM(8)  ;GET INTERNAL CODE INSTEAD OF 'STANDS FOR'
 Q:BARITYP'="N"               ;NON-BEN CODE
 K D0
 ;end new code
 ;;ADJUST ACCOUNT       -   WRITE-OFF       -   AUTO WRITE-OFF 2007
 I $P(BARTR(1),U)=43,($P(BARTR(1),U,2)=3),($P(BARTR(1),U,3)=916) D
 . ;I POSTTRAN'="",($P(BARTR(0),U,2)=POSTDEB),(POSTAWO=916) Q  ;IF THIS IS TRUE THEY MANUALLY REVER
 . ;I PRETRAN'="",($P(BARTR(0),U,3)=PRECRED),(PREAWO=916) Q  ;IF THIS IS TRUE THEY
 . I POSTTRAN'="",(POSTAWO=916) Q  ;IF THIS IS TRUE THEY MANUALLY REVER
 . I PRETRAN'="",(PREAWO=916) Q  ;IF THIS IS TRUE THEY
 . D REVERSE
 . D BILLED
 . D ARBILL
 Q
ARBILL ;
 K DIR,DIE,DR,DIC,DA,DR
 S DA=$P(BARTR(0),U,4)
 S DIE="^BARBL(DUZ(2),"
 S DR="15///^S X=$P(BARTR(0),U,2)"
 D ^DIE
 Q
 ; *********************************************************************
REVERSE ;
 S BARTRIEN=$$NEW^BARTR                   ; Create new transaction
 S DA=BARTRIEN
 S DIE=90050.03
 S DR="3////^S X=$P(BARTR(0),U,2)"       ; PUT WRITE-OFF AMT IN DEBIT ($$$)
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
 S DR=DR_";103////916"                  ; Adj Type (Auto Write off 2007)
 S DIDEL=90050
 D ^DIE                                ; Populate transaction file
 K DIDEL,DIE,DA,DR
 D TR^BARTDO(BARTRIEN)                    ; Post from trans to files
 K BARBL
 S BARCNT=BARCNT+1
 S BARBILL=$$GET1^DIQ(90050.01,$P(BARTR(0),U,4),.01)
 W !,BARBILL,?25," for ",$J($FN(-$P(BARTR(0),U,2),",",2),10)," written off (reversed)."
 Q
 ; *********************************************************************
BILLED ;
 S BARBLDA=$P(BARTR(0),U,4)
 S ABMBIL=$$FIND3PB^BARUTL(DUZ(2),BARBLDA)
 ; Mark bill in 3PB Bill file as BILLED
 S DIE="^ABMDBILL(DUZ(2),"
 S DA=$P(ABMBIL,",",2)
 S DR=".04////B"
 D ^DIE
 K DR
 Q
 ; *********************************************************************
 ;
XIT ;
 D ^BARVKL0
 Q
