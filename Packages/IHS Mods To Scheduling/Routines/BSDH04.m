BSDH04 ; IHS/ANMC/LJF - INTRO TEXT 4 APP COORD MENU ; 
 ;;5.3;PIMS;;APR 26, 2002
 ;
ACR ;EP; intro text for Add Cancellation Reasons
 NEW BSDX
 S BSDX(1)="Use this option to add cancellation reasons.  Deleting"
 S BSDX(2)="reasons is not allowed; make them inactive.  A sample set"
 S BSDX(3)="of reasons was installed but you may create those fitting"
 S BSDX(4)=" to your facility."
 D DISPLAY(4)
 Q
 ;
AEH ;EP; intro text for add/edit holiday
 NEW BSDX
 S BSDX(1)="Use this option to add holidays to the Scheduling calendar."
 S BSDX(2)="If you are adding or changing a holiday that will affect"
 S BSDX(3)="the availability of clinic schedules already set up,"
 S BSDX(4)="remember to use the option REMAP CLINICS."
 D DISPLAY(4)
 Q
 ;
AWR ;EP; intro text for Add Waiting List Reasons
 NEW BSDX
 S BSDX(1)="Use this option to add reasons patients are placed on"
 S BSDX(2)="a waiting list. Deleting reasons is not allowed; make"
 S BSDX(3)="them inactive.  A sample set of reasons was installed"
 S BSDX(4)="but you may create those whic are more appropriate for"
 S BSDX(5)="your facility."
 D DISPLAY(5)
 Q
 ;
CHG ;EP; intro text for Convert Patterns to 30-60
 NEW BSDX
 S BSDX(1)="Use this option to change the patterns created using 15"
 S BSDX(2)="minute increments to 30 or 60 minute time slot patterns."
 D DISPLAY(2)
 Q
 ;
CVS ;EP; intro text for Create Visit Status Report
 NEW BSDX
 S BSDX(1)="Use this report to review whether clinics have 'Create"
 S BSDX(2)="Visit at Check-in' turned on or not.  It lists those"
 S BSDX(3)="clinics with the parameter turned OFF first sorted by"
 S BSDX(4)="principal clinic.  All clinics on the list are active."
 D DISPLAY(4)
 Q
 ;
ESP ;EP; intro text for Edit Scheduling Parameters
 NEW BSDX
 S BSDX(1)="Use this option to set up and maintain facility and system"
 S BSDX(2)="parameters dealing with the Scheduling functions in PIMS."
 S BSDX(3)="There are 3 files involved. The MAS Parameter file has only"
 S BSDX(4)="one entry and is used for system-wide items such as multi-"
 S BSDX(5)="division yes/no and appointment search threshold. All other"
 S BSDX(6)="parameters are based on facility and stored in either the"
 S BSDX(7)="Medical Center Division or the IHS Scheduling Parameter file."
 D DISPLAY(7)
 Q
 ;
 S BSDX(8)="file."
 D DISPLAY(8)
 Q
 ;
IRC ;EP; intro text for inactivate/rectivate clinic
 NEW BSDX
 S BSDX(1)="Choose INACTIVATE to render a clinic inactive (no activity)"
 S BSDX(2)="allowed) as of a selected date.  Choose REACTIVATE to set"
 S BSDX(3)="the date from which point the inactivation of a clinic is"
 S BSDX(4)="terminated."
 S BSDX(5)=""
 S BSDX(6)="For INACTIVE clinics, you may want to change the clinic"
 S BSDX(7)="name, remove the abbreviation and principal clinic link."
 S BSDX(8)="Use the Set Up A Clinic option to make those changes."
 D DISPLAY(8)
 Q
 ;
OVB ;EP; intro text for list overbook users
 NEW BSDX
 S BSDX(1)="Use this option to print a listing of all users holding the"
 S BSDX(2)="SDOB or SDMOB keys.  These keys give users overbook access"
 S BSDX(3)="to ALL clinics.  It is recommended that you keep this list"
 S BSDX(4)="short.  Assigning overbook access by individual clinic or"
 S BSDX(5)="by principal clinic is available under the Set Up a Clinic"
 S BSDX(6)="option."
 D DISPLAY(6),PAUSE^BDGF
 Q
 ;
RMC ;EP; intro text for remap clinic
 NEW BSDX
 S BSDX(1)="Use this option to remap one or more clinics. It is used"
 S BSDX(2)="primarily after adding a new holiday or deleting existing"
 S BSDX(3)="holidays.  It updates the appointment patterns to insert"
 S BSDX(4)="or delete the holiday on the schedule.  It must be run"
 S BSDX(5)="for each clinic which meets on the date of the holiday."
 D DISPLAY(5)
 Q
 ;
SCT ;EP; intro text for Scheduling Templates
 NEW BSDX
 S BSDX(1)="Use this option to add or edit scheduling appointment"
 S BSDX(2)="availability templates.  These templates are defined times"
 S BSDX(3)="and number of slots to make setting up clinic appointments"
 S BSDX(4)="much easier.  You can also use this option to view a list"
 S BSDX(5)="of templates already defined."
 D DISPLAY(5)
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
