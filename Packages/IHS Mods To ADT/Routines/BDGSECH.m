BDGSECH ; IHS/ANMC/LJF - INTRO HELP FOR OPTIONS ; 
 ;;5.3;PIMS;**1005,1008,1009**;MAY 28, 2004
 ;IHS/OIT/LJF 01/20/2006 PATCH 1005 Added PAU subroutine
 ;            09/06/2007 PATCH 1008 Added EAR subroutine
 ;
DUA ;EP; intro text for Display User Access to Patient Records
 NEW BDGX
 S BDGX(1)="For holders of the DG SECURITY OFFICER key, use this option"
 S BDGX(2)="to display who accessed a particular patient record over"
 S BDGX(3)="a given date range.  You can view just one user's access or"
 S BDGX(4)="that of all users who accessed the record."
 D DISPLAY(4)
 Q
 ;
EAR ;EP; intro text for Enter/Edit Access Restrictions
 NEW BDGX
 S BDGX(1)="Use this option to restrict a user from accessing specific"
 S BDGX(2)="patient records.  Restrictions can be lifted, either for a"
 S BDGX(3)="specific period of time or permanently.  This option is to"
 S BDGX(4)="to be used when a patient requests that particular staff or"
 S BDGX(5)="providers are not to view his/her record at all."
 D DISPLAY(5)
 Q
EPL ;EP; intro text for Enter/Edit Patient Security Level
 NEW BDGX
 S BDGX(1)="For holders of the DG SENSITIVITY key, use this option to"
 S BDGX(2)="assign a security level to a patient. A patient can be"
 S BDGX(3)="either Sensitive (access tracked) or Non-Sensitive (access"
 S BDGX(4)="no longer tracked unless all patients tracked at facility)."
 S BDGX(5)="If the security level for a patient changes from sensitive"
 S BDGX(6)="to non-sensitive, a bulletin is sent to your site's mail"
 S BDGX(7)="group listed as ""Sensitivity Removed Group"" under the"
 S BDGX(8)="security parameters."
 D DISPLAY(8)
 Q
 ;
LSP ;EP; intro text for List Sensitive Patients
 NEW BDGX
 S BDGX(1)="Use this option to list all patients marked as sensitive"
 S BDGX(2)="in the DG SECURITY LOG file.  You can then change their"
 S BDGX(3)="security level or display who accessed each record.  You"
 S BDGX(4)="cannot add new patients to the list here. Instead use the"
 S BDGX(5)="Enter/Edit option."
 D DISPLAY(5),PAUSE^BDGF
 Q
 ;
 ;IHS/OIT/LJF 01/20/2006 PATCH 1005 added subroutine below
PAU ;EP; intro text for DIsplay All Patients Accessed by a User
 NEW BDGX
 S BDGX(1)="Use this option to view all patients a particular user"
 S BDGX(2)="accessed within a date range.  The list may be sorted"
 S BDGX(3)="by date, alphabetically by patient name or by the option"
 S BDGX(4)="accessed.  Report lists patient's sensitivity level, if"
 S BDGX(5)="known, at time of access."
 D DISPLAY(5)
 Q
 ;
PLOG ;EP; intro text for Purge Access Log entries
 NEW BDGX
 S BDGX(1)="Use this option to purge the access log for a select"
 S BDGX(2)="patient or for all patients within a date range.  Any"
 S BDGX(3)="access made to a sensitive record must be kept at least"
 S BDGX(4)="30 days."
 D DISPLAY(4)
 Q
 ;
PPAT ;EP; intro text for Purge Non-sensitive patients from file
 NEW BDGX
 S BDGX(1)="Use this option to purge patients from the DG SECURITY LOG"
 S BDGX(2)="file if the patient's security level is non-sensitive."
 D DISPLAY(2)
 Q
 ;
USP ;EP; intro text for Update Security Parameters option
 NEW BDGX
 S BDGX(1)="Use this option to update such parameters as ""Days to"
 S BDGX(2)="Maintain Sensitivity"" and ""Restrict Patient Record"
 S BDGX(3)="Access"".  You can assign mail groups to bulletins and"
 S BDGX(4)="add members to the mail groups.  A listing of all users"
 S BDGX(5)="with access to this menu and sensitive records is available."
 D DISPLAY(5)
 Q
 ;
DISPLAY(N) ; -- display array with N lines
 S BDGX(1,"F")="!!!?5"
 F I=2:1:N S BDGX(I,"F")="!?5"
 S BDGX(N+1,"F")="!!"
 D EN^DDIOL(.BDGX)
 Q
