BARCBTR ; IHS/SD/LSL - COLLECTION BATCH CLOSING TRANSACTIONS DEC 4,1996 ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;
 ; IHS/SD/LSL - 12/05/02 - V1.7 - QAA-1200-130051
 ;     Added quit logic if error in getting new transaction.
 ;     Also split lines for readability and removed unused code
 ;
 ; *********************************************************************
 ;;
EN(BARCBDA)        ;EP COLLECTION BATCH DA
 N BAR,BARCB,BARIT,BARITS,BARCOL,BARERROR
 S BARERROR=0
 ; A/R COLLECTION BATCH data elements
 D ENP^XBDIQ1(90051.01,BARCBDA,".01;3;8;10;15;18;20","BARCB(","I")
 I BARCB(3)'["POST" Q
 I BARCB(20)="COMPLETED" Q
 S BARCOL=$$GET1^DIQ(90051.01,BARCBDA,.01)
 ;** gather all items from subfile
 D ENPM^XBDIQ1(90051.1101,"BARCBDA,0",17,"BARITS(") ; item status
 ;** walk down all items
 S BARITDA=0
 F  S BARITDA=$O(BARITS(BARITDA)) Q:BARITDA'>0  D ITEM
 ; -------------------------------
 ;
 ;** set transmission status to complete
 Q:+BARERROR                ; not all transaction got created
 K DR,DA,DIE
 S DIE=$$DIC^XBDIQ1(90051.01)
 S DA=BARCBDA
 S DR="20////1"
 S DIDEL=90050
 D ^DIE
 K DIDEL
 Q
 ; *********************************************************************
 ;
ITEM ;** process item
 I $E(IOST)="C",IOT["TRM" W "."
 I "E"'[$E(BARITS(BARITDA,17)) Q  ; do not process non-EOBs
 N BART,BARS
 ;** get item demographics
 D ENP^XBDIQ1(90051.1101,"BARCBDA,BARITDA","4:7;17;101;201;203","BARIT(","I")
 ;** set tr basic demographics
 K DR,DA,DIE
 S DR=";4////^S X=BARIT(6,""I"")"
 S DR=DR_";5////^S X=BARIT(5,""I"")"
 S DR=DR_";8////^S X=BARCB(8,""I"")"
 S DR=DR_";10////^S X=BARCB(10,""I"")"
 S DR=DR_";13////^S X=DUZ"
 S DR=DR_";14////^S X=BARCBDA"
 S DR=DR_";15////^S X=BARITDA"
 I BARIT(6) S DR=DR_";16////^S X=$$VALI^XBDIQ1(90050.01,BARIT(6,""I""),4)"
 S DR=DR_";205///^S X=BARIT(201)"
 S BARDR=DR
 ; -------------------------------
 ;
CB2ACP ;** cb>acp  TR account postable
 K DR,DA,DIE
 S DR="101///115"
 S DR=DR_";2///^S X=BARIT(101)"
 S DR=DR_";6////^S X=BARIT(7,""I"")"
 D TRSET
 I BARTR<1 D  Q
 . S BARERROR=1
 . S BARTTYPE="COL BAT TO ACC POST"
 . D MSG
 . H 2
 ;** ac postable amount
 S DIE=90050.02
 S DA=BARIT(7,"I")
 S DR="302///^S X=$$VAL^XBDIQ1(DIE,DA,302)+BARIT(101)"
 S DIDEL=90050
 D ^DIE
 K DIDEL
 D TRFLAG
 ; -------------------------------
 ; Collection batch to facility account
 ;** get subs
 D ENPM^XBDIQ1(90051.1101601,"BARCBDA,BARITDA,0",".01;2","BARS(")
 ;all facilities in the parent satellite file are to have accounts
 S BARSDA=0 F  S BARSDA=$O(BARS(BARSDA)) Q:BARSDA'>0  D FACILITY
 Q
 ; *********************************************************************
 ;
FACILITY ;** set tr  & account updates
 S X="L."_BARS(BARSDA,.01)
 S DIC(0)="XLM"
 S DIC=90050.02
 D ^DIC
 I Y'>0 D  Q
 . W !,*7,BARS(BARSDA,.01)
 . W " NOT IN THE ACCOUNT FILE!",!
 . H 5
 S BARACDA=+Y
 K DR,DA,DIE
 S DR="101////117"
 S DR=DR_";2///^S X=BARS(BARSDA,2)"
 S DR=DR_";6////^S X=BARACDA"
 S DR=DR_";11////^S X=BARSDA"
 D TRSET
 I BARTR<1 D  Q
 . S BARERROR=1
 . S BARTTYPE="COL BAT TO FACILITY"
 . D MSG
 . H 2
 ;** update loc account
 K DR,DA,DIE
 S DA=BARACDA
 S DIE=90050.02
 S DR="301///^S X=$$VAL^XBDIQ1(DIE,DA,301)+BARS(BARSDA,2)"
 S DIDEL=90050
 D ^DIE
 K DIDEL
 D TRFLAG
 Q
 ; *********************************************************************
 ;------------------   SUB ROUTINES CALLED  -------------------
 ;
TRSET ;** set transaction into A/R TRANSACTIONS/IHS data file
 S DR=DR_BARDR
 S (DA,BARTR)=$$NEW^BARTR
 Q:BARTR<1
 S DIE=90050.03
 S DIDEL=90050
 D ^DIE
 K DIDEL
 Q
 ; *********************************************************************
 ;
TRFLAG ;** complete tr
 K DR,DA,DIE
 S DA=BARTR
 S DIE=90050.03
 S DR="104////1"
 S DIDEL=90050
 D ^DIE
 K DIDEL
 Q
 ; *********************************************************************
 ;
DSPAC(DA)          ;** display an account
 N BART,I
 D ENP^XBDIQ1(90050.02,DA,".01;301:305","BART(")
 S I=""
 F  S I=$O(BART(I)) Q:I'>0  W !,I,?7,BART(I),?19,$P(^DD(90050.02,I,0),U)
 D EOP^BARUTL(0)
EDSPAC Q
 ; *********************************************************************
MSG ;
 I $E(IOST)="C",IOT["TRM" D
 . W !,*7,$$CJ^XLFSTR("Could not create "_BARTTYPE_" transaction in A/R Transaction File.")
 . W !,$$CJ^XLFSTR("Please verify "_BARCOL_" item "_BARITDA_" closed properly.")
 Q
