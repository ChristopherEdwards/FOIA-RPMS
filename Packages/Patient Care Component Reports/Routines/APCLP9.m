APCLP9 ; IHS/CMI/LAB - Routine to create bulletin ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;;
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 Q
 ;
POST ;EP
CPTTAX ;install new cpt taxonomies
 D ^APCLP9A ;   DM AUDIT FLU CPTS
 D ^APCLP9B ;   DM AUDIT MAMMOGRAM CPTS
 D ^APCLP9C ;   DM AUDIT PAP CPTS
OPT ;add 2 new options (supplement, report)
 NEW X S X=$$ADD^XPDMENU("APCL M MAN PATIENT LISTINGS","APCL P ELDER CARE 4","ELNH")
 I 'X W "Attempt to add Elder Care Report 4 option failed." H 3
 S X=$$ADD^XPDMENU("APCL M MAIN DM MENU","APCLDMSP","DPCS")
 I 'X W "Attempt to add DM 2000 Audit Menu option failed.." H 3
 ;*********SEND OUT ATXCHK
 ;;Here's how to make this work:
 ;;
 ;;1. Create your message in subroutine WRITEMSG
 ;;2. Identify recipients in GETRECIP by setting APCLKEY
 ;;3. Make changes in SUBJECT and SENDER as desired
 ;;4. Rename this routine in appropriate namespace and 
 ;;   call on completion of patch or upgrade
 ;
 I '$G(DUZ) W !,"DUZ UNDEFINED OR ZERO.",! Q
 D HOME^%ZIS,DT^DICRW
 ;
 NEW XMSUB,XMDUZ,XMTEXT,XMY,DIFROM
 KILL ^TMP($J,"APCLBUL")
 D WRITEMSG,GETRECIP
 ;Change following lines as desired
SUBJECT S XMSUB="* * * IMPORTANT RPMS INFORMATION * * *"
SENDER S XMDUZ="Cimarron Medical Informatics"
 S XMTEXT="^TMP($J,""APCLBUL"",",XMY(1)="",XMY(DUZ)=""
 I $E(IOST)="C" W !,"Sending Mailman message to holders of the"_" "_APCLKEY_" "_"security key."
 D ^XMD
 KILL ^TMP($J,"APCLBUL"),APCLKEY
 Q
 ;
WRITEMSG ;
 F %=3:1 S X=$P($T(WRITEMSG+%),";",3) Q:X="###"  S ^TMP($J,"APCLBUL",%)=X
 Q
 ;;  
 ;;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ;;+     This message is intended to advise you of changes,        +
 ;;+     upgrades or other important RPMS information
 ;;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ;;  
 ;;PCC Management Reports Patch 9 has recently been installed.  This patch
 ;;includes the following modifications/enhancements:
 ;;   
 ;;-DM Audit 2000.  Fixes the EPI export record.
 ;;-Adds logic to check for CPT codes for Flu, Pap and Mammogram
 ;;-Adds VGEN items:  Microbiology Result, Microbiology Organism, and Culture
 ;;-Adds VGEN item: Health Factor Quantity/Score
 ;;-Adds an option to print a Diabetes Care Summary w/o printing
 ;;a full health summary.
 ;;-Fixes a potential error in the injury report.
 ;;-Fixes a potential error in the active user report.
 ;;-Modifies the drug taxonomy update system to display synonyms
 ;;-Modifies the template creation from VGEN/PGEN to bypass fileman security
 ;;
 ;;For additional information contact your RPMS site manager, Area Office RPMS
 ;;support staff or any of the following Cimarron staff members:
 ;;
 ;;Dorothy Russell *  Gary Lawless    *  Bill Mason       *  Lori Butcher
 ;;(520)-743-3275     (715)-358-3763     (520)-615-0689      (520)-577-2146
 ;;  
 ;;+++++++++++++++++++++ end of announcement +++++++++++++++++++++++
 ;;###
 ;
GETRECIP ;
 ;* * * Define key below to identify recipients * * *
 ;
 S CTR=0,APCLKEY="APCLZMENU"
 F  S CTR=$O(^XUSEC(APCLKEY,CTR)) Q:'CTR  S Y=CTR S XMY(Y)=""
 Q
