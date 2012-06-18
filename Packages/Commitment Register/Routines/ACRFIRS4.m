ACRFIRS4 ;IHS/OIRM/DSD/AEF - CALCULATE YTD PAYMENTS TO VENDORS [ 11/01/2001   9:44 AM ]
 ;;2.1;ADMIN RESOURCE MGMT SYSTEM;;NOV 05, 2001
 ;
 ;This routine loops through the payments in the 1166 Approvals for
 ;Payment file for the export date range specified and totals up all the
 ;payment amounts and places the total amount in the YTD PAID field
 ;of the Vendor file.
 ;
EN ;----- MAIN ENTRY POINT
 ;
 N Z
 D ^XBKVAR
 D HOME^%ZIS
 D DATES
 Q:'+Z
 D ZERO
 D LOOP(Z)
 Q
LOOP(Z) ;----- LOOP THROUGH PAYMENTS AND SET TOTALS
 ;
 ;      Z = BEGINNING DATE^ENDING DATE
 ;
 N AMOUNT,DATA,DATE,DIR,END,FY,SEQ,VENDOR
 S DATE=$P(Z,U)-1
 S END=$P(Z,U,2)
 F  S DATE=$O(^AFSLAFP("EXP",DATE)) Q:'DATE  Q:DATE>END  D
 . S FY=0
 . F  S FY=$O(^AFSLAFP("EXP",DATE,FY)) Q:'FY  D
 . . S BCH=0
 . . F  S BCH=$O(^AFSLAFP("EXP",DATE,FY,BCH)) Q:'BCH  D
 . . . S SEQ=0
 . . . F  S SEQ=$O(^AFSLAFP(FY,1,BCH,1,SEQ)) Q:'SEQ  D
 . . . . S DATA=$G(^AFSLAFP(FY,1,BCH,1,SEQ,0))
 . . . . S VENDOR=$P(DATA,U,10)
 . . . . Q:'VENDOR
 . . . . S AMOUNT=$P(DATA,U,11)
 . . . . D SET(VENDOR,AMOUNT)
 W !,"DONE"
 S DIR(0)="E"
 D ^DIR
 Q
SET(VENDOR,AMOUNT) ;
 ;----- SET DATA INTO 1166 AFP 1099-VENDORS FILE
 ;
 N YTD,DA,DIE,DR
 S YTD=$P(^AUTTVNDR(VENDOR,11),U,7)
 S YTD=YTD+AMOUNT
 S DA=VENDOR
 S DIE="^AUTTVNDR("
 S DR="1107///^S X=YTD"
 D ^DIE
 Q
DATES ;----- ASK FOR BEGINNING AND ENDING DATES
 ;
 ;      Returns Z = BEGIN^END
 ;
 N DIR,X,Y
 W !
 S Z=""
 S DIR(0)="DO^::E"
 S DIR("A")="Enter BEGINNING DATE"
 D ^DIR
 Q:Y'>0
 S Z=Y
 S DIR("A")="Enter ENDING DATE"
 D ^DIR
 Q:Y'>0
 I Y<Z W !,*7,"ENDING DATE cannot be less than BEGINNING DATE!" G DATES
 S $P(Z,U,2)=Y
 Q
ENZ ;EP -- ENTRY POINT TO SET VENDOR YTD FIELDS TO NULL
 ;
 S DIR(0)="Y"
 S DIR("A")="Do you want to ZERO out the Year-To-Date field for all Vendors"
 S DIR("B")="NO"
 D ^DIR
 I Y D ZERO W !,"  DONE!"
 Q
ZERO ;----- SET YTD FIELDS TO NULL
 ;
 N DA,DIE,DR,VENDOR,X,Y
 S VENDOR=0
 F  S VENDOR=$O(^AUTTVNDR(VENDOR)) Q:'VENDOR  D
 . S DA=VENDOR
 . S DIE="^AUTTVNDR("
 . S DR="1107///^S X=""@"""
 . D ^DIE
 Q
