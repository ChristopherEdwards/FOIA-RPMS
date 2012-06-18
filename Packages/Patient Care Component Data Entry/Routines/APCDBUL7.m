APCDBUL7 ; IHS/CMI/LAB - Routine to create bulletin ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;;Borrowed from ACHSP1, ACHSP1A
 ;;
 ;;Here's how to make this work:
 ;;
 ;;1. Create your message in subroutine WRITEMSG
 ;;2. Identify recipients in GETRECIP by setting APCDKEY
 ;;3. Make changes in SUBJECT and SENDER as desired
 ;;4. Rename this routine in appropriate namespace and 
 ;;   call on completion of patch or upgrade
 ;
 I '$G(DUZ) W !,"DUZ UNDEFINED OR ZERO.",! Q
 D HOME^%ZIS,DT^DICRW
 ;
 NEW XMSUB,XMDUZ,XMTEXT,XMY,DIFROM
 KILL ^TMP($J,"APCDBUL")
 D WRITEMSG,GETRECIP
 ;Change following lines as desired
SUBJECT S XMSUB="* * * IMPORTANT RPMS INFORMATION * * *"
SENDER S XMDUZ="Cimarron Medical Informatics"
 S XMTEXT="^TMP($J,""APCDBUL"",",XMY(1)="",XMY(DUZ)=""
 I $E(IOST)="C" W !,"Sending Mailman message to holders of the"_" "_APCDKEY_" "_"security key."
 D ^XMD
 KILL ^TMP($J,"APCDBUL"),APCDKEY
 Q
 ;
WRITEMSG ;
 F %=3:1 S X=$P($T(WRITEMSG+%),";",3) Q:X="###"  S ^TMP($J,"APCDBUL",%)=X
 Q
 ;;  
 ;;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ;;+     This message is intended to advise you of changes,        +
 ;;+     upgrades or other important RPMS information
 ;;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ;;  
 ;;PCC Data Entry Patch 7 has been installed.  This patch includes the following:
 ;;modifications/enchancements:
 ;;
 ;; - add field OBJECTIVES to the PED mnemonic and re-orders the prompts
 ;; - adds creation of VA VISIT ID for Electronic Health Record Project
 ;; - Updated PCC form print with New fields for education
 ;; - added Hospital Location to visit lookup screen, if it exists
 ;; - added new visit display option which limits each lab entry to selected fields
 ;; - added entry of refusals to the DM Update option
 ;; - added a new option to complete 'orphan' blood bank visits
 ;; - added a new option to complete 'orphan' microbiology visits
 ;; - added option to the Supervisor menu for updating PCC links
 ;;    (You must be given a special key for this option)
 ;; - Added 3 report that lists all allergies on the problem list for a group of pts
 ;; - New Mnemonics:
 ;;          ALG - entry of allergies into Allergy tracking (not Problem list)
 ;;            (you must have a special key to do this)
 ;;          HHF - Historical Health Factor entry
 ;;          UAS - Unable to Screen Refusal type
 ;;          HADA - historical ada codes
 ;;          ADA - ada codes (from outside your facility)
 ;;+++++++++++++++++++++ end of announcement +++++++++++++++++++++++
 ;;###
 ;
GETRECIP ;
 ;* * * Define key below to identify recipients * * *
 ;
 S CTR=0,APCDKEY="APCDZMENU"
 F  S CTR=$O(^XUSEC(APCDKEY,CTR)) Q:'CTR  S Y=CTR S XMY(Y)=""
 Q
