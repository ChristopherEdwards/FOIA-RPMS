BSDH03 ; IHS/ANMC/LJF - INTRO TEXT FOR SUPERVISOR MENU ;
 ;;5.3;PIMS;**1003,1013**;MAY 28, 2004
 ;IHS/ITSC/LJF 06/17/2005 PATCH 1003 fixed typo errors under CRA
 ;ihs/cmi/maw 05/03/2011 PATCH 1013 added wait list to EEL
 ;
CRA ;EP; intro text for Cancel/Restore Availability
 NEW BSDX
 S BSDX(1)="Use this option to either CANCEL or RESTORE a clinic's"
 S BSDX(2)="appointment slots."
 S BSDX(3)=""
 S BSDX(4)="You can CANCEL a clinic's availability for either a whole"
 S BSDX(5)="day or portion of a day.  If several portions of a day are"
 S BSDX(6)="to be canceled you must cancel one portion first, then select"
 S BSDX(7)="CANCEL again to cancel the second portion, etc."
 S BSDX(8)=""
 S BSDX(9)="You can RESTORE the availability for a previously canceled"
 S BSDX(10)="clinic.  Appointments that were rescheduled using the"
 S BSDX(11)="auto-rebook feature at the time of cancellation WILL NOT"
 S BSDX(12)="be moved to their original time slots."
 D DISPLAY(12)
 Q
 ;
DSU ;EP; intro text for Display Scheduling User
 NEW BSDX
 S BSDX(1)="Use this option to view a user's access level in the IHS"
 S BSDX(2)="Scheduling software.  It will list all major functions a"
 S BSDX(3)="user can perform based on security keys.  It will also list"
 S BSDX(4)="which restricted clinics the user can access and the user's"
 S BSDX(5)="overbook level."
 D DISPLAY(5)
 Q
 ;
EEL ;EP; intro text for Enter/Edit Letters
 NEW BSDX
 S BSDX(1)="Use this option to enter a new or edit an existing letter."
 S BSDX(2)="The letter types available are:"
 S BSDX(3)="  (A)ppointment Cancelled - appointment cancelled by Cancel"
 S BSDX(4)="                         Appointment action under Appt Mgt."
 S BSDX(5)="  (C)linic Cancelled - appointment cancelled by Cancel"
 S BSDX(6)="                         Clinic Availability option."
 S BSDX(7)="  (N)o-Show - reminder to patient who did not show, to make"
 S BSDX(8)="                         another appointment."
 S BSDX(9)="  (P)re-Appointment - reminder to patient of upcoming appt."
 S BSDX(10)="  (W)ait List - patient on wait list."
 D DISPLAY(10)
 Q
 ;
LAM ;EP; intro text to List Appt Made by Clinic
 NEW BSDX
 S BSDX(1)="Use this option to list all appointments scheduled for a"
 S BSDX(2)="date range, who made the appointment and when."
 S BSDX(3)=$$SP(25)_"OR"
 S BSDX(4)="Use this option to list who made appointments scheduled for"
 S BSDX(5)="a given date range, how many they made and their percentage"
 S BSDX(6)="of the total."
 D DISPLAY(6)
 Q
 ;
SET ;EP; intro text for Set Up A Clinic
 NEW BSDX
 S BSDX(1)="Use this option to create clinics, modify their parameters,"
 S BSDX(2)="and set up their appointment slots."
 D DISPLAY(2)
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
