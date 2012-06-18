BARFRAPI ; IHS/SD/LSL - A/R Flat Rate API ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;
 ; IHS/SD/SDR - BAR*1.6*3 - 9/16/2002 - QDA-0802-130076
 ;         Modified routine to populate current balance correctly
 ;         Also added a line to new DA so it doesn't get overwritten
 ;         for 3PB routine
 ;
 Q
 ;
 ; *********************************************************************
EN(BAR)         ; PEP
 ; API to pass Flat Rate Adjustments from 3PB to A/R
 ; This API is expecting the difference between what the Flat Rate was
 ; and what the new rate is.  A transaction will be created for the
 ; difference with a transaction type of FRA.  The amount billed and
 ; current bill amount will be adjusted accordingly.
 ;
 ; Pass in array where:
 ;     BAR("USER")         User who enters transaction
 ;     BAR("ADJ AMT")      Dollar amount of transaction
 ;     BAR("ARLOC")        Location of A/R bill DUZ(2),IEN
 ;     BAR("TRAN TYPE")    Type of transaction to post
 ;
 ; -------------------------------
 ;
 N DA
 I '$G(BAR("ADJ AMT"))!('$G(BAR("ARLOC")))!('$G(BAR("TRAN TYPE"))) Q ""
 I $G(BAR("TRAN TYPE"))'=503 Q "NOT FRA TRANSACTION TYPE"
 I '+BAR("ADJ AMT") Q "NO AMOUNT ENTERED"
 ;
 ; Set BARUSR(29,"I") to accomodate input transforms on many A/R fields.
 ; This value must match the Service section on the transaction.
 ; Service/Section must be Business Office (8) for A/R
 ;
 S BARUSR(29,"I")=8
 S BARHOLD=DUZ(2)
 S DUZ(2)=+BAR("ARLOC")
 S BARBLIEN=$P(BAR("ARLOC"),",",2)
 I 'BARBLIEN Q "No A/R bill to post to"
 ;
 S BARBLPAT=$$GET1^DIQ(90050.01,BARBLIEN,101,"I")  ; A/R Patient IEN
 S BARBLAC=$$GET1^DIQ(90050.01,BARBLIEN,3,"I")     ; A/R Account
 S BARVIST=$$GET1^DIQ(90050.01,BARBLIEN,108,"I")   ; A/R Visit loc
 S BARTRIEN=$$NEW^BARTR                      ; Create New Transaction
 I +BARTRIEN<1 Q "A/R TRANSACTION NOT CREATED"
 ;
 ; Populate Transaction file
 S DA=BARTRIEN                               ; IEN to A/R TRANSACTION
 S DIE=90050.03
 I $E(BAR("ADJ AMT"),1)="-" S DR="2////^S X=BAR(""ADJ AMT"")"  ; Credit
 E  S DR="3////^S X=BAR(""ADJ AMT"")"  ; Debit
 S DR=DR_";4////^S X=BARBLIEN"               ; A/R Bill
 S DR=DR_";5////^S X=BARBLPAT"               ; A/R Patient
 S DR=DR_";6////^S X=BARBLAC"                ; A/R Account
 S DR=DR_";8////^S X=DUZ(2)"                 ; Parent Location
 S DR=DR_";9////^S X=DUZ(2)"                 ; Parent ASUFAC
 ;
 ; Force A/R section to Business Office
 S DR=DR_";10////8"                          ; A/R Section
 S DR=DR_";11////^S X=BARVIST"               ; Visit Location
 S DR=DR_";12////^S X=DT"                    ; Date
 S DR=DR_";13////^S X=BAR(""USER"")"         ; Entry by
 S DR=DR_";101////^S X=BAR(""TRAN TYPE"")"   ; Transaction Type
 S DIDEL=90050
 D ^DIE
 K DIDEL,DIE,DA,DR
 ;
 ; Adjust bill amount and current bill amount to reflect difference
 S BARBAMT=$P($G(^BARBL(DUZ(2),BARBLIEN,0)),U,13)  ;amount billed
 S BARCBAMT=$P($G(^BARBL(DUZ(2),BARBLIEN,0)),U,15)  ;current bill amount
 S DR="13////^S X=BARBAMT+BAR(""ADJ AMT"")"  ;adjust amount billed
 S DR=DR_";15////^S X=BARCBAMT+BAR(""ADJ AMT"")"  ;adj current bill amt
 S DIE=90050.01   ;A/R bill file
 S DA=BARBLIEN
 D ^DIE
 ;
 ; Post from transaction file to related files
 D TR^BARTDO(BARTRIEN)                 ;Pull trans info and update PSR
 S DUZ(2)=BARHOLD
 Q BAR("ARLOC")
