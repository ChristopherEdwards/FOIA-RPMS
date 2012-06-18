BAREDP06 ; IHS/SD/LSL - POST CLAIMS ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**1**;MAR 27, 2007
 ;;
 ; IHS/SD/LSL - 11/26/02 - V1.7 - NOIS QAA-1200-130051
 ;       Modified to Q if error in creating a transaction
 ;
 ; ********************************************************************
 ;
EN(TRDA,IMPDA)     ; EP
 ; LOOP Claims in M status and post
 D INIT^BARUTL
 S BARSECT=BARUSR(29,"I")
 S CLMDA=0
 F  S CLMDA=$O(^BAREDI("I",DUZ(2),IMPDA,30,"AC","M",CLMDA)) Q:CLMDA'>0  D
 . D BASIC ; (gather claim data & build BARDR string)
 . D PAY
 . D ADJMULT
 . D MRKCLMP
 Q
 ; *********************************************************************
 ;
PAY ;EP
 ; PULL CLAIM INFO AND POST PAYMENT (IF ANY)
 K BARCR,CLM
 D ENP^XBDIQ1(90056.0205,"IMPDA,CLMDA",".01;.05;1.01;.02;.04","CLM(")
 W !!,"Claim: ",CLM(.01)," <> ",CLM(1.01)
 W !?5,"Billed: ",CLM(.05),?25,"Payment: ",CLM(.04)
 S BARCR=$$VALI^XBDIQ1(90056.0205,"IMPDA,CLMDA",.04)
 Q:BARCR=0
 S BARTRAN=40
 I +$G(BARCOL),+$G(BARITM)
 E  Q
 D POST
 Q
 ; *********************************************************************
 ;
ADJMULT ;EP
 ; POST ADJUSTMENTS
 K ADJ
 S DR=BARDR_";102////^S X=BARCAT;103////^S X=BARREA"
 D ENPM^XBDIQ1(90056.0208,"IMPDA,CLMDA,0",".02;.04;.05","ADJ(","I")
 Q:'$D(ADJ)
 S BARTRAN=43
 S ADJDA=0
 F  S ADJDA=$O(ADJ(ADJDA)) Q:ADJDA'>0  D
 . S BARCR=ADJ(ADJDA,.02,"I")
 . S BARCAT=ADJ(ADJDA,.04,"I")
 . S BARREA=ADJ(ADJDA,.05,"I")
 . S DR=BARDR_";102////^S X=BARCAT;103////^S X=BARREA"
 . D POST
 . K ADJP
 . D ENP^XBDIQ1(90056.0208,"IMPDA,CLMDA,ADJDA",".02;.04;.05","ADJP(")
 . W !?5,"ADJ: ",ADJP(.02),?25,ADJP(.04),?45,ADJP(.05)
 Q
 ; *********************************************************************
 ;
MRKCLMP ;EP
 ; MARK CLAIM AS POSTED
 K DIC,DA,DR
 S DIE=$$DIC^XBDIQ1(90056.0205)
 S DA(1)=IMPDA
 S DA=CLMDA
 S DR=".02////P"
 D ^DIE
 K DIC,DA,DR
 Q
 ; *********************************************************************
 ;
BASIC ;EP ASSEMBLE BASIC DATA FOR TRANSACTION   
 ;
 S BARBLIEN=$$VALI^XBDIQ1(90056.0205,"IMPDA,CLMDA",1.01) ; A/R BILL 
 S BARBLPAT=$$GET1^DIQ(90050.01,BARBLIEN,101,"I")  ; A/R Patient IEN
 S BARBLAC=$$GET1^DIQ(90050.01,BARBLIEN,3,"I")     ; A/R Account
 S BARCOL=$$GET1^DIQ(90056.02,IMPDA,.06,"I") ;  A/R COLLECTION BATCH IEN 
 S BARITM=$$GET1^DIQ(90056.02,IMPDA,.07,"I") ; A/R COL BATCH ITEM
 S BARVLOC=$$GET1^DIQ(90056.02,IMPDA,108,"I") ; A/R LOCATION
 S DR="2////^S X=BARCR"
 S DR=DR_";4////^S X=BARBLIEN"        ; A/R Bill
 S DR=DR_";5////^S X=BARBLPAT"        ; A/R Patient
 S DR=DR_";6////^S X=BARBLAC"         ; A/R Account
 S DR=DR_";8////^S X=DUZ(2)"          ; Parent Location
 S DR=DR_";9////^S X=DUZ(2)"          ; Parent ASUFAC
 S DR=DR_";10////^S X=BARSECT"        ; A/R Section
 S DR=DR_";11////^S X=BARVLOC"         ; Visit Location
 S DR=DR_";12////^S X=DT" ; Date
 S DR=DR_";13////^S X=DUZ"            ; Entry by
 S DR=DR_";14////^S X=$G(BARCOL)"         ; IEN to A/R COLLECTION BATCH
 S DR=DR_";15////^S X=$G(BARITM)"         ; IEN to ITEM mult in A/R COL
 S DR=DR_";101////^S X=BARTRAN"       ; Transaction Type
 S BARDR=DR
 S (BARCAT,BARREA)=""
 Q
 ; *********************************************************************
 ;
POST ;EP
 ; SET TRANSACTION & POST FILES
 S BARTRIEN=$$NEW^BARTR               ; Create Transaction
 I BARTRIEN<1 D MSG^BARTR(BARBLIEN) Q
 S BARROLL(BARBLIEN)=""
 ; Populate Transaction file
 S DA=BARTRIEN                        ; IEN to A/R TRANSACTION
 S DIE=90050.03
 S DIDEL=90050
 D ^DIE
 K DIDEL,DIE,DA,DR
 ; Post from transaction file to related files
 D TR^BARTDO(BARTRIEN)
 Q
