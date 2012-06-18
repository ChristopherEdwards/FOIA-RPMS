BDGH02 ; IHS/ANMC/LJF - INTRO TEXT FOR BED CONTROL MENU ; 
 ;;5.3;PIMS;;APR 26, 2002
 ;
 Q
ADM ;EP; intro text for admit a patient
 NEW BDGX
 S BDGX(1)="Use this option to admit a patient to your facility to"
 S BDGX(2)="inpatient or observation status.  The treating specialty"
 S BDGX(3)="you select will determine the status.  You may also use"
 S BDGX(4)="this option to change admission data entered in error BUT"
 S BDGX(5)="only if the patient has not yet been discharged."
 D DISPLAY(5)
 Q
 ;
DID ;EP; intro text for detailed inpatient display
 NEW BDGX
 S BDGX(1)="Use this option to view all the patient movements, service"
 S BDGX(2)="transfers and provider changes for a particular admission."
 S BDGX(3)="Bed switches within wards only show the last entry."
 D DISPLAY(3)
 Q
 ;
DSC ;EP; intro text for discharge a patient
 NEW BDGX
 S BDGX(1)="Use this option to release an inpatient or observation"
 S BDGX(2)="patient from your facility.  You will be asked for IHS"
 S BDGX(3)="discharge type, disposition code, transfer facility, if"
 S BDGX(4)="appropriate, and discharge provider."
 D DISPLAY(4)
 Q
 ;
EBC ;EP; intro text for extended bed control
 NEW BDGX
 S BDGX(1)="Use this option to edit any past admission, transfer or"
 S BDGX(2)="discharge.  You will not be able to edit any item older"
 S BDGX(3)="than "_(+$$GET1^DIQ(9009020.1,$$DIV^BSDU,.02))_" days.  "
 S BDGX(3)=BDGX(3)_"To correct older items, please contact"
 S BDGX(4)="your application coordinator."
 D DISPLAY(4)
 Q
 ;
PCH ;EP; intro text for provider change
 NEW BDGX
 S BDGX(1)="Use this option to change the provider's primary provider"
 S BDGX(2)="and/or attending provider during an inpatient stay.  Use"
 S BDGX(3)="this option when a change of provider is NOT accompanied"
 S BDGX(4)="by a treating specialty transfer."
 D DISPLAY(4)
 Q
 ;
SIE ;EP; intro text for seriously ill list
 NEW BDGX
 S BDGX(1)="Use this option to designate certain patients as seriously"
 S BDGX(2)="ill or DNR (do not resusitate) or both.  Facilities using"
 S BDGX(3)="TIU may prefer to use the CWAD function to designate DNR"
 S BDGX(4)="patients.  Some wards may be set up to automatically set"
 S BDGX(5)="their patients as Seriously Ill."
 D DISPLAY(5)
 Q
 ;
SWB ;EP; intro text for switch bed
 NEW BDGX
 S BDGX(1)="Use this option to transfer the patient to another room-bed"
 S BDGX(2)="without a change in ward location."
 D DISPLAY(2)
 Q
 ;
TTX ;EP; intro text for treating specialty transfer
 NEW BDGX
 S BDGX(1)="Use this option to change a patient's treating specialty"
 S BDGX(2)="without a corresponding change in physical location.  You"
 S BDGX(3)="will also be asked if the provider changed."
 D DISPLAY(3)
 Q
 ;
WTX ;EP; intro text for ward transfer     
 NEW BDGX
 S BDGX(1)="Use this option to transfer an inpatient or an observation"
 S BDGX(2)="patient to another ward.  If the patient's provider or"
 S BDGX(3)="treating specialty also changes, you will be prompted to"
 S BDGX(4)="enter that also.  An observation patient transferred to an"
 S BDGX(5)="inpatient service, will be become an inpatient."
 D DISPLAY(5)
 Q
 ;
DISPLAY(N) ; -- display array with N lines
 S BDGX(1,"F")="!!!?5"
 F I=2:1:N S BDGX(I,"F")="!?5"
 S BDGX(N+1,"F")="!!"
 D EN^DDIOL(.BDGX)
 D VAR^BDGVAR      ;makes all optins able to run independently
 Q
