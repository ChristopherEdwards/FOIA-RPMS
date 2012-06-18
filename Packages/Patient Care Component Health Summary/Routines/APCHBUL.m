APCHBUL ; IHS/BJI/GRL - routine to create bulletin [ 03/14/01  8:37 PM ]
 ;;2.0;IHS RPMS/PCC Health Summary;**8**;JUN 24, 1997
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
 ;;PCC Health Summary patch 8 has recently been installed on this RPMS computer
 ;;
 ;;This patch fixes/modifies the following functionality:
 ;;
 ;;-Fixes PAP display on Diabetes Supplement.
 ;;-Fixes lab results to not display "^^" on Diabetes Supplement.
 ;;-Fixes potential <UNDEF> in Medicare display.
 ;;-Expands the lookup for PAP, Influenza Immunization and Mammograms on Diabetes
 ;;Supplement to include CPT codes.
 ;;-Modifies the PPD prompt on Diabetes Supplement to state "Last Documented PPD".
 ;;-Modifies the prompt to state "Known Positive PPD or Hx of TB" on supplement.
 ;;-Adds the date of the last Mammogram from PCC to Diabetes Supplement.
 ;;
 ;;-Upgrades all Health Maintenance Remainders.  Significant changes have been
 ;;made to the PCC Health Maintenance Reminders including:
 ;;
 ;;--Removal of DM reminders from health summary.  All DM related Health Reminders
 ;;are provided for on the Diabetes Patient Care Summary (DM Supplement)
 ;;--Closer reminder correlation to recommendations of U.S. Preventive Services
 ;;Task Force (USPSTF), the Advisory Committee on Immunization Practices and other
 ;;appropriate groups.
 ;;--Creation of new Health Maintenance Reminder (HM) option on the Health Summa
 ;;ry Maintenance menu which allows sites to customize the Health Reminders to 
 ;;meet locally determined standards.
 ;;
 ;;A complete review of the changes to the Health Maintenance Reminders was
 ;;provided to your Area Office with this patch and was recently published in the
 ;;IHS Provider.
 ;;
 ;;* * * It is imperative that all active health summaries be reviewed to assure
 ;;that desired Health Maintenance Reminders are present.  Use the new option in 
 ;;the Health Summary Maintenance menu "HM Health Maintenance Reminders..." to 
 ;;print the reminder protocols and health summaries to which the reminders are
 ;;attached. * * *
 ;;
 ;;--------------------- End of Announcement -----------------------
 ;;###
 ;
GETRECIP ;
 ;* * * Define key below to identify recipients * * *
 ;
 ;S CTR=0,APCHKEY="APCHZMENU"
 ;F  S CTR=$O(^XUSEC(APCHKEY,CTR)) Q:'CTR  S Y=CTR S XMY(Y)=""
 ;
 ;Send bulletin to all active users
 S CTR=0
 F  S CTR=$O(^VA(200,CTR)) Q:CTR'=+CTR  D
 .I $P($G(^VA(200,CTR,0)),"^",11)]]"" Q  ;inactive date
 .I $P($G(^VA(200,CTR,201)),"^")]"" S Y=CTR S XMY(Y)=""  ;primary menu
 Q
