BARCLU ; IHS/SD/LSL - USER ENTRY INTO COLLECTION BATCHES ;; 07/09/2010
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**3,4,6,16,18,19**;OCT 26,2005
 ;;
 ; IHS/ASDS/LSL - 06/15/01 - V1.5 Patch 1 - HQW-0201-100027
 ;     fm 22 issue.  Modified to include E in DIC(0)
 ;
 ; IHS/SD/SDR - v1.8 p4
 ;   Added prompt for TDN and amount for batch
 ;
 ; IHS/SD/AR  03/31/2010 1.8*18, low priorities, TDN dupl
 ; 
 ; IHS/SD/TMM 06/18/2010 1.8*19 (M819), Add Prepayment functionality.
 ;      See work order 3PMS10001
 ;      ------------------------
 ;      BARCLU4 is new routine for Prepayment functionality in collection entry.
 ;      819_1. Display prepayments not assigned to a batch (^BARCLU,^BARCLU4)
 ;      819_2. Remove prompt: AUTO PRINT RECEIPT (^BARCLU01)
 ;      819_3. Prepayment entry ^BARPPY01 (new routine),^BARCLU1,^BARPUTL
 ;      819_4. Display prepayments matching payment type selected (^BARCLU,^BARCLU4)
 ;      819_5. Allow user to assign prepayment to batch (^BARCLU,^BARCLU4,^BARCLU01,^BARPUTL,^BARPST1,^BARBLLK)
 ;      819_6. Print Prepayment Receipt (^BARPPY02) (new routine)
 ; ********************************************************************* ;
 ;
ENTRY ;
 ; lookup collection id I '$D(BARUSR) D INIT^BARUTL
 ;---select collection batch
 ;D KILL^XUSCLEAN  ;UFMS BAR*1.8*3
 S X1=$$GET1^DIQ(200,DUZ,20.4,"I")
 I X1']"" D  Q
 . W *7,!!,"NO ELECTRONIC SIGNATURE CODE ON FILE"
 . W !,"Use ^TBOX to give yourself one",!
 . D EOP^BARUTL(0)
 D SIG^XUSESIG
 Q:X1=""  ;elec signature test
 ; -------------------------------
 ;
G ;
 I '$D(BARUSR) D INIT^BARUTL
 K DIC
 S DIC="^BAR(90051.02,DUZ(2),"
 S DIC(0)="AEZQM"
 S DIC("S")="I $D(^BAR(90051.02,DUZ(2),""AB"",DUZ,+Y))" ;screen for user
 D ^DIC                        ;Select A/R COLLECTION POINT/IHS NAME:
 Q:Y'>0
 S BARDA=+Y
 K BARCLID
 D BARCLID ;setup BARCLID collection id array
 D DISPPAY^BARCLU4       ;Display unassigned Prepayments  ;M819*ADD*TMM*20100709 (M819_1)
 G:BARCLID(6)="" NEW
 I BARCLID(6.5)="POSTABLE" G NEW
 I BARCLID(6.5)'="OPEN",BARCLID(6.3)'=BARUSR(.01) G NEW
 I BARCLID(6.5)="OPEN",BARCLID(6.3)=BARUSR(.01) G ENTER
 I BARCLID(6.5)="OPEN",BARCLID(6.3)'=BARUSR(.01) G INUSE
 I BARCLID(6.5)="REVIEW",BARCLID(6.3)=BARUSR(.01) G INREVIEW
 G ENTER
 ; *********************************************************************
 ;
NEW ; EP
 ; open a new batch
 D NEW^BARCLU1
 ; -------------------------------
 ;
ENTER ; EP
 ; Enter/Add new collection item
 K DIC,DR,DA,BARQUIT
 S BARDIC="^BARCOL(DUZ(2),"
 S (BARDA,BARCLDA)=BARCLID(6,"I")
 D BARCL
 S X=+$$GET1^DIQ(90051.01,BARCLDA,7)
 S Y=+$O(^BARCOL(DUZ(2),BARCLDA,1,"A"),-1)
 I X'=Y D  G ENTER
 .W !,*7,"An out of sequence item ",Y," has been detected and removed."
 .W !,"Please recheck your entries"
 .K DIK
 .S DA(1)=BARCLDA
 .S DA=Y
 .S DIK=$$DIC^XBDIQ1(90051.1101)
 .D ^DIK
 .K DIK,DIR
 .S DIR(0)="EA"
 .S DIR("A")="<cr> to continue"
 .D ^DIR
 .K DIR
 ;D NEWITEM  ;IHS/SD/SDR bar*1.8*4
 W $$EN^BARVDF("IOF")
 W !!,"ENTERING ",BARCL(.01)
 ;W ?30,"TYPE: ",BARCLID(2)  ;IHS/SD/SDR bar*1.8*4 DD item 4.1.5.1
 W ?35,"TYPE: ",BARCLID(2)  ;IHS/SD/SDR bar*1.8*4 DD item 4.1.5.1
 ;W ?50,"BATCH TOTAL: ",$$GET1^DIQ(90051.01,BARCLDA,15),!!  ;IHS/SD/SDR bar*1.8*4 DD item 4.1.5.1
 W ?55,"BATCH TOTAL: ",$$GET1^DIQ(90051.01,BARCLDA,15)  ;IHS/SD/SDR bar*1.8*4  DD item 4.1.5.1
 ;start new code IHS/SD/SDR bar*1.8*4  DD item 4.1.5.1
 I $P($G(^BARCOL(DUZ(2),BARCLDA,0)),U,28)'="",(+$G(BARCLID(22,"I"))) D
 .W !,"TDN/IPAC: ",$P($G(^BARCOL(DUZ(2),BARCLDA,0)),U,28)
 .W ?35,"TDN/IPAC AMOUNT: ",$FN($P($G(^BARCOL(DUZ(2),BARCLDA,0)),U,29),",",2),!!
 ;
 ;start old code IHS/SD/SDR bar*1.8*6 IM29168
TDN ;I $P($G(^BARCOL(DUZ(2),BARCLDA,0)),U,28)=""!($P($G(^BARCOL(DUZ(2),BARCLDA,0)),U,29)="")&(+$G(BARCLID(22,"I"))) D  Q:$P($G(^BARCOL(DUZ(2),BARCLDA,0)),U,28)=""&($P($G(^BARCOL(DUZ(2),BARCLDA,0)),U,29)="")&($G(BARFLG)'=1)
 ;end old code start new code IM29168
 I $P($G(^BARCOL(DUZ(2),BARCLDA,0)),U,28)=""!(+$P($G(^BARCOL(DUZ(2),BARCLDA,0)),U,29)=0)&(+$G(BARCLID(22,"I"))) D  Q:($P($G(^BARCOL(DUZ(2),BARCLDA,0)),U,28)="")&(+$P($G(^BARCOL(DUZ(2),BARCLDA,0)),U,29)=0)&($G(BARFLG)'=1)
 .;end new code IM29168
 .W !,"You will now be prompted for the Treasury Deposit/IPAC and an amount."
 .W !,"The Treasury Deposit/IPAC will be used for all items in this batch."
 .W !,"The total of all the items entered must equal the amount entered here or"
 .W !,"the batch will not finalize.",!!
 .K DIC,DIE,DR,DA,X,Y
 .K BARFLG
 .S DIE="^BARCOL(DUZ(2),"
 .S DA=BARCLDA
 .;IHS/SD/AR 03/31/2010 low priorities, TDN dupl
 .I '$$IHS^BARUFUT(DUZ(2)) D
 ..K DIE("NO^")   ;BAR*1.8*16
 ..S DR="28Enter TDN/IPAC//"  ;BAR*1.8*16
 .E  D
 ..S DIE("NO^")=""
 ..S DR="28R~Enter TDN/IPAC//"  ;BAR*1.8*16
 .;S DR="28Enter TDN/IPAC//;29Enter TDN/IPAC Dollar Amount for this Batch//"
 .D ^DIE
 .K DIE("NO^")
 .N LIST,DOCARE,DUPFDA
 .D CHECKDUP($P($G(^BARCOL(DUZ(2),BARCLDA,0)),U,28),.LIST)
 .I $D(LIST) D
 ..K DIR
 ..S DIR(0)="Y"
 ..S DIR("B")="No"
 .E  D
 ..W "  No duplicates found."
 .K LIST,DOCARE
  .I '$$IHS^BARUFUT(DUZ(2)) D
 ..K DIE("NO^")   ;BAR*1.8*16
 ..S DR="30Enter TDN/IPAC/Deposit Date;29Enter TDN/IPAC Dollar Amount for this Batch//"  ;BAR*1.8*16
 .E  D
 ..S DIE("NO^")=""
 ..S DR="30R~Enter TDN/IPAC/Deposit Date;29R~Enter TDN/IPAC Dollar Amount for this Batch//"  ;BAR*1.8*16
 .;S DR="28Enter TDN/IPAC//;29Enter TDN/IPAC Dollar Amount for this Batch//"
 .D ^DIE
 .K DIE("NO^")
 .Q:$P($G(^BARCOL(DUZ(2),BARCLDA,0)),U,28)=""!($P($G(^BARCOL(DUZ(2),BARCLDA,0)),U,29)="")
 .;IHS/SD/AR 03/31/2010 end low priorities, TDN dupl
 .W !!,"----------------------------------",!
 .W "TDN/IPAC: ",$P($G(^BARCOL(DUZ(2),BARCLDA,0)),U,28)
 .W !,"  Amount: ",$FN($P($G(^BARCOL(DUZ(2),BARCLDA,0)),U,29),",",2),!
 .W "TDN/IPAC/Deposit Date: ",$$GET1^DIQ(90051.01,BARCLDA_",",30,"E")  ;BAR*1.8*16
 .;check for NONPAYMENT and dollar amt '=0
 .I $P($G(^BARCOL(DUZ(2),BARCLDA,0)),U,28)["NONPAY",(+$P($G(^BARCOL(DUZ(2),BARCLDA,0)),U,29)'=0) D  Q
 ..W !!,"Cannot batch a dollar amount to a NONPAYMENT TDN/IPAC"
 ..S DIE="^BARCOL(DUZ(2),"
 ..S DA=BARCLDA
 ..S DR="28////@;29////@"
 ..D ^DIE
 .K DIR,DIC,DIE,DR,DA,X,Y
 .S DIR(0)="Y"
 .S DIR("A")="Correct? "
 .S DIR("B")="YES"
 .D ^DIR K DIR
 .I Y<1 D
 ..S DIE="^BARCOL(DUZ(2),"
 ..S DA=BARCLDA
 ..S DR="28////@;29////@"
 ..D ^DIE
 ..S BARFLG=1
 .W !
 ;
 ;I $P($G(^BARCOL(DUZ(2),BARCLDA,0)),U,28)="",(+$G(BARCLID(22,"I")))  G TDN  ;go back up and prompt for TDN again  ;IHS/SD/SDR bar*1.8*6 IM29168
 ;I ($P($G(^BARCOL(DUZ(2),BARCLDA,0)),U,28)="")!(($P($G(^BARCOL(DUZ(2),BARCLDA,0)),U,28)'="NONPAYMENT")&(+$P($G(^BARCOL(DUZ(2),BARCLDA,0)),U,29)=0)),(+$G(BARCLID(22,"I")))  G TDN  ;go back up & prompt for TDN again ;IHS/SD/SDR bar*1.8*6 IM29168
 ;PER TONI JOHNSON TRIBALS DO NOT HAVE TO POPULATE THESE FIELDS BAR*1.8*16  
 I ($P($G(^BARCOL(DUZ(2),BARCLDA,0)),U,28)="")!(($P($G(^BARCOL(DUZ(2),BARCLDA,0)),U,28)'="NONPAYMENT")&(+$P($G(^BARCOL(DUZ(2),BARCLDA,0)),U,29)=0)),(+$G(BARCLID(22,"I"))),($$IHS^BARUFUT(DUZ(2)))  G TDN
 D NEWITEM^BARCLU4
 W !
 S DA(1)=BARCLDA
 S DA=BARITDA
 S DIE="^BARCOL(DUZ(2),"_DA(1)_",1,"
 ;end new code IHS/SD/SDR bar*1.8*4 DD item 4.1.5.1
 W "ITEM ",BARITDA
 ;
 ;----  51:EOB 52:CASH 53:CC 55:REFUND 81:CHECK
 ;
 I BARCLID(2,"I")="E" S DR="2////51"
 E  D
 . S DR="2//^S X=$G(BARITTYP)"                   ;2=
 . W !,"Up-Arrow at Transaction Type to exit loop and KILL New Entry"
 S DIDEL=90050
 D ^DIE                   ;prompts for PAYMENT TYPE:
 K DIDEL
 I $D(Y) S BARQUIT=1 G NOMORE
 D BARCLIT
 S BARITTYP=BARCLIT(2)
 ; -------------------------------
 ;
DR ;EP
 ; setup DR as to type of collection item
 S BARX=BARCLIT(2,"I")
 I 'BARX D  G NOMORE
 . W *7,!,"ERROR IN TRANSACTION TYPE"
 . S BARQUIT=1
 ; -------------------------------
 ; 
 ; Display Prepayments of same PAYMENT TYPE
 D SELPPAY^BARCLU4  ;M819*ADD*TMM*20100710
 ;
EDITEM ;EP
 ; edit collection item
 D EDITEM^BARCLU0   ;edit the various types of items    ;prompts for Credit:
 ;
 I $G(BARQUIT) G NOMORE ;can be set by EOB with "^" at check number
 D BARCLIT
 ; -------------------------------
 ;
REVIEW ;EP
 ; review item
 I $E(BARCLIT(2))'="E",BARCLID(20,"I") G ASK    ;20=NON EOB DATA REVIEW/EDIT
 I $E(BARCLIT(2))="E",BARCLID(21,"I") G ASK     ;21=EOB DATA REVIEW/EDIT
 G FILE
 ; *********************************************************************
 ;
ASK ;
 D DISPLAY
 ;** check required fields
 S BARERROR=0
 ;F I=2,7,8,101 D
 F I=2,7,8,101,20 D  ;BAR*1.8*3 UFMS MAKE TREASURY NUMBER REQUIRED
 .I I=20,('$G(BARCLID(22,"I"))) Q  ;IHS/SD/TPF BAR*1.8*4 IM26177
 .I $L(BARCLIT(I))'>0 D
 ..W !,$P(^DD(90051.1101,I,0),U),?20," IS MISSING"
 ..S BARERROR=1
 K DIR
 S DIR(0)="S^E:Edit;D:Delete;F:FILE"
 S DIR("B")="F"
 S:BARERROR DIR("B")="E"
 D ^DIR
 I Y="E" D  G EDITEM
 .W $$EN^BARVDF("IOF")
 .W !!,"ENTERING ",BARCL(.01),!!
 .W "ITEM ",BARITDA
 I Y="D" D  G ENTER
 .S DIK=$$DIC^XBDIQ1(90051.1101)
 .S DA(1)=BARCLDA
 .S DA=BARITDA
 .D ^DIK
 G:BARERROR ASK
 ;--------------------------------
 ;
FILE ; EP
 K DIE,DR,DA
 S DIE=$$DIC^XBDIQ1(90051.01)
 S DR="7///^S X=BARCL(7)"
 S DA=+BARCL("ID")
 S DIDEL=90050
 D ^DIE
 K DIDEL
 K BARDA
 S BARITAC=BARCLIT(7)
 S BARITLC=BARCLIT(8) ;set defaults
 I +$G(BARPPSEL)>0 D PPUPDT^BARCLU4   ;update A/R Prepayment file with batch assignment ;M819*ADD*TMM*20100711
 W !!         ;M819*ADD*TMM*20100711
 D PAZ^BARRUTL    ;Press return to continue        ;M819*ADD*TMM*20100711
 G ENTER
 ; *********************************************************************
 ;
SELECT ;EP
 ; select action
 ;W !,$$GET1^DIQ(90051.01,BARCLDA,15)  ;bar*1.8*4
 K DIR,DIE
 S DIR(0)="S^A:ADD;M:MORE;E:EDIT;Q:QUIT"
 S DIR("A")="A/M/E/Q"
 S DIR("B")="ADD"
 D ^DIR
 I Y="A" G ENTER
 I Y="M" D ^BARCLU2 G SELECT
 I Y="E" D ^BARCLU3 G SELECT
 I Y="Q" G EXIT
 ; -------------------------------
 ;
NOMORE ;EP
 ; nomore entries backout last entry
 S (DIK,DIE)=$$DIC^XBDIQ1(90051.1101)
 S DA=BARITDA
 S DA(1)=BARCLDA
 D ^DIK
 K BARQUIT
 K DIE,DR,DA
 S BARCL(7)=BARCL(7)-1
 ;start new code IHS/SD/SDR bar*1.8*4 DD item 4.1.5.1
 W !!,"GETTING READY TO RUN DETAIL REPORT."
 W "  PLEASE VALIDATE "_$S($G(BARCLID(22,"I")):"TREASURY DEPOSIT/IPAC AND ",1:"")_"AMOUNT FOR ACCURACY"
 S BARSEL="D",BARBATCH=BARCLDA,BARBEX=BARCL(".01") D D2^BARCLRG G:$D(BAREFLG) SELECT D PRINT^BARCLRG
 ;end new code IHS/SD/SDR bar*1.8*4 DD item 4.1.5.1
 G SELECT
 ; *********************************************************************
 ;
INUSE ;EP
 ; in use
 W !!,"Sorry  ",BARCLID(.01),"  is OPENED by  : ",BARCLID(6.3),!!
 S DA=0
 S DA(1)=+BARCLID("ID")
 S BARCLDA=DA(1)
 D ENPM^XBDIQ1(90051.2201,"BARCLDA,0",.01,"BARSUP(")
 I $D(BARSUP(DUZ)) D  G ENTER
 . W !,"YOU ARE A SUPERVISOR SO YOU ARE ENTERING THE BATCH",!
 . D EOP^BARUTL(1)
 . K BARSUP
 D EOP^BARUTL(1)
 Q
 ; *********************************************************************
 ;
INREVIEW ;EP
 ; in REVIEW
 W !!,"Sorry  ",BARCLID(.01),"  is in REVIEW by >you< : ",BARCLID(6.3),!!
 D EOP^BARUTL(1)
 G ENTER
 ; *********************************************************************
 ;
EXIT ;EP
 ; exit program
 ;start new code IHS/SD/SDR bar*1.8*4 DD item 4.1.5.1
 ;don't do for batches created prior to 10/1/07
 I $P($P($G(^BARCOL(DUZ(2),BARCLDA,0)),U,4),".")<3071001 Q
 Q:'$G(BARCLID(22,"I"))
 S BARITTOT=$$ITEMTOT(BARCLDA)  ;get total of items
 I +BARITTOT'=(+$P($G(^BARCOL(DUZ(2),BARCLDA,0)),U,29)) D
 .W !!,"BATCHED AMOUNT OF "_$FN(BARITTOT,",",2)_" DOES NOT MATCH THE TDN/IPAC AMOUNT OF "
 .W $FN($P($G(^BARCOL(DUZ(2),BARCLDA,0)),U,29),",",2)_" FOR"
 .W !,"TDN/IPAC "_$P($G(^BARCOL(DUZ(2),BARCLDA,0)),U,28)_".",!
 .;
 .I BARITTOT<($P($G(^BARCOL(DUZ(2),BARCLDA,0)),U,29)) D
 ..W !,"PLEASE REVIEW YOUR ENTRIES AND EITHER CORRECT THE AMOUNT OF THE TDN/IPAC OR ADD ADDITIONAL ITEMS TO BALANCE."
 .I BARITTOT>($P($G(^BARCOL(DUZ(2),BARCLDA,0)),U,29)) D
 ..W !,"PLEASE REVIEW YOUR ENTRIES AND EITHER CORRECT THE AMOUNT OF THE TDN/IPAC, REMOVE ITEMS, OR CORRECT THE BATCH ITEM AMOUNTS."
 .W ! K DIR S DIR(0)="E",DIR("A")="Enter RETURN to Continue" D ^DIR K DIR
 ;end new code IHS/SD/SDR bar*1.8*4 DD item 4.1.5.1
 Q
 ; *********************************************************************
 ;
BARCLID ;EP
 ; build BARCLID array:uses current da in array or BARDA if no array
 D BARCLID^BARCLU1
 Q
 ; *********************************************************************
 ;
BARCL ;EP
 ; build BARCL array:uses current da in array of DA if no array
 D BARCL^BARCLU1
 Q
 ; *********************************************************************
 ;
BARCLIT ;EP
 ; build the BARCLIT array
 D BARCLIT^BARCLU1
 Q
 ; *********************************************************************
 ;
DISPLAY ;EP
 ; display item elements
 D DISPLAY^BARCLU1
 Q
 ;start new code IHS/SD/SDR bar*1.8*4 DD item 4.1.5.1
ITEMTOT(BARCLDA) ;EP - get total of items
 S BARITDA=0,BARITTOT=0
 F  S BARITDA=$O(^BARCOL(DUZ(2),BARCLDA,1,BARITDA)) Q:+BARITDA=0  D
 .Q:$P($G(^BARCOL(DUZ(2),BARCLDA,1,BARITDA,0)),U,17)="C"!($P($G(^BARCOL(DUZ(2),BARCLDA,1,BARITDA,0)),U,17)="R")  ;no cancelled or rolled up items
 .S BARITTOT=+$G(BARITTOT)+$P($G(^BARCOL(DUZ(2),BARCLDA,1,BARITDA,1)),U)
 Q BARITTOT
 ;end new code IHS/SD/SDR bar*1.8*4 DD item 4.1.5.1
CHECKDUP(NEWTDN,LIST) ;EP - CHECK FOR DUPLICATE TDN IN A/R COLLECTION BATCH
 W !!,"Checking for duplicate TDN/IPAC..."
 Q:NEWTDN=""
 N CHECNUM,CHECK,COLBAT,ITEM,AMOUNT,COLNAM,COLSTATUS
 K LIST
 S CNT=0
 S COLBAT=""
 F  S COLBAT=$O(^BARCOL(DUZ(2),"E",NEWTDN,COLBAT)) Q:COLBAT=""  D
 .Q:BARCLDA=COLBAT
 .S CNT=CNT+1
 .S COLNAM=$$GET1^DIQ(90051.01,COLBAT_",",.01,"E")
 .S AMOUNT=$$GET1^DIQ(90051.01,BARCLDA,15)
 .S COLSTATUS=$$GET1^DIQ(90051.01,BARCLDA,3)
 .S LIST(CNT)=COLNAM_U_COLSTATUS_U_NEWTDN_U_AMOUNT
 Q:'$D(LIST)
 D DUPHDR(CNT)
 D SHOLIST(.LIST)
 Q
 ;
DUPHDR(CNT) ;EP - TDNDUP HEADER
 W !!,"**Duplicate TDN/IPAC detected in the following batches**"
 Q
 ;
SHOLIST(LIST) ;EP - SHOW LIST OF DUPES
 N CNT
 S CNT=""
 W !
 F  S CNT=$O(LIST(CNT)) Q:'CNT  D
 .W !,CNT,"."
 .W ?3,$P(LIST(CNT),U)    ;NAME
 .W ?32,"TTL: $ ",$J($FN($P(LIST(CNT),U,4),",",2),10) ;TOTAL
 .W ?35,"  ST: ",$P(LIST(CNT),U,2)
 .W ?63," T/I: ",$P(LIST(CNT),U,3)
 W !!
 ;K DIR
 ;S DIR(0)="E"
 ;D ^DIR
 Q
 ;
BFLAG(BARDA) ; (tag called by Fileman trigger for field: BATCH FLAG)
 ; Update BATCH FLAG field (triggered when BATCH field is updated)
 ;--->New Tag BFLAG  ;M819*ADD*TMM*20100710 (819_4)
 S BARTMP=+$$GET1^DIQ(90050.06,BARDA_",",.14,"I")
 S BARTMPX=$S(BARTMP=0:"N",1:"A")
 Q BARTMPX
