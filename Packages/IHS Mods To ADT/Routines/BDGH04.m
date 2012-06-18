BDGH04 ; IHS/ANMC/LJF - INTRO TEXT FOR CENSUS REPORTS ;
 ;;5.3;PIMS;;APR 26, 2002
 ;
 Q
 ;
AID1 ;EP; intro text for census data by ward
 NEW BDGX
 S BDGX(1)="Use this option to view numbers of admissions, transfers"
 S BDGX(2)="and discharges for a particular ward within a date range."
 S BDGX(3)="The report also includes a calculation of ward activity;"
 S BDGX(4)="a benchmark based on number of movements against the"
 S BDGX(5)="number of patients remaining."
 D DISPLAY(5)
 Q
 ;
AID2 ;EP; intro text for census data by ward and service
 NEW BDGX
 S BDGX(1)="Use this option to view activity for a service within a"
 S BDGX(2)="ward for a date range.  You will also be asked to choose"
 S BDGX(3)="between adult or pediatric movements for that service."
 D DISPLAY(3)
 Q
 ;
AID3 ;EP; intro text for census data by service
 NEW BDGX
 S BDGX(1)="Use this option to view service changes in your facility"
 S BDGX(2)="for a date range.  You must choose between adult or"
 S BDGX(3)="pediatric movements.  These are the same numbers that are"
 S BDGX(4)="reported on the summary-style A&D Sheet."
 D DISPLAY(4)
 Q
 ;
AID4 ;EP; intro text for list ward census movements
 NEW BDGX
 S BDGX(1)="Use this option to list each patient movement within a"
 S BDGX(2)="given time frame.  This report is used by unit nursing"
 S BDGX(3)="staff to check their manual census records against the"
 S BDGX(4)="data recorded in ADT.  A summary page is printed if all"
 S BDGX(5)="wards are chosen to print."
 D DISPLAY(5)
 Q
 ;
M202 ;EP; intro text for M202
 NEW BDGX
 S BDGX(1)="Use this option to print the HSA-202-1 form for reporting"
 S BDGX(2)="inpatient services at your facility for a specific month."
 S BDGX(3)="Unlike most ADT reports, this report is designed to print"
 S BDGX(4)="only on paper so it is not available in list manager mode."
 D DISPLAY(4)
 Q
 ;
Y202 ;EP; intro text for M202 for date range
 NEW BDGX
 S BDGX(1)="Use this option to print a report in the HSA-202-1 format"
 S BDGX(2)="BUT for a range of months. This can be used to view your"
 S BDGX(3)="facility's inpatient services over time.  Like the M202,"
 S BDGX(4)="this report is designed to print on paper."
 D DISPLAY(4)
 Q
 ;
DISPLAY(N) ; -- display array with N lines
 S BDGX(1,"F")="!!!?5"
 F I=2:1:N S BDGX(I,"F")="!?5"
 S BDGX(N+1,"F")="!!"
 D EN^DDIOL(.BDGX)
 D VAR^BDGVAR      ;makes all options able to run independently
 Q
