AMH30P2B ; IHS/BJI/GRL - Routine to create bulletin [ 04/27/04  2:30 PM ]
 ;;3.0;IHS BEHAVIORAL HEALTH;**2**;JAN 27, 2003
 ;;Borrowed from ACHSP1, ACHSP1A
 ;;
 ;;Here's how to make this work:
 ;;
 ;;1. Create your message in subroutine WRITEMSG
 ;;2. Identify recipients in GETRECIP by setting AMHKEY
 ;;3. Make changes in SUBJECT and SENDER as desired
 ;;4. Rename this routine in appropriate namespace and 
 ;;   call on completion of patch or upgrade
 ;
 I '$G(DUZ) W !,"DUZ UNDEFINED OR ZERO.",! Q
 D HOME^%ZIS,DT^DICRW
 ;
 NEW XMSUB,XMDUZ,XMTEXT,XMY,DIFROM
 KILL ^TMP($J,"AMHBUL")
 D WRITEMSG,GETRECIP
 ;Change following lines as desired
SUBJECT S XMSUB="* * * IMPORTANT RPMS INFORMATION * * *"
SENDER S XMDUZ="Cimarron Medical Informatics"
 S XMTEXT="^TMP($J,""AMHBUL"",",XMY(1)="",XMY(DUZ)=""
 I $E(IOST)="C" W !,"Sending Mailman message to holders of the"_" "_AMHKEY_" "_"security key."
 D ^XMD
 KILL ^TMP($J,"AMHBUL"),AMHKEY
 Q
 ;
WRITEMSG ;
 F %=3:1 S X=$P($T(WRITEMSG+%),";",3) Q:X="###"  S ^TMP($J,"AMHBUL",%)=X
 Q
 ;;  
 ;;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ;;+     This message is intended to advise you of changes,        +
 ;;+     upgrades or other important RPMS information
 ;;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ;;+++++++++++++++++++++ end of announcement +++++++++++++++++++++++
 ;;
 ;; - adds a new option under the Manager Utilities to allow backloading
 ;;   of old CDMIS data into the Behavioral Health Module.  This option
 ;;   is locked with a key (AMHZ CDMIS BACKLOAD) and should be run
 ;;   at the discretion of the program after they discontinue using
 ;;   CDMIS and all CDMIS users are using the Behavioral Health Module.
 ;; 
 ;; - Added a SECURITY KEY called AMHZ DELETE VISIT.  The ability
 ;;   to delete a visit, treatment plan or suicide form is not locked.
 ;;   The supervisors and program managers should be allocated this
 ;;   key.  Only those with the key will be able to delete a visit, 
 ;;   treatment plan or suicide form.  
 ;; 
 ;; - added the capability for a site to have an Interactive PCC link.
 ;;   If the site parameter is set to YES the user will be asked to
 ;;   select a PCC visit if one already exists.  This should be used
 ;;   at sites that are checking patients into Mental Health, Social
 ;;   Services or Chemical dependency clinics where the check-in
 ;;   process creates the PCC visit.  Site parameter file and
 ;;   screens were updated. 
 ;; 
 ;; - modified the SEEN report to exclude closed cases (AMHRC1)
 ;; 
 ;; - fixed activity report to correctly tally problems if problem
 ;;   narrative is same or similar 
 ;; 
 ;; - Modified the ACT report to include AGE, GENDER and Clinic
 ;;   type as choices 
 ;; 
 ;; - Added FACE SHEET as an option on PDE. 
 ;; 
 ;; - Added a new report to display time spent in group by patient. 
 ;; 
 ;; - Revised Treatment Plans needing reviewed report to exclude
 ;;   resolved Treatment Plans. 
 ;; 
 ;; - Modified SAN F/U form to combine items 8 through 11. 
 ;; 
 ;; - Added a new site parameter to only allow those entered into the
 ;;   site parameter file to see all visits on the day in SDE/RDE.
 ;;   If the user is not entered into the site parameter they will
 ;;   only see the visits they entered or were a provider on. 
 ;; 
 ;; - Added a display of the problem code narrative to the case screen.
 ;; 
 ;; - changed the patient flag field to be 3 digits.
 ;; 
 ;; - Added capture of IPV/DV screening to all forms.
 ;; - Added display of IPV/DV screening on FULL encounter form.
 ;; - Modified PCC link to pass IPV/DV screening.
 ;; 
 ;; - Provided a new Option to updated Suicide Forms by Date.
 ;; 
 ;; - Added personal Hx to PDE screen.
 ;; 
 ;; - Added a delete case item to the Case update screen.
 ;; 
 ;; - Added a delete intake item to the Intake Update screen.
 ;; - Data Dictionary changes:
 ;;   1.  Added OTHER to set of codes for Program type in 
 ;;   Case Status file
 ;;   2.  Added BRIEF as a Visit Type.
 ;;   3.  Added INFO/REFERRAL to A/SA Type of Contact
 ;; - Changes the export to not error if a community does not
 ;;   have a state, county, community code. 
 ;; - Fixed sporadic undef error in screen refreshing on PDE (AMHLEP2)
 ;; - Removed site parameters items that are not longer used:
 ;;      1.  Full SOAP
 ;;      2.  Default device for export
 ;; - Fixed spelling of barbiturates on suicide form.
 ;; - Fixed spelling of highest on suicide form.
 ;; - Fixed Designated provider report to not generate an undef
 ;;   if OTHER (2) is chosen.
 ;; - Fixed spelling of recurrence on SAN form.
 ;;###
 ;
GETRECIP ;
 ;* * * Define key below to identify recipients * * *
 ;
 S CTR=0,AMHKEY="AMHZMENU"
 F  S CTR=$O(^XUSEC(AMHKEY,CTR)) Q:'CTR  S Y=CTR S XMY(Y)=""
 Q
