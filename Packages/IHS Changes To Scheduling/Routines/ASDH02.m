ASDH02 ; IHS/ADC/PDW/ENM - INTRO TEXT FOR REPORTS ; [ 03/25/1999  11:48 AM ]
 ;;5.0;IHS SCHEDULING;;MAR 25, 1999
 ;
CP ;EP; intro text for clinic profile
 D ^XBCLS W !!?25,"CLINIC PROFILES",!!
 W !?5,"Use this option to display or print summaries of clinics"
 W !?5,"you specify.  You can also print for all clinics.",!
 Q
 ;
AI ;EP; intro text for AIU
 D ^XBCLS W !!?20,"ADDRESS/INSURANCE UPDATE",!!
 W !?5,"Use this option to print out Address/Insurance Update forms"
 W !?5,"for an individual patient or for a whole clinic.  You can also"
 W !?5,"set up clinics to print the AIU automatically with the health"
 W !?5,"summaries.  The AIU will print ONLY if a specified number of"
 W !?5,"days since the last registration update has passed.  This"
 W !?5,"number of days is a site parameter.  This option lets you"
 W !?5,"print out an AIU without checking the parameter if printing"
 W !?5,"by individual patient.",!
 Q
 ;
HC ;EP; intro text for HS by clinic
 D ^XBCLS W !!?20,"HEALTH SUMMARIES BY CLINIC",!!
 W !?5,"Use this option to print out health summaries for your clinics"
 W !?5,"for a specific date.  Use this option if you have a different"
 W !?5,"printer for routing slips and health summaries.  For those"
 W !?5,"sites using the same printer, the health summaries print out"
 W !?5,"with the routing slips.  This option will also print out any"
 W !?5,"other forms you've selected for a clinic.  These include the"
 W !?5,"Encounter Form (Superbill), Medication Profile, and the Address"
 W !?5,"and Insurance Update.",!
 Q
 ;
FL ;EP; intro text for file room list
 D ^XBCLS W !!?20,"FILE ROOM LIST",!!
 W !?5,"Use this option to print a list of patients with appointments"
 W !?5,"for the date you specify.  This is designed for use by the"
 W !?5,"medical records department, therefore the default for the sort"
 W !?5,"is by terminal digit order.  You can also choose to sort by"
 W !?5,"patient name, chart # or principle clinic.  For a listing in"
 W !?5,"order by appointment time, use the Appointment List.",!
 Q
 ;
RL ;EP; intro text for radiology pull list
 D ^XBCLS W !!?20,"RADIOLOGY PULL LIST",!!
 W !?5,"Use this option to print, in terminal digit order, a listing"
 W !?5,"of all patients whose radiology reports/films are required"
 W !?5,"for appointment.",!
 Q
 ;
RS ;EP; introtext for Routing Slips
 D ^XBCLS W !!?25,"ROUTING SLIPS",!!
 W !?5,"Use this option to print out Routing Slips for your clinics"
 W !?5,"or for a single patient.  If your site parameter is set to YES"
 W !?5,"for printing Health Summaries with Routings Slips they and"
 W !?5,"other forms selected by the clinic will also print here.",!
 Q
 ;
AL ;EP; intro text for appt list
 D ^XBCLS W !!?25,"APPOINTMENT LISTING",!!
 W !?5,"Use this option to print a listing of appointments by time"
 W !?5,"for selected clinics for one date.  You will also be asked"
 W !?5,"to include walk-ins and if you want the person who made the"
 W !?5,"appointment to be printed on the listing.",!
 Q
 ;
FA ;EP; intro text for future inpt appt by admit date
 D ^XBCLS W !!?20,"FUTURE INPATIENT APPOINTMENTS (by ADMIT DATE)",!!
 W !?5,"Use this option to print a list of pending appointments for"
 W !?5,"patients admitted on a certain date.",!
 Q
 ;
IA ;EP; intro text for inpt appt by ward
 D ^XBCLS W !!?20,"APPOINTMENTS FOR CURRENT INPATIENTS",!!
 W !?9,"Use this option to print a list of current inpatients for"
 W !?5,"one ward or all who have pending appointments.  You will"
 W !?5,"be asked for a date range for the appointments.",!
 Q
 ;
DW ;EP; intro text for clinic list-day of week
 D ^XBCLS W !!?20,"CLINIC LIST - DAY OF THE WEEK",!!
 W !?5,"Use this option to print a list of selected clinics detailing"
 W !?5,"the days of the week each clinic meets.  You can choose to"
 W !?5,"print all clinics, selected ones by name or all grouped under"
 W !?5,"a principal clinic.",!
 Q
 ;
CA ;EP; intro text for clinic availability report
 D ^XBCLS W !!?20,"CLINIC AVAILABILITY REPORT",!!
 W !?5,"Use this option to print out the patterns for the clinics and"
 W !?5,"the date ranges you select.  It will then list the patients"
 W !?5,"scheduled in those slots.",!
 Q
 ;
NS ;EP; intro text for no-show report
 D ^XBCLS W !!?25,"NO-SHOW REPORT",!!
 W !?5,"Use this option to print out a report listing no-shows for"
 W !?5,"selected clinics and date ranges.  It will also give simple"
 W !?5,"statistics on no-shows.",!
 Q
 ;
WL ;EP; intro text for Waiting LIst
 D ^XBCLS W !!?20,"CLINIC WAITING LIST",!!
 W !?5,"Use this option to print out the waiting list for the"
 W !?5,"clinic you specify.  The listing can be sorted by the"
 W !?5,"date entered or by priority.",!
 Q
 ;
WR ;EP; intro text for Workload Report
 D ^XBCLS W !!?20,"WORKLOAD REPORT",!!
 W !?5,"Use this option to print out statistics on the number of"
 W !?5,"appointments per clinic for a date range.  The Expanded"
 W !?5,"Report breaks down the numbers by scheduled and unscheduled"
 W !?5,"appointments, cancellations and inpatients.  You can choose"
 W !?5,"to list the patients.  The Brief Report lists only the number"
 W !?5,"of appointments and compares it to the same date range of"
 W !?5,"the previous year.  It can take a long time to run.  This"
 W !?5,"report is NOT designed to be run on the terminal screen!",!
 Q
