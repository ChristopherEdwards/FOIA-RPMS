ASDH01 ; IHS/ADC/PDW/ENM - INTRO TEXT FOR OPTIONS ; [ 03/25/1999  11:48 AM ]
 ;;5.0;IHS SCHEDULING;;MAR 25, 1999
 ;
MA ;EP; intro text for Make Appointment
 D ^XBCLS W !!?20,"MAKE APPOINTMENT",!!
 W !?5,"Use this option to make clinic appointments for a patient."
 W !?5,"You may be asked to edit selected patient demographics and"
 W !?5,"then you will be asked for the clinic.  If you choose a "
 W !?5,"Principal Clinic, the first available for each individual"
 W !?5,"clinic under it will display.  You can select a clinic from"
 W !?5,"that list if appropriate.  The patient's pending appointments"
 W !?5,"also display to assist in scheduling appointments convenient"
 W !?5,"to the patient.",!
 Q
 ;
AT ;EP; intro text for Append Ancillary Test
 D ^XBCLS W !!?20,"APPEND ANCILLARY TEST TO APPOINTMENT",!!
 W !?5,"Use this option to add to a previously scheduled appointment,"
 W !?5,"any ancillary test which may have been overlooked when the"
 W !?5,"appointment was made.",!
 Q
 ;
DT ;EP; intro text for Delete Ancillary Test
 D ^XBCLS W !!?20,"DELETE ANCILLARY TEST FROM APPOINTMENT",!!
 W !?5,"Use this option to delete any ancillary tests scheduled by"
 W !?5,"mistake which are attached to a clinic appointment.",!
 Q
 ;
CA ;EP; intro text for Cancel Appt
 D ^XBCLS W !!?25,"CANCEL APPOINTMENTS",!!
 W !?5,"Use this option to cancel clinic appointments that were"
 W !?5,"either cancelled by the patient or by the clinic.",!
 Q
 ;
CR ;EP; intro text for Chart Request
 D ^XBCLS W !!?20,"CHART REQUESTS (future dates)",!!
 W !?5,"Use this option to request charts for chart review purposes."
 W !?5,"You will be asked to enter the date you would like the charts"
 W !?5,"to be available.  The minimum waiting period is determined by"
 W !?5,"your facility giving Medical Records time to ready your charts"
 W !?5,"while also pulling charts for patient appointments.",!
 W !?5,"The minimum waiting period for this facility is ",$$CRDAY
 W " days.",!
 Q
 ;
CRDAY() ; -- return chart request waiting period
 Q $$VAL^XBDIQ1(40.8,$$DIV^ASDUT,9999999.07)
 ;
CV ;EP; intro text for CHeck-in/Unsched Appt/CR for today
 D ^XBCLS W !!?15,"CHECK-IN/UNSCHED APPT/CR FOR TODAY",!!
 W !?5,"Use this option to perform any one of these functions:"
 W !?5,"  > Check-in a patient for a scheduled appointment;"
 W !?5,"  > Make an unscheduled appointment for a walk-in;"
 W !?5,"  > Ask for a chart to be pulled for review today."
 W !?5,"       (use if you need chart now; otherwise use CR)",!
 Q
DA ;EP; intro text for Display Appt
 D ^XBCLS W !!?20,"DISPLAY PATIENT'S APPOINTMENTS",!!
 W !?5,"Use this option to view a specific patient's past and/or"
 W !?5,"future appointments.  You are also given the opportunity"
 W !?5,"to print the list to paper.",!
 Q
 ;
MB ;EP; intro text for Multi Appt Booking
 D ^XBCLS W !!?20,"MULTIPLE APPOINTMENT BOOKING",!!
 W !?5,"Use this option to make a series of multiple daily or weekly"
 W !?5,"appointments to a clinic for a specific patient.",!
 Q
 ;
MC ;EP; intro tedxt for Multi Clinic Booking
 D ^XBCLS W !!?20,"MULTIPLE CLINIC DISPLAY/BOOKING",!!
 W !?5,"Use this option to make appointments in up to 4 clinics for"
 W !?5,"a patient within the same day.  The option will automatically"
 W !?5,"find the day all clinics you've specified have appointments"
 W !?5,"available.",!
 Q
 ;
MD ;EP; intro text for Month-at-a-glance
 D ^XBCLS W !!?20,"MONTH-AT-A-GLANCE DISPLAY",!!
 W !?5,"Use this option to display on your screen or print to paper"
 W !?5,"a snapshot of the appointment schedule for a particular"
 W !?5,"clinic.",!
 Q
 ;
OI ;EP; intro text for Add/Edit Other Info
 D ^XBCLS W !!?20,"ADD/EDIT OTHER INFO ON PENDING APPTS",!!
 W !?5,"Use the option to add to or change the ""Other Information"" "
 W !?5,"section of a patient's pending appointment.",!
 Q
 ;
PR ;EP; intro text for Pat Mini-Registration
 D ^XBCLS W !!?20,"PATIENT MINI-REGISTRATION",!!
 W !?5,"Use this option to temporarily register a new patient who"
 W !?5,"needs a clinic appointment.  The eligibility status will be"
 W !?5,"set to ""Pending Verification"" until the patient arrives for"
 W !?5,"the appointment and is assigned an official chart number.",!
 K DIR S DIR(0)="E" D ^DIR K DIR I X=U S XQUIT=1
 Q
 ;
PREND ;EP; called to clean up variables for pat mini reg
 K AG,AGDTS,AGOPT,AGE,AGDOG,DOG,DFN,DR,DIC,SEX,SSN Q
 ;
NS ;EP; intro text for no-shows
 D ^XBCLS W !!?25,"NO-SHOWS",!!
 W !?5,"Use this option to record your clinic's no-shows by date."
 W !?5,"You are also given the opportunity to print no-show letters"
 W !?5,"now, if desired.  There is also an option to print no-show"
 W !?5,"letters on the Reports Menu.",!
 Q
 ;
WL ;EP; intro text for Waiting list edit
 D ^XBCLS W !!?20,"WAITING LIST ENTER/EDIT",!!
 W !?5,"Use this option to enter patients into a waiting list for"
 W !?5,"selected clinics.  Any active clinic can be used.  You will"
 W !?5,"be asked to set a priority for each patient.  There is also"
 W !?5,"a comments section.  The Reports Menu has an option to print"
 W !?5,"out the waiting lists.",!
 Q
