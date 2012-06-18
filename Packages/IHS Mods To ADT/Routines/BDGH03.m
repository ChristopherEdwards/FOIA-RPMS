BDGH03 ; IHS/ANMC/LJF - INTRO TEXT FOR ADT REPORTS ; 
 ;;5.3;PIMS;**1005**;MAY 28, 2004
 ;IHS/OIT/LJF 02/15/2006 PATHC 1005 added PIC subroutine
 ;
 Q
 ;
AFM ;EP; intro text for admission forms option
 NEW BDGX
 S BDGX(1)="Use this option to print one of the various admission forms"
 S BDGX(2)="avaiable.  A locator card is printed to show the current"
 S BDGX(3)="ward and room-bed of a patient and is usually used by a"
 S BDGX(4)="site's operators or information desk.  You may also print"
 S BDGX(5)="an A Sheet for one patient, for all patients admitted on"
 S BDGX(6)="one admission date, or if you have the key, a final, coded"
 S BDGX(7)="A Sheet for a patient."
 D DISPLAY(7)
 Q
 ;
ASR ;EP; intro text for ADT statistical reports
 NEW BDGX
 S BDGX(1)="Use this option to review ADT census and other statistics"
 S BDGX(2)="by ward or by service.  Each report gives a different view"
 S BDGX(3)="of the ADT activity at your facility."
 D DISPLAY(3)
 Q
 ;
BED ;EP; intro text for bed availability
 NEW BDGX
 S BDGX(1)="Use this option to view a list of empty beds by ward.  The"
 S BDGX(2)="abbreviated view can optionally include bed descriptions."
 S BDGX(3)="The expanded view can include scheduled admissions for the"
 S BDGX(4)="next 2 weeks, lodgers occupying beds on the ward as well as"
 S BDGX(5)="bed descriptions.  Any bed with an asterisk (*) can be used"
 S BDGX(6)="by multiple wards.  These can include OR and RR beds."
 D DISPLAY(6)
 Q
 ;
CIC ;EP; intro text for current inpatient census
 NEW BDGX
 S BDGX(1)="Use this option to view the current number of inpatients"
 S BDGX(2)="and observation patients admitted to your facility.  The"
 S BDGX(3)="report breaks down the counts by ward and by service."
 D DISPLAY(3)
 Q
 ;
ILD ;EP; intro text for inpt lists by date
 NEW BDGX
 S BDGX(1)="Use this option view past admissions, ICU transfers, and"
 S BDGX(2)="discharges for a given date range.  Each report offers"
 S BDGX(3)="several ways to sort the information.  All reports are"
 S BDGX(4)="available in browse mode in addition to printing on paper."
 D DISPLAY(4)
 Q
 ;
IPL ;EP; intro text for current inpatient listings
 NEW BDGX
 S BDGX(1)=$$SP^BDGF(10)_"CURRENT INPATIENT LISTINGS"
 S BDGX(2)="Use this option to print any of nine various inpatient"
 S BDGX(3)="listings based on current inpatients.  Complete on-line"
 S BDGX(4)="help is available as choice #10."
 D DISPLAY(4)
 Q
 ;
IWA ;EP; intro text for inpts with appts
 NEW BDGX
 S BDGX(1)="Use this option to print appointment lists for inpatients."
 S BDGX(2)="You can choose from listing just those patients admitted"
 S BDGX(3)="on a certain day or to list all current inpatients."
 D DISPLAY(3)
 Q
 ;
OPL ;EP; intro text for operator's inpatient listing
 NEW BDGX
 S BDGX(1)="This option is an alphabetical listing of currents"
 S BDGX(2)="inpatients for use in locating a particular patient."
 S BDGX(3)="It lists the patient's ward and room but no clinical"
 S BDGX(4)="information.  This option is designed to be placed on"
 S BDGX(5)="any menu used by the phone operators at your facility."
 D DISPLAY(5)
 Q
 ;
PIC ;EP; intro text for provider's IC list;IHS/OIT/LJF 02/15/2006 PATCH 1005
 NEW BDGX
 S BDGX(1)="Providers can use this option to print out a copy of their"
 S BDGX(2)="own current Incomplete Charts Listing. You are not asked for"
 S BDGX(3)="a provider name; it knows who is currently signed in.  This"
 S BDGX(4)="prevents providers from viewing each other's list."
 D DISPLAY(4)
 D PAUSE^BDGF
 Q
 ;
PMR ;EP; intro text for patient movement reports
 NEW BDGX
 S BDGX(1)="This option gives you a choice of reports detailing ward"
 S BDGX(2)="transfers and other movements affecting census data."
 S BDGX(3)="These reports are designed for use by inpatient unit staff"
 S BDGX(4)="For more information, see the on-line help option below."
 D DISPLAY(4)
 Q
 ;
SVL ;EP; intro text for scheduled visit list
 NEW BDGX
 S BDGX(1)="Use this option to print out a listing of patients with"
 S BDGX(2)="visits by date range.  You can choose to print all types or"
 S BDGX(3)="just admissions, just day surgeries or just outpatients."
 S BDGX(4)="Depending on the type of visits chosen, you have customized"
 S BDGX(5)="choices for primary and secondary sorts. Either a brief or"
 S BDGX(6)="detailed report can be chosen."
 D DISPLAY(6)
 Q
 ;
VAH ;EP; intro text for view admission history
 NEW BDGX
 S BDGX(1)="Use this option to view a condensed list of all inpatient"
 S BDGX(2)="and observation stays for a patient at your facility.  You"
 S BDGX(3)="will be asked to choose the patient and the list will be"
 S BDGX(4)="presented in browse mode.  Use the PL - Print List function"
 S BDGX(5)="if you need a paper copy."
 D DISPLAY(5)
 Q
 ;
DISPLAY(N) ; -- display array with N lines
 S BDGX(1,"F")="!!!?5"
 F I=2:1:N S BDGX(I,"F")="!?5"
 S BDGX(N+1,"F")="!!"
 D EN^DDIOL(.BDGX)
 D VAR^BDGVAR     ;makes all options able to run independently
 Q
