BPXRMEA ; IHS/CIA/MGH - Handle measurement findings. ;23-Jan-2006 10:15;MGH
 ;;1.5;CLINICAL REMINDERS;**1001,1003,1004**;Jun 19, 2000
 ;COPY OF PXRMMEAS using IHS V Measurement file instead of VA Vitals app
 ;
 ;=======================================================================
EVALFI(DFN,FIEVAL) ;EP Evaluate vitals/measurement findings.
 ;Use the most recent measurement.
 N FIND0,FIND3,FINDING,MTYPE,INVDATE
 S MTYPE=""
 F  S MTYPE=$O(^PXD(811.9,PXRMITEM,20,"E","AUTTMSR(",MTYPE)) Q:+MTYPE=0  D
 . S INVDATE=$O(^AUPNVMSR("AA",DFN,MTYPE,""))
 . S FINDING=""
 . F  S FINDING=$O(^PXD(811.9,PXRMITEM,20,"E","AUTTMSR(",MTYPE,FINDING)) Q:+FINDING=0  D
 .. S FIND0=^PXD(811.9,PXRMITEM,20,FINDING,0)
 .. S FIND3=$G(^PXD(811.9,PXRMITEM,20,FINDING,3))
 .. D FIEVAL(DFN,MTYPE,INVDATE,FIND0,FIND3,"","",FINDING,.FIEVAL)
 Q
 ;
 ;=======================================================================
EVALTERM(DFN,FINDING,TERMIEN,TFIEVAL) ;EP Evaluate vitals/measurement terms.
 ;Use the most recent measurement.
 N FIND0,FIND3,MTYPE,TFIND0,TFIND3,TFINDING,INVDATE
 S FIND0=^PXD(811.9,PXRMITEM,20,FINDING,0)
 S FIND3=$G(^PXD(811.9,PXRMITEM,20,FINDING,3))
 S MTYPE=""
 F  S MTYPE=$O(^PXRMD(811.5,TERMIEN,20,"E","AUTTMSR(",MTYPE)) Q:+MTYPE=0  D
 . S INVDATE=$O(^AUPNVMSR("AA",DFN,MTYPE,""))
 . S TFINDING=""
 . F  S TFINDING=$O(^PXRMD(811.5,TERMIEN,20,"E","AUTTMSR(",MTYPE,TFINDING)) Q:+TFINDING=0  D
 .. S TFIND0=^PXRMD(811.5,TERMIEN,20,TFINDING,0)
 .. S TFIND3=$G(^PXRMD(811.5,TERMIEN,20,TFINDING,3))
 .. D FIEVAL(DFN,MTYPE,INVDATE,FIND0,FIND3,TFIND0,TFIND3,TFINDING,.TFIEVAL)
 Q
 ;
 ;=======================================================================
FIEVAL(DFN,MTYPE,INVDATE,FIND0,FIND3,TFIND0,TFIND3,FINDING,FIEVAL) ;
 ;Use the most recent measurement.
 N VALID,CONVAL,TEMP,RSLT,VIEN,DATE,ERR,GMRVSTR,IC,IEN
 I INVDATE="" S FIEVAL(FINDING)=0 Q
 S IEN=$O(^AUPNVMSR("AA",DFN,MTYPE,INVDATE,""))
 Q:IEN=""
 S TEMP=$G(^AUPNVMSR(IEN,0))
 S RSLT=$P(TEMP,U,4)
 S VIEN=$P(TEMP,U,3)
 S DATE=$P($G(^AUPNVMSR(IEN,12)),U,1)    ;Get date entered
 I DATE="" S DATE=$$VDATE^PXRMDATE(VIEN) ;else get visit date
 ;Save the rest of the finding information.
 S FIEVAL(FINDING)=1
 S FIEVAL(FINDING,"DATE")=DATE
 S FIEVAL(FINDING,"FINDING")=MTYPE_";AUTTMSR(,"
 S FIEVAL(FINDING,"SOURCE")=IEN_";AUTTVMSR(,"
 S FIEVAL(FINDING,"RATE")=RSLT
 S FIEVAL(FINDING,"VALUE")=RSLT
 S FIEVAL(FINDING,"VIEN")=VIEN
 ;If this is being called as part of a term evaluation we are done.
 I TFIND0'="" Q
 ;Determine if the finding has expired.
 S VALID=$$VALID^PXRMDATE(FIND0,TFIND0,DATE)
 I 'VALID D  Q
 . S FIEVAL(FINDING)=0
 . S FIEVAL(FINDING,"EXPIRED")=""
 ;If there is a condition for this finding evaluate it.
 S CONVAL=$$COND^PXRMUTIL(FIND3,TFIND3,RSLT)
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
 S DATE=FIEVAL(FINDING,"DATE")
 S RATE=$G(FIEVAL(FINDING,"VALUE"))
 S TEMP=$$EDATE^PXRMDATE(DATE)
 S TEMP=TEMP_" Measurement: "
 S MTYPE=$P(FIEVAL(FINDING,"FINDING"),";",1)
 S MNAME=$$GET1^DIQ(9999999.07,MTYPE,.01,"","","","ERR")
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
