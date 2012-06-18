ASDP5POS ; IHS/ANMC/LJF - MAS PATCH 5 POSTINIT; [ 09/28/2000  10:53 AM ]
 ;5.0;IHS SCHEDULING;**5**;MAR 25, 1999
 ;
 D MAIL^XBMAIL("SDZSUP1,SDZMGR","MSG^ASDP5POS")
 Q
 ;
MSG ;EP; patch 5 mail message
 ;;MAS 5 PATCH 5 RELEASE NOTES
 ;;MAS V5 Patch #5 has just been installed on your RPMS system.
 ;;  
 ;;This patch adds a new function to the check-in system in RPMS
 ;;Scheduling.  If you turn on the appropriate parameters for a clinic,
 ;;a PCC visit will be created at check-in.  This will be required to
 ;;use the new PCC Encounter Form.  This new function allows tracking
 ;;incomplete visits and their associated PCC forms. A PCC error report
 ;;under the VRR (View Review Report) menu is designed to assist you.
 ;;It is called Scheduling Check-In Created Visits Not Yet Coded (CINC).
 ;;  
 ;;For details on this new visit creation process and how to set up
 ;;your clinics to use it, please read the Appointment Tutorial on the
 ;;Appointment Menu in Scheduling.  Choose 3 for the "Check-in Patients
 ;;for Scheduled Appointments" section.
