APCP20P6 ; IHS/TUCSON/LAB - Routine to create bulletin ; [ 08/18/2003   7:44 AM ]
 ;;2.0;IHS PCC DATA EXTRACTION;**6**;APR 03, 1998
 ;;
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 Q
 ;
PRE ;EP - pre init
 ;delete all entries from rec file
 S APCPX=0 F  S APCPX=$O(^APCPREC(APCPX)) Q:APCPX'=+APCPX  S DA=APCPX,DIK="^APCPREC(" D ^DIK
 ;data will be reloaded with kids install
 Q
POST ;EP
 ;*** REMEMBER TO SEND APCPVSTS GLOBAL AS GLOBAL OR AS KIDS
OPT ;add 2 new options (supplement, report)
 D LAB ;build lab taxonomy
 NEW X
 S X=$$ADD^XPDMENU("APCPMENU","APCP RE-EXPORT DATE RANGE","EDR")
 I 'X W "Attempt to new re-export option failed.." H 3
 S X=$$DELETE^XPDMENU("APCPMENU","APCP RE-EXPORT MENU")
 S X=$$DELETE^XPDMENU("APCP REPORTS MENU","APCP RPT CHA RECORDS")
 ;;Here's how to make this work:
 ;;
 ;;1. Create your message in subroutine WRITEMSG
 ;;2. Identify recipients in GETRECIP by setting APCPKEY
 ;;3. Make changes in SUBJECT and SENDER as desired
 ;;4. Rename this routine in appropriate namespace and 
 ;;   call on completion of patch or upgrade
 ;
 I '$G(DUZ) W !,"DUZ UNDEFINED OR ZERO.",! Q
 D HOME^%ZIS,DT^DICRW
 ;
 NEW XMSUB,XMDUZ,XMTEXT,XMY,DIFROM
 KILL ^TMP($J,"APCPBUL")
 D WRITEMSG,GETRECIP
 ;Change following lines as desired
SUBJECT S XMSUB="* * * IMPORTANT RPMS INFORMATION * * *"
SENDER S XMDUZ="Cimarron Medical Informatics"
 S XMTEXT="^TMP($J,""APCPBUL"",",XMY(1)="",XMY(DUZ)=""
 I $E(IOST)="C" W !,"Sending Mailman message to holders of the"_" "_APCPKEY_" "_"security key."
 D ^XMD
 KILL ^TMP($J,"APCPBUL"),APCPKEY
 Q
 ;
WRITEMSG ;
 F %=3:1 S X=$P($T(WRITEMSG+%),";",3) Q:X="###"  S ^TMP($J,"APCPBUL",%)=X
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
 ;;- APCPDF2 - data fetcher - protects against invalid AA xref entries
 ;;- Operations Summary - removes APC recode display because recode table is out
 ;;  of date.
 ;;- Added the ability to save the results of the Overweight/Obese report
 ;;  to a search template
 ;;- NEW REPORTS:
 ;;  - INPC   Inpatient Discharges/Days by Community
 ;;  - INPS   Inpatient Discharges/Days by SU of Residence
 ;;  - INPT   Inpatient Discharges/Days by Tribe
 ;;  - APCP   List Patients on a Register w/an Appointment
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
 S CTR=0,APCPKEY="APCPZMENU"
 F  S CTR=$O(^XUSEC(APCPKEY,CTR)) Q:'CTR  S Y=CTR S XMY(Y)=""
 Q
LAB ;
 S APCPX="APCP PAP SMEAR TESTS" D PAPLAB1
 S APCPX="APCP PSA TESTS TAX" D PSALAB1
 Q
PAPLAB1 ;
 W !,"Creating ",APCPX," Taxonomy..."
 S APCPDA=$O(^ATXLAB("B",APCPX,0))
 Q:APCPDA  ;taxonomy already exisits
 S X=APCPX,DIC="^ATXLAB(",DIC(0)="L",DIADD=1,DLAYGO=9002228 D ^DIC K DIC,DA,DIADD,DLAYGO,I
 I Y=-1 W !!,"ERROR IN CREATING ",APCPX," TAX" Q
 S APCPTX=+Y,$P(^ATXLAB(APCPTX,0),U,2)=APCPX,$P(^(0),U,5)=DUZ,$P(^(0),U,6)=DT,$P(^(0),U,8)="B",$P(^(0),U,9)=60,^ATXLAB(APCPTX,21,0)="^9002228.02101PA^0^0"
 S APCPX=$O(^LAB(60,"B","PAP SMEAR",0))
 I APCPX S ^ATXLAB(APCPTX,21,1,0)=APCPX,^ATXLAB(APCPTX,21,"B",APCPX,1)="",$P(^ATXLAB(APCPTX,21,0),U,3)=APCPX,$P(^ATXLAB(APCPTX,21,0),U,4)=1
 S DA=APCPTX,DIK="^ATXAX(" D IX1^DIK
 Q
 ;
PSALAB1 ;
 W !,"Creating ",APCPX," Taxonomy..."
 S APCPDA=$O(^ATXLAB("B",APCPX,0))
 Q:APCPDA  ;taxonomy already exisits
 S X=APCPX,DIC="^ATXLAB(",DIC(0)="L",DIADD=1,DLAYGO=9002228 D ^DIC K DIC,DA,DIADD,DLAYGO,I
 I Y=-1 W !!,"ERROR IN CREATING ",APCPX," TAX" Q
 S APCPTX=+Y,$P(^ATXLAB(APCPTX,0),U,2)=APCPX,$P(^(0),U,5)=DUZ,$P(^(0),U,6)=DT,$P(^(0),U,8)="B",$P(^(0),U,9)=60,^ATXLAB(APCPTX,21,0)="^9002228.02101PA^0^0"
 S APCPX=$O(^LAB(60,"B","PSA",0))
 I APCPX S ^ATXLAB(APCPTX,21,1,0)=APCPX,^ATXLAB(APCPTX,21,"B",APCPX,1)="",$P(^ATXLAB(APCPTX,21,0),U,3)=APCPX,$P(^ATXLAB(APCPTX,21,0),U,4)=1
 S DA=APCPTX,DIK="^ATXAX(" D IX1^DIK
 Q
 ;
