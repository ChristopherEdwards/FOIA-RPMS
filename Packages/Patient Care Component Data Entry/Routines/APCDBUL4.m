APCDBUL4 ; IHS/CMI/LAB - Routine to create bulletin ;
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
 ;;PCC Data Entry Patch 4 has been installed.  This patch includes the following
 ;;modifications/enchancements:
 ;; - Changes the way patient education is entered using the PED
 ;;   mnemonic.  The user will now be able to enter a topic in the old
 ;;   way by choosing T at the first prompt (this is the way it works
 ;;   currently) or by choosing D and entering a diagnosis and a category
 ;;   of education.
 ;; - modifies the immunization display when using the IM mnemonic
 ;; - checks for the required admitting diagnosis in the VRR
 ;;   for hospitalizations
 ;; - fixes the form print for operations
 ;; - adds a new data entry option for entering data for a cohort of patients
 ;; - adds a new mnemonic for entering provider driven overrides
 ;;   of health maintenance reminders
 ;; - add mnemonics ECO2 and ECO3 for entering a second and third
 ;;   E-code for a POV
 ;; - adds the Place of Injury prompt to ECOD mnemonic
 ;; - adds Level of Decision Making field to PHN mnemonic
 ;; - adds BP to DM Update screen
 ;;
 ;;
 ;;+++++++++++++++++++++ end of announcement +++++++++++++++++++++++
 ;;###
 ;
GETRECIP ;
 ;* * * Define key below to identify recipients * * *
 ;
 S CTR=0,APCDKEY="APCDZMENU"
 F  S CTR=$O(^XUSEC(APCDKEY,CTR)) Q:'CTR  S Y=CTR S XMY(Y)=""
 Q
