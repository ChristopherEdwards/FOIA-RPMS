SDAMA202 ;BPOIFO/ACS-Scheduling Replacement APIs ;03 July 2003
 ;;5.3;Scheduling;**253,275,283**;13 Aug 1993
 ;
 ;GETPLIST - Returns appointment information for a clinic
 ;
 ;**   BEFORE USING THE API IN THIS ROUTINE, PLEASE SUBSCRIBE      **
 ;**   TO DBIA #3869                                               **
 ;
 ;*******************************************************************
 ;              CHANGE LOG
 ;
 ;  DATE      PATCH       DESCRIPTION
 ;--------  ----------    -----------------------------------------
 ;09/20/02  SD*5.3*253    ROUTINE COMPLETED
 ;12/10/02  SD*5.3*275    ADDED PATIENT STATUS FILTER
 ;07/03/03  SD*5.3*283    REMOVED 'NO ACTION TAKEN' EDIT.  REMOVED
 ;                        'GETALLCL' API
 ;
 ;********************************************************************  
 ;
GETPLIST(SDCLIEN,SDFIELDS,SDAPSTAT,SDSTART,SDEND,SDRESULT,SDIOSTAT) ;
 ;********************************************************************
 ;
 ;               GET APPOINTMENTS FOR A CLINIC
 ;
 ;INPUT
 ;  SDCLIEN      Clinic IEN (required) 
 ;  SDFIELDS     Fields requested (optional)
 ;  SDAPSTAT     Appointment Status filter (optional)
 ;  SDSTART      Start date/time (optional)
 ;  SDEND        End date/time (optional)
 ;  SDRESULT     Record count returned here (optional)
 ;  SDIOSTAT     Patient Status filter (optional)
 ;  
 ;OUTPUT
 ;  ^TMP($J,"SDAMA202","GETPLIST",X,Y)=FieldYdata
 ;  where "X" is an incremental appointment counter and
 ;  "Y" is the field number requested
 ;  
 ;
 ;********************************************************************
 N SDAPINAM,SDRTNNAM
 S SDAPINAM="GETPLIST",SDRTNNAM="SDAMA202",SDRESULT=0
 K ^TMP($J,SDRTNNAM,SDAPINAM)
 S SDRESULT=$$VALIDATE^SDAMA200(.SDCLIEN,.SDFIELDS,.SDAPSTAT,.SDSTART,.SDEND,SDAPINAM,SDRTNNAM,.SDIOSTAT)
 I SDRESULT=-1 Q
 ;
 ;if the clinic has no appointments on ^SC, quit
 I '$$CLNAPPT^SDAMA200(SDCLIEN) S SDRESULT=0 Q
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
 N SDAPPTDT,SDPIECE,SDRECNUM,SDFIELD,SDDATA,SDPATCNT,SDMCODE,SDPATIEN,SDNEXT,SDASTAT,SDPSTAT
 S (SDPIECE,SDRECNUM,SDAPPTDT,SDFIELD,SDPATCNT,SDNEXT)=0,SDDATA="",SDMCODE=""
 S SDRECNUM=0
 S SDAPPTDT=SDSTART
 ; find each appointment date/time for this clinic
 F  S SDAPPTDT=$O(^SC(SDCLIEN,"S",SDAPPTDT)) Q:$S(+$G(SDAPPTDT)=0:1,SDAPPTDT>SDEND:1,1:0)  D
 . ;find all patients in this clinic for this appointment date/time
 . S SDPATCNT=0
 . F  S SDPATCNT=$O(^SC(SDCLIEN,"S",SDAPPTDT,1,SDPATCNT)) Q:SDPATCNT=""  D
 .. S SDNEXT=0
 .. S SDPATIEN=$$GETPTIEN^SDAMA200(SDCLIEN,SDAPPTDT,SDPATCNT)
 .. ;Get appt status and patient status
 .. S SDASTAT=$$GETASTAT^SDAMA200(SDPATIEN,SDAPPTDT)
 .. S SDPSTAT=$$GETPSTAT^SDAMA200(SDPATIEN,SDAPPTDT)
 .. ;apply patient status filter
 .. I SDIOSTAT'[SDPSTAT S SDNEXT=1
 .. Q:SDNEXT=1
 .. ;apply appointment status filter
 .. I SDAPSTAT'[(";"_SDASTAT_";") S SDNEXT=1
 .. Q:SDNEXT=1
 .. ;set patient status to null if appointment status is No-Show, Cancelled, or NT
 .. I ";N;C;NT;"[(";"_SDASTAT_";") S SDPSTAT=""
 .. S SDRECNUM=SDRECNUM+1
 .. ;spin through the requested field numbers
 .. F SDPIECE=1:1 S SDFIELD=$P(SDFIELDS,";",SDPIECE) Q:SDFIELD=""  D
 ... ;get MUMPS code for the requested field number. Execute. Put result in ^TMP
 ... S SDMCODE=$G(^SDAM(44.3,SDFIELD,1)) X SDMCODE
 ... S ^TMP($J,SDRTNNAM,SDAPINAM,SDRECNUM,SDFIELD)=$G(SDDATA)
 ... Q
 .. Q
 . Q
 ;clean up data map variable and pass back appointment count
 K SDDATA
 S SDRESULT=SDRECNUM
 Q
