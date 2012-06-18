BARPUCU ; IHS/SD/LSL - UNALLOCATED COMMAND PROCESSOR ; 06/09/2008
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**4,6,19,21**;OCT 26, 2005
 ;** posting utilities
 ;
 ; IHS/SD/LSL - 09/23/02 - V1.6 Patch 3 - HIPAA
 ;     Don't allow updating of other files if Adjustment Category
 ;     is PENDING or GENERAL INFORMATION.
 ;
 ; IHS/SD/LSL - 11/27/02 - V1.7 - QAA-1200-130051
 ;     Added quit logic if error in creating a transaction
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
 I $D(BARMIN),X<BARMIN Q "?"
 I $D(BARMAX),X>BARMAX Q "?"
 Q X
 ; *********************************************************************
 ;
COMHLP ;EP - help display
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
 S BARHLP("A")="A = Adjustments (Write-Off, Deductible, Non-Covered, Non-Pay, Penalty)"
 S BARHLP("C")="C = Itemized Charges - allows posting by line item"
 S BARHLP("D")="D = Patient Demographics"
 S BARHLP("E")="E = Edit a transaction not yet posted to A/R"
 S BARHLP("I")="I = Insurer Demographics"
 S BARHLP("H")="H = History of Bill Transactions ($ only)"
 S BARHLP("M")="M = Message"
 S BARHLP("P")="P = Payments"
 S BARHLP("Q")="Q = Quit - Ends the data entry for this Patient and allows for posting to A/R"
 S BARHLP("R")="R = Rollover"
 S BARHLP("T")="T = Toggle Display - Current transaction list."
 ; IHS/SD/PKD 1.8*19 change spelling
 ;S BARHLP("B")="B = Bill Enquire"
 S BARHLP("B")="B = Bill Inquire"
 Q
 ; *********************************************************************
 ;
POSTTX ;EP - poster
 ;IHS/SD/TPF BAR*1.8*21 8/3/2011 HEAT20490
 I $$NOTOPEN^BARUFUT(.DUZ,$G(UFMSESID)) Q  ;IS SESSION STILL OPEN
 W !!,"Please wait... Posting Transactions."
 K DD,DO,BARBLV
 N DA,DR,DIE,DIC,DIQ,BARTT,BARZZZZ
 S BARAC=BARTX(6,"I")
 S DIC="^BARTR(DUZ(2),"
 S DIC(0)="L"
 S BARLIN=0
 F  S BARLIN=$O(BARTR(BARLIN)) Q:'BARLIN  D
 . S BARBDFN=$O(^BARTMP($J,"B",BARLIN,""))
 . S BARROLL(BARBDFN)=""
 . S BARBLV(15)=$$GET1^DIQ(90050.01,BARBDFN,15,"I")
 . S BARCOL=BARTX(14,"I")                 ;BAR*1.8*6 DD 4.2.5
 . S BARITM=BARTX(15)                     ;BAR*1.8*6 DD 4.2.5
 . S BARZZZZ=1     ;DON'T CHECK BATCH/ITEM;BAR*1.8*6 DD 4.2.5
 . D CKBAL^BARPSTU(BARLIN,BARBLV(15))     ;BAR*1.8*4 DD 4.1.7.2
 . Q:BARSTOP                              ;BAR*1.8*4 DD 4.1.7.2
 . S (BARBTOT,BARJ)=0
 . F  S BARJ=$O(BARTR(BARLIN,BARJ)) Q:'BARJ  D
 .. S BARREC=BARTR(BARLIN,BARJ)
 .. S BARTXT=$P(BARREC,U,1)
 .. S BARAMT=$P(BARREC,U,2)
 .. Q:+BARAMT=0
 .. S BARBTOT=BARBTOT+BARAMT
 .. S BARCAT=$P(BARREC,U,3)
 .. I BARTXT="P" D
 ... S BARTT=$O(^BARTBL("B","PAYMENT",""))
 ... S BARUCAC=$$GET1^DIQ(90050.03,+BARTX("ID"),6,"I")
 ... Q:'BARUCAC
 ... S BARBLV(304)=$$GET1^DIQ(90050.02,BARUCAC,304,"I")
 ... S DA=BARUCAC
 ... S DR="304////^S X=BARBLV(304)-BARAMT"
 ... S DIE="^BARAC(DUZ(2),"
 ... S DIDEL=90050
 ... D ^DIE
 ... K DIDEL
 .. S:BARTXT="A" BARTT=$O(^BARTBL("B","ADJUST ACCOUNT",""))
 .. S BARATYP=$P(BARREC,U,4)
 .. D P1
 .K ^BARTMP($J,BARBDFN)
 ; -------------------------------
 ;
FINISH ;
 Q:BARSTOP                            ;BAR*1.8*4 DD 4.1.7.2
 K DR,DIC
 I (+BARTX(2,"I"))-(+BARPMT)'=0 D  G CLOSE
 . D ENP^XBDIQ1("^BARTR(DUZ(2),",+BARTX("ID"),"6;8;10;11;14;15;101;104;105","BARSIB(","0I")
 . S BARREM=(+BARTX(2,"I"))-(+BARPMT)
 . S DIC="^BARTR(DUZ(2),"
 . S DIC(0)="L"
 . S DLAYGO=90050
 . L +^BARTR(DUZ(2)):2 F  D NOW^%DTC S X=% I '$D(^BARTR(DUZ(2),"B",X)) L -^BARTR(DUZ(2)) D ^DIC K DLAYGO Q
 . S BARSIB=+Y
 . I BARSIB<1 D  G FINISH
 . . W !,"Couldn't create a new UN-ALLOCATED transaction.  The system is trying again.",!
 . S DA=BARSIB
 . S DIE="^BARTR(DUZ(2),"
 . S DR="2////^S X=BARREM"
 . S DR=DR_";12////^S X=DT"
 . S DR=DR_";13////^S X=DUZ"
 . S DR=DR_";201////^S X=+BARTX(""ID"")"
 . S DR=DR_";6////^S X=BARSIB(6,""I"")"
 . S DR=DR_";8////^S X=BARSIB(8,""I"")"
 . S DR=DR_";10////^S X=BARSIB(10,""I"")"
 . S DR=DR_";11////^S X=BARSIB(11,""I"")"
 . S DR=DR_";14////^S X=BARSIB(14,""I"")"
 . S DR=DR_";15////^S X=BARSIB(15,""I"")"
 . S DR=DR_";101////^S X=BARSIB(101,""I"")"
 . S DR=DR_";104////^S X=BARSIB(104,""I"")"
 . S DR=DR_";105////^S X=BARSIB(105,""I"")"
 . S DIDEL=90050
 . D ^DIE
 . K DIDEL
 . S DIE="^BARTR(DUZ(2),"
 . S DR="2////^S X=BARPMT"
 . S DR=DR_";105////^S X=""R"""
 . S DR=DR_";202////^S X=+BARSIB"
 . S DA=+BARTX("ID")
 . S DIDEL=90050
 . D ^DIE
 . K DIDEL
 . Q
 I (+BARTX(2,"I"))-(+BARPMT)=0 D
 . S DIE="^BARTR(DUZ(2),"
 . S DR="105////^S X=""R"""
 . S DA=+BARTX("ID")
 . S DIDEL=90050
 . D ^DIE
 . K DIDEL
 ; -------------------------------
 ;
CLOSE ;
 ;K ^BARTMP($J)
 K BARTX,BARREM,BARSIB,BARTR,BARPMT,BARADJ,BARCAT,BARATYP,BARBTOT,BARBLV
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
 K BARCOL
 D ENP^XBDIQ1("^BARCOL(DUZ(2),",BARTX(14,"I"),"8;9;10","BARCOL(","0I")
 S BARPAR=BARCOL(8,"I")
 S BARASFAC=BARCOL(9,"I")
 S BARSECT=BARCOL(10,"I")
 S DA=BARTX(15,"I")
 S DA(1)=BARTX(14,"I")
 S BARSITE=$$GET1^DIQ(90051.1101,.DA,8,"I")
PX ;
 S X=$$NEW^BARTR
 S BARTRIEN=X
 I X<1 D MSG^BARTR(BARBDFN) Q
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
 S DR=DR_";14////^S X=BARTX(14,""I"")"
 S DR=DR_";15////^S X=BARTX(15,""I"")"
 S DR=DR_";13////^S X=DUZ"
 S DR=DR_";101////^S X=BARTT"
 I BARTXT="A" D
 . S DR=DR_";102////^S X=BARCAT"
 . S DR=DR_";103////^S X=BARATYP"
 I BARTXT="P" S DR=DR_";201////^S X=+BARTX(""ID"")"
 S DR=DR_";10////^S X=$$VALI^XBDIQ1(200,DUZ,29)"
 S DIDEL=90050
 D ^DIE
 K DIDEL
 I ",21,22,"[(","_BARCAT_",") Q
 D TR^BARTDO(BARTRIEN)
 W "."
DONE ;
 Q
