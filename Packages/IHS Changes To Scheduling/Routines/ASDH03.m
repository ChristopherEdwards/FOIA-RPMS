ASDH03 ; IHS/ADC/PDW/ENM - MORE INTRO TEXT FOR RPTS ; [ 03/25/1999  11:48 AM ]
 ;;5.0;IHS SCHEDULING;;MAR 25, 1999
 ;
NE ;EP; intro text for next avail appt by prin clinic
 D ^XBCLS W !!?15,"NEXT AVAILABLE APPOINTMENT by PRINCIPAL CLINIC",!!
 W !?5,"Use this option to print a listing of active clinics, sorted"
 W !?5,"by principal clinic, noting the number of days until an"
 W !?5,"appointment is available.",!
 Q
 ;
NU ;EP; intro text for number of avail appts listing
 D ^XBCLS W !!?15,"NUMBER OF AVAILABLE APPOINTMENTS LISTING",!!
 W !?5,"Use this option to view the number of available appointments"
 W !?5,"within each clinic for each day of the next 2 weeks.  The"
 W !?5,"listing is sorted by principal clinic and identifies each"
 W !?5,"clinic by abbreviation.",!
 Q
 ;
AB ;EP; intro text for clinic abbreviations listing
 D ^XBCLS W !!?20,"LIST CLINIC ABBREVIATIONS",!!
 W !?5,"Use this option to print out a list of active clinics sorted"
 W !?5,"by their abbreviations.  This will help decipher reports with"
 W !?5,"only enough room to print the abbreviations instead of the full"
 W !?5,"clinic name.  It also helps you check for the use of duplicate"
 W !?5,"abbreviations.",!
 Q
 ;
FN ;EP; intro text for find next appointment
 D ^XBCLS W !!?20,"FIND NEXT AVAILABLE APPOINTMENT",!!
 W !?5,"Use this option to find the next appointment slot open in"
 W !?2,"a selected clinic within the date range you specify."
 W !?5,"You will also be asked for the appointment length.  The"
 W !?5,"schedule for the day with this open appointment displays"
 W !?5,"to your screen in the same format as month-at-a-glance.",!
 Q
 ;
PL ;EP;  intro text for print letters options
 D ^XBCLS W !!?20,"PRINT SCHEDULING LETTERS",!!
 W !?5,"Use this option to print various appointment letters for"
 W !?5,"your clinics.  These include Pre-Appointment letters,"
 W !?5,"Cancellation letters, or No-show letters",!!
 Q
