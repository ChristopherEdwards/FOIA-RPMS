BARCLU3 ; IHS/SD/LSL - EDIT/CANCEL WITH AUDIT ; 07/22/2010
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**4,19**;OCT 26, 2005
 ;
 ; IHS/SD/SDR - v1.8 p4 - DD item 4.1.5.1
 ;   Removed change that was done previously in patch 4 because the user
 ;   can't edit the TDN on the item itself, only on the batch.
 ; 
 ; IHS/SD/TMM 06/18/2010 1.8*19
 ;  NEWITEM^BARCLU moved to ^BARCLU4 due to SAC size limitation
 ; ********************************************************************* ;
 ;
 ; select item
 W $$EN^BARVDF("IOF")
 W !,"Edit / Cancel and Item with Auditing",!
 K DIC
 ; -------------------------------
 ;
ITEM ;
 S DIC("W")="D DICW^BARCLU2"
 S DIC("A")="ITEM: "
 S DIC=BARDIC_BARCLDA_",1,"
 S DA(1)=BARCLDA
 S DIC(0)="SMA"
 S DIC("S")="I ""E""[$P(^(0),U,17)"
 S DIC(0)="AEQMZ"
 D ^DIC
 Q:Y'>0
 S BARITDA=+Y
 D BARCLIT^BARCLU
 S BARX=BARCLIT(2,"I")
 D DISPLAY
 K DIR
 S DIR(0)="S^E:Edit w Audit;C:Cancel;Q:Quit"
 D ^DIR
 G:Y="Q" ITEM
 I Y="C" D CANCEL I 1
 E  D EDIT
 G ITEM
 ; *********************************************************************
 ;
CANCEL ; EP
 ; cancel a batch item
 K DA,DR,DIE
 S DR="501;17////C;102///^S X=BARCLIT(101);402////^S X=DUZ;403///NOW"
 S DIE=$$DIC^XBDIQ1(90051.1101)
 S DA=BARITDA
 S DA(1)=+BARCL("ID")
 S DIDEL=90050
 D ^DIE
 K DIDEL
 D BARCLIT^BARCLU
 D DISPLAY
 K DIR
 S DIR(0)="S^R:RE-EDIT;C:CONTINUE TO CANCEL"
 D ^DIR
 G:Y="R" CANCEL
 I '$D(BARCLIT(501)) D  G CANCEL
 . W !!,*7,"Error Comment Required",!
 . D EOP^BARUTL(0)
 Q
 ; *********************************************************************
 ;
EDIT  ;EP
  ; rollup and then edit the new item
 D ERRORCOM
 K DA,DIE,DIC,DR
 S DIE=$$DIC^XBDIQ1(90051.1101)
 S (DA,BAROLD)=BARITDA
 S DA(1)=BARCLDA
 S DR="102///^S X=BARCLIT(101);402////^S X=DUZ;403///NOW"
 S DIDEL=90050
 D ^DIE
 K DIDEL
 D ROLL
 D ITEMEDIT
 Q
 ; *********************************************************************
 ;
ERRORCOM ; EP
 ; LOOP FOR ERROR COMMENT
 S DIE=$$DIC^XBDIQ1(90051.1101)
 S (DA,BAROLD)=BARITDA
 S DA(1)=BARCLDA
 S DR="501"
 S DIDEL=90050
 D ^DIE
 K DIDEL
 D BARCLIT^BARCLU
 D DISPLAY
 I '$D(BARCLIT(501)) D  G ERRORCOM
 . W !!,*7,"Error Comment Required",!
 . D EOP^BARUTL(0)
 K DIR
 S DIR(0)="Y"
 S DIR("B")="YES"
 S DIR("A")="Is the comment correct ?"
 D ^DIR
 I Y'=1 G ERRORCOM
 Q
 ; *********************************************************************
 ;
ROLL ;
 S BAROLD=BARITDA
 D BARCLIT^BARCLU ;pull up old item
 ;D NEWITEM^BARCLU  ;M819*DEL*TMM*20100722--moved to ^BARCLU4
 D NEWITEM^BARCLU4
 ; -------------------------------
 ;
UPDATE ;
 S (BARNEW,BARITDA)=+Y
 K DIE,DR,DA,DIC
 S DA=BARITDA
 S DA(1)=BARCLDA
 S DIE=$$DIC^XBDIQ1(90051.1101)
 S DR="405///^S X=BAROLD;"
 F BARI=2,4,5,6,7,8,9,10,16,17 S:(BARCLIT(BARI,"I"))]"" DR=DR_BARI_"////"_BARCLIT(BARI,"I")_";"
 F BARI=11,12,13,14,101,201,203 S:(BARCLIT(BARI)]"") DR=DR_BARI_"///"_BARCLIT(BARI)_";"
 ;BAR*1.8*4 FIX SCHEDULE NUMBER SHOULD BE AVAILABLE TO EDIT AND DISPLAY
 ;F BARI=11,12,13,14,101,201,203,20 S:(BARCLIT(BARI)]"") DR=DR_BARI_"///"_BARCLIT(BARI)_";"
 ;END
 S DIDEL=90050
 D ^DIE
 K DIDEL
 K DR,DA,DIE,DIC
 S DA=BAROLD
 S DA(1)=BARCLDA
 S DIE=$$DIC^XBDIQ1(90051.1101)
 S DR="17////R;404///^S X=BARNEW"
 S DIDEL=90050
 D ^DIE
 K DIDEL
 K DR,DA,DIE,DIC
 S DA=BARCLDA
 S DIE=$$DIC^XBDIQ1(90051.01)
 S DR="7///^S X=BARCL(7)"
 S DIDEL=90050
 D ^DIE
 K DIDEL
 S BARITDA=BARNEW
 D BARCLIT^BARCLU
 K DR,DA,DIE,DIC
 ;
EROLL ;
 Q
 ; *********************************************************************
 ;
ITEMEDIT ;EP edit collection item
 S BARX=BARCLIT(2,"I")
 K DIE,BARBL
 S DA=BARITDA
 S DA(1)=BARCLDA
 S DIE=$$DIC^XBDIQ1(90051.1101)
 D:BARX=51 EOB
 D:BARX=52 CASH
 D:BARX=53 CC
 D:BARX=55 REFUND
 D:BARX=81 CHECK
 D:BARX=99 GL
 D DISPLAY
 K DIR
 S DIR(0)="Y"
 S DIR("A")="ABOVE IS CORRECT ?"
 S DIR("B")="YES"
 D ^DIR
 I Y'>0 G ITEMEDIT
 Q
 ; *********************************************************************
 ;
CHECK ; EP
 ; for checks
 D CHECK^BARCLU0
 Q
 ; *********************************************************************
 ;
CC ; EP
 ; credit card
 S DR=""
 D CC^BARCLU0
 Q
 ; *********************************************************************
 ;
GL ; EP
 ; general ledger
 S DR="203;"
 D CACC^BARCLU0
 Q
 ; *********************************************************************
 ;
REFUND ; EP
 ; refund
 S DR="102;Q;6///^S X="""" D ^BARBLLK S:$D(BARBL)>1 X=BARBL(.01);Q;6;5;7;8;Q;"
 S:+BARSPAR(3,"I") DR=DR_"10;"
 S DR=DR_"201//^S X=$G(BARBL(3));301;16//^S X=BARCLID(3)"
 S DIDEL=90050
 D ^DIE
 K DIDEL
 Q
 ; *********************************************************************
 ;
CASH ; EP
 ; cash col
 S DR=""
 D CACC^BARCLU0
 Q
 ; *********************************************************************
 ;
EOB ;EP
 ;  EOB entry
 ; the following lifted from BARCLU0 and modified
ITEMEOB ;
 K BARQUIT
 S BARAC=BARCLIT(7,"I")
 D SPAYOR^BARCLU0 ;select payor
 S:+Y>0 BARAC=+Y
 I +Y'>0 W !,"SELECTION ERROR ... SELECT PAYOR",! G ITEMEOB
 S DIE=$$DIC^XBDIQ1(90051.1101)
 S DA=BARITDA
 S DA(1)=BARCLDA
 S DR="7////^S X=BARAC;2////51;17////E"
 S DIDEL=90050
 D ^DIE
 K DIDEL
 D BARCLIT^BARCLU
 S BARITTYP=BARCLIT(2)
 W $$EN^BARVDF("IOF")
 W !!,"ENTERING ",BARCL(.01)
 W ?30,"TYPE: ",BARCLID(2)
 W ?50,"BATCH TOTAL: ",$$GET1^DIQ(90051.01,BARCLDA,15),!!
 W "ITEM ",BARITDA,?20,BARCLIT(7)
 S DR="11;S:X="""" BARQUIT=1"
 ;BAR*1.8*4 UFMS ASK TREASURY DEPOSIT NUMBER
 ;I +BARCLID(22,"I") D
 ;.S DR="11;20R;S:X="""" BARQUIT=1"
 ;E  S DR="11;S:X="""" BARQUIT=1"
 ;END BAR*1.8*4
 S DIDEL=90050
 D ^DIE
 K DIDEL
 S DR="103///@;"
 S:BARCLID(12,"I") DR=DR_"12;" ;bnk num
 S DR=DR_"101;" ;amt
 S:BARCLID(13,"I") DR=DR_"10;" ;in/out pat
 S:'BARSPAR(2,"I") DR=DR_"8///^S X=BARSPAR(.01)"
 S DIDEL=90050
 D ^DIE
 K DIDEL
 I BARSPAR(2,"I") D EOBSUB^BARCLU0 I 1 ;multiple 3P facilities
 E  D INSSUB^BARCLU0
 D BARCLIT^BARCLU
 D DISPLAY^BARCLU1
 K BARQUIT
 K DIR
 S DIR(0)="S^E:EDIT;C:CONTINUE"
 S DIR("B")="CONTINUE"
 D ^DIR
 G:Y="E" EOB
 ;
EITEMEOB ;
 Q
 ; *********************************************************************
 ;
PAYOR ; EP
 ; ask PAYOR (A/R Account with DISV(screen)
 S DR=""
 S DIE=DIC
 S:'+BARCLID(12,"I") DR=DR_"12;" ;bnk num
 S DR=DR_"10;16;301;" ;i/o pat,auto print,comment
 S DIDEL=90050
 D ^DIE
 K DIDEL
 Q
 ; *********************************************************************
 ;
DISPLAY ; EP
 ; display item elements
 D BARCLIT^BARCLU
 D DISPLAY^BARCLU
 Q
 ; *********************************************************************
 ;
DICW ; EP
 ; help display an item lookup
 D DICW^BARCLU2
 Q
