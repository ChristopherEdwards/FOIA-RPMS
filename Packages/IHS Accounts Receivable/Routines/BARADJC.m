BARADJC ; IHS/SD/LSL - CREATE 2 NEW ENTRIES IN A/R TABLE TYPE FILE ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;
 ; IHS/SD/LSL - 09/19/2002 - V1.6 Patch 3
 ;     For HIPAA compliance.  Create 2 new Adjustment Categories
 ;     PENDING and GENERAL INFORMATION
 ;
 ; *********************************************************************
 ;
ENTRY ;
 ; Create entry
 S BARD=";;"
 F BARIEN=21,22 D EN2
 D ^BARVKL0
 Q
 ; *********************************************************************
 ;
EN2 ;
 S BARVALUE=$P($T(@BARIEN),BARD,2,3)
 K DIC,DA,X,Y
 S DIC="^BAR(90052.01,"
 S DIC(0)="LZE"
 S DINUM=BARIEN
 S X=$P(BARVALUE,BARD)
 S DIC("DR")="2///^S X=$P(BARVALUE,BARD,2)"
 K DD,DO
 D FILE^DICN
 Q
 ; *********************************************************************
 ; NAME;;ACRONYM
 ; *********************************************************************
21 ;;PENDING;;PEND
22 ;;GENERAL INFORMATION;;GENINF
