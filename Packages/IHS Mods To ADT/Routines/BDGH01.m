BDGH01 ; IHS/ANMC/LJF - INTRO TEXT FOR ADT MENU ;
 ;;5.3;PIMS;;APR 26, 2002
 ;
 Q
 ;
PI ;EP; intro text for patient inquiry
 NEW BDGX
 S BDGX(1)="Use this option to view basic data about a patient.  It"
 S BDGX(2)="includes some demographics, the patient's last admission,"
 S BDGX(3)="last day surgery, scheduled visits, future appointments,"
 S BDGX(4)="and the paper chart's status (incomplete or not).  For each"
 S BDGX(5)="section with data, you can expand it for more details."
 D DISPLAY(5)
 Q
 ;
PV ;EP; intro text for provider inquiry
 NEW BDGX
 S BDGX(1)="This option is designed to be used by physicians to view"
 S BDGX(2)="current inpatients, today's surgeries and appointments. You"
 S BDGX(3)="will be asked to select a provider and sort option. An"
 S BDGX(4)="expanded view of each patient encounter is also available."
 D DISPLAY(4)
 Q
 ;
DISPLAY(N) ; -- display array with N lines
 S BDGX(1,"F")="!!!?5"
 F I=2:1:N S BDGX(I,"F")="!?5"
 S BDGX(N+1,"F")="!!"
 D EN^DDIOL(.BDGX)
 D VAR^BDGVAR     ;makes all options able to run independently
 Q
