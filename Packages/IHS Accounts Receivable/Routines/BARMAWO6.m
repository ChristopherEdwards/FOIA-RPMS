BARMAWO6 ; IHS/SD/LSL - Automatic Write Off ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**1,2,21**;OCT 26, 2005
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
 ; IHS/SD/PKD - 03/28/11 - 1.8*21 
 ;    Manilaq, Alaska write-offs through 1/1/09 has been approved
 ;    Heat 19931.  Modify to allow Date Range to be entered regardless
 ; 	  of Parameter file
 ; 	  From: Glen Fowler [mailto:glen.fowler@maniilaq.org] 
 ;Sent: Thursday, December 16, 2010 1:41 PM
 ; ;Subject: RE: A/R request [19931]
 ; Currently, we are working aged Medicare claims, as the 12/31/10 deadline to submit claims 
 ; (10-1-08 to 12/31/09) will deny on timely filing limits.  
 ; Subsequently, we will be ready to run the AWO the first of the year
 ; Need new WriteOff code ...
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
 ;S BAREXP=3100000  ;  through 12/31/09 ??
 ;S BARFROM=3080930  ; from 10/1/08  (OR from the beginning???)
 ;
 W !!,"This menu is meant to be used as a Write-off tool. "
 W !,"The user is asked for: "
 W !,"  a locally added Adjustment Type code for Auto Write-off, "
 W !,"       IEN or Full Name of Write-off Code"
 W !,"  Inclusion of Non-Beneficiaries or not, "
 W !,"  a list of visit locations (or all),"
 W !,"  an inclusive Date Range of Bills to be written off,"
 W !,"  a list of A/R Accounts (or all). "
 ;
 W !," The account balance of each bill found"
 W !,"with a DOS up to and including the end date keyed, will be written off to"
 W !,"the Adjustment Code entered, if the following conditions are met:"
 ;
 W !!?5,"1.  The DOS on the bill is within date range entered"  ;BAR*1.8*21
 ;W !?5,"2.  The amount billed is less than 20,000.00"
 W !?5,"2.  The A/R Account tied to the bill is in the list specified, "
 W !?5,"3.  The account is NON-BENEFICIARY or BENEFICARY, as selected."
 W !?5,"4.  There is a positive balance left on the bill"
 W !?5,"5.  The Visit Location tied to the bill is in the list specified"
 ; 
 ;S Y=BAREXP
 ;D DD^%DT
 ;S BAREXPDT=Y  ;External Date
 ;
 S QUIT=0
 W !!
 ; IHS/SD/PKD 4/5/11 Manilaq wants to write off Non-Ben as well as BEN
 ;
 S ADJTYP=0 D ADJCAT
 I QUIT D XIT Q
 S (BARQUIT,BENPLUS)=0
 D ASKBEN
 I BARQUIT D XIT Q
 D ASKLOC                                 ; Ask visit location list
 I '+BARLOC D XIT Q
 D ASKDOS                                 ; Ask Date of Service
 Q:'$D(BARDOS)!($G(BARDOS("E"))="")  ; Quit if invalid date entered
 D ASKACCT                                ; Ask A/R Account List
 I '+BARACCT D XIT Q
 D CONTINUE                               ; Display choices ask continue
 I '+BARCONT D XIT Q                      ; Don't continue
 D LOOPDUZ^BARMAWO7  ; 1.8*21 PKD 3/28/11
 ;BAR*1.8*21
 .W !!!,BARCNT," Bills written off to Auto Write-off ",BAREXPDT
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
DATE ;  don't force dates 3 years into past  
 ; IHS/SD/PKD 3/28/11 1.8*21
 ; Select date range
 S BARDOS=$$DATE^BARDUTL(1)
 I BARDOS<1 Q
 S BARDOS2=$$DATE^BARDUTL(2)
 I BARDOS2<1 W ! G DATE
 I BARDOS2<BARDOS D  G DATE
 . W *7
 . W !!,"The END date must not be before the START date.",!
 S Y=BARDOS2
 I Y>3100100 W *7," Date later than 12/31/2009 is not acceptable at this time" G DATE
 D DD^%DT
 S BARDOS("E")=Y  ;External End Date
 Q
 ; *********************************************************************
 ;
ASKACCT ;  
 ; Ask for list of A/R Accounts
 K DIC,X,Y
 W !
 I 'BENPLUS W !,"Selecting ALL A/R accounts will Write off Only BENEFICIARY accounts"
 S BARACCT=1
 S DIC="^BARAC(DUZ(2),"
 S DIC(0)="AEMQ"
 S DIC("A")="Select A/R Account: ALL// "
 F  D  Q:+Y<0
 . I $D(BAR("ACCT")) S DIC("A")="Select Another A/R Account: "
 . D ^DIC
 . Q:+Y<0
 . S BAR("ACCTTYPE")=$$GET1^DIQ(90050.02,+Y,1.08)
 .; IHS/SD/PKD 4/5/11 1.8*MANILAQ 2 chgs:  
 .; 1 - see if ok to include NONBEN's  (BENPLUS=1)
 .; 2 - change to "NON-BEN" since that's what returned
 .; I BAR("ACCTTYPE")["NON-BENEFICIARY" D  Q
NON . I 'BENPLUS I BAR("ACCTTYPE")["NON-BEN" D  Q  ; BENPLUS=0 if ONLY NON-BEN
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
 I $G(BARDOS("E"))="" W !,"Quitting - no date entered" Q
 W "You have chosen to write off bills meeting the above criteria"
 W !,"for dates of service up to and including ",BARDOS("E")
 W !!,"for the following Locations: "
 I '$D(BAR("LOC")) W ?40,"ALL"
 I $D(BAR("LOC")) D
 . S BARTMP=0
 . F  S BARTMP=$O(BAR("LOC",BARTMP)) Q:'+BARTMP  D
 . . W ?40,$P(^DIC(4,BARTMP,0),U),!
 W !,"for the following A/R accounts: "
 I '$D(BAR("ACCT")) W ?40,"ALL" I 'BENPLUS W " BENEFICIARY"
 I $D(BAR("ACCT")) D
 . S BARTMP=0
 . F  S BARTMP=$O(BAR("ACCT",BARTMP)) Q:'+BARTMP  D
 . . W ?40,$$VAL^XBDIQ1(90050.02,BARTMP,.01),!
 W !,"The Transaction Type will be: Adjustment (43)"
 W !,"The Adjustment Category will be:  ",BARY("ADJ CAT",BARCAT)," (",(BARCAT),")"
 W !,"The Adjustment Type will be:  ",BARY("ADJ TYP",ADJTYPE)," (",(ADJTYPE),")",!!
 W !!,"The bill number and amount written off will scroll by on the screen."
 W !,"If you wish to capture this information, please turn on Screen Capture.",!
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
ASKBEN  ; EP
 ; IHS/SD/PKD 1.8*Manilaq Allow Non-Bens to be written off
 W !,"   ***********   **************   ***************   *************************"
 W !,"Generally, this Write-Off should apply to BENEFICIARY patients ONLY."
 W !,"However, you may specify whether to include Non-Beneficiary patients as well."
 W !,"   ***********   **************   ***************   *************************",!
 K DIR
 S DIR(0)="Y"
 S DIR("A")="Include Non-Beneficiaries?"
 S DIR("B")="No"
 D ^DIR
 K DIR
 S (BARQUIT,BENPLUS)=0
 S:Y=1 BENPLUS=1  ; Include Non-Beneficiaries
 S:Y=U BARQUIT=1
 Q
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
 ;
ADJTYPE  ; EP  IHS/SD/PKD 1.8*20 from BARTRANS
 ; Select ADJ TYPES 
 K BARY("ADJ TYP")
 K DIC
 S DIC=90052.02
 S DIC(0)="AEQX"
 W !
 S DIC("A")="Please select ADJUSTMENT TYPE: "
 ;F  D  Q:+Y<0
 D ^DIC
 I $G(DUOUT)=1 S QUIT=1 W !!,"      QUITTING" Q
 I Y<1 W !,"Required Input" G ADJTYPE
 S BARY("ADJ TYP",+Y)=$P(Y,U,2)
 I '$D(BARY("ADJ TYP")) W !,"Required Input" G ADJTYPE
 I $P(^BARTBL(+Y,0),U,3)'="WO" W !,"Please enter a valid Write-Off code" G ADJTYPE
 S ADJTYPE=+Y
 K DIC
 W !
 Q
ADJCAT ; choices
 K DIC,DIE,DR,DA
 S DIC(0)="AEZ"
 S DIC=90052.01
 W !!,"     Select WRITE-OFF (3) or NON-PAYMENT (4), please"
 S DIC("S")="I "",3,4,""[("",""_Y_"","")"
 S DIC("W")="N C,DINAME W ""  "" W ""   "",$P(^(0),U,2)"
 D ^DIC
 S BARCAT=""
 I $G(DUOUT)=1 S QUIT=1 W !!,"      QUITTING" Q
 I Y>0 S BARCAT=+Y,BARY("ADJ CAT",BARCAT)=Y(0)
 E  W !!,"Required field, Please select" G ADJCAT
 ;S BARCAT=Y
ADJTYP K DIC,DIE,DR,DA
 S DIC(0)="AEQSZ"
 W !!,"     Now select an Adjustment Type Code",!
 S DIC=90052.02  ; ^BARTBL - Adj Type Codes for NonPayment or WriteOff
 K ADJTYP S ADJTYP=","
 S TYP=0 F  S TYP=$O(^BARTBL("D",BARCAT,TYP)) Q:'TYP  S ADJTYP=ADJTYP_TYP_","
 N Q S Q=""""
 S DIC("S")="I "_Q_ADJTYP_Q_"[("",""_Y_"","")"
 S DIC("W")="N C,DINAME W ""  "" W ""   "",$P(^(0),U,2)"
 D ^DIC
 I $G(DUOUT)=1 S QUIT=1 W !!,"      QUITTING" Q
 I $P(Y(0),U,2)'=BARCAT W !!,*7,?10,"*** Problem w/ dictionary, this is not an AdjCat ",BARY("ADJ CAT",BARCAT) G ADJTYP
 K ADJTYP
 K DIC
 I +Y>0 S ADJTYPE=+Y
 E  G ADJTYP
 S BARY("ADJ TYP",ADJTYPE)=$P(^BARTBL(ADJTYPE,0),U,1)
 Q
