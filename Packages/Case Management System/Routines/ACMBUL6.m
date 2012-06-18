ACMBUL6 ; IHS/CMI/TMJ - Routine to create bulletin; [ 05/11/06  3:01 PM ]
 ;;2.0;ACM CASE MANAGEMENT SYSTEM;**6**;JAN 10, 1996
 ;;
 ;;Here's how to make this work:
 ;;
 ;;1. Create your message in subroutine WRITEMSG
 ;;2. Identify recipients in GETRECIP by setting appropriate key
 ;;3. Make changes in SUBJECT and SENDER as desired
 ;;4. Callthis routine on completion of patch or upgrade
 ;
 I '$G(DUZ) W !,"DUZ UNDEFINED OR ZERO.",! Q
 D HOME^%ZIS,DT^DICRW
 ;
 NEW XMSUB,XMDUZ,XMTEXT,XMY,DIFROM
 KILL ^TMP($J,"ACMBUL")
 D WRITEMSG,GETRECIP
 ;Change following lines as desired
SUBJECT S XMSUB="* * * IMPORTANT RPMS INFORMATION * * *"
SENDER S XMDUZ="Case Management System Coordinator"
 S XMTEXT="^TMP($J,""ACMBUL"",",XMY(1)="",XMY(DUZ)=""
 I $E(IOST)="C" W !,"Sending Mailman message to holders of the"_" "_ACMKEY_" "_"security key."
 D ^XMD
 KILL ^TMP($J,"ACMBUL"),ACMKEY
 Q
 ;
WRITEMSG ;
 F %=3:1 S X=$P($T(WRITEMSG+%),";",3) Q:X="###"  S ^TMP($J,"ACMBUL",%)=X
 Q
 ;;  
 ;;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ;;+     This message is intended to advise you of changes,        +
 ;;+     upgrades or other important RPMS information
 ;;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ;;  
 ;;Case Management System patch 6 has recently been installed, and
 ;;includes the following modifications/enhancements:
 ;;   
 ;;1. Various technical programming changes.
 ;;
 ;;2. New Option to install National Pre-Diabetes Register
 ;;
 ;;This option will guide the User through the following
 ;;1 = Installing the IHS National Pre-Diabetes Register"
 ;;if you currently are not using a Pre-Diabetes Register.
 ;;OR
 ;;2 = Converting an existing Case Management based
 ;;Register to the "IHS Pre-Diabetes Register, renaming your
 ;;register and adding Elements: Register Data, Case Review
 ;;Dates, Diagnoses, Complications, Diagnostic Criteria, and
 ;;Risk Factors included in the IHS Standard.
 ;;Answer NO if you have an existing Pre-Diabetes Register.
 ;;Answer YES if you want the IHS National Pre-Diabetes
 ;;Register installed.
 ;;
 ;;3. New General Retrieval Items
 ;;  1.  Initial Entry Date
 ;;  2.  Inactivation Date
 ;;  3.  Risk Factors
 ;;  4.  DX Criteria
 ;;  5.  Intervention
 ;;  6.  Intervention Due Date
 ;;  7.  Intervention Result Date
 ;;  8.  Intervention Results
 ;;  9.  Mlg Address - State
 ;;  10. Mlg Address - Zip
 ;;
 ;;
 ;;4. Fix print template (ACM RECALL LETTERS) when printing Recall Letters.
 ;;5. Added a Screen Message, when installing the new Pre-Diabetes
 ;;Register.  If an existing Register is named IHS-PRE DIABETES the
 ;;User must first change the existing Register name before install. 
 ;;6. Added the Register Creator Name to the Screen Display - Stating
 ;;You are not the Creator of this Register.
 ;;7. Fix code on the Complication Onset Date under General Retrieval Item.
 ;;8. Fixed Master List to single space patient names.
 ;;9. Changed display on Case Summary for *Insurance Information* only if
 ;;patient has insurance and added new heading for Patient Information.
 ;;10. Completed data entry to include new measurement types.
 ;;
 ;;
 ;;For additional information contact your RPMS site manager, Area Office RPMS or
 ;;the HELP DESK.
 ;;
 ;;  
 ;;+++++++++++++++++++++ End of Announcement +++++++++++++++++++++++
 ;;###
 ;
GETRECIP ;
 ;* * * Define key below to identify recipients * * *
 ;
 S CTR=0,ACMKEY="ACMZMENU"
 F  S CTR=$O(^XUSEC(ACMKEY,CTR)) Q:'CTR  S Y=CTR S XMY(Y)=""
 Q
