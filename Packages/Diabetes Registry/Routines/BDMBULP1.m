BDMBULP1 ; cmi/anch/maw - Routine to create bulletin for Version 2 patch 1 ; 
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**1**;AUG 11, 2006
 ;;
 ;;Here's how to make this work:
 ;;
 ;;1. Create your message in subroutine WRITEMSG
 ;;2. Identify recipients in GETRECIP by setting appropriate key
 ;;3. Make changes in SUBJECT and SENDER as desired
 ;;4. Callthis routine on completion of patch or upgrade
 ;
 I '$G(DUZ) W !,"DUZ UNDEFINED OR ZERO.",! Q
 D HOME^%ZIS,DT^DICRW
 ;
 NEW XMSUB,XMDUZ,XMTEXT,XMY,DIFROM
 KILL ^TMP($J,"BDMBUL")
 D WRITEMSG,GETRECIP  ;,RENAME
 ;Change following lines as desired
SUBJECT S XMSUB="* * * IMPORTANT RPMS INFORMATION * * *"
SENDER S XMDUZ="Diabetes Management System Coordinator"
 S XMTEXT="^TMP($J,""BDMBUL"",",XMY(1)="",XMY(DUZ)=""
 I $E(IOST)="C" W !,"Sending Mailman message to holders of the"_" "_BDMKEY_" "_"security key."
 D ^XMD
 KILL ^TMP($J,"BDMBUL"),BDMKEY
 Q
 ;
WRITEMSG ;
 F %=3:1 S X=$P($T(WRITEMSG+%),";",3) Q:X="###"  S ^TMP($J,"BDMBUL",%)=X
 Q
 ;;  
 ;;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ;;+     This message is intended to advise you of changes,        +
 ;;+     upgrades or other important RPMS information
 ;;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ;;  
 ;;PCC Diabetes Management System Version 2 patch 1 has recently been installed, and
 ;;includes the following modifications/enhancements:
 ;;   
 ;;1. Various technical programming changes.
 ;;
 ;;2. Locked data entry items in Patient Management with the BDMZEDIT key.
 ;;
 ;;3. Added code set versioning to various routines.
 ;;
 ;;4. Fixed the follow up report when lab results are returned with an abnormal flag.
 ;;
 ;;MAKE SURE YOU ASSIGN THE BDMZEDIT KEY TO USERS WHO NEED TO UPDATE PATIENT RECORDS
 ;;
 ;;For additional information contact your RPMS site manager, Area Office RPMS or
 ;;the HELP DESK.
 ;;
 ;;  
 ;;+++++++++++++++++++++ End of Announcement +++++++++++++++++++++++
 ;;###
 ;
GETRECIP ;
 ;* * * Define key below to identify recipients * * *
 ;
 S CTR=0,BDMKEY="BDMZMENU"
 F  S CTR=$O(^XUSEC(BDMKEY,CTR)) Q:'CTR  S Y=CTR S XMY(Y)=""
 Q
 ;
RENAME ;-- rename sent routines for DM AUDIT 2008 patch
 N BDMX,I
 F BDMI=11,14,15,16,"1P" D
 . S BDMX="ZL BDMD8"_BDMI_" ZS APCLD8"_BDMI
 . X BDMX
 Q
 ;
