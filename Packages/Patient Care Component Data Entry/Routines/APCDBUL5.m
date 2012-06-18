APCDBUL5 ; IHS/CMI/LAB - Routine to create bulletin ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;;Borrowed from ACHSP1, ACHSP1A
 ;;
 ;;Here's how to make this work:
 ;;
 ;;1. Create your message in subroutine WRITEMSG
 ;;2. Identify recipients in GETRECIP by setting APCDKEY
 ;;3. Make changes in SUBJECT and SENDER as desired
 ;;4. Rename this routine in appropriate namespace and 
 ;;   call on completion of patch or upgrade
 ;
 I '$G(DUZ) W !,"DUZ UNDEFINED OR ZERO.",! Q
 D HOME^%ZIS,DT^DICRW
 ;
 NEW XMSUB,XMDUZ,XMTEXT,XMY,DIFROM
 KILL ^TMP($J,"APCDBUL")
 D WRITEMSG,GETRECIP
 ;Change following lines as desired
SUBJECT S XMSUB="* * * IMPORTANT RPMS INFORMATION * * *"
SENDER S XMDUZ="Cimarron Medical Informatics"
 S XMTEXT="^TMP($J,""APCDBUL"",",XMY(1)="",XMY(DUZ)=""
 I $E(IOST)="C" W !,"Sending Mailman message to holders of the"_" "_APCDKEY_" "_"security key."
 D ^XMD
 KILL ^TMP($J,"APCDBUL"),APCDKEY
 Q
 ;
WRITEMSG ;
 F %=3:1 S X=$P($T(WRITEMSG+%),";",3) Q:X="###"  S ^TMP($J,"APCDBUL",%)=X
 Q
 ;;  
 ;;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ;;+     This message is intended to advise you of changes,        +
 ;;+     upgrades or other important RPMS information
 ;;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ;;  
 ;;PCC Data Entry Patch 5 AND 6 have been installed.  This patch includes the following
 ;;modifications/enchancements:
 ;;
 ;; - New Option:  Merge 2 visits on different dates. APCDVMDD
 ;; - New Option:  Visit Display in Non-Browser mode. APCDVDP
 ;; - New Option:  Complete Orphaned Radiology Visits. APCDKRV
 ;; - New Option:  Complete Orphaned Pharmacy Visits.  APCDKPV
 ;; - New Option:  Re-print Group Forms.
 ;; - New Mnemonics:  AST - capture asthma related data.
 ;;               HAST - capture historical asthma related data.
 ;;               COC - coded chief complaint.  Capture Chief
 ;;                     Complaint in icd diagnosis format.
 ;;               PCF - documents that this pcc visit was created
 ;;                        By PCC+.
 ;;               PF - Peak Flow measurement type.
 ;;              O2 - O2 Saturation measurement type.
 ;;               PA - Pain measurement type.
 ;; - 3m Coder:  modification made to support the interface with the 3M coder.  (APCD3M, APCD3ME)
 ;; - stuff visit unique ID in visit record.  (APCDALV)
 ;; - Sentinel Surveillance link from V Lab added.  (APCDALVR)
 ;; - Prevent Undef in several places where a patient pointer may be null.  (APCDPRB, APCDDVD1
 ;; - Allow lookup of inactive patients in visit display and visit list in a date range options.  (APCDVLST, APCDDISP)
 ;; - Set a data entry date in the visit file for the data warehouse export.  (APCDEA2, APCDEAP, APCDEGP0, APCDEHI2, APCDPE2, APCDDMUP)
 ;; - DM update option:  add exam results, add education provider (APCDDMU1, ACPDDMU2)
 ;; - Allow the PPPV report in the Visit Review Report to be run for just pharmacy, radiology, lab or immunization visits. (APCDDVD, APCDR00)
 ;; - Print CPT codes on the PCC form print.  (APCDEF, APCDEFC, APCDEFP, APCDEFP1)
 ;; - Allow re-printing of group forms.
 ;; - Have user okay input before proceeding with group form entry.  (APCDEGP, APCDEPG0,APCDEGP1)
 ;; - Print VCN in WHAT mnemonic. (APCDEWHA)
 ;; - Print operator's name on Listing of Uncoded Diagnoses and Procedures Reports.  (APCDFPPV)
 ;; - Fixed HRN display on QA Coding reports. (APCDFQAP)
 ;; - Modified Complete Orphaned Reports and Purging options to allow
 ;;     Pharmacy and Radiology in addition to the existing Complete Orphaned
 ;;     Lab options.  (APCDKLV, APCDKLVR, APCDKLVP)
 ;; - Fixed formatting on immunization display.  (APCDLIM)
 ;; - Modified problem list entry option to use ^TMP rather than a local
 ;;    array due to PGMOV errors.  (APCDPL, APCDPL1, APCDPL2)
 ;; - Fixed ECODE error in VRR.  (APCDR07)
 ;; - Modified APCDVLK to use the AA index rather than the AC to speed
 ;;   up visit lookup.  (APCDVLK)
 ;; - Set .37 field of visit (merged to) for billing in VISIT 
 ;;   MERGE.  (APCDVMRG)
 ;; - Modified several input templates for Fileman 22.
 ;; - Added V BLOOD BANK to items to be moved from one visit
 ;;    to another. (APCDKUL)
 ;; - Added GOAL STATUS to patient education
 ;;+++++++++++++++++++++ end of announcement +++++++++++++++++++++++
 ;;###
 ;
GETRECIP ;
 ;* * * Define key below to identify recipients * * *
 ;
 S CTR=0,APCDKEY="APCDZMENU"
 F  S CTR=$O(^XUSEC(APCDKEY,CTR)) Q:'CTR  S Y=CTR S XMY(Y)=""
 Q
