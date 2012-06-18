BARUTL0 ; IHS/SD/LSL - Utility programs for user/fac ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;;
 ; IHS/SD/LSL - 09/24/02 - V1.7 - NOIS HQW-0902-100094
 ;     Set BARUSR(29 [service section] to be BUSINESS OFFICE
 ;     if it is something othe than BUSINESS OFFICE or
 ;     FISCAL SERVICE"
 ;
 ; ********************************************************************
 ;
BARUSR ;EP setup BARUSR( user array from DUZ:200
 N XB,DIQ,DIC,DA
 K BARUSR
 S DIQ="BARUSR("
 S DIQ(0)="I"
 S DIC=200
 S DR=".01;29"
 S DA=DUZ
 D EN^XBDIQ1
 Q:BARUSR(29)="BUSINESS OFFICE"
 Q:BARUSR(29)="FISCAL SERVICE"
 S DIC="^DIC(49,"          ; Service/Section file
 S DIC(0)="ZEX"
 S X="BUSINESS OFFICE"
 K DD,DO
 D ^DIC
 Q:Y'>0
 S BARUSR(29)=$P(Y,U,2)
 S BARUSR(29,"I")=+Y
 Q
 ; *********************************************************************
 ;
BARSPAR ;EP setup BARSPAR( A/R Site Parameter array
 N XB,DIC,DIQ,DA,DR
 K BARSPAR
 S DIC=90052.06
 S DR=".01:99"
 S DA=DUZ(2)
 S DIQ="BARSPAR("
 S DIQ(0)="I"
 D EN^XBDIQ1
 Q
 ; *********************************************************************
 ;
BARSITE ;EP setup BARSITE( site array
 N XB,DIC,DA,DR
 S DIC="^AUTTSITE("
 S DIQ="BARSITE("
 S DIQ(0)="I"
 S DA=1
 S DR=".01"
 D EN^XBDIQ1
 Q
 ; *********************************************************************
 ;
BARPSAT ;EP built BARPS arrary with Parent Satellite
 N DA,DIC,DR,BARGL,Y
 K BARPSAT
 S DIC=90052.05
 S DIQ="BARPSAT("
 S DIQ(0)="I"
 S DR=".01;2"
 S DIQ(0)="1E"
 S DA=0
 D ENM^XBDIQ1
 Q
 ; *********************************************************************
 ;
ADDREGON ;EP add a regional site (needs DUZ(2))
 K DIQ
 S DIC=4
 S DIQ="BARTMP("
 S DR=".01"
 S DA=DUZ(2)
 D EN^XBDIQ1
 I $D(^BARBL(DUZ(2))) D
 . W !,?5,BARTMP(.01),"  EXISTS"
 . D EOP^BARUTL(0)
 K DIR
 S DIR(0)="Y"
 S DIR("B")="NO"
 S DIR("A")=BARTMP(.01)_" to be added/updated as an A/R Regional Site?"
 D ^DIR
 I 'Y D  Q
 . W !,"You can change your Default A/R Facility and return here if necessary!",!
 . K DIR,BARTMP
 . D EOP^BARUTL(1)
 ; -------------------------------
 ;
 ; set files 0 nodes
 F BARI=1:1 S BARFLNUM=$P($T(FNUM+BARI),";;",2) Q:'BARFLNUM  D
 . S BARGL=^DIC(BARFLNUM,0,"GL")_"0)"
 . I '$D(@BARGL) D
 . . S $P(@BARGL,"^",1,2)=$P(^DIC(BARFLNUM,0),"^",1,2)
 . . W !,"ADDED: ",?10,$P(@BARGL,U)
 W !!,BARTMP(.01)," Has been added",!
 ;--------------------------------
 ;
ARSPAC ;set up two special A/R accounts
 K DIC
 S DIC=$$DIC^XBDIQ1(90052.07)
 S DIC(0)="L"
 I '$D(@(DIC_"""B"",""UN-ALLOCATED"")")) D
 . S X="UN-ALLOCATED"
 . K DD,DO
 . D ^DIC
 . I Y'>0 D
 . . S BARQUIT=1
 . . W !,"ERROR IN SETUP OF UN-ALLOCATED"
 ;--------------------------------
 ;
HOSPSRVC ;
 S DIC=49 ;hospital service
 S DIC(0)="L"
 S DLAYGO=49
 I '$D(^DIC(49,"B","BUSINESS OFFICE")) D
 . S X="BUSINESS OFFICE"
 . K DD,DO
 . D ^DIC
 . I Y'>0 D
 . . S BARQUIT=1
 . . W !,"ERROR IN SETUP OF BUSINESS OFFICE",!
 I '$D(^DIC(49,"B","FISCAL SERVICE")) D
 . S X="FISCAL SERVICE"
 . K DD,DO
 . D ^DIC
 . I Y'>0 D
 . . S BARQUIT=1
 . . W !,"ERROR IN SETUP OF FISCAL SERVICE",!
 I $G(BARQUIT) D EOP^BARUTL(0)
 ;
EADD ;
 Q
FNUM ;;$T filenumber to be regionally added/deleted
 ;;90051.01
 ;;90051.02
 ;;90050.02
 ;;90050.01
 ;;90052.05
 ;;90052.06
 ;;90052.07
 ;;90050.03
 ;;end of list
EFNUM ;----------
 ;
SRVSEC ;EP switch Service Section
 K DIC,DR,DIE,DA
 S DIC="^BARTBL("
 S DIC(0)="AEQM"
 S DIC("S")="I $P(^(0),U,3)=""SRVSEC"""
 K DD,DO
 D ^DIC
 Q:Y'>0
 S Y=+Y
 S DIE="^VA(200,"
 S DA=DUZ
 S DR="29///"_$$VAL^XBDIQ1("^BARTBL(",+Y,.01)
 S DIDEL=90050
 D ^DIE
 K DIDEL
 Q
