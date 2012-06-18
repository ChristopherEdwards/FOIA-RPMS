ACRFUFMD ;IHS/OIRM/DSD/AEF - DRIVER TO CORE OPEN DOCUMENTS MATCH FOR UFMS [ 05/21/2007   9:44 AM ]
 ;;2.1;ADMIN RESOURCE MGMT SYSTEM;**22**;NOV 05, 2001
 ;LOOP THROUGH CORE OPEN DOCUMENT FILE AND FIND MATCH IN ARMS
 ;New routine ACR*2.1*22 UFMS
 ;
EN ;EP; 
 N I,ACRX
 W @IOF
 F I=1:1 S ACRX=$P($T(DESC+I),";",3) Q:ACRX["$$END"  D
 .W !,ACRX
 .I $Y>(IOSL-6) D
 ..K ACROUT
 ..D PAUSE^ACRFWARN
 ..W @IOF
 .Q:$D(ACROUT)
 Q:$D(ACROUT)
 S DIR(0)="Y"
 S DIR("A")="Do you want to continue and generate the reports"
 S DIR("B")="NO"
 D ^DIR
 Q:'Y=1
 ;
 S ACRX="Please be patient while the files are created."
 D BMES^XPDUTL(ACRX)
 D EN^ACRFUFMZ
 Q
 ; *********************************************
 ;
DESC ;----- ROUTINE DESCRIPTION
 ;;
 ;;This routine loops through the imported CORE Open Documents file entries and
 ;;  attempts to match the CORE document number with ARMS documents in the FMS
 ;;  Document, FMS Document History Record and the 1166 Approvals for Payment files
 ;;  and sets various sub-files depending on the type of match. The sub-files can
 ;;  be uploaded into Excel spreadsheet reports and are located in the ARMS default
 ;;  directory where the ECS files are found (generally /usr/spool/afsdata).
 ;;
 ;;Contract Health ("CHS"), GovTrip ("GTRIP"), Payroll ("PAY") and Grant ("GR")
 ;;  documents are not found in ARMS. The documents are listed in separate reports.
 ;;
 ;;When a document is found, the routine matches the CAN, Fiscal Year, and
 ;;  Object Class Code supplied by CORE.
 ;;
 ;;When a match is found, the routine creates additional sub-files: 
 ;; "ACRDOC" contains ARMS document data with Vendor information
 ;; "NOVNDR" contains ARMS document data for obligations without a Vendor
 ;; "TR" contains outstanding ARMS Travel documents including those without
 ;;       a match to an ARMS document
 ;; "VNDR" contains an unique listing of all Vendors found in the matches
 ;; "ERR" contains every document that has a Vendor with errors found in the
 ;;       IHS Vendor file
 ;; "NOHIT" contains CORE documents that could not be matched in any category
 ;; "NOMATCH" contains documents that were found in ARMS, but did not match
 ;;       the criteria
 ;; "ITEMS" contains the obligation, payment, receiving report and invoice
 ;;       information on the line item
 ;; "CEIN" contains ARMS Vendor numbers that do not match the CORE Vendor
 ;; "TOTALS" contains the total number of documents in each report
 ;;
 ;;$$END
 ;
 ; ************************************************
AUDIT ;EP; SEARCH FOR VENDORS WITH ERROR AND FIX IF POSSIBLE
 ;
 K ^ACRZ("VEINCK")
 S (CORP,INDV,ACR,ERR)=0
 S ACRNODUP=1                               ;SKIP DUPLICATE CHECK
 F  S ACR=$O(^AUTTVNDR(ACR)) Q:'ACR  D
 .I $$IDATE^ACRFUFMU(ACR) Q
 .S ACRERR=""
 .S OLD0=$G(^AUTTVNDR(ACR,0))
 .S OLD11=$G(^AUTTVNDR(ACR,11))
 .D NAMCHK^ACRFUFMU(ACR)
 .D DUNSCHK^ACRFUFMU(ACR)
 .D EINCHK^ACRFUFMU(ACR)
 .D SFX2
 .D BANK^ACRFUFMU(ACR)
 .S NEW0=$G(^AUTTVNDR(ACR,0))
 .S NEW11=$G(^AUTTVNDR(ACR,11))
DIAG .I $D(^AUTTVNDR(DT)) D
 ..W !,$G(^AUTTVNDR(DT,0))
 .I OLD0'=NEW0 W !,ACR,?8,NEW0,!?20,ACRERR
 .I OLD11'=NEW11 W !,ACR,?8,NEW11,!?20,ACRERR
 Q
 ; *********************************
SFX2 ;
 S ACRSFX=$$SFX^ACRFUFMU(ACR)
 Q:$L(ACRSFX)=2
 N HIT,I
 S HIT=0
 I $L(ACREIN)=10 D  Q
 .I ACRSFX="" F I="00":"01" D  Q:HIT
 ..I $L(I)=1 S I="0"_I
 ..I '$D(^AUTTVNDR("E",ACREIN_I)) D  Q
 ...S DIE="^AUTTVNDR("
 ...S DA=X
 ...S DR="1102////"_I
 ...D DIE^ACRFDIC
 ...S HIT=1
 S ^ACRZ("VEINCK","ERR",ACR)=^AUTTVNDR(ACR,0)_U_ACREIN_ACRSFX_": "_ACRERR
 Q
CLEAN ;FIX
 W !,ACR,?15,^AUTTVNDR(ACR,0)
 S DIE="^AUTTVNDR("
 S DA=ACR
 S DR=".05////@"                        ;REMOVE INACTIVE DATE
 D DIE^ACRFDIC
 W !?15,^AUTTVNDR(ACR,0)
 Q
