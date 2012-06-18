BLRALPH ;DAOU/ALA/EJN-Setup Participating Physicians [ 12/19/2002  7:16 AM ]
 ;;5.2;LR;**1013,1015**;NOV 18, 2002
 ;
 ; ** Program Description **
 ;  This program sets up any physician and physician
 ;  supervisor who are participating in the requirement
 ;  of electronic signature for lab results
 ;
EN ;  Check for access to this option
 ;  check if a user has one of the BLRA keys and is calling
 ;  this option from the User Toolbox option
 F BLRAKEY="BLRAZLAB","BLRAZPHY","BLRAZSUP" D
 . S RETKEY=$$KCHK^XUSRB(BLRAKEY)
 . S KEYCT=$G(KEYCT)+RETKEY
 I $G(XQSV)["XUSERTOOLS"&(KEYCT=0) Q
 ;
 ;  If the user is a participating physician, allow them
 ;  to edit their surrogates.
 I $D(^BLRALAB(9009027.1,DUZ))&($$KCHK^XUSRB("BLRAZCLRK")=0) G SUR
 ;
 ;  If the user hasn't been assigned the Lab ES Clerk key, quit
 I $$KCHK^XUSRB("BLRAZCLRK")=0 Q
 ;
CLK ; Clerk's enter/edit of the Participating Physician File
 ;D CSUR
 S DIC="^BLRALAB(9009027.1,",DIC(0)="AELMNZ",DLAYGO=9009027.1
 S DIC("A")="Select PARTICIPATING PHYSICIAN: "
 D ^DIC S DA=+Y I DA<1 G EXIT
 ;
 S DIE=DIC,DR="[BLRA PHYSICIAN]" D ^DIE
 W !!
 G CLK
 ;
EXIT K BLRAACT,DIC,DIE,DA,DR
 K IENS,TXT,BLRAPIEN,BLRASUP,BLRAPNAM
 Q
SUR ;  Set up delegated surrogates
 ;D CSUR
 S DR="[BLRA SURROGATES]"
 E  S DR="1"
 S DIE="^BLRALAB(9009027.1,",DA=DUZ
 D ^DIE
 G EXIT
 Q
 ;
CSUR ;EP - Clean-up expired surrogates in Participating Physicians File
 N BLRASUR,BLRAPHY,DA,DIK,Y
 S BLRAPHY=0
 F  S BLRAPHY=$O(^BLRALAB(9009027.1,BLRAPHY)) Q:'BLRAPHY  D
 . I $P($G(^BLRALAB(9009027.1,BLRAPHY,1,0)),U,4)<1 Q
 . S BLRASUR=0
 . F  S BLRASUR=$O(^BLRALAB(9009027.1,BLRAPHY,1,BLRASUR)) Q:'BLRASUR  D
 .. I $P($G(^BLRALAB(9009027.1,BLRAPHY,1,BLRASUR,0)),U,3)<$$DT^XLFDT() D
 ... S DA=BLRASUR,DA(1)=BLRAPHY
 ... S DIK="^BLRALAB(9009027.1,"_BLRAPHY_",1," D ^DIK
 Q
 ;
INACT ;EP
 ;   Inactivate a participating provider 
 ;D CSUR
 D EN^DDIOL("","","!!")
 S DIC="^BLRALAB(9009027.1,",DIC(0)="AEMNZ"
 S DIC("A")="Select PARTICIPATING PHYSICIAN: "
 D ^DIC S DA=+Y I DA<1 G EXIT
 S BLRAPNAM=$G(Y(0,0))
 S BLRAPIEN=DA
 ;
 ;  Check to see if a supervisor
 S BLRASUP=$S($P($G(^BLRALAB(9009027.1,DA,0)),U,2)="S":1,1:0)
 I BLRASUP S QFL=0,BLRAFSP=DA D SUP Q:QFL
 ;
 ;  Inactive physician
 D EN^DDIOL("To inactive physician "_BLRAPNAM_" enter ""I""","","!!")
 S DIE=DIC,DR=".07;I X="""" S BLRAACT=1;" D ^DIE
 I $G(BLRAACT)>0 D EN^DDIOL("The Physician "_BLRAPNAM_" has not been inactivated...","","!!") G EXIT
 ;
ISRG ;  Designate surrogate for 90 days
 K DA,DIC,DIE,DR
 S DA(1)=BLRAPIEN,DR="1",DLAYGO=9009027.11
 I '$D(^BLRALAB(9009027.1,DA(1),1,0)) S ^BLRALAB(9009027.1,DA(1),1,0)="^9009027.11^^"
 S DIC="^BLRALAB(9009027.1,"_DA(1)_",1,",DIC(0)="AEMLZ"
 S DIC("A")="Select a SURROGATE PHYSICIAN:"
 D ^DIC S DA=+Y
 I DA<1 D EN^DDIOL("** You must select a Participating Physician to be the Surrogate for 90 days. **","","!!") G ISRG
 S TERMDT=$$GET1^DIQ(200,DA,9.2,"I")
 I TERMDT'=""&(TERMDT'>DT) D EN^DDIOL("This provider has a termination date please select another.") K DA G ISRG
 S IENS=$$IENS^DILF(.DA)
 S DR="@2;.02;I X="""" D EN^DDIOL(""You must enter a START DATE."") S Y=""@2"";S ENDT=$$FMADD^XLFDT(($$GET1^DIQ(9009027.11,IENS,.02,""I"")),90);.03////^S X=ENDT;S TXT=""END DATE: ""_$$FMTE^XLFDT(ENDT);D EN^DDIOL(TXT)"
 S DIE=DIC,DIE("NO^")="BACK" D ^DIE
 ;
 K DIE,DA,DIK,DIC,BLRAS,BLRVD,BLRAP,LRIDT,LRSS,LRDFN,TERMDT
 K BLRAACT,BLRAFPH,BLRATPH,DIR,BLRADATA,BLRARFL,BLRARPHY
 G INACT
 Q
SUP ;  Ask to change supervisor to
 NEW DIR
 S DIR("A",1)=" "
 S DIR("A",2)="This physician is a designated supervisor.  All subordinate"
 S DIR("A",3)="participating physicians must have a valid supervisor."
 S DIR("A")="DO YOU WISH TO REASSIGN TO ANOTHER SUPERVISOR NOW"
 S DIR(0)="Y"
 D ^DIR
 I $G(Y)'=1 S QFL=1 Q
 I $G(Y)=1 D  Q:QFL
 . S DIC="^BLRALAB(9009027.1,",DIC(0)="AEMNZ",DIC("S")="I $P(^(0),U,2)=""S"""
 . D ^DIC I Y<1 S QFL=1 Q
 . S BLRATSP=+Y
 . S BLRJ="" F  S BLRJ=$O(^BLRALAB(9009027.1,"C",BLRAFSP,BLRJ)) Q:'BLRJ  D
 .. S BLRALY(9009027.1,BLRJ_",",.03)=BLRATSP
 . D FILE^DIE("","BLRALY")
 Q
