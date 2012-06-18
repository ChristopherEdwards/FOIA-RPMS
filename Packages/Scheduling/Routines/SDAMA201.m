SDAMA201 ;BPOIFO/ACS-Scheduling Replacement APIs ;03 July 2003
 ;;5.3;Scheduling;**253,275,283**;13 Aug 1993
 ;
 ;GETAPPT  - Returns appointment information for a patient
 ;NEXTAPPT - Returns next appointment information for a patient
 ;
 ;**   BEFORE USING THE APIS IN THIS ROUTINE, PLEASE SUBSCRIBE   **
 ;**   TO DBIA #3859                                             **
 ;
 ;*****************************************************************
 ;              CHANGE LOG
 ;
 ;  DATE      PATCH       DESCRIPTION
 ;--------  ----------    -----------------------------------------
 ;09/20/02  SD*5.3*253    ROUTINE COMPLETED
 ;12/10/02  SD*5.3*275    ADDED PATIENT STATUS FILTER
 ;07/03/03  SD*5.3*283    REMOVED 'NO ACTION TAKEN' EDIT
 ;
 ;*****************************************************************
GETAPPT(SDPATIEN,SDFIELDS,SDAPSTAT,SDSTART,SDEND,SDRESULT,SDIOSTAT) ;
 ;*****************************************************************
 ;
 ;               GET APPOINTMENTS FOR PATIENT
 ;
 ;INPUT
 ;  SDPATIEN     Patient IEN (required)
 ;  SDFIELDS     Fields requested (optional)
 ;  SDAPSTAT     Appointment Status Filter (optional)
 ;  SDSTART      Start date/time (optional)
 ;  SDEND        End date/time (optional)
 ;  SDRESULT     Record count returned here (optional)
 ;  SDIOSTAT     Patient Status filter (optional)
 ;  
 ;OUTPUT
 ;  ^TMP($J,"SDAMA201","GETAPPT",X,Y)=FieldYdata
 ;  where "X" is an incremental appointment counter and
 ;  "Y" is the field number requested
 ;  
 ;*****************************************************************
 N SDAPINAM,SDRTNNAM
 S SDAPINAM="GETAPPT",SDRTNNAM="SDAMA201",SDRESULT=0
 K ^TMP($J,SDRTNNAM,SDAPINAM)
 S SDRESULT=$$VALIDATE^SDAMA200(.SDPATIEN,.SDFIELDS,.SDAPSTAT,.SDSTART,.SDEND,SDAPINAM,SDRTNNAM,.SDIOSTAT)
 I SDRESULT=-1 Q
 ;
 ;if the patient has no appointments on ^DPT, quit and pass back 0
 I '$$PATAPPT^SDAMA200(SDPATIEN) S SDRESULT=0
 Q:SDRESULT=0
 ;
 ;Set up start and end date/times
 S SDSTART=$S($G(SDSTART):(SDSTART-.0001),1:0)
 S SDEND=$S($G(SDEND):SDEND,1:"9999999.9999")
 I SDEND'["." S SDEND=SDEND_".9999"
 ;
 ;IF RSA DATABASE AVAILABLE, GET APPOINTMENT DATA FROM RSA DATABASE
 ;I $$GOTS^SDAMA100(SDRTNNAM,SDAPINAM) D  Q SDRESULT
 ;. ;Insert GOTS code here...
 ;. Q
 ;
 ;GET PATIENT APPOINTMENT DATA ON VISTA
 N SDAPPTDT,SDPIECE,SDRECNUM,SDFIELD,SDDATA,SDMCODE,SDMATCH,SDCLIEN,SDPATCNT,SDNEXT,SDI,SDASTAT,SDPSTAT
 S (SDPIECE,SDRECNUM,SDAPPTDT,SDFIELD,SDI)=0,SDAPPTDT=SDSTART,SDDATA="",SDMCODE=""
 ;Spin through each appointment on the PATIENT file
 F SDI=1:1 S SDAPPTDT=$O(^DPT(SDPATIEN,"S",SDAPPTDT)) Q:$S(+$G(SDAPPTDT)=0:1,SDAPPTDT>SDEND:1,1:0)  D
 . S SDNEXT=0
 . ;Get appt status and patient status
 . S SDASTAT=$$GETASTAT^SDAMA200(SDPATIEN,SDAPPTDT)
 . S SDPSTAT=$$GETPSTAT^SDAMA200(SDPATIEN,SDAPPTDT)
 . ;apply patient status filter
 . I SDIOSTAT'[SDPSTAT S SDNEXT=1
 . Q:SDNEXT=1
 . ;apply appointment status filter
 . I SDAPSTAT'[(";"_SDASTAT_";") S SDNEXT=1
 . Q:SDNEXT=1
 . ;set patient status to null if appointment status is No-Show, Cancelled, or NT
 . I ";N;C;NT;"[(";"_SDASTAT_";") S SDPSTAT=""
 . ;-- valid appointment has been found --
 . ;get clinic IEN, SDDA node, and increment the appointment count
 . S SDCLIEN=$$GETCLIEN^SDAMA200(SDPATIEN,SDAPPTDT)
 . S SDPATCNT=$$GETSDDA^SDAMA200(SDCLIEN,SDAPPTDT,SDPATIEN)
 . S SDRECNUM=SDRECNUM+1
 . ;spin through the requested field numbers
 . F SDPIECE=1:1 S SDFIELD=$P($G(SDFIELDS),";",SDPIECE) Q:SDFIELD=""  D
 .. ;get MUMPS code for the requested field number. Execute. Put result in ^TMP
 .. S SDMCODE=$G(^SDAM(44.3,SDFIELD,1)) X SDMCODE
 .. ;put resulting data in ^TMP global
 .. S ^TMP($J,SDRTNNAM,SDAPINAM,SDRECNUM,SDFIELD)=$G(SDDATA)
 ;clean up data map variable
 K SDDATA
 ; set output record count and quit
 S SDRESULT=SDRECNUM
 Q
 ;
NEXTAPPT(SDPATIEN,SDFIELDS,SDAPSTAT,SDIOSTAT) ;
 ;*****************************************************************
 ;
 ;               GET NEXT APPOINTMENT FOR PATIENT
 ;
 ; This API should be called with an EXTRINISIC call.  It will
 ; return "-1" if an error occurs, "1" if a future appointment
 ; exists, or "0" if no future appointment exists.  If the user
 ; enters field numbers into the optional SDFIELDS parameter and a
 ; next appointment is found, the requested fields for that next
 ; appointment will be retrieved and put into: 
 ; ^TMP($J,"SDAMA201","NEXTAPPT")
 ;
 ;INPUT
 ;  SDPATIEN     Patient IEN (required)
 ;  SDFIELDS     Fields requested (optional)
 ;  SDAPSTAT     Appointment status filter (optional)
 ;  SDIOSTAT     Patient status filter (optional)
 ;
 ;OUTPUT
 ;  -1: error
 ;   0: no future appointment
 ;   1: future appointment exists
 ;
 ;  If "1" is returned and the user has requested fields in the 
 ;  SDFIELDS  parameter, the following global is populated:
 ;  ^TMP($J,"SDAMA201","NEXTAPPT",Y)=FieldYdata
 ;  where "Y" is the field number requested
 ;  
 ;*****************************************************************
 N SDAPINAM,SDRTNNAM,SDERRFLG,SDSTART,SDRESULT
 S SDAPINAM="NEXTAPPT",SDRTNNAM="SDAMA201",SDRESULT=0,SDERRFLG=0
 K ^TMP($J,SDRTNNAM,SDAPINAM)
 ;
 ;Validate input parameters
 S SDRESULT=$$VALIDATE^SDAMA200(.SDPATIEN,.SDFIELDS,.SDAPSTAT,,,SDAPINAM,SDRTNNAM,.SDIOSTAT)
 I SDRESULT=-1 Q -1
 ;
 ;if the patient has no appointments on ^DPT, quit and pass back 0
 I '$$PATAPPT^SDAMA200(SDPATIEN) S SDRESULT=0 Q SDRESULT
 ;
 ;Get current date
 S SDSTART=+DT_".9999"
 ;
 ;IF RSA DATABASE AVAILABLE, GET APPOINTMENT DATA FROM RSA DATABASE
 ;I $$GOTS^SDAMA100(SDRTNNAM,SDAPINAM) D  Q SDRESULT
 ;. ;Insert GOTS code here...
 ;. Q
 ;
 ;GET NEXT APPOINTMENT DATA ON VISTA
 N SDAPPTDT,SDPIECE,SDFIELD,SDDATA,SDMCODE,SDFOUND,SDMATCH,SDASTAT,SDNEXT,SDPSTAT
 S (SDPIECE,SDAPPTDT,SDFIELD,SDFOUND,SDNEXT)=0,SDAPPTDT=SDSTART,SDDATA="",SDMCODE=""
 ;get next appointment
 F  S SDAPPTDT=$O(^DPT(SDPATIEN,"S",SDAPPTDT)) D  Q:((+$G(SDAPPTDT)=0)!SDFOUND)
 . Q:$G(SDAPPTDT)=""
 . S SDNEXT=0
 . ;Get appointment status and patient status
 . S SDASTAT=$$GETASTAT^SDAMA200(SDPATIEN,SDAPPTDT)
 . S SDPSTAT=$$GETPSTAT^SDAMA200(SDPATIEN,SDAPPTDT)
 . ;apply patient status filter
 . I SDIOSTAT'[SDPSTAT S SDNEXT=1
 . Q:SDNEXT=1
 . ;apply appointment status filter
 . I SDAPSTAT'[(";"_SDASTAT_";") S SDFOUND=0,SDNEXT=1
 . Q:SDNEXT=1
 . S SDFOUND=1
 ;
 ;If an appt was found and the user wants data returned, get fields requested
 I SDFOUND,$G(SDFIELDS) D
 . ;set patient status to null if appointment status is No-Show, Cancelled, or NT
 . I ";N;C;NT;"[(";"_SDASTAT_";") S SDPSTAT=""
 . ;get clinic IEN and SDDA node; used when retrieving appt fields located on ^SC
 . S SDCLIEN=$$GETCLIEN^SDAMA200(SDPATIEN,SDAPPTDT)
 . S SDPATCNT=$$GETSDDA^SDAMA200($G(SDCLIEN),SDAPPTDT,SDPATIEN)
 . ;spin through the requested field numbers
 . F SDPIECE=1:1 S SDFIELD=$P($G(SDFIELDS),";",SDPIECE) Q:SDFIELD=""  D
 .. ;get MUMPS code for the requested field number. Execute. Put result in ^TMP
 .. S SDMCODE=$G(^SDAM(44.3,SDFIELD,1)) X SDMCODE
 .. S ^TMP($J,SDRTNNAM,SDAPINAM,SDFIELD)=$G(SDDATA)
 .. Q
 . Q
 ;clean up data map variable
 K SDDATA
 Q SDFOUND
