ASDH04 ; IHS/ADC/PDW/ENM - INTRO TEXT FOR MGR MENU ; [ 03/25/1999  11:48 AM ]
 ;;5.0;IHS SCHEDULING;;MAR 25, 1999
 ;
ESP ;EP; intro text for SD IHS PARAMETER
 D ^XBCLS W !!?20,"EDIT SCHEDULING PARAMETERS",!!
 W !?5,"Use this option to modify parameters that affect the whole"
 W !?5,"Scheduling package and are not different for each clinic."
 W !?5,"It is mandatory that these be answered to assure successful"
 W !?5,"execution of Scheduling options.",!
 Q
 ;
CRA ;EP ;intro text for cancel/restore clinic availability
 D ^XBCLS W !!?20,"CANCEL/RESTORE CLINIC AVAILABILITY",!
 W !?5,"Use this option to either CANCEL or RESTORE a clinic's"
 W !?5,"appointment slots.",!
 W !?5,"You can CANCEL a clinic's availability for either a whole"
 W !?5,"day or portion's of a day.  If several portions's of a day"
 W !?5,"are to be cancelled you must cancel one portion first, then"
 W !?5,"select CANCEL again to cancel the second portion, etc.",!
 W !?5,"You can RESTORE the availability for a previously cancelled"
 W !?5,"clinic.  Appointments which were rescheduled using the auto-"
 W !?5,"rebook feature at the time of cancellation WILL NOT be moved"
 W !?5,"to their original time slots.",!
 Q
 ;
IRC ;EP; intro text for inactivate/reactivate clinic
 D ^XBCLS W !!?20,"INACTIVATE/REACTIVATE CLINIC",!!
 W !?5,"Choose INACTIVATE to render a clinic inactive (no activity)"
 W !?5,"allowed) as of a selected date.  Choose REACTIVATE to set"
 W !?5,"the date from which point the inactivation of a clinic is"
 W !?5,"terminated.",!
 Q
 ;
AMB ;EP; intro text of rAppt made by
 D ^XBCLS W !!?20,"APPOINTMENT MADE BY",!!
 W !?5,"Use this option to view a patient's appointments starting"
 W !?5,"from a date you specify listing who made each appointment."
 W !?5,"You can choose to view any appointments on the list for"
 W !?5,"more details.",!
 Q
 ;
SET ;EP; intro text for set up a clinic
 D ^XBCLS W !!?25,"SET UP A CLINIC",!!
 W !?5,"Use this option to create clinics, modify their parameters,"
 W !?5,"and to change their appointment availability.",!
 Q
 ;
CHG ;EP; intro text for change patterns option
 D ^XBCLS W !!?20,"CHANGE PATTERNS TO 30-60",!!
 W !?5,"Use this option to change patterns which had been created"
 W !?5,"with 15 minute increments to 30 or 60 minute time slot"
 W !?5,"patterns.",!
 Q
 ;
RMP ;EP ; intro text for Remap Clinic
 D ^XBCLS W !!?25,"REMAP CLINIC",!!
 W !?5,"Use this option to remap a clinic. It is used primarily after"
 W !?5,"the entry of a new holiday or deletion of an existing holiday."
 W !?5,"It basically updates the pattern to insure that it knows that"
 W !?5,"the holiday now exists or no longer exists.  It must be run"
 W !?5,"for each clinic which meets on the date of the holiday.",!
 Q
 ;
AEH ;EP; intro text for add holidays
 D ^XBCLS W !!?20,"ADD/EDIT HOLIDAYS",!!
 W !?5,"Use this option to add holidays to the Scheduling calendar."
 W !?5,"If you are adding or changing a holiday that will affect the"
 W !?5,"availability of clinic schedules already set up, remember to"
 W !?5,"use the option REMAP CLINICS.",!
 Q
 ;
EEL ;EP; intro text for edit letters
 D ^XBCLS W !!?20,"ENTER/EDIT LETTERS",!!
 W !?5,"Use this option to enter a new/edit an existing letter which"
 W !?5,"is one of the following types:"
 W !?5," (P)re-appointment"
 W !?5," (N)o-show"
 W !?5," (C)linic Cancelled -      (Cancel Clinic Availaility option"
 W !?5,"                           was used to cancel appointments)"
 W !?5," (A)ppointment Cancelled - (appointment was cancelled individually"
 W !?5,"                           through Cancel Appointment option)"
 W ! Q
 ;
PRG ;EP; intro text for purge scheduling data
 D ^XBCLS W !!?20,"PURGE SCHEDULING DATA",!!
 W !?5,"Use this option to delete various non-essential nodes created"
 W !?5,"by the Scheduling module in the Hospital Location and Patient"
 W !?5,"files.  The time limit for keeping these nodes is this year"
 W !?5,"and the prior fiscal year.",! D PRTOPT^ASDVAR
 Q
 ;
LAC ;EP; intro text for list of appts made by user
 D ^XBCLS W !!?20,"LIST APPTS MADE BY CLINIC",!!
 W !?5,"Use this option to list all appointments made for a clinic"
 W !?5,"within a date range.  For each appointment, the person who"
 W !?5,"made the appointment is noted.",!
 Q
 ;
OVB ;EP; intro text for enter overbook user
 D ^XBCLS W !!?20,"ENTER OVERBOOK USER",!!
 W !?5,"There are 2 ways to give a user the ability to overbook "
 W !?5,"appointments.  The site manager can assign the overbook"
 W !?5,"and/or master overbook keys to the user.  OR you can give"
 W !?5,"a user access to overbook in only selected clinics using"
 W !?5,"this option.  The Master Overbook access means the person"
 W !?5,"can overbook beyond the maximum overbooks allowed per day"
 W !?5,"for the clinic.",!
 Q
 ;
DSU ;EP; intro text for Display Scheduling User
 D ^XBCLS W !!?20,"DISPLAY SCHEDULING USER",!!
 W !?5,"Use this option to view a user's access level in the IHS"
 W !?5,"Scheduling software.  It will list the extra functions a"
 W !?5,"user can perform based on security keys.  It will also list"
 W !?5,"which restricted clinics the user can access and the user's"
 W !?5,"overbook level.",!
 Q
