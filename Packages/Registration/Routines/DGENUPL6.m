DGENUPL6 ;ISA/KWP - PROCESS INCOMING (Z11 EVENT TYPE) HL7 MESSAGES ; 05/07/99
 ;;5.3;REGISTRATION;**232**;Aug 13,1993
 ;Phase II Process EGT Consistency Checks before uploading (SRS 6.5.1.3)
 ;
CHECK(ERRMSG) ;
 ;Description: Check the enrollment record received from HEC
 ;against the current EGT setting,setting type and effective date.
 ;Input:
 ;  ERRMSG -passed by reference, if 0 is returned(EGT checks fail) then the ERRMSG "THE ENROLLMENT RECORD DID NOT PASS THE EGT CONSISTENCY CHECKS" is also returned
 ;  DGENR -Enrollment array
 ;Output:
 ; if did not pass (1-5) then return error message
 ;Returns
 ; 1 if no current EGT settings
 ; 0 if the EGT checks fail
 ; 2 Enrollment Category of Enrolled (E),status of Verified (2), priority above the current EGT and the enrollment end date is null
 ; 3 Enrollment category of "NOT ENROLLED", status of "Rejected - Fiscal Year", and a priority below the current EGT, and an EGT type of Fiscal Year Change, or "Stop New Enrollments", and enrollment end date > = to the EGT effective date.
 ; 4 Enrollment category of "NOT ENROLLED",status of "Rejected - Mid-Cycle", and priority below the current EGT, and EGT type of Fiscal Year Change, "Mid-Cycle Change", or "Stop New Enrollments", and enrollment end >= to the EGT effective date.
 ; 5 An Enrollment Category of "NOT ENROLLED"; and an enrollment status of "Rejected-Stop Enrolling New Applicants"; and an enrollment priority below the Enrollment Group Threshold (EGT) value; and an EGT setting type of
 ;   (2) "Stop New Enrollments During Cycle"; and an enrollment end date >=to the effective date and equal to the application date
 ;
 S ERRMSG=""
 ;get current EGT settings If no current EGT settings return success
 I '$$GET^DGENEGT($$FINDCUR^DGENEGT,.DGEGT) Q 1
 ;
 ;get category for status
 N DGENCAT
 S DGENCAT=$$CATEGORY^DGENA4(,DGENR("STATUS"))
 ;
 ;The following 4 conditions must be met to return success
 ;a) Enrollment Category of Enrolled (E),status of Verified (2), priority above the current EGT and the enrollment end date is null
 I DGENCAT="E",DGENR("STATUS")=2,$$ABOVE^DGENEGT1(DGENR("PRIORITY"),DGENR("SUBGRP"),DGEGT("PRIORITY"),DGEGT("SUBGRP")),DGENR("END")="" Q 2
 ;
 ;b) Enrollment category of "NOT ENROLLED", status of "Rejected - Fiscal Year", and a priority below the current EGT, and an EGT type of Fiscal Year Change, or "Stop New Enrollments", and enrollment end date > = to the EGT effective date.
 I DGENCAT="N",DGENR("STATUS")=11,'$$ABOVE^DGENEGT1(DGENR("PRIORITY"),DGENR("SUBGRP"),DGEGT("PRIORITY"),DGEGT("SUBGRP")),DGEGT("TYPE")<3,(DGENR("END")+1)>DGEGT("EFFDATE") Q 3
 ;
 ;c) Enrollment category of "NOT ENROLLED",status of "Rejected - Mid-Cycle", and priority below the current EGT, and EGT type of Fiscal Year Change, "Mid-Cycle Change", or "Stop New Enrollments", and enrollment end >= to the 
 ;EGT effective date.-
 I DGENCAT="N",DGENR("STATUS")=12,'$$ABOVE^DGENEGT1(DGENR("PRIORITY"),DGENR("SUBGRP"),DGEGT("PRIORITY"),DGEGT("SUBGRP")),DGEGT("TYPE"),(DGENR("END")+1)>DGEGT("EFFDATE") Q 4
 ;
 ;d) An Enrollment Category of "NOT ENROLLED"; and an enrollment status of "Rejected-Stop Enrolling New Applicants"; and an enrollment priority below the Enrollment Group Threshold (EGT) value; and an EGT setting type of
 ;(2) "Stop New Enrollments During Cycle"; and an enrollment end date >= to the effective date and equal to the application date
 N DGRESVAL
 I DGENCAT="N",DGENR("STATUS")=13 S DGRESVAL=0 D  I DGRESVAL Q 5
 .I '$$ABOVE^DGENEGT1(DGENR("PRIORITY"),DGENR("SUBGRP"),DGEGT("PRIORITY"),DGEGT("SUBGRP")),DGEGT("TYPE")=2,(DGENR("END")+1)>DGEGT("EFFDATE"),$P(DGENR("END"),".")=$P(DGENR("APP"),".") S DGRESVAL=1
 ;
 ; return failure because a-d checks were not meet
EXIT S ERRMSG="THE ENROLLMENT RECORD DID NOT PASS THE EGT CONSISTENCY CHECKS."
 Q 0
