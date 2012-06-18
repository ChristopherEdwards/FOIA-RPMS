ACMBUL7 ; cmi/anch/maw - Routine to create bulletin for patch 7; [ 05/11/06  3:01 PM ]
 ;;2.0;ACM CASE MANAGEMENT SYSTEM;**7**;JAN 10, 1996
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
 KILL ^TMP($J,"ACMBUL")
 D WRITEMSG,GETRECIP
 ;Change following lines as desired
SUBJECT S XMSUB="* * * IMPORTANT RPMS INFORMATION * * *"
SENDER S XMDUZ="Case Management System Coordinator"
 S XMTEXT="^TMP($J,""ACMBUL"",",XMY(1)="",XMY(DUZ)=""
 I $E(IOST)="C" W !,"Sending Mailman message to holders of the"_" "_ACMKEY_" "_"security key."
 D ^XMD
 KILL ^TMP($J,"ACMBUL"),ACMKEY
 Q
 ;
WRITEMSG ;
 F %=3:1 S X=$P($T(WRITEMSG+%),";",3) Q:X="###"  S ^TMP($J,"ACMBUL",%)=X
 Q
 ;;  
 ;;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ;;+     This message is intended to advise you of changes,        +
 ;;+     upgrades or other important RPMS information
 ;;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ;;  
 ;;Case Management System patch 7 has recently been installed, and
 ;;includes the following modifications/enhancements:
 ;;   
 ;;1. Various technical programming fixes.
 ;;
 ;;  Changes and corrections for this patch:
 ;;
 ;;  a) New General Retrieval Items
 ;;  b) Fix date range prompt on general retrieval when select next review date
 ;;  c) Fix patient lookup, if user selects chart that isn't found it was looking at last 4 of SSN
 ;;
 ;;  d) New option to display register creator
 ;;  e) Make registers read only for certain users by addding security key ACMZ EDIT
 ;;
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
 S CTR=0,ACMKEY="ACMZMENU"
 F  S CTR=$O(^XUSEC(ACMKEY,CTR)) Q:'CTR  S Y=CTR S XMY(Y)=""
 Q
