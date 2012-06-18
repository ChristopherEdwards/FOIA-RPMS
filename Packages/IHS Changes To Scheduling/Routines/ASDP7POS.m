ASDP7POS ; IHS/ANMC/LJF - MAS PATCH 7 POSTINIT; [ 12/06/2000  6:37 AM ]
 ;;5.0;IHS SCHEDULING;**7,8**;MAR 25, 1999
 ; make sender Postmaster so installer gets new mail
 ;IHS/ITSC/KMS, 25-Apr-2003 - Patch 8 - added ";" in comment line 1, above, before 5.0 for SAC Compliancy
 ;
 NEW ASDDUZ S ASDDUZ=DUZ,DUZ=.5
 D MAIL^XBMAIL("SDZSUP1,SDZMGR","MSG^ASDP7POS")
 S DUZ=ASDDUZ
 Q
 ;
MSG ;EP; patch 7 mail message
 ;;MAS 5 PATCH 7 RELEASE NOTES
 ;;MAS V5.0 Patch #7 has just been installed on your RPMS system.
 ;;   
 ;;This patch contains the tested version of the new "Create Visit at
 ;;Check-in" function released in patch #5.  A new field VISIT PROVIDER
 ;;REQUIRED? has been added to each clinic's setup.  If the provider
 ;;is not known at check-in time, answer NO to this question.  If you
 ;;are running the new Encounter Form software, it will use a generic
 ;;provider to print the form if none is defined at check-in.  Answer 
 ;;YES to require entering a provider at check-in insuring that it will
 ;;be passed to PCC for you.
 ;;    
 ;;   
 ;;Here are the release notes from MAS patch 5:
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
