BSDH02 ; IHS/ANMC/LJF - INTRO TEXT FOR REPORTS MENU ; 
 ;;5.3;PIMS;**1007**;APR 26, 2002
 ;
 ;
 ;cmi/anch/maw 2/20/2007 added CHK for check in status report
 ;cmi/anch/maw 2/20/2007 modified FRL for File Room List update PATCH 1007 item 1007.07 and item 1007.10
 ;cmi/anch/maw 2/21/2007 added reference in CHL for incomplete charts PATCH 1007 item 1007.21
 ;cmi/anch/maw 2/20/2007 modified WLR PATCH 1007 item 1007.34
 ;cmi/anch/maw 2/20/2007 modified CPF PATCH 1007 item 1007.34
 ;
AIU ;EP; intro text for Address/Insurance Update
 NEW BSDX
 S BSDX(1)="Use this option to print individual patient address and"
 S BSDX(2)="insurance update forms.  Each clinic can be set up to"
 S BSDX(3)="auotmatically prints these forms with the routing slips."
 D DISPLAY(3)
 Q
 ;
AMR ;EP; intro text for Appt Mgt Report
 NEW BSDX
 S BSDX(1)="Use this option to access reports designed to assist you"
 S BSDX(2)="in managing your appointment statuses.  Workload Reports"
 S BSDX(3)="require knowing whether an appointment took place, so each"
 S BSDX(4)="must be checked-in or marked as a no-show.  One report also"
 S BSDX(5)="helps you track if all checked-in appointments are being"
 S BSDX(6)="coded in PCC."
 D DISPLAY(6)
 Q
 ;
CAR ;EP; intro text for clinic availability reports
 NEW BSDX
 S BSDX(1)="Use this option to select from a list of reports dealing"
 S BSDX(2)="with clinic schedules and appointment availabilities.  All"
 S BSDX(3)="reports can be viewed in browse mode when HOME is the print"
 S BSDX(4)="device selected."
 D DISPLAY(4)
 Q
 ;
CHL ;EP; intro text for chart locatior
 ;cmi/anch/maw 2/21/2007 added reference for incomplete charts PATCH 1007 item 1007.21
 NEW BSDX
 S BSDX(1)="Use this option to review all appointments (scheduled and"
 S BSDX(2)="walk-ins), chart requests, and incomplete charts for a"
 S BSDX(3)="patient within a date range.  This option is designed to"
 S BSDX(4)="assist you in finding the paper chart if not in its proper"
 S BSDX(5)="place in the file room."
 D DISPLAY(5)
 Q
 ;
CPF ;EP; intro text for Clinic Profile
 ;cmi/anch/maw 2/20/2007 PATCH 1007 item 1007.34
 NEW BSDX
 S BSDX(1)="Use this option to view a summary of how selected clinics"
 S BSDX(2)="are set up.  If you select a principal clinic (including"
 S BSDX(3)="inactive ones), all clinics within that principal clinic"
 S BSDX(4)="will display."
 D DISPLAY(4)
 Q
 ;
FRL ;EP; intro text for file room list
 ;cmi/anch/maw 2/20/2007 PATCH 1007 item 1007.34
 NEW BSDX
 S BSDX(1)="Use this option to list patients who have an appointment"
 S BSDX(2)="or had their chart requested for a specific date.  You can"
 S BSDX(3)="print all clinics or all divisions or just selected ones."
 S BSDX(4)="You have a choice to sort by patient name, appointment time,"
 S BSDX(5)="clinic code, principal clinic or by terminal digit order."
 S BSDX(6)="The report also shows the patients appointments for a different"
 S BSDX(7)="clinic on the same day."
 D DISPLAY(7)
 Q
 ;
HSC ;EP; intro text for health summaries by clinic
 NEW BSDX
 S BSDX(1)="Use this option to print all health summaries for one day's"
 S BSDX(2)="appointments.  These will only print for those clinics that"
 S BSDX(3)="have health summaries turned on.  This option is used when"
 S BSDX(4)="the short form of routing slips is printed.  The health"
 S BSDX(5)="summaries automatically print WITH the long form routing"
 S BSDX(6)="slips."
 D DISPLAY(6)
 Q
 ;
LCR ;EP; intro text for List Chart Requests
 NEW BSDX
 S BSDX(1)="Use this option to print a list of all chart requests for"
 S BSDX(2)="a particular date.  This report lists only chart requests"
 S BSDX(3)="and does not include scheduled appointments or walk-ins."
 S BSDX(4)="The report may be sorted by date/time the request was made,"
 S BSDX(5)="by clinic, by principal clinic or by terminal digit."
 D DISPLAY(5)
 Q
 ;
NSR ;EP; intro text for no-show reports
 NEW BSDX
 S BSDX(1)="Use this option to access various reports on no-shows for"
 S BSDX(2)="scheduled clinic appointments.  Reports include statistics"
 S BSDX(3)="and patient listings."
 D DISPLAY(3)
 Q
 ;
RPL ;EP; intro text for radiology pull list
 NEW BSDX
 S BSDX(1)="Use this option to list patients with appointments for the"
 S BSDX(2)="specified date, whose previous radiology films need to be"
 S BSDX(3)="pulled for the appointment.  You may choose only selected"
 S BSDX(4)="divisions and clinics.  The report is sorted by chart # or"
 S BSDX(5)="by terminal digit order depending on your site parameter."
 D DISPLAY(5)
 Q
 ;
WLR ;EP; intro text for Waiting List Report
 ;cmi/anch/maw 2/20/2007 modified BSDX(6), added BSDX(7) PATCH 1007 item 1007.34
 NEW BSDX
 S BSDX(1)="Use this option to list patients on your waiting list by"
 S BSDX(2)="date added, recall date or date removed.  You can sort the"
 S BSDX(3)="report by date, priority, provider, reason for adding or"
 S BSDX(4)="resolution.  You can select to print for only one provider,"
 S BSDX(5)="priority or reason. For a list displayed on your screen, you can"
 S BSDX(6)="select any entry to review all information including the"
 S BSDX(7)="comments added."
 D DISPLAY(7)
 Q
 ;
CHK ;EP; intro text for check in Report
 ;cmi/anch/maw 2/20/2007 PATCH 1007 item 1007.34
 NEW BSDX
 S BSDX(1)="Use this option to list patients check in status for a "
 S BSDX(2)="particular clinic.  This report can be set to refresh"
 S BSDX(3)="itself every 60 seconds or to have a manual refresh."
 D DISPLAY(3)
 Q
 ;
WSR ;EP; intro text for Workload/Statistical Reports
 NEW BSDX
 S BSDX(1)="Use this option to access various workload reports, some"
 S BSDX(2)="statistical and some appointment listings.  This series"
 S BSDX(3)="assumes that Appointment Management Reports have been run"
 S BSDX(4)="and deemed clean.  These reports count past appointments."
 D DISPLAY(4)
 Q
 ;
DISPLAY(N) ; -- display array with N lines
 S BSDX(1,"F")="!!!?5"
 F I=2:1:N S BSDX(I,"F")="!?5"
 S BSDX(N+1,"F")="!!"
 D EN^DDIOL(.BSDX)
 Q
 ;
PAD(DATA,LENGTH) ; -- SUBRTN to pad length of data
 Q $E(DATA_$$REPEAT^XLFSTR(" ",LENGTH),1,LENGTH)
 ;
SP(N) ; -- returns N number of spaces
 Q $$PAD(" ",N)
