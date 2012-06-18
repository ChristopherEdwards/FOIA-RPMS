PXRMMEAS ; SLC/PKR - Handle measurement findings. ;01/22/2002
 ;;1.5;CLINICAL REMINDERS;**2,8**;Jun 19, 2000
 ;
 ;=======================================================================
EVALFI(DFN,FIEVAL) ;Evaluate vitals/measurement findings.
 ;Use the most recent measurement.
 N FIND0,FIND3,FINDING,MTYPE
 S MTYPE=""
 F  S MTYPE=$O(^PXD(811.9,PXRMITEM,20,"E","GMRD(120.51,",MTYPE)) Q:+MTYPE=0  D
 . S FINDING=""
 . F  S FINDING=$O(^PXD(811.9,PXRMITEM,20,"E","GMRD(120.51,",MTYPE,FINDING)) Q:+FINDING=0  D
 .. S FIND0=^PXD(811.9,PXRMITEM,20,FINDING,0)
 .. S FIND3=$G(^PXD(811.9,PXRMITEM,20,FINDING,3))
 .. D FIEVAL(DFN,MTYPE,FIND0,FIND3,"","",FINDING,.FIEVAL)
 Q
 ;
 ;=======================================================================
EVALTERM(DFN,FINDING,TERMIEN,TFIEVAL) ;Evaluate vitals/measurement terms.
 ;Use the most recent measurement.
 N FIND0,FIND3,MTYPE,TFIND0,TFIND3,TFINDING
 S FIND0=^PXD(811.9,PXRMITEM,20,FINDING,0)
 S FIND3=$G(^PXD(811.9,PXRMITEM,20,FINDING,3))
 S MTYPE=""
 F  S MTYPE=$O(^PXRMD(811.5,TERMIEN,20,"E","GMRD(120.51,",MTYPE)) Q:+MTYPE=0  D
 . S TFINDING=""
 . F  S TFINDING=$O(^PXRMD(811.5,TERMIEN,20,"E","GMRD(120.51,",MTYPE,TFINDING)) Q:+TFINDING=0  D
 .. S TFIND0=^PXRMD(811.5,TERMIEN,20,TFINDING,0)
 .. S TFIND3=$G(^PXRMD(811.5,TERMIEN,20,TFINDING,3))
 .. D FIEVAL(DFN,MTYPE,FIND0,FIND3,TFIND0,TFIND3,TFINDING,.TFIEVAL)
 Q
 ;
 ;=======================================================================
FIEVAL(DFN,MTYPE,FIND0,FIND3,TFIND0,TFIND3,FINDING,FIEVAL) ;
 ;Use the most recent measurement.
 N ABBR,CONVAL,DATA,DATE,ERR,GMRVSTR,IC,IEN,INVDATE
 N MNAME,RATE,VALID
 K ^UTILITY($J,"GMRVD")
 ;Setup for the GMRVUT0 call.
 S ABBR=$$GET1^DIQ(120.51,MTYPE,1,"","","","ERR")
 S GMRVSTR=ABBR
 S GMRVSTR(0)=U_U_1_U_1
 D EN1^GMRVUT0
 ;Find the latest entry for this measurement type.
 I $D(^UTILITY($J,"GMRVD")) D
 . S (IEN,INVDATE)=""
 . S INVDATE=$O(^UTILITY($J,"GMRVD",INVDATE))
 . I INVDATE="" S FIEVAL(FINDING)=0
 . S IEN=$O(^UTILITY($J,"GMRVD",INVDATE,ABBR,IEN))
 . S DATA=^UTILITY($J,"GMRVD",INVDATE,ABBR,IEN)
 . S RATE=$P(DATA,U,8)
 E  S FIEVAL(FINDING)=0
 K ^UTILITY($J,"GMRVD")
 ;
 I $G(FIEVAL(FINDING))=0 Q
 S DATE=$P($G(DATA),U,1)
 ;Save the rest of the finding information.
 S FIEVAL(FINDING)=1
 S FIEVAL(FINDING,"DATE")=DATE
 S FIEVAL(FINDING,"FINDING")=MTYPE_";GMRD(120.51,"
 S FIEVAL(FINDING,"SOURCE")=IEN_";GMRV(120.5,"
 S FIEVAL(FINDING,"DATA")=DATA
 S FIEVAL(FINDING,"RATE")=RATE
 S FIEVAL(FINDING,"VALUE")=RATE
 ;If this is being called as part of a term evaluation we are done.
 I TFIND0'="" Q
 ;Determine if the finding has expired.
 S VALID=$$VALID^PXRMDATE(FIND0,TFIND0,DATE)
 I 'VALID D  Q
 . S FIEVAL(FINDING)=0
 . S FIEVAL(FINDING,"EXPIRED")=""
 ;If there is a condition for this finding evaluate it.
 S CONVAL=$$COND^PXRMUTIL(FIND3,TFIND3,RATE)
 I CONVAL'="" D
 . I CONVAL D
 .. S FIEVAL(FINDING)=CONVAL
 .. S FIEVAL(FINDING,"CONDITION")=CONVAL
 . E  D
 .. K FIEVAL(FINDING)
 .. S FIEVAL(FINDING)=0
 Q
 ;
 ;=======================================================================
OUTPUT(NLINES,TEXT,FINDING,FIEVAL) ;Produce the clinical
 ;maintenance output.
 N DATA,DATE,EM,FIEN,MNAME,MTYPE,RATE,TEMP
 S FIEN=$P(FIEVAL(FINDING,"FINDING"),";",1)
 S DATA=FIEVAL(FINDING,"DATA")
 S DATE=FIEVAL(FINDING,"DATE")
 S RATE=$G(FIEVAL(FINDING,"VALUE"))
 S TEMP=$$EDATE^PXRMDATE(DATE)
 S TEMP=TEMP_" Measurement: "
 S MTYPE=$P(FIEVAL(FINDING,"FINDING"),";",1)
 S MNAME=$$GET1^DIQ(120.51,MTYPE,.01,"","","","ERR")
 S TEMP=TEMP_MNAME
 I $L(RATE)>0 D
 . S TEMP=TEMP_"; rate - "
 . S TEMP=TEMP_RATE
 ;Check for abnormal measurement.
 S TEMP=TEMP_$P(DATA,U,12)
 ;If the finding has expired add "EXPIRED"
 I $D(FIEVAL(FINDING,"EXPIRED")) S TEMP=TEMP_" - EXPIRED"
 ;If the finding is false because of the value add the reason.
 I $G(FIEVAL(FINDING,"CONDITION"))=0 S TEMP=TEMP_$$ACTFT^PXRMOPT
 S NLINES=NLINES+1
 S TEXT(NLINES)=TEMP
 I $D(PXRMDEV) D
 . N UID
 . S UID="MEAS "_MNAME
 . S ^TMP(PXRMPID,$J,PXRMITEM,UID)=TEMP
 Q
 ;
