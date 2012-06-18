APCLP11 ; IHS/CMI/LAB - Routine to create bulletin ; [ 03/20/02 12:32 PM ]
 ;;3.0;IHS PCC REPORTS;**10**;FEB 15, 1997
 ;;
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 Q
 ;
POST ;EP
 ;*** REMEMBER TO SEND APCLVSTS GLOBAL AS GLOBAL OR AS KIDS
OPT ;add 2 new options (supplement, report)
 NEW X
 S X=$$ADD^XPDMENU("APCL M MAN ALL REPORTS","APCL P ALLV INCOMPLETE","INCV")
 I 'X W "Attempt to new incomplete visit report failed.." H 3
 S X=$$ADD^XPDMENU("APCL M MAIN DM MENU","APCL DM REG APPT CLN","APCL")
 I 'X W "Attempt to new appt list of reg pats failed.." H 3
 S X=$$ADD^XPDMENU("APCL M MAN PATIENT LISTINGS","APCL UPLOAD PATS TO ST","UPLP")
 I 'X W "Attempt to new upload pats option failed.." H 3
 ;S X=$$ADD^XPDMENU("APCL M MAN ALL REPORTS","APCL PROVIDER PROFILE","PP")
 ;I 'X W "Attempt to new provider profile report failed.." H 3
 S X=$$ADD^XPDMENU("APCL MENU PHN REPORTS","APCL PHN TIME & SER BY PROV CR","TSCR")
 I 'X W "Attempt to new phn report failed.." H 3
 S X=$$ADD^XPDMENU("APCL M MAIN DM MENU","APCL DM REG APPT HS","HSRG")
 I 'X W "Attempt to add health summary for dm reg pts failed.." H 3
 NEW X S X=$$ADD^XPDMENU("APCL M MAN RESOURCE ALLOCATION","APCL P RES INPT BY COMM","INPC")
 I 'X W "Attempt to add Inpatient by community option failed." H 3
 NEW X S X=$$ADD^XPDMENU("APCL M MAN RESOURCE ALLOCATION","APCL P RES INPT BY TRIBE","INPT")
 I 'X W "Attempt to add Inpatient by tribe option failed." H 3
 NEW X S X=$$ADD^XPDMENU("APCL M MAN RESOURCE ALLOCATION","APCL P RES INPT BY SU","INPS")
 I 'X W "Attempt to add Inpatient by su option failed." H 3
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
 ;;PCC Management Reports Patch 11 has recently been installed.  This patch
 ;;includes the following modifications/enhancements:
 ;;   
 ;;Prevents an Undefined error in various reports if Provider entry
 ;;is missing a discipline code.
 ;;Modifies slightly how BMI is calculated to match other applications
 ;;- Prevents an undef in several reports if provider narrative is blank
 ;;- fixes a problem with activity time report in file 200 converted sites
 ;;- fixed date disply on Calender Year First/Revisit report
 ;;- Adds a check for cpt code 92012 for eye exam in the 2001 audit
 ;;- Modifies the DM Diet Education portion of the 2001 audit to more accurately
 ;;  determine if education was provided by an RD
 ;;- Modifies the 2001 DM Audit to look at Staged Diabetes Managemenent Health
 ;;- Modifies the 2001 DM Audit to look at Diabetes Self Monitoring Health
 ;;- Modifies verbage on BMI reports.
 ;;  factors.
 ;;- Modifies lab lookup on 2001 audit to ignore tests with result COMMENT
 ;;- APCLDF2 - data fetcher - protects against invalid AA xref entries
 ;;- Operations Summary - removes APC recode display because recode table is out
 ;;  of date.
 ;;- Added the ability to save the results of the Overweight/Obese report
 ;;  to a search template
 ;;- NEW REPORTS:
 ;;  - INPC   Inpatient Discharges/Days by Community
 ;;  - INPS   Inpatient Discharges/Days by SU of Residence
 ;;  - INPT   Inpatient Discharges/Days by Tribe
 ;;  - APCL   List Patients on a Register w/an Appointment
 ;;  - HSPrint Health Summary of DM patients w/Appointment
 ;;  - TSCR   Time and Services by Provider for chart reviews
 ;;  - INCV   Listing of Incomplete Lab, Rx or Radiology Visits
 ;;  - UPLP   Upload Patients from text file to search template
 ;;- NEW VGEN/PGEN items
 ;;  - Medicare Part B
 ;;  - Problem List DX (Any)
 ;;  - Problem List DX (Active)
 ;;  - Problem List DX (Inactive)
 ;;  - Hx of Surgery
 ;;  - Most recent Tobacco HF
 ;;  - Most recent TB HF
 ;;  - Most recent SDM HF
 ;;  - Most recent Alcohol HF
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
