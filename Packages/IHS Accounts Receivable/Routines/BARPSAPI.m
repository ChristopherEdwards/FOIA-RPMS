BARPSAPI ; IHS/SD/LSL - A/R Pharmacy POS API ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**4**;OCT 26, 2005
 ;
 Q
 ;
 ; *********************************************************************
EN(BAR)         ; PEP
 Q "API DISABLED"  ;BAR*1.8*4 ITEM 5 SCR58
 ; Pass in array where
 ; BAR("USER")            User who enters transaction
 ; BAR("CREDIT")          Dollar amount of transaction
 ; BAR("ARLOC")           Location of A/R bill DUZ(2),IEN
 ; BAR("TRAN TYPE")       Type of transaction to post
 ; BAR("ADJ CAT")         Adjustment category if BAR("TRAN TYPE")=43
 ; BAR("ADJ TYPE")        Adjustment type if BAR("TRAN TYPE")=43
 ;
 I '$G(BAR("CREDIT"))!('$G(BAR("ARLOC")))!('$G(BAR("TRAN TYPE"))) Q ""
 I $G(BAR("TRAN TYPE"))=43&('$G(BAR("ADJ CAT"))!('$G(BAR("ADJ TYPE")))) Q ""
 ; Set BARUSR(29,"I") to accomodate input transforms on many A/R fields.
 ; This value must match the Service section on the transaction.
 ; Service/Section must be Business Office (8) for A/R
 S BARUSR(29,"I")=8
 S BARHOLD=DUZ(2)
 S DUZ(2)=+BAR("ARLOC")
 S BARBLIEN=$P(BAR("ARLOC"),",",2)
 I 'BARBLIEN Q "No A/R bill to post to"
 S BARROLL(BARBLIEN)=""                      ; Needed for rollback
 S BARBLPAT=$$VALI^XBDIQ1(90050.01,BARBLIEN,101)  ; A/R Patient IEN
 S BARBLAC=$$VALI^XBDIQ1(90050.01,BARBLIEN,3)     ; A/R Account
 S BARVIST=$$VALI^XBDIQ1(90050.01,BARBLIEN,108)   ; A/R Visit loc
 S BARTRIEN=$$NEW^BARTR                      ; Create New Transaction
 I +BARTRIEN<1 Q ""
 ; Populate Transaction file
 S DA=BARTRIEN                               ; IEN to A/R TRANSACTION
 S DIE=90050.03
 S DR="2////^S X=BAR(""CREDIT"")"            ; Credit
 S DR=DR_";4////^S X=BARBLIEN"               ; A/R Bill
 S DR=DR_";5////^S X=BARBLPAT"               ; A/R Patient
 S DR=DR_";6////^S X=BARBLAC"                ; A/R Account
 S DR=DR_";8////^S X=DUZ(2)"                 ; Parent Location
 S DR=DR_";9////^S X=DUZ(2)"                 ; Parent ASUFAC
 ; Force A/R section to Business Office
 S DR=DR_";10////8"                          ; A/R Section
 S DR=DR_";11////^S X=BARVIST"               ; Visit Location
 S DR=DR_";12////^S X=DT"                    ; Date
 S DR=DR_";13////^S X=BAR(""USER"")"         ; Entry by
 S DR=DR_";101////^S X=BAR(""TRAN TYPE"")"   ; Transaction Type
 I BAR("TRAN TYPE")=43 D                     ; If Adjustment
 . S DR=DR_";102////^S X=BAR(""ADJ CAT"")"   ; Adjustment Category
 . S DR=DR_";103////^S X=BAR(""ADJ TYPE"")"  ; Adjustment Type
 S DIDEL=90050
 D ^DIE
 K DIDEL,DIE,DA,DR
 ; Post from transaction file to related files
 D TR^BARTDO(BARTRIEN)
 D EN^BARROLL                                ; Roll trans back to 3PB
 S DUZ(2)=BARHOLD
 Q BAR("ARLOC")
