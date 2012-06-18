BARPST7 ; IHS/SD/LSL - UNALLOCATED POSTING ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**3,21**;OCT 26, 2005
 ;
 ; IHS/SD/LSL - 11/27/02 - V1.7 - QAA-1200-130051
 ;      Modified to not update other files if couldn't create a
 ;      transaction.
 ;
 ; ********************************************************************
 ;
 ;** post unallocated cash
 ;
 Q
 ;--------------------------------------------------------------------
UNALC(BARCB,BARITM,BARSUB)         ;EP - Unallocated posting
 ;IHS/SD/TPF BAR*1.8*21 8/3/2011 HEAT20490
 I $$NOTOPEN^BARUFUT(.DUZ,$G(UFMSESID)) Q  ;IS SESSION STILL OPEN
 ;
 N BARUN
TRYAGIN ;
 D TOP^BARPST1(0)
 W !!!
 S DIR(0)="NOA^0:"_$S(BARSUB:BARVSIT(4),1:BARCLIT(19))_":2"
 S DIR("A")="Enter UNALLOCATED amount: "
 D ^DIR
 K DIR
 Q:$D(DUOUT)!(+Y=0)
 S BARUN("AMT")=Y
 W *7,!!,"Amount: "_$J(BARUN("AMT"),0,2)
 S DIR("A")="OK to Post to UNALLOCATED CASH"
 S DIR("B")="YES"
 S DIR(0)="Y"
 D ^DIR
 K DIR
 I Y'=1 G TRYAGIN
 ;IHS/SD/TPF BAR*1.8*21 8/3/2011 HEAT20490
 I $$NOTOPEN^BARUFUT(.DUZ,$G(UFMSESID)) G EXIT  ;IS SESSION STILL OPEN
 W !!,"Updating Account, Transaction and Batch files now..."
 N DA
 S DIC=$$DIC^XBSFGBL(90051.1101)
 S DA(1)=+BARCB
 S DA=+BARITM
 S BARUN("ACCT")=$$VALI^XBDIQ1(DIC,.DA,7)
 D TX
 I BARTRIEN<1 G TRYAGIN
 D BATCH
 D ACC(BARUN("ACCT"))
 ; -------------------------------
 ;
EXIT ;
 D EOP^BARUTL(1)
 Q
 ; *********************************************************************
 ;
ACC(DA) ;** update un-allocated account
 N DIC,DIE,DR
 Q:'DA
 S DIC="^BARAC(DUZ(2),"
 S DIC(0)="LX"
 S BARUN(304)=$$GET1^DIQ(90050.02,DA,304,"I")
 S BARUN(302)=$$GET1^DIQ(90050.02,DA,302,"I")
 S DIE=DIC
 S DR="304////^S X=BARUN(304)+BARUN(""AMT"")"
 S DR=DR_";302////^S X=BARUN(302)-BARUN(""AMT"")"
 S DIDEL=90050
 D ^DIE
 K DIDEL
 Q
 ; *********************************************************************
 ;
BATCH ;** update batch
 N DA,DR,DIE,DIC,BARPMT
 S BARPMT=BARUN("AMT")
 ; -------------------------------
 ;
SLVL ;
 ; ** sub eob level
 G:'$G(BARSUB) ILVL
 S (DIC,DIE)=$$DIC^XBSFGBL(90051.1101601)
 S DA(2)=+BARCB
 S DA(1)=+BARITM
 S DA=+BARSUB
 S BARUN(5)=$$VALI^XBDIQ1(DIC,.DA,5)
 S DR="5////^S X=BARUN(5)+BARPMT"
 S DIDEL=90050
 D ^DIE
 K DIDEL
 ; -------------------------------
 ;
ILVL ;
 ; ** item level
 S (DIC,DIE)=$$DIC^XBSFGBL(90051.1101)
 S DA(1)=+BARCB
 S DA=+BARITM
 S BARUN("ACCT")=$$VALI^XBDIQ1(DIC,.DA,7)
 Q:$G(BARSUB)
 S BARUN(105)=$$VALI^XBDIQ1(DIC,.DA,105)
 S DR="105////^S X=BARUN(105)+BARPMT"
 S DIDEL=90050
 D ^DIE
 K DIDEL
 Q
 ; *********************************************************************
 ;
BLVL ;
 ; ** batch level
 ;
TX ;** create transaction
 ;IHS/SD/TPF BAR*1.8*21 8/3/2011 HEAT20490
 I $$NOTOPEN^BARUFUT(.DUZ,$G(UFMSESID)) Q  ;IS SESSION STILL OPEN
 N DIC,BARCR,BARAC,BARTT
 S DIE="^BARTR(DUZ(2),"
 S DIC(0)="LX"
 K DO,DD
 S BARCR=BARUN("AMT")
 S BARAC=BARUN("ACCT")
 S BARTT=$O(^BARTBL("B","UN-ALLOCATED",0))
 ; -------------------------------
 ;
PX ;
 S X=$$NEW^BARTR
 S BARTRIEN=X
 I BARTRIEN<1 D  Q
 . W !!,"The system could not create an UN-ALLOCATED transaction.  Please try again.",!
 S DA=X
 S DR="2////^S X=BARCR"
 S DR=DR_";6////^S X=BARAC"
 S DR=DR_";12////^S X=DT"
 S DR=DR_";13////^S X=DUZ"
 S DR=DR_";14////^S X=BARCB"
 S DR=DR_";101////^S X=BARTT"
 S DR=DR_";15////^S X=BARITM"
 S DR=DR_";105////^S X=""O"""
 S DR=DR_";104////^S X=1"
 S DR=DR_";10////^S X=$$VALI^XBDIQ1(200,DUZ,29)"
 S DIDEL=90050
 D ^DIE
 K DIDEL
 ;
 S X=$$TRANTRIG^BARUFUT(DUZ,UFMSESID,BARTRIEN)  ;BAR*1.8*3 UFMS
 Q
