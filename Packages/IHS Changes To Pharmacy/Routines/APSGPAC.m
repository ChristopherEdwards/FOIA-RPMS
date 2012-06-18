APSGPAC ;IHS/DSD/ENM - POST UTILITY ; [ 12/28/2001  9:48 AM ]
 ;;3.2;INPATIENT MEDICATIONS;**3**;12/28/01
 W !,"Running Post Routines that will............."
 W !!,"- Create Application Package Use Settings....."
 W !!,"- Create Inpatient Meds V4 Pre-Release Menu....."
 W !!,"- And...Send a Mail Message to all IV Managers....",!
 H 3
 D ^APSGPOST ;Add PSJI MGR Menu Option to IV Manager's menu
 D ^APSGIOU ;Stuff 'IOU' setting for all 'Active' Drugs
 D ^APSGMSG ;Send a Mail Message to all IV Managers
 W !!,"*** I'm Done ***"
 Q
