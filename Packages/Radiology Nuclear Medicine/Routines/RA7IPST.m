RA7IPST ;HIRMFO/GJC - Post-init Driver patch seven ;02/01/99  08:04
VERSION ;;5.0;Radiology/Nuclear Medicine;**7**;Mar 16, 1998
 Q:'$D(XPDNM)  ; must be in KIDS to run this software
EN1 ; This entry point will accomplish two tasks.  The first task
 ; will copy all of the ^RADPT("C" cross reference to the newly
 ; created ^RADPT("AE" cross reference.  The new data dictionary
 ; for the Exam Status (#3) field on the Examinations sub-file
 ; (#70.03) has the new "AE" cross reference logic defined.
 Q:'$D(XPDNM)  ; must be in KIDS to run this software
 M ^RADPT("AE")=^RADPT("C")
 K ^RADPT("C") ; kill off the old "C" cross reference
 Q
