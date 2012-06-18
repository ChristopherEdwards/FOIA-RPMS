BWBRNOT2 ;IHS/ANMC/MWR - BROWSE NOTIFICATIONS;03-Sep-2003 20:09;PLS
 ;;2.0;WOMEN'S HEALTH;**8,9**;MAY 16, 1996
 ;;* MICHAEL REMILLARD, DDS * ALASKA NATIVE MEDICAL CENTER *
 ;;  PROMPTS FOR SELECTION CRITERIA WHEN BROWSING NOTIFICATIONS.
 ;;  CALLED BY BWBRNOT.
 ;
 D SETVARS^BWUTL5
 D TITLE^BWUTL5("BROWSE NOTIFICATIONS")
 D ONEALL Q:BWPOP
 D DATES  Q:BWPOP
 D STATUS Q:BWPOP
 D CMGR   Q:BWPOP
 D ORDER  Q:BWPOP
 D DEVICE Q:BWPOP
 Q
 ;
ONEALL ;EP
 ;---> SELECT ONE PATIENT OR ALL PATIENTS.
 K DIR
 W !!?3,"Browse Notifications for ONE individual patient,"
 W !?3,"or browse Notifications for ALL patients?"
 S DIR("A")="   Select ONE or ALL: ",DIR("B")="ALL"
 S DIR(0)="SAM^o:ONE;a:ALL" D HELP2
 D ^DIR K DIR
 I Y=-1!($D(DIRUT)) S BWPOP=1 Q
 ;---> IF ALL PATIENTS, S BWA=1 AND QUIT.
 I Y="a" S BWA=1 Q
 ;
 W !!,"   Select the patient whose Notifications you wish to browse."
 D PATLKUP^BWUTL8(.Y)
 I Y<0 S BWPOP=1 Q
 ;---> FOR ONE PATIENT, SET BWA=0 AND BWDFN=PATIENT DFN, QUIT.
 S BWDFN=+Y,BWA=0,BWCMGR=$P(^BWP(BWDFN,0),U,10)
 Q
 ;
DATES ;EP
 ;---> ASK DATE RANGE.  RETURN DATES IN BWBEGDT AND BWENDDT.
 ;---> IF LOOKING AT ONLY ONE PATIENT, SET DEFAULT BEGIN DATE=T-365.
 S BWBEGDF=$S(BWA:"T-30",1:"T-365")
 D ASKDATES^BWUTL3(.BWBEGDT,.BWENDDT,.BWPOP,BWBEGDF,"T")
 Q
 ;
STATUS ;EP
 ;---> GET XREF: OPEN OR ALL
 W !!?3,"Do you wish to browse DELINQUENT, OPEN, QUEUED, "
 W "ERROR, or ALL Notifications?"
 S DIR("A")="   Select DELINQUENT, OPEN, QUEUED, ERROR or ALL: "
 S DIR("B")="OPEN"
 S DIR(0)="SAM^d:DELINQUENT;o:OPEN;q:QUEUED;e:ERROR;a:ALL" D HELP4
 D ^DIR K DIR
 I Y=-1!($D(DIRUT)) S BWPOP=1 Q
 S BWB=Y
 Q
 ;
CMGR ;EP
 ;---> SELECT CASES FOR ONE CASE MANAGER OR ALL.
 ;---> DO NOT PROMPT FOR CASE MANAGER IF SITE PARAMETERS SAY NOT TO,
 ;---> OR IF LOOKING AT PROCEDURES FOR ONLY ONE PATIENT.
 I '$D(^BWSITE(DUZ(2),0)) S BWE=1 Q
 I '$P(^BWSITE(DUZ(2),0),U,5)!('BWA) S BWE=1 Q
 W !!?3,"Browse Notifications for ONE particular Case Manager,"
 W !?3,"or browse Notifications for ALL Case Managers?"
 S DIR("A")="   Select ONE or ALL: ",DIR("B")="ALL"
 S DIR(0)="SAM^o:ONE;a:ALL" D HELP5
 D ^DIR K DIR
 I Y=-1!($D(DIRUT)) S BWPOP=1 Q
 ;---> IF ALL CASE MANAGERS, S BWE=1 AND QUIT.
 I Y="a" S BWE=1 Q
 ;
 W !!,"   Select the Case Manager whose patients you wish to browse."
 ;
 D DIC^BWFMAN(9002086.01,"QEMA",.Y,"   Select CASE MANAGER: ")
 I Y<0 S BWPOP=1 Q
 ;---> FOR ONE CASE MANAGER, SET BWE=0 AND BWCMGR=^VA(200 DFN, QUIT.
 S BWCMGR=+Y,BWE=0
 Q
 ;
 ;
ORDER ;EP
 ;---> ASK ORDER BY DATE OR BY PATIENT OR BY PRIORITY.
 ;---> IF LOOKING AT ONLY ONE PATIENT, ORDER BY DATE AND QUIT.
 I 'BWA S BWC=1 Q
 ;
 ;---> SORT SEQUENCE IN BWC:  1=DATE, PATIENT, PRIORITY
 ;--->                        2=PATIENT, DATE, PRIORITY
 ;--->                        3=PRIORITY, DATE, PATIENT
 ;
 W !!?3,"Display Notifications in order of:"
 W ?39,"1) DATE OF NOTIFICATION (earliest first)"
 W !?39,"2) NAME OF PATIENT (alphabetically)"
 W !?39,"3) PRIORITY (beginning with URGENT)"
 S DIR("A")="   Select 1, 2, or 3: ",DIR("B")=1
 S DIR(0)="SAM^1:DATE;2:NAME;3:PRIORITY" D HELP3
 D ^DIR K DIR
 I Y=-1!($D(DIRUT)) S BWPOP=1 Q
 S BWC=Y
 Q
 ;
DEVICE ;EP
 ;---> GET DEVICE AND POSSIBLY QUEUE TO TASKMAN.
 S ZTRTN="DEQUEUE^BWBRNOT"
 F BWSV="A","B","C","D","E","CMGR","DFN","BEGDT","ENDDT" D
 .I $D(@("BW"_BWSV)) S ZTSAVE("BW"_BWSV)=""
 D ZIS^BWUTL2(.BWPOP,1,"HOME")
 Q
 ;
HELP2 ;EP
 ;;Answer "ONE" to browse Notifications for ONE particular patient.
 ;;Answer "ALL" to browse Notifications for ALL patients.
 S BWTAB=5,BWLINL="HELP2" D HELPTX
 Q
 ;
HELP3 ;EP
 ;;Enter "DATE" to list Notifications in chronological order beginning
 ;;   with the oldest first.
 ;;Enter "NAME" to list Notifications by Patient Name in alphabetical
 ;;   order.
 ;;Enter "PRIORITY" to list Notifications by degree of urgency,
 ;;   beginning with the most urgent first.
 S BWTAB=5,BWLINL="HELP3" D HELPTX
 Q
 ;
HELP4 ;EP
 ;;"OPEN Notifications" are ones that have not yet been closed,
 ;;     in other words, the patient has not yet been reached or has not
 ;;     yet responded.
 ;;
 ;;"DELINQUENT Notifications" are OPEN Notifications that have remained
 ;;     open past the date they were due to be closed (as determined by
 ;;     the "DATE DELINQUENT BY" field in the Edit Notification screen).
 ;;
 ;;"QUEUED Notifications" are only LETTERS waiting to be printed.
 ;;     They do not include letters that have already been printed.
 ;;
 ;;"ERROR Notifications" are those notifications which have been marked
 ;;     as entered in error.
 ;;
 ;;"ALL Notifications" includes DELINQUENT, OPEN and CLOSED.
 ;;     CLOSED notifications are ones that have been brought to closure,
 ;;     in other words, either the patient has been contacted or the
 ;;     case is no longer active.
 S BWTAB=5,BWLINL="HELP4" D HELPTX
 Q
 ;
HELP5 ;EP
 ;;Answer "ONE" to browse Notifications for ONE particular Case Manager.
 ;;Answer "ALL" to browse Notifications for ALL Case Managers.
 S BWTAB=5,BWLINL="HELP5" D HELPTX
 Q
 ;
HELPTX ;EP
 ;---> CREATES DIR ARRAY FOR DIR.  REQUIRED VARIABLES: BWTAB,BWLINL.
 N I,T,X S T="" F I=1:1:BWTAB S T=T_" "
 F I=1:1 S X=$T(@BWLINL+I) Q:X'[";;"  S DIR("?",I)=T_$P(X,";;",2)
 S DIR("?")=DIR("?",I-1) K DIR("?",I-1)
 Q
