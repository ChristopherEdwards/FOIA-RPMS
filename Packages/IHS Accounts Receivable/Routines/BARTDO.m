BARTDO ; IHS/SD/LSL - ROUTINE TO PERFORM TRANSACTIONS ; 12/12/2007
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**3,5**;JUN 22, 2008
 ;;
 ;given the da of a transaction, this will pull the data
 ;from the transaction and perform the setting of fields
 ;in the related files.
 ; to reverse an entry pass BARUNDO=1
 ;
 ; IHS/SD/SDR - 4/18/02 - V1.6 P2 - Update for new trans. type
 ;     Updated to include new transaction type FLAT RATE ADJUSTMENT.
 ;     It should be treated the same as BILL NEW.
 ;
 ; IHS/SD/LSL - 03/04/03 - V1.7 Patch 1 - Remove call to BARPSDAT
 ;     Routine was deleted as Period Summary Data File no longer exists
 ;
 Q
 ; *********************************************************************
 ;
TR(BARTRDA,BARUNDO) ; EP
 ; Pull the transaction and perform the sets per the type of transaction
 S:'$D(BARUNDO) BARUNDO=0
 ;
 I $D(UFMSESID) D
 .S X=$$TRANTRIG^BARUFUT(DUZ,UFMSESID,BARTRDA)  ;BAR*1.8*3 UFMS             ;IF ERA POSTING FLAG IS SET
 ;
 ;
 K BART
 D ENP^XBDIQ1(90050.03,BARTRDA,".01;3.5;4;5;6;10;11;14;15;101;102;103","BART(","I")
 S BARTYP=BART(101,"I")
 Q:BARTYP=""
 K BARX
 ;F X=39,40,41,43,49,108,503 S BARX(X)=""
 F X=138,139,39,40,41,43,108,503 S BARX(X)=""  ;BAR*1.8*5 SRS-80 IHS/SD/TPF 4/15/2008 INCLUDE 'PAYMENT CREDIT'
 I '$D(BARX(BARTYP)) Q
 S BARAMT=BART(3.5)
 S:BARUNDO BARAMT=-BARAMT ; reverse or back out
 ;
 I BARTYP D @BARTYP ; types as set in the element tables for transactions
 Q
 ; *********************************************************************
 ;
138 ;BAR*1.8*5 SRS-80 IHS/SD/TPF 4/15/2008 INCLUDE 'CREDIT TO OTHER BILL' - ACT LIKE ADJUST
 ; Payment credit (act like adjustment)
 D 43
 Q
 ; ********************************************************************
139 ;BAR*1.8*5 SRS-80 IHS/SD/TPF 4/15/2008 INCLUDE 'CREDIT FROM OTHER BILL' - ACT LIKE ADJUST
 ; Payment credit (act like adjustment)
 D 43
 Q
 ; *********************************************************************
 ;
39 ;
 ; Refund (act like adjustment)
 D 43
 Q
 ; ********************************************************************
 ;
40 ;
 ; payment to a bill /account
 N DIC,DIE,DR,DA,BARBLV
 S BARACC=BART(6,"I")
 S BARBL=BART(4,"I")
 ;update account fields un-posted, current a/r ballance
 S (DIC,DIE)=$$DIC^XBDIQ1(90050.02)
 S DA=BARACC
 G:'$D(^BARAC(DUZ(2),DA,0)) BILL40
 S BARBLV(301)=$$GET1^DIQ(90050.02,DA,301,"I")
 S BARBLV(302)=$$GET1^DIQ(90050.02,DA,302,"I")
 S DR="301////^S X=BARBLV(301)-BARAMT;302////^S X=BARBLV(302)-BARAMT"
 S DIDEL=90050
 D ^DIE
 K DIDEL
 ; -------------------------------
 ;
BILL40 ;
 ; update bill amount field
 N DIC,DIE,DR,DA,BARBLV
 S (DIC,DIE)=$$DIC^XBDIQ1(90050.01)
 S DA=BARBL
 S BARBLV(15)=$$GET1^DIQ(90050.01,DA,15)
 S DR="15////^S X=BARBLV(15)-BARAMT"
 ;
I ;
 S DIDEL=90050
 D ^DIE
 K DIDEL
 ; -------------------------------
 ;
BATCH ;** update batch
 ; Replaced by triggers in Collection Batch
 ; -------------------------------
 ;
BLVL ;** batch level
 ; Replaced by triggers in Collection Batch
 ; -------------------------------
 ;
ILVL ;** batch item level
 N DIC,DIE,DR,DA,BARUN
 S (DIC,DIE)=$$DIC^XBSFGBL(90051.1101)
 K DA
 S DA(1)=BART(14,"I")
 S DA=BART(15,"I")
 S BARUN(18)=$$VALI^XBDIQ1(DIC,.DA,18)
 S DR="18////^S X=BARUN(18)+BARAMT"
 S DIDEL=90050
 D ^DIE
 K DIDEL
 ; -------------------------------
 ;
SLVL ;** batch item sub eob level
 ; to be coded when sub item is put into transactions
 Q
 ; *********************************************************************
 ;
Q40 ;
 Q
 ; *********************************************************************
 ;
41 ;cancellation of a bill/account
 N DIC,DIE,DR,DA,BARBLV
 ;adjust account field current a/r balance
 S (DIC,DIE)=$$DIC^XBDIQ1(90050.02)
 S DA=BART(6,"I")
 G:'$D(^BARAC(DUZ(2),DA,0)) BILL41
 S BARBLV(301)=$$GET1^DIQ(90050.02,DA,301,"I")
 S DR="301////^S X=BARBLV(301)-BARAMT"
 S DIDEL=90050
 D ^DIE
 K DIDEL
 ; -------------------------------
 ;
BILL41 ;update bill amount field
 N DIE,DR,DA,BARBLV
 S (DIC,DIE)=$$DIC^XBDIQ1(90050.01)
 S DA=BART(4,"I")
 S BARBLV(15)=$$GET1^DIQ(90050.01,DA,15)
 S DR="15////^S X=BARBLV(15)-BARAMT"
 S DIDEL=90050
 D ^DIE
 K DIDEL
Q41 ;
 Q
 ; *********************************************************************
 ;
43 ;adjustment to a bill/account
 N DIC,DIE,DR,DA,BARBLV
 ;adjust account field current a/r balance
 S (DIC,DIE)=$$DIC^XBDIQ1(90050.02)
 S DA=BART(6,"I")
 G:'$D(^BARAC(DUZ(2),DA,0)) BILL43
 S BARBLV(301)=$$GET1^DIQ(90050.02,DA,301,"I")
 S DR="301////^S X=BARBLV(301)-BARAMT"
 S DIDEL=90050
 D ^DIE
 K DIDEL
 ; -------------------------------
 ;
BILL43 ;update bill amount field
 N DIE,DR,DA,BARBLV
 S (DIC,DIE)=$$DIC^XBDIQ1(90050.01)
 S DA=BART(4,"I")
 S BARBLV(15)=$$GET1^DIQ(90050.01,DA,15)
 S DR="15////^S X=BARBLV(15)-BARAMT"
 S DIDEL=90050
 D ^DIE
 K DIDEL
Q43 ;
 Q
 ; *********************************************************************
 ;
49 ;bill new / account
 N DIC,DIE,DA,DR,BARACV
 S (DIC,DIE)=$$DIC^XBDIQ1(90050.02)
 S DA=BART(6,"I")
 Q:'$D(^BARAC(DUZ(2),DA,0))
 S BARACV=$$GET1^DIQ(90050.02,DA,301,"I")
 S DR="301////^S X=BARACV-BARAMT"
 S DIDEL=90050
 D ^DIE
 K DIDEL
Q49 ;
 Q
 ; *********************************************************************
 ;
108 ; 3P credit - edit cr field and then same sequence as an adjustment
 N DIE,DA,DR
 S DIE=$$DIC^XBDIQ1(90050.01)
 S DA=BARBLDA
 S DR="20////^S X=BARAMT"
 D ^DIE
 D 43
Q108 ;
 Q
 ; *********************************************************************
 ;
503 ; Flat Rate Adjustment
 D 49   ;FRA should be treated the same as BILL NEW
 Q
