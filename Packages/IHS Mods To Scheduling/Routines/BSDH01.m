BSDH01 ; IHS/ANMC/LJF - INTRO TEXT FOR APPTS MENU ;  [ 04/01/2004  12:00 PM ]
 ;;5.3;PIMS;**1004,1007**;MAY 28, 2004
 ;IHS/OIT/LJF 07/22/2005 PATCH 1004 added WL subroutine for waiting list option
 ;cmi/anch/maw 2/20/2007 added line CL for PATCH 1007 item 1007.14
 ;cmi/anch/maw 2/21/2007 modified intro text in WL to mention sort criteria PATCH 1007 item 1007.33
 ;cmi/anch/maw 2/20/2007 modified AL for PATCH 1007 item 1007.34
 ;cmi/anch/maw 2/23/2007 added OAS PATCH 1007 item 1007.32
 ;
 Q
AL ;EP; intro text for app list option
 ;cmi/anch/maw 2/20/2007 modified BSDX(5) and added BSDX(6) PATCH 1007 item 1007.34
 NEW BSDX
 S BSDX(1)="Use this option to print a list of scheduled appointments"
 S BSDX(2)="for one or more clinics for a specific date.  You can ask"
 S BSDX(3)="for all clinics or by principal clinic.  Optional items to"
 S BSDX(4)="include are walk-ins, who made the appointment, patient's"
 S BSDX(5)="phone number, work phone, current community, and primary"
 S BSDX(6)="care provider assignments."
 D DISPLAY(6)
 Q
 ;
AM ;EP; intro text for app mgt option
 NEW BSDX D ^XBCLS
 S BSDX(1)=$$REPEAT^XLFSTR(" ",15)_"APPOINTMENT MANAGEMENT"
 S BSDX(2)=""
 S BSDX(3)="Use this option to make appointments, check-in patients,"
 S BSDX(4)="request charts and otherwise manage your clinic.  You can"
 S BSDX(5)="select by patient to process that patient's appointments"
 S BSDX(6)="OR select a clinic to process all appointments in that"
 S BSDX(7)="clinic for a date range."
 D DISPLAY(7)
 Q
 ;
CR ;EP; intro text for chart requests
 NEW BSDX
 S BSDX(1)="Use this option to request multiple patient charts for"
 S BSDX(2)="review without actually scheduling appointments.  Routing"
 S BSDX(3)="slips will print when appointments are run for the date"
 S BSDX(4)="requested.  If that date is today, a routing slip will"
 S BSDX(5)="print immediately."
 ;
 ;IHS/ANMC/LJF 10/19/2001 ANMC only mod
 D ENS^%ZISS
 S BSDX(6)=""
 S BSDX(7)=$$REPEAT^XLFSTR("*",25)_"REMINDER"_$$REPEAT^XLFSTR("*",25)
 S BSDX(7)=$G(IORVON)_BSDX(7)_$G(IORVOFF)
 S BSDX(8)="Chart Requests will be processed AFTER walk-ins and same"
 S BSDX(9)="day appointments.  Please request charts as many days in"
 S BSDX(10)="advance as possible."
 D DISPLAY(10),KILL^%ZISS Q
 ;IHS/ANMC/LJF 10/19/2001 end of ANMC mods
 ;
 D DISPLAY(5)
 Q
 ;
DA ;EP; intro text for display patient appointments
 NEW BSDX
 S BSDX(1)="Use this option to view a patient's appointments for a date"
 S BSDX(2)="range you specify.  This will also tell you who made the"
 S BSDX(3)="appointment and when, along with the current status of the"
 S BSDX(4)="appointment and PCC visit."
 D DISPLAY(4)
 Q
 ;
MB ;EP; intro text for multiple appt booking
 NEW BSDX
 S BSDX(1)="Use this option to make multiple appointments for a patient"
 S BSDX(2)="to the same clinic.  This can be used to book weekly or"
 S BSDX(3)="daily appointments for a given date range."
 D DISPLAY(3)
 Q
 ;
MC ;EP; intro text for multi clinic booking
 NEW BSDX
 S BSDX(1)="Allows you to display or book appts into 2-4 clinics on"
 S BSDX(2)="the same day.  It automatically finds the day where all"
 S BSDX(3)="chosen clinics have the necessary availability."
 D DISPLAY(3)
 Q
 ;
MD ;EP; intro text for month-at-a-glance
 NEW BSDX
 S BSDX(1)="Use this option to view a clinic's available appointments"
 S BSDX(2)="or to view the first available date for each clinic under"
 S BSDX(3)="a principal clinic."
 D DISPLAY(3)
 Q
 ;
OAS ;EP; intro text for original clinic setup display
 ;cmi/anch/maw 2/22/2007 added PATCH 1007 item 1007.32
 NEW BSDX
 S BSDX(1)="Use this option to view a clinic's original availability"
 S BSDX(2)="setup."
 D DISPLAY(2)
 Q
 ;
SL ;EP; intro text for print scheduling letters
 NEW BSDX
 S BSDX(1)="Use this option to print Pre-Appointment, No-Show, and"
 S BSDX(2)="Cancellation letters.  If you choose to print letters"
 S BSDX(3)="assigned to the clinics AND a clinic in your selection"
 S BSDX(4)="does NOT have one assigned, no letters will print for that"
 S BSDX(5)="clinic.  You can also choose one letter to print for all"
 S BSDX(6)="clinics you select, ignoring the letter assignments."
 D DISPLAY(6)
 Q
 ;
PS ;EP; intro text for View Provider's Schedule
 NEW BSDX
 S BSDX(1)="Use this option to view a particular provider's schedule"
 S BSDX(2)="across all clinics where that provider is listed as the"
 S BSDX(3)="default provider."
 D DISPLAY(3)
 Q
 ;
WL ;EP; intro test for Waiting List Entry/Edit ;IHS/OIT/LJF 7/22/2005 PATCH 1004
 ;cmi/anch/maw 2/21/2007 modified intro text to mention sort criteria PATCH 1007 item 1007.33
 NEW BSDX
 S BSDX(1)="Use this option to manage your waiting lists for both outpatient"
 S BSDX(2)="clinics or inpatient wards.  Only application coordinators may add"
 S BSDX(3)="new clinics or wards as waiting lists.  Once a list is selected, you"
 S BSDX(4)="can select how the list will be displayed.  Options are Patient Name,"
 S BSDX(5)="Date Added to List, Priority, and Recall Date.  From that"
 S BSDX(6)="list, you may add new patients, edit or view existing entries, remove"
 S BSDX(7)="patients from active status or request a listing of closed cases."
 D DISPLAY(7)
 Q
 ;
CL ;EP; intro text for customized letters
 NEW BSDX
 S BSDX(1)="Use this option to print out letters for a single or group"
 S BSDX(2)="of patients.  The patient does not need to have an appointment"
 S BSDX(3)="to print the letter.  This option can be used if you want to"
 S BSDX(4)="print letters for a group of patients, ones that have a"
 S BSDX(5)="designated provider, a follow up or when a doctor is leaving."
 D DISPLAY(5)
 Q
 ;
DISPLAY(N) ; -- display array with N lines
 S BSDX(1,"F")="!!!?5"
 F I=2:1:N S BSDX(I,"F")="!?5"
 S BSDX(N+1,"F")="!!"
 D EN^DDIOL(.BSDX)
 Q
