BARBADU ; IHS/SD/LSL - PAYMENT TRANSACTION EXECUTION ; 06/09/2008
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**3,4,6,19,20,21**;OCT 26, 2005
 ;** posting utilities
 ;
 ; IHS/SD/LSL - 09/23/02 - V1.6 Patch 3 - HIPAA
 ;     Don't update files if Adjustment Category is PENDING or
 ;     GENERAL INFORMATION
 ;
 ; IHS/SD/LSL - 10/17/02 - V1.7 - QAA-1200-130051
 ;      Provide Q conditions if failed getting a new A/R transaction
 ; IHS/SD/PKD 3/21/11 1.8*21 Patch 19 copied BARBAD* from BARPST* and modified
 ;      BARBAD* will be merged back at some point, but not all comments
 ;      apply to BARBAD since comments weren't updated w/ Patch 19 changes
 ;
 ; ********************************************************************
 Q
 ;
AMT(X,BARMIN,BARMAX) ;EP - ** number function
 ;** quits with "^" to exit
 ;** quits with "?" for incorrect entry
 I '$D(X) Q "^"
 I X["^"!('$L(X)) Q "^"
 S:X["$" X=$P(X,"$",2)
 I X'?."-".N.1".".2N Q "?"
 I $D(BARMIN),X'>BARMIN Q "?"
 I $D(BARMAX),X'<BARMAX Q "?"
 Q X
 ; *********************************************************************
 ;
COMHLP ;EP - help processor
 N X,J
 W $$EN^BARVDF("IOF"),!!
 S X="Select Command Options"
 W ?IOM-$L(X)\2,X
 W !?IOM-$L(X)\2 F J=1:1:$L(X) W "-"
 W !!
 D SETHLP
 S J=0
 F  S J=$O(BARHLP(J)) Q:'J  D
 . W !?2,BARHLP(J)
 W !!
 Q
 ; *********************************************************************
 ;
SETHLP ;EP - sethelp
 S BARHLP(1)="S = Set all or a portion of the current balance as ""Sent to Collections."""
 S BARHLP(2)="V = Reverse from ""Sent to Collections"" back into the current balance."
 S BARHLP(3)="Q or 3 = Quit"
 S BARHLP(4)="H = History of Bill Transactions ($ only)"
 S BARHLP(5)="M = Message"
 S BARHLP(6)="T = Toggle Display - Current transaction list."
 S BARHLP(7)="B = Bill Inquire"
 S BARHLP(8)="E = Edit a transaction not yet posted to A/R"
 Q
 ; *********************************************************************
 ;
POSTTX ;EP - poster  ;Heavily modified for BAR*1.8*4 DD 4.1.7.2
 ;CALLED BY PAY/ADJ/REF POSTING OPTIONS ;BAR*1.8*4 DD 4.1.7.2
 ;
 ;IHS/SD/TPF BAR*1.8*21 8/3/2011 HEAT20490
 I $$NOTOPEN^BARUFUT(.DUZ,$G(UFMSESID)) Q  ;IS SESSION STILL OPEN
 ; 
 W !!,"Please wait... Posting Transactions."
 K DD,DO,BARBLV
 N DA,DR,DIE,DIC,DIQ
 S BARLIN=0
 F  S BARLIN=$O(BARTR(BARLIN)) Q:'BARLIN  D
 .S BARBDFN=$O(^BARTMP($J,"B",BARLIN,""))
 .; IHS/SD/AR 1.8*19 Added following 2 lines which will set up ^BARTMP($J
 .;  if they were not there.  comments added 3/21/11
 .I BARBDFN="" S BARCNT=$$EN^BARBAD2(BARPASS)
 .S BARBDFN=$O(^BARTMP($J,"B",BARLIN,""))
 . ; end 1.8*19
 .S BARAC=$$GET1^DIQ(90050.01,BARBDFN,3,"I")
 .S BARROLL(BARBDFN)=""
 .S BARBLV(15)=$$GET1^DIQ(90050.01,BARBDFN,15,"I")
 .D CKBAL(BARLIN,BARBLV(15))
 .Q:BARSTOP                      ;BAR*1.8*4 DD 4.1.7.2
 .S (BARBTOT,BARJ)=0
 .F  S BARJ=$O(BARTR(BARLIN,BARJ)) Q:'BARJ  D
 ..S BARREC=BARTR(BARLIN,BARJ)
 ..S BARTXT=$P(BARREC,U,1)
 ..S BARAMT=$P(BARTR(BARLIN,BARJ),U,2)  ;CHG'D LINE
 ..S BARBTOT=BARBTOT+BARAMT
 ..S BARCAT=$P(BARREC,U,3)
 ..S BARTT=$O(^BARTBL("B","STATUS CHANGE",""))
 ..S BARATYP=$P(BARREC,U,4)
 ..D P1
 .K BARTR(BARLIN),BARPMT,BARADJ,BARCAT,BARATYP,BARBTOT,BARBLV  ;BAR*1.8*4 DD 4.1.7.2
 Q
CKBAL(BARL,BARB) ;EP; CHECK IF TX'S WILL CREATE NEGATIVE BALANCE
 ;ENTERS WITH BARL = LINE  = BILL
 ;            BARB = BILL BALANCE
 S BARSTOP=0
 N BARTOT,BARJ,BARDIF,BARTAMT,BARCAT
 S (BARTOT,BARJ)=0
 F  S BARJ=$O(BARTR(BARL,BARJ)) Q:'BARJ  D
 .S BARREC=BARTR(BARLIN,BARJ)
 .S BARTYP=$P(BARREC,U)
 .S BARTAMT=$P(BARREC,U,2)
 .S BARCAT=$P(BARREC,U,3)
 .S BARCOM1=$P(BARREC,U,5)
 .I BARCAT'=21&(BARCAT'=22) D
 ..S BARTOT=BARTOT+BARTAMT
 Q
 ;
P1 ;
 S DIE="^BARTR(DUZ(2),"
 S BARCR=$S(BARCOM1="S":BARAMT,1:0)
 S BARDB=$S(BARCOM1="V":BARAMT,1:0)
 ; IHS/SD/PKD 1.8*20 3/11/11  Piece 3 is Debit
 ; Putting it negative causes it to be positive.
 ;S BARDB=-BARDB 
 S BARPT=+BARPAT
 S:$G(BARITM(0)) BARAC=$P(BARITM(0),U,7)
 S BARPAR=$P($G(BARCOL(0)),U,8)
 S BARASFAC=$P($G(BARCOL(0)),U,9)
 S BARSECT=$P($G(BARCOL(0)),U,10)
 S BARSITE=$P($G(BARITM(0)),U,8)
 S:$G(BAREOB) BARSITE=BAREOB
 ;End changes for BAR*1.8*4 DD 4.1.7.2
 ; -------------------------------
PX ;
 S X=$$NEW^BARTR
 S BARTRIEN=X
 I X<1 D MSG^BARTR(BARBDFN) Q
 K DIE,DIC,DR,DA
 S DA=X,DIE=90050.03
 S DR="2////^S X=BARCR"
 S DR=DR_";3////^S X=BARDB"
 S DR=DR_";4////^S X=BARBDFN"
 S DR=DR_";5////^S X=BARPT"
 S DR=DR_";6////^S X=BARAC"
 S DR=DR_";8////^S X=BARPAR"
 S DR=DR_";9////^S X=BARASFAC"
 S DR=DR_";10////^S X=BARSECT"
 S DR=DR_";11////^S X=BARSITE"
 S DR=DR_";12////^S X=DT"
 S DR=DR_";13////^S X=DUZ"
 S:$G(BARCOL) DR=DR_";14////^S X=BARCOL"    ;BAR*1.8*4 DD 4.1.7.2
 S:$G(BARITM(0)) DR=DR_";15////^S X=$P(BARITM(0),U,1)" ;BAR*1.8*4 DD 4.1.7.2
 S DR=DR_";101////^S X=993"
 S DR=DR_";102////^S X=BARCAT"
 S DR=DR_";103////^S X=BARATYP"
 ;S DR=DR_";10////^S X=$$VALI^XBDIQ1(200,DUZ,29)"
 S DIDEL=90050
 D ^DIE
 K DIDEL
 I ",21,22,"[(","_BARCAT_",") Q
 D TR^BARTDO(BARTRIEN)
 W "."
SETCOLL ;EP
 ; Create COLLECTION STATUS multiple for A/R Bill
 N DR,DA,DIC,J,I,BARTOTO,BARTOTSC,BARTEXT,BARCUR,BARCURSC,BARSCIEN,BARTOTM
 S BARTOTO=0,BARTOTSC=0,BARTEXT="",BARCUR=0,BARCURSC=0,BARTOTM=0
 S BARCUR=$$GET1^DIQ(90050.01,BARBDFN,15)
 S BARSCIEN=0
 F  S BARSCIEN=$O(^BARBL(DUZ(2),BARBDFN,9,BARSCIEN)) D  Q:'BARSCIEN
 . S:BARSCIEN BARCURSC=$P(^BARBL(DUZ(2),BARBDFN,9,BARSCIEN,0),U,4)
 I BARCOM1="V" D
 . S BARTOTO=BARCUR+BARAMT
 . S BARTOTSC=BARCURSC-BARAMT
 . S BARTEXT="SENT TO COLLECTIONS-REVERSAL"
 I BARCOM1="S" D
 . S BARTOTO=BARCUR-BARAMT
 . S BARTOTSC=BARCURSC+BARAMT
 . S BARTEXT="SENT TO COLLECTIONS"
 S BARTOTM=BARAMT
 K DIE,DA,DIDEL
 S DIE="^BARBL(DUZ(2),"
 S DA=BARBDFN
 S DR=""
 S DR=DR_"15////^S X=BARTOTO"
 S DIDEL=90050
 D ^DIE
 K DIE,DA,DIDEL
 S DA(1)=BARBDFN
 S DIC="^BARBL(DUZ(2),"_DA(1)_",9,"
 S DIC(0)="LX"
 S DIC("P")=$P(^DD(90050.01,901,0),U,2)
 S DIC("DR")=""
 S X=DT_U_BARTOTM_U_BARTEXT_U_BARTOTSC
 K DD,DO
 D FILE^DICN
 K DLAYGO
DONE ;
 Q
