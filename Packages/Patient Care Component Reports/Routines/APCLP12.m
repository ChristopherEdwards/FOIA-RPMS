APCLP12 ; IHS/CMI/LAB - Routine to create bulletin ; [ 09/16/02 7:37 AM ]
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
 S X=$$ADD^XPDMENU("APCL M MAN RESOURCE ALLOCATION","APCL P PROVIDER PRACTICE DESC","PPDS")
 I 'X W "Attempt to new provider practice description report failed.." H 3
 S X=$$ADD^XPDMENU("APCL M MAN ALL REPORTS","APCL CALIFORNIA STATE REPORT","CSAR")
 I 'X W "Attempt to new california state report report failed.." H 3
 D POST^APCLCART
 D DMADA
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
 ;;PCC Management Reports Patch 12 has recently been installed.  This patch
 ;;includes the following modifications/enhancements:
 ;;   
 ;;This patch contains the following:
 ;;
 ;;- NEW REPORTS:
 ;;  Under Resource Allocation Reports:
 ;;  * PPDS   Provider Practice Description Report
 ;;    This report provides a description of patients served and visits
 ;;    by a particular provider
 ;;  Under PCC Ambulatory Visit Counts
 ;; * CSAR   California State Annual Utilization Report
 ;;    This report was requested by the California Area to satisfy a State
 ;;    report requirement.  The data includes a tally of visits by CPT and 
 ;;    diagnoses which other sites may find useful.
 ;;  
 ;; - New VGEN/PGEN items:
 ;; * Veteran Status Y/N
 ;; * PCC Plus Form?
 ;; * Primary Provider IEN
 ;; * Prim/Sec Prov IEN
 ;; * Visit IEN
 ;; * HRN Record Status
 ;; * HRN Disposition
 ;; * 3rd Party Billed Status
 ;; 
 ;; Report Modifications:
 ;;1. 1A Report:  modified the logic to match the logic used by NPIRS in their
 ;; 1A report, modified the display to be in discipline code order.
 ;;2. List APC-1A Visits Not Exported:  modified definition of workload
 ;; (APC  visit) per new logic.
 ;;3. APC Visit Counts by Provider Discipline, APC Visit Counts by Clinic,
 ;;    APC Visit Counts by Individual Provider, APC Visit Counts by Date
 ;;    Of Visit, APC Visit Counts by Primary Diagnosis (APC CODE), 
 ;;    APC Visit Counts by Location of Service, APC Visit Counts by 
 ;;    APC Major Diagnosis Category:  Modified definition of workload (APC
 ;;Visit) per new logic.
 ;;4. Average Number of APC Visits per Day: Modified definition of
 ;;    workload (APC Visit) per new logic.
 ;;5. Average Number of Visits by Day of  Week and Clinic:  Modified
 ;;    definition of workload (APC Visit) per new logic.
 ;;6. PCC Data Analysis Report: Modified definition of workload
 ;;    (APC Visit) per new logic.
 ;;7. Patients w/no Diagnosis of DM on Problem List:  Added a check
 ;;for inactive or missing chart.
 ;;8. DM Register Pts w/no recorded DM Date of Onset:  Added a check
 ;;for inactive or missing chart.
 ;;9. Operations Summary:  fixed an UNDEF error.
 ;;10. Registered Patients and Visit Count reports under Resource Allocation:
 ;;Modified definition of workload (APC visit) per new logic.
 ;;11. Taxonomy Setup:  Made several fixes to this.  Added a check for 
 ;;An ADA code taxonomy, fixed ADA code taxonomy display.
 ;;12. Dis-continued rounding height to the nearest inch on BMI calculation.
 ;;13. OOPT - Risk for Overweight Prevalance Report:  Added selection of a
 ;;Case Management register as the set of patients to run the report for.
 ;;14. Diabetes Audit:  Added Clinic code A2 as a clinic to trigger that a 
 ;;Diabetic eye exam was done.
 ;;Exam was done.
 ;;15. Frequency of Diagnoses Report:  Added a selection of a patient search
 ;;Template so that the report can be run for a selected set of patients.
 ;;(e.g a template of all veterans created by QMAN).
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
DMADA ;
 S ATXFLG=1
 W !,"Updating APCH ADA Codes Taxonomy..."
 S APCLTX=0 S APCLTX=$O(^ATXAX("B","APCH DM ADA EXAMS",APCLTX))
 I APCLTX G TX1
 S X="APCH DM ADA EXAMS",DIC="^ATXAX(",DIC(0)="L",DIADD=1,DLAYGO=9002226 D ^DIC K DIC,DA,DIADD,DLAYGO,I I Y=-1 W !!,"ERROR IN CREATING APCH DM ADA EXAMS TAXONOMY" Q
 S APCLTX=+Y,$P(^ATXAX(APCLTX,0),U,2)="ADA CODES FOR DM EXAM",$P(^(0),U,5)=DUZ,$P(^(0),U,8)=0,$P(^(0),U,9)=DT,$P(^(0),U,12)=174,$P(^(0),U,13)=0,$P(^(0),U,15)=9999999.31,^ATXAX(APCLTX,21,0)="^9002226.02101A^0^0"
TX1 S APCLTEXT="ADA" F APCLX=1:1:5 S X=$P($T(@APCLTEXT+APCLX),";;",2),DIC="^AUTTADA(",DIC(0)="M" D ^DIC K DIC,DA,DR,DIADD,DLAYGO,DQ,DI,D1,D0 I $P(Y,U)>0 D
 .S Y=+Y Q:$D(^ATXAX(APCLTX,21,"B",Y))  ;this code is already there.
 .S (APCLY,APCLL)=0 F  S APCLY=$O(^ATXAX(APCLTX,21,APCLY)) Q:APCLY'=+APCLY  S APCLL=APCLY
 .S APCLL=APCLL+1,^ATXAX(APCLTX,21,APCLL,0)=Y,$P(^ATXAX(APCLTX,21,APCLL,0),U,2)=Y,$P(^ATXAX(APCLTX,21,0),U,3)=APCLL,$P(^(0),U,4)=APCLL,^ATXAX(APCLTX,21,"AA",Y,Y)="",^ATXAX(APCLTX,21,"B",Y,APCLL)=""
 .Q
 S DA=APCLTX,DIK="^ATXAX(" D IX1^DIK
 K APCLTX,APCLDA,APCLTEXT,ATXFLG
 D ^XBFMK
 Q
 ;
ADA ;
 ;;0120
 ;;0150
 ;;0114
 ;;9320
 ;;9321
 ;;
