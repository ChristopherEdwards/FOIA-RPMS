APCHBU14 ; IHS/BJI/GRL - routine to create bulletin [ 01/14/05  10:36 AM ]
 ;;2.0;IHS RPMS/PCC Health Summary;**14**;JUN 24, 1997
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
 ;;PCC Health Summary patch 14 has recently been installed on this RPMS computer
 ;;
 ;;    - adds LOINC code lookups to all lab lookups in both
 ;;      the Diabetes Supplement and the Health Maintenance
 ;;      reminders
 ;;
 ;;    - adds a New patient medical handout.  This new
 ;;      option is called "Patient Medical Handouts" (APCHPSUM) and can
 ;;      be found on the APCHMENU option.  This option is standalone
 ;;      and can be added to a users menu.  This provides the ability
 ;;      to print out a handout sheet to give to the patient.  There
 ;;      are 2 handouts, one is a pre-visit handout to be given to
 ;;      the patient before they see the provider and the second 
 ;;      one is a handout to be given to the patient after their
 ;;      visit is over.  The pre-visit handout can be printed at
 ;;      check-in through scheduling by setting the parameter in the
 ;;      PCC MASTER CONTROL file called "PROMPT FOR PT HANDOUT AT CHKIN"
 ;;      to yes.  For more information about these handouts please see
 ;;      the supplemental document distributed with this patch.
 ;;
 ;;    - fixed the DM Supplement to not display refusals for Mammogram
 ;;      if the patient had a mammogram after the refusal date.
 ;;
 ;;    - On the medication component called "MEDS - ALL W/#ISS & ALT NAME"
 ;;      we have added the ability to display the ordering provider's name
 ;;      if the site opts to do so.  To turn this on you must set the field
 ;;      called "DISPLAY PROV INITIALS W/MEDS" to YES in the health summary
 ;;      type file for the type of summary on which you want the ordering
 ;;      provider to display.
 ;;      
 ;;    - added a check for refusals to the pneumovax health maintenance
 ;;      reminder.
 ;; 
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
