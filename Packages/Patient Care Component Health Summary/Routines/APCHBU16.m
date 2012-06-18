APCHBU16 ; IHS/BJI/GRL - routine to create bulletin [ 01/14/05  10:36 AM ]
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
 ;;PCC Health Summary patch 16 has recently been installed on this RPMS computer
 ;;
 ;; 1.  added new ICD9 codes 995.2* to the list of codes for allergies
 ;; 
 ;; 2.  Patient Wellness Handout
 ;;     - added logic to allow the patient wellness handout to be
 ;;       printed from EHR
 ;; 
 ;; 3.  added office phone to the demographic component of the health
 ;;     summary
 ;;
 ;; 4.  added site parameters for both flowsheets and supplements
 ;;     to allow the user to define the # of diagnoses in what # of years
 ;;     to use to determine when a flowsheet or supplement should be 
 ;;     printed.  For example, if the site wants the Diabetes Supplement
 ;;     to print only if a patient has at least 2 diagnoses of diabetes
 ;;     in the past 5 years they would enter 2 and 5 into these new
 ;;     parameters.  Currently these items print if there is one diagnosis
 ;;     in the past year.  These site parameters can be updated using 
 ;;     the option: HSSP   Update Health Summary Site parameters
 ;;
 ;; 5.  Comments have been added as an option in the lab components.
 ;;     added a new parameter that can be set when a health summary type
 ;;     is created or edited to print the comments entered for a lab
 ;;     test with that test when it displays in the most recent lab
 ;;     components
 ;;   
 ;; 6.  modified the display of family history
 ;;
 ;; 7.  modified the reproductive factors section to support the new
 ;;     additions to the WH package when the WH package is available
 ;;
 ;; 8.  Health maintenance items:
 ;;     Updated ICD diagnosis, icd procedure, cpt and exam code lookup
 ;;     logic to conform to the CRS logic and to accomodate for the
 ;;     inactivation of many of the IHS Exam codes:
 ;;    - ADULT MMR 1-DOSE VERSION and ADULT MMR 2-DOSE VERSION - added
 ;;      diagnosis code V06.4, CPT codes 90707, 90710 and procedure
 ;;      code 99.48 to logic for MMR
 ;;    - Asthma - Flu Shot - added CPT 90656 to logic for flu shot
 ;;    - Breast Exam - added V76.10, V76.12, V76.19 procedure 89.36
 ;;      and CPT G0101 added refusal of exam 06, procedure 89.36
 ;;      and CPT G0101.
 ;;    - Cholesterol - added cpt 82465
 ;;    - Colorectal Ca Scrn-FOBT - added cpt codes 82274, G0107, 89205
 ;;    - Colorectal Ca Scrn-SCOPE/XRAY - matched GPRA logic
 ;;    - Sigmoidoscopy looks for procedure 45.24, 45.42, cpts 45330-45345,
 ;;      G0104
 ;;    - Colonoscopy looks forV Procedure 45.22, 45.23, 45.25, 45.43;
 ;;      V POV 76.51; CPT 44388-44394,44397, 45355, 45378-45387,
 ;;      45391, 45392, 45325 (old), G0105, G0121
 ;;    - Barium Enema - CPT or VRad: 74280, G0106, G0120
 ;;    - Hearing Test - added CPT codes 92552, 92555, 92556, DX: V72.11,
 ;;      V72.19
 ;;    - Influenza - added CPT 90656 to flu shot logic
 ;;    - Mammogram - added CPT 77055-77059, G0202, G0204, G0206
 ;;    - Pap Smear - added dx codes V72.31, V72.32, V76.47, V76.49, 795.06
 ;;    - Pelvic Exam - added CPT codes G0101, dx code V72.31, V72.32
 ;;    - Rectal Exam - added V76.4, V76.44, procedure 89.34, CPT G0102,
 ;;      S0601, S0605
 ;;    - Visual Acuity Exam - added V72.0, procedures 95.09, 95.05, CPTs
 ;;      99172, 99173
 ;;
 ;;9.  Added a new component called "REFUSALS - MOST RECENT OF EACH"
 ;;
 ;;10.  Added refusals to each component that refusals can be documented
 ;;     for.  The following components were updated, the refusals will display
 ;;     at the end of the component:
 ;;     - Diagnostic Procedure
 ;;     - Examinations - Most recent
 ;;     - History of Minor Surgery
 ;;     - History of Surgery
 ;;     - Immunizations
 ;;     - Lab Data - Most recent by Date
 ;;     - Laboratory Data - Most Recent
 ;;     - Measurement Panels
 ;;     - Meds - All
 ;;     - Meds - All w/#iss & alt name
 ;;
 ;;11.  Added 3 new CPT components to display CPT codes entered into the V CPT file
 ;;     1   CPT - ALL BY CPT CODE
 ;;     2   CPT - ALL BY DATE
 ;;     3   CPT - MOST RECENT OF EACH
 ;;     the user can apply date limits on each of the above components
 ;;
 ;;12.  Added CPT code documented procedures to the History of Surgery
 ;;     and History of Minor Surgery components of the health summary.
 ;;     Since there are many CPT codes and it is difficult to try and determine
 ;;     at a national level what CPT codes are considered "major" and which "minor"
 ;;     the determination of which CPT codes display in each component is made
 ;;     by a taxonomy of CPT codes.  A site can modify this taxonomy using 2 new
 ;;     options on the Health Summary Maintenance menu:
 ;;   
 ;;     IPT    Update the Minor Procedures CPT Taxonomy
 ;;     MPT    Update the Major Procedures CPT Taxonomy
 ;;
 ;;     The taxonomies are distributed with the following code ranges but they
 ;;     can be modified by the site to remove or add cpt code ranges.
 ;;
 ;;     Major Procedures taxonomy:  1)  19000-69990
 ;;                                 2)  93501-93581
 ;;                                 3)  97597-97602
 ;;
 ;;     Minor Procedures Taxonomy:  1)  10000-17999
 ;;
 ;;13.  Added new Health Maintenance reminder for Fall Risk Assessment.
 ;;     Yearly for ages 65 and older.
 ;;
 ;;14.  Added health maintenance reminder using ANMC logic for EPSDT
 ;;     screening.  Uses CPT codes to determine if screening has been
 ;;     done.
 ;;
 ;;15.  Created a published entry point that an application can call to get
 ;;     the printed value of the health maintenance reminders 3 columns of 
 ;;     data.  For example, if the mammogram reminder for patient X displays
 ;;     as this:
 ;;                        LAST        NEXT
 ;;    MAMMOGRAM          02/13/07  Undetermined (by NO DATE)
 ;;                                  (per Women's Health system)
 ;;
 ;;     then the call S X=$$GVHMR^APCHSMU(dfn,ien of reminder) will return in X
 ;;     X="MAMMOGRAM^3070213^02/13/07^Undetermined (by NO DATE) (per Women's Health system)"
 ;;     where piece one is column 1 (label), piece 2 is the internal fileman form
 ;;     of the date in the "last" column, piece 3 is the external value of the
 ;;     "LAST" column and piece 4 is the value of the 3rd column.
 ;;     If a reminder typically produces several lines of reminders (e.g.
 ;;     immunizations due) the various lines will be in "|" pieces of the
 ;;     output string (e.g. VARICELLA^^^Due|MMR^2060102^02/02/06^Due")
 ;;    
 ;; 16. Modified medication components MEDS - ALL W/#ISS & ALT NAME and
 ;;     MEDS - ALL WITH # ISSUED to no longer separate by chronic and Other
 ;;     medications, the components are sorted by fill date.  Added
 ;;     an indication of whether the drug dispensed was a controlled
 ;;     substance.
 ;;
 ;; 17. Add a new supplement:  CHRONIC MEDICATION REORDER SHORT FORM
 ;;
 ;; 18. Modified the 5 medicaton reorder supplements to allow the user
 ;;     to define how far back in time to go when displaying drugs.
 ;;     The user must indicate a value such as 90D or 1Y or 6M when
 ;;     adding one of these supplements to the Supplement Panel of
 ;;     a health summary type.  Default is 1 year.
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
