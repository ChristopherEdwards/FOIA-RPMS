APCHBU15 ; IHS/BJI/GRL - routine to create bulletin [ 01/14/05  10:36 AM ]
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
 ;;PCC Health Summary patch 15 has recently been installed on this RPMS computer
 ;;
 ;;    - adds an option to Print a Patient Medical Handout
 ;;      This option (APCHSPMH) is already attached to APCHMENU,
 ;;      however, since not all clinical staff will have that option
 ;;      on their menus, APCHSPMH may also be added to a user's
 ;;      Secondary Menu or attached to any appropriate RPMS
 ;;      application menu.
 ;;
 ;;    - Changes the term "Prescribed at" to "Dispensed at" on the medication
 ;;      components.
 ;;      
 ;;    - changes the terminology for the IPV/DV Screening exam in the
 ;;      exam section.
 ;;      
 ;;    - adds the result of the Domestic Violence Screening back
 ;;      to the exam section
 ;;      
 ;;    - adds a new Depression Screening Health maintenance reminder
 ;;      this reminder must be added to each health summary type on
 ;;      which you wish this reminder to be displayed 
 ;;      
 ;;    - adds 2 new supplements which are medication reorder documents
 ;;      that display ONLY Chronic medications     
 ;;    
 ;;    - adds the education topic mnemonic to the education display
 ;;    
 ;;    - fixes the HCT/Hgb reminder to correctly lookup the taxonomy
 ;;    
 ;;    - Fixes the lab components to display reference ranges even if units
 ;;      is blank
 ;;      
 ;;    - Adds a check in the Behavioral Health package and adds a check
 ;;       for refusals to the Depression Screening on the DM Supplement
 ;;       
 ;;    - Adds the last A/C Ratio test result to the DM Supplement
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
