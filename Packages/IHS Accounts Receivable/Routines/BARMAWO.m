BARMAWO ; IHS/SD/LSL - Automatic Write Off ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**1,2**;MAR 27,2007
 ;
 ; IHS/ASDS/LSL - 12/11/00 - Routine created
 ;     This routine is intended to be used to clean up accounts
 ;     receivable on dates of service prior to 06/30/00.  It is intended
 ;     to be a one time option.  It may not be used after 07/01/01.
 ;
 ;     All bills for up to and including the DOS specified for the
 ;     A/R Accounts specified will be written off to a special code if
 ;     The amount billed is not greater than 20,000, the date of service
 ;     is before 06/30/2000, and there is not a credit balance.
 ;
 ; IHS/ASDS/LSL - 01/22/01 
 ;     Modified to mark bill complete in 3PB and populate payment mult.
 ;
 ; IHS/ASDS/LSL - 01/23/01
 ;     Modified to allow write off by visit location
 ;
 ; IHS/ASDS/LSL - 06/15/01 - V1.5 Patch 1 - NOIS HQW-0601-100051
 ;     Extend expiration date to 12/31/2001.
 ;
 ; IHS/ASDS/LSL - 09/07/01 - V1.5 Patch 2
 ;     Modified to include finance specifications
 ;     DOS must be at least 3 years old
 ;     Don't allow write-off of non-bens
 ;     Option expires by parameter or default to 10/15/01
 ;     One time only?????
 ;
 ; *********************************************************************
 ;
 Q
 ;
EN ;EP
 ;
 S BARHOLD=DUZ(2)
 S (BARCONT,BARCNT)=0
 S BARSECT=$$GET1^DIQ(200,DUZ,29,"I")      ; Serv/Sect from NEW PERSON
 ;BAR*1.8*1 SPLIT MESSAGE SO ONE IS APPROPRIATE FOR UFMS AND THE OTHER FOR INTERIM
 S BAREXP=$P($G(^BAR(90052.06,DUZ(2),DUZ(2),0)),U,15)
 ;I BAREXP=3070430 D
 I BAREXP=3070525 D  ;BAR*1.8*2
 .W !!,"This menu is meant to be used as a tool for meeting the UFMS"
 .W !,"clean-up deadline.  The user is asked for a list of visit locations (or all),"
 .W !,"and list of A/R Accounts (or all).  The account balance of each bill found"
 .W !,"with a DOS up to and including 9/30/2005 will be written off to"
 .W !,"code 916 Auto Write-off 2007 if the following conditions are met:"
 E  D
 .W !!,"This menu is meant to be used as a tool for meeting the A/R Interim Policy"
 .W !,"clean-up deadline.  The user is asked for a list of visit locations (or all),"
 .W !,"date of service (DOS) and list of A/R Accounts (or all).  The account balance"
 .W !,"of each bill found with a DOS up to and including the DOS entered will be"
 .W !,"written off to code 502 Auto Write-off 2001 if the following conditions are met:"
 ;BAR*1.8*1
 ;I BAREXP=3070430 W !!?5,"1.  The DOS on the bill is prior to 10/1/2005"
 I BAREXP=3070525 W !!?5,"1.  The DOS on the bill is prior to 10/1/2005"  ;BAR*1.8*2
 E  W !!?5,"1.  The DOS on the bill is at least three (3) years old."
 ;W !!?5,"1.  The DOS on the bill is at least three (3) years old."
 W !?5,"2.  The amount billed is less than 20,000.00"
 W !?5,"3.  The A/R Account tied to the bill is in the list specified"
 W !?5,"    and not NON-BENEFICIARY."
 W !?5,"4.  There is a positive balance left on the bill"
 W !?5,"5.  The Visit Location tied to the bill is in the list specified"
 S BAREXP=$P($G(^BAR(90052.06,DUZ(2),DUZ(2),0)),U,15)
 S:BAREXP="" BAREXP=3011015
 S Y=BAREXP
 D DD^%DT
 S BAREXPDT=Y
 W !!,"This menu option expires on ",BAREXPDT,"."
 ;
 I DT>BAREXP D  Q
 . W !!!?20,"*** This option expired on ",BAREXPDT," *****"
 . D PAZ
 . D XIT
 W !!
 D ASKLOC                                 ; Ask visit location list
 I '+BARLOC D XIT Q
 D ASKDOS                                 ; Ask Date of Service
 Q:'$D(BARDOS)                            ; Quit if invalid date entered
 D ASKACCT                                ; Ask A/R Account List
 I '+BARACCT D XIT Q
 D CONTINUE                               ; Display choices ask continue
 I '+BARCONT D XIT Q                      ; Don't continue
 D LOOPDUZ^BARMAWO1
 ;BAR*1.8*1
 ;I BAREXP=3070430 D
 I BAREXP=3070525 D  ;BAR*1.8*2
 .W !!!,BARCNT," Bills written off to Auto Write-off 2007."
 E  W !!!,BARCNT," Bills written off to Auto Write-off 2001."
 D XIT
 Q
 ; *********************************************************************
 ;
ASKLOC ;
 ; Ask list of visit locations
 K DIC,X,Y
 S BARLOC=1
 S DIC="^BAR(90052.05,DUZ(2),"
 S DIC(0)="ZAEMQ"
 S DIC("A")="Select LOCATION: ALL// "
 F  D  Q:+Y<0
 . I $D(BAR("LOC")) S DIC("A")="Select Another LOCATION: "
 . D ^DIC
 . Q:+Y<0
 . S BAR("LOC",+Y)=$P(Y,U,2)
 I '$D(BAR("LOC")) D
 . I $D(DUOUT) S BARLOC=0 Q
 . W "ALL"
 K DIC
 W !
 Q
 ; *********************************************************************
 ;
ASKDOS ;
 ; Ask date of Service
 ;BAR*1.8*1
 ;THIS IS A ONE TIME THING FOR THE UFMS WRITE OFF
 ;if option expire date is april 30,2007 we know its for UFMS
 ;I BAREXP=3070430 D  Q
 I BAREXP=3070525 D  Q  ;BAR*1.8*2
 .S BARDOS=3050930
 .S BARDOS("E")="9/30/2005"
 ;END UFMS
 S BARDOS2=DT-30000                    ; 3 years ago
 S Y=BARDOS2
 D DD^%DT
 S BARDOSE=Y
 K DIR
 S DIR("A")="Enter Date of Service"
 S DIR("?")="Enter a date less than or equal to "_BARDOSE_"."
 S DIR("?",1)="Dates up to and including the one entered will be written off."
 S DIR(0)="DE^:"_BARDOS2
 D ^DIR
 Q:'+Y
 S BARDOS=Y
 S BARDOS("E")=Y(0)
 Q
 ; *********************************************************************
 ;
ASKACCT ;  
 ; Ask for list of A/R Accounts
 K DIC,X,Y
 W !
 S BARACCT=1
 S DIC="^BARAC(DUZ(2),"
 S DIC(0)="AEMQ"
 S DIC("A")="Select A/R Account: ALL// "
 F  D  Q:+Y<0
 . I $D(BAR("ACCT")) S DIC("A")="Select Another A/R Account: "
 . D ^DIC
 . Q:+Y<0
 . S BAR("ACCTTYPE")=$$GET1^DIQ(90050.02,+Y,1.08)
 . I BAR("ACCTTYPE")["NON-BENEFICIARY" D  Q
 . . W !,"Cannot use this option on Non-Beneficiaries",!
 . S BAR("ACCT",+Y)=$P(Y,U,2)
 I '$D(BAR("ACCT")) D
 . I $D(DUOUT) S BARACCT=0 Q
 . W "ALL"
 K DIC
 W !!!
 Q
 ; *********************************************************************
 ;
CONTINUE ;
 ; Display choices to user and ask if they wish to continue. 
 ; Tell them bills written off will scroll on the screen if they wish to
 ; capture.
 W "You have chosen to write off bills meeting the above criteria"
 W !,"for dates of service up to and including ",BARDOS("E")
 W !!,"for the following Locations: "
 I '$D(BAR("LOC")) W ?40,"ALL"
 I $D(BAR("LOC")) D
 . S BARTMP=0
 . F  S BARTMP=$O(BAR("LOC",BARTMP)) Q:'+BARTMP  D
 . . W ?40,$P(^DIC(4,BARTMP,0),U),!
 W !,"for the following A/R accounts: "
 I '$D(BAR("ACCT")) W ?40,"ALL"
 I $D(BAR("ACCT")) D
 . S BARTMP=0
 . F  S BARTMP=$O(BAR("ACCT",BARTMP)) Q:'+BARTMP  D
 . . W ?40,$$VAL^XBDIQ1(90050.02,BARTMP,.01),!
 W !!,"The bill number and amount written off will scroll by on the screen"
 W !,"if you wish to capture this information.",!
 ;
 K DIR
 S DIR(0)="Y"
 S DIR("A")="Continue"
 S DIR("B")="No"
 D ^DIR
 K DIR
 S:Y=1 BARCONT=1
 Q
 ; *********************************************************************
 ;
PAZ ;EP to pause report
 I '$D(IO("Q")),$E(IOST)="C",'$D(IO("S")) D
 .F  W ! Q:$Y+3>IOSL
 .K DIR S DIR(0)="E" D ^DIR K DIR
 Q
 ; *********************************************************************
 ;
XIT ;
 ; Clean up
 S DUZ(2)=BARHOLD
 D ^BARVKL0                             ; Kill local variables
 Q
