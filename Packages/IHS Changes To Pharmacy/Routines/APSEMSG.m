APSEMSG ;IHS/DSD/ENM - OUTPATIENT NEW DRUG ED MSG ; [ 06/11/2001  1:28 PM ]
 ;;6.1;IHS PHARMACY MODIFICATIONS;**1**;01/02/01
MSG ;SETUP AND SEND EMAIL MSG
 W !,"Now I will send a mail message to all holders of the pharmacy 'PSORPH' KEY.",!
 D XMSET
 D TEXT
 D MSG1
 D ZAAP
 Q
XMSET ;SET MAIL VARIABLES
 K XMY S XMSUB="Outpatient Pharmacy Patient Drug Education Update",XMDUZ="OUTPATIENT PHARMACY DEVELOPER"
 D RPH
 Q
MSG1 D ^XMD K APSPMSG
 Q
TEXT S APSPMSG(1,0)="To:   Outpatient Pharmacy (OP) Supervisors"
 S APSPMSG(2,0)=" "
 S APSPMSG(3,0)="      OUTPATIENT PHARMACY PATIENT DRUG EDUCATION DATABASE (PDED) ENHANCEMENT"
 S APSPMSG(4,0)=" "
 S APSPMSG(5,0)=" "
 S APSPMSG(6,0)="The purpose of this message is to notify you that Outpatient PDED has been"
 S APSPMSG(7,0)="released and installed in your computer. This release includes the new Pharmacy"
 S APSPMSG(8,0)="Patient Drug Education enhancements.  This message was sent to Pharmacy"
 S APSPMSG(9,0)="Supervisors only (holding the PSORPH Security Key).  Please forward this"
 S APSPMSG(10,0)="message to your staff."
 S APSPMSG(11,0)="------------------------------------------------------------------------------ "
 S APSPMSG(12,0)="About the Pharmacy Patient Drug Education Process......."
 S APSPMSG(13,0)=""
 S APSPMSG(14,0)="Enhancements to the Outpatient Pharmacy package have been made to enable the"
 S APSPMSG(15,0)="printing of drug monograph sheets.  The monograph sheets can be printed for"
 S APSPMSG(16,0)="a specific drug, for a specific patient's medications, or while filling new"
 S APSPMSG(17,0)="prescriptions for a patient.  For easy access all three print methods can be"
 S APSPMSG(18,0)="executed from the main RX menu."
 S APSPMSG(19,0)="  "
 S APSPMSG(20,0)="To access the monograph sheets for a specific drug, the option"
 S APSPMSG(21,0)="DPMI  PRINT DRUG MEDIATION SHEETS can be executed from the"
 S APSPMSG(22,0)="RX main menu.  Within this option, you will be prompted for the specific"
 S APSPMSG(23,0)="drug that you would like to print a monograph sheet for, and if not previously"
 S APSPMSG(24,0)="selected, the device the sheet should print on."
 S APSPMSG(25,0)=""
 S APSPMSG(26,0)="To access the monograph sheets for prescriptions issued to a specific patient,"
 S APSPMSG(27,0)="the option PMI  PRINT PATIENT MEDICATION SHEETS can be executed"
 S APSPMSG(28,0)="from the RX main menu as well.  This option will prompt for a patient and then"
 S APSPMSG(29,0)="will supply a list of all prescriptions the patient has.  You will then be"
 S APSPMSG(30,0)="prompted for which prescriptions to print a monograph sheet for, or by entering"
 S APSPMSG(31,0)="ALL you can obtain monograph sheets for all the patient's prescribed"
 S APSPMSG(32,0)="medications."
 S APSPMSG(33,0)=" "
 S APSPMSG(34,0)="In addition, drug monograph sheets can be requested while entering new"
 S APSPMSG(35,0)="prescriptions for a patient.  Within the NERX  New Prescription Entry option"
 S APSPMSG(36,0)="(accessed from the Rx main menu) the final prompt that appears when the"
 S APSPMSG(37,0)="prescription entry is complete has been altered to provide a monograph print"
 S APSPMSG(38,0)="feature.  The final prompt appears as follows:"
 S APSPMSG(39,0)="Print/Queue/Med Sheet/Refill/CAncel/Summary/B=Sum+Cpro/"
 S APSPMSG(40,0)="and by selecting Med Sheet, both the label and Med Sheet (monograph)"
 S APSPMSG(41,0)="will be printed."
 S APSPMSG(42,0)=""
 S APSPMSG(43,0)="To simplify the print process, you can pre-select a device on which the"
 S APSPMSG(44,0)="monograph sheets should print on by responding Yes to the"
 S APSPMSG(45,0)="Pre-Select PMI/Chronic Med Profile Device? (Y/N)? prompt and specifying"
 S APSPMSG(46,0)="a printer to use at the Select PMI/Chronic Med Profile PRINTER: prompt."
 S APSPMSG(47,0)="These prompts will appear the first time you access the main Outpatient"
 S APSPMSG(48,0)="Pharmacy Manager menu each day.  Please make note that the printer selected"
 S APSPMSG(49,0)="at these prompts will be used for both the printing of the chronic med profile"
 S APSPMSG(50,0)="and the monograph sheets."
 S APSPMSG(51,0)=" "
 S APSPMSG(52,0)="NOTICE!   NOTICE!   NOTICE!   NOTICE!   NOTICE!   NOTICE!  NOTICE!   "
 S APSPMSG(53,0)=" "
 S APSPMSG(54,0)="The information contained in the monographs comes from the Patient Drug"
 S APSPMSG(55,0)="Education Database (PDED) and is confidential and proprietary information"
 S APSPMSG(56,0)="of First DataBank, Inc. and may be used only by a licensee under the terms and"
 S APSPMSG(57,0)="conditions of the License.  Any unauthorized use such as copying or editing"
 S APSPMSG(58,0)="the monographs contained in this file are prohibited! All authorized sites will"
 S APSPMSG(59,0)="receive a monthly update of the First DataBank PDED files containing Patient"
 S APSPMSG(60,0)="Medication Information (PMI)/Monograph Sheets.  PMI/Monograph Sheets"
 S APSPMSG(61,0)="can be printed and given to patients with their medications."
 S APSPMSG(62,0)=""
 S APSPMSG(63,0)="First DataBank Disclaimer"
 S APSPMSG(64,0)="The information contained in the First DataBank database is intended to"
 S APSPMSG(65,0)="supplement the knowledge of physicians, pharmacists, and other healthcare"
 S APSPMSG(66,0)="professionals regarding drug therapy problems and patient counseling"
 S APSPMSG(67,0)="information.  This information is advisory only and is not intended to replace"
 S APSPMSG(68,0)="sound clinical judgment in the delivery of healthcare services. You are advised"
 S APSPMSG(69,0)="to review the definitions, functionality, and limitations of each"
 S APSPMSG(70,0)="First DataBank database."
 S APSPMSG(71,0)=""
 S APSPMSG(72,0)="First DataBank, Inc. disclaims all warranties, whether expressed or implied,"
 S APSPMSG(73,0)="including any warranty as to the quality, accuracy, and suitability of this"
 S APSPMSG(74,0)="information for any purpose."
 S APSPMSG(75,0)=" "
 S APSPMSG(76,0)="*UPDATE ADVISORY*     *UPDATE ADVISORY*     *UPDATE ADVISORY*   "
 S APSPMSG(77,0)=""
 S APSPMSG(78,0)="First DataBank offers updates on a monthly basis for the Patient Drug"
 S APSPMSG(79,0)="Education Database(PDED).  To insure that you are issuing the most current"
 S APSPMSG(80,0)="information available on the monograph sheets, it is vitally important that"
 S APSPMSG(81,0)="updates to this package are kept current at all times.  A warning/reminder"
 S APSPMSG(82,0)="message will be displayed upon entry into the main pharmacy menu two"
 S APSPMSG(83,0)="weeks prior to the PDED's expiration date, again one week before"
 S APSPMSG(84,0)="expiration, and daily after expiration, reminding you that an update"
 S APSPMSG(85,0)="to the PDED needs to be done.  When you receive this warning/reminder,"
 S APSPMSG(86,0)="please contact your site manager and schedule an update as soon as"
 S APSPMSG(87,0)="possible."
 S APSPMSG(88,0)=" "
 S APSPMSG(89,0)="Please take note that a general monograph sheet will print for all drugs"
 S APSPMSG(90,0)="whose NDC value is not current or correct. To reduce occurrence of this, please"
 S APSPMSG(91,0)="make sure you are running with the most recent release of the AWP update"
 S APSPMSG(92,0)="(patch 11 or higher) and that your NDCs are kept up to date at all times."
 S XMTEXT="APSPMSG(",%H=$H D YX^%DTC
 Q
RPH ;GET HOLDERS OF 'PSORPH' (PHARMACIST)
 ;S XMY("MOORE,EDGAR")="",XMY("JARAMILLO,LISA")="" Q  ;TEMPORARY, REMOVE AFTER TESTING
 ;S XMY("JARAMILLO,LISA")="" Q  ;temporary, remark out after testing
 S J=0
 F J=0:0 S J=$O(^XUSEC("PSORPH",J)) Q:'J  S APSPNAME=$P($G(^VA(200,J,0)),"^"),XMY(APSPNAME)=""
 ;F J=0:0 S J=$O(^XUSEC("PSOGLORES",J)) Q:'J  S APSPNAME=$P($G(^VA(200,J,0)),"^"),XMY(APSPNAME)="" ;IHS/OKCAO/POC 6/22/98 CHANGE SECURITY KEY
 Q
ZAAP ;KILL ALL VARIABLES ON EXIT
 K APSLNAME,APSP,APSPDG,APSPZ,XMDUZ,J,X,XMSUB,XMTEXT
 Q
