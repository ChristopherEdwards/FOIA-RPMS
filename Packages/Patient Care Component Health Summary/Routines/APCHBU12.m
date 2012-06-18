APCHBU12 ; IHS/BJI/GRL - routine to create bulletin [ 01/14/05  10:36 AM ]
 ;;2.0;IHS RPMS/PCC Health Summary;**12**;JUN 24, 1997
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
 ;;PCC Health Summary patch 12 has recently been installed on this RPMS computer
 ;;
 ;;
 ;;-   Modified the In-Hospital section of the health summary
 ;;    to not display In-Hospital visits with no purpose
 ;;    of visit.  Displaying these takes up space is meaningless
 ;;    without a purpose of visit. (APCHS2B)
 ;;
 ;;-   Modified the EXAM section to display the provider's name
 ;;    if the provider is recorded with the exam as the provider
 ;;    performing the exam.  Data entry will soon be prompted for
 ;;    provider with the EX mnemonic, if the provider initials the
 ;;    exam when it is documented they can enter the provider's name
 ;;    to link that provider to the exam.  This is being done for the 
 ;;    INTIMATE PARTNER VIOLENCE SCREENING exam. (APCHS3C)
 ;;
 ;;-   Added a new component called RADIOLOGY EXAMS.  This component
 ;;    differs from the existing RADIOLOGY-MOST RECENT component 
 ;;    in that it lists all Radiology exams in the date range specified
 ;;    by the summary type, not just the most recent.  This component
 ;;    was built for use on the PATIENT MERGE (COMPLETE) summary
 ;;    type so that a user who is reviewing all of a patient's data
 ;;    can see all radiology exams.  This component may not be 
 ;;    appropriate for the adult regular summary type. (APCHS3C)
 ;;
 ;;-   Diabetes Supplement:
 ;;    1. Modified the supplement to display the last DIABETES
 ;;    SELF MONITORING health factor if no strips were
 ;;    found as being dispensed through pharmacy. (APCHS9B2)
 ;;    2. Added the last ESTIMATED GFR value under the CREATININE
 ;;    Value. (APCHS9B3)
 ;;    3. Modified the Tobacco Use display to the last TOBACCO
 ;;    Health factor on file. (APCHS9B6, APCHSMU)
 ;;    4. Modified the PAP logic to match the GPRA logic for finding
 ;;    a Pap Smear. (APCHS9B2,APCHS9B4)
 ;;    5. Added LOINC code lookups to selected lab test items.
 ;;
 ;;-   Added a new PRE DIABETES CARE SUMMARY as a supplement type.  
 ;;    The user must put this supplement type on their health summary
 ;;    Types in order to have it displayed.  This new supplement, 
 ;;    designed by the diabetes providers will display if the patient
 ;;    has had a pre diabetes diagnoses (e.g. IGT) and does not have
 ;;    diabetes on the problem list and has not had a diabetes dx
 ;;    in the past year.  Two lab taxonomies must be reviewed and
 ;;    populated for this supplement:
 ;;        DM AUDIT GLUCOSE TESTS TAX
 ;;        DM AUDIT 2 HR GTT TAX
 ;;
 ;;-   Added the ability to automatically switch from the health
 ;;    summary type defined by the clinic in scheduling to the
 ;;    diabetes summary type if the patient has diabetes on the
 ;;    problem list or has had a diagnosis of Diabetes on a visit
 ;;    with a primary care provider.  In order to make this happen,
 ;;    it the site decides this is desired you must update the 
 ;;    Health Summary Site parameters using option HEALTH SUMMARY
 ;;    SITE PARAMETER SETUP which is on the Health Summary Maintenance
 ;;    and the Build Health Summary menu options.  When you
 ;;    choose this option you must answer YES to auto switch
 ;;    summary types and then put the name of your Diabetes
 ;;    summary type into the subsequent field.
 ;;
 ;;- Modified the allergy sections of the health summary to work
 ;;  with both the new and old versions of allergy tracking.
 ;;
 ;;-  added a new component for scheduled encounters that excludes
 ;;  chart requests and walk ins.
 ;;
 ;; - added an new health maintenance reminder for IPV/DV screening
 ;;   the criteria is to prompt for Due every year for females 15
 ;;   and over.
 ;;   If you would like to see this prompt on your summary types
 ;;   it must be added to the surveillance items section of the health
 ;;   summary type.
 ;;
 ;; - added 2 medication reorder documents as supplements to the health
 ;;   summary.  These documents are used as a means to re-order
 ;;   medications
 ;;   for a patient.  Listed on this document are all current
 ;;   medications (defined as twice duration or 60 days) and all
 ;;   chronic medications (defined as those flagged as chronic in
 ;;   the pharmacy package) that were dispensed in the last year.
 ;;   To use this document you must have it added to the summary
 ;;   type in the supplement section.
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
