BARCLU1 ; IHS/SD/LSL - UTILITY CALLS FROM BARCLU ; 07/09/2010
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**3,4,19**;OCT 26, 2005
 ;;
 ; IHS/SD/TMM 06/18/2010 1.8*19 Add Prepayment functionality.
 ;      See work order 3PMS10001
 ;      ------------------------
 ;      819_1. Display prepayments not assigned to a batch (^BARCLU)
 ;      819_2. Remove prompt: AUTO PRINT RECEIPT (^BARCLU01)
 ;      819_3. Prepayment entry ^BARPPY01 (new routine),^BARCLU1,^BARPUTL
 ;      819_4. Display prepayments matching payment type selected (^BARCLU)
 ;      819_5. Allow user to assign prepayment to batch (^BARCLU,^BARCLU01,^BARPUTL,^BARPST1,^BARBLLK)
 ;      819_6. Print Prepayment Receipt (^BARPPY02) (new routine)
 ; *********************************************************************
 ; 
NEW ; EP
 ; open a new batch
 K DA
 ;----  update Date / Sequence in BARCLID
 I DT=BARCLID(4,"I") S BARCLID(5)=BARCLID(5)+1
 E  S BARCLID(4,"I")=DT,BARCLID(5)=1
 K DIE,DR,DA
 S DIE=$$DIC^XBDIQ1(90051.02)
 S DA=+BARCLID("ID")
 S DR="4////"_BARCLID(4,"I")_";5///"_BARCLID(5)
 S DIDEL=90050
 D ^DIE
 K DIDEL
 D BARCLID
 ;
 ;---- setup new collection batch
 S X=BARCLID(.01)_"-"_BARCLID(4.5)_"-"_BARCLID(5)
 S BARCLID(6)=X ;set new current into BARCLID
 K DIC,DR,DA
 S DIC="^BARCOL(DUZ(2),"
 S DIC(0)="XEQML"
 S DIC("DR")="2////^S X=+BARCLID(""ID"")"
 S DIC("DR")=DIC("DR")_";3////O"
 S DIC("DR")=DIC("DR")_";4///NOW"
 S DIC("DR")=DIC("DR")_";5////^S X=DUZ"
 S DIC("DR")=DIC("DR")_";7///0"
 S DIC("DR")=DIC("DR")_";8////^S X=DUZ(2)"
 S DIC("DR")=DIC("DR")_";10////^S X=BARCLID(10,""I"")"
 S DLAYGO=90050
 K DD,DO
 D FILE^DICN
 K DLAYGO ;setup new batch
 I Y'>0 W !,"error in setting up new collection batch" H 5 Q
 S BARCLDA=+Y
 S BARDA=+Y D
 . D BARCL
 . K BARDA
 K DR,DA,DIE
 S DIE=$$DIC^XBDIQ1(90051.02)
 S DA=+BARCLID("ID")
 S DR="6///"_BARCLID(6)
 S DIDEL=90050
 D ^DIE
 K DIDEL
 D BARCLID
 ;
ENEW ;
 Q
 ; *********************************************************************
 ;
BARCLID ; EP
 ; build BARCLID array:uses current da in array or BARDA if no array
 N XB,DIC,DR,DA,DIQ
 I $D(BARCLID) S DA=+BARCLID("ID")
 I $D(BARDA) S DA=BARDA K BARDA
 I '$G(DA) W !!,"NO DA FOR BARCLID",*7,!! H 5 Q
 K BARCLID
 S DR=".001:99"
 S DIQ="BARCLID("
 S DIQ(0)="I"
 S DIC=90051.02
 D EN^XBDIQ1
 Q
 ; *********************************************************************
 ;
BARCL ; EP
 ; build BARCL array:uses current da in array of DA if no array
 N XB,DIC,DR,DA,DIQ
 S:$D(BARCL) DA=+BARCL("ID")
 I $D(BARDA) S DA=BARDA K BARDA
 I '$G(DA) W !!,"NO DA FOR BARCL",*7,!! H 5 Q
 K BARCL
 S DR=".001:99"
 S DIQ="BARCL("
 S DIQ(0)="I"
 S DIC=90051.01
 D EN^XBDIQ1
 Q
 ; *********************************************************************
 ;
BARCLIT ; EP
 ; build the BARCLIT array
 ;needs +BARCL("ID") for DA and BARITDA for item
 N DIC,DA,DR,DIQ,XB
 K BARCLIT
 K DIQ
 S DA=BARITDA
 S DIQ="BARCLIT("
 S DIQ(0)="I"
 S DIC=90051.1101
 S DA(1)=BARCLDA
 S DR="^.01:203;301;401:405;501"
 ;S DR="^.01:203;301;401:405;501;20"  ;BAR*1.8*3 UFMS MAKE TREASURY NUMBER REQUIRED  ;IHS/SD/SDR bar*1.8*4 DD item 4.1.5.1
 ;S DR=".01:203;301;401:405;501;20"  ;BAR*1.8*4 SCHEDULE NUMBERING NOT DISPLAYING ON USE OF 'Edit w Audit' option IHS/SD/SDR bar*1.8*4 DD item 4.1.5.1
 S DR=".01:203;301;401:405;501;20////"_$P($G(^BARCOL(DUZ(2),BARCLDA,0)),U,28)_";W !,TDN/IPAC: "_$P($G(^BARCOL(DUZ(2),BARCLDA,0)),U,28)  ;IHS/SD/SDR bar*1.8*4 DD item 4.1.5.1
 D EN^XBDIQ1
 ;BAR*1.8*4 ASK TREASURY NUMBER
 I BARCLIT("20")="" D
 .S BARCLIT("20")=$P($G(^BARCOL(DUZ(2),BARCLDA,1,BARITDA,0)),U,20)
 .S BARCLIT("20","I")=$P($G(^BARCOL(DUZ(2),BARCLDA,1,BARITDA,0)),U,20)
 ;END
 Q
 ; *********************************************************************
 ;
DISPLAY ; EP
 ; display item elements
 W $$EN^BARVDF("IOF")
 W !,BARCL(.01)
 W ?22,"ITEM: ",BARITDA,"    TYPE: ",BARCLIT(2)
 W ?48,"BATCH TOTAL: ",$$GET1^DIQ(90051.01,BARCLDA,15)
 ;start new code IHS/SD/SDR bar*1.8*4 DD item 4.1.5.1
 I +BARCLID(22,"I") D
 .W !,"TDN/IPAC: ",$P($G(^BARCOL(DUZ(2),BARCLDA,0)),U,28)
 .W ?35,"TDN/IPAC AMOUNT: ",$FN($P($G(^BARCOL(DUZ(2),BARCLDA,0)),U,29),",",2)
 ;end new code IHS/SD/SDR bar*1.8*4 DD item 4.1.5.1
 W !
 F BARI=1:1:IOM-4 W "="
 F BARLAB="FLD1","FLD2" D
 . S BARY=$P($T(@BARLAB),";;",2)
 . F BARI=1:1 S BARE=$P(BARY,U,BARI) Q:BARE=""  D
 . . S BARFLD=+BARE
 . . S BARNM=$P(BARE,";",2)
 . . I $G(BARCLIT(BARFLD))]"" W !,?5,BARNM,?30,BARCLIT(BARFLD)
 I $D(BARCLIT(301)) D
 . W !,"COMMENTS"
 . F BARI=1:1 Q:'$D(BARCLIT(301,BARI))  W !?3,BARCLIT(301,BARI)
 I $D(BARCLIT(501)) D
 . W !,"ERROR COMMENTS"
 . F BARI=1:1 Q:'$D(BARCLIT(501,BARI))  W !,?3,BARCLIT(501,BARI)
 ;
EDSP ;
 W !
 F BARI=1:1:IOM-4 W "="
 D DSPSUB
 Q
 ; *********************************************************************
 ;
DSPSUB ; EP
 ; Display subs
 W !
 N DR,BARY,BARI,BARNM,BARFLD,BARESUB
 S DIQ="BARESUB("
 S DIQ(0)=1
 S DIC=90051.1101601
 S DA(1)=BARITDA
 S DR=".01;.5;2"
 S DA(2)=BARCLDA
 S DA=0
 D ENM^XBDIQ1
 S BARS=0
 F BARI=1:1 S BARS=$O(BARESUB(BARS)) Q:BARS'>0  D
 . W BARESUB(BARS,.5)
 . W ?5,BARESUB(BARS,.01)
 . W ?30,"$",$J(BARESUB(BARS,2),8,2),!
 W !
 ;
EDSPSUB ;
 Q
 ; *********************************************************************
 ;
 ; $T LINES ;IHS/SD/AML 11/26/07 - Print treasury dep number
FLD1 ;;203;GENERAL LEDGER^11;CHECK NUMBER^12;CHECK BANK NUMBER^13;CC NUMBER^14;CC VER NUMBER^101;AMOUNT PAID^102;REFUND^
FLD2 ;;7;A/R ACCOUNT^201;PAYOR^8;LOCATION OF SERVICE^10;INPAT/OUTPAT^5;PATIENT^6;BILL^16;AUTO PRINT^20;TREASURY DEPOSIT/IPAC # 
 ;----------------------------
EDISPLAY ;
 Q
 ;
 ;---BEGIN ADD(1)---> NEW TAG 'BARPPAY'   ;M819*ADD*TMM*20100709 (M819_3)
BARPPAY(BARPPIEN) ; EP
 ; build BARPPAY array:uses current da in existing array or BARPPIEN if no array
 N XB,DIC,DR,DA,DIQ
 ;I $D(BARPPAY) S DA=+BARPPAY("ID")        ;M819*DEL*TMM*20100709
 ;I $D(BARPPIEN) S DA=BARPPIEN K BARPPIEN  ;M819*DEL*TMM*20100709
 I $D(BARPPIEN) S DA=BARPPIEN              ;M819*ADD*TMM*20100709
 I '$G(DA) W !!,"NO DA FOR BARPPAY",*7,!! H 5 Q
 K BARPPAY
 S DR=".01:201"
 S DIQ="BARPPAY("
 S DIQ(0)="I"
 S DIC=90050.06
 D EN^XBDIQ1
 Q
 ;-----END ADD(1)---> NEW TAG 'BARPPAY'   ;M819*ADD*TMM*20100709 
