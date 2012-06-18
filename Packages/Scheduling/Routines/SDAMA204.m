SDAMA204 ;BPOIFO/NDH-Scheduling Replacement APIs ;11 Aug 2003
 ;;5.3;Scheduling;**310**;13 Aug 1993
 ;
 ;**   BEFORE USING THE API IN THIS ROUTINE, PLEASE SUBSCRIBE    **
 ;**   TO DBIA #4216                                             **
 ;
 ;*****************************************************************
 ;              CHANGE LOG
 ;
 ;  DATE      PATCH       DESCRIPTION
 ;--------  ----------    -----------------------------------------
 ;08/11/03  SD*5.3*310    API PATIENT APPOINTMENT EXISTS
 ;
 ;*****************************************************************
 ;
PATAPPT(SDDFN) ; Check for existence of any appointment for a patient
 ; 
 ;       This API is an extrinsic function that returns 1 of 3 values.
 ;       The API checks for the existence of appointment records.
 ; 
 ;       INPUT    SDDFN : Patient's DFN number (required)
 ; 
 ;       OUTPUT       1 : Appointment(s) on file
 ;                    0 : No appointment(s) on file
 ;                   -1 : Error
 ;                   
 ; ERROR CODES - 101 : Database is Unavailable
 ;               102 : Patient ID is required
 ;               110 : Patient ID must be numeric
 ;               114 : Invalid Patient ID
 ; 
 ; ERROR LOCATION : ^TMP($J,"SDAMA204","PATAPPT","ERROR")
 ; 
 ; Check for proper parameter and return -1 if bad DFN
 ; 
 ; Initialize node for error reporting
 K ^TMP($J,"SDAMA204","PATAPPT")
 ; 
 ;IF RSA DATABASE AVAILABLE, GET APPOINTMENT DATA FROM RSA DATABASE
 ;I $$GOTS^SDAMA100(SDRTNNAM,SDAPINAM) D  Q SDRESULT
 ;. ;Insert GOTS code here...
 ;. Q
 ; 
 ; Check for no input parameter
 I '$D(SDDFN) D  Q -1
 .D ERROR^SDAMA200(102,"PATAPPT",0,"SDAMA204")
 ; Check if SDDFN is numeric
 I SDDFN'?1.N D  Q -1
 .D ERROR^SDAMA200(110,"PATAPPT",0,"SDAMA204")
 ; Check if DFN exists or is 0
 S DFN=SDDFN
 D DEM^VADPT
 I SDDFN=0!VAERR=1 D  Q -1
 .D ERROR^SDAMA200(114,"PATAPPT",0,"SDAMA204")
 D KVAR^VADPT
 ; Check for patient appointments and return 1 if appointment found
 ; and 0 if no appointments found
 Q $$PATAPPT^SDAMA200(SDDFN)
 ;
