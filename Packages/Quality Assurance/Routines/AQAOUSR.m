AQAOUSR ; IHS/ORDC/LJF - ENTER/EDIT QI USER ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This is the first rtn containing the user interface for adding and
 ;editing a user entry in the QI User file.  Even with all the security
 ;keys, a user cannot enter the main QAI menu without the proper entry
 ;in the QI User file.
 ;
NAME ;ENTRY POINT from continuation rtn AQAOUSR1
 D INTRO^AQAOHUSR ;intro text
 ; >>> ask for user name
 I $D(AQAOUSR) L -^AQAO(9,AQAOUSR) ;unlock last user edited
 D KILL^AQAOUTIL ;clean out variables
 W ! K DIC S DIC=200,DIC(0)="AEMZQ",DIC("A")="Select QI USER NAME:  "
 D ^DIC G END:$D(DTOUT),END:$D(DUOUT),END:X="",NAME:Y=-1
 S AQAOUSR=+Y,AQAONM=$P(Y,U,2) ;user ifn and name
 ;
ADD ; >> if not in qi user file, ask to add     
 I '$D(^AQAO(9,AQAOUSR,0)) D  G NAME:$D(DIRUT),NAME:Y=0
 .W ! K DIR S DIR(0)="Y",DIR("B")="YES"
 .S DIR("A")="Do you wish to add "_AQAONM_" to the QI USER file"
 .D ^DIR Q:$D(DIRUT)  Q:Y=0
 .K DD,DO,DIC S DIC="^AQAO(9,",DIC(0)="L",(X,DINUM)=AQAOUSR
 .S DIC("DR")=".02///^S X=DT;.03///^S X=""`""_DUZ"
 .L +(^AQAO(9,0)):1 I '$T D  Q
 ..W !!,"CANNOT ADD; ANOTHER USER ADDING TO THIS FILE.  TRY AGAIN.",!
 .D FILE^DICN L -(^AQAO(9,0)) S AQAONEW=""
 I '$D(^AQAO(9,AQAOUSR)) G END ;add didn't work
 L +^AQAO(9,AQAOUSR):1 I '$T D  G NAME
 .W !!,"CANNOT EDIT; ANOTHER USER IS EDITING THIS USER ENTRY.",!
 ;
INACTIVE ; >> check for inactive entry
 I $P(^AQAO(9,AQAOUSR,0),U,4)'="" D
 .W !!?5,*7,AQAONM," has been INACTIVATED!",!!
 .K DIR S DIR(0)="Y",DIR("B")="NO"
 .S DIR("A")="Do you wish to REACTIVATE this QI User entry"
 .D ^DIR Q:$D(DIRUT)  Q:Y'=1
 .S DIE="^AQAO(9,",DA=AQAOUSR,DR=".04///@;.05///@" D ^DIE
 ;
 ;
START ; >> start security key array
 K AQAOARR S AQAOARR("AQAOZMENU")=""
 ;
QISTAFF ; >> ask if user is member of QI staff for package-wide access
 W ! K DIR S DIR(0)="Y"
 S DIR("B")=$S($P(^AQAO(9,AQAOUSR,0),U,6)["Q":"YES",1:"NO")
 S DIR("?",1)="QI STAFF as defined for this package have access to ALL"
 S DIR("?",2)="indicators and occurrences.  For any user to have this"
 S DIR("?",3)="level of access, you must designate them as QI STAFF."
 S DIR("?")=" "
 S DIR("A")="Is "_AQAONM_" a member of the QI Staff"
 D ^DIR G NAME:$D(DIRUT)
 I Y=0,DIR("B")="YES" D  G TEAM ;if no longer qi staff member
 .S DIE="^AQAO(9,",DA=AQAOUSR,DR=".06///@" D ^DIE
 G TEAM:Y=0
 ;
PKGADMIN ; >> is user to be a pkg administrator
 W ! K DIR S DIR(0)="Y" K AQAOARR("AQAOZPKG")
 S DIR("B")=$S($P(^AQAO(9,AQAOUSR,0),U,6)="QA":"YES",1:"NO")
 S DIR("?",1)="From among the QI staff members, you may designate some"
 S DIR("?",2)="as PACKAGE ADMINISTRATORS.  These users will have access"
 S DIR("?",3)="to manage the QI USER file; to manage QI Teams and their"
 S DIR("?",4)="their membership lists; to print the AUDIT REPORTS that"
 S DIR("?",5)="track changes to the QAI files; and to the package files"
 S DIR("?",6)="that require initialization and updates."
 S DIR("?")=" "
 S DIR("A")="Is "_AQAONM_" to be a PACKAGE ADMINISTRATOR"
 D ^DIR G NAME:$D(DIRUT)
 ;
 I Y=0 S DR=".06///^S X=""QI"""
 I Y=1 S DR=".06///^S X=""QA""",AQAOARR("AQAOZPKG")=""
 S DIE="^AQAO(9,",DA=AQAOUSR D ^DIE
 I $D(AQAOARR("AQAOZPKG")) S DIE=200,DA=AQAOUSR,DR=".132" D ^DIE
 I $D(Y) G NAME ;"^" entered
 G PCUSER ;qi staff don't need team affiliations
 ;
TEAM ; >> enter team affiliations
 W !!,"Please add ALL QI Teams to which this user is a member.  You"
 W !,"will also be asked to designate the user's access level for each"
 W !,"team.  For example, a user may be able to enter occurrences for"
 W !,"one team (CREATE/EDIT) but have only INQUIRY access to the"
 W !,"occurrences for another team.",!!
 K DIC,DIE S DIE="^AQAO(9,",DA=AQAOUSR,DR="1"
 S DR(2,9002168.91)=".01:.02"
 D ^DIE I $D(Y) G NAME ;"^" entered
 ;
 ;
PCUSER ;ENTRY POINT >> is user advanced enough to use capture of ASCII files
 W !!,"  Some of reports available in this package can be transferred"
 W !,"  to a user's PC via 'Data Capture'.  The data will be sent in "
 W !,"  ASCII file format.  The user will NOT be given this choice"
 W !,"  unless you answer YES here.  This gives you the chance to"
 W !,"  make sure the user is KNOWLEDGEABLE in using data capture and"
 W !,"  understands the importance of SAFEGUARDING the data once it"
 W !,"  resides on their PC.  This gives the user access to RPMS data"
 W !,"  for use with statistical software.",!
 W ! K DIC,DIE S DIE="^AQAO(9,",DA=AQAOUSR,DR=".07" D ^DIE
 I $D(Y) G NAME
 ;
 ;
NEXT G ^AQAOUSR1 ;continuation of this rtn
 ;
END ; >>> eoj
 I $D(AQAOUSR) L -^AQAO(9,AQAOUSR)
 D KILL^AQAOUTIL Q
