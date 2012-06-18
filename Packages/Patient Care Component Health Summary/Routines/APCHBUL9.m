APCHBUL9 ; IHS/BJI/GRL - routine to create bulletin [ 07/21/02  7:25 PM ]
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
 ;;PCC Health Summary patch 9 has recently been installed on this RPMS computer
 ;;
 ;;This patch fixes/modifies the following functionality:
 ;;
 ;; - Added MICROBIOLOGY component.
 ;; - Added BLOOD BANK component.
 ;; - Added a PATIENT ED - MOST RECENT BY TOPIC component to display
 ;;    patient education by topic name.
 ;; - Added a new Medication component to display chronic meds only 
 ;;   but does not display any meds that have been D/C'ed.
 ;; - Modifies the demographic section to display Blood Type/Rh
 ;;   from the Blood bank section of lab if available.  - APCHS1
 ;; - Modifies the logic for supplement display to display a
 ;;   supplement if the patient has had a diagnoses within the 
 ;;   evoking codes list during the past year.  The visit must be
 ;;   to a primary care provider.  Previously, only the problem list
 ;;   was scanned for a diagnoses with the evoking codes list.
 ;; - DM Supplement:
 ;;    - Made EP2^APCHS9B1 a published entry point
 ;;    - If no DM problem on Problem list display ***NONE RECORDED***
 ;;      to prompt provider to add DM to problem list.
 ;;    - If patient is not on a Diabetes Register, prompt such
 ;;      on the the supplement.
 ;;    - Display date of last Chest Xray if Known Positive PPD or TB.
 ;; - Fixed TD to look at immunization tetanus toxoid
 ;; - Modifies the logic for flowsheet display to display a flowsheet
 ;;   if the patient has had a diagnoses within the evoking codes
 ;;   list during the past year.  The visit must be to a primary care
 ;;   provider.  Previously, only the problem list was scanned for a 
 ;;   diagnoses with the evoking codes list.
 ;; - Kills ^TMP where appropriate after the lab display (APCHS3A)
 ;; - Adds NKDA and NO KNOWN DRUG ALLERGIES as narratives that
 ;;   evoke the No Known Allergies phrase in the allergy component
 ;; - Prints Medicaid Plan Name in the demographic section.  (APCHS5A)
 ;; - Modifies 2 med components to pick up free text name if available
 ;;   from outside pharmacy system links.  (APCHS73, APCHS74)
 ;; - Fixed 1 space errors after quits (APCHS79)
 ;; - Modifies several routines that were using 365.25 with
 ;;   $$FMADD^XLFDT to use 365 as the function call does not support
 ;;   partial days.
 ;; - Fixes the PATIENT ED - MOST RECENT component to observe time frame and max
 ;;   occurrences parameters.
 ;;
 ;;--------------------- End of Announcement -----------------------
 ;;###
 ;
GETRECIP ;
 ;* * * Define key below to identify recipients * * *
 ;
 S CTR=0,APCHKEY="PROVIDER"
 F  S CTR=$O(^XUSEC(APCHKEY,CTR)) Q:'CTR  D
 .I $P($G(^VA(200,CTR,0)),"^",11)]]"" Q
 .I $P($G(^VA(200,CTR,"PS")),U,4)]"" Q  ;inactive date
 .I $P($G(^VA(200,CTR,201)),"^")]"" S Y=CTR S XMY(Y)=""  ;primary menu
 ;
 Q
