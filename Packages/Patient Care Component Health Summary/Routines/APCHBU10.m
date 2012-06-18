APCHBU10 ; IHS/BJI/GRL - routine to create bulletin [ 02/19/03  8:38 AM ]
 ;;2.0;IHS RPMS/PCC Health Summary;**10**;JUN 24, 1997
 ;;
 ;;Here's how to make this work:
 ;;
 ;;1. Create your message in subroutine WRITEMSG
 ;;2. Identify recipients in GETRECIP by setting APCHKEY
 ;;3. Make changes in SUBJECT and SENDER as desired
 ;;4. Rename this routine in appropriate namespace and 
 ;;   call on completion of patch or upgrade
 ;
 I '$G(DUZ) W !,"DUZ UNDEFINED OR ZERO.",! Q
 D HOME^%ZIS,DT^DICRW
 ;
 NEW XMSUB,XMDUZ,XMTEXT,XMY,DIFROM
 KILL ^TMP($J,"APCHBUL")
 D WRITEMSG,GETRECIP
 ;Change following lines as desired
SUBJECT S XMSUB="* * * IMPORTANT RPMS INFORMATION * * *"
SENDER S XMDUZ="Cimarron Medical Informatics"
 S XMTEXT="^TMP($J,""APCHBUL"",",XMY(1)="",XMY(DUZ)=""
 ;I $E(IOST)="C" W !,"Sending Mailman message to holders of the"_" "_APCHKEY_" "_"security key."
 I $E(IOST)="C" W !,"Sending Mailman message to all active RPMS users."
 D ^XMD
 KILL ^TMP($J,"APCHBUL"),APCHKEY
 Q
 ;
WRITEMSG ;
 F %=3:1 S X=$P($T(WRITEMSG+%),";",3) Q:X="###"  S ^TMP($J,"APCHBUL",%)=X
 Q
 ;;  
 ;;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ;;+     This message is intended to advise you of changes,        +
 ;;+     upgrades or other important RPMS information
 ;;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ;;  
 ;;PCC Health Summary patch 10 has recently been installed on this RPMS computer
 ;;
 ;;This patch fixes/modifies the following functionality:
 ;;
 ;; - Added 5 new Asthma Health Maintenance Reminders.
 ;; *** you must have the new Asthma Register package installed
 ;; *** for these to work.  That package should be released shortly.
 ;; - Added a prompt to the Microbiology and Blood Bank components
 ;;  to notify providers to see the Lab package for more details
 ;; - Reordered the lab component to sort by date of test
 ;; - Added site where drug dispensed to all medication components
 ;;   when the drug was dispensed at a site other than the site
 ;;   logged in to.
 ;; - Modified the DM Supplement to look at all registers with the
 ;;   term "DIAB" in their names when searching for Date of Onset
 ;; - Modified the DM Supplement to search for EKG in V RADIOLOGY
 ;;
 ;;--------------------- End of Announcement -----------------------
 ;;###
 ;
GETRECIP ;
 ;* * * Define key below to identify recipients * * *
 ;
 S CTR=0,APCHKEY="APCHZMENU"
 F  S CTR=$O(^XUSEC(APCHKEY,CTR)) Q:'CTR  D
 .I $P($G(^VA(200,CTR,0)),"^",11)]]"" Q
 .I $P($G(^VA(200,CTR,"PS")),U,4)]"" Q  ;inactive date
 .I $P($G(^VA(200,CTR,201)),"^")]"" S Y=CTR S XMY(Y)=""  ;primary menu
 ;
 Q
