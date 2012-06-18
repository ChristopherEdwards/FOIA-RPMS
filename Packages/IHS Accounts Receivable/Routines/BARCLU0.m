BARCLU0 ; IHS/SD/LSL - COLLECTION BATCH ENTRY FOR EOBS ; 07/22/2010
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**3,4,16,19**;OCT 26, 2005
 ;;
 ; IHS/ASDS/LSL - 06/18/2001 - V1.5 Patch 1 - NOIS HQW-0201-100027
 ;     FM 22 issue.  Modified to include E in DIC(0)
 ;
 ; IHS/SD/LSL - 02/26/04 - V1.7 Patch 5
 ;     Change CHECK prompt to CHK/EFT #
 ;
 ; IHS/SD/TMM 06/18/2010 1.8*Patch 19 - M819
 ;   M819 - NEWITEM^BARCLU moved to ^BARCLU4 due to SAC size limitation
 ; *********************************************************************
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
 Q
 ; *********************************************************************
 ;
CHECK ; EP
 ; for checks
 S DR="11Check/EFT #;"
 ;S:+BARCLID(22,"I") DR=DR_"20R;" ;BAR*1.8*3 UFMS ASK TREASURYDEPOSITNUMBER ;IHS/SD/SDR bar*1.8*4 DD item 4.1.5.1
 S:+BARCLID(22,"I") DR=DR_"20////"_$P($G(^BARCOL(DUZ(2),BARCLDA,0)),U,28)_";"  ;TDN  ;IHS/SD/SDR bar*1.8*4 DD item 4.1.5.1
 S:+BARCLID(12,"I") DR=DR_"12;" ;bk num
 ; -------------------------------
 ;
CACC ; EP
 D CACC^BARCLU01 ;split for size
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
 ; general ledger entry
 S DR="203;" D CACC
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
 ; -------------------------------
 ;
CASH ; EP
 ; cash col
 S DR=""
 D CACC
 Q
 ; *********************************************************************
 ;
EOB ; EP
 ; ask PAYOR (A/R Account with DISV(screen)
 I BARITDA'>$G(BARLAST) D  Q
 . W !,"A sequence error has been detected."
 . W !,"Please notate exactly what you were doing"
 . W !,"to provide assistance to the programmers"
 . W !,BARLAST,?10,BARITDA
 . D EOP^BARUTL(0)
 ; -------------------------------
 ;
EOBEDIT ;
 S BARQUIT=0
 K DR
 S BARPAYOR=$G(BARCLIT(7))
 I BARPAYOR=-1 S BARPAYOR=""
 ; -------------------------------
 ;
RESEL ;
 D SPAYOR
 I Y'>0 S BARQUIT=1 Q
 S BARAC=+Y
 S DIE=BARDIC_BARCLDA_",1,"
 S DA=BARITDA
 S DA(1)=BARCLDA
 S DR="7////"_BARAC
 D ^DIE
 I +BARAC'>0 W !,"FILEING ERROR .. SELECT PAYOR ",! G RESEL
 ; -------------------------------
 ;
SAME  ; EP
  ; loop with same payor
  ;
ITEMEOB ;
 K BARQUIT
 S DIE=BARDIC_BARCLDA_",1,"
 S DA=BARITDA
 S DA(1)=BARCLDA
 S DR="7////^S X=BARAC;2////51;17////E"
 S DIDEL=90050
 D ^DIE
 K DIDEL
 ;
 D BARCLIT^BARCLU
 S BARITTYP=BARCLIT(2)
 W $$EN^BARVDF("IOF")
 W !!,"ENTERING ",BARCL(.01)
 W ?30,"TYPE: ",BARCLID(2)
 ;W ?50,"BATCH TOTAL: ",$$GET1^DIQ(90051.01,BARCLDA,15),!!  ;IHS/SD/SDR bar*1.8*4 DD item 4.1.5.1
 ;start new code IHS/SD/SDR bar*1.8*4 DD item 4.1.5.1
 W ?50,"BATCH TOTAL: ",$$GET1^DIQ(90051.01,BARCLDA,15)
 I +BARCLID(22,"I") D
 .W !,"TDN/IPAC: ",$P($G(^BARCOL(DUZ(2),BARCLDA,0)),U,28)
 .W ?35,"TDN/IPAC AMOUNT: ",$FN($P($G(^BARCOL(DUZ(2),BARCLDA,0)),U,29),",",2)
 .W !,"TDN/IPAC/Deposit Date: ",$$GET1^DIQ(90051.01,BARCLDA_",",30,"E")  ;BAR*1.8*16 IHS/SD/TPF 1/21/2010
 W !!
 ;end new code IHS/SD/SDR bar*1.8*4 DD item 4.1.5.1
 W "ITEM ",BARITDA
 W ?20,BARCLIT(7)
 W !," ^ at Check Number to ask Payor"
 W !," ^ at Payor to exit entry"
 S DR="11Check/EFT #;S:X="""" BARQUIT=1"
 ;S:+BARCLID(22,"I") DR=DR_";20R;" ;BAR*1.8*3 UFMS ASK TREASURY DEPOSIT NUMBER  ;IHS/SD/SDR/ bar*1.8*4 DD item 4.1.5.1
 ;start new code IHS/SD/SDR bar*1.8*4 DD item 4.1.5.1
 S BARTDN=$P($G(^BARCOL(DUZ(2),BARCLDA,0)),U,28)
 S:+BARCLID(22,"I") DR=DR_";20////^S X=BARTDN"
 ;end new code IHS/SD/SDR bar*1.8*4 DD item 4.1.5.1
 S DIDEL=90050
 D ^DIE
 K DIDEL
 I +BARCLID(22,"I") W !,"TREASURY DEPOSIT/IPAC: "_BARTDN  ;IHS/SD/SDR bar*1.8*4 DD item 4.1.5.1
 ;
 I $D(Y) S BARQUIT=1
 I $G(BARQUIT) G EOBEDIT ; return to payor question
 ;BEGIN BAR*1.8*16 IHS/SD/TPF 1/21/2010
 N LIST,DOCARE
 D CHECKDUP($$GET1^DIQ(90051.1101,BARITDA_","_BARCLDA_",",11),.LIST)
 I $D(LIST) D  G:DOCARE ITEMEOB
 .K DIR
 .S DIR(0)="Y"
 .S DIR("B")="No"
 .W !!,"Duplicates have been found."
 .S DIR("A")="Are you sure you wish to use this check number?"
 .D ^DIR
 .S DOCARE='Y
 K LIST,DOCARE
 W !!
 ;END
 S DR="103///@;"
 S:BARCLID(12,"I") DR=DR_"12;" ;bnk num
 ;start old code IHS/SD/SDR bar*1.8*4 DD item 4.1.5.1
 ;S DR=DR_"101;" ;amt
 ;S:BARCLID(13,"I") DR=DR_"10;" ;in/out pat
 ;end old code start new code 4.1.5.1
 S DIDEL=90050
 D ^DIE
 K DIDEL
AMT S DR="101" ;amt
 S:($P($G(^BARCOL(DUZ(2),BARCLDA,0)),U,28)["NONPAY") DR=DR_"////0"  ;IHS/SD/SDR bar*1.8*4 SCR 88
 D ^DIE
 K DR
 I +BARCLID(22,"I"),($P($G(^BARCOL(DUZ(2),BARCLDA,1,BARITDA,1)),U))>($P($G(^BARCOL(DUZ(2),BARCLDA,0)),U,29)) D  G AMT
 .W !!,"AMOUNT OF CREDIT IS GREATER THAN TDN/IPAC OF ",$FN($P($G(^BARCOL(DUZ(2),BARCLDA,0)),U,29),",",2),".  PLEASE CORRECT"
 S:BARCLID(13,"I") DR="10;" ;in/out pat
 ;end new code IHS/SD/SDR bar*1.8*4 DD item 4.1.5.1
 ;S:'BARSPAR(2,"I") DR=DR_"8///^S X=BARSPAR(.01)"  ;IHS/SD/SDR bar*1.8*4 DD item 4.1.5.1
 S:'BARSPAR(2,"I") DR=$S($G(DR)'="":DR_"8///^S X=BARSPAR(.01)",1:"8///^S X=BARSPAR(.01)")  ;IHS/SD/SDR bar*1.8*4 DD item 4.1.5.1
 S DIDEL=90050
 ;D ^DIE  ;IHS/SD/SDR bar*1.8*4 DD item 4.1.5.1
 I $G(DR) D ^DIE  ;IHS/SD/SDR bar*1.8*4 DD item 4.1.5.1
 K DIDEL
 ;
 I BARSPAR(2,"I") D EOBSUB I 1 ;multiple 3P facilities
 E  D INSSUB
 D BARCLIT^BARCLU
 D DISPLAY^BARCLU1
 K BARQUIT
 ; -------------------------------
 ;
ASK ;
 K DIR
 S DIR(0)="S^E:EDIT;D:DELETE;C:CONTINUE"
 S DIR("B")="CONTINUE"
 D ^DIR
 G:Y="E" EOBEDIT
 I Y="D" D
 . K DA
 . S DIK=$$DIC^XBDIQ1(90051.1101)
 . S DA=BARITDA
 . S DA(1)=BARCLDA
 . D ^DIK
 . S BARCL(7)=BARCL(7)-1
 ; -------------------------------
 ;
EITEMEOB ;
 ;
FILE ;
 ; file entry and check counter
 K DIE,DR,DA
 S DIE=$$DIC^XBDIQ1(90051.01)
 S DR="7///"_BARCL(7)
 S DA=BARCLDA
 S BARLAST=BARCL(7)
 S DIDEL=90050
 D ^DIE
 K DIDEL
 ;D NEWITEM^BARCLU  ;M819*DEL*TMM*20100722--moved to ^BARCLU4 due to rtn size
 D NEWITEM^BARCLU4 ;get new item to enter
 G SAME
 ; *********************************************************************
 ;
EOBSUB ;EP
 ; enter data for sub EOB locations and amounts"
 ;
LOOP ;EP
 ; loop subs for entries and amounts
 K DIC,DR,DA,DIE
 S DA(2)=BARCLDA
 S DA(1)=BARITDA
 S DIC="^BARCOL(DUZ(2),"_BARCLDA_",1,"_BARITDA_",6,"
 S DIC(0)="EAQMLZ"
 S DIC("P")=$P(^DD(90051.1101,601,0),U,2)
 F  D BARCLIT^BARCLU,DSPSUB S DIC("A")="Cr="_BARCLIT(101)_" Bal=$"_BARCLIT(202.5)_"  Select Location ?",DIC(0)="AEQMLZ" D ^DIC Q:+Y'>0  D  Q:+BARCLIT(202.5)=0
 .S DIE=DIC
 .S DA=+Y
 .S DR="2///^S X=BARCLIT(202.5)+$$VAL^XBDIQ1(DIE,.DA,2);2;S BARAMT=X"
 .S DIDEL=90050
 .D ^DIE
 .K DIDEL,DIC("P")
 .D BARCLIT^BARCLU
 .I BARCLIT(202.5)<0 D
 .. W *7,?40,"BALANCE : ",BARCLIT(202.5)
 .. D KILLSUB
 .. W !,"NEGATIVE BALANCE .. ENTRY REMOVED",!
 D BARCLIT^BARCLU
 I +BARCLIT(202.5)'=0 D  G LOOP
 .W !!,"BALANCE OFF BY ",BARCLIT(202.5)
 .W !!?10,"CREDITS CAN NO LONGER BE PLACED INTO THE UNDISTRIBUTED FUND ACCOUNT"
 .W !?10,"PLEASE PLACE THE BALANCE INTO THE APPROPRIATE LOCATION(S)"
 .H 2
 ; -------------------------------
 ;
ENDEOB ;
 Q
 ; *********************************************************************
 ;
SPAYOR ; EP
 ; from BARCLU3
 D ^XBNEW("SELPAYOR^BARCLU0:Y;BARPAYOR") ;get a payor
 ; returns Y from a dic call
 Q
 ; *********************************************************************
 ;
SELPAYOR ; EP
 ; select A/R Account for Insurer only
 K DIC
 S DIC="^BARAC(DUZ(2),"
 S DIC(0)="AEZQM"
 S DIC("A")="PAYOR: "
 S DIC("S")="I $P(^(0),U)[""AUTNINS"",$P(^(0),U,10)=$$VALI^XBDIQ1(200,DUZ,29)"
 S DIC("B")=$G(BARPAYOR)
 D ^DIC
 Q
 ; *********************************************************************
 ;
INSSUB ; EP
 ; insert single sub node
 D DELSUBS ;delete existing subs
 K DIC,DR,DA,DIE
 S DA(2)=BARCLDA
 S DA(1)=BARITDA
 S DIC=$$DIC^XBDIQ1(90051.1101601)
 S DIC(0)="=EL"
 S DIC("P")=$P(^DD(90051.1101,601,0),U,2)
 S BART=$E(DIC,1,$L(DIC)-1)_")" K @BART
 N BART
 D ENP^XBDIQ1(90051.1101,"BARCLDA,BARITDA","8;101","BART(")
 S X=BART(8)
 S DIC("DR")="2///^S X=BART(101)"
 D ^DIC
 Q
 ; *********************************************************************
 ;
KILLSUB ; EP
 ; kill eob sub when the entry is 0
 D ^XBNEW("KSUB^BARCLU0:DA*;DIE")
 Q
 ; *********************************************************************
 ;
KSUB ; EP
 ; kill eob sub
 S DIK=DIE
 D ^DIK
 Q
 ; *********************************************************************
 ;
DSPSUB ;
 D DSPSUB^BARCLU1
 Q
 ; *********************************************************************
 ;
END ;
DELSUBS ; EP
 ; REMOVE EOBSUBS
 N BART,DIE
 S DIE=$$DIC^XBDIQ1(90051.1101601)
 D ENPM^XBDIQ1(90051.1101601,"BARCLDA,BARITDA,0",".01","BART(")
 S BART=0
 F  S BART=$O(BART(BART)) Q:'BART  D
 . S DA=BART
 . D PARSE^XBDIQ1("BARCLDA,BARITDA,DA")
 . D KILLSUB
 Q
 ;BAR*1.8*16 IHS/SD/TPF 1/21/2010
CHECKDUP(CHK,LIST) ;EP - CHECK FOR DUPLICATE CHEACKS IN A/R COLLECTION BATCH
 Q:CHK=""
 N CHECNUM,CHECK,COLBAT,ITEM,AMOUNT,COLNAM
 K LIST
 S CNT=0
 S COLBAT=""
 F  S COLBAT=$O(^BARCOL(DUZ(2),"D",CHK,COLBAT)) Q:COLBAT=""  D
 .Q:BARCLDA=COLBAT
 .S ITEM=""
 .F  S ITEM=$O(^BARCOL(DUZ(2),"D",CHK,COLBAT,ITEM)) Q:'ITEM  D
 ..S CNT=CNT+1
 ..S COLNAM=$$GET1^DIQ(90051.01,COLBAT_",",.01,"E")
 ..S ACCOUNT=$$GET1^DIQ(90051.1101,ITEM_","_COLBAT_",",7,"E")
 ..S AMOUNT=$$GET1^DIQ(90051.1101,ITEM_","_COLBAT_",",101,"E")
 ..S LIST(CNT)=COLNAM_U_ITEM_U_ACCOUNT_U_AMOUNT
 Q:'$D(LIST)
 D DUPHDR(CNT)
 D SHOLIST(.LIST)
 Q
 ;
DUPHDR(CNT) ;EP - CHKDUP HEADER
 W !!,"Potential duplicate"_$S(CNT>1:"s",1:"")_" found in the following batch"_$S(CNT>1:"es",1:"")_":"
 Q
 ;
SHOLIST(LIST) ;EP - SHOW LIST OF DUPES
 N CNT
 S CNT=""
 W !
 F  S CNT=$O(LIST(CNT)) Q:'CNT  D
 .W !,CNT,"."
 .W ?3,$P(LIST(CNT),U)
 .W ?34,$P(LIST(CNT),U,2)
 .W ?37,$P(LIST(CNT),U,3)
 .W ?65,$J($FN($P(LIST(CNT),U,4),",",2),15)
 W !!
 ;K DIR
 ;S DIR(0)="E"
 ;D ^DIR
 Q
