APCLP10 ; IHS/CMI/LAB - Routine to create bulletin ; [ 08/23/01 4:32 PM ]
 ;;3.0;IHS PCC REPORTS;**10**;FEB 15, 1997
 ;;
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 Q
 ;
POST ;EP
OPT ;add 2 new options (supplement, report)
 S X=$$ADD^XPDMENU("APCL M MAIN DM MENU","APCL DM2001 AUDIT MENU","DM01",4)
 I 'X W "Attempt to add DM 2001 Audit Menu option failed.." H 3
 NEW X S X=$$ADD^XPDMENU("APCL M MAIN DM MENU","APCL DM PTS 4 MONTHS","DMV")
 I 'X W "Attempt to add DM PTS WITH VALUES option failed." H 3
 NEW X S X=$$ADD^XPDMENU("APCL M DX/PROC COUNT REPORTS","APCL P QA FREQ CPT","FCPT")
 I 'X W "Attempt to add FREQUENCY OF CPT REPORT option failed." H 3
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
 ;;PCC Management Reports Patch 10 has recently been installed.  This patch
 ;;includes the following modifications/enhancements:
 ;;   
 ;;Contains the 2001 DM Audit.
 ;;Contains a new Frequency of CPTs report.
 ;;-DM Audit 2000.  Changes the way lab values are found.  If 2 of the
 ;;same lab are found on the same day, the one with a result is used.
 ;;-DM Audit 2000:  fixes the duration of diabetes cumulative totals.
 ;;-DM Audit 2000:  fixes the TB status totals on the cumulative audit.
 ;;-Adds VGEN items:  3P Bill Number, Exams, Posting Date of Visit
 ;;-Fixes VGEN items:  PHN Items
 ;;-Adds an option to print a list of Patients on the Diabetes Register with their 2 most
 ;;recent HGB A1c, BP, LDL, HDL and Total Cholesterol Values.
 ;;This report is run by Primary Provider and compares a provider to
 ;;the entire register.
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
