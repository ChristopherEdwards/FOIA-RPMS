BCHENV ; IHS/TUCSON/LAB - environmental check [ 09/21/2006  11:23 AM ]
 ;;1.0;IHS RPMS CHR SYSTEM;**12,14,15**;OCT 28, 1996
 ;
 ;;
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 F X="XPO1","XPZ1","XPZ2","XPI1" S XPDDIQ(X)=0
 Q
 ;
PRE ;EP - delete CHR POV file
 F DA=1:1:200 S DIK="^BCHSORT(" D ^DIK
 S DA=$O(^BCHTREF("B","SUBSTANCE ABUSE PROGRAM",0))
 I DA S DIE="^BCHTREF(",DR=".01///BEHAVIORAL HEALTH;.03///BH" D ^DIE K DA,DIE,DR
 S DA=$O(^BCHTHAC("B","MENTAL HEALTH",0))
 I DA S DIE="^BCHTHAC(",DR=".01///BEHAVIORAL HEALTH" D ^DIE K DA,DIE,DR
 S DA=$O(^BCHTPROB("C","TB",0))
 I DA S DIE="^BCHTPROB(",DR=".01///TUBERCULOSIS" D ^DIE K DA,DIE,DR
 S DA=$O(^BCHTPROB("C","HI",0))
 I DA S DIE="^BCHTPROB(",DR=".01///HIV/AIDS" D ^DIE K DA,DIE,DA
 S DA=$O(^BCHTHAC("C","MENTAL HEALTH",0))
 I DA S DIE="^BCHTHAC(",DR=".01///BEHAVIORAL HEALTH" D ^DIE K DA,DIE,DR
 S DA=$O(^BCHTPROB("C","SX",0))
 I DA S DIE="^BCHTPROB(",DR=".01///SEXUALLY TRANSMITTED" D ^DIE K DA,DIE,DR
 ;S DA=$O(^BCHTPROB("C","SD",0))
 ;I DA S DIE="^BCHTPROB(",DR=".02///SZ" D ^DIE K DA,DIE,DR
 S DA=$O(^BCHTPROB("C","DA",0))
 I DA S DIE="^BCHTPROB(",DR=".01///SUBSTANCE ABUSE;.02///SA" D ^DIE K DA,DIE,DR
 S DIK="^DD(90002.53,",DA=.04,DA(1)=90002.53 D ^DIK
 S X=0 F  S X=$O(^BCHTPROB(X)) Q:X'=+X  S $P(^BCHTPROB(X,0),U,4)=""
 S DA=$O(^BCHTSERV("B","NO CONTACT",0)) I DA S DIK="^BCHTSERV(" D ^DIK
 Q
POST ;EP
 ;
 ;get rid of infections and repoint to infections (ear)
 S BCHIN=$O(^BCHTPROB("B","INFECTIONS",0))
 S BCHINE=$O(^BCHTPROB("B","INFECTIONS (EAR)",0))
 I BCHIN,BCHINE D
 .S BCHX=0 F  S BCHX=$O(^BCHRPROB("B",BCHINE,0)) Q:BCHX'=+BCHX  D
 ..S DIE="^BCHRPROB(",DA=BCHX,DR=".01///`"_BCHIN D ^DIE W "."
 ..K DIE,DA,DR
 .S DA=BCHINE,DIK="^BCHTPROB(" D ^DIK
  ;get rid of infections and repoint to infections (ear)
 NEW X
 S X=$$ADD^XPDMENU("BCH M MANAGER UTILITIES","BHL CHR MENU","CHL7")
 I 'X W "Attempt to add BHL HL7 option failed.." H 3
 Q
SENDBULL ;
 ;;
 ;;Here's how to make this work:
 ;;
 ;;1. Create your message in subroutine WRITEMSG
 ;;2. Identify recipients in GETRECIP by setting BCHKEY
 ;;3. Make changes in SUBJECT and SENDER as desired
 ;;4. Rename this routine in appropriate namespace and 
 ;;   call on completion of patch or upgrade
 ;
 I '$G(DUZ) W !,"DUZ UNDEFINED OR ZERO.",! Q
 D HOME^%ZIS,DT^DICRW
 ;
 NEW XMSUB,XMDUZ,XMTEXT,XMY,DIFROM
 KILL ^TMP($J,"BCHBUL")
 D WRITEMSG,GETRECIP
 ;Change following lines as desired
SUBJECT S XMSUB="* * * IMPORTANT RPMS INFORMATION * * *"
SENDER S XMDUZ="IHS Information Technology"
 S XMTEXT="^TMP($J,""BCHBUL"",",XMY(1)="",XMY(DUZ)=""
 I $E(IOST)="C" W !,"Sending Mailman message to holders of the"_" "_BCHKEY_" "_"security key."
 D ^XMD
 KILL ^TMP($J,"BCHBUL"),BCHKEY
 Q
 ;
WRITEMSG ;
 F %=3:1 S X=$P($T(WRITEMSG+%),";",3) Q:X="###"  S ^TMP($J,"BCHBUL",%)=X
 Q
 ;;  
 ;;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ;;RPMS CHR Reporting System patch 1 has been installed on your system.
 ;;
 ;;You will notice the following change:
 ;;  There is a new menu option/action that allows you to browse a patient's
 ;;  CHR visits.
 ;;
 ;;+++++++++++++++++++++ end of announcement +++++++++++++++++++++++
 ;;###
 ;
GETRECIP ;
 ;* * * Define key below to identify recipients * * *
 ;
 S CTR=0,BCHKEY="BCHZMENU"
 F  S CTR=$O(^XUSEC(BCHKEY,CTR)) Q:'CTR  S Y=CTR S XMY(Y)=""
 Q
