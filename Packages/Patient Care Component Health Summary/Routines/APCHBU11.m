APCHBU11 ; IHS/BJI/GRL - routine to create bulletin [ 03/15/04  12:52 PM ]
 ;;2.0;IHS RPMS/PCC Health Summary;**11**;JUN 24, 1997
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
 ;;PCC Health Summary patch 11 has recently been installed on this RPMS computer
 ;;
 ;;
 ;;  - total rewrite of how you create or modify a new health summary
 ;;    type.  It is now in list manager. 
 ;;  -  Put a check in for $D of LR node to protect against undefined
 ;;    error when obtaining Blood type from Lab Blood Bank
 ;;    section (APCHS1)
 ;;  -  Added Notice of Privacy Practices to Demographic section
 ;;    (APCHS1)
 ;;  -  Added Objectives Met and Behavior Code (Goal set, etc.) to all
 ;;    3 patient education components. (APCHS10)
 ;;  - Added a list of all instances of dental ADA codes 1310, 1320
 ;;    and 1330 to the patient education components.  Three components
 ;;    were updated. (APCHS10)
 ;;  - added new v8.0 Immunization package call to immunization
 ;;    component (APCHS2)
 ;;  - Added exam result to Exam component.  (APCHS3C)
 ;;  - Added event visits to the outpatient sections for event
 ;;    visits that have a POV.  This is so the visits passed to PCC
 ;;    from RCIS are displayed. (APCHS2B,APCHS2C,APCHS2F,APCHS2H)
 ;;  - Added the provider initial display as a part of the outpatient
 ;;    section of the health summary as an option.  You must turn
 ;;    on Provider initial display in all summary types by using the 
 ;;    option to modify a summary type(APCHS2B,APCHS2C,APCHS2F,APCHS2H)
 ;;  - Added 989.82 to the list of allergies. (APCHS40)
 ;;  - Modified Allergy components to display NO KNOWN ALLERGIES when
 ;;    documented as such in the Adverse Reaction Tracking package.
 ;;  - In the medication components, if the drug was given outside
 ;;    of the current facility (as defined by DUZ(2)) then the phrase
 ;;    "Prescribed at" is displayed with the name of the facility
 ;;    where prescribed.  (APCHS7*)
 ;;  - Added the following 3 new Medication components:
 ;;    1.  MEDS  ;;  - CHRONIC & ACUTE W/ ISSUE HISTORY (APCHS78)
 ;;    2.  MEDS - CHONIC BY NAME (sorts by drug name) (APCHS77)
 ;;    3.  MEDS - CURRENT BY NAME (sorts by drug name) (APCHS77)
 ;;  - Added Diagnostic code display to Radiology component (APCHS3C)
 ;;  - added refusals entered via the immunization package to the
 ;;    refusal section (APCHS5)
 ;;  - added kill of DIR variable in APCHS9B1
 ;;  - added $G in APCHS9B3 due to missing file 6 nodes
 ;;  - Modified how mammograms were being found in V Radiology due
 ;;    due error in RAMIS "D" index.
 ;;  - Added V77.1 as a hit on diabetes screening reminder (APCHSM02)
 ;;  - updated the CVX codes and the cpt codes used for TD- Adult
 ;;    health maintenance reminder. (APCHSMU1,APCHSMU2,APCHSM03)
 ;;  - updated the CVX codes and the cpt codes used for Pneumovax
 ;;    health maintenance reminder. (APCHSMU1,APCHSMU2,APCHSM03)
 ;;  - updated the CVX codes and the cpt codes used for Influenza
 ;;    health maintenance reminder. (APCHSMU1,APCHSMU2,APCHSM03)
 ;;  - added ada code 9991, if found, as a "refusal" for dental
 ;;    exam on the diabetes supplement. (APCHS9B6)
 ;;
 ;;  - NEW HEALTH MAINTENANCE REMINDERS:
 ;;    NOTE:  in order to appear on the health summary these must be 
 ;;    added to the appropriate health summary types. 
 ;;
 ;;    1.  ADULT MMR 1 dose version (APCHSM08)
 ;;    2.  ADULT MMR 2 dose version (APCHSM08)
 ;;    3.  Ischemic Heart Disease: IHD- LDL Screening (APCHSM06)
 ;;    4.  Ischemic Heart Disease: IHD- Elevated LDL (APCHSM06)
 ;;    5.  Rubella Vaccination Reminder (APCHSM08)
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
