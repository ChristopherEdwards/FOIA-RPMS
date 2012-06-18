BSDH021 ; IHS/ANMC/LJF - HELP TEXT FOR CLINIC AVAIL RPTS ; 
 ;;5.3;PIMS;**1005,1007,1012**;FEB 26, 2007
 ;IHS/OIT/LJF 04/12/2006 PATCH 1005 added WK5 subroutine
 ;cmi/anch/maw 2/6/2007 PATCH 1007 item 1007.18, 1007.19 added AM4 and AM5 subroutines
 ;cmi/flag/maw 06/02/2010 PATCH 1012 added TOD subroutine
 ;
ABB ;EP; intro text for Clinic Abbreviations
 NEW BSDX
 S BSDX(1)="Use this report to produce a listing of abbreviations for"
 S BSDX(2)="all active clinics.  Many reports do not have room for"
 S BSDX(3)="clinic names so abbreviations are used.  This list can"
 S BSDX(4)="serve to decipher unfamiliar abbreviations."
 D DISPLAY(4)
 Q
 ;
AM1 ;EP; intro text for Appt Mgt Statistics
 NEW BSDX
 S BSDX(1)="Use this report to print a statistics for appointments with"
 S BSDX(2)="their corresponding statuses of checked-in, checked-out,"
 S BSDX(3)="no action taken, cancelled, no-shows and inpatient.  Use"
 S BSDX(4)="the report to track whether all your appointments have"
 S BSDX(5)="been processed.  This will insure that workload reports"
 S BSDX(6)="run properly."
 D DISPLAY(6)
 Q
 ;
AM2 ;EP; intro text for "NO Action Taken" appointments
 NEW BSDX
 S BSDX(1)="Use this report to list all appointments with no status"
 S BSDX(2)="or with a status of ""No Action Taken"".  All Workload"
 S BSDX(3)="and statistical reports will not be accurate until these"
 S BSDX(4)="appointments have an appropriate status added."
 D DISPLAY(4)
 Q
 ;
AM3 ;EP; intro text for List Uncoded Appointments
 NEW BSDX
 S BSDX(1)="This is a PCC report duplicated here for convenience."
 S BSDX(2)="It can also be found on the Visit Review Report menu as"
 S BSDX(3)="CINC - Scheduling Check-In Created Visits Not Yet Coded."
 S BSDX(4)="It will list all PCC visits created by Scheduling that do"
 S BSDX(5)="NOT have a POV added yet.  This is used to determine if"
 S BSDX(6)="PCC forms are not being submitted or if duplicate visits"
 S BSDX(7)="are being created."
 D DISPLAY(7)
 Q
 ;
AM4 ;EP; intro text for "Eligibility" appointments
 NEW BSDX
 S BSDX(1)="Use this report to list all appointments with patient's"
 S BSDX(2)="Insurance Eligibility.  You will be asked to select"
 S BSDX(3)="which type of coverage to display as well as what to"
 S BSDX(4)="sort the report by."
 D DISPLAY(4)
 Q
 ;
AM5 ;EP; intro text for "Cancelled" appointments
 NEW BSDX
 S BSDX(1)="Use this report to list all appointments that were cancelled"
 S BSDX(2)="This report may take some time as it has to search through"
 S BSDX(3)="the entire patient file to obtain the information needed for"
 S BSDX(4)="the report."
 D DISPLAY(4)
 Q
 ;
CAP ;EP; intro text for Clinic Capacity Report
 NEW BSDX
 S BSDX(1)="Use this report to compare appointment slots assigned vs."
 S BSDX(2)="open slots left.  For past dates this report will also"
 S BSDX(3)="display the number of actual patient encounters that day,"
 S BSDX(4)="the number of new appointments made that day along with"
 S BSDX(5)="the average number of days between making the appointment"
 S BSDX(6)="and the appointment date itself."
 D DISPLAY(6),PAUSE^BDGF
 Q
 ;
CAV ;EP; intro text for Clinic Availability Report
 NEW BSDX
 S BSDX(1)="Use this report to view the month-at-a-glance display for"
 S BSDX(2)="selected dates for multiple clinics with short appointment"
 S BSDX(3)="lists attached.  You can choose to also include no-shows"
 S BSDX(4)="and cancelled appointments in the listings."
 D DISPLAY(4)
 Q
 ;
DOW ;EP; -- intro on Clinic List (Day of Week)
 NEW BSDX
 S BSDX(1)="Use this report to generate a list of clinics by the day"
 S BSDX(2)="of week they meet.  It also lists if a clinic meets on each"
 S BSDX(3)="day currently or will in the future.  You can choose to print"
 S BSDX(4)="by division, principal clinic or selected clinics."
 D DISPLAY(4)
 Q
 ;
NAA ;EP; intro text for Next Available Appointment
 NEW BSDX
 S BSDX(1)="Use this report to print a listing of active clinics,"
 S BSDX(2)="sorted by principal clinic, noting the number of days"
 S BSDX(3)="until an appointment is available."
 D DISPLAY(3)
 Q
 ;
NAM ;EP; intro text for Count Number Appts Made
 NEW BSDX
 S BSDX(1)="Use this report to review the number of appointments made"
 S BSDX(2)="each day by principal clinic and individual clinic.  The"
 S BSDX(3)="number made by day of week is also included as well as the"
 S BSDX(4)="wait time between making the appointment and the actual"
 S BSDX(5)="appointment date.  The wait times are listed as low, high"
 S BSDX(6)="and average number of days."
 D DISPLAY(6)
 Q
 ;
NS1 ;EP; intro text for No-Show Report
 NEW BSDX
 S BSDX(1)="Use this report to list numbers of no-shows by date and"
 S BSDX(2)="optionally a patient listing.  Subtotaled by clinic and"
 S BSDX(3)="division."
 D DISPLAY(3)
 Q
 ;
NS2 ;EP; intro text for Frequent No-Shows
 NEW BSDX
 S BSDX(1)="Use this report to track patients with a specified number"
 S BSDX(2)="of recorded no-shows by clinic, by principal clinic or for"
 S BSDX(3)="your whole facility.  Each time you run the report, you can"
 S BSDX(4)="select the # of no-shows that will determine who to include"
 S BSDX(5)="in the listing."
 D DISPLAY(5)
 Q
 ;
NUM ;EP; intro text for Number of Available Appointments
 NEW BSDX
 S BSDX(1)="Use this report to view the number of appointments still"
 S BSDX(2)="available in selected clinics for a 14 day date range."
 S BSDX(3)="The default is to start with today.  The list is sorted by"
 S BSDX(4)="principal clinic"
 D DISPLAY(4)
 Q
 ;
TOD ;EP; intro text for Time of Day clinic fills up
 NEW BSDX
 S BSDX(1)="Use this report to display the time of day a clinic fills"
 S BSDX(2)="up.  It will display the date and time of the last"
 S BSDX(3)="appointment made, even if it did not occur on the day that"
 S BSDX(4)="the report is generated"
 D DISPLAY(4)
 Q
 ;
WK1 ;EP; intro text for Workload Report: Appts by Type
 NEW BSDX
 S BSDX(1)="Use this report to view counts of completed appointments"
 S BSDX(2)="broken down by type of appointment (scheduled, same day,"
 S BSDX(3)="walkin, overbook or inpatient).  Sorts include clinic,"
 S BSDX(4)="principal clinic, provider or team.  Optional subsorts"
 S BSDX(5)="include morning vs. afternoon appts., pediatric vs. adult"
 S BSDX(6)="patients, and male vs. female patients."
 D DISPLAY(6)
 Q
 ;
WK2 ;EP; intro text for Workload Listing
 NEW BSDX
 S BSDX(1)="Use this report to view a listing of completed appointments"
 S BSDX(2)="sorted by clinic and date.  For each appointment, the type"
 S BSDX(3)="(scheduled, walkin, inpt, etc.), chart #, sex, age and"
 S BSDX(4)="appointment status (checked-in, no action taken) are listed"
 S BSDX(5)="Can be sorted by principal clinic, provider or team."
 D DISPLAY(5)
 Q
 ;
WK3 ;EP; intro text for Workload Comparisons
 NEW BSDX
 S BSDX(1)="Use this report to compare statistics between the date"
 S BSDX(2)="range selected and the same date range in the previous"
 S BSDX(3)="year. For each month, the net change and percent change"
 S BSDX(4)="is noted.  The report can be sorted by clinic, principal"
 S BSDX(5)="clinic, provider or team.  No subsorts are available."
 D DISPLAY(5)
 Q
 ;
WK4 ;EP; intro text for Scheduled vs. Seen report
 NEW BSDX
 S BSDX(1)="Use this report to compare workload expectations versus"
 S BSDX(2)="what actually happened in clinic.  Scheduled appointments"
 S BSDX(3)="are added to overbooks while cancellations are subtracted"
 S BSDX(4)="to give you the number of patients expected.  Then no-shows"
 S BSDX(5)="are subtracted and walk-ins added to show how many patients"
 S BSDX(6)="were actually seen.  Sorts and subsorted are the same as"
 S BSDX(7)="Statistics by Type of Appointment report."
 D DISPLAY(7)
 Q
 ;
 ;IHS/OIT/LJF 04/12/2006 PATCH 1005 added WK5 subroutine
WK5 ;EP; intro text for Clinic Workload Report
 NEW BSDX
 S BSDX(1)="Use this option to print out statistics on the number of"
 S BSDX(2)="appointments per clinic for a date range.  The Expanded"
 S BSDX(3)="Report breaks down the numbers by scheduled and unscheduled"
 S BSDX(4)="appointments, cancellations and inpatients.  You can choose"
 S BSDX(5)="to list the patients.  The Brief Report lists only the number"
 S BSDX(6)="of appointments and compares it to the same date range of"
 S BSDX(7)="the previous year.  It can take a long time to run.  This"
 S BSDX(8)="report is NOT designed to be run on the terminal screen!"
 D DISPLAY(8)
 Q
 ;
WK6 ;EP; intro text for turn around time report
 NEW BSDX
 S BSDX(1)="Use this option to print out statistics on the turn around"
 S BSDX(2)="time of appointments.  Turn around time (TAT) is the difference"
 S BSDX(3)="between time checked in and time checked out.  Report can"
 S BSDX(4)="be summary and detailed.  Summary lists number of appointments"
 S BSDX(5)="number checked in and number checked out.  Detailed includes"
 S BSDX(6)="summary info plus a listing of each appointment with patient"
 S BSDX(7)="name, chart number, appointment time, check in time, check out"
 S BSDX(8)="time, and TAT"
 D DISPLAY(8)
 Q
 ;
WK7 ;EP; intro text for chart request and routing slip report
 NEW BSDX
 S BSDX(1)="Use this option to print out statistics on the number of"
 S BSDX(2)="chart requests and routing slips printed by month.  The report"
 S BSDX(3)="displays number of routing slips printed, subtotals by chart"
 S BSDX(4)="requests, scheduled appointments and walkins."
 S BSDX(5)="The report can be subtotaled by sorting criteria."
 D DISPLAY(5)
 Q
 ;
WK8 ;EP; intro text for advanced access report
 NEW BSDX
 S BSDX(1)="Use this option to print out a report to assess the internal"
 S BSDX(2)="and external demand for appointments.  The report should be"
 S BSDX(3)="evaluated on a daily basis to adjust the providers schedule"
 S BSDX(4)="so that patients have better access to health care"
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
