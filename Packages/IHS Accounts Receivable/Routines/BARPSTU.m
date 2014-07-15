BARPSTU ; IHS/SD/LSL - PAYMENT TRANSACTION EXECUTION ; 06/09/2008
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**3,4,6,21,23**;OCT 26, 2005
 ;** posting utilities
 ;
 ; IHS/SD/LSL - 09/23/02 - V1.6 Patch 3 - HIPAA
 ;     Don't update files if Adjustment Category is PENDING or
 ;     GENERAL INFORMATION
 ;
 ; IHS/SD/LSL - 10/17/02 - V1.7 - QAA-1200-130051
 ;      Provide Q conditions if failed getting a new A/R transaction
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
 D:$D(BARHLP)<10 SETHLP
 S J=""
 F  S J=$O(BARHLP(J)) Q:J=""  W !?2,BARHLP(J)
 W !!
 Q
 ; *********************************************************************
 ;
SETHLP ;EP - sethelp
 S BARHLP("A")="A or 2 = Adjustments (Write-Off, Deductible, Non-Covered, Non-Pay, Penalty)"
 S BARHLP("C")="C = Itemized Charges - allows posting by line item"
 S BARHLP("D")="D = Patient Demographics"
B S BARHLP("B")="B = Bill Inquire"
 S BARHLP("E")="E = Edit a transaction not yet posted to A/R"
 S BARHLP("I")="I = Insurer Demographics"
 S BARHLP("H")="H = History of BIll Transactions ($ only)"
 S BARHLP("M")="M = Message"
 S BARHLP("P")="P or 1 = Payment"
 S BARHLP("Q")="Q or 3 = Quit - Ends the data entry for this Patient and allows for posting to A/R"
 S BARHLP("R")="R = Rollover"
 S BARHLP("T")="T = Toggle Display - Current transaction list."
 Q
 ; *********************************************************************
 ;
POSTTX ;EP - poster  ;Heavily modified for BAR*1.8*4 DD 4.1.7.2
 ;CALLED BY PAY/ADJ/REF POSTING OPTIONS ;BAR*1.8*4 DD 4.1.7.2
 ;
 ;IHS/SD/TPF BAR*1.8*21 8/3/2011 HEAT20490
 I $$NOTOPEN^BARUFUT(.DUZ,$G(UFMSESID)) Q  ;IS SESSION STILL OPEN
 W !!,"Please wait... Posting Transactions."
 K DD,DO,BARBLV
 N DA,DR,DIE,DIC,DIQ
 N REVERSAL,REVSCHED             ;BAR*1.8*3 UFMS
 S BARLIN=0
 F  S BARLIN=$O(BARTR(BARLIN)) Q:'BARLIN  D
 .S BARBDFN=$O(^BARTMP($J,"B",BARLIN,""))
 .S BARAC=$$GET1^DIQ(90050.01,BARBDFN,3,"I")
 .S BARROLL(BARBDFN)=""
 .S BARBLV(15)=$$GET1^DIQ(90050.01,BARBDFN,15,"I")
 .D CKBAL(BARLIN,BARBLV(15))     ;BAR*1.8*4 DD 4.1.7.2
 .Q:BARSTOP                      ;BAR*1.8*4 DD 4.1.7.2
 .S (BARBTOT,BARJ)=0
 .F  S BARJ=$O(BARTR(BARLIN,BARJ)) Q:'BARJ  D
 ..S BARREC=BARTR(BARLIN,BARJ)
 ..S BARTXT=$P(BARREC,U,1)
 ..S BARAMT=$P(BARREC,U,2)
 ..S BARBTOT=BARBTOT+BARAMT
 ..S BARCAT=$P(BARREC,U,3)
 ..S:BARTXT="P" BARTT=$O(^BARTBL("B","PAYMENT",""))
 ..S:BARTXT="A" BARTT=$O(^BARTBL("B","ADJUST ACCOUNT",""))
 ..S:BARTXT="R" BARTT=39 ;BAR*1.8*4 DD 4.1.7.2 ;change from 55 wrong account number
 ..S BARATYP=$P(BARREC,U,4)
 ..S REVERSAL=$P(BARREC,U,5)      ;BAR*1.8*3 UFMS
 ..S REVSCHED=$P(BARREC,U,6)      ;BAR*1.8*4 UFMS SCR56,SCR58
 ..;
 ..D P1
 .K REVERSAL,REVSCHED            ;BAR*1.8*4 UFMS SCR56,SCR58
 .K BARTR(BARLIN),BARPMT,BARADJ,BARCAT,BARATYP,BARBTOT,BARBLV  ;BAR*1.8*4 DD 4.1.7.2
 ;K ^BARTMP($J)                   ;BAR*1.8*4 DD 4.1.7.2
 ;K BARTR,BARPMT,BARADJ,BARCAT,BARATYP,BARBTOT,BARBLV   ;BAR*1.8*4 DD 4.1.7.2
 Q
CKBAL(BARL,BARB) ;EP; CHECK IF TX'S WILL CREATE NEGATIVE BALANCE
 ;BAR*1.8*4 DD 4.1.7.2
 ;ENTERS WITH BARL = LINE  = BILL
 ;            BARB = BILL BALANCE
 S BARSTOP=0
 Q:'$$IHS^BARUFUT(DUZ(2))
 ;;;Q:'$$IHSERA^BARUFUT(DUZ(2)) ;P.OTT
 N BARTOT,BARJ,BARDIF,BARTAMT,BARPTOT,BARCAT
 S (BARTOT,BARJ,BARPTOT)=0
 F  S BARJ=$O(BARTR(BARL,BARJ)) Q:'BARJ  D
 .S BARREC=BARTR(BARLIN,BARJ)
 .S BARTYP=$P(BARREC,U)
 .S BARTAMT=$P(BARREC,U,2)
 .S BARCAT=$P(BARREC,U,3)
 .I BARCAT'=21&(BARCAT'=22) D
 ..S BARTOT=BARTOT+BARTAMT
 .S:BARTYP="P" BARPTOT=BARPTOT+BARTAMT
 I BARB-BARTOT<0 D
 .D STOP("BILL",BARB-BARTOT)
 Q:'$G(BARCOL)                      ;NO COLLECTION BATCH TO CHECK
 Q:$G(BARZZZZ)  ;DON'T CHECK BATCH/ITEM WHEN ENTERED FROM PUC ;BAR*1.8*6 DD 4.2.5
 D CKCOL
 I +$G(BAREOB),(BAREOV(4)-BARPTOT)<0 D STOP("VISIT LOCATION",(BAREOV(4)-BARPTOT))
 I (BARITV(19)-BARPTOT)<0 D STOP("COLLECTION ITEM",(BARITV(19)-BARPTOT))
 I (BARCLV(17)-BARPTOT)<0 D STOP("COLLECTION BATCH",(BARCLV(17)-BARPTOT))
 Q
 ;
STOP(TYPE,BARDIF) ;EP; BAR*1.8*4 DD 4.1.7.2
 W !!,"THE TRANSACTION(S) YOU ARE ATTEMPTING TO POST WILL PUT"
 W !,"THE ",TYPE," INTO A NEGATIVE BALANCE BY $"_-BARDIF
 W !,"PLEASE CANCEL, OR USE 'M' FOR MORE TO EDIT YOUR TRANSACTION"
 W !,"TO PREVENT THE NEGATIVE BALANCE"
 S BARSTOP=1
 D EOP^BARUTL(1)
 Q
 ; *********************************************************************
P1 ;
 S DIE="^BARTR(DUZ(2),"
 S BARCR=$S(+BARAMT>0:BARAMT,1:"")
 S BARDB=$S(+BARAMT<0:BARAMT,1:"")
 S BARDB=-BARDB
 S BARPT=+BARPAT
 ;Begin changes for BAR*1.8*4 DD 4.1.7.2
 ;S BARAC=$P(BARITM(0),U,7)
 ;S BARPAR=$P(BARCOL(0),U,8)
 ;S BARASFAC=$P(BARCOL(0),U,9)
 ;S BARSECT=$P(BARCOL(0),U,10)
 ;S BARSITE=$P(BARITM(0),U,8)
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
 ;S DR=DR_";14////^S X=BARCOL"              ;BAR*1.8*4 DD 4.1.7.2
 ;S DR=DR_";15////^S X=$P(BARITM(0),U,1)"   ;BAR*1.8*4 DD 4.1.7.2
 S:$G(BARCOL) DR=DR_";14////^S X=BARCOL"    ;BAR*1.8*4 DD 4.1.7.2
 S:$G(BARITM(0)) DR=DR_";15////^S X=$P(BARITM(0),U,1)" ;BAR*1.8*4 DD 4.1.7.2
 S DR=DR_";101////^S X=BARTT"
 ;I BARTXT="A" D                             ;BAR*1.8*4 DD 4.1.7.2
 I "RA"[BARTXT D                             ;BAR*1.8*4 DD 4.1.7.2
 . S DR=DR_";102////^S X=BARCAT"
 . S DR=DR_";103////^S X=BARATYP"
 S DR=DR_";10////^S X=$$VALI^XBDIQ1(200,DUZ,29)"
 ;S DR=DR_";110////^S X=REVERSAL"  ;ISH/SD/TPF BAR*1.8*3 UFMS
 I $G(REVERSAL) D
 .S DR=DR_";110////^S X=REVERSAL"  ;ISH/SD/TPF BAR*1.8*4 UFMS
 .S DR=DR_";111////^S X=REVSCHED"  ;ISH/SD/TPF BAR*1.8*4 UFMS SCR56,SCR58
 S DIDEL=90050
 D ^DIE
 K DIDEL
 I ",21,22,"[(","_BARCAT_",") Q
 D TR^BARTDO(BARTRIEN)
 W "."
DONE ;
 Q
 ; ------------------------------------------
CKCOL ;EP; CHECK COLLECTION BATCH/ITEM BALANCES;BAR*1.8*4 DD 4.1.7.2
 K BARCLV,BARITV,BAREOV
 N DA,DIC,DIQ,DR
 S DIC=90051.01
 S DIQ="BARCLV("
 S DR=17
 S DA=+BARCOL
 D EN^XBDIQ1
 ;
 S DIC=90051.1101
 S DIQ="BARITV("
 S DR=19
 S DA=+BARITM
 S DA(1)=+BARCOL
 D EN^XBDIQ1
 ;
 I +$G(BAREOB) D
 . S DIC=90051.1101601
 . S DIQ="BAREOV("
 . S DR=4
 . S DA=+BAREOB
 . S DA(2)=+BARCOL
 . S DA(1)=+BARITM
 . D EN^XBDIQ1
 Q
