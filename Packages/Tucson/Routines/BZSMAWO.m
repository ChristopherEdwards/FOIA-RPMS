BZSMAWO ; IHS/TAO/EDE - WRITE OFF OLD BILLS [ 04/06/2003  9:28 AM ]
 ;;1.0;TUCSON AREA OFFICE W/O;;MAR 14, 2003
 ;
 ; This routine is intended to be used to clean up accounts
 ; receivable on dates of service specified by the user.
 ;
 ; All bills for up to and including the DOS specified for the
 ; A/R Accounts specified will be written off to a special code.
 ;
 ; The user selects the allowance category, Medicare, Medicaid, or
 ; Private Insurance.  Based on the allowance category the
 ; account types are selected.  Based on the account types the
 ; individual accounts are selected.
 ;
START ;
 D INIT ;                                   initialization
 I BZSQF D EOJ Q  ;                         problem or user sez quit
 D WRITEOFF ;                               write off bills
 D EOJ ;                                    clean up
 Q
 ;
SACCT ; EP-TO WRITE OFF SELECTED ACCOUNTS
 S BZSSAFLG=1 ;                             set selected accts flag
 D INIT ;                                   initialization
 I BZSQF D EOJ Q  ;                         problem or user sez quit
 D WRITEOFF ;                               write off bills
 D EOJ ;                                    clean up
 Q
 ;
 ;====================
INIT ; INITIALIZATION
 S BZSQF=1 ;                                set quit flag to yes
 S BZSHOLD=DUZ(2)
 I '$D(IORVON) S X="IORVON;IORVOFF" D ENDR^%ZISS
 I '$D(IORVON) S (IORVON,IORVOFF)="""" ;use " then
 I '$D(^BARTBL(1003,0)) D  Q
 .  W !,"A/R tabe entry 1003 PAID DENIED OVER STAT LIMIT not defined.",!
 .  W "Terminating run.",!!
 .  Q
 S (BZSCONT,BZSCNT)=0
 S BZSSECT=$$VALI^XBDIQ1(200,DUZ,29)      ; Serv/Sect from NEW PERSON
 I $G(BZSSAFLG) D  I 1
 .  W !!,"This routine allows the user to write off old bills for selected accounts",!
 .  W "and date of service.  You should capture this session to a file.",!
 .  Q
 I '$G(BZSSAFLG) D
 .  W !!,"This routine allows the user to write off old bills based on the allowance",!
 .  W "category and date of service.  You should capture this session to a file.",!
 .  Q
 W "You need to run this routine using terminal software that allows you to",!
 W "scroll back.",!
 I $G(BZSSAFLG) D INITSA I 1 ;              init for selected accts
 E  D INITAC ;                              init for allowance cat
 Q:BZSSQF  ;                                quit if sub qf set
 D ASKDOS ;                                 Ask Date of Service
 Q:$G(BZSEDOS)=""  ;                        Quit if no ending date
 D CONTINUE ;                               Display choices ask continue
 Q:'+BZSCONT  ;                             Don't continue
 S BZSQF=0 ;                                set quit flag to no
 Q
 ;
INITSA ; INITIALIZATION FOR SELECTED ACCOUNTS ONLY
 S BZSSQF=1 ;                               set sub quit flag to yes
 D ASKACCT ;                                as for selected accts
 Q:'$O(BZS("ACCT",0))  ;                    no acct selected
 S BZSSQF=0 ;                               set sub quit flag to no
 Q
 ;
INITAC ; INITIALIZATION FOR ALLOWANCE CATEGORY
 S BZSSQF=1 ;                               set sub quit flag to yes
 D ASKACAT ;                                ask allowance category
 Q:'BZSACAT  ;                              no allowance cat selected
 D ASKACCTT ;                               ask account types
 Q:'BZSACCTT  ;                             no account types
 D BLDACCTL ;                               build account list
 S BZSSQF=0 ;                               set sub quit flag to no
 Q
 ;
 ;--------------------
ASKACCT ; ASK FOR LIST OF A/R ACCOUNTS  
 K BZS("ACCT") ;                             no residue
 K DIC,X,Y
 W !
 S DIC="^BARAC(DUZ(2),"
 S DIC(0)="AEMQ"
 S DIC("A")="Select A/R Account:"
 F  D  Q:+Y<0
 . I $D(BZS("ACCT")) S DIC("A")="Select Another A/R Account: "
 . D ^DIC
 . Q:+Y<0
 . S BZSACT=$$GET1^DIQ(90050.02,+Y,1.08)
 . S:BZSACT]"" BZS("ACCTTYPE",BZSACT)="" ;  save account types
 . S BZS("ACCT",+Y)=$P(Y,U,2) ;             save account
 . Q
 K DIC
 W !!
 Q
 ;
 ;--------------------
ASKACAT ; ASK ALLOWANCE CATEGORY
 S BZSACAT="" ;                             allowance cat to null
 S DIR(0)="S^1:MEDICARE;2:MEDICAID;3:PRIVATE INSURANCE",DIR("A")="Select allowance category to write off" KILL DA D ^DIR KILL DIR
 Q:$D(DIRUT)  ;                             ^ or time out
 S BZSACAT=Y ;                              save allowance cat
 S BZSACATN=$S(Y=1:"MEDICARE",Y=2:"MEDICAID",Y=3:"PRIVATE INSURANCE",1:"")
 Q
 ;
 ;--------------------
ASKACCTT ; ASK FOR LIST OF ACCOUNT TYPES
 S BZSACCTT=0
 K BZSATTBL
 S BZSACCT=0
 F  S BZSACCT=$O(^BARAC(DUZ(2),BZSACCT)) Q:'BZSACCT  D
 .  Q:'$D(^BARAC(DUZ(2),BZSACCT,0))  ;      corrupt database
 .  S BZSAT=$$VAL^XBDIQ1(90050.02,BZSACCT,1.08)
 .  Q:BZSAT=""  ;                           bad acct entry
 .  S BZSATTBL(BZSAT)=$S(BZSAT["MEDICARE":1,BZSAT["MEDICAID":2,BZSAT["PRIVATE":3,1:"")
 .  S BZSATTBL(BZSAT,BZSACCT)=$P(^BARAC(DUZ(2),BZSACCT,0),U)
 .  Q
 S BZSAT=""
 F BZSATC=1:1 S BZSAT=$O(BZSATTBL(BZSAT)) Q:BZSAT=""  D
 .  S BZSATL(BZSATC)=BZSAT_U_$S(BZSATTBL(BZSAT)=BZSACAT:"In",1:"Out")
 .  Q
 S BZSATC=BZSATC-1 ;                        set to real count
 F  D CONFAT Q:BZSLQF  ;                    confirm acct types
 Q:$D(DUOUT)  ;                             user ^ out
 ; gen temp tbl of acct types in allowance category
 F BZSSN=1:1 S BZSAT=$P(BZSATL(BZSSN),U)  D  Q:BZSSN=BZSATC
 .  Q:$P(BZSATL(BZSSN),U,2)'="In"
 .  S BZSTMP(BZSAT)=""
 .  Q
 ; delete all acct types not in allowance category from bzsattbl
 S BZSAT=""
 F  S BZSAT=$O(BZSATTBL(BZSAT)) Q:BZSAT=""  D
 .  Q:$D(BZSTMP(BZSAT))  ;                  quit if in allow cat
 .  K BZSATTBL(BZSAT) ;                     delete acct type nic
 .  Q
 S BZSAT=""
 F BZSACCTT=1:1 S BZSAT=$O(BZSATTBL(BZSAT)) Q:BZSAT=""
 S BZSACCTT=BZSACCTT-1
 K BZSATL,BZSTMP
 Q
 ;
CONFAT ; CONFIRM ACCOUNT TYPES
 S BZSLQF=1 ;                               loop control flag to end
 W !,"Allowance Category: ",BZSACATN,!!
 F BZSSN=1:1 S BZSAT=$P(BZSATL(BZSSN),U)  D  Q:BZSSN=BZSATC
 .  W ?1,BZSSN,?5,$P(BZSATL(BZSSN),U,2),?10,BZSAT,!
 .  Q
 S DIR(0)="NO^1:"_BZSATC,DIR("A")="Select item number to toggle in/out of allowance category" KILL DA D ^DIR KILL DIR
 Q:$D(DIRUT)  ;                             ^ or time out
 Q:Y=""  ;                                  user thru
 NEW X S X=$P(BZSATL(Y),U,2) ;              get cat flag
 S $P(BZSATL(Y),U,2)=$S(X="In":"Out",1:"In") ;toggle value
 S BZSLQF=0 ;                               loop control flag to go
 Q
 ;
 ;--------------------
BLDACCTL ; BUILD ACCOUNT LIST
 K BZS
 S BZSAT=""
 F  S BZSAT=$O(BZSATTBL(BZSAT)) Q:BZSAT=""  D
 .  S BZSACCT=0
 .  F  S BZSACCT=$O(BZSATTBL(BZSAT,BZSACCT)) Q:'BZSACCT  D
 . . S BZS("ACCT",BZSACCT)=BZSATTBL(BZSAT,BZSACCT)
 ..  Q
 .  Q
 K BZSATTBL
 Q
 ;
 ;--------------------
ASKDOS ; ASK DATE OF SERVICE
 I $G(BZSACAT) S BZSDYS=$S(BZSACAT=1:((365*2)+180),BZSACAT=2:365,BZSACAT=3:(365+90),1:"") I 1
 E  S BZSDYS=((365*2)+180) ;             for selected accts default long
 S BZSDOS2=$$FMADD^XLFDT(DT,-BZSDYS) ;   latest end date
 S Y=BZSDOS2
 D DD^%DT
 S BZSDOSE=Y
 W !!,"Enter a date, preferably less than or equal to "_BZSDOSE_".",!
 W "Dates up to and including the one entered will be written off.",!
 K DIR
 S DIR("?")="Enter a date, preferably less than or equal to "_BZSDOSE_"."
 S DIR("?",1)="Dates up to and including the one entered will be written off."
 S DIR(0)="DO^::EP",DIR("A")="Enter ending date of time frame" KILL DA D ^DIR KILL DIR
 Q:'+Y
 S BZSEDOS=Y
 S BZSDOS("E")=Y(0)
 I BZSEDOS>BZSDOS2 D  Q:'$D(BZSEDOS)  ;     quit if no end date
 .  W !!,IORVON_"Ending date of time frame is after "_BZSDOSE_"."_IORVOFF,!
 .  W IORVON_"Are you absolutely certain you want this date?"_IORVOFF,!
 .  S DIR(0)="YO",DIR("B")="NO" KILL DA D ^DIR KILL DIR
 .  I 'Y K BZSDOS,BZSEDOS ;                 user said no
 .  Q
 S BZSBDOS=""
 W !
 S DIR(0)="DO^:"_BZSEDOS_":EP",DIR("A")="Enter beginning date of time frame" KILL DA D ^DIR KILL DIR
 S BZSBDOS=Y
 S BZSDOS("B")=$G(Y(0))
 Q
 ;
 ;--------------------
CONTINUE ; DISPLAY CHOICES AND ASK IF THEY WISH TO CONTINUE
 ; Tell them bills written off will scroll on the screen if they wish to
 ; capture.
 S BZSX=$S(BZSDOS("B")="":"up to and including "_BZSDOS("E"),1:"between "_BZSDOS("B")_" and "_BZSDOS("E")_" inclusively")
 W !!,"You have chosen to write off bills for dates of service ",!
 W BZSX,!
 ;W !!,"for the following Locations: "
 ;I '$D(BZS("LOC")) W ?40,"ALL"
 ;I $D(BZS("LOC")) D
 ;. S BZSTMP=0
 ;. F  S BZSTMP=$O(BZS("LOC",BZSTMP)) Q:'+BZSTMP  D
 ;. . W ?40,$P(^DIC(4,BZSTMP,0),U),!
 W !,"for the following A/R accounts: "
 I '$D(BZS("ACCT")) W ?40,"ALL"
 I $D(BZS("ACCT")) D
 . S BZSTMP=0
 . F  S BZSTMP=$O(BZS("ACCT",BZSTMP)) Q:'+BZSTMP  D
 . . W ?40,$$VAL^XBDIQ1(90050.02,BZSTMP,.01),!
 W !!,"The bill number and amount written off will scroll by on the screen"
 W !,"if you wish to capture this information.",!
 ;
 K DIR
 S DIR(0)="Y"
 S DIR("A")="Continue"
 S DIR("B")="No"
 D ^DIR
 K DIR
 S:Y=1 BZSCONT=1
 Q
 ;
 ;--------------------
PAUSE ; PAUSE FOR USER
 S DIR(0)="EO",DIR("A")="Press RETURN to continue"
 KILL DA
 D ^DIR
 KILL DIR
 Q
 ;
 ;====================
WRITEOFF ; WRITE OFF BILLS
 S BZSCNT=0
 D ^BZSMAWO2 ;                      write off bills matching criteria
 W !!,BZSCNT," Bills written off to Auto Write-off 1003."
 Q
 ;
 ;====================
EOJ ; EOJ CLEAN UP
 S DUZ(2)=BZSHOLD
 D EN^XBVK("BZS") ;                       Kill local variables
 Q
