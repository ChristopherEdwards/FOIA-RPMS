BARFM ; IHS/SD/LSL - USER FM ACCESS TO RESTRICTED FILES MAY 30,1996 ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;;
 ; IHS/SD/LSL - 06/23/03 - V1.7 Patch 2
 ;       Modified screen to work better with FM 22
 ;
 ; IHS/SD/LSL - 09/22/03 - V1.7 Patch 4 - IM11534
 ;      Resolve <CMMND>*XECUTE*S^DIC1
 Q
 ; *********************************************************************
 ;
EN ; EP
 ; FM search or sort files
SELPKG ;
 ; select package / select file withing package  return file number in BARFN
 S BARFN=0
 I '$D(DUZ(2)) D  Q
 . W !,"DUZ(2) NOT DEFINED",!
 . D EOP^BARUTL(0)
 D SPKG
 K DIC,DA,DR,DIE
 S DIC=9.4
 S DIC(0)="AEQM"
 S DIC("S")="I $S($$GET1^DIQ(9.4,+Y,1)']"""":0,1:$D(BARS($$GET1^DIQ(9.4,+Y,1))))"
 D ^DIC
 Q:Y'>0
 S BARPKDA=+Y
 S BARNS=$$VAL^XBDIQ1(9.4,+Y,1)
 ; -------------------------------
 ;
SELFILE ;
 ; select file
 K DIC,DA,DR,DIE
 S DIC=$$DIC^XBDIQ1(9.44),DIC(0)="AQEMZ"
 S DA(1)=BARPKDA
 I $L($T(@BARNS)) D
 .K BARS
 .F I=1:1 S X=$P($T(@BARNS+I),";;",2) Q:X="end"  S BARS(X)=""
 .S DIC("S")="N Z S Z=$P(^(0),U) I $D(BARS(Z))"
 D ^DIC
 Q:Y'>0
 S DA=+Y
 S BARFN=$$VALI^XBDIQ1(DIC,.DA,.01)
 Q
 ; *********************************************************************
 ;
SPKG ;
 K BARS
 F I=1:1 S X=$P($T(PKG+I),";;",2) Q:X="end"  S BARS(X)=""
 Q
 ; *********************************************************************
 ;
DIP ; EP
 ; do a sort/print of a file
 D EN^BARFM
 Q:'$G(BARFN)
 S DIC=BARFN
 I BARFN=90050.03 D
 . W !,"You have selected the A/R Transaction file",!
 . K DIR
 . W !,"Would you like an auto screen for:"
 . W !,"    'payments,refunds, & adjustments' set ? ",!
 . S DIR(0)="YO"
 . S DIR("B")="Y"
 . D ^DIR
 . K DIR
 . I 'Y  W !,"Screen not set",! Q
 . S DIS(0)="N X S X=$P($G(^BARTR(DUZ(2),D0,1)),U) I ((X=40)!(X=39)!(X=43))"
 . W !,"Screen is set",!
 D EN1^DIP
 Q
 ; *********************************************************************
 ;
DIS ; EP
 ; do a SEARCH/PRINT of a file
 D EN^BARFM
 Q:'$G(BARFN)
 S DIC=BARFN
 D EN^DIS
 Q
 ; *********************************************************************
 ;
XBFLD ; EP
 ; do a quick dd file print
 D ^XBFLD
 Q
 ; *********************************************************************
 ;
 ;-----------   ARRAY BUILDING
PKG ;;list of name spaces
 ;;BAR
 ;;ABM
 ;;AG
 ;;end
BAR ;; list of BAR FILES
 ;;90051.01;; collection batch
 ;;90050.02;; account
 ;;90050.01;; bill
 ;;90050.03;; transaction
 ;;end
