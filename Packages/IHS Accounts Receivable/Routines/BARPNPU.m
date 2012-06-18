BARPNPU ; IHS/SD/LSL - POSTING TRANSACTIONS ; 04/30/2008
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**4**;OCT 26, 2005
 ;** posting utilities
 ;
 ; IHS/SD/LSL - 09/23/02 - V1.6 Patch 3 - HIPAA
 ;     Don't allow updating of other files if Adjustment Category is
 ;     PENDING or GENERAL INFORMATION
 ;
 ; IHS/SD/LSL -11/26/02 - V1.7 - QAA-1200-130051
 ;     Modified to q if error in creating a new transaction.
 ;
 ; IHS/SD/LSL- 02/20/04 - V1.7 Patch 5 - IM12695
 ;     Resolve <UNDEF>*XECUTE*F+2^DIED
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
COMHLP ;EP - help driver
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
SETHLP ;EP - set help
 S BARHLP("A")="A or 2 = Adjustments (Write-Off, Deductible, Non-Covered, Non-Pay, Penalty)"
 S BARHLP("D")="D = Patient Demographics"
 S BARHLP("E")="E = Edit a transaction not yet posted to A/R"
 S BARHLP("I")="I = Insurer Demographics"
 S BARHLP("H")="H = History of Bill Transactions ($ only)"
 S BARHLP("M")="M = Message"
 S BARHLP("Q")="Q or 3 = Quit - Ends the data entry for this Patient and allows for posting to A/R"
B S BARHLP("B")="B = Bill Inquire"
 S BARHLP("R")="R = Rollover"
 S BARHLP("T")="T = Toggle Display - Current transaction list."
 Q
 ; *********************************************************************
 ;
POSTTX ;EP - poster  ;NO LONGER USED, CALL IS TO POSTTX^BARPSTU ;BAR*1.8*4 DD 4.1.7.2
 Q
 W !!,"Please wait... Posting Transactions."
 K DD,DO,BARBLV
 N DA,DR,DIE,DIC,DIQ
 S BARLIN=0
 F  S BARLIN=$O(BARTR(BARLIN)) Q:'BARLIN  DO
 . S BARBDFN=$O(^BARTMP($J,"B",BARLIN,""))
 . S BARROLL(BARBDFN)=""
 . S BARAC=$$GET1^DIQ(90050.01,BARBDFN,3,"I")
 . S BARBLV(15)=$$GET1^DIQ(90050.01,BARBDFN,15,"I")
 . D CKBAL^BARPSTU(BARLIN,BARBLV(15))     ;BAR*1.8*4 DD 4.1.7.2
 . Q:BARSTOP                              ;BAR*1.8*4 DD 4.1.7.2
 . S (BARBTOT,BARJ)=0
 . F  S BARJ=$O(BARTR(BARLIN,BARJ)) Q:'BARJ  DO
 .. S BARREC=BARTR(BARLIN,BARJ)
 .. S BARTXT=$P(BARREC,U,1)
 .. S BARAMT=$P(BARREC,U,2)
 .. S BARBTOT=BARBTOT+BARAMT
 .. S BARCAT=$P(BARREC,U,3)
 .. S:BARTXT="A" BARTT=$O(^BARTBL("B","ADJUST ACCOUNT",""))
 .. S:BARTXT="R" BARTT=$O(^BARTBL("B","REFUND",""))
 .. S BARATYP=$P(BARREC,U,4)
 .. D P1
 .K ^BARTMP($J,BARDA)             ;BAR*1.8*4 DD 4.1.7.2
 .K BARTR(BARLIN),BARPMT,BARADJ,BARCAT,BARATYP,BARBTOT,BARBLV  ;BAR*1.8*4 DD 4.1.7.2
 ;K ^BARTMP($J)                   ;BAR*1.8*4 DD 4.1.7.2
 ;K BARTR,BARPMT,BARADJ,BARCAT,BARATYP,BARBTOT,BARBLV   ;BAR*1.8*4 DD 4.1.7.2
 Q
 ; *********************************************************************
 ;
P1 ;
 S DIC="^BARTR(DUZ(2),"
 S DIC(0)="L"
 S BARCR=$S(+BARAMT>0:BARAMT,1:"")
 S BARDB=$S(+BARAMT<0:BARAMT,1:"")
 S BARDB=-BARDB
 S BARPT=+BARPAT
 S BARPAR=""
 S BARASFAC=""
 S BARSECT=""
 S BARSITE=""
PX ;
 S X=$$NEW^BARTR
 S BARTRIEN=X
 I X<0 D MSG^BARTR(BARBDFN) Q
 S DA=X
 S DIE=90050.03
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
 S DR=DR_";101////^S X=BARTT"
 I BARTXT="A" D
 . S DR=DR_";102////^S X=BARCAT"
 . S DR=DR_";103////^S X=BARATYP"
 S DR=DR_";10////^S X=$$VALI^XBDIQ1(200,DUZ,29)"
 S DIDEL=90050
 D ^DIE
 K DIDEL
 I ",21,22,"[(","_BARCAT_",") Q
 D TR^BARTDO(BARTRIEN)
 W "."
DONE ;
 Q
