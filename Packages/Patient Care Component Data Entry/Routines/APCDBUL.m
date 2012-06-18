APCDBUL ; IHS/CMI/LAB - Routine to create bulletin ;
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
 NEW XMSUB,XMDUZ,XMTEXT,XMY
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
 ;;PCC Data Entry Patch 3 has been installed.  This patch includes the following
 ;;modifications/enchancements:
 ;;-  Adds a new data entry option called UPDATE DIABETES PATIENT DATA.  This
 ;;   option can be used when providers are attempting to update historical data
 ;;   related to diabetes care.
 ;;-  Adds a new data entry option called PRINT A PCC VISIT IN ENCOUNTER FORM
 ;;   FORMAT.
 ;;   This option can be used to print a visit after it has been completely
 ;;   entered.  This similiar is to displaying a visit, but the format will look like
 ;;   a PCC Encounter Form.
 ;;-  New mnemonics:
 ;;   CC   - to pick up and record the Chief Complaint
 ;;   AOP  - similar to OP but this will prompt for anesthesia information
 ;;   NMI  - similar to the REF (Refusals) mnemonic.  This one should be 
 ;;          used if the provider indicates that the refusal is because the item
 ;;          is not medically indicated.
 ;;-  The RAD mnemonic will now prompt for CPT Modifiers.  These are not
 ;;   required.
 ;;-  The RAD mnemonic will now prompt for ordering provider.  This is not
 ;;   a required data element.
 ;;-  If an IHS VCN is entered on a visit, it will now display when a visit
 ;;   is being selected. 
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
