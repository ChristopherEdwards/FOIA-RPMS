BARCLU2 ; IHS/SD/LSL - ASK MORE QUESTIONS ON A COLLECTION ITEM ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**4**;OCT 26, 2005
 ;;
 ;select item
 W $$EN^BARVDF("IOF")
 W !,"MORE FUNCTION - add items that were not asked"
 K DIC
 ; -------------------------------
 ;
ITEM ; EP
 D ^XBSFGBL(90051.1101,.DIC)
 S DIC=$P(DIC,"DA,")
 S DIC("W")="D DICW^BARCLU2"
 S DIC("A")="ITEM: "
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
 S DR=""
 ; -------------------------------
 ;
EDITEM ; EP
 ; edit collection item
 K DIE,BARBL
 S DA=BARITDA
 S DA(1)=BARCLDA
 S DIE=BARDIC_BARCLDA_",1,"
 D:BARX=51 EOB
 D:BARX=52 CASH
 D:BARX=53 CC
 D:BARX=55 REFUND
 D:BARX=81 CHECK
 D:BARX=99 GL
 D DISPLAY
 G ITEM
 ; *********************************************************************
 ;
CHECK ; EP
 ; for checks
 S:'+BARCLID(12,"I") DR=DR_"12;" ;bk num
 ; -------------------------------
 ;
CACC ; EP
 ; for other types
 I BARX=52 S:'+BARCLID(15,"I") DR=DR_"6///^S X="""" D ^BARBLLK S:$D(BARBL)>1 X=BARBL(.01);Q;" ;bill CA
 I BARX=53 S:'+BARCLID(14,"I") DR=DR_"6///^S X="""" D ^BARBLLK S:$D(BARBL)>1 X=BARBL(.01);Q;" ;bill CC
 I BARX=81 S:'+BARCLID(16,"I") DR=DR_"6///^S X="""" D ^BARBLLK S:$D(BARBL)>1 X=BARBL(.01);Q;" ;bill CK
 K BARBL
 S DIDEL=90050
 D ^DIE
 K DIDEL
 S DR=""
 I '$D(BARBL) D
 .I BARX=52 S:'+BARCLID(18,"I") DR=DR_"5;" ;pat CA
 .I BARX=53 S:'+BARCLID(17,"I") DR=DR_"5;" ;pat CC
 .I BARX=81 S:'+BARCLID(19,"I") DR=DR_"5;" ;pat CK
 I '$D(BARCLIT(301)) S DR=DR_"301;"
 S DIDEL=90050
 D ^DIE
 K DIDEL
 W:DR="" !,"ALL QUESTIONS ALREADY ASKED"
 H 5
 Q
 ; *********************************************************************
 ;
CC ; EP
 ; credit card
 S DR=""
 D CACC
 Q
 ; *********************************************************************
 ;
GL ; EP
 ; general ledger
 S DR=203
 D CACC
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
 D CACC
 Q
 ; *********************************************************************
 ;
EOB ; EP
 ; EOB entry
 D PAYOR
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
 ;IHS/SD/AML 11/26/07 - Print treasury dep number 
FLDS ;;203;GENERAL LEDGER^11;CHECK NUMBER^12;BANK NUMBER^13;CC NUMBER^14;CC VER NUMBER^101;AMOUNT PAID^102;REFUND^7;A/R ACCOUNT^201;PAYOR^8;LOCATION OF SERVICE^10;INPAT/OUTPAT^5;PATIENT^6;BILL^16;AUTO PRINT^20;TREASURY DEPOSIT/IPAC #
 ;
 S BARY=$P($T(FLDS),";;",2)
 W $$EN^BARVDF("IOF")
 W !,BARCL(.01)
 W ?22,"ITEM: ",BARITDA
 W "    TYPE: ",BARCLIT(2)
 W ?54,"BATCH TOTAL: ",$$GET1^DIQ(90051.01,BARCLDA,15)
 W !
 F BARI=1:1:70 W "="
 F BARI=1:1 S BARE=$P(BARY,U,BARI) Q:BARE=""  D
 . S BARFLD=+BARE
 . S BARNM=$P(BARE,";",2)
 . I $G(BARCLIT(BARFLD))]"" W !?5,BARNM,?30,BARCLIT(BARFLD)
 I $D(BARCLIT(301)) D
 . W !,"COMMENTS"
 . F BARI=1:1 Q:'$D(BARCLIT(301,BARI))  W !,?3,BARCLIT(301,BARI)
 W ! F BARI=1:1:70 W "="
 W !
 K BARY,BARI,BARNM,BARFLD
 Q
 ; *********************************************************************
 ;
END ;
DICW ; EP
 ; help display on Item lookup
 D ^XBNEW("DICW1^BARCLU2:Y;BARCL*")
 Q
 ; *********************************************************************
 ;
DICW1  ;EP
 K BARCLIT
 N DIC,DA,DR,DIQ
 Q:'+Y
 S DA=+Y
 N Y
 S DIQ="BARCLIT("
 S DIQ(0)="I"
 S DIC=90051.1101
 S DA(1)=BARCLDA
 S DR="2;2.5;7;11;101"
 D EN^XBDIQ1
 W ?7,$J($E(BARCLIT(11),1,9),10)
 W:$L(BARCLIT(11))>9 "*"
 W ?18,$J(BARCLIT(101),8,2),?28,BARCLIT(7),?58,$E(BARCLIT(2.5),1,2)
 ;
EDICW ;
 Q
