BARROLL ; IHS/SD/LSL - ROLLOVER AFTER POSTING - DEC 4,1996 ; [ 02/15/2006  5:57 PM ]
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**20**;OCT 26, 2005
 ;;
 ; IHS/ASDS/LSL - 06/21/2001 - V1.5 Patch 1 - NOIS NDA-0601-180067
 ;     Allow rollback to function properly
 ;
 ; IHS/ASDS/LSL - 11/26/2001 - V1.6 Patch 1 - NOIS BXX-0501-150094
 ;     Resolve <UNDEF>INS2+16^ABMDLCK1
 ;
 ; IHS/ASDS/LSL - 12/04/2001 - V1.6 Patch 1 - NOIS NEA-1201-180002
 ;     Find the proper 3PB bill if 3P bill IEN matches but not bill
 ;     name or DOS.
 ;
 ; IHS/SD/LSL - 04/04/2002 - V1.6 Patch 2 - NOIS XJG-0302-16095
 ;     Modified to look all possible locations in 3P for bill during
 ;     the rollback process.
 ;
 ; IHS/SD/LSL - 09/22/03 - V1.7 Patch 4 - IM11532
 ;      Resolve UNDEF error when rollback occurs at time of posting
 ;      when more than 50 bills have been flagged.  This error should
 ;      not ocur when rolling back from ROL.
 ;
 ; *********************************************************************
 Q
 ;
EN ;EP - rollover posted bills
 S BARQUIT=0
 S BARBLDA=0
 F  S BARBLDA=$O(BARROLL(BARBLDA)) Q:'BARBLDA  D
 .N X S X=$$VAL^XBDIQ1(90050.01,BARBLDA,15) Q:X'=0
 .D SET
 .Q:'$G(BAR3PDA)
 .Q:'$G(BARRAYGO)
 .D BILL
 K BARROLL,BARBLDA,BAR3PNM,BAR3PDA,BARCNT
 Q
 ; *********************************************************************
 ;
SET ;set rollback status
 K BAR3PDA
 S DIE="^BARBL(DUZ(2),"
 S DA=BARBLDA
 S DR="208////P"
 S DIDEL=90050
 D ^DIE
 K DIDEL
 S BAR3PNM=$$GET1^DIQ(90050.01,BARBLDA,.01)
 S BAR3PNM=$P(BAR3PNM,"-")
 S BAR("3P BILL LOC")=$$FIND3PB^BARUTL(DUZ(2),BARBLDA)
 I BAR("3P BILL LOC")="" D  Q
 . D SETBLRL
 . W *7," ",BAR3PNM," not found in the 3P System"
 . D EOP^BARUTL(0)
 S BAR3PDA=$$GET1^DIQ(90050.01,BARBLDA,17,"I")
 I $P(BAR("3P BILL LOC"),U,2)'=BAR3PDA D
 .S DIE="^BARBL(DUZ(2),"
 .S DA=BARBLDA
 .S DR="17////^S X=$P(BAR(""3P BILL LOC""),"","",2)"
 .S DR=";22////^S X=$P(BAR(""3P BILL LOC""),"","")"
 .S DIDEL=90050
 .D ^DIE
 .K DIDEL
 ;
SETE ;
 Q
 ; *********************************************************************
 ;
 ;** MENU ENTRY -------------------
MENU ;** EP FOR MENU ROLLOVER TO 3-PARTY
 S BARBLDA=""
 S BARQUIT=0,BARCNT=0
 F  S BARBLDA=$O(^BARBL(DUZ(2),"AF","P",BARBLDA)) Q:'BARBLDA  D BILL Q:BARQUIT
 I $G(BARCNT)<1 W !!!!!?14,"*** There are no bills to process for rollover. ***",!!!!!
 K BARCNT
 Q
 ; *********************************************************************
 ;
BILL ;
 ; needs BARBLDA  builds tr amounts by category
 S BARCNT=+$G(BARCNT)+1
 I '(BARCNT#50) D  Q:BARQUIT
 .W !!,BARCNT,?10,"Bills have been processed for Rollover",!
 .D EOP^BARUTL(0)
 .S:'$G(Y) BARQUIT=1
 K BARBL
 D ENP^XBDIQ1(90050.01,BARBLDA,".01;3;15;17;101;114;108;205;206;207;214","BARBL(","I")
 W !,"CHECKING A/R BILL ",BARBL(.01)
 ;
 I $L(BARBL(214)) D  Q
 . W !,"This bill was already rolled over by ",BARBL(214)
 . D SETBLRL
 ;
 S BAR3PDA=BARBL(17)
 I BAR3PDA'>0 D  Q
 . W !,BARBL(.01),"   NOT 3P BILL"
 . D EOP^BARUTL(0)
 . K ^TMP($J,"BARRL",BARBLDA)
 . D SETBLRL
 ;
 I BARBL(15) D  Q
 .;amt not zero rm P status
 .S DIE=$$DIC^XBDIQ1(90050.01)
 .S DA=BARBLDA
 .S DR="208///@"
 .S DIDEL=90050
 .D ^DIE
 .K DIDEL
 W $$EN^BARVDF("IOF"),!,"Reviewing Bill ",BARBL(.01),?70,BARBLDA
 K BART,BARTM,BARTOT
 D SETVAR
 D DSP Q:$G(BARQUIT)
 D ROLL
 Q
 ; *********************************************************************
 ;
SETVAR ; EP
 ; ** PAY = PAY - GROUPER + WRITE OFF - REFUND
LOOP ;
 K BARTOT,BARTM
 S BARTRDA=""
 F  S BARTRDA=$O(^BARTR(DUZ(2),"AC",BARBLDA,BARTRDA)) Q:BARTRDA'>0  D TOTAL^BARTR(BARTRDA)
 I '$D(BARBL) D ENP^XBDIQ1(90050.01,BARBLDA,".01;3;15;17;101;108;114;205;206;207;214;17.2","BARBL(","I")
 S BARBILL=$$GET1^DIQ(90050.01,BARBLDA,13)
 ;array rollback to 3P
 S (BARBIL,BARSUM("AMT"))=$G(BARTOT("T49"))
 S (BARPAY,BARSUM("PAY"))=$G(BARTOT("T40"))
 S (BAR3PCR,BARSUM("3P"))=$G(BARTOT("T108"))
 S (BARWO,BARSUM("WO"))=$G(BARTOT("A3"))
 S (BARNP,BARSUM("NP"))=$G(BARTOT("A4"))
 S (BARDED,BARSUM("DED"))=$G(BARTOT("A13"))
 S (BARCOP,BARSUM("COP"))=$G(BARTOT("A14"))
 S (BARPEN,BARSUM("PEN"))=$G(BARTOT("A15"))
 S (BARGRP,BARSUM("GRP"))=$G(BARTOT("A16"))
 S (BARRF,BARSUM("RF"))=$G(BARTOT("A19"))
 S (BARPCR,BARSUM("PCR"))=$G(BARTOT("A20"))
 ;  IHS/SD/PKD 1.8*20 3/11/11 Sent to Collections "A25"
 S (BARSTC,BARSUM("STC"))=$G(BARTOT("A25"))
 ;pay calculated = payments + grouper + refunds + 3p credits + write off + credits
 S BARPCAL=BARPAY+BARGRP+BARRF+BAR3PCR+BARWO+BARPCR
 S BARSUM=BARPCAL
 ;
 ; array rollback to 3P
 ; IHS/SD/PKD 1.8*20 Include Sent to Collection in ADJUSTMENTS
 ;adjustments= Non-Pay + Deductable + Co-Pay + Penalty
 ;S BARADJ=BARNP+BARDED+BARCOP+BARPEN
 S BARADJ=BARNP+BARDED+BARCOP+BARPEN+BARSTC
 S BARROLL=BARBILL-BARPCAL
 S BARCBAL=BARBILL-BARPCAL-BARADJ
 Q
 ; *********************************************************************
 ;
DSP ;
 S BAR3PNM=$$VAL^XBDIQ1(90050.01,BARBLDA,.01)
 W !,"BILL",?10,$J(BAR3PNM,10)
 W ?25,">PAYMENTS<",?50,">ADJUSTMENTS<"
 W !,"BILLED",?10,$J(BARBILL,10,2)
 W ?25,"3-P CRD",?35,$J(BAR3PCR,10,2),?50,"NON-PAY",?60,$J(BARNP,10,2)
 W !,"PAY TOT",?10,$J(BARPCAL,10,2)
 W ?25,"PAYMENTS",?35,$J(BARPAY,10,2),?50,"DED",?60,$J(BARDED,10,2)
 W !,"ADJ TOT",?10,$J(BARADJ,10,2)
 W ?25,"PAY CRD",?35,$J(BARPCR,10,2)
 W ?50,"CO-PAY",?60,$J(BARCOP,10,2)
 W !,?25,"WR OFFS",?35,$J(BARWO,10,2),?50,"PENALTY",?60,$J(BARPEN,10,2)
 ;IHS/SD/PKD 1.8*20 Print STC in ADJ column, move TOTAL ADJ down 1 line
 ;W !,?25,"GROUPER",?35,$J(BARGRP,10,2),?50,"TOTAL ADJ*",?60,$J(BARADJ,10,2)
 ;W !,?25,"REFUND",?35,$J(BARRF,10,2)
 W !,?25,"GROUPER",?35,$J(BARGRP,10,2),?50,"STC",?60,$J(BARSTC,10,2)
 W !,?25,"REFUND",?35,$J(BARRF,10,2),?50,"TOTAL ADJ*",?60,$J(BARADJ,10,2)
 ;END 1.8*20
 W !,"ROLLOVER",?10,$J(BARROLL,10,2)
 W ?25,"TOTAL PAY*",?35,$J(BARPCAL,10,2),!
 W !,"Pat:",?10,BARBL(101),?40,"Visit Type.: "_$G(BARBL(114))
 W !,?40,"Bill Status: "_$G(BARBL(17.2))
 W !!,?2,"Original bill approved with the following:"
 W !!,?5,"P: ",BARBL(205),!,?5,"S: ",BARBL(206),!,?5,"T: ",BARBL(207)
 I $L(BARBL(214)) W !!,"This bill was already rolled over by ",BARBL(214)
 I $G(BARRAYGO) D EOP^BARUTL(1)
 W !!
 ;
DSPE ;
 Q
 ; *********************************************************************
 ;
ROLL ;** ROLL
 K DIE,DA,DR
 S BAR3PNM=BARBL(.01)
 S:(BAR3PNM["-") BAR3PNM=$P(BAR3PNM,"-")
 S Y=+BAR3PDA
 S DIC=$$DIC^XBDIQ1(9002274.4)
 S DUZO2=DUZ(2)
 S DUZ(2)=$P($G(^BARBL(DUZO2,BARBLDA,0)),U,22)
 S:DUZ(2)="" DUZ(2)=$P($G(^BARBL(DUZO2,BARBLDA,1)),U,8)
 S Y=Y_"^"_DUZ(2)
 S BARGBL=DIC_+Y_")"
 I '$D(@BARGBL) S DUZ(2)=$P($G(^BARBL(DUZO2,BARBLDA,0)),U,8)  ; Parent
 I $D(@BARGBL) D
 . S BARTMP1=$P($G(^ABMDBILL(DUZ(2),+Y,0)),U)    ; 3P bill
 . S BARTMP2=$P($G(^ABMDBILL(DUZ(2),+Y,7)),U)    ; 3P Service date from
 . S BARDOS=$P($G(^BARBL(DUZO2,BARBLDA,1)),U,2)  ; A/R bill DOS Begin
 . I BARTMP1'=BAR3PNM!(BARTMP2'=BARDOS) D
 . . S DUZ(2)=$P($G(^BARBL(DUZO2,BARBLDA,1)),U,8)  ; Use parent 
 I $D(@BARGBL) D EN^XBNEW("START^ABMAROLL(Y,.BARSUM,BAR3PNM)","Y,BARPCAL,BAR3PNM,BARSUM")
 ; array rollback to 3P
 S DUZ(2)=DUZO2
 D SETBLRL
 Q
 ; *********************************************************************
 ;
SETBLRL ; EP **set bill as rolled
 K DIC,DR,DA
 S DIE=$$DIC^XBDIQ1(90050.01)
 S DA=BARBLDA
 S DR="208////R;210///NOW;214////^S X=DUZ;209///^S X=+$G(BARROLL)"
 S DIDEL=90050
 D ^DIE
 K DIDEL
 Q
 ; *********************************************************************
 ;
SUM(BARBLDA)       ;EP display bill summary
 D SETVAR,DSP
 Q
